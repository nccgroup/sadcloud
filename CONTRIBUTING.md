## How to contribute to sadcloud

*based off the [rails contribution guidelines](https://github.com/rails/rails/blob/master/CONTRIBUTING.md)*

#### **Did you find a bug?**

* **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/nccgroup/sadcloud/issues).

* If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/nccgroup/sadcloud/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible.

#### **Did you write a patch that fixes a bug?**

* Open a new GitHub pull request with the patch.

* Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.

#### **Did you fix whitespace, format code, or make a purely cosmetic patch?**

* Thank you! We're sorry if our code hurt your eyes! We reserve the right to ignore such a PR if we have a different opinion on cosmetics ...

#### **Do you have questions about sadcloud?**

* Feel free to email the maintainers: rami.mccarthy@nccgroup.com & joshua.dow@nccgroup.com

#### **Do you want to contribute a new misconfiguration?**

1. Thank you!
2. Some notes on where to start:
- Each AWS service has its own module
- Each misconfiguration maps to a variable in the module's `variables.tf`
- If a given misconfiguration requires the creation of any resources, ensure that they are not created unless necessary (`count`/`for_each`)
- Each misconfiguration variable is set in the root `main.tf`, make sure to include conditional checks on `all_{service}_findings` and `all_findings`


Thanks!

Made with :heart:  
Rami McCarthy & Josh Dow
