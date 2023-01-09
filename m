Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E68661E9A
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 07:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjAIGNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 01:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjAIGNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 01:13:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2041.outbound.protection.outlook.com [40.107.20.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E06BA195;
        Sun,  8 Jan 2023 22:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjrvFXS8CRtb3/xt9aflTNcozi5CpGpE4u5mvl6nhdbTUfykThXpKoU5EZe4ZwlOAR+yczOYIQ+dfRdgt9k1EJM4scVfxr2/V4eA/DfnfQLSfPZ+5tCywToCPKWG682k3+l6eeZCxr4fDLEg4Ffe1YkvO0fIB8tETkgPjLy4tLBP239a/SDliCM/mIojVzNDVULL4rCbhcX8S0JcmF4HWYmVolBA5a3kxHqWIZHRWc1Te/usY0unwvhBE3daXas+X3ufHW1kQxH1J4Wwa/pXuZ+7oXMxchJvtNmU59imy/RwZeldrI4fh8c43GtFKLg8h1gwryGs2MTi4KewFDLJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu5Dx6KXwTKUICP/yHFaHGPHvLJaY5Mz3y/kJORJCFg=;
 b=A0IFTT3IIxyKG3m/aJbBTgBLgszxj39w6z1HD3Ars88KJ7+5H633GfVbGmrnng3h/VvumKek6VwyMo9V3VQSxz0OM1ROwRgiXhdotE17Io9tO8jknoT4KsEeF16BOc0JB2Jot4oDD7BTkbxgXUU93ZE9k1ZB4li2O9SZfhPh0S8mdE/mIpcD9LK70aEZySUqK34XJZXF5Ur6z25YQpmqFN8/RKggzuGPQGFZoqqSFH0a+b+c8SR7p0kmqqBMNNAIBx+sY9AQff+EvJh1W+X7FK90pdRPat+yQVHjqZSFmpkr0ywg48U6zwclyfP41AySsNXTorAivuMfMfLOVxp46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu5Dx6KXwTKUICP/yHFaHGPHvLJaY5Mz3y/kJORJCFg=;
 b=DGDO5aTLSPbDphpYdsVwz41iXWMg0vel7gvcpP2wezKeypEasj5bEPiXVGv5hmIB3qkNY4yNXLJhQNuCe88CFKQ4H2LLz4iXFIct1Bf+XQYGu6Sx0WpLTOjtJo/Q/2J1B1IOvv305CKXAG53+WA/cOpjWySmC4VDsNmcXMBQV0od3Vm+Rfl/KJ5lz7azrcTL8vrX9EzSx4NBUEnTs71qdlk50+1PRhZA0n7806P0oiEEiINwpVOz3igW76oXjdUWg/wg9CePzsfKeCy8hNsYBDk1A8DRXu1MdZAdLyCzNU2vBzTT/t5cuaR5L9pLbWkICEzSWmMQGGJfbmW2MEwpog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com (2603:10a6:20b:348::19)
 by PAXPR04MB8976.eurprd04.prod.outlook.com (2603:10a6:102:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 06:13:09 +0000
Received: from AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::5c50:6906:e9a4:5b9f]) by AS8PR04MB8465.eurprd04.prod.outlook.com
 ([fe80::5c50:6906:e9a4:5b9f%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 06:13:09 +0000
Message-ID: <a259d451-c2f2-a8ec-b82a-d2e6ecd6b676@suse.com>
Date:   Mon, 9 Jan 2023 14:13:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] btrfs: fix resolving backrefs for inline extent followed
 by prealloc
Content-Language: en-US
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Boris Burkov <boris@bur.io>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <560840afc3e63bbe5d9c5ef6b2ecf8f3589adff6.1672970015.git.wqu@suse.com>
In-Reply-To: <560840afc3e63bbe5d9c5ef6b2ecf8f3589adff6.1672970015.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:408:f6::34) To AS8PR04MB8465.eurprd04.prod.outlook.com
 (2603:10a6:20b:348::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8465:EE_|PAXPR04MB8976:EE_
X-MS-Office365-Filtering-Correlation-Id: c3512363-e992-4e90-29ab-08daf2089412
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAGe4c2Ty/scyjjsqm2YiLshutSOMSu31wLBqgDMasfGF9btfrYdN/b895a66ebQ2N1YlT1OmfXAIPXPmuSp+l8bTlDH3+SkrS0Se8Zgl+Qe2fTwql1xLhdzyQsfWgR5n+EFJ7xZ+HlKG/ljtXMbfU3K1S+0ejgCog2yxbtneBLQ9N2OHVk+BAv5TfhxQv9R26be/0EJNSxbClF8SiDC+B3sOHDPmnc+tbLPYH4ZZTog1bLedUzLrYkKc876Oq5phsxt0ebjX+XdXNSJXS4OuA4/lt6wV99WpfggBgg4LKTB72pbdNfskarrvEkyPj3aXlFzwuXzqoCcl01wF++Vr4WoaTdxqxR1/QitFdC/g4e6rGLPOToIbSr6ZrzbIdzCy6dIwMiGJxDivmr2CJxQYxwpWjyUtbq7BXmTmQUfih9vUpIEWXQKxsJQRu1pDZYjSCwPPPSBA7DQObpbXrNZy48Vf+bBgT8LPsWwnhdN1/BAuR1hYeWGworDAujANouQnRy1FoSPLxFAQEn9U+hRZM3dBAxWd+lp4zE0WJEuPNDRI6t1LGN18nYZrJGIiKqYH3XgM5ze/asHxK067xvL5UdZeYyJ0MmXVSltbVP0Wfgw27LxRTy0fQB1YV6oJRfsHJbquda1ygNX9LK2XAw7wA4CcXp3I6UOazv9fvya1UGZDFAT+hDgmhEvrBeazZ94AcmN5b/TkZ/lgFiafk97AaMdZRrRvQz2rgnk9j9JUd4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8465.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199015)(36756003)(86362001)(2906002)(5660300002)(8936002)(41300700001)(83380400001)(31696002)(66946007)(45080400002)(54906003)(31686004)(66556008)(6666004)(53546011)(6506007)(107886003)(38100700002)(6486002)(8676002)(316002)(66476007)(4326008)(186003)(6916009)(2616005)(478600001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlBLUmhLWXViMU9DcmxDMEpNak5kYmxYczZZN1B6MXdSZ0xxZzgvUnlMZ09k?=
 =?utf-8?B?WUFhWDhnWVVGVFQ3aDcwNjVCaUVpcTRwbHlreFZ6bXFuU1RWbmxYQnd4MElt?=
 =?utf-8?B?K3l2SUY4TlNCR0VqcHlVUlh0UkVLa3JQSk1BZ0ZqNlN2aXUyK2xvYkg3VGpm?=
 =?utf-8?B?OVNBeTlQdnlTdVJ2UzdDTnZsenV3SXlLMS9VbkRkQU1NNXh3YWl6UnJZY3Np?=
 =?utf-8?B?UVROTFBpN1lXUFlvWUJYUk9oZUpVVFk5Z1BZdWROUVdNTjl6UjhEOG9BdUpJ?=
 =?utf-8?B?Y2h4TVlQSlpRdkZ0dkFrZ1YwZHREK3pTZGxIZ1A5VEY1WG5HQkNrMmk0eEtU?=
 =?utf-8?B?K1c5Q3oyN2xBN3N5NEtyS0RJZmdRNWhwakNoV0xJVEI3NkZJY2VvNWhFTXRX?=
 =?utf-8?B?YVJtRUNmUXFSdExtY1F4VFhaV0Z2LytvUHBYYWFTWUIrVDJEUVV1Vjk0L2hG?=
 =?utf-8?B?T09vMWpHR3JjNmJJNEhYS1pTNkN6YXVkTXZzZWFjT0Fob09oSDQxbWZha096?=
 =?utf-8?B?Unk0amI2VkRKb3hRTVpLY2hva09Vak5ZTzcwZzZGcXdhd25GM1JtWHJxMUlR?=
 =?utf-8?B?d2hIUVh4MmpxS0xXc29SWnpRQmZqVk1CWWliLzByRjUydStaNUZDNGJaQXl0?=
 =?utf-8?B?VFhsWS9qRmhwUUlicy8rYXQ1SE5FRlBVTGJNb3dxZDIxVksybTNraGdjS3hC?=
 =?utf-8?B?SDZ2VGpnNXVvMGxSTUR6eGJBSjBwNTZtOTI3VENMNnhtNC82M0RNS1U3RENY?=
 =?utf-8?B?Yy9MK3o5RFIxODQ1a2lheG5WM3pWSUtOQ0lTcHdHMnBkaE9QMlpVdmluR0dj?=
 =?utf-8?B?Yk1sL25Bb2NqVDVyc1B4b2N4ajdZYllReENQL0lzSEVMZEpOUWdrWTNLczYr?=
 =?utf-8?B?UnpoSUFCc2t6amxCT2RmK3l2a0JpcjhZM3RyOUZTNGMrU29GT3VINmVsSG5i?=
 =?utf-8?B?cEIrZkhUS3Fieko0RlBubXV6dnMrcnNOZkRGU2pFU2FJSWpTbmVtL2xiM2pW?=
 =?utf-8?B?YlArZ2pIclVVY1pveEp3dVArYW5scW1aOWI0ODh3RTRjOGt3MWhsK1JYNGpK?=
 =?utf-8?B?a0daK0lBeTE4bGtQeHN6YjJybWkzRVNsbGFsMGp3b2oweUdwMUVJbTdIN3g2?=
 =?utf-8?B?RUtsWlU1dXdINWJTeVNWOGFCckpERHA5S20vOUpiM21xNHAxdk1aYWVLa1l1?=
 =?utf-8?B?QWRRc1NxdkJ3ODliVXBEVG85UHFBWnBtNVQrNDR5c0hoajJ2cjR1b1hjSXpt?=
 =?utf-8?B?bHpBdXpkRmRxTVlmMytDdzZmVTg1Ulg3d2N4dGYraDJyUE8rSzAwWmxHVFlz?=
 =?utf-8?B?RGdmTFFMRysrUkY0MnVPRkxub3hiWS96YXRzN1F4MThzSU84V2oxRVRxSEkw?=
 =?utf-8?B?am55ZVNHV2hla28zaW5WRHdrcUhqMXBqcGdHZ1AwZUZYY0dLa1pxMlo2N2NF?=
 =?utf-8?B?OFVpRTJhTmdtTUN1M2VXRGVGemtabVZwSE1PVE00Si9aOVFkakx5aVFMY2FF?=
 =?utf-8?B?MWZGRGhPT2FaVEdkVTY1MHpkSVRJWHhURjBqTllhaTQvZDB1RUhmYjY0OURT?=
 =?utf-8?B?YTRTRFdYVmovdyt2dU1KMDRIUVpObHFJbEMwZnZIeW9LUlJzblltMkJJM0xr?=
 =?utf-8?B?NW5memFZeDIzWnpMbWM3SEVFMUtqVEVKVnBvcmc2ZnlkVmpXcFh4MWltM21M?=
 =?utf-8?B?Nys5N1Q5ZEIxSkxmQXBBMlJnV2pRYjlhcjl5blA5VGpvaW5Sblp3bGRGejNX?=
 =?utf-8?B?cXAveDRGMGg3WWRQQU45ZThZMHVsTTF6eGdwSTQvSGhKQjNtQ1JOWkZ1N3dy?=
 =?utf-8?B?V1hLeEE4UllWNWxTMkZ1NDhKbEcrc2ZUUUZoTFcvQVVOM1RrTWFmeGdNNjdC?=
 =?utf-8?B?dnRCS3c5VlYzNDJUaElUWE5ZeXV4c3YrWU9WdWJYOVJmNDBVbGNIdDM4Wm1t?=
 =?utf-8?B?SWNwekxPYWZWTlhNVTFpRWZralNGbG5hbWV2SXFzZThVQmRZdktIZFNjOUMy?=
 =?utf-8?B?Z2F3dURnbDNBZEtYNlNlQTZIRUNNVUJmMGJyL3prTG8wSmIyNURtM0k3TUlF?=
 =?utf-8?B?RzY4UEl1SGxQVnZHWkRkNnRqY2xEMjhOQW9ja2ZvOStMWU54aTZWM3FkdUlG?=
 =?utf-8?B?SHEwQWdUYjFPWWJhSTNXbzZWWjNQMUtpWUo3ZGVHN2ZSL0VqQWFKdW9zL0pG?=
 =?utf-8?Q?8erkpAgmwkY4vPKOE8sutsE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3512363-e992-4e90-29ab-08daf2089412
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8465.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 06:13:08.9705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZiarCtWlWUYhoI56TBYnWdfTYZYJtJI4L3Kq+XFGUlBbVGbOxwP3NB34/SlC/c7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8976
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, this is an internal backport.

Please ignore it.

Thanks,
Qu

On 2023/1/9 14:11, Qu Wenruo wrote:
> From: Boris Burkov <boris@bur.io>
> 
> If a file consists of an inline extent followed by a regular or prealloc
> extent, then a legitimate attempt to resolve a logical address in the
> non-inline region will result in add_all_parents reading the invalid
> offset field of the inline extent. If the inline extent item is placed
> in the leaf eb s.t. it is the first item, attempting to access the
> offset field will not only be meaningless, it will go past the end of
> the eb and cause this panic:
> 
>    [17.626048] BTRFS warning (device dm-2): bad eb member end: ptr 0x3fd4 start 30834688 member offset 16377 size 8
>    [17.631693] general protection fault, probably for non-canonical address 0x5088000000000: 0000 [#1] SMP PTI
>    [17.635041] CPU: 2 PID: 1267 Comm: btrfs Not tainted 5.12.0-07246-g75175d5adc74-dirty #199
>    [17.637969] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>    [17.641995] RIP: 0010:btrfs_get_64+0xe7/0x110
>    [17.649890] RSP: 0018:ffffc90001f73a08 EFLAGS: 00010202
>    [17.651652] RAX: 0000000000000001 RBX: ffff88810c42d000 RCX: 0000000000000000
>    [17.653921] RDX: 0005088000000000 RSI: ffffc90001f73a0f RDI: 0000000000000001
>    [17.656174] RBP: 0000000000000ff9 R08: 0000000000000007 R09: c0000000fffeffff
>    [17.658441] R10: ffffc90001f73790 R11: ffffc90001f73788 R12: ffff888106afe918
>    [17.661070] R13: 0000000000003fd4 R14: 0000000000003f6f R15: cdcdcdcdcdcdcdcd
>    [17.663617] FS:  00007f64e7627d80(0000) GS:ffff888237c80000(0000) knlGS:0000000000000000
>    [17.666525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [17.668664] CR2: 000055d4a39152e8 CR3: 000000010c596002 CR4: 0000000000770ee0
>    [17.671253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    [17.673634] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    [17.676034] PKRU: 55555554
>    [17.677004] Call Trace:
>    [17.677877]  add_all_parents+0x276/0x480
>    [17.679325]  find_parent_nodes+0xfae/0x1590
>    [17.680771]  btrfs_find_all_leafs+0x5e/0xa0
>    [17.682217]  iterate_extent_inodes+0xce/0x260
>    [17.683809]  ? btrfs_inode_flags_to_xflags+0x50/0x50
>    [17.685597]  ? iterate_inodes_from_logical+0xa1/0xd0
>    [17.687404]  iterate_inodes_from_logical+0xa1/0xd0
>    [17.689121]  ? btrfs_inode_flags_to_xflags+0x50/0x50
>    [17.691010]  btrfs_ioctl_logical_to_ino+0x131/0x190
>    [17.692946]  btrfs_ioctl+0x104a/0x2f60
>    [17.694384]  ? selinux_file_ioctl+0x182/0x220
>    [17.695995]  ? __x64_sys_ioctl+0x84/0xc0
>    [17.697394]  __x64_sys_ioctl+0x84/0xc0
>    [17.698697]  do_syscall_64+0x33/0x40
>    [17.700017]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>    [17.701753] RIP: 0033:0x7f64e72761b7
>    [17.709355] RSP: 002b:00007ffefb067f58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>    [17.712088] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f64e72761b7
>    [17.714667] RDX: 00007ffefb067fb0 RSI: 00000000c0389424 RDI: 0000000000000003
>    [17.717386] RBP: 00007ffefb06d188 R08: 000055d4a390d2b0 R09: 00007f64e7340a60
>    [17.719938] R10: 0000000000000231 R11: 0000000000000246 R12: 0000000000000001
>    [17.722383] R13: 0000000000000000 R14: 00000000c0389424 R15: 000055d4a38fd2a0
>    [17.724839] Modules linked in:
> 
> Fix the bug by detecting the inline extent item in add_all_parents and
> skipping to the next extent item.
> 
> CC: stable@vger.kernel.org # 4.9+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Boris Burkov <boris@bur.io>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/backref.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 21c92c74bf71..46851511b661 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -484,6 +484,7 @@ static int add_all_parents(struct btrfs_backref_walk_ctx *ctx,
>   	u64 wanted_disk_byte = ref->wanted_disk_byte;
>   	u64 count = 0;
>   	u64 data_offset;
> +	u8 type;
>   
>   	if (level != 0) {
>   		eb = path->nodes[level];
> @@ -538,6 +539,9 @@ static int add_all_parents(struct btrfs_backref_walk_ctx *ctx,
>   			continue;
>   		}
>   		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> +		type = btrfs_file_extent_type(eb, fi);
> +		if (type == BTRFS_FILE_EXTENT_INLINE)
> +			goto next;
>   		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
>   		data_offset = btrfs_file_extent_offset(eb, fi);
>   
