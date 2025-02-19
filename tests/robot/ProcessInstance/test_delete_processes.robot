*** Settings ***
Library    CamundaLibrary
Suite Setup    Set Camunda Configuration    ${configuration}

*** Variables ***
${CAMUNDA_HOST}    http://localhost:8080
${PROCESS_NAME}    demo_for_robot


*** Test Cases ***
Get all instances
    # Given
    Upload process
    ${process_instances_before}    get all active process instances    ${PROCESS_NAME}
    start process    ${PROCESS_NAME}
    ${process_instances_after}    get all active process instances    ${PROCESS_NAME}

    # EXPECT
    should be 1 more process    ${process_instances_before}    ${process_instances_after}

    # WHEN
    FOR    ${process_instance}    IN    @{process_instances_after}
        delete process instance    ${process_instance}[id]
    END

*** Keywords ***
Upload process
    deploy    ${CURDIR}/../../bpmn/demo_for_robot.bpmn

should be 1 more process
    [Arguments]    ${before}    ${after}
    ${count_before}    Evaluate    len($before)+1
    ${count_after}    Evaluate    len($after)
    Should be equal as integers    ${count_before}    ${count_after}