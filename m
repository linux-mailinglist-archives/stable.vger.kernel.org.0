Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E76558B2F0
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiHFALd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 20:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiHFALc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 20:11:32 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6291CF
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 17:11:30 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27600FRe006676;
        Fri, 5 Aug 2022 17:11:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=PPS06212021;
 bh=dAaYoht9qiL7RDZflKE3POt9mu20S7vBl0UPzoz6h2k=;
 b=Ipm+UEdx2cok0Q1KvyBbqPLRqlOzcURBSjdll38RTJGjJP5yCk35e3bkrn7lzz9guWnF
 9Rm7J13E3UmrYMeuZFeO9vEoj9291nTSN8n5ZVM7y3cEUjIrcRLO5IndMSF584DpiY0w
 QZRJ7Pmgz0gryiFLAsGVfJ4Y1Av3k3B4fWRvnGf7Ko+xBrwAiKBdKMD2o+45tYYQOfW5
 apSgpUBfmZg5SnnUd1rJg7qhbs1s0CBTK5kVxuYm+X4d6WHYz0bOgu8UqXs1s9Gkw3ty
 P73VUs2HsZrdDf4LG8lJ1PDvsBmT4d2tywv8A/3tklr4CnXVcK4HtEqpPxy6Z9jvWYPy UQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hr3vghthu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 17:11:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml4My8GbKhXi/CTi0rMXVfWLhBZ2immIwJFj9ns/sonw+u6MfM24A3k3HxmG7JlUNTB+96RBfrinL64YYA/GkqcY+chZPVUYQcvXaqUvvPnDz9eMSQmCcrpUOKhnSEXKGkfo0nLzs/SC4wb8H0HUEKyjV7m0+XRaEEyQJKi9rwc8ZxGcDz3igbKL0VQ+mewaXYYILWYsoHdS/JccwBZb1We6QezNivS24c009vTpxF5mHkX4vm/6nc2PzptXZZ0/g13LRslEqGTxHSMCzrl6xwz9WXGa6qeSu15Drcrwypd8EzYuOwquRQsxPuKiDM7Yh1j6DThqhRteDl6PxWgfgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAaYoht9qiL7RDZflKE3POt9mu20S7vBl0UPzoz6h2k=;
 b=mVTapkg4a7tS6Fhw8NBpWhfdZLmE7zIt7+fTOF3ElGIyGZsXsHMjICL71+EHq5vDCoV+z5m8+IpIVi1uQtOpeV52bM4CBbxRPJ19+wt3C4mcfGTzc79Tc1APRZl4zu3F8Lfxly1x6xQUzjebv+LKz29baDnP4IfKnRMnjTCVSCJzdy+Fv4xhKYoN+YLJc6KN2P2Kg7US6FAG41g8H2qcSrWrN4Cc8n30dN5SBQ1R9F/vokxrMh9obdPTH3tNKtAAA308EvT8lk4JSGKruQcwB0NUofwSeYTjYh+Fv3VRoO1MJno3/O2KomCyVHxjTWRNLgNHvIHuAcQgBW4qc8rybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM6PR11MB2649.namprd11.prod.outlook.com (2603:10b6:5:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sat, 6 Aug
 2022 00:11:03 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::d07a:62c7:2b1c:487f]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::d07a:62c7:2b1c:487f%4]) with mapi id 15.20.5504.016; Sat, 6 Aug 2022
 00:11:03 +0000
Date:   Fri, 5 Aug 2022 20:11:00 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <20220806001100.GD42579@windriver.com>
References: <20220805200438.GC42579@windriver.com>
 <Yu2H/Rdg/U4bHWaY@quatroqueijos>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu2H/Rdg/U4bHWaY@quatroqueijos>
X-ClientProxiedBy: YQBPR0101CA0185.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::28) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f16651dd-97ee-4b07-9725-08da77402682
X-MS-TrafficTypeDiagnostic: DM6PR11MB2649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmnct9WX/5zJ/cW8E6A2d8UJcq6s3QFAMtydCH1RLzMZ7qDuuFZ2BN+uNVPm7AuupaX7ISbw743ZVmIG3bFJgsfQfWFHbrT2aFi8Z+8wv7khcvUVpJgjNJ6Dbcm0RLLdy3tFf1FPg0eo/yE7I+kbOlIw+PcrfeJDgATFwOK79w1hJrGDzH3KZdUvve5H9x9vUaK3qXzt+YNScKw6UzhD4fG6K11eOaBQAeJfizSEAyHZac3ZvxwXZBrZ6FffqSzDduGM16Ow07ZGiJ9wHEjuUF4FwxZIb2Fh31gX43KVSh/80JCT4W6RKTQ60s4TGodCx+aSjQMIgi24AWDASqoRI1LUnGeKYxpaJA633ucgysSBYflLvmVqDOOBAwbnY98n1d2einvsG6HXcVtao0ai7py6ZQW2NKiw5/xljVuCYg+LFohFX5Q4Lktzb/TfvJHU0eiojTOWSkkiaWzfv5dFA8ZYLqWle6WwdR22VO5M5sJ0+n+thtRDoi72E4KjcUiZ5vN+6xs620wsVU7DF9fxyMKs98rGZ1PJNFri7YpSfEXVh0ehtl++ZXjr4FKE+6ifeVvNiL9WqTidimywnRNyVKHNMJuV0m3yWQaoT6lxfQdnK03T70kNjhv+mFHtWA5EEbWi/ru9fOpKtEDjKwQ+xI8yKt1zNBeIgnjb8bRN9+SuGq202fD45XtwKjx93lFEFqqv+ND0OxmjsSH/e2Ah1dcikyNpI10/XAFSNaw8nWqh4R2jeHA8O3pIjI9b5blgaJsP9lN128rq+5K/6ZtdK7zgmkLVKPNCEDYoqHzhXavs0Se3zNxp/IjWPzjXEPe+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(39850400004)(136003)(8936002)(186003)(26005)(6512007)(33656002)(44832011)(1076003)(2906002)(5660300002)(36756003)(6916009)(66946007)(86362001)(54906003)(6486002)(478600001)(41300700001)(66556008)(52116002)(316002)(4326008)(8676002)(6506007)(66476007)(2616005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zOtdtFpTdKPaQsE6u+WHg2VsOV45v7RopthEnDfxkdJe73il2Ewjg2iGhF0l?=
 =?us-ascii?Q?Cq+0beaU7Z9icq0aFkir9p8PrRqHFOGEG5+cJaQ9fbhiOP49XIiQvzIefpvU?=
 =?us-ascii?Q?wbqMFaDwgYsAwPuSPJ+lZQesh6D94JAWzKbjca3zrWFR3FoIJT8pvNM+/7Hz?=
 =?us-ascii?Q?wLwG2l/xI56YTbCE2jzvgoxvWlwPYRVqOnMh/lxey3g8Bch/Ey0XM7S2Mgzd?=
 =?us-ascii?Q?NFuzcgdaeJiRKtosDOi+JNr0x/WV8L80hznUl0NNqX5gRD0KI+FCvp/jEOJo?=
 =?us-ascii?Q?vWGyLxZcK4ccckTfz1DI82ii/ufeHr3s6e50gYoeA0zQMphDkMmTfCcBDqwU?=
 =?us-ascii?Q?qGWSRnpcaNl1sp74KM/hpzYrv+S1gB3ys7MC8TYSZfXDbVznqimlYPSR2hGl?=
 =?us-ascii?Q?zzOPVBwc0pOA/aH6MlzhCgpv/bzUstISVJbIdSPwZpFhgGznb+XBN6XvTKBr?=
 =?us-ascii?Q?CD1iyFHjC1RiA5ft+K+HWhKMFiM8N8u6nRa8NOT94GwEiC/ZtBX7MweXJEtj?=
 =?us-ascii?Q?YIi6dODCPrCJ5o3EIkMQiIxT/XOY3xBjueP4BIm8Mv3hZFXvCrjzepnHHvjQ?=
 =?us-ascii?Q?Th5kElrhOx6ANOeDocPBi8MWJFHMLVuPXEh78O6Cd53YeoBprJTwqy5MqszF?=
 =?us-ascii?Q?SfT0miudEVjskhuGoy7B/k01z9YPqkcF5DyB6keKoehm4b2ZPVw9U8kAUqAd?=
 =?us-ascii?Q?tnoFbYRZrrR8cH9DQimfFQaPk/wzRQDUee8RLGt/aG1dr3W/2YZPXa3FJLO+?=
 =?us-ascii?Q?WaKpl3TRTtjX7PNGPOo7jhLHa20fvBLfzxGd0lh+gIbI93/DRtWhfLLEKtdC?=
 =?us-ascii?Q?aJL/OShEthtYXwyZgqwFy4kHlepKIV5jTguB3i0uw5a3LPQm3d1IDElDD2Db?=
 =?us-ascii?Q?kcLoEP5PkeUh4Gsv5kUlPX7ZykQBPH1bqr7HcE3YGJA/P4jF9Yb2n1dBvVOe?=
 =?us-ascii?Q?P7eTNX24gGeNRTsJhCVzRI8S3ZTCLwI6smXISiSu1IhJTHTv+hX0s+4ZJu5I?=
 =?us-ascii?Q?LCXOTgihe8OhRJnhtQMZktxZaoF42Yitg70YTGVDGpCGF0cQD7+pEoC7dakD?=
 =?us-ascii?Q?poM8AI6W/lEIG6hpxDkChDKrv3aHTjKD2CF4s0XYgFNxt2AaY0L3gMPzGGQU?=
 =?us-ascii?Q?goe/WaIMtm72Vgx0hn6c828ZXfwALmihxr5gpCXlXIrlPAOFPs60TJMhnJkc?=
 =?us-ascii?Q?4sHzXqoLLbB+qCTCei+slbwFV3VrrJ5hbeq7vd9yXABZqopCqrKAZh26c2/C?=
 =?us-ascii?Q?RuF4mkKFeLyku2czAnbd9SZj2MkadGBc1UZw1Ax71YZxW5I7+b8R197Yw5x8?=
 =?us-ascii?Q?jsVulSiKRD5sgAcbYaI6AshgwGeOQ/mLMLfOCpJPpwtHLIJgagmfdYpcEedI?=
 =?us-ascii?Q?g6kj7Z7zjgCoqdIINfgGVswVVGUxRA2GUY3qINDaomN9MMWxQY0OqP1PcWxY?=
 =?us-ascii?Q?JiP3WacG1yf1dYoKHm4BoWeoY+Jsi01F6V9DqwDKx4M9sClY956c+LOBH2zN?=
 =?us-ascii?Q?htNV5WFvFoMzo3mE3Pkt6OBG+Pq+Mw5yftufuBkbVk1E9105g6Xc9tLjvoP3?=
 =?us-ascii?Q?rsDiJYPu1mo1xQxlggc4m976f/xZEpKOdxrkxBXSXF7ZPIYOj5JAVTIFv4U6?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16651dd-97ee-4b07-9725-08da77402682
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 00:11:03.5614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEK/JtmufYpDXdGwRphzKQF4uintOXwEd3jElW0+EqQv0kILzt+sOiIztO2f6dLpWpj4J3nsaN0Z3sfHTI0GHpn3e5zasSNDXBHBsV1oNcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2649
X-Proofpoint-GUID: tpx3hdDvwGE0J3IeEtj7dOukTrx9_WIX
X-Proofpoint-ORIG-GUID: tpx3hdDvwGE0J3IeEtj7dOukTrx9_WIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_12,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=687
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050106
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 05/08/2022 (Fri 18:13) Thadeu Lima de Souza Cascardo wrote:

> On Fri, Aug 05, 2022 at 04:04:38PM -0400, Paul Gortmaker wrote:
> > The panic comes from the sanity test code, but after trying to boil down the
> > .config differences between the kitchen sink our test team uses, and a
> > "defconfig", it seems there are at least a couple extra dependencies for
> > creating a reproducer:

[...]

> > 
> >    rcu: Hierarchical SRCU implementation.
> >    Kprobe smoke test: started
> >    BUG: unable to handle page fault for address: ffffffffc110f3e7
> >    #PF: supervisor instruction fetch in kernel mode
> >    #PF: error_code(0x0010) - not-present page
> >    PGD b2c60f067 P4D b2c60f067 PUD b2c611067 PMD 0
> >    Oops: 0010 [#1] SMP NOPTI
> >    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.57 #33

[...]

> Can you try the patch below?

[    2.529263] rcu: Hierarchical SRCU implementation.
[    2.530393] Kprobe smoke test: started
[    2.555965] Kprobe smoke test: passed successfully
[    2.556454] smp: Bringing up secondary CPUs ...

As per above, the same spot in the kprobe test seems to manage to not
panic anymore and the remainder of the boot looks clean and normal.

I tested directly on vanilla v5.15.57.

Thanks for the quick response!
Paul.
--

> 
> Thanks.
> Cascardo.
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 74c2f88a43d0..6bb479ce1ae4 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -321,12 +321,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	unsigned long offset;
>  	unsigned long npages;
>  	unsigned long size;
> -	unsigned long retq;
>  	unsigned long *ptr;
>  	void *trampoline;
>  	void *ip;
>  	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
>  	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
> +	unsigned const char retq[] = { RET_INSN_OPCODE, INT3_INSN_OPCODE };
>  	union ftrace_op_code_union op_ptr;
>  	int ret;
>  
> @@ -364,15 +364,10 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  		goto fail;
>  
>  	ip = trampoline + size;
> -
> -	/* The trampoline ends with ret(q) */
> -	retq = (unsigned long)ftrace_stub;
>  	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
>  		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
>  	else
> -		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
> -	if (WARN_ON(ret < 0))
> -		goto fail;
> +		memcpy(ip, retq, sizeof(retq));
>  
>  	/* No need to test direct calls on created trampolines */
>  	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
