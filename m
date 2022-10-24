Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED99609B02
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 09:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJXHIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 03:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJXHIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 03:08:35 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A543B3DBD1
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 00:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVpUBGTIM69g41Jk2NJZOYjixZRxCj6W9+iOEHDcxBGSwuldAJ2TkKKDFYNp+ElKg71jC4noRWgnDV2M9l5vInpo6/K03r88elOoLt2NNvi1rD4cxqALCnDlnY3ef9YW93JzDqPhQXD3r0J3T1Kc3o4DXUfSfPQaNh1G9MRNyzzVhgkNeM6BoIVnAmt2CAG2Srxm3i8Dq4HMMIYmW16/6Gpo+s6pzFkhxOCRLhlIO+2t+thAgD0I2HYRztResen1yl4T9QBvfaLdFpV/91AMX5zPR40oFqLYkXl610Df1t364OpMo37XbTPCDuK6P2+mjccy6+M5SVb2EnTwA73g3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PX66e6AaOGrJ45g4fwEJ00nmjRHfP9nm32h4S3VkRM=;
 b=KYzgSsyhU8MMtW9B5JRfkO3s0y4dNXoDWHip7tsdXGkoxcbU7YeIyRsmV+VgqNkt8JAyLQxFPpsGO0ltQ/lIx4W7ksIX/llEUT9Q0u1k35f0MFq1mb1DytDSQCfhrxTQb7UkNgMBopuP1jWCAad5UOGOPNPteCNS0Lj0PPslaINIY73ZOhueVVRsJRekSe4RDvOp+qDWcMKyOw28rPyk2lVn8z5KQLpZ8Me370L6H9m7kcoQFkIiMOY6KysyZxnFEb2GMXoqqOnzxMhrsc0tTFXDBsWDgoQjUNcAI/ISocNhOoV842quK8QSiAtHJrU02mZB3lIj8PLHJM9VbDWCfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PX66e6AaOGrJ45g4fwEJ00nmjRHfP9nm32h4S3VkRM=;
 b=MmPPpqUOh5VG8z17gx8iBV+82jf5bQSzLzD2fsLmlEVViikHmqT1KHF3JB2pl9bf6D17ebanMr3JS16LGknBktoKSyrdsxLC309AhoANzX1oNavP6rF+5ygcOZlGaZ6LrOm5VfJg0DiyN9DEuhGhHMDKzSRlcS/Hu5CYEaZs/46EI2aiM+Oiin9kTILeCPjC98L23BT3vGxU7ECKrM5XR5T39uBjfeL9ZE43FUkROSw9AbrzDA0gTgNgmZHo6K4xnC0Wu7vH+BVuYYLxdNB5EaqGYEHnIG8GLRMN3gafKKm08WyPhjc//MD+A63b9DNcooc0ZFzACm0ABsSnIVxHdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by AM9PR04MB8745.eurprd04.prod.outlook.com (2603:10a6:20b:43e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 07:08:31 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9%5]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 07:08:30 +0000
Message-ID: <6f9bd9ba-ac8b-4ec5-d4a5-865d5546fecb@suse.com>
Date:   Mon, 24 Oct 2022 15:08:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO flags
 handling" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, dsterba@suse.com, nborisov@suse.com
Cc:     stable@vger.kernel.org
References: <1665923098198193@kroah.com>
From:   Qu Wenruo <wqu@suse.com>
In-Reply-To: <1665923098198193@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::34) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8465:EE_|AM9PR04MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: b7e5a785-ded5-4e1d-aa87-08dab58e8e6f
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvDOdpb/k021jC9wHZUfZAuEK5fBykDItBlNk8gsFpUf60bDQcu6M/Tuq6S22HG88+SMJjknow8VJ71MJQAlnSsxoTAmr7xWNjcEDBgAXbQ4/mfzeakwJYRubFoXgxlKpf88lsWIw41tGS1bYuN4SCrn/c9WByLxVf5IVogK/7ITq7V+w8ZzkUSpD72x9oYePj3Sxj3yKTTRu2mru/ryz2zUOoPPLqt+G8EvJH2yTnhSzT5Txer3EwfwAFxAO6xFD75W/Pz5O0+6cXL3LyWSzwT+8BIjKiyOpXajB7s9M00N2VUk8Z+yNcXUMn2weZmrN76YtalBUnI32ZG4SkL2px+EKERc41+LtxwkXNqrDiuytm1wHkKAeoJv/D/DHWcPpaFvs4Q3Y4sSw1KyKFNGJmCA2TQLujTapNbpjaLxTOB5gQ3epKTduq4WpUB8XXZD/qMp9/9KyWdk3cEl8Em+/NxmqhCALRwmVIYgMd9NEbmK/nKmLFASSLsAp8FL8nbXc0Qcon2YxSLlUTLM26bu5l8BzNCf+Qfy9I8FpDd7zUb4DC21QME94JE7Aen8DgWOHd9x9TLVnrcXUMKm0B1TwKEhWS7E63fWKnin+dZs0r+EJrX32zhVCx1mkGyA8T2WQgGKe606nSu6R6VTyl0+jUqFIWsRz7EdZtiJ/anJWL6i/h+6gsehyx6JSBc5cPN9f2dyOLJme4qhM7SDOh7l3e+A5/ByTX8JboOfWvaUbo+a++eTlNcz+VP0SgEfUyVBkODOGjYGEfi3PLq0i0wwNukqT/63HSj3qMthuDa50Xo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199015)(2616005)(31686004)(66946007)(66556008)(66476007)(5660300002)(6506007)(186003)(53546011)(6666004)(83380400001)(36756003)(4326008)(6486002)(478600001)(8676002)(38100700002)(86362001)(8936002)(41300700001)(31696002)(2906002)(6636002)(6512007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVJ4dU9xdlJLNlBEMTBBUFF0MUoyZTdGUk5BT1dqdW9tNXZyMWpMMDhKNEtK?=
 =?utf-8?B?NWtpYTl0d2M0VENHWnRNYUJKc1BucUtxNmM0dlFqM1kydUlwa1lHcU5VNFBt?=
 =?utf-8?B?VU1zbUdSQTg3a1E4cW9YdFNQM3NrVmJ3bERBYUc4YlNrR2ovNkhDV2FtQ1dv?=
 =?utf-8?B?Vzd2L2NpNHprK2JXUmROdkx3UGpDOGdRZkNFWnF3cjFvMnovS05IZVA3SEVC?=
 =?utf-8?B?NVNHeFpWY08rckM0aEd0OFJYYzVobEtnYlVQZFpPaFY2aE82R0ZtVlAxZEpY?=
 =?utf-8?B?RzhhcUFvL3FadTA5VHp0UFZ6cFNneGVHWkxZMmpkQlFKRjQrK25MM2ZBMnV5?=
 =?utf-8?B?ZGFITS96aUFNSlVicjhnUk00dDJ5UlNBVExWSzZWWFlWUGNnazJMbnhyQ2tK?=
 =?utf-8?B?QlBaNmNiWnZWYTc3Q2ZBUVAxaWNkR0dNbnV3TW1BNzJ5MzlZUjRRaHpYcGZJ?=
 =?utf-8?B?SENJQklmZmJuNC9mQlIxby9zR01yeVNVNk5zeXRHSTFXZWFJZGl4b0cza1Vp?=
 =?utf-8?B?V3JISHVMOUxhYVNBdTNvbWltcUdmUDc1VXIwcDI5Z1lvMFVoVmExTHVqeTVY?=
 =?utf-8?B?eVc0czIyaWZ2ZjNEV3Y0SEJGUHFsRlRVc2llb1VxYWlrdXFTVjFLekVyYjJ5?=
 =?utf-8?B?SUFUZXd2NUJ1SGNFUEV6bW1VZlpIOXpVTXZtUnlKUHI1SU5PL2VKT25CVGZY?=
 =?utf-8?B?RHMxbGQ1L01wNVVDR0Q1cWF1R2ZKS2tCcEh3a1Npb1l5Sjk3cjdBWlo0Uis1?=
 =?utf-8?B?NHFaTlNORjQ0a0wyRERHaUNEblV5bGFaT2FpL3hLcjlTcXNUMUdTb2ZlTUts?=
 =?utf-8?B?aTViQ2lNUkxLUDEzdFE2VUVjWHFhd0N6WUREdnFuTnI5WXEwQWkyM1FkOUgy?=
 =?utf-8?B?YlBhQVFMcGNqSXFUZ0llUWxxbkcvbmdXekpNTE9tOVJXOVBGSmFpRldmcllH?=
 =?utf-8?B?cmk3Z3NOU1ZvSHZTOGdxdzBHay9WZ2diclpPNTlnV055aDI2dm0xcHNSNTgz?=
 =?utf-8?B?eExaejc3cEpmRGdqN1gxYS9ySjk5Tk1KZVJoWVRDR2YwL1VtSENKWGlOOEZT?=
 =?utf-8?B?akszeGw0RDBlL0x2SFQ4U2M5RDdJcjBOOFVmdmFIcTMxYURjaHROSGhNMng0?=
 =?utf-8?B?cHlQeGV6Q1kwZG1ZR281RmtFTmJleUlVKzJxQ203UisrQ1NaQUJzL01Uemho?=
 =?utf-8?B?SCt5emZJZFNBSkRtTlErTU9tTXpZMjk2b2xSdk8rVXdOV2dZZ002YXlEZWR6?=
 =?utf-8?B?Z2txbmg0cmI0RE84WTA1UXBudE5MaUVEVDRiSzRGY0dPZEgwQUtYVGhNYW1B?=
 =?utf-8?B?NVRyT1E1Rk5lMUtUMjF2UTVsZXVnZ1NKRFBmakgzMkxkL01hN2REOXZaRjBm?=
 =?utf-8?B?MmFpZkwzY05HV1hsZVQ4U1EwdnpaR2Z6eVZwUk00K1M1eEc4Nlg3TjlQUjAv?=
 =?utf-8?B?NE10WkZOdTdNRzZramZlUHNUQ2oxV3UrS3JqS1I4YjBiTWpLdWVWdndnSURE?=
 =?utf-8?B?RmlmZjZKVUowR0dvcmY1U3U4MzFwQkN3c1dad3U3bkhIYlRWMncxektRNWdR?=
 =?utf-8?B?bkFxSTJHakFlbnVxWWtyOE94WnpEaVlEdGxmUExGMk84c3VJL3BnVjl5ejZD?=
 =?utf-8?B?dFVqS1VjcDZOdVhqR0tING0rVUxzaCtvWW1jd3BKRmR3QjdXUXpsa2tCN1FH?=
 =?utf-8?B?cmVXcTlURjJGSmpkT0V2NkVtVUZDdXdZbzBMS3lBTHpNU1IwTWtHNDF5RnlP?=
 =?utf-8?B?NmVSeG5BQllDM0MwMU9XVFNvY0docWxaS0FDYmNJdGJxazZHQUZjb1kxL05p?=
 =?utf-8?B?V3lpSjU5OXUxOWNzeWZXeXZ5TER0UGxnQlEyOWYybi9lcmhLMitaQUprRjAy?=
 =?utf-8?B?TFBlTTFRTDljOExWekVIYTNTRXFPRFhqSTFJajlmRXQ4RllWSys3aHlJNGo1?=
 =?utf-8?B?bUlnSjdiVnRHeFZ5R2h1Z3BMSmJPTzRDRHg3NHZyaCs1TE1iYW43WUc3YjFi?=
 =?utf-8?B?NEVpUjZ0K2xIbDBjU2ZnQm9reDYrZHBNV3JVaVdMWE1WMEFtdG5WK2RzSWtO?=
 =?utf-8?B?WERleDQrTEk3NDdpUjVRS290djIxdE42V0xJQW5PUTR1ZTY0VkZaKzJ6bVRD?=
 =?utf-8?B?NHRuZDFvVUtWOXFxdXpCdlhwKzQ1djhOR2hwQ2xEQ0hRbHU2cG96U1h1S2g1?=
 =?utf-8?Q?0x89r7yHbCHVMzhgsIsiIig=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e5a785-ded5-4e1d-aa87-08dab58e8e6f
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 07:08:30.9137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07yQofNbQ5kVMErQLSWOKsDWB2J8TK78hPtTX3raDfQNrZ9uToQfkhDUVZ0FROl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8745
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/10/16 20:24, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
> dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
> b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
> 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")

Hi Greg and btrfs guys,

I'm not confident enough to continue backporting this patch (and its 
dependency) for older branches.

This patch itself relies on the new function fill_dummy_bgs() to skip 
the full block group items search.

That function is the core functionality to allow us to mount fses 
read-only with unsupported compat_ro flags.

But if we backport 42437a6386ff ("btrfs: introduce mount option 
rescue=ignorebadroots"), we need the "rescue=" mount option series, 
which can be super large, especially for older and older branches.

The other solution is to still implement that fill_dummy_bgs(), but not 
introducing the "rescue=" mount option.
This means, we will have some moderate changes to 42437a6386ff ("btrfs: 
introduce mount option rescue=ignorebadroots"), but at least no full 
dependency on the "rescue=" mount options.

I'm wondering which solution would be more acceptable from the POV of 
stable kernels?

Thanks,
Qu

> 68319c18cb21 ("btrfs: show rescue=usebackuproot in /proc/mounts")
> ab0b4a3ebf14 ("btrfs: add a helper to print out rescue= options")
> ceafe3cc3992 ("btrfs: sysfs: export supported rescue= mount options")
> 334c16d82cfe ("btrfs: push the NODATASUM check into btrfs_lookup_bio_sums")
> d70bf7484f72 ("btrfs: unify the ro checking for mount options")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 81d5d61454c365718655cfc87d8200c84e25d596 Mon Sep 17 00:00:00 2001
> From: Qu Wenruo <wqu@suse.com>
> Date: Tue, 9 Aug 2022 13:02:16 +0800
> Subject: [PATCH] btrfs: enhance unsupported compat RO flags handling
> 
> Currently there are two corner cases not handling compat RO flags
> correctly:
> 
> - Remount
>    We can still mount the fs RO with compat RO flags, then remount it RW.
>    We should not allow any write into a fs with unsupported RO flags.
> 
> - Still try to search block group items
>    In fact, behavior/on-disk format change to extent tree should not
>    need a full incompat flag.
> 
>    And since we can ensure fs with unsupported RO flags never got any
>    writes (with above case fixed), then we can even skip block group
>    items search at mount time.
> 
> This patch will enhance the unsupported RO compat flags by:
> 
> - Reject read-write remount if there are unsupported RO compat flags
> 
> - Go dummy block group items directly for unsupported RO compat flags
>    In fact, only changes to chunk/subvolume/root/csum trees should go
>    incompat flags.
> 
> The latter part should allow future change to extent tree to be compat
> RO flags.
> 
> Thus this patch also needs to be backported to all stable trees.
> 
> CC: stable@vger.kernel.org # 4.9+
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 53c44c52cb79..e7b5a54c8258 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2164,7 +2164,16 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>   	int need_clear = 0;
>   	u64 cache_gen;
>   
> -	if (!root)
> +	/*
> +	 * Either no extent root (with ibadroots rescue option) or we have
> +	 * unsupported RO options. The fs can never be mounted read-write, so no
> +	 * need to waste time searching block group items.
> +	 *
> +	 * This also allows new extent tree related changes to be RO compat,
> +	 * no need for a full incompat flag.
> +	 */
> +	if (!root || (btrfs_super_compat_ro_flags(info->super_copy) &
> +		      ~BTRFS_FEATURE_COMPAT_RO_SUPP))
>   		return fill_dummy_bgs(info);
>   
>   	key.objectid = 0;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 7291e9d67e92..eb0ae7e396ef 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2117,6 +2117,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   			ret = -EINVAL;
>   			goto restore;
>   		}
> +		if (btrfs_super_compat_ro_flags(fs_info->super_copy) &
> +		    ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
> +			btrfs_err(fs_info,
> +		"can not remount read-write due to unsupported optional flags 0x%llx",
> +				btrfs_super_compat_ro_flags(fs_info->super_copy) &
> +				~BTRFS_FEATURE_COMPAT_RO_SUPP);
> +			ret = -EINVAL;
> +			goto restore;
> +		}
>   		if (fs_info->fs_devices->rw_devices == 0) {
>   			ret = -EACCES;
>   			goto restore;
> 
