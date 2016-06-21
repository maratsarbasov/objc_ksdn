//
//  main.cpp
//  kschecker
//
//  Created by MS on 6/20/16.
//  Copyright © 2016 Sarbasov inc. All rights reserved.
//

#include <iostream>
#include <vector>

#define BOOST_FILESYSTEM_VERSION 3
#define BOOST_FILESYSTEM_NO_DEPRECATED
#include <boost/filesystem.hpp>

#include "KeystrokeCaptureData.hpp"
#include "FeatureExtractor.hpp"
#include "Fingerprint.hpp"

namespace fs = ::boost::filesystem;
int f(int a) {
    return 0;
}

// return the filenames of all files that have the specified extension
// in the specified directory and all subdirectories
void get_all(const fs::path& root, const std::string& ext, std::vector<fs::path>& ret)
{
    if(!fs::exists(root) || !fs::is_directory(root)) return;
    
    fs::recursive_directory_iterator it(root);
    fs::recursive_directory_iterator endit;
    
    while(it != endit)
    {
        if(fs::is_regular_file(*it) && it->path().extension() == ext) ret.push_back(it->path());
        ++it;
        
    }
}

std::string get_author(fs::path p)
{
    std::size_t underline = p.filename().string().find("_");
    std::string author = p.filename().string().substr(0, underline);
    return author;
}

int main(int argc, const char * argv[])
{
    // insert code here...
    std::vector<fs::path> paths;
    get_all(fs::path{"/Users/macuser/Projects/ks_data/"}, ".ksdata", paths);
    std::vector<std::string> authors;
    for (fs::path& p : paths) {
        if (std::find(authors.begin(), authors.end(), get_author(p)) != authors.end()) {
            continue;
        }
        authors.push_back(get_author(p));
        std::ifstream is(p.string());
        KeystrokeCaptureData kscd = KeystrokeCaptureData(is);
        FeatureExtractor fe = FeatureExtractor();
        kscd.feed(fe);
        auto features = fe.extract_features();
        Fingerprint fingerprint(features);
        
        double gen_can = 0.0;
        double gen_man = 0.0;
        double gen_euc = 0.0;

        double sum_can = 0.0;
        double sum_man = 0.0;
        double sum_euc = 0.0;
        
        int gen_count = 0;
        int imp_count = 0;
        for (fs::path& p2 : paths) {
            if (p == p2) {
                continue;
            }
            
            std::ifstream is2(p2.string());
            KeystrokeCaptureData kscd2(is2);
            FeatureExtractor fe2;
            kscd2.feed(fe2);
            auto features2 = fe2.extract_features();
            Fingerprint fingerprint2(features2);
            

            if (get_author(p) == get_author(p2)) {
                gen_can += fingerprint.canberra_distance(fingerprint2);
                std::cout << "gen " << fingerprint.canberra_distance(fingerprint2) << std::endl;
                gen_euc += fingerprint.euclid_distance(fingerprint2);
                gen_man += fingerprint.manhattan_distance(fingerprint2);
                gen_count++;
            }
            else {
                sum_can += fingerprint.canberra_distance(fingerprint2);
                sum_euc += fingerprint.euclid_distance(fingerprint2);
                sum_man += fingerprint.manhattan_distance(fingerprint2);
                imp_count++;
            }
                
        }

        std:: cout << "Geniune: " << std::endl;
        std::cout << gen_can/gen_count << " " << gen_man/gen_count << " " << gen_euc/gen_count << std::endl;
        std:: cout << "Impostor: " << std::endl;
        std::cout << sum_can/imp_count << " " << sum_man/imp_count << " " << sum_euc/imp_count << std::endl;
        std::cout << std::endl;
       
    }
    return 0;
}
