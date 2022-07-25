Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B929580073
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiGYOIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 10:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiGYOI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 10:08:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7532D13CC4
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 07:08:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XITVMU4Kq9ozIoig/BCjSpSXaiLN1prxP1PYAQGGBa2ZWgU3iMJMUEEpf3GsQDDokgK9q+/BtqRMfSv74GCwH6auiRYbgTkjIt7gq5MSFC5GxW/QG2cdHbdNVbAu8QKh2Fiy2ijaC5bl6x3wrThvje4VKBocWZ1wdaoQzLthHhNe6sMQQqDhdqNp4CVllMU9qwakTCVyKF6nbe0MFp+rz1ZYsW4YUWxcSqqGga5F8L1mn8SYgJAfryEy7CvIl13xgho3gbsb94G0hlXWD8lAUmAfEXRBfnBEGuluy3h+dRY8YIspmmFa1Pc6ZrZQFGoEzrYnsGldia4XGEZJwe/eCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=se0MszVBq7/SkkfAtWgDa0kr5xkdPsv1Pct+rQydoZE=;
 b=NmzgVTyNggYHE+s4cy0bUi+af1NVzh7ZVS6NOVb37ZuwoEnKF98P5+Z8a5h6TX4e7TUdn24Rhu7CXpk01FE4uJjg1Swdq1wv5AGa0aSZsnwdzyfce5veTgCDvh+2JMDz50N5lAJBjrRBxDwG4gLG4TbXLnfIo5xBX/zMlFD3XtxlqyS/9af3gisZTKRctx+BMMOB+IMHFcBV8BwpMAlwKRbqxPpHtyuMbTC5LcyLdHlBpbQsndNkorzCgFkuqZJOAp/gMn5+BP+YVSIIBkks4DDPOQ4xmlEl49dQ8w8/Sy6D0ZlZ3+rxDPS6t+47dfLl32BuvL7GDj5FcejJgt/4hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=se0MszVBq7/SkkfAtWgDa0kr5xkdPsv1Pct+rQydoZE=;
 b=2OQwMIzZEriJsqbH2qrw2DksnWHOD6ySE3RCYJkLIBcxLMsNHSzEzIwoMw7Fy8PO91tuy86rjPJb9AOh1l/PTH2TuNvhvb+y9LkrACXE4+OLRqzQAfPCvYNyv7n/VG8s/+ZGFwc3d8bxN1HAHKXZyckpazbPdHGiRVK9NoAWSnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by MWHPR12MB1903.namprd12.prod.outlook.com (2603:10b6:300:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Mon, 25 Jul
 2022 14:08:25 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::406d:afb5:d2d7:8115]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::406d:afb5:d2d7:8115%5]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:08:24 +0000
Message-ID: <496113e0-033e-f336-7fe9-7014f64df71b@amd.com>
Date:   Mon, 25 Jul 2022 10:08:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Ralph Campbell <rcampbell@nvidia.com>, linux-mm@kvack.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <20220722225632.4101276-1-rcampbell@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0205.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::15) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c93a3cc3-2eb4-4ab1-0d2b-08da6e47239e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1903:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EePmpuSPOQTSUGyorsw5ULPVvsAZyxRM6LqLFkI4gH9kqpvTgV2QBPuKGmc8YLFVyGxRzfJHJ3DT9g57AhUGua6HDvfsM0HHvvkn68D7H9l1k1D7apajR9azRua4sTHT9zwzdsOXwzDY+87jLL+KsXm2q6LPXWfDv7srBRX7E35unC0WBFcAdcL2jPK+CfjvEXC5V8f2ws2XM6Em6qhPopW8zPN5H/LjDIBSMayBGN5YJzHPP4IZU+clG3kYZQtYhLVWaHLLT+Gx4p83JHkQjlI1Wu2uiH0QpNY3G8KBGWvB6BQ6XL95JRsNaH5SrztzRKbKoq3tF7/MAcbQxXujculig+4UiRZRqshzQb5WvXjmUeutlyGX8d8FyYuLfSW+5UMYzYkY75ikykzTeWo91V1AsEKbMYbrn9cYLP+Memwa5IuB4hisQ6EzU8MnPPQADuwgpjJy3oa7eBFyNPJQ9R6IRkR2IDgBddQZKw02g2SwP1fsvlDOkUsmuW21rDqzZilUjniYa4aoTxxAgGkGlnBvQjJB0evnL848r9ENv1mP5XjujL4xIksWHwfzPd4EQJoDZfbQU5qsegHQ9R9GtzWMTA+8PZHgmp/HMN0LmXFtwGgfDegSZ0szRRBAcSFoPcIz29PnHywnqblj1hDJkBnXOsMsm6K30MpddywP6R1hEDUYRs14nMc4BaKT9tBg8TugUeN34442NOuxEUR1Kk4+Ob28NWl3dzDzQcI45XRcsf+hsZ4fFm3tKjvftUb0hvxQL/MRVaU31X71sppAPv1NEWIX66bDY8DxQ8eb8LMMFb+cuKDc/totH049w4P9dUAdBUBVMyLohK0HPZZJrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(31686004)(6486002)(6506007)(38100700002)(6512007)(26005)(186003)(54906003)(2616005)(478600001)(316002)(66946007)(4326008)(66476007)(44832011)(8936002)(5660300002)(66556008)(41300700001)(6666004)(2906002)(86362001)(8676002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVQ2WWRlOWZLUFBCZEhxOXdlSXgrWUxjM2tPN2hQNEV5VFR5MGorZjJrWWdO?=
 =?utf-8?B?Q29VeXZybVE3Y1B5U1FkUjRuNWp0RmtLb3RaUWx1VDZINjBVT2YwOE1id2FQ?=
 =?utf-8?B?VGk4Z25wM1J5bUZDekl2c3I4QytUTjc2bmcwRi9CV1YreTA5WitwV3JmV0dk?=
 =?utf-8?B?NFZUbDdUdEJmd1lnUElrejNuZDQ1VWRlYVladDYrdTNvaVBtTllhMncvVGNs?=
 =?utf-8?B?M3c3aVpXdXpFTDlvVEgyTDE4eWJiYjNjdUp0bGxUWUNXNXN3TzJJR0dpMEM0?=
 =?utf-8?B?SUJCSDUzY0czRFZXbDhKM2tLTXUvSGdYNjAyN0ExckNiaHd6dkozamE0ei9K?=
 =?utf-8?B?SnFCWmMwQWNaSFpidTNlZHhVODVFMlErTWxySUQ3WURHSTQyOGU3NFRzMDY0?=
 =?utf-8?B?eFZzbmRNZFhiaFFCSm84YW5SU2FWZVVyeEtkNktmWkQrM2EvUHBFOEQ2ZU1p?=
 =?utf-8?B?ZTg3UU16dWZnL0NFZUNLOVV2ODh2cGp3Zy9QOUl0bGExcHExeUw1WHEvRjBV?=
 =?utf-8?B?Q0tsMDM3WVFhMDBxTHZRcHRYMDRRSm5WdkRSeEUyYUcwYnZUTU1SMDU4ZU9B?=
 =?utf-8?B?SkhENFl4M3A3ak9rei9DaHBHb2FEOEdGemRUbkNROHZmQ3NaL3FaNFd0Vkt6?=
 =?utf-8?B?cTBXM1c4SStKb0NJRUlpVlY3cmIzODJsdU1jSmNsb1gxL25EWnJZaUlXZXl2?=
 =?utf-8?B?YnhGRVlNVU5QZk1jK294SXR0SGc1ejlCb3lHalgyRTd3b2JZc2RuZ2NWcnht?=
 =?utf-8?B?VnhrTDdnVER1eWI5ZlMxcTlLaWV6TGpaSkpOT3dacm56blRYdkVzaTNQNERG?=
 =?utf-8?B?ZmtTd1J1Rm5WNGNaMjczTHNMbVBlVmFFTzFxSlJiMSsxWU5IeCtabEZkOU9G?=
 =?utf-8?B?ZU9CU2JHUTlUOW9CN0JNNkNma0lVRFN5TDRkL2x4MExLOW1WaTJzaDhubS9G?=
 =?utf-8?B?czhsaUU0Y3ZnNTVFS2w3YUNpUFA3MGp0eXNIYktJTkYvbERRd1lwcjRFZGxv?=
 =?utf-8?B?TEx3SE9BRklyZEhncG5SemxOeDhQMURqQzBGSThBbnZCdldLMUVWNmJRWnJ4?=
 =?utf-8?B?ZlptNThqaUVjYzJWaWZUZ09obXpLRC8zUEZqOVFKU1JlRVJwU0Q1YmYyQ3pj?=
 =?utf-8?B?TnNkSUtrcmFTVFBkdkJCdWhpZk1JcUdoOU1RaGVvcGpla3g3eTRnTjFwNUtE?=
 =?utf-8?B?QVFsUVpKQlh4UlhncjRuWUp0NFhSeklyWTNnTTBTTHVtb1BWZ2lYcGRYSGtP?=
 =?utf-8?B?bElKR1d5VXBQT3pvTHhOTDd1bmZnaFBIRW02bkhmKzZCMGUrOHY2cWhEMXlO?=
 =?utf-8?B?byszeFk0VEk2TjVpTVhjc2IrdUtpSjJRNE1PaUNSVXgxSFA0ektzcVZ4OUJi?=
 =?utf-8?B?NklpL1p5L3F0TkZUVmxWRXNIWUgrS25YUXlkUUw1RzR1bHA2S3dielRickJn?=
 =?utf-8?B?Qy96dXJacFdaMU8yOFBrUFdvR24yQnNqdFBicDdpUHljanR1SzJ0anAwS0hK?=
 =?utf-8?B?ZXAvWXAwdXh5WXBEc1lWUXBsWStid2luNDNEWWxPUlFZMEwxSnlyZXg0MkVu?=
 =?utf-8?B?K2hJWmxja1V2VXlxWmtzYmV0NWFObmtyelFhY2ZhM3NjbWF4dUxESXE4WEY2?=
 =?utf-8?B?RHB0c2FUZUZ6MVZFZWE5bDdsYktvR2ExOVZJaS85Q01BeEZNVEJYbm1YVk9T?=
 =?utf-8?B?L0JwcFNlN0lFSEM1RzR6VmtuTUZLY1k5NWwwQXN6b0tSOFptcmlQcXJyWmpC?=
 =?utf-8?B?dzkxSTZGS2IyRkFzZkx0K1Q2S2MrcUVtQjdaUUVEcEpCTGpsUVFTSmt4UmY0?=
 =?utf-8?B?Y1dDcDc5a2xZbTdBWUt5eHJGemtlMi9GVGtkZzl4SHJ4blJmUzV1dzdBOWZj?=
 =?utf-8?B?MG5TUG5TUWZvUlJwRDl2RWR2eHYyU2FWMDBKNnhOMjZmV1E4WHh6clh1dzh0?=
 =?utf-8?B?NnhLNHNwWlM0RXNKQkh2em1nMzNWMU5qWHpONElDclZLb045MDJXbUw3dmFS?=
 =?utf-8?B?eTg3OUROWkZvT2o3VDhyNlF3U1NETEZleTFhbWd5SS9oLzV6L0NtR0hNN2d1?=
 =?utf-8?B?M2gyekJQekJpT005cUVub3BWYTJ0T3BVSnF5blFCVExKQ21kK3p6cFA5ZmJ3?=
 =?utf-8?Q?N/JTapkbUULMppmrAaUpAl0s1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c93a3cc3-2eb4-4ab1-0d2b-08da6e47239e
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 14:08:24.7370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MnvnZOihidRimLy9T0mV7aZWjaj6LUx7BEC+OayHmGGMsf7FR/rClSj7zs3Ebub19nV2VLLZPTXM21yt+dcYrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1903
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-07-22 um 18:56 schrieb Ralph Campbell:
> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.
>
> Cc: stable@vger.kernel.org
> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reported-by: Felix Kuehling <felix.kuehling@amd.com>

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>

Thank you!


> ---
>   mm/hmm.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 3fd3242c5e50..7db2b29bdc85 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -273,6 +273,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>   		if (!non_swap_entry(entry))
>   			goto fault;
>   
> +		if (is_device_private_entry(entry))
> +			goto fault;
> +
>   		if (is_device_exclusive_entry(entry))
>   			goto fault;
>   
