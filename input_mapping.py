from base.models import Resource
import os

def map_inputs(user, all_data, data_name, id_list):
    '''
    `user` is a User instance (or subclass).  This gives us
    the option of applying user-specific logic to the mapping.
    Since the code that calls this function does NOT know
    the structure of the input data, it cannot impose any logic
    such as filtering Resource objects for a particular user.
    Therefore we have to keep that information here

    `unmapped_data` is some data structure sent by
    the frontend.  The structure is known to the 
    developer since they specified the input element responsible
    for creating the data.  For example, a file chooser will send
    a list/array of primary keys.

    `id_list` is a list of WDL input "names"/ids that we are mapping
    to.  Note that the ordering is important.  Make sure the logic below
    matches the order in gui.json 

    '''
    unmapped_data = all_data[data_name]

    bam_list = []
    for pk in unmapped_data:
        r = Resource.objects.get(pk=pk)
        if (r.owner == user) or (user.is_staff):
            bam_list.append(r.path)
        else:
            raise Exception('The user %s is not the owner of Resource with primary key %s.' % (user, pk))

    return {id_list[0]:bam_list}
