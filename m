Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFBA6B8DE3
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 09:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCNIyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCNIym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 04:54:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59FA637F0
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 01:54:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0nbU5m9S22U3oWQ6NGp8GfjtmgxOLRIFuDzov7mMooQxYu+Cp5WZor9SZNA58LGhpQgRzchYqHrdmMzyYYOR+yqVRYzfX7iEH7sUO2nE00LbTelj/lai8IMvH582wwX0VFx4LEhrGJoBfHJlcnr5UaJNVWT7WoUh92YiF+FuWulax9BeU99OvAaMqTZfDt0+YjXJ2sPOAnHc/1KPbVYIcfG1sUQzIxjQ5p30ROTHDwpY4R86sl4QrmA6tMep1AtHB9Wn29jUT2spLFbWXvYexXdsK9GzaTZJNVEcs6r1qJTyx11A5BK2vy1QjBw4VtqxiL6/UlRy+J00OaHIBWg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmPfHINyHAWSuQum0cd5NwpzlatMyNP+dNSuhczot+0=;
 b=j0pM8MlS2V+OGfeXP2LAFrCxP+2svsyO5OU3RsSkSz0+UNMyUUT3haBlxeMwoZLhijPHRzk1+WW4C6R+R2jtG7mfyfXX+8k2L5oBU1Bh6dpaggYzSdNcw70AHLlfLttlKlVNqPtVnARv/DpsUEk8oQO7il3yFVC9CEw3IwrtCrFjDOU+Xeqsa5QutrGUPEMeIMlU49f7dNCGISseIUdoJtE/P6cCDbZARZZW23l6+/cQWMIPHgsx1qFIOGWvELNrzX0ZFUtEDfrEG9kdGSS5AWzZvkYYVD0OVby46BDZ48LiNccwu/uV8IC1nuczEKh/uK7/BYxb3Txnvc+WMWGm7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmPfHINyHAWSuQum0cd5NwpzlatMyNP+dNSuhczot+0=;
 b=lkgcU26dJJDuVtTo6mw6diWvchqDCffqlc9JHjxeU/aZiQqHZ0oekW0CAIGhLsGH7BGlEJIAW3BoyUodHuPLBqthTMqykmX2CHef2ty3u9fomr5g7gFt4OM2MFAEqyMprz0yLLxGy6NWkQKBJnjTI6F4P/KuuThtXXV4lsjOXe4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SA1PR12MB5659.namprd12.prod.outlook.com (2603:10b6:806:236::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 08:54:34 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:54:34 +0000
Message-ID: <2e14e654-e4f1-8c4a-a0ac-60f5e036659a@amd.com>
Date:   Tue, 14 Mar 2023 19:54:25 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.2 073/211] swiotlb: mark swiotlb_memblock_alloc() as
 __init
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
        linux-mm@kvack.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20230310133718.689332661@linuxfoundation.org>
 <20230310133721.005935440@linuxfoundation.org>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230310133721.005935440@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY0PR01CA0011.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::8) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SA1PR12MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: 6affb0fb-7cf1-40d8-b502-08db2469bb83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PR0u6TFqfrUplGFA+JUjDSl3XBNg3zWIFJzcjmbT1WA0PGwt9ExommaDAJ10uOh97jUf6riF1xsb0btN9xsILZi1ZOGHQHOkphczo3Ar0xf7VK90H6Mqv8FOIr5tfXUz4TpUpchN+48e2yTdxjlj8PexNgiPpNSBvcSEWhs+NhId2HiFXAcJZzg0mcc8YYgjWQXvKDoAavd4K6/xNwcJnd2UwhVke2bbyILw7BB95hl2+siExEfIME3RZ53Gz/2ChNbtL5PojzY4R0+P5nWfoqhExwJjCq4GAnas5ZKOjaTpWfSzMqADQeZZ8qw5p/x9/MA0fD7EvUuC6ky4EbP3DpdqfZZD2zh+ijUBFzS5W4/vD78v7WBjgj6EPPgMoxF+EvX8CbcdOJAxV2vSdMUrOFazJeARTOnRhE+1XsQHXn4SmWJz5nujopq7MTXYUTNiM8LEhHoRqk5j1Ot/yJRR2rWOj/8AepLxjMcEzlBkSK+bo+WfNvZ7CQGhgqThUWOtnpWsPVi0ULNKLcwV8LD5KL4CLTVzy++DJT7ZkIzE+JZsBvQCny8kr8ppl7FC75AVsQxOZbMnD6cxsPpABMZEeH8tEljkrCAV9BDcpfMV4D90lqBsVuT//CQ2ulfq+++FAlqH/arGAsBbUpD/FqCLfM66NzT3KwEoBukWfwJjpf5cFgxZidtJdChYGpDZSNXrJlSG6kKtQcjCj96Z5qy33nL7pLvKVFrPm+Xh7GUZP0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199018)(5660300002)(36756003)(83380400001)(478600001)(26005)(6666004)(6506007)(6512007)(6486002)(53546011)(2616005)(8676002)(186003)(66556008)(4326008)(66476007)(316002)(8936002)(66946007)(6916009)(41300700001)(54906003)(31696002)(38100700002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1VuZXVhU0J2cWlvWEIzVzRCSSsvenZxVnMwdG5hZ0lCQ2tyT2l2UlJKVVlw?=
 =?utf-8?B?c0xQZDZWamF6MVVtdFVrQ2VSSHcxY3V2VElzNXgzTlVDd0J3OGZGMUlRMmtU?=
 =?utf-8?B?dlUvOTBwMWlSa2lRQ21ycTlkZmVDZ3dTUWFnaklnMmNqVStubXA1WVczL2N5?=
 =?utf-8?B?L1ZzWVkxblg2MDNQRXhzdmdTSlp0a3NIY2hZSGR6dko0aXhYVnZXYlZObTZa?=
 =?utf-8?B?Tit1TnZTUjJvbFRkOEpCTkNQcnFjbG1nUVBESEdiSUdmRzRWRFlZY2hRY3hG?=
 =?utf-8?B?Y1AvQ2xQL1V1S0dnMnIwRm4wakIwYWk3RFlldUJMTXRDelRSOEd6OTc3UVRm?=
 =?utf-8?B?ZG5sSlBnV0FEZFhyblFmT3g1MkRBU3hPcXlHZW1pWlo4Ni9hakhFK1N4RXJh?=
 =?utf-8?B?a3VFUkdUMDBaQWlOOHRvWHhzVnY0UEdEUSt0N0Zqd0Ezd2NiMFRJSVErQU9E?=
 =?utf-8?B?VXR6M1A2K3IraEhpVFJOa3gyeFkxa2h6M2hsdTd1QXdwUE5DQnp6dVA4eW1w?=
 =?utf-8?B?R08rTTM4OEpJVjBwM2dxVUtidVhHN3h6QmNHbzBFMFVBVS9HTXdRSGU3TWg1?=
 =?utf-8?B?aVl2aW45L3BDUFNjeVdvY3U5Zks5aVUvTTNOSlNQMUhYVnZpUUtrbmdYVG04?=
 =?utf-8?B?VzhRY0s1WnlYU3hHbm9ma1lyOUdhc1p6S1VkaDZDQ1Z2TGdLbG0ySDZOTG1i?=
 =?utf-8?B?aTF6endYa1h0Z0xzQjd0emdOTXd2clFqamsrVzBJV0hrUFB4QzFlVmlVVExV?=
 =?utf-8?B?NXNsNmxhWklrQk5yQS9HSDhYY0IwdkRDb3MycWVWMWYrVkh0c0J3dFRkcTRx?=
 =?utf-8?B?eGJEYzVRN0xHN3Q1ZnNFUCtDK2xRVFpnTFBUNEdXM1hTMWZEWktBbHBnbk5x?=
 =?utf-8?B?aTZmcXRjc2E1Wmg1RDNhOVlLanJ0eTBSa3Q0L3FiK1BFVWtnYnZGR3VkRnQ4?=
 =?utf-8?B?MjdETit5eDdPYmMzTWNEN1A1MnhQVlR2aGNkNHJRSVBRZ21rTjRVckNuZ3JH?=
 =?utf-8?B?S2lhRjhlN3BCbVhxZGQ2WTl0ZUJuUllUUE9SL1FLaEEvT0ZKZ0FQSzlZdm5S?=
 =?utf-8?B?RHhWcllSUFlVMHlWTktQTXVqVG9wK3ZJSlRVQlpHYm41OHYwcHIzMzRRTEc1?=
 =?utf-8?B?Nm9tbnlhMEhRYnd6T0N1WnZ3MGdzMkFGajFYNjNaK1hLM1doWTNrSUlXL0E5?=
 =?utf-8?B?dCtSY2JFQmFvOHcrUG11WDUvSmpURkJ6Qi9TU0RiaFl5Z3JLOWd1MkpqSS83?=
 =?utf-8?B?bitjZHRBTVZWSWpwWmU2WWFqaEVON1F3cisyUXFTUUFmcWtQdHo3OHhTeld2?=
 =?utf-8?B?cC9kNElYUTFUSUJlQVNBVWlkWUdOSFNjOGZrelpQRCtVTkc1ZFBESkJMNFRy?=
 =?utf-8?B?QlVjUStZN21iUjFCaCtwSlA2RnlaZHNtaUw1V0FXRVRzM0k1cVcyT0VYYU1p?=
 =?utf-8?B?QW43bnpKNWFzMjJmakkzQWNUZHkwS29pUWtTY3VELzl1eGkzVUh6Z25XYk1S?=
 =?utf-8?B?bVhOZkNSUU5kR2pKQ1IxakdURTZyTndEeGJTVm93ZWxKZERoT1NwVWFNV09a?=
 =?utf-8?B?M1FOczJsV28yZVFsTnVLVm1POVZaMkRMNXZuZkQ4R2ZzUElPYnB6N0IycjIx?=
 =?utf-8?B?Q2xoRjM0MWU5dHJKR0dqcXlHc2RvL241TmRRZVhyT0FpbDdMZGpNRHgvVjFP?=
 =?utf-8?B?Y3BzaVlyM3hWdVdHeFZxMXdjVXBYbGxzNEtwV3hKNmlLdGtxbFZKMlBXekZN?=
 =?utf-8?B?UFZFNzV5cUZxc2dwMUhPR2YvdzJua2hSem9zR1RwNncweWtOK1NGS2ZzbHRz?=
 =?utf-8?B?Q2VuZ3R0dFhmZkIxdGM1eExWd3dOUU5XOHBLZHk0c0lKWjRvS1hIaXJaTGda?=
 =?utf-8?B?ZFFVVWhsczNtYzFCUzhCYzFPbnRmcDJMS0U2aXRweWlOM2k0M3hYeksxckJk?=
 =?utf-8?B?eUtueTBmWEk3dyt0QU94Y08zUmNsWDVaZWVBTktjbUU5WEloU09jbGVMZEtY?=
 =?utf-8?B?YjVGczcyTFUrVkJUZWdFWDdEWWZQbWlYYVlqZ1VQcmx2Nk1aOHd2QjRHbTNj?=
 =?utf-8?B?U2pETEtMNWNiRmdCaHJDbno4cGxlZTl2WEl4ckI3WkNkaFExZk1GUGQ1NWV3?=
 =?utf-8?Q?NLx7P0UplPzaAAuNdK7xs2nVJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6affb0fb-7cf1-40d8-b502-08db2469bb83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:54:34.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxCeqWdG54jKOO80oE0xXHMVallTiXkdA3QzxrziJFszcWU/n91nuoVlFyiuZStqREBdgFifafb3djiThVicpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/3/23 00:37, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 9b07d27d0fbb7f7441aa986859a0f53ec93a0335 ]
> 
> swiotlb_memblock_alloc() calls memblock_alloc(), which calls
> (__init) memblock_alloc_try_nid(). However, swiotlb_membloc_alloc()
> can be marked as __init since it is only called by swiotlb_init_remap(),
> which is already marked as __init. This prevents a modpost build
> warning/error:
> 
> WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
> WARNING: modpost: vmlinux.o: section mismatch in reference: swiotlb_memblock_alloc (section: .text) -> memblock_alloc_try_nid (section: .init.text)
> 
> This fixes the build warning/error seen on ARM64, PPC64, S390, i386,
> and x86_64.

Did you do something special in your config to get these warnings? Or it 
is your toolchain? I tested with whatever comes with Ubuntu2210 and 
Fedora36 and neither printed the warning and I want to see those :-/ Thanks,


> 
> Fixes: 8d58aa484920 ("swiotlb: reduce the swiotlb buffer size on allocation failure")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: iommu@lists.linux.dev
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/dma/swiotlb.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index a34c38bbe28f1..ef3bc3a5bbed3 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -300,7 +300,8 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>   	return;
>   }
>   
> -static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
> +static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
> +		unsigned int flags,
>   		int (*remap)(void *tlb, unsigned long nslabs))
>   {
>   	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);

-- 
Alexey
