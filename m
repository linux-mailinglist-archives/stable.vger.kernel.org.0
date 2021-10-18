Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1FD431E7A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhJROBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:01:35 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:16768
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233410AbhJRN7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:59:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2acBux4ZwqQr2r/UgurRdoeK1Pp5pmTl5lK/WdCLNWP5Oyscy9B00aEOMOZktS7IIRfgNk9uhGmDD5DKIHAzSExJ6g6kccoWuh2F2YZbaZ0ET/8PPmy57qpo8R6SkA0QXyMZdI58OIWwFNY3w8OF132MzzADNWJ1fXozaUQnHQGOCzvkbZZJR064RZWpEOqifUYUjFxA9hQDsTsiGYOS25yfclBHrxpYdC2F/lyxNmVh1rufKJ+fH+RZjOUZR4kNIumbb1Yra9Nun2rUuH3KUbkhE2QM12Imnfm5x65t+MPEmVpWn1AiIfU28VxtaaU3aExouuTJ05v8SsV1QMbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Oxfy+E8aWBYqidZb5mVwN0CLjMv+KbaTEc6q7zUTSc=;
 b=dwoJPKoelmDmnuOtjZG+af6HaOePoZT0acaB6Ve+iEoGGlPjtnvcrXJ5X94e0fecQZSGH77rmJn5QudJ4hiI+7CyBrLqPdvOoj6oGwZ8cLTXTvB/UjJdPCCx2JqJqGjN4sn8B9Ajaip1obpAHSu5yZk2/GUvuIazopdohE8svl7VKEnGTgfGbVHqQMUfk++im8Qg/oEjxpjaJyNljBGu0+Ug7pwi5rcvCwVO0QMSFl1GtQXKxHM/Z3Cj0sBlRJgTq4l0YVWPQcODWsc+tlaN2EW1qFqLrVs3LhQ+mgHMrpFcyGafZfmT5d3Gu/ZV8actx+qXbmbmGE706V27P3QbUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Oxfy+E8aWBYqidZb5mVwN0CLjMv+KbaTEc6q7zUTSc=;
 b=1T97XUIIKflWgBx1jd772OcCvtrn1keoFtoGQ73eD8gz3t9PF3KPYCx4/yNxON6NUT9rF+q+nbHM1oyEt8+zjLQ2N3JZTyb32GvbJa+OI0QnGABNXI8F9or3PSnZmGY56BsOBSMTqGRaQOJbQu7HZVhu+p6tv0UHTC/dQX3Vs8U=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5491.namprd12.prod.outlook.com (2603:10b6:303:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 13:57:23 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::d82f:e8c3:96ac:5465]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::d82f:e8c3:96ac:5465%8]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 13:57:23 +0000
Message-ID: <e80eeccc-86e0-932a-da29-3bb58cc29518@amd.com>
Date:   Mon, 18 Oct 2021 09:57:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
Content-Language: en-US
To:     "Limonciello, Mario" <mario.limonciello@amd.com>, Roman.Li@amd.com,
        amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        rodrigo.siqueira@amd.com
Cc:     stable@vger.kernel.org
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
 <7076d49f-b450-d500-fdea-2ec3e59cbf80@amd.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <7076d49f-b450-d500-fdea-2ec3e59cbf80@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR0101CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::37) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
Received: from [192.168.50.4] (198.200.67.104) by YQBPR0101CA0024.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Mon, 18 Oct 2021 13:57:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1252d60-ce9c-4266-0fd0-08d9923f35c4
X-MS-TrafficTypeDiagnostic: CO6PR12MB5491:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB549178881E63EFF7B7BEBD968CBC9@CO6PR12MB5491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUn/I9zTQH/fzFJyaf4YlkMcDsawdyU4zGXuQOqhtTI5FiiE2kJG79g1uOrSJ5o8p2M2czLETkiJqvdCxdhzTEtldgQFDWlNl0+SoLm0sTqPetGNy2BioHDtN9wWudkjIAlww5tkmSF2A7mjNk/C2Ge/P9DmIJvRw7JP76PU7tFHzj3gMO51W/f1i/XaOmeYPorWYC4fsbJJvIZZE4foo7TfrLNs7H0yMnLvNnCwFi9czn1tHl3oaRZVVaV5GPn2w5ArsUWsQr0hvXG2wp7lpcN6kJQYS/VRlElv5A4SMw4OgJFN2qhwZfGB+skoTe+oW/uhmyE8ZuJRUW+0S70AlHSmlKOuSO5kP7KNIGU/ws3suW5+/lvHSGJdkqOh1KxhJz9t5uXvdoa7LVN2AzfmJsQEANo++xOg7HBtCKJjcfSQimRJeRmhBfyz7W9ZaIvPAOjC5+ye6VkabnpJwvNITIBO0x9obefwL5YgBJfVPCKng7qnCAVwqRGbDOk2hW62EftiOAfPb1JetvKc514vC7i59cgteAFP80N0ZHzk7Xg5kC7I39Lw/ktXCEGfle7kV0Iv2qHz3Kic85PfdcxktsbWoJ5TiJH/Oi+X/iHaF45NVLpBZyEFxppcopYKYkepp8qd/U85fAh8tBY+N4IiTmaZ6QPbpxLRWhuUuuJ54dLCnVeYh4fHpyIgLOe+3iwCv9qELNDezMmaeXIrAXGD4/q/6mxi+Mv3fd7ZLsvTCZrK6KjHD00Vm+Eq2vJoUium
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(6636002)(44832011)(6666004)(8676002)(66556008)(66476007)(966005)(956004)(16576012)(2616005)(53546011)(4326008)(2906002)(36756003)(8936002)(186003)(38100700002)(83380400001)(31686004)(31696002)(86362001)(4001150100001)(26005)(6486002)(316002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N004MDVlcDBQY1Z2RnhPN3lFUDRKWCs5NW1nQU1IbUxqTHNmdXZMbEZmUnhI?=
 =?utf-8?B?QzlVVWlCY1hha1hoN3Exd1B4YlpnODBLWWw2MmFPdk5nZDJ3SHFiSy9EcnNJ?=
 =?utf-8?B?OG5kelpnaEFqNzlNdmc5a2YzOVFyZEp3Mk1xYSs1YnhtaGtiemkyVFZCa1NP?=
 =?utf-8?B?VWE5MVNQNTRzaWpyVjJGbnZMeXAzS0dvMnlDaUxpVk9DWEFmMEM5dEUwTEdE?=
 =?utf-8?B?T2hBb3poeGE0cHRSRUJVVDJoY0wzUkNyUDQ0L3JMRS94b3hrM3laR2xlVEpU?=
 =?utf-8?B?V2dYMXoxOE01T0w5cFhOdnZjYkRiM0NBOUN1dWQxTVdKanBBNkV3ZGFjdmwr?=
 =?utf-8?B?N1FnZTBDUUtZVmdUY3pldmQvRGs3SlJNUkJuSzZRU2NUQmRabklkdk1iNVdM?=
 =?utf-8?B?UVhYbnhyWEhUMngxYkF3SDlPRHMvMW5INWg1VnlkSTN5Tlh2ZThDOWpsSFhx?=
 =?utf-8?B?NXZvQTZVMVIzSnorZTFoQTFKZjdDOW4vQWhyOGp5cjE1M2JTeUFrcHRTYzhi?=
 =?utf-8?B?d052emY1R2ZadE1FdSttMnI1MFFxY24zV3N1QWI2czBVY2NjTFRCaS9RQUZH?=
 =?utf-8?B?RnV3V2diTkhVdVZySnFhMlNETmx2OTlKWDVBU0tPWDlMWFRPYTJRVkFENW5G?=
 =?utf-8?B?aStJdEo0WGY2TU9Cc0EyNE1UK0xESWFSOGp1anlsa0xGbk5CMEVGc25mZEc1?=
 =?utf-8?B?Q0V0U2xTaE41L2piK3R1aTVDbWJpeXJEVnhseDJna0hTa1R4ODVDYWVFZGFk?=
 =?utf-8?B?Q0RYRldNUkJ0K0dsRlZPUEE4dTFCZ0N6c3o0UWlFNlNCNkFEQVVZQmpKbXBP?=
 =?utf-8?B?THlSS3pyQngybUN6MXk5alEvU013elorQWs0dm93TGE3eUo0bVBOL1ZrczhR?=
 =?utf-8?B?VmY3akl5bGFIMzdsRHlSR3hGdTZlV2liaHV6QjNlRnZvV0s5MGx2YWRveEZt?=
 =?utf-8?B?TXBtUUFTVDBSQ09Ya3V0Y0tDSmRoWUpsemRTQ2NHb0pvYmxZQk96Tmg2c1ha?=
 =?utf-8?B?RW5RdnZJN0xyeDZkUk1wUnp0eXljZzNoMTF4eklKb3J2bHNCSHRaaGVTNVRG?=
 =?utf-8?B?bkYyNUtvR0ZKZkM4UDRzQ2oxakhmeSsveHVlL1hzRzdIdWY1SkJ1aHNqNUVJ?=
 =?utf-8?B?VFBjeXNpS3kvam5RSW9FU0J1TnFpb1dSVkllUUpoTUs1NXFFMVpBbEtQV2tl?=
 =?utf-8?B?bVZBZGNUQVlHVGhCOGFlNXRxbWZSZ1RERm9Ia0doN2N0OGw3NXdGNDhkVndn?=
 =?utf-8?B?cmx3d3pqamk4clE0Y0pwR3NRayt3Qld4eEVVVklBRFlyT3FhUDdsaStKSGxz?=
 =?utf-8?B?dkdhVVpTdUd0bzgyQlhzVzdLanI0QjMxNUgxT0pkUHVnMlJueHNvREM4Vldv?=
 =?utf-8?B?VlFvdXdjWVlDWlhwdUZLeXpDNUVzNHkxblJOeFA1TTdZRnRZRGU3Wk1xU3V4?=
 =?utf-8?B?UmdxcWNvWWE2cnVDVVpkSTB6d1c5SHBXNmNoUzJRT2lzL0l1ek44TUR1c2Nz?=
 =?utf-8?B?ZXhwN09nclE4SmZPSUptMDVJMGxmeTZTL1h4aFhaVHI5R2VmTGMvT2FtVlMz?=
 =?utf-8?B?cU5tYXVPaWpsbVNiaDIxcndlUUYzOURZNU9oSW1uOE53c2FQTTBXaWZVams4?=
 =?utf-8?B?V1NiaTh0OE5sVVVVNTJsSHZSalkwRDFLby82Y09Nb2x0SjhRV2EzN1RJZS9O?=
 =?utf-8?B?WmJoaTdaUXZMS09xdHN6clpjSzZRdXhUQXJyOHpHWFlFbThXM1NSM0dzUTNM?=
 =?utf-8?Q?qsBbEJMGjJk4vSD7q87TqoLHcT4ZRrkSReHAG/L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1252d60-ce9c-4266-0fd0-08d9923f35c4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:57:23.5368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHUQbw34rvnnk8ohx6SDzUJu6PWeoRfpM9SOuqgeSLlsMNOfkGfhO/vEwfnzOTJd9m/7+jNKVp5r9B/rDf9feQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5491
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021-10-18 09:41, Limonciello, Mario wrote:
> On 10/15/2021 17:31, Roman.Li@amd.com wrote:
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
>> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1735>>> Cc: stable@vger.kernel.org
> 
> This won't backport cleanly to stable 5.15 and earlier don't use IP version to detect the chip.
> 
> Also - a question: *should* this go to stable?  If a user has the older FW what happens with this change?
> 

Good point. Might be better of we drop Cc: stable from this patch

Harry

>> Signed-off-by: Roman Li <Roman.Li@amd.com>
>> ---
>>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index ff54550..e56f73e 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>>           switch (adev->ip_versions[DCE_HWIP][0]) {
>>           case IP_VERSION(2, 1, 0):
>>               init_data.flags.gpu_vm_support = true;
>> -            if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
>> -                init_data.flags.disable_dmcu = true;
>> +            init_data.flags.disable_dmcu = true;
>>               break;
>>           case IP_VERSION(1, 0, 0):
>>           case IP_VERSION(1, 0, 1):
>>
> 

