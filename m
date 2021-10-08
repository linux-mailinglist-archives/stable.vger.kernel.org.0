Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350C8427123
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbhJHTD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:03:56 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:27909
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231312AbhJHTDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 15:03:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHMApZdhD2Ndg1pCYEKI8JWA4wA+xfUiXjTJS+gc60Hvbp3XMpv+Us8ekOE1unyHxtlGwaXpBz1LboEdXB29OzpfEqEOn7X6CMA7lV1yz8Dkz6+cYvY5RnzLTGQhb92rgwrJnEQDwqt+aiX6MkeNBeQp2LlBFlHPvEsDYrFctHWxKJunaH29mt+EevDONsGtEoz7E1pjCc+mSCLKb5D2qplzdiZSs9EHeVVTpW7p/LoA0acBD1jKqccaOaUQSiUvUlEPLvWd2v2lm7FKer7D4fxbkY9atiuWSMrfmzfc9aGb+mz2A0kNeVfZHBGIqtl/amkS90tHS4OaNtkox79oqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ6U43s3GpnAiCq6nEuuxnLzQUz3PCKMj8mmwBxDyb0=;
 b=MbotNW0P1kFYVonfgjhoog+CR1GRrlAPsp/f5+irvlt0vqTX9VGxy79AlTQfVGjaC9kTL2IqhOP4ehUuyVAOCqLG1uLMyk0gA/0t1Ld6rvKjT0mtHAU3zD2xBUZEYHF6sgDN7qqcXHDpvaKiSxZEK3VL58s89wkCU/czDWohz08NmD6q9D9CWtgrL6HbVRLru0ucI53AaUXyS4Q5OapNhPvLu+9rXmkpW1ytOFQCWu/9u6RArZ98/jPFT5AhcQCpt5DlTQ82SIIYgZvb7kX9wUsVhEDQ/DdP0KM+xgSLd6ez90PObKQ5etDD8GugVW1u8tu9AHnBq3PknPiE6hs8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ6U43s3GpnAiCq6nEuuxnLzQUz3PCKMj8mmwBxDyb0=;
 b=oRSVJQAgQXdn6agD0+rzGMlL8GcBNOqZ3LpM7FAnwJs34cdvoXYaRdNKitdu7ACAtJPSmkogXcjCkgnyRbR6TFTTvEKzTkaVP2UKzEM2D9zXPzWK9MKb2hjjLu+TU7cygLZqwx5nEkqBrg9qmCuEM10ODWaQnHTq+fhOO+t8ARI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 19:01:56 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 19:01:56 +0000
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for
 PMC controller
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
To:     Sachi King <nakato@nakato.io>, hdegoede@redhat.com,
        mgross@linux.intel.com, rafael@kernel.org, lenb@kernel.org,
        Sanket.Goswami@amd.com, Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
 <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com>
 <609f5254-4527-38b8-3d1d-5cb06791e103@amd.com> <1837953.FDaK0lLtFO@youmu>
 <42e9a7d0-536f-bd15-0c4a-071d09195bc2@amd.com>
Message-ID: <fa761e91-0aa7-d18d-a1ad-17325f419c4c@amd.com>
Date:   Fri, 8 Oct 2021 14:01:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <42e9a7d0-536f-bd15-0c4a-071d09195bc2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:805:ca::42) To SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.254.54.68] (165.204.77.11) by SN6PR16CA0065.namprd16.prod.outlook.com (2603:10b6:805:ca::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20 via Frontend Transport; Fri, 8 Oct 2021 19:01:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7935fa04-c5b4-488d-d195-08d98a8e1977
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB46704010FE9809AB85234680E2B29@SN6PR12MB4670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ho2f3NxALz7ogx0tVdzzWr5nDilzkUvsedQ/FNmsfWPuSKlotKkIpgXpwk+2qNj1i5PwYfKNSnErc2XMYdy3Hl7tXA83TZ6qJ5HAK22nbDBzMSmhXU1ydeniNBBFbyW7FZJqrAgXoNK1Nj+Lv/pg3nM3K0jg9N7LEJlgxFzMDkhT4u8rNIm+Tjbd2BBi12PfgBIr2tPRh3wbmsBnKZz6rPTLVp8iI/8Zj6vj3qonfSSx9RCA3IMvCpIfU4Qt5G9NCeUoFZ+ucYbQgnCR34Z0zCOasYPXAOnQuxCdv1NnIeINEI2WcFLIv1CfFH4UgmZmzuwTveJsAG+cxWi1xOSmfoqCPa3aO5Nu6gBesVq4uCaKQ8tgJSB5t4NvbAGNYat7JHWy5K7xMqkVezmCsMJBC+d6fnWr0CxN+acNyX6psxL06yacP5QZTEXdPA5dnhQMDFlP6KxM0UjReo/PvzynrUBD5VyX4+QOBkLgsYpgeyGO+59r/Jv/uiqS4L5DUbUpfMBAMkes3tBQllLu62BbeR/kvaSNxy/EWY8UuVGEnQvODOQW/ggsAR+h9qAEHYthS967wTq8UI3ZvS+F0ei2yArWAqUbepl5yoOdGJrxaQ0bBlkhqMNYX6r2EFNwP4T1xKgAGKAPW1uGJ1R8PPkwzFAYieQRdjvb2OtCO+WDWSHx8Lb1bzu9N/l2pIKtr3E//eHgIPJp8mIwegIDB2Ui4UmHkbZeSiE30iCWFaR2MHDhMbE4VYYgJ9Ar963jTU4N0JCM1HPFA7tVgcv32E5OPJONMTdJB8zZI3Id9iWlWnrjXULG/EPTzOFkJOn1FcqSOWomkfzJbZL9nRATKMta3zB10lswis1tdOL5Yg+4skM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8936002)(508600001)(31686004)(2616005)(53546011)(30864003)(966005)(38100700002)(6486002)(83380400001)(956004)(86362001)(66476007)(6636002)(2906002)(110136005)(316002)(16576012)(26005)(45080400002)(66556008)(4326008)(8676002)(36756003)(5660300002)(31696002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1RUOVVlb01mei9hZVhZRmNHTVkxS1ppWGpkd2ZsUUN5ekYrVjlsRW9aVlJy?=
 =?utf-8?B?cEd0K0xnMlROdzMzaXFUdTAvRjBwdjRIVG5iWGtIZlVJTnU0MjQySGxsaStl?=
 =?utf-8?B?V0ZJOGp2UkJrckZidnUrUjVHMUYrQktrZlFDc3J3a3dXOHU4UDMyME81NGdR?=
 =?utf-8?B?aG9aazlHWUIwdW45N0hlVUZpeHRaSFI3YXQxb2x3Y1BlSXBXVW1hb0Rrc2ty?=
 =?utf-8?B?UzdUekI5MGZxWDhHMCs1ZXVIby9td3l5YWFtVERzY3drZW0yZXF3UVU0M3Ey?=
 =?utf-8?B?WWNxcmRRVmk1ZXlrT0x2b09VTVlNUjk5cWlDVTRicktOK0xlYzVyNk83RG5o?=
 =?utf-8?B?MVdiZ20vWkh4YnlLempvdzY0S3U2dCtESy9wUzUrNWxhQm5HNFVZYWVnK2ww?=
 =?utf-8?B?aWdPSDF4cEJHQmpnM2dUeG1ycE1xYThDVSsya2tsejdHOEtRYmE3R2tQTDVW?=
 =?utf-8?B?SnRnK2pILy80WVRGYXFCS0RPQWkvYmVNd3lsSDVmS3RWckJEelFkdURqUi9W?=
 =?utf-8?B?RGhxUDJSQ3h0UWRaV0ovTDBzTi9oaFJFcUxST2ZicHphWkhjWlVMemJtT0Ir?=
 =?utf-8?B?NFN3MXlWWEw4bkxPZkdqbDlDSG9LclBidUk4amYvbjJQenhzdkNRNzFXU2lL?=
 =?utf-8?B?WDVnMm81U1lXZUxFQjdmZEV1bkR2cHNuV20rdlhJb1BUUnlLM0FYOGgrVUxZ?=
 =?utf-8?B?WmNwQVY2SThlSzJGYnJ2VnZPTnRYWnpMbEVUSXRhanRySzYwa3BEUEt3MjZw?=
 =?utf-8?B?YTVqN2FEVGtmUkVHMG16bURIaWptMnNSNFpsWGdXenlrdjFHOFZvaTZQK0RR?=
 =?utf-8?B?d0J4UjBaY3RMSUlHckJubFA2b2h6SVE2Z1BoUmpUbHdpdWNKemp2bWRiclJ1?=
 =?utf-8?B?dFV1amE3WTNoYUNjS2U0QnU5eVhGNmswWG1CY3E4bEdmdzFFS3E4bnVzdFp0?=
 =?utf-8?B?UnNGUjFWbFRIdndEa294aEVzcTBSWDlkZkdUa1h3ZjZSUEdJSnlSbkZGbGtu?=
 =?utf-8?B?V25pY1UrbXVYVTBMR0JvV0g5WTBBOVVocE9USm10QThjNkxnQ3ZQQ1JTS2pB?=
 =?utf-8?B?Z1dtRE0xeng5TmJGblU5a3pBQWx5QnA2VEhweW1nRGtadFFqQURkcXJ1UWRu?=
 =?utf-8?B?Tm9yOC9pM21sNVR3bGVwM1hnN1NjMjAwbUt4eUNGODZ6QnNhY1dRRUF1dVNL?=
 =?utf-8?B?ZFJhOTJrSHFMRmJHRWcvOWdQNjZtTk40OTJQeG1hTzJDVGlvQ0pxN3dqTWRN?=
 =?utf-8?B?ZE9IV2o4VytETUxPMUNmVVpYakpXWXZybmNTYWRndlZnL20vdFJXMDNvVGhr?=
 =?utf-8?B?ckhPWGF1b09LZmc2L1BqTUs1VWYzaGNwa3AwZ0htL3BGTGNPQzNMcFZlLzd0?=
 =?utf-8?B?MlpnWDh6MkdhSWt3dCt4RFJqRkxLc0J4MDFrTWRNTTFPaURIOFdaT2MwZStr?=
 =?utf-8?B?ajcxcmxsdEJkYkc1RVdtV2YxK3hxbHplUDBZYTMrcFRpbjJMczQ5Qm9SaklU?=
 =?utf-8?B?eXVUdDl4TlhGZGxacGRGbTZPY3FFV0kycjB1NXBwQ3BnTkdMV3UrL0FSdWxu?=
 =?utf-8?B?YVU3N1BjYXhQK0NOZVNBd0tYcjB0TC9ua1ByK0NXdkhlaVJHTEVsb1ljYS9P?=
 =?utf-8?B?OGpKQVQ2OEhiaHNNRWFJSk4rbEtRUXAzcVZvZ0NnQVZRcjJYTDRKTXd0Z3ZO?=
 =?utf-8?B?bDVIbEhaVUVlckFDY3k2VEpFd0FZQmxYWC94UmdidkMwdUIyVHVsVGtRcXpj?=
 =?utf-8?Q?jOBwReIlxX9/S4/fnkR0vynJ9VZUNvsuwz+vTLH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7935fa04-c5b4-488d-d195-08d98a8e1977
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 19:01:56.8062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioqJRO59rHtnAVmyWuyo4lzV5izOwLotkVsxBO4MtG8CBITb5Z9SKGRM21Hvt24VoZ/fhM/eWgMu75Ac6TOeLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/2021 10:57, Limonciello, Mario wrote:
> On 10/8/2021 07:19, Sachi King wrote:
>> On Friday, 8 October 2021 21:27:15 AEDT Shyam Sundar S K wrote:
>>>
>>> On 10/8/2021 1:30 AM, Limonciello, Mario wrote:
>>>>
>>>> On 10/5/2021 00:16, Shyam Sundar S K wrote:
>>>>>
>>>>> On 10/2/2021 9:48 AM, Sachi King wrote:
>>>>>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
>>>>>> controller instead of using the appropriate ACPI ID AMDI0005.  
>>>>>> Include
>>>>>> AMD0005 in the acpi id list.
>>>>>
>>>>> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
>>>>
>>>> I had a look through the acpidump listed there and it seems like the 
>>>> PEP
>>>> device is filled with a lot of NO-OP type of code.  This means the LPS0
>>>> patch really isn't "needed", but still may be a good idea to include 
>>>> for
>>>> completeness in case there ends up being a design based upon this that
>>>> does need it.
>>>>
>>>> As for this one (the amd-pmc patch) how are things working with it? 
>>>> Have
>>>> you checked power consumption
>>
>> Using my rather limited plug-in power meter I measure 1w with this patch,
>> and I've never seen the meter go below this reading, so this may be over
>> reporting.  Without this patch however the device bounces around 
>> 2.2-2.5w.
>> The device consumes 6w with the display off.
>>
>> I have not left the device for long periods of time to see what the 
>> battery
>> consumption is over a period of time, however this patch is being carried
>> in linux-surface in advance and one users suspend power consumption is
>> looking good.  They have reported 2 hours of suspend without a noticable
>> power drop from the battery indicator.
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Flinux-surface%2Fissues%2F591%23issuecomment-936891479&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=MND10b0iIblTgywFsxoLNx7D1bZuLZOmbqbhQJiezxM%3D&amp;reserved=0 
>>
>>
> 
> Thanks, in that case this is certainly part of what you'll need and it 
> sounds like you're on the right train as it pertains to the wakeup sources.
> 
> For both patches in this series:
> 
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> 
>>
>>>> and verified that the amd_pmc debugfs
>>>> statistics are increasing?
>>
>> s0ix_stats included following smu_fw_info below.
>>
>>>> Is the system able to resume from s2idle?
>>
>> It does, however additional patches are required to do so without an 
>> external
>> device such as a keyboard.  The power button, lid, and power plug trigger
>> events via pinctrl-amd.  Keyboard and trackpad go via the Surface EC and
>> require the surface_* drivers, which do not have wakeup support.
>>
>> 1. The AMDI0031 pinctrl-amd device is setup on Interrupt 7, however 
>> the APIC
>> table does not define an interrupt source override.  Right now I'm not 
>> sure
>> how approach producing a quirk for this.  linux-surface is carrying 
>> the hack
>> described in
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F87lf8ddjqx.ffs%40nanos.tec.linutronix.de%2F&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=5dWwpgh%2FRIA%2F57UpY5h0l9Snzem%2BNpirgE6ujEHO7aY%3D&amp;reserved=0 
>>
>> Also available here:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F25baf27d6d76f068ab8e7cb7a5be33218ac9bd6b&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=HPZfqPoVUJT8w%2FRD7UaVjegT0iRLDlRkXfOwMx5HS8Q%3D&amp;reserved=0 
>>
>>
>> 2. pinctrl: amd: Handle wake-up interrupt
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Ftorvalds%2Fc%2Facd47b9f28e5&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=gUtHcFKolVIZeHtIIJuT3BkruQbjq8NAOU5504%2F02Mg%3D&amp;reserved=0 
>>
>> Without this patch the device would suspend, but any interrupt via
>> pinctrl-amd would result in a failed resume, which is every wakeup
>> souce I know of on this device.
> 
> Yes that was the same experience a number of us had on other AMD based 
> platforms as well which led to this patch being submitted.
> 
>>
>> 3. pinctrl: amd: disable and mask interrupts on probe
>> Once I worked out that I needed the patch in 2 above the device gets a 
>> lot
>> of spurious wakeups, largely because Surface devices have a second 
>> embedded
>> controller that wants to wake the device on all sorts of events.  We 
>> don't
>> have support for that, and there were a number of interrupts not 
>> configured
>> by linux that were set enabled, unmasked, and wake in s0i3 on boot.
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-gpio%2F20211001161714.2053597-1-nakato%40nakato.io%2FT%2F%23t&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=mwJgcXBY9zdlTG671KssViHdSwHfq6DCJ2fpeLbRbR4%3D&amp;reserved=0 
>>
> 
> We'll have to take a look at this to make sure it's not causing a 
> regression for the other platforms the original patch helped.  If it 
> does, then we'll need some sort of other messaging to accomplish this 
> for the surface devices.
> 
>>
>> These three are enough to be able to wake the device via a lid event, 
>> or by
>> changing the state of the power cable.
>>
>> 4. The power button requires another pair of patches.  These are only 
>> in the
>> linux-surface kernel as qzed would like to run them there for a couple of
>> releases before we propose them upstream.  These patches change the 
>> method
>> used to determine if we should load surfacepro3-button or 
>> soc-button-array.
>> The AMD variant Surface Laptops were loading surfacepro3-button instead
>> soc-button-array.  They can be seen:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F1927c0b30e5cd95a566a23b6926472bc2be54f42&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=PGWON0kCpByJtsO1rS9wrYr7oH86V%2F8M%2FYLmUoFjBhM%3D&amp;reserved=0 
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2Fac1a977392880456f61e830a95e368cad7a0fa3f&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=B%2BBW3M4L5TLCq3Fc6oB0KHaC9A%2FQp3uwkB2Jby%2FdDo8%3D&amp;reserved=0 
>>
>>
>>
>>> Echo-ing to what Mario said, I am also equally interested in knowing the
>>> the surface devices are able to reach S2Idle.
>>>
>>> Spefically can you check if your tree has this commit?
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fpdx86%2Fplatform-drivers-x86.git%2Fcommit%2F%3Fh%3Dfor-next%26id%3D9cfe02023cf67a36c2dfb05d1ea3eb79811a8720&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=XdRCk8klBuDRCk7UWL%2Ft5wiupVVgdCWBqFmaYgGK%2BFU%3D&amp;reserved=0 
>>>
>>
>> My tree currently does not have that one.  I've applied it.
> 
> You should look through all the other amd-pmc patches that have happened 
> as well in linux-next, it's very likely some others will make sense too 
> for you to be using and testing with.
> 
>>
>>> this would tell the last s0i3 status, whether it was successful or not.
>>>
>>> cat /sys/kernel/debug/amd_pmc/smu_fw_info
>>
>>
>> === SMU Statistics ===
>> Table Version: 3
>> Hint Count: 1
>> Last S0i3 Status: Success
>> Time (in us) to S0i3: 102543
>> Time (in us) in S0i3: 10790466
>>
>> === Active time (in us) ===
>> DISPLAY  : 0
>> CPU      : 39737
>> GFX      : 0
>> VDD      : 39732
>> ACP      : 0
>> VCN      : 0
>> DF       : 18854
>> USB0     : 3790
>> USB1     : 2647
>>
>>>> /sys/kernel/debug/amd_pmc/s0ix_stats
>>
>> After two seperate suspends:
>>
>> === S0ix statistics ===
>> S0ix Entry Time: 19022953504
>> S0ix Exit Time: 19485830941
>> Residency Time: 9643279
>>
>> === S0ix statistics ===
>> S0ix Entry Time: 21091709805
>> S0ix Exit Time: 21586928064
>> Residency Time: 10317047
>>
>>
> 
> Yeah these look good, thanks.
> 
>>>> Does pinctrl-amd load on this system? It seems to me that the power
>>>> button GPIO doesn't get used like normally on "regular" UEFI based AMD
>>>> systems.  I do see MSHW0040 so this is probably supported by
>>>> surfacepro3-button and that will probably service all the important 
>>>> events.
>>
>> We require the first patch listed above to get pinctrl-amd to load on 
>> this
>> system, and the two patches mentioned in 4 so we correctly choose
>> soc-button-array which is used by all recent Surface devices.
>>
>>
>>
>>
> 

Sachi,

I was talking to some internal folks about this patch.  We had one more 
thought - can you please put into a Github gist (or somewhere 
semi-permanent) the output of:

# cat /sys/kernel/debug/dri/0/amdgpu_firmware_info

That way we know more about the FW versions on your system in case of 
any future regressions stemming from this.

Hans,

If you can pick up the tag:

Link: 
https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd

as well as that value for "Link: <url>" pointing to amdgpu_firmware_info 
in the commit message.  Or if you want Sachi to re-spin to do 
themselves, then Sachi feel free to add my Reviewed-by tag in your v2.

Thanks,

