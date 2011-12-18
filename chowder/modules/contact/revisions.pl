
package contact::revisions;

# ----------------------------------------------------------------------------
# Revision 1
# ----------------------------------------------------------------------------

$revision[1]{'up'}{'shared'} = sub {

    # Register the module
    module::register('contact');

    # Add permissions
    #user::add_permission('contact_submit');
};

$revision[1]{'up'}{'site'} = sub {

    # Enable the module
    module::enable('contact');

};

1;
