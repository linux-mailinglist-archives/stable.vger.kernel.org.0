Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53405EBCCE
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiI0IKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiI0IKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:10:09 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63521B6031;
        Tue, 27 Sep 2022 01:03:56 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28R7oOlQ020757;
        Tue, 27 Sep 2022 01:03:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=M35wjq6nbgoPzLgIStu4uITqs5QL8yBFr3p3rGLt8EI=;
 b=l7wuEgDC/YEEtAPk/ZHFSW33QJ+IYX4yjqnQbGVUJ9g5uvW7ZFx1CdBmg833E3gQr3VS
 loBeNNr42/KLxNnXZazUSzGujLJ6lvUFHWsVG9UuR4N2rWE3LrEr4+15v2K0wdBagtus
 2QK143sOExLxkgxBlvdr0lAYHckydZBsuqAkje3chdyR3SwmMMNwHFJX674Uzuyw2E0h
 YcXFD+eSc/JYUeV3zFLnOJ01QqMVgcvDPm02ADdENEmYC/7NNOWZhj8KPRA0JAHze7pJ
 i58FDHD3u7F3wt7Zt3wpEedKRJO3rrjo40sqHDsvpxm7SPrrziewCHRHBF4k5b7gnK23 ng== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jt1dka17k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 01:03:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuWlcBaqPUuHPJKhfWFYSyyf9Z2wl5lWlGX+Xtncrc4Bjtm/+agzlNJjAwfG8rb1B8UFccycZBuUJ4+KGLm1cs4SfuMlakBjYBXelqRyM/1svFEt4PN2qDwfmeTjn5GOdWcpDmtipUUXpHs6ZNBIxMjWwDtWNRRTNznMo8/LXgNIMdPvbPzYKZSCnYZ7P0IOaEVYSmDmKhxXWKEKJMyybYZJi7HoN4kWLIJe+6VznlOPNDkdplIA8w8pLnlwJmE0nrbo7P75X42OcV0DNeVoIrZkq6vbPguhsPMQ36vbFxXwiqCO7Gd5s2ROtj/8k3RYsXs9a7+q7eJN1cD3SpiF3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M35wjq6nbgoPzLgIStu4uITqs5QL8yBFr3p3rGLt8EI=;
 b=hvk2LXBU2rKUo1CwzOZ9gTwVskZ8PmrQu9OJjmpdX/W+RKhLB9nuE0YZBk1zpJRGS8LzAxPetzcVtYm+4HW7d6MvTHFEYkpNNTvhxUJHVJL3dO7/0JDP4ZSSB0jPXbgTewB6F4mRx0h1mEsoV/Jzq+KSXu+qhB15pwbVfW7hNJ3LlEEZHHJN544B5q4n9G5l/v5YfddhZbt8phX1mISuWmNycm/tq9F9jA5oGUnL487bzMde6kOIyCGjVNO4hKtFtyj9RLFMb5q065MiBrQ8cHiC2qloPfYHTMENufzrglMEx/+4AZDwVl7+7a8T3vw+eYxFpvhydSeHM5EL3wiiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MW3PR11MB4651.namprd11.prod.outlook.com (2603:10b6:303:2c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 08:03:37 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9df7:43d1:af9d:4d3f]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::9df7:43d1:af9d:4d3f%6]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 08:03:37 +0000
Message-ID: <876a7707-c9b9-0985-af00-c7fc461ada02@windriver.com>
Date:   Tue, 27 Sep 2022 11:03:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, liam.merwick@oracle.com,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Ashish.Kalra@amd.com
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
In-Reply-To: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR08CA0147.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::25) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MW3PR11MB4651:EE_
X-MS-Office365-Filtering-Correlation-Id: 500bdb74-083d-4918-4e6a-08daa05ec809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCeEopSb/ubU8sFFKcqOUC5+g45laaO1hwQpc/b8jSVlAc5imYKPOKL1B/NBAcQOF2sdNUN2bjmk2hH5biODRIRn7wBPxhJS598n44irQZDBLJ/UK0hJjuntyb+bw7vuFIDY0voXMF4v2TscCKeyxufmVFisU1kpjhELmlaKrSs6Qcm/Ibidms9bXMrKoadbU34QwbX2fQF2C4cDaQA5NHpoSQuoHUIVmWwQAEv9yUyGhnI0x5SDZQu7UV2Vl6eksvvZQs8xLpTdnztIEMQx19rC3lbygcmhKtXIO2UomXdo4Y8R6TZZVWLdBc/ncBnZgc70CZfnArgeXPLe/pnbUr5v+AABeqNLONvm5oTNCWAeqYyetdG9RONOlvAUrp8mLrtbiAJn6uMfxdIgy6EbjT6rmt/+XCKty1dJ+yBAvXcNCPV+FDRSTL0EulRrTslTd7HicvNb5beIzHj080jhOPIi7Z20b+trjhVGGH0DDKx8fkEXQx/Zxl2DG2ugUsVC+PtItX4jWXvug5IB08GprSJZTTgmnm3kyNjZedcBKcAP/jH8QATyj6YyTHNRMnKl46utuXciW6U6/Nd6XkiLBZz/uwtOkP6czhjpl/NWGt7ZznfFpgf1ugMXCwzK04itRhMDcUbjcGWg7o7sbpxyC6KKNw7QAUiNUuKLk7YVbFqsRYwa0D8ttJ9RaxTF/opGwdSBeQh3eSaF3lRkUEHBDMn8IAGzP7SwNV8hUu89LGf/QyDA6f3B76XNA6LlXxNniqlW1ZKwuVE3O6vGx5o/hyDdgxuecmvlypZXR2m29uPk5VHBxzaAeNZ/bI/Qnfd5VxP3KQAMSjGzxHplpqYxuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39850400004)(346002)(136003)(366004)(451199015)(5660300002)(6512007)(36756003)(41300700001)(44832011)(53546011)(6666004)(2616005)(8936002)(2906002)(66946007)(66476007)(66556008)(4326008)(6506007)(8676002)(38100700002)(31696002)(86362001)(186003)(6916009)(54906003)(316002)(83380400001)(31686004)(478600001)(6486002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUd5Y1U5eVc5TENGS3JZL3JFK0diVFFkQWZPRThtU0FRSm1GQjNwc1Q5QVlO?=
 =?utf-8?B?R0RFd3orWTQzaEdON2RUMFU5RXRBbHVaRnFhSVNlOUttMFh2NXNyNU15Y1Ji?=
 =?utf-8?B?cmNlSWRGR3c2YXg4MmNYRGwwcmpYNFlRU053NEZxK3pGRGRlSE1EZzRyaDFK?=
 =?utf-8?B?MnBYeForOWs4dEEyZFR0Q3JmRVVZMFB2a29SdHF6TDBheXpkWWwrUmxzR3c3?=
 =?utf-8?B?MjRkT3ZEb01SNDJYc0x3bmJOMFFpdG84SUpxbkRwVkNSMjRiNno3TmRuN0NM?=
 =?utf-8?B?RCtXYzRpeWxxckJjYUEyby80MGM4U2sremxMdUJOek5MQjQrVGhicDJpY2xl?=
 =?utf-8?B?VFJudHZ2YmU0WmwzR2hDaldadnd0YWxJY1MybTM3cXljSnQ0c0lrd0VhTkFZ?=
 =?utf-8?B?cW13NUZlczhNRWpZSktoa0pnWUgxOFdIZUwxNFg2RVlEVm4yd1lVOWE3RWRQ?=
 =?utf-8?B?amZwSGV2ZEdmR0tLa2l4b0VvMXhlemhqTU14MEJtMEFQZFdycURjRXNLWnBS?=
 =?utf-8?B?OVF6bWdBZ2hiTDcxMkRzSm42S0tOb1RHTWd3ZDNsa3dHci9nRFNlWHMyRVZJ?=
 =?utf-8?B?eGFkTTFyTTl1TnJtWGtkTnBBeHIxMGxSeDBWdFYrT1VjS3JFcEtWZnFTS2pE?=
 =?utf-8?B?MEpURVBIaWp0UFgwRkNTQXVUN0FvQUtlaFN2ZVE1aWZrc083SkQ4M28vR09S?=
 =?utf-8?B?WmVDdkhsclpscXBjRDZaQ2twM1ZqQjR3Z3ZZYmxhZFVvcXZQVWpBSDFzQVRu?=
 =?utf-8?B?QmE5a3hjVnRGRjFYL1FkcWJCKzBrU2Z3aVp5SFMzaURFeG9nc0ZVeko4OXhV?=
 =?utf-8?B?SjlhbVdWZCtiaUhta0pGRFhXMDFSSUhhc3dVV0d4ZVdXbE14MXVGcGdjcWhR?=
 =?utf-8?B?RkhySGdhOTcycjAzajdlRjVFM1FQUWRUNnFrUVlrV3N0cTFkZHNNUStpRC8x?=
 =?utf-8?B?YXExU2FkR2RrdzBIazlENTZMMEttOFB2MVZaVEwrVXhFc2JFcWtVZkxadmtt?=
 =?utf-8?B?Y2d2YmtxNG85QWVCOTlub2JuNFlQUHh1K21FVlplN2FOUXhqN1NlNEc5akdw?=
 =?utf-8?B?c2hBN2tlc08yYzk4VldSWW1Gc3dRcjVaNm0wWmdpcVFYUEpVNGg1U1ZWKzdn?=
 =?utf-8?B?SVA2V0JPenErMm9uOUl4RnpGaXNrQnR1NjdqNzlVYkJGaWcvYXpiS05SMkh2?=
 =?utf-8?B?clVCUytVWjJlMmI4cVdQcGk1MkNrZGwzTGZxSVphMnhrb0FYYkoyV3h0OHgz?=
 =?utf-8?B?KzRvaXZBTTJ6ZHJ3bmloek1NZGgxd1dDbjZiVG9EWG1wU0V6VjVnYkxKTHJY?=
 =?utf-8?B?NGUyVzFZRldMUDVlZ2kydlNKQlpnanFSOWZjV1NaTzkxU0g5K3VVOU1kbXgv?=
 =?utf-8?B?ajFGNXFoVDV5WGpMTVN0Mk1qek5qMiticFN4Y1Y2cVBoWEMza29udEV2VFVI?=
 =?utf-8?B?VmVzNzl3NVVMRUNDT1JKd3hJZ2pmdEJ6YTY4d081OEhVR0tiVjNRVVFyUTB3?=
 =?utf-8?B?K0JJN3M1NEJIZ3QvdDdvSHJ0R2lucW53K0dsUHNCREtSSXh0Y1NNL1l4SUVn?=
 =?utf-8?B?d1dFK3pRL2VYbnZFQ1VhM2lPa1l5NHg0Y1ZWR0N6TVp1a3NKa3I2S05SRmdH?=
 =?utf-8?B?anAvdVJzMnIxT0pGUjBwdDBqQUppVm1LM1V3M21GZkQyK1gyWEM4KzZBK2Vs?=
 =?utf-8?B?ZldHdUhEcGc4NlVTRVdGcjVHWlBKRGtjUHlBTHRGcE5sVmZSTjI3ZkNWQ2Rx?=
 =?utf-8?B?b0lJMkl1QURMTExXQk9QenJ1MUo4VU01blptOWJPVGg2ZHVBcXhycDhVakw3?=
 =?utf-8?B?ZzlUamttTW90ZHVXSzcxdFppdWlXeTc5YkkrTjNPQnhSckM5WXowdUt5emVU?=
 =?utf-8?B?bnZvdGw3Q0VjbDVYUlVTSkV0MGk4UkFmQ2RRWFJnV1dvNnI5M2hGeE4xdnh5?=
 =?utf-8?B?M1hBMWxrelhMM0M4WmxVbWo2ZFFHR2VUVUtCVmVOcVp0RThSWjJJa0hJVVEy?=
 =?utf-8?B?Y1FTL0J5U1hOckNLNnFhS0FDd3JPbHVDRllqN0ZHSjVLczhhTTJIMkR3UmNN?=
 =?utf-8?B?eHNQNXkxTHhxeExCOXk2cXpCRjFlclhmb1hxekNBb1FHbDFaazZzNURyR3kw?=
 =?utf-8?B?TzN6TFRHNzNhclQweDF0OXNYdWFaaVlRTWdxRmZmUWp5TWZ5K28zMUxoOHF4?=
 =?utf-8?B?aEpXM1Nqc3BqMXd1aHJXN2RjNjVNVG84NUw5UGFFY2JOV05Dc2NsKzR2S3Ba?=
 =?utf-8?Q?sQVAVxG6PO4DzIh350GzcxyXjogIOeb/azMoWAAYEQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500bdb74-083d-4918-4e6a-08daa05ec809
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 08:03:37.0239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uU+u3kb/rcb6Q7HfsbuLvE2E3G1o1H1VJwDfp29qrZ1WlyKUNfUw6ylRNo8finzKN0W1CW7SujplPwgSWsh4ROZeGviSaO1YN0vbQFWs+6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4651
X-Proofpoint-GUID: YA_g_-Qz6W2ePzhVUFrMJF4ue0Hw1tyH
X-Proofpoint-ORIG-GUID: YA_g_-Qz6W2ePzhVUFrMJF4ue0Hw1tyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_02,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270047
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 9/26/22 17:52, Ovidiu Panait wrote:
> From: Mingwei Zhang <mizhang@google.com>
>
> commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.
Please ignore this 5.4 backport, as it introduces soft lockups in 
certain scenarios:
https://lore.kernel.org/kvm/YzJFvWPb1syXcVQm@google.com/T/#mb79712b3d141cabb166b504984f6058b01e30c63 



Ovidiu

>
> Flush the CPU caches when memory is reclaimed from an SEV guest (where
> reclaim also includes it being unmapped from KVM's memslots).  Due to lack
> of coherency for SEV encrypted memory, failure to flush results in silent
> data corruption if userspace is malicious/broken and doesn't ensure SEV
> guest memory is properly pinned and unpinned.
>
> Cache coherency is not enforced across the VM boundary in SEV (AMD APM
> vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
> VM guests have to be explicitly flushed on the host side. If a memory page
> containing dirty confidential cachelines was released by VM and reallocated
> to another user, the cachelines may corrupt the new user at a later time.
>
> KVM takes a shortcut by assuming all confidential memory remain pinned
> until the end of VM lifetime. Therefore, KVM does not flush cache at
> mmu_notifier invalidation events. Because of this incorrect assumption and
> the lack of cache flushing, malicous userspace can crash the host kernel:
> creating a malicious VM and continuously allocates/releases unpinned
> confidential memory pages when the VM is running.
>
> Add cache flush operations to mmu_notifier operations to ensure that any
> physical memory leaving the guest VM get flushed. In particular, hook
> mmu_notifier_invalidate_range_start and mmu_notifier_release events and
> flush cache accordingly. The hook after releasing the mmu lock to avoid
> contention with other vCPUs.
>
> Cc: stable@vger.kernel.org
> Suggested-by: Sean Christpherson <seanjc@google.com>
> Reported-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Message-Id: <20220421031407.2516575-4-mizhang@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: applied kvm_arch_guest_memory_reclaimed() calls in
> __kvm_set_memory_region() and kvm_mmu_notifier_invalidate_range_start();
> OP: adjusted kvm_arch_guest_memory_reclaimed() to not use static_call_cond()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm.c              |  9 +++++++++
>   arch/x86/kvm/x86.c              |  6 ++++++
>   include/linux/kvm_host.h        |  2 ++
>   virt/kvm/kvm_main.c             | 16 ++++++++++++++--
>   5 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4bc476d7fa6c..7167f94ed250 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1204,6 +1204,7 @@ struct kvm_x86_ops {
>   	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>   	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +	void (*guest_memory_reclaimed)(struct kvm *kvm);
>   
>   	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1efcc7d4bc88..95f1293babae 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5072,6 +5072,14 @@ static void reload_tss(struct kvm_vcpu *vcpu)
>   	load_TR_desc();
>   }
>   
> +static void sev_guest_memory_reclaimed(struct kvm *kvm)
> +{
> +	if (!sev_guest(kvm))
> +		return;
> +
> +	wbinvd_on_all_cpus();
> +}
> +
>   static void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   {
>   	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
> @@ -7385,6 +7393,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>   	.mem_enc_op = svm_mem_enc_op,
>   	.mem_enc_reg_region = svm_register_enc_region,
>   	.mem_enc_unreg_region = svm_unregister_enc_region,
> +	.guest_memory_reclaimed = sev_guest_memory_reclaimed,
>   
>   	.nested_enable_evmcs = NULL,
>   	.nested_get_evmcs_version = NULL,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d0b297583df8..bb391ff7a901 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8046,6 +8046,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>   		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>   }
>   
> +void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
> +{
> +	if (kvm_x86_ops->guest_memory_reclaimed)
> +		kvm_x86_ops->guest_memory_reclaimed(kvm);
> +}
> +
>   void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
>   {
>   	struct page *page = NULL;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index dd4cdad76b18..9a35585271d8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1408,6 +1408,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>   					    unsigned long start, unsigned long end);
>   
> +void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
> +
>   #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
>   int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
>   #else
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0008fc49528a..b1cb2ef209ca 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -164,6 +164,10 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>   {
>   }
>   
> +__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
> +{
> +}
> +
>   bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
>   {
>   	/*
> @@ -324,6 +328,12 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
>   	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>   }
>   
> +static void kvm_flush_shadow_all(struct kvm *kvm)
> +{
> +	kvm_arch_flush_shadow_all(kvm);
> +	kvm_arch_guest_memory_reclaimed(kvm);
> +}
> +
>   int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>   {
>   	struct page *page;
> @@ -435,6 +445,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   		kvm_flush_remote_tlbs(kvm);
>   
>   	spin_unlock(&kvm->mmu_lock);
> +	kvm_arch_guest_memory_reclaimed(kvm);
>   	srcu_read_unlock(&kvm->srcu, idx);
>   
>   	return 0;
> @@ -538,7 +549,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>   	int idx;
>   
>   	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_arch_flush_shadow_all(kvm);
> +	kvm_flush_shadow_all(kvm);
>   	srcu_read_unlock(&kvm->srcu, idx);
>   }
>   
> @@ -844,7 +855,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>   	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
>   #else
> -	kvm_arch_flush_shadow_all(kvm);
> +	kvm_flush_shadow_all(kvm);
>   #endif
>   	kvm_arch_destroy_vm(kvm);
>   	kvm_destroy_devices(kvm);
> @@ -1143,6 +1154,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   		 *	- kvm_is_visible_gfn (mmu_check_roots)
>   		 */
>   		kvm_arch_flush_shadow_memslot(kvm, slot);
> +		kvm_arch_guest_memory_reclaimed(kvm);
>   
>   		/*
>   		 * We can re-use the old_memslots from above, the only difference
