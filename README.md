# Resume_Analyzer


# Project Goal
Create a module in R with a Shiny interface that accepts a resume, scores it against job descriptions scraped from indeed.com, provides top industries and occupations that match that resume.


# Project Description
The project is about developing a module with a Shiny interface to help clients find a career that fits their resume. Leveraging the knowledge from the MASY program at NYU SPS, which involved creating an entirely new module that met the same specification requirements and ensured that it would eventually function properly for the client. The final deliverable of the project must meet the client’s requirements, including ease of use as a job hunting tool and use for research. Also, the final delivery date requires the module’s installation guide and user manual.


# Use Case
This application will provide users with job posting options that closely match their skills. NYU CAES and MASY can use this app to help students find the best job match. Not only does this application help students self-assess their resumes, it can also be an aid to Career Center. Career coaches can find out what's missing from a student's resume and how to improve it.

Users can visit the webpage to upload their resume as a source firstly. 
The resume should be a txt file. If users want to discover the most suitable recommended occupation according to personal situations, they should also upload the occupation description CSV file as the target file. Then users can click Compute button, and the tool will automatically score the resume match. Users should patiently wait for few seconds, and the result will display on their screen. 
Based on the results, users can compare the similarity scores to choose the most suitable occupation. Then crawl the selected occupation on the Indeed.com website to get the most suitable job. If users want to save the result, they can click the "Download" button to download it.
Finally, users can also search for keyword frequency for resume and job descriptions to help users find suitable occupation.


This system has six main functions:
1.	Upload resume txt file by users.
2.	Click the "Submit" button, the result will show in “Matched Occupation” interface.
3.	Users can select up to 5 occupations based on the top 20 occupations listed with the best match.
4.	Click the "Submit" button, the result will show in “Scrape Indeed” interface.
5.	Click the "Download" button to download a copy of the job list.
6.	In “Text Frequency” interface, users can observe keyword frequency for resume and job descriptions.




