# You may need to install and restart the package for this to work. Load_all
# will not pick up the most recent changes, and so testing can fail if the installed
# version of crunch differs from your working version. 
# In particular if your tests pass locally, but fail on check or Travis, then
# likely you need to install and restart.
library(crunchy)
source(system.file("crunch-test.R", package = "crunch"))

with_mock_crunch({
    getEnvOf <- function(what, which=rev(sys.parents())) {
        for (frame in which)
            if (exists(what, frame=frame, inherits=FALSE))
                return(sys.frame(frame))
        return(NULL)
    }
    ds <- crunch::loadDataset("test ds")
    crunchy:::.makeArrayGadget(env = getEnvOf("ds"))
})
