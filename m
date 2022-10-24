Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C0609C03
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJXIEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 04:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJXIEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 04:04:05 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C7C5805C
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 01:04:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y33Gm/NPRUGdxZt/wBixsQ50DlMkT9Cs49tKzHyyHr0ht9AB9LDkzaTPLnW6PSK7FLvwpeYsKRTtyz7KIPSJvzVG25czzAdSYaOUDjYultD7UhMLIHz/2e82oHiNwZNT7rqVCH2//89lx6co3RaVDDCGEo+lNmydCU8H0+pdfNjihvF62xekEs3HggWQktyzrDxWbiVGDDtieAE20VcrwhYOLJzSfQ/URdoRe3+dubcpVIOotP/+PibRHRDhl+k1xgSdNsu7caKK9SZkultqgkA77rAvV36x3aMxGdmi3xdvju76h1AEkfJJawDelGqljBoYgDZjj6Ry2RCXCJnwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/NZG1qb/eUCKTlK8rvMoSM8pqd5rUKrgcFIQGxaRzY=;
 b=kYPqCf9bZogz/g9vATlJFYbihVtRibAh5ciFdQzs5gQWFiD3hdvLZTh5spE8oZWbKLTyCfxgSc2veXKx8m7RY7Is/aBep+32t/wZ6AnbAfOQm1spGkAk52V9ubsqwzkMJT36a0LmLmiWeWpyUcVwQZm9to1ftrTADsZmP0LeL7i2sgpbERrDwzH8lbrei4mzAwez06QqfKznGkPUE5fKSJkrVFk+ltBn8VsfeQ+b6TNGBay7cOhob+KUe3COHvyBjVKCNzKc6eAV9Uot/wN8m7oQ5jGXqLfee7B12RKjY9di9UdI7BxjYmxo8Ku33R83T2mW41llcu72gffyfV1EDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/NZG1qb/eUCKTlK8rvMoSM8pqd5rUKrgcFIQGxaRzY=;
 b=fR+MRarZFtgi7U3g0P026XPqgMNgtn56qOrxlZny29FM58/ibUGywz9w82UEzPhRbcCkVOjcF9AtnbB9pD6QkuLWiWJGxG0ys+9Q8UfTWArty5NxFXAR0DLlhueUWoM5it2gNaTm3remTXIsPul52EXQnXMqB9TH8OUNYcaCt1tcRxf0Fy+lGb785M9njbiBlCeVyKeVIBXwXoFGBcDHDr7r8pcxBNpxamJNtS7nb9J3CTBicSG86MuHyeK/Yan35IkrZng/iuQyKvOC9tK2JSftnIuK3eq2KGoNwnQFzCszqXAugxaYl91NON0BIZg2ts4CwewLkheTceJP/PXAHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by AM0PR04MB6804.eurprd04.prod.outlook.com (2603:10a6:208:189::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 08:03:56 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::3a32:8047:8c8a:85d9%5]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 08:03:56 +0000
Message-ID: <6a6e5158-98a2-be31-fa5e-20e3b18af068@suse.com>
Date:   Mon, 24 Oct 2022 16:03:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO flags
 handling" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     dsterba@suse.com, nborisov@suse.com, stable@vger.kernel.org
References: <1665923098198193@kroah.com>
 <6f9bd9ba-ac8b-4ec5-d4a5-865d5546fecb@suse.com> <Y1ZC8sOqXE5I7EoO@kroah.com>
From:   Qu Wenruo <wqu@suse.com>
In-Reply-To: <Y1ZC8sOqXE5I7EoO@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0076.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::17) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8465:EE_|AM0PR04MB6804:EE_
X-MS-Office365-Filtering-Correlation-Id: bfef5ef4-d819-4f35-a031-08dab5964cc4
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1aiRS2qvDglAmW7WFahnH2QQ7Q0y+RP1tFvhRSX6bntiUcbybC5TqZ0ZCpiZSHo5wQk26YLFSe6bsEUe9NlxU82bnNzr1VLNMPTERPrLq++jMJzd5G0EQOSCTVeNGnK8f6SbU72fq2ANaSmE9hT2u6AA96QFY507bvLFTh0dPYGQoAJYUKPf4eM42Q3pIQEMW8BRP4HWwb0NPY79lcJiL4hnOwsiQpe/pkNp9uOmOgluN+HpBjfTsfQvoQhkEBDy9qHhGzUr9TTo4aWdk5oQwKBoAYM8M0AWEiu5r8EaxOPPJU+wmOHRrKumau7k2+amTTX6WzJy7yJc1B1P3fJKGlxnZ81uakBRSJWTrh71IU6nTS7/L0xFvsKGHP7UcKvzS0qdA5w3bJmeSR3TfzV7J+OIpbZtqgeNsUDteDVPOSpfMnwJyvfVzJIpaTqM2l64mT1MFr8xM2PoycJgT/D5MfNhb9fqnUglLY6guO2UBu3ZPn7F27F8LLS+tDwwevG/Zk5J6Ixm4+qP5vt33W6lzua1GDppPTSguU0iCPGlBW+QbkJ3XTTxD5aCxKzwPPR6vnSKDGyrTxWmqNew1ErGKsG9H8tvEZPFWTOesS76lTi5458zszzl1PtdZv+1I+Vsg8VdrcjVNQEIYqge5V2PT2BOhC7yBUAeDtbL4k+uHQ1lNhWRK1yrky5uRMC1qzh8Bov/f3R2NdV7rAKM4607tQFUdpLsHWO2eWVCnKEtc4sNoFqg6nI3BSJruK/8LJbHCga9K8XcugWVhWrEVcF4T+K2Jr12E+ixqEJalFULKcA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(31686004)(6512007)(36756003)(86362001)(31696002)(2906002)(38100700002)(186003)(2616005)(83380400001)(6666004)(4326008)(6486002)(53546011)(66946007)(6506007)(316002)(8676002)(6916009)(66476007)(66556008)(5660300002)(8936002)(41300700001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZIQ0Z5SVhNaTUxUjFwQ1l1RjNxbGZ2aU5MWlQ4ZXVnY0ZCS2d0RFI3TFNH?=
 =?utf-8?B?L2U2Y1pZanZrZE9rejI4clY2QVJ1VlVtRkEydDZORjN2U3NZaUxyRDF0aG56?=
 =?utf-8?B?VlUyWmhpdnB3OGVoOTBQVVExc0dtV0hLbmR4OGRwMmF5cjJQbTUwempaYy9U?=
 =?utf-8?B?NHkvNTdwNzZCK1dzVlpYWHFHUHpHUHRWTHBIMno5NDdEamZoNDFZNndnc2ov?=
 =?utf-8?B?Q1lZdzVyUW53QVFWeDhDNllOR1JQbXNCb1FTaXl3NGQwaEp2cUQ2OGFTVnVZ?=
 =?utf-8?B?aWNPZEYrc25kSWFKZHNjVmp2S2pZRmRpeTZIK1QyUHFFWEorUlpxa09OT3dY?=
 =?utf-8?B?ZWxFK3YrY0tmc1pIUmtrQWNUKzF0TnpQaTZHc1hwbnRWRzVEdlY0ZkRzTmZp?=
 =?utf-8?B?cHdMVGdCNnZPNnZ5TG5hK1lNUmZ4UjFvaVhjOXFQUlF3SEZIOEFNTGQ0OEth?=
 =?utf-8?B?WFdLdmZ3bE90U2hIbDNVRWNQblFnNGRLOG9QQkkyRHY4bTlJRWVMWGFVNldG?=
 =?utf-8?B?TTg1ak5EQmdEM1hHSnl0Y1k2Q0VmZzFsWlVmV2Q0NTk3d09IVjRlSTlIRXh1?=
 =?utf-8?B?bmRDNnZ5VUFkelZxaTN6dXM3SVljekVUa0dydStqcURuN2ltSTFUNVAxTmhr?=
 =?utf-8?B?cisyMWVSSjFRNng4a2p5clgzTE1BcnZBb2hMWHZKSnZIS1l4SUhPNzVSekM4?=
 =?utf-8?B?NTliTmNSbnVlMWx4Y0YrRGNldkxhcTRWaEdrSStJQk4zUjhPckJxa2tFUWtD?=
 =?utf-8?B?ZEU4cWpDNXcxaEFkZnFjOSs5RkdrQi9lM052UjBIQW55L1hxSUM5eXA4dEg4?=
 =?utf-8?B?RGVORW1jdnh3NDRzWU1CRDI2c2JMNW9KQlQ4LzVMRXpMcCtDUWNheHJ4NExR?=
 =?utf-8?B?N1NPYkZWTzcrNFFFWEM5cy8wSVJvMk5xaGFCdXlMWDNoNmIveitaeHVJeUEr?=
 =?utf-8?B?S1l1VUkzelVPNEJjNklRWkxTS2Y1S2JKNjFXSjZvLzhpTHMrTkJFRDRuT0xU?=
 =?utf-8?B?UW5oeUwrNkptYUZLUDNwY0tlV0Y5N09QbkxNdTRSajdzdVdnZUN1SGxPZjhO?=
 =?utf-8?B?bG5vTlhTUUZWSjlQZmtpcGdDZ2hnTUJWVW1RRlhqMHgyVG82ZUcxaS9LZisv?=
 =?utf-8?B?UVRhUnhNeGp0K1dBZVAraXFZOXJHYjVXZSsvQnYzQ3RsN1A1MGZIdXhjUjBW?=
 =?utf-8?B?S25PMm9pN0xJdWg4eUd0aXdHRmozSzVML0RwajAycUpuWnNLT2RoVThkb1Bo?=
 =?utf-8?B?MzlLNzhxdDZoK0YrdEE2S1VSUGxUK29VQUJaMGVuMEdWMFV0Sjd3MEl3L2k5?=
 =?utf-8?B?YklNR0tmbzV0K0xUMDhXelJWRHVoWWhveWR0QVFIOUlQZ1BpTExST09wOXVD?=
 =?utf-8?B?NG5IcnVDeElWUWgxT1E5SHNmMngvOHBVQUVuRWR0ZTBGRXRSeW9Gc2o0TWQz?=
 =?utf-8?B?NGpiTjZuelg0dzFpbzRnWmx4VUthdWQzQUl2aElVbjZuYWpRRDNjcFJzK0Q1?=
 =?utf-8?B?dUNhOHZIL0w2QXhUeC9peTJHaktmUGQ2YWRLTnBrQy9iZWY2R0lYTzZsSmg4?=
 =?utf-8?B?VjRtWklIOTh5V3ZFYnZhc3VpWG1WM0QwZS9oMjZycXVMWnZ2Zi9kUEIrbkZM?=
 =?utf-8?B?ckI5SCtUL3hha1QzQ0Rhd0QycExkSTJrNmxpRHNKZlA2b2RrdnoyeVl6UnBj?=
 =?utf-8?B?L2Q1cktUMmlaUW16bG91NDdVN0xLNW9kekczaHIzM2dEMktFYzk2NWlGRVp6?=
 =?utf-8?B?L3p2RlMwMGljSzRHNVVrZFdydFAvVndZK1BDcTlWQXJlemloREFJTzZGL290?=
 =?utf-8?B?Qkw5UjhwekFwMzZHKzUzOGI0dHluZm9LR21WNGlIbUd0c3FaVWd3cVROQ2gr?=
 =?utf-8?B?RklxRklmQ2lONm53RUJVQThuMHJSM0QxMXE3WnVETEM4Q0dJaW1oRmxCYnlL?=
 =?utf-8?B?cmpJM1ZBNDFvNFdrL2RGMTlyaDhLL2xjZjZsbFBpZE9hMUhiZm4rRUZqOGEr?=
 =?utf-8?B?bWpVdHRQNTFrM01tM1VSQmhpam1ocE9YWnhZalE4MmlTVFJXZDQ5NUZlVWpZ?=
 =?utf-8?B?eEVzSU1obnRFMFRhanRuSGx2ZGlwOXlRYVpqRWNlbWZyZUJWcG1RZFRMNGZ4?=
 =?utf-8?B?ODNtcHZLQ3J4OVh3cUs2ekNNSTlScG03bXpucnhkY3RHZjArSk9Vc0ozUmc4?=
 =?utf-8?Q?Zh3idAWdR+DB5UynqnqQ1mY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfef5ef4-d819-4f35-a031-08dab5964cc4
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 08:03:56.6053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKtqVgclcUog/NG3aUBsROE327hwGPeAFxuLnfIW8giuCoeHArcLKq0XZoWb8jKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6804
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/10/24 15:46, Greg KH wrote:
> On Mon, Oct 24, 2022 at 03:08:21PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/10/16 20:24, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.10-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>>
>>> Possible dependencies:
>>>
>>> 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
>>> dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
>>> b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
>>> 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
>>
>> Hi Greg and btrfs guys,
>>
>> I'm not confident enough to continue backporting this patch (and its
>> dependency) for older branches.
>>
>> This patch itself relies on the new function fill_dummy_bgs() to skip the
>> full block group items search.
>>
>> That function is the core functionality to allow us to mount fses read-only
>> with unsupported compat_ro flags.
>>
>> But if we backport 42437a6386ff ("btrfs: introduce mount option
>> rescue=ignorebadroots"), we need the "rescue=" mount option series, which
>> can be super large, especially for older and older branches.
>>
>> The other solution is to still implement that fill_dummy_bgs(), but not
>> introducing the "rescue=" mount option.
>> This means, we will have some moderate changes to 42437a6386ff ("btrfs:
>> introduce mount option rescue=ignorebadroots"), but at least no full
>> dependency on the "rescue=" mount options.
>>
>> I'm wondering which solution would be more acceptable from the POV of stable
>> kernels?
> 
> First off, is this really needed in older kernels?  It was marked as
> such, but that's up to you all to decide if it's true or not.

This is mostly related to a corner case that, certain compat_ro flags 
should be allowed to be mounted RO for older kernels.

There is already one such feature, called block-group-tree, and with 
that patch, we should be able to mount a fs with such feature read-only.
(RW mount is still not supported until v6.1 kernel).


The root cause is from our uncertain understanding on which features 
should be counted as compat_ro.
Until recently we don't really bothered incompat/compat_ro flags, and 
tends to caused quite some incompatible features which should be compat_ro.

Thus I want to mark this patch for all stable kernels, and push for the 
more accurate incompat/compat_ro flags splitting.

Without this patch, the new block-group-tree feature will just be 
rejected (no matter RO or not) due to older kernel can not skip the 
unnecessary block group items search.

Maybe it's not that important and time can solve it?

Thanks,
Qu

> 
> So I'll defer to you and the btrfs maintainers on what to do, just let
> us know.
> 
> thanks,
> 
> greg k-h
