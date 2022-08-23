Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0883959ED78
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiHWUjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHWUiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:38:46 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA3E2AD0;
        Tue, 23 Aug 2022 13:25:35 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NHwRP5025709;
        Tue, 23 Aug 2022 13:25:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=PPS06212021;
 bh=P3mDgRDexLITJ7CSJblWNGoet8kAM2dvzUxWfDUDR3s=;
 b=irzYEvzDk0f9viLSTITLsm2F4AU65s4fXxO7pwvX+GvyUwg7nMf5TI3LtDGBDMm1WnUX
 57mYPZCz6LyjW0dEaA6ak15A/PSsV6vW0rwTJboHGrQyPXZXUWnOseffPcZJA7AQxSjm
 rXeFC8k7kenzdZsMQfmgNO37BaAn4Oyjc1pereYrqxJAFQ2GslO7kDxNNIqFgJsolgQG
 3Gzlxwu/ARwnNB01vLG4oCksqzCIyQGGt7LbkLLwAlE6yaNb2Mj6jnrZ7D3XzsQge+t1
 Nu8sznRh2fIfsy2sbSEx76qjg2LnlqxEeDOOqpMmueW4gkiJOCdmX3gBb99K6E7PqDMh 0w== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j53rvg3h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Aug 2022 13:25:32 -0700
Received: from [128.224.79.53] (128.224.79.53) by ala-exchng01.corp.ad.wrs.com
 (147.11.82.252) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Tue, 23 Aug
 2022 13:25:24 -0700
Message-ID: <94756777-b5b4-4db1-fe52-2386609f8a86@windriver.com>
Date:   Tue, 23 Aug 2022 23:25:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: bpf selftest failed in 5.4.210 kernel
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        RAJESH DASARI <raajeshdasari@gmail.com>
CC:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexei.starovoitov@gmail.com>,
        <john.fastabend@gmail.com>
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com> <Yv3wZLuPEL9B/h83@myrica>
 <Yv9shQ3i49efHG6f@kroah.com>
 <CAPXMrf8VsNMKNLxFjdytk57mk_9ZC0avg1qCGLSMOZNirpdboQ@mail.gmail.com>
 <YwCGoRt6ifOC6mCD@kroah.com>
 <CAPXMrf-Gc-Mv1goZrk59GG96OLPxEUC-FKT6Dwo6TU6D7po=gw@mail.gmail.com>
 <YwR76AVTOsdXNpxh@kroah.com>
 <CAPXMrf-XUHnfQtnCMs6pbpM+2LUBLqE2c1Z-UwsM-mU1KdoOUA@mail.gmail.com>
 <YwUdyiK16jz1W5Aa@myrica>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <YwUdyiK16jz1W5Aa@myrica>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.79.53]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Proofpoint-GUID: 8pLVtc1wQjDz12APBVlXnSsyJkJMbby9
X-Proofpoint-ORIG-GUID: 8pLVtc1wQjDz12APBVlXnSsyJkJMbby9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230077
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jean-Philippe,

On 8/23/22 21:34, Jean-Philippe Brucker wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Tue, Aug 23, 2022 at 10:31:40AM +0300, RAJESH DASARI wrote:
>> Sorry for the confusion, results are indeed confusing to me .
>> If I try with git bisect I get
>>
>> git bisect bad
>> 9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit
> For me bisecting points to:
>
> (A)     7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
>
> This changes the BPF verifier output and (as expected) breaks the
> test_align selftest. That's why in the same series [1] another patch fixed
> test_align. In v5.4.y, that patch is:
>
> (B)     6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
>
> Unfortunately commit (B) addresses multiple verifier changes, not solely
> (A). My guess is those changes were in series [1] and haven't been
> backported to v5.4. So multiple solutions:
>
> * Partially revert (B), only keeping the changes needed by (A)
> * Revert (A) and (B)
> * Add the missing commits that (B) also addresses
>
> I don't know which, I suppose it depends on the intent behind backporting
> (A). Ovidiu?
The intent behind backporting 7c1134c7da99 ("bpf: Verifer, 
adjust_scalar_min_max_vals to always call update_reg_bounds()") was to 
fix CVE-2021-4159.

If we revert test 11 changes brought in by 6a9b3f0f3bad ("selftests/bpf: 
Fix test_align verifier log patterns") backport, all test_align 
testcases pass on my side:

diff --git a/tools/testing/selftests/bpf/test_align.c 
b/tools/testing/selftests/bpf/test_align.c
index c9c9bdce9d6d..4726e3eca9b2 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -580,18 +580,18 @@ static struct bpf_align_test tests[] = {
                         /* Adding 14 makes R6 be (4n+2) */
                         {11, 
"R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
                         /* Subtracting from packet pointer overflows 
ubounds */
-                       {13, 
"R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 
0x7c)"},
+                       {13, 
"R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 
0x7c))"},
                         /* New unknown value in R7 is (4n), >= 76 */
                         {15, 
"R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
                         /* Adding it to packet pointer gives nice 
bounds again */
-                       {16, 
"R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 
0xfffffffc)"},
+                       {16, 
"R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 
0x7fc))"},
                         /* At the time the word size load is performed 
from R5,
                          * its total fixed offset is NET_IP_ALIGN + 
reg->off (0)
                          * which is 2.  Then the variable offset is 
(4n+2), so
                          * the total offset is 4-byte aligned and meets 
the
                          * load's requirements.
                          */
-                       {20, 
"R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 
0xfffffffc)"},
+                       {20, 
"R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 
0x7fc))"},
                 },
         },
  };

root@intel-x86-64:~/bpf# ./test_align
Test   0: mov ... PASS
Test   1: shift ... PASS
Test   2: addsub ... PASS
Test   3: mul ... PASS
Test   4: unknown shift ... PASS
Test   5: unknown mul ... PASS
Test   6: packet const offset ... PASS
Test   7: packet variable offset ... PASS
Test   8: packet variable offset 2 ... PASS
Test   9: dubious pointer arithmetic ... PASS
Test  10: variable subtraction ... PASS
Test  11: pointer variable subtraction ... PASS
Results: 12 pass 0 fail
> In any case 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic"
> test") can be reverted, I can send that once we figure out the rest.

In my testing, with [1] and [2] applied, but without [3], the following 
test_align selftest would still fail:

Test   9: dubious pointer arithmetic ... Failed to find match 9: 
R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 
0x7fffffff7ffffffc)


[1] 7c1134c7da99 ("bpf: Verifer, adjust_scalar_min_max_vals to always 
call update_reg_bounds()")
[2] 6a9b3f0f3bad ("selftests/bpf: Fix test_align verifier log patterns")
[3] 6098562ed9df ("selftests/bpf: Fix "dubious pointer arithmetic" test")

Ovidiu

> Thanks,
> Jean
>
> [1] https://lore.kernel.org/bpf/158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower/
>
>> If I  try to test myself with multiple test scenarios(I have mentioned
>> in  the previous mails) for the bad commits , I see that bad commits
>> are
>> bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
>> selftests/bpf: Fix test_align verifier log patterns
>> selftests/bpf: Fix "dubious pointer arithmetic" test
>>
>> Thanks,
>> Rajesh Dasari.
>>
>> On Tue, Aug 23, 2022 at 10:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Mon, Aug 22, 2022 at 10:23:02PM +0300, RAJESH DASARI wrote:
>>>> Hi,
>>>>
>>>> Please find the test scenarios which I have tried.
>>>>
>>>> Test 1:
>>>>
>>>> Running system Kernel version (tag/commit) :  v5.4.210
>>>> Kernel source code checkout : v5.4.210
>>>> test_align test case execution status : Failure
>>>>
>>>> Test 2:
>>>>
>>>> Running system Kernel version (tag/commit) : v5.4.210
>>>> Kernel source code checkout : v5.4.209
>>>> test_align test case execution status : Failure
>>>>
>>>> Test 3:
>>>>
>>>> Running system Kernel version (tag/commit) : v5.4.209
>>>> Kernel source code checkout : v5.4.209
>>>> test_align test case execution status : Success
>>>>
>>>> Test 4:
>>>>
>>>> Running system Kernel version (tag/commit) : ACPI: APEI: Better fix to
>>>> avoid spamming the console with old error logs ( Kernel compiled at
>>>> this commit  and system is booted with this change)
>>>> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
>>>> test_align verifier log patterns and selftests/bpf: Fix "dubious
>>>> pointer arithmetic" test. If I revert only the Fix "dubious pointer
>>>> arithmetic" test, the testcase still fails.
>>>> test_align test case execution status : Success
>>>>
>>>> Test 5:
>>>>
>>>> Running system Kernel version (tag/commit) :  v5.4.210 but reverted
>>>> commit (bpf: Verifer, adjust_scalar_min_max_vals to always call
>>>> update_reg_bounds() )
>>>> Kernel source code checkout : v5.4.210 but reverted selftests/bpf: Fix
>>>> test_align verifier log patterns and selftests/bpf: Fix "dubious
>>>> pointer arithmetic" test.
>>>> test_align test case execution status : Success
>>>>
>>>> Test 6 :
>>>>
>>>> Running system Kernel version (tag/commit) : bpf: Test_verifier, #70
>>>> error message updates for 32-bit right shift( Kernel compiled at this
>>>> commit  and system is booted with this change)
>>>> Kernel source code checkout : v5.4.209 or v5.4.210
>>>> test_align test case execution status : Failure
>>> I'm sorry, but I don't know what to do with this report at all.
>>>
>>> Is there some failure somewhere?  If you use 'git bisect' do you find
>>> the offending commit?
>>>
>>> confused,
>>>
>>> greg k-h
