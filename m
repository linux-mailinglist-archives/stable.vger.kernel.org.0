Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E126006B3
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 08:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJQG1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 02:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiJQG1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 02:27:40 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56732E69B
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 23:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8WNbV9jncKcoJdOHYRa0h4GtkbI3zIJyVqXcG1/kNRTENWSYO8tAnz8wYirDFjnln13ZB3OxIQ5NwADB7E8BPfayKzvN3FQelQHTv2Bytxlg08Wyu4iuQIflu3dzIKI1S5o0psP9y6T5voXJvuaTEd72Pz7ZzNRgh6ZXExkXBoIAbG1ldJYNeQS2B9+yvX13swhmuMIXwdKef6zErXwF+KUIs0Bl37Xz4cCVU8wboIJctqR+i3/8R4Y6usCpm9SB+0q2FxZpaTJgyd+OwGwRaeliC6GA1NTnC4SMRPf1xfG2J8A8nFcc+dw7qs1AYFi+hzoze/03kA3kPS4kPAf0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js/3646nSXy+XqPC5649fHNlHaRnpikEhhMVa6PBkJM=;
 b=QiNY0ZMZ3TQTpajEM8QOypZ5CMC/isi3Lnm8JBiP4WpB+DMyPOtcmNbRIjzm7M/XT0f9RR3pFfSEox+RLwS8mNtx9s2cL+h0kltiOKQSgUL6Wg6gnmFER+A0tIcxo8RDTp29QJqFwAz4d1OoIeQu+DMC2Z4UbU4ew8nCbiLq+ZcwnKeoaasZy+dpo0zlddg/bwm/fPz5R6u3KZIv35QCBvyI7J98q8LMih1OdEZ9ezzSpcxduciCHWjkCwZkxSefGOyanC23XqulqU6VTmMCJlXtNxtNWoNYk0TrWyhXh8GHLEf6Xorcr4e/ephW4FLig/+MRcYk5Iy4vV/3+EY52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js/3646nSXy+XqPC5649fHNlHaRnpikEhhMVa6PBkJM=;
 b=nj7HlJxWERVvl6Lv/lgWyCxEkrzQVZHPS/+2eL7eOc8FWUnIUot0NWctG8L3UoBRL1M2pVymtsoBeQkUgBKR5onetzerPuchFhRdwrxwaQItDaFXGJW3imdpSBDYIixS+6a+mUxLsgmk9kI/iv73OVYiYUY4X0g7uyEwbUdydQo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 06:27:33 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::805b:58b6:1f27:d644]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::805b:58b6:1f27:d644%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 06:27:33 +0000
Message-ID: <7d482756-b5a0-328c-9e9c-ef0e31c4225a@amd.com>
Date:   Mon, 17 Oct 2022 08:27:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] drm/amdgpu: use DRM_SCHED_FENCE_DONT_PIPELINE for VM
 updates
Content-Language: en-US
To:     Luben Tuikov <luben.tuikov@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20221014081553.114899-1-christian.koenig@amd.com>
 <20221014081553.114899-2-christian.koenig@amd.com>
 <fd55eef9-1ce1-3f4c-d6ff-a5a230828b8e@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <fd55eef9-1ce1-3f4c-d6ff-a5a230828b8e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|MW3PR12MB4505:EE_
X-MS-Office365-Filtering-Correlation-Id: 1196d3d7-743d-4fc9-6abc-08dab008acfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juusRUE8ZmKWTEPOQc86hid7BpS//C2eWiSG6uuODQ3D2qwvEEF+1Jx1QgbDPSYmxf/aNNnTCPKcDvyhe/WhlBWyqut+JSrVWAuHLTQ0EfcO0XYxhco040tkKsdOdKhFKz4F9a0u7Fnd08gg+Ei86aTqx5eaELOjkG11zRwl2BlCykPfXlzpPXNyt83WoL2BspD/cuG+f4Yqq/dQPAipHXY6v8SJUElbhIp4VhcHAI8MbUWkr/hHvZMw8GYENWHG/BnuqjqJ4MCSKuNw0R87L4BRG3/uOl2raFGwvOz/7inz08vj44H61+mwiUtP4tmh3jpK6xQFkKhXP+G1o5cZm9leGOA/j6C28SaptxljC522YsaFCRRG5utdkuLvl5RS4ZKEqBlApaOQUJo0cOgftoVXNqHltMivCVWMXc0uwXtfJ39rzN3tBP6UkSQfjMHBQuu1tUI6vxCMghNuRRlwUz9lKouzhIT/yzKY2EqRgIUejUxvTwhmXno7JVDyUTdf2i881otZv6cqNUk0BpUb0QF0ogYYNJckY/UjmagJ9l+aPaqT348RO8Groy2X9Y1huXxfXxb5GJfBFM3ICGZN9aXadTwB2rrzOmuzqa3BIQ/1aavHbd7gG46jhGHXzVCDOGS1mB8v3rjIccyJMO+da3SrJz4pmUzue/kAXqP4ArNUNlStpBX6nSb6gEWwO38g+UVJPRebyWfSVPqpkxdaYwQ70lJwRhc4xIPg/VyxG83TM6FnvgO4LV4+pCcMry1HEV6ETd+z7wjIq/cVz8XbVd22Ov3lNzRJq3987bUEuB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(36756003)(31686004)(86362001)(31696002)(2906002)(5660300002)(4001150100001)(38100700002)(2616005)(186003)(83380400001)(66574015)(6506007)(316002)(53546011)(478600001)(6512007)(6486002)(66556008)(66476007)(66946007)(8936002)(41300700001)(15650500001)(4326008)(110136005)(6666004)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWErRDhZYkVwS0g0YnFtbzFadTlPT3FHQk1pNDFVZXoybGd3QWxlZ3hSN3Ar?=
 =?utf-8?B?NE9hMGo2YnZqSlpOd2ZwZGNKaStaY0V1ZFNGQWp1ejR4aTk2UkVSeU1sK0RQ?=
 =?utf-8?B?TmsvSENHNThON21pc0RIdUNkaE1oajllaWIxZXArd1IzbFNpTHFkOU1xaFUz?=
 =?utf-8?B?OEpMdVRLNE01NjVmSWtOalNoSzY0czhxUHRqdVB6aW1yRVpXcTZ5cTc4dGFj?=
 =?utf-8?B?MWUySXFVTjFUcEk4cmU3QkFSZFlGY2dnNmt4ZUdNNWdZRXR6Qk80bDFvZG9W?=
 =?utf-8?B?T3EzTStpdWc5RFVNdFFlaFJrQXZmbkNNNDF6bFdQdlFwU3lJQ0toUUFhSDBw?=
 =?utf-8?B?eGVJdmhJRExlcStOZmZScHd0NGJCaFhRaWRkVDhDdllQd2JaR1RZMndNTUVl?=
 =?utf-8?B?T0FoRk4yVU8xTFlPemJXVGZrd3FxOXFJaWQwaDNZbG5Nc1AwQTRhL3d5ZlJW?=
 =?utf-8?B?ZXFJV0gwNDAxSW5hZDhmaWpiWEQwbnFTd05PMVZzeVZrQ3Bxcm8wcnlmN2Ev?=
 =?utf-8?B?amJQN1pvVTd0TkpNbWpRM3dCRG5seVlnUUhhcVBUWXRWYVFSNjlhc2N1ZU9m?=
 =?utf-8?B?WXlibllVZnBHSHlQTWdDeEl5Z0doQ1JNYis2WjFWYmlKQ1FDd2RJS3VnQ2l2?=
 =?utf-8?B?ZkxFZDdNc2g5VHMwQUphbzErdnJ6WHFPUnk2c0tVV2o2d3Y5Q1lESldyUVNU?=
 =?utf-8?B?RWJQb0J2N21ybW5OeDBDZ1hZYUZzeGw1ZUNlR1VIQXZIUXptOEsxa0pHVEVi?=
 =?utf-8?B?ZlVWdk53N2Vpekd3WnV5bU9odGNxWlA2RnhXOXRuNnFRR2NmUmE3YjBCM1do?=
 =?utf-8?B?b1NQcVRlak56bnNWQTlSd3Z2RHpmQkhxcE9UNjR6STVRK01iQ2lKT0lvaXV2?=
 =?utf-8?B?d0FVNUV4Qlk5NnNYK3l5ZXg1cEc5MFVhUG9rdTJBRm5uSGpsb2tWQ01udVha?=
 =?utf-8?B?aU1CRS9JeWFPaXVhSjhQOTE0d1ZCeDRGcVJHNThIVXdZY2htK0x5VCtRMkJ0?=
 =?utf-8?B?bkIyM2UyNXFFTmpFM0dtUDBvMlJrSUF6cUpiQ05heUg5VlZwdkZDU1JpdUdX?=
 =?utf-8?B?bU9xMnZZYjEyUWxkL21nSkpZUWp5M1J0NlhPTS9EMDFQVkFadm9MZitKR01r?=
 =?utf-8?B?cS9YelJRMTNUN0JhTWx6N1VWclVFaUtSZ2swOXdXblB5V0ovZ0NqVDZOeXho?=
 =?utf-8?B?R25heS80R0pRalBnWWNSeFdxanphQlhNRlo1VHdIMzJwTkRlRDVOelNQRTU5?=
 =?utf-8?B?OC9DWTdGSlVtNTl6SDk2LzNPN3RBNWVPRGxRUkxuU0FsQmkyZDI0SzdxR0pK?=
 =?utf-8?B?ODF6VVFoTGlzMXN0OHpGMkpGdDVwN0NQWlFQU1kwL25pVUVMWE1DSnZ4MGhr?=
 =?utf-8?B?OW5KRG9QZTQ4emwrOXdPY0NwVHZvaW11TnNOV2xOelZSOEp2dVZMODJ3bnBj?=
 =?utf-8?B?ekoyYnVGemd2Rkd5UC9PZE1ONk42UVhvOXpDSTR6MW9uclBGSHZBaEMxeDI0?=
 =?utf-8?B?THVlMW92Y0tYdXhPTEdYdmQxU3hUYzFBaktrZEpxbGVuY3JoY0w0SUpmY0Js?=
 =?utf-8?B?QkxFSXFzbUdBNS84WkdiTTJveXZoZS9yN0xwQXl6KzQySjM4Sm5NZHNnbjlJ?=
 =?utf-8?B?MXc1VlBHV2VMSDBzQ2UxTnc4NEZpSkUvQXZMNEVGOU9WbFRHNWxJUkp0M2pt?=
 =?utf-8?B?aFk0N1hWZWhhV01SeHYwRUFzdVNyOEIwcm1yeU1nOUFDYlZJRFc5ZFI0aEdF?=
 =?utf-8?B?THNlb3lWZU1TR0RJVDQ4VTQrN0ZMeGRXMWtwaVlnN3NoOThmdDhvaWRzUHpk?=
 =?utf-8?B?Mm5DbWczQWc0UlJKazJ5U0pVZFJuWStuOEJMOGJxb3dNN3NrYndEZTRLaUQ5?=
 =?utf-8?B?encwN1NRKzVHekhyTkZDNTVBdlNMWVZmUHppaEMrM1pPNnFDSXhhTmdxRE1y?=
 =?utf-8?B?dU51d2h2aVhkTUhtclZyYTVvb2xzeUtmY09XU1h0LzZ1L3ZkUUdISkZYc29w?=
 =?utf-8?B?WHFkQURPOTlETThhQ2p6RkhreWlTT3YvNTBJZjJxWTNjc1IydDBhbVg4T2p6?=
 =?utf-8?B?c05MSi9udGtVdXovVG9lSVVtTWl5dWRvelpoV3JXb2p5bUFKU2JQWmY2RDNK?=
 =?utf-8?B?UFJReWsraENJdFN6MDcyaXlhdlZOVWdsdkl6Z3prUzlldDJxcFlrT3BPcDQx?=
 =?utf-8?Q?uTcSdegwCBXMBx97uG+godDTKy8eZot60TPCtEqNITrW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1196d3d7-743d-4fc9-6abc-08dab008acfd
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 06:27:33.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ns+pmfSUY/PoUCkmayxYDwKwfqeH8x14BMHXEHTVrX/1f8G3hH0V3Iz7mXUTV2NH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 17.10.22 um 07:29 schrieb Luben Tuikov:
> Hi Christian,
>
> On 2022-10-14 04:15, Christian König wrote:
>> Make sure that we always have a CPU round trip to let the submission
>> code correctly decide if a TLB flush is necessary or not.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> CC: stable@vger.kernel.org # 5.19+
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>> index 2b0669c464f6..69e105fa41f6 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
>> @@ -116,8 +116,15 @@ static int amdgpu_vm_sdma_commit(struct amdgpu_vm_update_params *p,
>>   				   DMA_RESV_USAGE_BOOKKEEP);
>>   	}
>>   
>> -	if (fence && !p->immediate)
>> +	if (fence && !p->immediate) {
>> +		/*
>> +		 * Most hw generations now have a separate queue for page table
>> +		 * updates, but when the queue is shared with userspace we need
>> +		 * the extra CPU round trip to correctly flush the TLB.
>> +		 */
>> +		set_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &f->flags);
>>   		swap(*fence, f);
>> +	}
> Do you ever turn that bit off?

No, I just rely on the fact that the flags are zero initialized.

Regards,
Christian.

>
> Regards
> Luben
>
>>   	dma_fence_put(f);
>>   	return 0;
>>   

