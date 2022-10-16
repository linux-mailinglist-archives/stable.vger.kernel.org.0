Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38710600415
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 00:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJPW72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 18:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJPW7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 18:59:24 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140058.outbound.protection.outlook.com [40.107.14.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E25932DBE
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdjmPnPLxWpvbJr+P5NkzXCVBvQi/RmunYCIY2bezNA1l/EwmgJ6tvspiVgHVrw/NQGHDlnTvFyXpn3+WzeADLgJasOKQzp4PDbOMsPRDHnGo3evN0fMYIyS1IlWVTO+APey/r+gxHSMgWFd6Hi/kyOOXgcw2X7bJp1Foz0pqeAdojgVdmvurXmygVTBy1heIL63d3khYTOkRTIJUkEtZ398cJpgaUEYax4OZq37tDC9ssBWA3pYwh/Y0r4Ra4r1r4cD5vS8sdXCfqLl3GFXMkaoOH9DYkmepu0JGZ+t8DChLCtL/cfbBbWdnUebzTnIyJzT4ncQFnBtAdQfiO2siQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leds/0Wh2V3GnOOSUZqKgh3bE0m3sNc9otCMAuR4d5M=;
 b=Es1YIzeTvsT/jHyBfrml/xB2V5kZctc+Pl5/a13axTriBSWoshyRE94dLeABgcLHDLlb+OAjPwa60w/jdGIZmpr3Qt2+rYV301fPl1/1Bq7jKD+5qSUgVmPBGR9aMSZ3ACmcFnBe6bOx7vz7K+N6k02tSviBFUOCr/NMEuukqOKXcWvbM8CPWqNhQl3atxCwbk7ctOOKMZWve1vNmRtNgcUEbYcVfpHZo8QzDwfYQObAwAHMLGkETbsdl364I0JG2oVE7YWksyGGGAvq+13gXooS0eax0nyc6E67kHjudWouE6XvHsKiq0UVQwVuBOlsZZAp/Ya7qH62sW4fZOaHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leds/0Wh2V3GnOOSUZqKgh3bE0m3sNc9otCMAuR4d5M=;
 b=Z1BXkg0l8YsmCaQKcluYR+O2HXrf2L74Y0j4GMOhrSFm4MOulYT5/JFl0Efw+RuC/DxBwQ3hG79Hqu2WffzOjuSjbNcfPu5Vm76TwXWpZWKriDQsl7XIkxeFAd6yazQSQeXRYHQmZrIPCV+fn8W28t9kDJov2Wu9NYPEwH+ndyWeHEAnAWa4tNjDhzXyqVeDhU8irKAV1cbNH00PV0+U0NSUXyMXld0UeNCW90leWBkjGJNyEo4b5eGUEsH7qINesz8vy0LTh8RRAKe2tQ+ZC3JsL6AOW/65FhdjrIWrei/EKfBLx/Wi9JwsJcVSrbHHZGb/JbNoX6Z9zybDZxM2gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by AM0PR04MB6770.eurprd04.prod.outlook.com (2603:10a6:208:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sun, 16 Oct
 2022 22:59:13 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9%5]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 22:59:13 +0000
Message-ID: <20403694-0d4f-38b3-643b-c09e745f4bd8@suse.com>
Date:   Mon, 17 Oct 2022 06:59:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO flags
 handling" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, dsterba@suse.com, nborisov@suse.com
Cc:     stable@vger.kernel.org
References: <1665923107172110@kroah.com>
Content-Language: en-US
From:   Qu Wenruo <wqu@suse.com>
In-Reply-To: <1665923107172110@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::29) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8465:EE_|AM0PR04MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba23ccb-1190-4018-0ccd-08daafca0afb
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UioNa8nIuQzzqCm6P8S3F64YgqRv/famr0FqrgN8ke3qX6Jk2Jl4zHg1ZekDtlVg4QcJNVU+VrD8QI1F1Q6X6TzSBkKkO1e+LTblSnL4PE89Sx9fmRs/SjVudmEwAAt8R7mBQWk1WNQlm5jYu/VOpH+iV0OQRYR+1Q8frq4LE/HgomN8yKwYV5SMMtZfPNGLNaW0bDe+HcTcU+BBukgt/G0VfpZMlkppF2aDfaKMAspkp7rPIp9Ce9j2A5qM6OCWFDkB2rqFljjcAxkt3Upz6oMuM1mngQJTIgJVheaTVN52+GuMp2S1Ut8XShIzJzzZvbtiABHPbZT2hosk9EkFYndIq/nUi4Ij8JfbswYAqZrD/QfsaarfXX+MBO1j1p9byM4OFifqAIzssE+JjQbEZWPwFId8ybQotSfqN1MQiwyHP4DDtRCCGrDwmrTrWF0IS1VXfzzrXSZy80+9+UTtb2N40sKWBYstt6Aqf9biEWwwg4yhg1GIDLI24as3wUpDtv8B7SWH04Qt/iDXUdaR2PxJI1+IReOPP8DokWcvs7A9RKij6OT70VvacFHBPJuc2as/UvrTp7GIhYJ3Vv0+Cb1jXuKIEg3KFjuej3c7jJ22/NJj7KbE733LHUR7hUfX6lgZsl/w65EAWel3VKQAm8i/9NFIS7tmZe/okw6i4GvopmjRs3Jb6d8ClL3piAw8SzayEVaf+HXoOgt4FZe/3t4Vkr/C9v62cbT3WCpy63tS3WaNENUyNRkPEmUpIgizPNt+w955Nr30zvr4sNIZqQZ34YPDPqjVrSQxoA0eie8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39850400004)(136003)(451199015)(186003)(2616005)(83380400001)(31696002)(86362001)(38100700002)(5660300002)(2906002)(41300700001)(4326008)(8936002)(8676002)(6666004)(478600001)(6512007)(53546011)(6506007)(316002)(66476007)(66556008)(66946007)(6486002)(6636002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVJVaEhnbDV3SkViSnRTcVlqUWdNNjJRQStHc2dEZ0FBcXVmZ09kN3Z2d2wr?=
 =?utf-8?B?eG40cnc0clFacnRaMm1mMUsycHFXNGNqbCtydG4rUnc3dVVJdHo1VzJNM3hC?=
 =?utf-8?B?cUZFa3RzQUlCWDBoRnBUVnJSMFBucUdSRlJtdFcwWDc5Zm1qbGh0VURZVTJ2?=
 =?utf-8?B?d3l5S21NU0ZrWTlBaHd1QlZjQTZpMFRxRUFFeWhucWo0dDJMT3RPNzFWc0s4?=
 =?utf-8?B?OE1zd0FpdE9KVW8vZW4yZ2NaaDNQTHJjbDhzbmFTQnpzSGhqRWk3cjF2NnVI?=
 =?utf-8?B?dFVFRkczUnlwKzl6NXVIOXpNU3YwYVRtdjRiQjVrbkU0UjVnMnZpSE5kSGYz?=
 =?utf-8?B?YUZjRjRMQy9DTmVvU0U4VHdaSFJnNkxoN3owdGVEKzh1SUNmMHBLNk1qN20w?=
 =?utf-8?B?cmRaSU9kOUZnSEJwV20wVW80K2YvU1lVSjZtWndMOFBUZVBVK2dleFdsaVcw?=
 =?utf-8?B?Zjd4cXBibWpLWkEzOFFITFJhSzZ4ZnVqYVFtVE1pSUdwRy9uQ3Nzd1dTSkpQ?=
 =?utf-8?B?TytpRWxuY3MzZWs5eStibHBzMGR1UE8rMWtYZ1gzWXIxVWFNRGY1UmNDN1Yz?=
 =?utf-8?B?VmdZLzdnbTRGSEVraW5mK2p5MFhPeUg0V09YWjRSMnBLcHliT2VNLzBpZ1Vt?=
 =?utf-8?B?bUM5QlovVEF1VXF6bXNYNDc0MnFVNDEwUHhoSjltRmd3Zlo3SjBINGR0MEtK?=
 =?utf-8?B?Ti9JeHJteTVEYWpBT2s0NE9qUlhrT3Q2WmhRZUVkaXo5TGdwVTJVQ1JrZEwx?=
 =?utf-8?B?dHRCS2o4bFcwUnF3U1A2a2JQd2tVK1dUOU14QlZyRDU5MDZ1OWt6RFE5alpR?=
 =?utf-8?B?ME9zMHhNVDZObDluUjlxOFpLOXYzTW1HUnk3MEh4YTdVTTVSYUVicVFqbTdW?=
 =?utf-8?B?MGZpMVlYbkt0akxoekljc29adUs0QWtac1FZeFVuSWlPS0pQcW8veE5YbXFn?=
 =?utf-8?B?Y2djSmJENEMyU0QydVc2MStmN3dWQVFycGJtUFArNm1UaDY5eVdUci9aZ3ZG?=
 =?utf-8?B?WDM4OUd4Njl6Z3Y2M0libVVFL2NGOVRsZlpwTm9EODZOd1VlelZVRHJJZ3dN?=
 =?utf-8?B?NThGS0hJVnBqb0tZb21EaS9KOGR6TDFRWjhxTXd0WDhrR05YT3pKVk9FRWdv?=
 =?utf-8?B?czRZZGRnZERYNWVmb0I5cTdHNzdFOTBLdkJOejZCWStSNXFWL2lGVWs1Q1FC?=
 =?utf-8?B?QU1ZRXI0OVoyWFVvRmZhcFJ6M2dpWUgxOGtlUXhLSyt4NjdpNDRCQjBMd25Z?=
 =?utf-8?B?aGNoRVF1Uk9mMGVVVklYY2RFQmRqdE4zTUV1bGlJTS9OZW5DMzlRQmdhdlRI?=
 =?utf-8?B?N3lCMzFkUldMaXBQeDNNa21lMmFQOW9FZW9OaGZxM1phOWlUdW1JazdtbkE4?=
 =?utf-8?B?V0NURmFoUkFSZDZWd3NvSW5MWmsyaGNaL3dNT2ZwMHhuaFVweXZkK3g0Q0Vw?=
 =?utf-8?B?QW9jZERnd1lpVzBIVmVxTFQ0NE1LSzlGY1gvNlpTUlJNbVlsVW1HSktJOGF0?=
 =?utf-8?B?VlYxVys2WjA4R05LWkZKRmo0UTFpUTlzam5SeHI4UWIxcnplQnIwTS91dmd4?=
 =?utf-8?B?V3NCM2VuenkyY3kwSERORWhONE1yd2VJZDh2VzFRV2hZbHdFd2wwRHY2TTlo?=
 =?utf-8?B?K09BemVVcGJCN1lIZVdIY0NObXl5cXhvVm93MktGMTZlS0xGVW1tL1ZxQ2ZH?=
 =?utf-8?B?NCtQeXIwUzRpSURkWktUUlRrT2s2Y0lGUDhYK2c2aGU4TFZBTGwxSTRCbHRH?=
 =?utf-8?B?MWV5VUVHNXZIOHpkang4bUJyNi9KQWVDcEdrNXQ5bkNTRlMrb3o1OVc4VUV0?=
 =?utf-8?B?ZW1PZG9IOUFjTzgycGZNRkMvN0t0NGROQm5vcjZuSUJtcFNJa2hLUHMzNTJk?=
 =?utf-8?B?amwyU1FSTkRFOXFZejd6aGRNUWNEWVYrTjZ6K0V4ZTFqbXpJWXY0bDFnNmVJ?=
 =?utf-8?B?UTIvdk41YVVpS1VmUlZ3K0lVTGlLa3dEVjlBRmtlZkFVeFo0RmJCQzFRYkJv?=
 =?utf-8?B?eFR0bzkvSXVBUUowT25iZkp0bDh5bEdPYnlRcTR1d3RSNnR2UU1CNU5TQ1Nx?=
 =?utf-8?B?dWh3SnBCOTdWWEJYQ1djRk5zbGtGejI5djN3bFpld0M1b3Y5NUJxVTNhVUV1?=
 =?utf-8?B?SmtIWWlROEppY1VVa2pDWFErNFEvSldjSlZRVnVPZWRYcU83Y0c2SzhaRmxn?=
 =?utf-8?Q?Hv7qyONfkjTYHtFZdAGbx6o=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba23ccb-1190-4018-0ccd-08daafca0afb
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 22:59:13.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPeNwEJS+rXRlDH7fu99CgMVAenmDXpXe6OpwavowmcCZaWd5AOWksrwiZMuVq8E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6770
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/10/16 20:25, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Thanks for the mail, I'll backport the patch manually.

Just want to praise the new dependency hints.

> 
> Possible dependencies:
> 
> 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
> dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
> b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
> 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
> 68319c18cb21 ("btrfs: show rescue=usebackuproot in /proc/mounts")
> ab0b4a3ebf14 ("btrfs: add a helper to print out rescue= options")
> ceafe3cc3992 ("btrfs: sysfs: export supported rescue= mount options")
> 334c16d82cfe ("btrfs: push the NODATASUM check into btrfs_lookup_bio_sums")
> d70bf7484f72 ("btrfs: unify the ro checking for mount options")
> 7573df5547c0 ("btrfs: sysfs: export supported send stream version")
> 3ef3959b29c4 ("btrfs: don't show full path of bind mounts in subvol=")
> 74ef00185eb8 ("btrfs: introduce "rescue=" mount option")
> e3ba67a108ff ("btrfs: factor out reading of bg from find_frist_block_group")
> 89d7da9bc592 ("btrfs: get mapping tree directly from fsinfo in find_first_block_group")
> c730ae0c6bb3 ("btrfs: convert comments to fallthrough annotations")
> aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
> 92a7cc425223 ("btrfs: rename BTRFS_ROOT_REF_COWS to BTRFS_ROOT_SHAREABLE")
> 3be4d8efe3cf ("btrfs: block-group: rename write_one_cache_group()")
> 97f4728af888 ("btrfs: block-group: refactor how we insert a block group item")
> 7357623a7f4b ("btrfs: block-group: refactor how we delete one block group item")

It looks so awesome!!

I'm wondering how this is implemented? It would definitely help 
backporting not only to stable, but also some vendor backports branches.

Thanks,
Qu
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
