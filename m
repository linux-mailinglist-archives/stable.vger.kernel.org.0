Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F603431CAE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhJRNoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:01 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:6881
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231903AbhJRNl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:41:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUUduQAOg5VwokfILnrnV132+3xWGAozJzYeAhsWMK88K24oA64DXcKhtlSvq261XPnFX7KgggcN1Vxqz//+wjWpVMKd5+7iWOPOJn1z9JI0nH8MLYULHxEwLpf+jDxGlG2pYhLYexPh1c+X5nysnnI8loZPu4EYBTmDE0OhMOUW8/U9yjEsjawa4MWs7wV0H5MfzRv55TJNHC+DPSw1KkFHino/uI31NDHgHqGGZUdQkb2uN7C1XS/E+4QXvvWdGDTIUqifZ+shF00q/VWhj1c3V+E2Yi+2BpGkdVMXmujr00/U8+phRJcSWSJiqVUoYFb8I4U/9XPJu6EuvVz7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uf1GNhas0VQnwnpECKzPpy+3alKdYRtfnFq0S8lcgQk=;
 b=XwcSJFvvXAMdY+/5kfsZPsec4vX5EEXtBbNVs6I8u81R/11cOkUO5PcRzYwDXh160WNVYU4NUk0SCShDonctBjnJIadwqAyPNjt9D24v8ZWD0GkQ14RpVBtpELZUeOHJf1zYXawY2SfFXH5pG6g6oES8alyYo9GzTuku92E/SWS7EdQAYeVXv32r6tZ/J+Btzm7UzQ4qqme4KScE6UMdL5+9o9YJZC3eAi+I9m4fcx+B91xAuKdE2ct2EeyDBPFFwBeklM8M5tGWS+KEYtwTqUKt2LfzccmMKx7bFjLmYq2vDFiozeWz2DOEZxVr/DhFid1UcyW0ajsSRpaI6WkzYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf1GNhas0VQnwnpECKzPpy+3alKdYRtfnFq0S8lcgQk=;
 b=HJxR+Yo69Imf4tCVBQW3SNN8dSHFC/VFdeXEKpJ/vBCdTGzmJLVh3zMCnMgYRall5NI69YFisQMUVR8aVusk+rH3usX30RfqrSxgfmD7bpnnVX+dBvYSnJ6VB+gM5AC7FdD9K7lxh8iEZDAKZ+A/L/St1Ju77fABuBy5YxYRxAY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 13:39:45 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%4]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 13:39:45 +0000
Message-ID: <237b9ecb-646d-f7f8-a281-33b5b105654f@amd.com>
Date:   Mon, 18 Oct 2021 08:39:43 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Content-Language: en-US
To:     Harry Wentland <harry.wentland@amd.com>, Roman.Li@amd.com,
        amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        rodrigo.siqueira@amd.com
Cc:     stable@vger.kernel.org
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
 <7955cd39-d659-fa0b-039b-87554f43c682@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <7955cd39-d659-fa0b-039b-87554f43c682@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:806:121::13) To SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.236.178.93] (165.204.77.1) by SN7PR04CA0068.namprd04.prod.outlook.com (2603:10b6:806:121::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 13:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ccc802-3a19-4d09-4562-08d9923cbf1f
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB47519DACB5C9BB0D4AFA2C6EE2BC9@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WmNojp0vdmMtDlSF0LbiJCmu2Av+iww0EtbJmWnzqfFWwXeLK+GCuL4xFIT8mX0hb80xR2Yjb5gIwEKrEGuVhJg7i0vSq0oNvRywMJ0hrokwTgng5OHDCVYpSRl0razALWV9IPBnRCpUpzZi6mTd7lDGtCgVgSe7T8dT9Xf0M6mHtdbUd1mJHp6XNAzBIFnTnprAmQrTxjM2cruvhIXIK8SMFCeNrvmz2sveQwA33lwLxUikvGkHlUhdPE3w+q4GxsQ9cVW9zo65aUpZqXY5W49ufl/TzyXttc90pmP5rTO/MUZqHtBM6twrWNxaZl5JpX6usjL8ETmSDjYPgo6gM4LRdZV+wiZEnum1nLrEX+rg7O5R4t9auHsKb7/lH4tHpBy2m4TKylp8+7niBoo/T+TJbHam+tM7RuBdI20w//a7kcjptspMEozds2Yt0Mevm+w6XHR5xQwtgp3RH63pX0LDT3p/9XLBivdQ0WZUqN5lquVOPHHUucgA8woMaMTIr/U4/p3e4u2vGrGmFLYe7V4X57RbschBFrQwO6XMbtE1zC1Cy1BZ7MmlbLfbj/B+rNBcMqAgNII7LZonGv6wufPenZ+PAQAebU1hv9i0grbj8+c2Tnct4AvJX2ox9azx+686hoGXn1mQMUbL7hREKDJKmOPOa1CiV6Lu4Gx1UOvKSFxZIsGpjvzE0uCGhF3QOeTseJUniTSiscoiqTvoIxesJ1mJ12rWblXImF1Jf38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(16576012)(966005)(66556008)(53546011)(31686004)(66476007)(6486002)(4326008)(38100700002)(31696002)(36756003)(66946007)(186003)(86362001)(4001150100001)(2616005)(5660300002)(26005)(508600001)(83380400001)(8676002)(316002)(8936002)(956004)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3dvUkZGSFg4Njd0V0FBVDUyY09YRWd4T3RGYUlMMTErUkdPZkpNNWJJcERw?=
 =?utf-8?B?UmQ2d3FIWk1oUGE2ci9FQXJ3cHdZV3R1TVQ1dE45RXBPZHQvbUdyZmxoODlt?=
 =?utf-8?B?QmE1WFgxL0pPVG5EMDdzZFFuV2RKWU1LT0NIbVh6MzN3UzF2djd1K1ZKZjlT?=
 =?utf-8?B?dGNqRWptMi9xL3NaSi81MlM3QTFXeFRaeHQvSTJ6V1VKcDkyS1dvM2J6My92?=
 =?utf-8?B?dysySXZYd2kxVWJDYmRlL1Z6bG5YWStUdGpqNUxqV3VvWHJrVTVUblZlZmMw?=
 =?utf-8?B?UHQrMW85WUI2bjlab3lYaTA5UE9WMXR6NDBrRStBS0czVHRqKy9rMFFjeVRO?=
 =?utf-8?B?ZkZoQ0FCRjdxK2JvTFhhVjRlZ25RVVgzU3ZPdkM5V2VxSC9paG5ycFB0bUcy?=
 =?utf-8?B?U3MvUjRIVHVwWHVDaEVKZDRVYnNLRFhlS1RpY3JOLzZ3MlVMSjA5d1ZNMVRj?=
 =?utf-8?B?dHFLNG1LUlQ4WnBFekVCaXhvVG5Da3lIcDl2dWtBZUl6Yk5VWUNlcklSSnZM?=
 =?utf-8?B?cjd3Mnp2TWU3bWVUY1N6eGVEWGVyeHFsYW5VUkFQdlFjY1dJMWh2Z0hqUERU?=
 =?utf-8?B?UFFHQy8yb0M5QW5IQ0hWdkVoTW5ZdUlnbStpNHlKbXlHRXhlTGY5Ymdab0Jx?=
 =?utf-8?B?WklZYkJhMUlmL005SjExSHZFRE5vaXJVOHhudmt3VWRaUUs0UllWWGNhVGMw?=
 =?utf-8?B?Si9zRUpuSytsLzFMdWhLZHRwTjJ1Q3ZFNE42OVZJT2diVGlndDJrb3FUNERN?=
 =?utf-8?B?eDJtaExkQmJpQUIxN3lhbWdJL1FMZmlNQk1uNXJpNW9seUF1a0xnK0xqT3NS?=
 =?utf-8?B?am4zWm5QdVVGL2poQUVyb0p5WlZnM01ndlFIclFFcHJJdVlTdmlleUhVYk1y?=
 =?utf-8?B?TnNrVWIrUU5Mb3dWTUtZWmh4N0NrSWtnbUxjY0t0eWRISnViWVM1OEIrVGpC?=
 =?utf-8?B?ZEdRUjlhRmZIVHdtM1pLTi9LMlNVd0hTMTJ4ZUEzSHFpM05kSnpoR1B2Vm9V?=
 =?utf-8?B?Mnd2bThzeVpPVHRvci9wb3RoN1hUbmVlbzBxcW1NTDROY05KYXo0bitNNm9Z?=
 =?utf-8?B?d05EdXBLalA5T0pvalVpUzI2RE5CWk9HRmlDQ2oyd3p5anBrVWRmWDNxZkw5?=
 =?utf-8?B?aFVmWkw3UFh5b3JENSt6bSs4RmxVUlBENEV6YkttRFN1UXEvRkdjVlBJTHBQ?=
 =?utf-8?B?SWJIZy8rVVU5dWlxTDg5NWxvRE9IS1pCYjRxakFBYkFCRWdndXA3MHZ2OFl6?=
 =?utf-8?B?TFFvOTNSUVBON3dQOVBhNkxWOVV4S0tLcmJpVFV3eTdMR0tacjdoZWdpS2tP?=
 =?utf-8?B?YWZUQ3dsMG5hVGxJQ1FOSlZhSVhTZGZyK21FNDVsVlluV0hDeDNxWkl6YURO?=
 =?utf-8?B?T1RxVUg3VXpSVjE3MmpNalFmTnNCWjVGZWpnbVJMVE44aFJCcEVKek1OT2xo?=
 =?utf-8?B?b291aGc1QWtScTVVUis0a2pFcmFZaGJKVm56Z24zYmE2Yy9qVFlndUZUL2pZ?=
 =?utf-8?B?K1pkZTAzZmJIZXZIRU04SUpiUHdRMzhXNTdZRzBJWkd5aVRpazNMcHo0c3ps?=
 =?utf-8?B?TjNBTXFvcUlkVDQ2SnBCZTkyTEU3bTg5SFVqNndKeWc3TE1xU1pCeTRVV1FM?=
 =?utf-8?B?VFhyTEdNeEJDSnhTT2tUSUNYVGd0TDZzRVRoRkgyRnd2TkM3aHd6MjhSTmlF?=
 =?utf-8?B?c2hVTEpoNlVRbHNtQXNXSzd1YW1LckNpS0Z6OXI1ZXBuc0tKdlNEZWhmcDlQ?=
 =?utf-8?Q?bPbkWH1n/H8BCl4paZNCvjz9LjpTI4g6lPUIa0t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ccc802-3a19-4d09-4562-08d9923cbf1f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:39:45.3130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prRqfRSpNaPJPOXYaP18C71Zwx2t2hiPmARiaPnhiizToc2iICOrEcSpPcSS8IFnjXHZ8qVkwGNa28y6wrz7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/2021 08:38, Harry Wentland wrote:
> On 2021-10-15 18:31, Roman.Li@amd.com wrote:
>> From: Roman Li <Roman.Li@amd.com>
>>
>> [Why]
>> On renoir usb-c port stops functioning on resume after f/w update.
>> New dmub firmware caused regression due to conflict with dmcu.
>> With new dmub f/w dmcu is superseded and should be disabled.
>>
>> [How]
>> - Disable dmcu for all dcn21.
>>
>> Check dmesg for dmub f/w version.
>> The old firmware (before regression):
>> [drm] DMUB hardware initialized: version=0x00000001
>> All other versions require that patch for renoir.
>>
>> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Roman Li <Roman.Li@amd.com>
> 
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>

Tested-by: Mario Limonciello <mario.limonciello@amd.com>

> 
> Harry
> 
>> ---
>>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index ff54550..e56f73e 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>>   		switch (adev->ip_versions[DCE_HWIP][0]) {
>>   		case IP_VERSION(2, 1, 0):
>>   			init_data.flags.gpu_vm_support = true;
>> -			if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
>> -				init_data.flags.disable_dmcu = true;
>> +			init_data.flags.disable_dmcu = true;
>>   			break;
>>   		case IP_VERSION(1, 0, 0):
>>   		case IP_VERSION(1, 0, 1):
>>
> 

