#include <QString>
#include "revision.h"
const QString bespin_revision()
{
#define STR(str) #str
#define STRING(str) STR(str)
    return STRING(SVN_REVISION);
}
