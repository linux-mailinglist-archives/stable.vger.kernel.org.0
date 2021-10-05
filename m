Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EFC421DDB
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 07:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhJEFS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 01:18:26 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:17149
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhJEFSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 01:18:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cc6Ggj002xbfzfQB1NPYILeJt9BaEWxRZ98DN3EAgpEihw1t0B7Pmx8v4ZBcVsYwrjme5nDMsaoXJG02b6gn0hLnTDX2Gyl6IDNUMQc1GfAW9CqtiqRTwzaPQvvQz7nnjMU+bfrsz12EP4vSUZ0Ark/N+tsPH3w+Aa5rL7M4EX9FxXNIyFOk0G3qG/IQh7hDhWugiUVqclaGkJLkTubyxoKnAj6yoeFMuwLWKLo7IkWqMN51EnUFjebcaRhp+BKzk+9LeobTjOv7BKuuopA/ssv9xhXmoEGqtlb+J/AeHksSXasxub4Vlzlh0n+waqUPX5Z48aSU0J15rcztcOH0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHPdcYrD9/oDRnQ3sTYPyi8DrdbtSpi19upmdGKsNUU=;
 b=i/L8HsW4Y0b8UZ+yLU8YkI6jUVwFLkc95nEVyrxAAymP29KD2/XawaWUj1zLuoBMmk9SjmtFCRInDsW9SUefsDKaLpYfakfcb4U5nt+v8X2wH3MqEUJ5RNEHxYHw3Rjr/jfqh7SsAbKoJnbsXgf8Wwip+w8d5kJ6oDjieeJhhbtILlHw+d91o8DBkGznsOaQWpXexuvxzPbXgCzoKJcs0/ISppgGt0Elugh1CChb8vDVmkdn5kKYq+Wnv83o7MktqwTSePYnmkLw6W9h9X+DsRaLehkTq3Be0fjE53s0OzN5k9J9Von5ViruXwTNyUJs1qtW4zwnHpk7AbpoBnXLlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHPdcYrD9/oDRnQ3sTYPyi8DrdbtSpi19upmdGKsNUU=;
 b=RExtBlZc04VaHaarHfbyExIOm4mOV9X41WinAhGZvip/+nugegUpYsCURbNqCZCkxcR7I7ZZBWgMt1PSc/NM3ydQlIUlnkDhhIulc0YzwxfPrCb7iaakYtglJovDxUB43S46AelPr3wvhyy4jIACzvLE9UfIpd/dYgvhcWKorgI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by BL0PR12MB5540.namprd12.prod.outlook.com (2603:10b6:208:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Tue, 5 Oct
 2021 05:16:33 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::888b:8deb:3f8b:8d61]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::888b:8deb:3f8b:8d61%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 05:16:33 +0000
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for
 PMC controller
To:     Sachi King <nakato@nakato.io>, hdegoede@redhat.com,
        mgross@linux.intel.com, mario.limonciello@amd.com,
        rafael@kernel.org, lenb@kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Message-ID: <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
Date:   Tue, 5 Oct 2021 10:46:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211002041840.2058647-1-nakato@nakato.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0076.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::16) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
Received: from [10.252.89.180] (165.204.159.242) by BMXPR01CA0076.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Tue, 5 Oct 2021 05:16:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9dce909-86d9-446a-fdad-08d987bf4bd3
X-MS-TrafficTypeDiagnostic: BL0PR12MB5540:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB554054202A443D985D4729F79AAF9@BL0PR12MB5540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LAIHWOZ5NDE4yF5wOJ5QNuMEf2hDTvW/+jZYG1thIsOt2WA3DlEgcFzzNsALWqIUz9xgRT9WdKHaUjQWi4pOLPu6lLstD5U/XPtcZNLfd1LEeMfDgTID38IUTnPUBXgoC+F84KlOKDbsYWtkjdSr6pbVu6wSdhYszLuTrSjKaOppfQmgZLqXt9V2P9zoI5M9fdC2Q7eW7rq/Hf6l03h+rtouh8cIN4szYcjVYrg4fhbTffMqOM705Q3R4nQSSW7szBdzJakmA6NXWVQq8b35ONMncJepaOxhzWlOtRgo6gQqY6By6lFZvjQZDtapmQH1lCP3Pe4yaP9Bvn42xxtFOlRHQOdEoxO6nUD9sgPtnLAoX1voylJYvg1Su6/gbO6/U6nJzyb8BgvVENcdFZ1ViJjAOW+POTwxgmUgFu1CDGHcI5R+5x1JANIxD3UPIuS7Y5/XSHUoMZATwJV0RLp5XmB62VkzxhFD61tFQzBqUwsYeOKAJTk7GWQFULDo5EnodttJufcB50H2fNFTUBGvNdsAmYXEczSa4w+PBF+7f1l4xJ+xarcZvbvFqqnQ6v/bQjlEv6zh2BlS3olEgqtelDjTiYim3OWiowv/Ps7MgkvV31OssVcm1Yyb8si7RvJNUrEnkTbwN5dlAMdYUAddGo3I7re47TRQpxLAU8VXIDuCOSO3MgAar4y817cweAj/ZeKofsqhuU3OMJPCS4d3ML4ZtgeC+LLn383rYNhRh2p4pVJAQzUXgG+Le1PZKNka
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66556008)(66946007)(36756003)(558084003)(26005)(66476007)(186003)(4326008)(2906002)(16576012)(8936002)(31696002)(8676002)(31686004)(53546011)(6666004)(38100700002)(508600001)(316002)(2616005)(6486002)(956004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Rpa2VMZTJGc0g2QWNiRFpBOGRpQ3BkV0JGWUFnWHhXdkU3aWhMUG9CalZv?=
 =?utf-8?B?SjRraGxuZGVpQmVEbFFXcnh5VkI5SFVlQXZtaVRmTXY1bGNJUG8rSVg3Y2RW?=
 =?utf-8?B?KzlTVG1CQzdXdGVNeU5abWtVWU9rdjcxK0FqZ0JFSkZzT210TWplWkpiZWdN?=
 =?utf-8?B?SGYwRGoyYys4WVZvRzZPOTNRcDEwd1FDdVR4OHFZM1BTMDlTcHhNMitnWlVF?=
 =?utf-8?B?VzVpMEhlV2dXUXNnSTN5SzErbXRkNFRuMVY4RzdVMUJ1YTRJZGhhVHQ1VFF2?=
 =?utf-8?B?cUxSLyswdEd2MldSYnRXU2tZUXdEZzY1RS9hcllVTjc0QTkyTjhSd1JXbjNz?=
 =?utf-8?B?blJVVlhUVUFQejdKbmRJSFIvaEkrOXQ2WjR3M3MxdXRvN0gvMk94Y1RBV0pu?=
 =?utf-8?B?S0x2YmtJd2NmbHUydGtHL2h5M2NqMThka016SzVNVXlwTENBTjVMNTFyQnV6?=
 =?utf-8?B?KzJ5cDV4WUp1Znlnb3daSDRzNHN2Mkl3UlpjaWZqcXZaWVZ4M0U2ditheTha?=
 =?utf-8?B?NDZjNEcxQTFNbEVzb2xFZkV0Q0J6YWVFUithalU4V1FWVHBWL0RtcWptYVM2?=
 =?utf-8?B?c2EwQklOUitNYldENndmWFllSTg2NlBubGU2U05hWUZHRFlWQUNzMEYrdmNK?=
 =?utf-8?B?NFFrVUlFdGlYWEZRWnZzaEhYSkI1OHcyR2JsaFp6QUc5YlFJSWZOazR2WTBO?=
 =?utf-8?B?WUlaTEhKRDVBUFcxYVZaMDhqemhtUGV6cU1VY0JNcEV1RG5ZNUR5ZmZSSk1S?=
 =?utf-8?B?UTJzd1lXcXNSdWJLZjhhTTRaKy80dTNMTEVaTkRLR3p5YUNzWGJGbTJNcldW?=
 =?utf-8?B?MG4wUzdoQ3V0RHlzdWNlYXlWcmlhQm1wWklSbVJHcGpiaTg0VFpyek1VK2tp?=
 =?utf-8?B?YTV4V2Q2MXBxNU5UK3JZcWZxYzgyZFZjZnFuTHhXeHdnck9Ka2UyTjcyUjdp?=
 =?utf-8?B?dU80ZGNmL1M1UG5LWDJ4ZFQ1T000UTFPUDE1Zm1TVEYzNlNCcDNvWWdJbFdF?=
 =?utf-8?B?L2Q3K0x3eDFaa2lQV3Z3Sm5XVU42MEQ2SWJLS0ZhSnhHRnhMMEpiMTlhZGVp?=
 =?utf-8?B?QTdkUGtMS0VhdDVEVXg1SW40dXNNWE53SVFFbzg1OHJTL1pZUUtSTWIrQzdr?=
 =?utf-8?B?V3FlUG9USnJ6OGZobkNWdUt1K0kwcVA0aFJIclFHdnRCTWRhNjRGMHZrYjRq?=
 =?utf-8?B?VFdMS1ZBVkhDbHB6clc5TnlvVVhoaWgzNDlNSUFLMlVZOTI1bjM0ZStMc2JP?=
 =?utf-8?B?S0tFdnNFbzNCbU12TUdNcFVCTXNocjlSd1ZheitSaStjSDdac05rKzZjZ0o3?=
 =?utf-8?B?R2JLSUlKNDc1VTZSTXJqQnhNUndyeDRoR0tqUWh6VXVOOXdtaUtMMEFJMzIz?=
 =?utf-8?B?d2pKVnRaS2tUZ0M0N0tzaERMaUd6VmZZVXZ3dG1PeStnNkgraW9Wa1paM21z?=
 =?utf-8?B?Ull0TG1CdWR5WExESVM3aVMxcGprMWQzU2RJQ0liT2ZEKzlMZE1wTSt2cTBF?=
 =?utf-8?B?SktaR1JjdThmK3BSVkh5dmtZQWdDd1BNVVpRcTBUbUY0czVMajFFend6YmlP?=
 =?utf-8?B?TklDeTJLQWFDZ3ZubllsamQ2VmY0Wlc0c09wQ1BVVnNyYXhJODFRd1BBUWhL?=
 =?utf-8?B?Q2dHRCt1TStEOGlOQ0NrV3NMVStDdG9lVGpNcmxLZ00zaG9kZFhlRTBYaWZn?=
 =?utf-8?B?RGZ2MnJUVyt1a0Z0N2dJdmZBMExHbWxPNVhiYlkrYTBmc1pkdUN3TW9YY3Fz?=
 =?utf-8?Q?i6VbxxVOnBwsYYYfJd8CpzUV5mpvvZzbSlCk+dD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9dce909-86d9-446a-fdad-08d987bf4bd3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 05:16:33.5968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NaSVgZR0FwFcQFAajhF06p6De2it5NtFmu9suOrhWOToL+sTsZQX2OZCGBAFHIBwL7DjCJoDUqNjEhzkhMEKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5540
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/2/2021 9:48 AM, Sachi King wrote:
> The Surface Laptop 4 AMD has used the AMD0005 to identify this
> controller instead of using the appropriate ACPI ID AMDI0005.  Include
> AMD0005 in the acpi id list.

Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'

Thanks,
Shyam
