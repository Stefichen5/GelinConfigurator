# gelin_configurator

Goal of this project is to aid GELin users with creating and configuring their projects. I wrote this tool in my spare time.

I am not a UI/UX designer and thus the interface might look a little bit rough and not as aesthetically pleasing or intuitive as would be ideal.

Feel free to use it if you wish. However, I do not guarantee that it will work, do what you want or does not destroy your computer. Use at your own risk.

## Supported features

- Create new projects
  - Set name and path
  - Choose GELin version to base the project on
  - Choose a project template 
- Modify existing projects
  - Change name, version number and project description
  - Change used GELin version (automatically scans for installed GELin on your computer in /opt/)
  - Add/Remove packages
  - Add/Remove subprojects
  - Add/Remove files
- Save changes

More is WIP

## Known bugs

- not feature complete
- code is not ideal
- checking for gelin project validity not 100% accurate
- can overwrite comments in files if they have the same structure like real arguments (e.g. #KERNEL_IMAGE="")