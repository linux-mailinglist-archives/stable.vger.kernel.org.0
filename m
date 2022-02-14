Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD54B5C2E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiBNVH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:07:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiBNVHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:07:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB28A12BF62
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 13:07:26 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21EIZF06011579;
        Mon, 14 Feb 2022 11:15:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=o286ny5xPaWyh0Isu8Mewbr1ukTNA5sTHr8P2/DlGtQ=;
 b=XVSAqCrQ5uJNQs/U24m5RAuqYmmD6n2orWrEQQy7wPXNWbppxh6fOrFSABNNgMEwJF80
 DbNj2k7L3/bxBeaKFiG/uaX5yDCsrAVG+qg/5AfXUyfYl7Ss5tRZg0CVOsiTRvdpkuq8
 RW/o9kbeul5wh6PLHorY4QsdtxjUAm5jXyI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e7mk83nmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Feb 2022 11:15:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 11:15:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3rx+pzPV5MSz5VAsuax5WdhcslpCzW4u0Xvtt0Y7VoqmLoFExfzEjQjMXjwy1e44t66TxNQFouEVUCywn/cqqw517Qu52UAIX+qxV9YXZWXmtr7Q2ahUaQ5kzH6KJjgKnfFBrNaXP3kzlfIt6o5G1TfCrIh+0GOvaurIAVIjUbtdzn3WMOI10DcBbBTrmyiOBrPc4kSo/Sm70/hCe5GFocNoC7DSIQdl6F+rPyDA7NPDi1SPjhXu+oPvuVfHSvJ5XqLf6J/unOpggYTybtFSN1B2gD8/B1ZY6tdh2RqSsvZTwM9RQgfay08VTgnI0VzPhyuI6/5gwYZoO241ERuow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o286ny5xPaWyh0Isu8Mewbr1ukTNA5sTHr8P2/DlGtQ=;
 b=aKcw9wq8oV64g/cI+kGAe7cKf46OObl2ypo1fT1+u15khe4iwtCFJM4tsVUim3ld/423jc+m/TO/qAx8doyqa4Eh5AtkdXElprNcUqmtZ8wLb17ULmwIOebq8UJSQ4jXGvYaYMBpjh+9QdCXQi1hvhIRUJkXABcVfoCx9pCxU+MVjzrGngSL5l9oOcCju9pUKlxZurUy2Jbe3olzIrpi0ngZLLUkCtxkGm0PfpA6f1TY9ZYshjqx6WPiP18r1lZ10pbYy25U50Jup1BY5n/sn1oyE0fJK9Xz4VtnU4oGnqHp2erQCbabOQgytvcE8C4FnpfYpnfWlykCtkA5kOehsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by MWHPR15MB1614.namprd15.prod.outlook.com (2603:10b6:300:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 19:15:09 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 19:15:09 +0000
Date:   Mon, 14 Feb 2022 11:15:05 -0800
From:   Roman Gushchin <guro@fb.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <egorenar@linux.ibm.com>,
        <hannes@cmpxchg.org>, <jeremy.linton@arm.com>,
        <longman@redhat.com>, <shakeelb@google.com>,
        <stable@vger.kernel.org>, <tj@kernel.org>,
        <torvalds@linux-foundation.org>
Subject: Re: FAILED: patch "[PATCH] mm: memcg: synchronize objcg lists with a
 dedicated spinlock" failed to apply to 5.10-stable tree
Message-ID: <YgqqOQLwHdNtvS//@carbon.dhcp.thefacebook.com>
References: <164475140586254@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <164475140586254@kroah.com>
X-ClientProxiedBy: MWHPR10CA0068.namprd10.prod.outlook.com
 (2603:10b6:300:2c::30) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bdf0a43-a2ce-4add-41cd-08d9efee50ff
X-MS-TrafficTypeDiagnostic: MWHPR15MB1614:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB1614E9511EEA1796D6C382B9BE339@MWHPR15MB1614.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6jyc3TC03p3Dnq7wORj2hV7NsWXNQhQPVD82NUQ8AlE0rEm33uyyqPvSEgBAr4vJbDz161Gk0N0ctlVBvlHR4RqMtgXpCw+JSvZJr3ygPdcSpNDvRggiI8v6DpRqGldhdKnyVV1prv/hglnPXSiRFsLcFEEo27igji7kT14Pz62r5eHlMIJ/u05C4jNuzIEKg1dF9DBk+Zy3qdOvY2fd8xXv3yoEGiqrWKBPliOTdcP/kd3brg1Kq86eSUXzDbQdN0uIW3toowz5UY81NlHwhWb72jl4l1EDKeJ9SPFLWRAoDnbT6nAoD0Pw4KP+gu95oTgLnmjnxxNvZp+VYP/Dv3NXWRUs/tccZKDaEOn+HJPGYSW0IiJgoGsL4Hz0PiWHQc8LEGt1AP9sPaXgIzCrE9zKOHI5ndKIDDfkdIAZ6nk87IcUPjH2xtUCKsZiTe21C/JdbG35Pt4KxcwTRNjA+BB1zvZSYoqNXgNLgk+OrcGJDV7InW5EbeXLFu1FkgduyVtif4BHxSZGaKDak3L9m0QcPHFSsNh5lqyJxEDNNe4U8hFqtzdwbNC3CUuWlW8p0F062rm0QrPEIAjcn2r4rUT2Da9gGBHEi6yqDYIvYQwHmJxSB6SdeoENe+nYbPsp9v2s2ojiaBI7eyCV4NzEZvLV4NnpEwnPPrh71+50chigW1G0JKhemI6KqYS2pBdm9f/IV4apuSF/loepdLc2GCMLdNo/9OodKoge+tQZd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(53546011)(508600001)(6666004)(6512007)(6506007)(966005)(6486002)(316002)(9686003)(2906002)(66476007)(86362001)(7416002)(8936002)(8676002)(4326008)(38100700002)(83380400001)(186003)(66946007)(5660300002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKewurO7oul08wPCd0XHH06z0dPfkfVi8Bz1V6jD8rQ1dHoT3dUwWfcyfh67?=
 =?us-ascii?Q?iUKi7EHgpuMP8wYfNmnztcps400k78YTzUyuau1YlwPNeIcmKqm4yHRp9CG8?=
 =?us-ascii?Q?sNr21NVDK53fxrCWEtm2MFPuq6SZ4oj3r9IcYgoBuIhX2u6mV1xwxQCiqnGQ?=
 =?us-ascii?Q?VuCaKXvhyfbb0tZ2WiWPJGfx+xwDjJ9vqmFgMR+MHYxvtXDuBK3wKaSD1U9+?=
 =?us-ascii?Q?mVgcF4mdkAP5A7kdM2V5NiOVMEqEv4SoURm/eXG3XSyiJnWZdOP0Zbe931H+?=
 =?us-ascii?Q?BkLF1kh7hd0AZqe6coKip7NMDKmlkm0A75s3y8E51ZibXhDt7+9yjgBNyOtU?=
 =?us-ascii?Q?eHoA5wTAAiMl0JNG+VvDv1wU2sIwU5VvR6FLBBlauVkwaBwe9YChFT95dqAz?=
 =?us-ascii?Q?CWgvmZZLO/Y9X+9a0XtNETuwE6uftfnSmHt3gWEVu3+I0hoiYD5Cj+E8LvtD?=
 =?us-ascii?Q?pR3WIgbuDNXqHenmd6f5hOi9xhPv3bphZoR6iPEjZlV38QlIA9ckQw8FZqcx?=
 =?us-ascii?Q?tDyWtimoR/YND4cVQJmQggepxcuwf61u4pTiMTZvK5UEo939f+mbalVbSdUs?=
 =?us-ascii?Q?iDHDE2JObgabdqNUoZrUxp0j51F7Fz+kuX5FFILI9xAo0eElnoMm9cCA8Ewr?=
 =?us-ascii?Q?LWOllPf3cdAuLLDeSDVaaZ6FrxR0kH9PSXPyhvvuZh39Afx/kBR/FcYOv/g4?=
 =?us-ascii?Q?JPb3Iuc8WIrtqcXjjJSv6qw/FBAgyO4yB0mFTMtq0SW8jsS7HvhSJiXApMDG?=
 =?us-ascii?Q?Fofe1zolow2tr7jevsxrX+RNIOCPN9v+3IsoA2ziUWzHJX+XetEdUbR0MoiV?=
 =?us-ascii?Q?er/l0zpBVNpqOQH01JqzceErm0glHSja5Hf4R6OFepipYv/dHAxo1vXFcPzC?=
 =?us-ascii?Q?Nzu4d9aav56LmVSqhcYfD1bUXPspHdI9hk+ju/Zcw5vOWBgj6uabngbHyca8?=
 =?us-ascii?Q?WHFAZSIJtJqE9VMMkAjOetU+xqQNWX9y6AZWPX3F9dHh6Z4+nhUW6tJkP47l?=
 =?us-ascii?Q?KaJybo7JNDsn9R87/dyAnAtHsn3C7uMQqI78jocwkS647/dpyPfDATZR7SbX?=
 =?us-ascii?Q?NLLdZCIyefS/0Ci/IQesC8zvv+UUIPDedg6/YaMgZ9abtiZTdOOPSwlTRJ0y?=
 =?us-ascii?Q?f/NV5mXpS4aGGfQEN2XklO6VykoZrXUg7ydTCH4vriYIARo+94pB8VigEBJb?=
 =?us-ascii?Q?YMA3/hTXjJKuwMEcRKWPvmQ+9kNnmvwjewAFVCLls/cvhVpIJJY7sOkDmxZL?=
 =?us-ascii?Q?IpG9RCAgR+s/Ec6YbEprPHsVFvQjpkhKL4w3kT2b5CO6KORq8LfxLxOJ6wME?=
 =?us-ascii?Q?TgENCNcDs0+Yok1uQGJNYJ8ZW8woZtdX71NxXRU+OakK1woVTo9Znc+3TrgG?=
 =?us-ascii?Q?rc/PxHxXM4BvZJliGasTEoG0Ch8Y8DOSXS14DzU1jkp4IycROhdIk5qhzSaE?=
 =?us-ascii?Q?Cqh+0s1OOXbWoixqz3iUljdukx7cszTdcDo1Nz+g/o64ikN6oJOPIuGVj5nn?=
 =?us-ascii?Q?Y5wZpH/QN3LhNtZQxutngq+Be52VTdrX2EJRFdbuPNTLXjAXIEQwD8TPb6PY?=
 =?us-ascii?Q?jO561sr4fkj7Tss8wBznIP7Q6DiCjTed09xqyX8s?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdf0a43-a2ce-4add-41cd-08d9efee50ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 19:15:09.2608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6pxyuGyCLKuNYhd+iPln93zdbRY+DrBq7ocAQW7p6ygFm2HgLsOzzI+bK5VAzrn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1614
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: MyWRbIceGHFZ0HL4zugNGACw-E8FiItO
X-Proofpoint-ORIG-GUID: MyWRbIceGHFZ0HL4zugNGACw-E8FiItO
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1011 mlxlogscore=466
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140113
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 13, 2022 at 12:23:25PM +0100, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 

Hi Greg!

Below is the backport of 0764db9b49c9 ("mm: memcg: synchronize objcg lists with a dedicated spinlock")
to 5.10-stable.

Thanks!

--

From 43272d8809626549b7392d91e694afa74810fb00 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 11 Feb 2022 16:32:32 -0800
Subject: [PATCH] mm: memcg: synchronize objcg lists with a dedicated spinlock

Alexander reported a circular lock dependency revealed by the mmap1 ltp
test:

  LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
          WARNING: possible circular locking dependency detected
          5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1 Not tainted
          ------------------------------------------------------
          mmap1/202299 is trying to acquire lock:
          00000001892c0188 (css_set_lock){..-.}-{2:2}, at: obj_cgroup_release+0x4a/0xe0
          but task is already holding lock:
          00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
          which lock already depends on the new lock.
          the existing dependency chain (in reverse order) is:
          -> #1 (&sighand->siglock){-.-.}-{2:2}:
                 __lock_acquire+0x604/0xbd8
                 lock_acquire.part.0+0xe2/0x238
                 lock_acquire+0xb0/0x200
                 _raw_spin_lock_irqsave+0x6a/0xd8
                 __lock_task_sighand+0x90/0x190
                 cgroup_freeze_task+0x2e/0x90
                 cgroup_migrate_execute+0x11c/0x608
                 cgroup_update_dfl_csses+0x246/0x270
                 cgroup_subtree_control_write+0x238/0x518
                 kernfs_fop_write_iter+0x13e/0x1e0
                 new_sync_write+0x100/0x190
                 vfs_write+0x22c/0x2d8
                 ksys_write+0x6c/0xf8
                 __do_syscall+0x1da/0x208
                 system_call+0x82/0xb0
          -> #0 (css_set_lock){..-.}-{2:2}:
                 check_prev_add+0xe0/0xed8
                 validate_chain+0x736/0xb20
                 __lock_acquire+0x604/0xbd8
                 lock_acquire.part.0+0xe2/0x238
                 lock_acquire+0xb0/0x200
                 _raw_spin_lock_irqsave+0x6a/0xd8
                 obj_cgroup_release+0x4a/0xe0
                 percpu_ref_put_many.constprop.0+0x150/0x168
                 drain_obj_stock+0x94/0xe8
                 refill_obj_stock+0x94/0x278
                 obj_cgroup_charge+0x164/0x1d8
                 kmem_cache_alloc+0xac/0x528
                 __sigqueue_alloc+0x150/0x308
                 __send_signal+0x260/0x550
                 send_signal+0x7e/0x348
                 force_sig_info_to_task+0x104/0x180
                 force_sig_fault+0x48/0x58
                 __do_pgm_check+0x120/0x1f0
                 pgm_check_handler+0x11e/0x180
          other info that might help us debug this:
           Possible unsafe locking scenario:
                 CPU0                    CPU1
                 ----                    ----
            lock(&sighand->siglock);
                                         lock(css_set_lock);
                                         lock(&sighand->siglock);
            lock(css_set_lock);
           *** DEADLOCK ***
          2 locks held by mmap1/202299:
           #0: 00000000ca3b3818 (&sighand->siglock){-.-.}-{2:2}, at: force_sig_info_to_task+0x38/0x180
           #1: 00000001892ad560 (rcu_read_lock){....}-{1:2}, at: percpu_ref_put_many.constprop.0+0x0/0x168
          stack backtrace:
          CPU: 15 PID: 202299 Comm: mmap1 Not tainted 5.17.0-20220113.rc0.git0.f2211f194038.300.fc35.s390x+debug #1
          Hardware name: IBM 3906 M04 704 (LPAR)
          Call Trace:
            dump_stack_lvl+0x76/0x98
            check_noncircular+0x136/0x158
            check_prev_add+0xe0/0xed8
            validate_chain+0x736/0xb20
            __lock_acquire+0x604/0xbd8
            lock_acquire.part.0+0xe2/0x238
            lock_acquire+0xb0/0x200
            _raw_spin_lock_irqsave+0x6a/0xd8
            obj_cgroup_release+0x4a/0xe0
            percpu_ref_put_many.constprop.0+0x150/0x168
            drain_obj_stock+0x94/0xe8
            refill_obj_stock+0x94/0x278
            obj_cgroup_charge+0x164/0x1d8
            kmem_cache_alloc+0xac/0x528
            __sigqueue_alloc+0x150/0x308
            __send_signal+0x260/0x550
            send_signal+0x7e/0x348
            force_sig_info_to_task+0x104/0x180
            force_sig_fault+0x48/0x58
            __do_pgm_check+0x120/0x1f0
            pgm_check_handler+0x11e/0x180
          INFO: lockdep is turned off.

In this example a slab allocation from __send_signal() caused a
refilling and draining of a percpu objcg stock, resulted in a releasing
of another non-related objcg.  Objcg release path requires taking the
css_set_lock, which is used to synchronize objcg lists.

This can create a circular dependency with the sighandler lock, which is
taken with the locked css_set_lock by the freezer code (to freeze a
task).

In general it seems that using css_set_lock to synchronize objcg lists
makes any slab allocations and deallocation with the locked css_set_lock
and any intervened locks risky.

To fix the problem and make the code more robust let's stop using
css_set_lock to synchronize objcg lists and use a new dedicated spinlock
instead.

Link: https://lkml.kernel.org/r/Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 0764db9b49c932b89ee4d9e3236dff4bb07b4a66)
---
 include/linux/memcontrol.h |  5 +++--
 mm/memcontrol.c            | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4b975111b536..1f467fb620fe 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -197,7 +197,7 @@ struct obj_cgroup {
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
 	union {
-		struct list_head list;
+		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
 };
@@ -300,7 +300,8 @@ struct mem_cgroup {
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
-	struct list_head objcg_list; /* list of inherited objcgs */
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
 #endif
 
 	MEMCG_PADDING(_pad2_);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4bb2a4c593f7..dbe07fef2682 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -250,7 +250,7 @@ struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-extern spinlock_t css_set_lock;
+static DEFINE_SPINLOCK(objcg_lock);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -284,13 +284,13 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
-	spin_lock_irqsave(&css_set_lock, flags);
+	spin_lock_irqsave(&objcg_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
 		__memcg_kmem_uncharge(memcg, nr_pages);
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
-	spin_unlock_irqrestore(&css_set_lock, flags);
+	spin_unlock_irqrestore(&objcg_lock, flags);
 
 	percpu_ref_exit(ref);
 	kfree_rcu(objcg, rcu);
@@ -322,7 +322,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
-	spin_lock_irq(&css_set_lock);
+	spin_lock_irq(&objcg_lock);
 
 	/* Move active objcg to the parent's list */
 	xchg(&objcg->memcg, parent);
@@ -337,7 +337,7 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
 	}
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
-	spin_unlock_irq(&css_set_lock);
+	spin_unlock_irq(&objcg_lock);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.34.1


