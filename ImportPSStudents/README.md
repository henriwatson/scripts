# ImportPSStudents
Tiny PowerShell script to synchronise PowerSchool students with Active Directory.  
Originally based off of Lee Holmes' [Import-AdUser](http://poshcode.org/2171),
updated to use the Active Directory cmdlets instead of adsi and to handle
updating existing students.

## Setup
1. Modify the domain-specific configuration at the start of `ImportPSStudents.ps1`.
2. Import `AD_Export.pst` into PowerSchool for use as a Student Export Template.
3. Select the students you'd like to export in PowerSchool.
4. Use Special Functions to export the selected students using the `AD Export` template.
5. Execute `ImportPSStudents.ps1`, passing the exported file as a parameter.  
   `PS> .\ImportPSStudents.ps1 .\student.export.text`

## Details
| AD Attribute        | PS Attribute            |
| --------------------|-------------------------|
| Name                | First_Name + Last_Name  |
| SamAccountName      | Student_Web_ID          |
| UserPrincipalName   | Student_Web_ID          |
| AccountPassword     | Student_Web_Password    |
| GivenName           | First_Name              |
| Surname             | Last_Name               |
| DisplayName         | First_Name + Last_Name  |
| Title               | Grade_Level             |
| Department          | Home_Room               |

## License
    Copyright (c) 2015 Henri Watson

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
