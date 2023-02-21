Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4369DE9E
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 12:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbjBULTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 06:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjBULTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 06:19:40 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1B11C5A9
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 03:19:39 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L8jo3e016685;
        Tue, 21 Feb 2023 11:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=m4wgBVmRO/BWFQXLIwhnLb+aOv4Oo5x4WOVcISoHy0g=;
 b=NsQb8qbZ1XpNby36p6X3xSNaP/yHojiQAFetPCJx3BCU3Kqlw8lbKwCdiKclxcXhQLVP
 q5/E0sZh5/1ZrlVdesN3qAu/IWqgZafiMJw4nw4DpJERyxzA0oPMQ9qcHkBBzIj2Nblw
 NVYrkWvvGtArBxWmpHBbedBQwFXaH0ZQElZDjAIOO1z3s2Y81mJJ5GlOV7wZ4tf8FVAE
 FFekC5IdcY0QGotakFHlfkg2nvZtKfP1Kn3VZ7pRpB4ZcaOIug5QF/kYACenlXt3rmKJ
 uZttmQfAXkjUIoXUqcEplVx5d9hrnDRAgumZorZUbRjgOCNl569CtiseVKHqQwpoQ2qN Dw== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nvnbt91ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 11:19:37 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31LBJbbq020052
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 11:19:37 GMT
Received: from [10.213.73.166] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 21 Feb
 2023 03:19:36 -0800
Message-ID: <b721f192-32da-a532-84c2-6f768ac2a7ee@quicinc.com>
Date:   Tue, 21 Feb 2023 16:49:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH V1] rcu-tasks: Fix build error
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
References: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
 <Y/PByBdfz/WPBs2W@kroah.com>
 <72e8a2a5-8729-5551-563a-d8d7c143f527@quicinc.com>
 <Y/Sez06gvJbAv7VE@kroah.com>
From:   Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
In-Reply-To: <Y/Sez06gvJbAv7VE@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: oHQKe4BfTizcveQv6-zyfxSWN3RYpbmn
X-Proofpoint-ORIG-GUID: oHQKe4BfTizcveQv6-zyfxSWN3RYpbmn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_06,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=955 bulkscore=0 malwarescore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210097
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/21/2023 4:07 PM, Greg KH wrote:
> On Tue, Feb 21, 2023 at 02:57:15PM +0530, Srinivasarao Pathipati wrote:
>> On 2/21/2023 12:24 AM, Greg KH wrote:
>>> On Mon, Feb 20, 2023 at 11:43:59PM +0530, Srinivasarao Pathipati wrote:
>>>> Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
>>>> fix below compilation error.
>>>> This is applicable to only 5.10 kernels as code got modified
>>>> in latest kernels.
>>>>
>>>>    In file included from kernel/rcu/update.c:579:0:
>>>>    kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
>>>>     static void show_rcu_tasks_rude_gp_kthread(void) {}
>>>>
>>>> Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
>>>> ---
>>>>    kernel/rcu/tasks.h | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
>>>> index 8b51e6a..53ddb4e 100644
>>>> --- a/kernel/rcu/tasks.h
>>>> +++ b/kernel/rcu/tasks.h
>>>> @@ -707,7 +707,7 @@ static void show_rcu_tasks_rude_gp_kthread(void)
>>>>    #endif /* #ifndef CONFIG_TINY_RCU */
>>>>    #else /* #ifdef CONFIG_TASKS_RUDE_RCU */
>>>> -static void show_rcu_tasks_rude_gp_kthread(void) {}
>>>> +static inline void show_rcu_tasks_rude_gp_kthread(void) {}
>>>>    #endif /* #else #ifdef CONFIG_TASKS_RUDE_RCU */
>>>>    ////////////////////////////////////////////////////////////////////////
>>>> -- 
>>>> 2.7.4
>>>>
>>> What commit id caused this problem?
>> commit  (8344496e8b49c4122c1808d6cd3f8dc71bccb595 rcu-tasks: Conditionally
>> compile show_rcu_tasks_gp_kthreads()) introduced this issue
> So this has been around for a very very long time.
>
> Why is this suddenly an issue now, almost 3 years later?  What changed
> to cause this to become an issue?
>
> And please put this information in the changelog text.

  We observed this issue on Android kernels with arch=UM  after picking 
this patch (3fe617ccafd6f5bb33c2391d6f4eeb41c1fd0151 Enable '-Werror' by 
default for all kernel builds ) recently into Android kernels.

Earlier it was just warning and this issue depends on specific 
configuration, so it might got missed.

>
>> This patch added conditional macros for definition of
>> show_rcu_tasks_rude_gp_kthread()  but not for dummy definition.
>>
>>> And why isn't it an issue in newer kernels, what commit id fixed it and
>>> why can't we just take that instead?
>> Later code got modified with patch (27c0f1448389 rcutorture: Make
>> grace-period kthread report match RCU flavor being tested)  , with this
>> there won't be compilation issue.
>>
>> This patch is part of below series, Not sure all these can be picked to this
>> 5.10 stable branch so fixed issue by simply making function inline.
>>
>> if you think it is better to pick this series, please merge to 5.10 branch.
>>
>> https://lore.kernel.org/lkml/20201105233900.GA20676@paulmck-ThinkPad-P72/
>>
>> [1/4] e1eb075ccf37 rcutorture: Make preemptible TRACE02 enable lockdep
>> [2/4] 77dc174103fd rcu-tasks: Convert rcu_tasks_wait_gp() for-loop to
>> while-loop
>> [3/4] 27c0f1448389 rcutorture: Make grace-period kthread report match RCU
>> flavor being tested
>> [4/4] 75dc2da5ecd6 rcu-tasks: Make the units of ->init_fract be jiffies
> I would need you to test and verify that these actually work properly
> and do not cause any regressions and sign off on them before I could
> take them.
  probably it would be better to pick this no risk patch instead of 
picking above series as this is stable branch.
>
> thanks,
>
> greg k-h
