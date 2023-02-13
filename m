Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E126A694E18
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBMRdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 12:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBMRd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 12:33:28 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186381CF69
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 09:33:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODJqlXNXENzw1ckoryNgDGu1/I9/5yZS8tS7Z11XHNKZvSvbUMSnOTOkisnmd9PU2L2di2J8a+WxSdweiCURyItrXwrYKVF/xo2zqp2qwuvWBpAq4tqSt1sEmLqGbZy76m2aOw4ibUctQtaqEtwqeSEeoxHzB8e6W4KlhtdjGgyXMkbYHRARf/6cLGPt2kZpxZfXH2qlpHzSoxryzWuMkffuFml2/CVgFeNRIwnU2tDtpjHcZVsnd8edRubk0d9li0jDFu5hyn0GCqUlux6cb9UoyGbt/F+Quzuf0ZF2Vmg9M5GcRz22bMQpphoe5NoVk2Pw9gcH2jurZ2xsGMrfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zm425mszWTAs17mvCP6ontX7LeUbfz0pzZa4AhK8PH4=;
 b=QhhczOcvInq6LXb/ZFHh78nmVNCLySwcwC4sCXvoOHNSWETmnxFu4KLdW5lUxzoTCFJT0jH/etz+UhTE/54fSeov+W6q1e00oy+LW+w9NKc93JGifnchwQUdzkL3bP847uqFhJ14Vcfnr3SaGy27d83jeRoadtvlALouVEICneRsiEKsGcJnbbixuz94B9utF1GdGVN07q9aHljOC3h9/byObKzltA/Y2NLmAICbQRmz65GZLFqSxxs9HCbUUi4BJLJvastTzeZzYk/YxzL3nkjT8hND2fzhvnvbpoZMXEMlqJNLYK5cqvbPHKW8cyI1MwGGosI2oL75R+jNCzdhOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zm425mszWTAs17mvCP6ontX7LeUbfz0pzZa4AhK8PH4=;
 b=B0ikiGVAmWENxerxpqtjc3EBNBj6IwSQAli7LsdKQp2b1oFX/Lax02pHHRtNxAg58b30WE1pOukiiQT9yHGj0HAPcjGI7T02grRf1Xtinsh830FiubU/7Yjfg+M0vsNzQ7HALNq0vRIK69w5jC93/6cSC0PeVb1DAF3AjAgrfKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY5PR12MB6154.namprd12.prod.outlook.com (2603:10b6:930:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 17:33:22 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 17:33:22 +0000
Message-ID: <450de358-f3bc-bb26-cf7b-52e849c49612@amd.com>
Date:   Mon, 13 Feb 2023 11:33:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [5.15.y backport 1/1] platform/x86/amd: pmc: Disable IRQ1 wakeup
 for RN/CZN
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Xaver Hugl <xaver.hugl@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
References: <20230213151543.176-1-mario.limonciello@amd.com>
 <20230213151543.176-2-mario.limonciello@amd.com> <Y+pV/CuA/SMeqXen@kroah.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <Y+pV/CuA/SMeqXen@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR17CA0036.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::49) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|CY5PR12MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d649d4d-a827-42db-480f-08db0de86733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0davcN8GpuLqt2RQaSM/e5F99DAz1B0/raRfRs5kFPqjeO+CGICdomOucPiYZA3N92AcH5LB9QRV18NUmYajd6ZIpZdH0cBbJncVTIxVUMzAt5GI+jckzpMNV6+utO8jCmP2Hsn7J9Rg3ab0UAZk7FGOfTv5XK4+GJUHfeDZjj8mUecU5516fAXh2UEcAviTI/bLuQR6seAomLzxT/SbILOZXzoD0GeG2Rpm9JS1YtV6YV22K/KgnmAjzgAKt4zfiCW1v8T8pd0KpmeQJVCavLWP3OSJjFxVkl3ymKRGWlopPry/IqwcGxQ+2OjS/gk6boYvgtiMtYz5hWSWWlgIT6TQZv10ke6qJsSMUIhz6ybq2V8ByNY9sO+aKSDhS06Ls7/PKA5z5R5Zz3tPpSDhW+hfs4bcT5JaO6aOHcPfVKPh5sO3r6sCgN3XzPGPGANVbQknnJbKCHxR+nUfQW1/H14IfJT7GW6Op9OSd3hpVtvV44SNybEl4E9SXIXowQnj41lKOOXAIqk+8oi8735wx1A0jL86Sb8iwxxkLW+Z9NO6mA+AcbVZvTSmg/vfuuacTjbBroiW4qnNhWPZ2n9/Bl5F89Ucp9bTffRtJ1uDBSvmjRdetKiFk7lkOFei69ErGqKe7VRKdaGCxl9wuJNoCU3Y5mFuJkxctaoO1l2WJiO4FAMoNdB0B8EHByNFjNocZbOlpszzgF9wmKP5hD87GK6Ifa9HNJ+IeAdFfSvTvwPnTWaBfcGRG1YCApVbN/5D3Qnv/IvOqwZOTOy/GqnGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(478600001)(2616005)(83380400001)(53546011)(6512007)(186003)(6666004)(6506007)(2906002)(36756003)(54906003)(316002)(966005)(6486002)(41300700001)(4326008)(6916009)(44832011)(8936002)(5660300002)(66946007)(8676002)(66556008)(66476007)(38100700002)(31696002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUhzYlFpb0lJTFFVcmNVSk1kN1FDQzNGWk9BVDR5eHVEV2YzLy9HVGRTdy8y?=
 =?utf-8?B?NWFEbFd1dG5rUTl5STBDYlJVK281OVZpYXlRUVVzcnFINzhrcDZVWWJCNnQ5?=
 =?utf-8?B?QmRBWlB3ejU1UGo5Z2pLZGp2bDQ3OTNzdDIwM3BaajdNNDVMU1FkaS92cTRF?=
 =?utf-8?B?RnQ5cEdraTRROU8yK2RNbFozNFlldVRYbXNSN0VOUmEwZWN1clZHTTN3aWk2?=
 =?utf-8?B?TXZXa3pBdXhhRno2ZDNQWTF0VDM3bEdrSnZLaUs1VWxBaXRSQ3dPV0t3OUE1?=
 =?utf-8?B?T3ZuMmY0VmRxZmdFSE95cjJ5SVZtS05CUTdxQytmb1ZWNVlYQlQ5amU4ejA4?=
 =?utf-8?B?Y096MHk0dGVsV3Q5WjZtcmlZWWo1TG95eStWVnloazhNYmVhN2Z3UzlvYitN?=
 =?utf-8?B?U25VRTkvVVFLbWJFTVJPNEVuOGZqNENFSFNZV0tDWGJvMGpXSkMzc0RVN0du?=
 =?utf-8?B?blFJNWtsWXJyU3hpTktVQlNNVytEV2s1SFNjeVRNSDNmZVk0YXZNZnhPRllS?=
 =?utf-8?B?eGY2ekgzM2U5MmlRTGhvSVRFK1Z2ckYweExIR1RwOVFRTXp3SkNPMW9lY25K?=
 =?utf-8?B?Sk9rNGhsTmtHOXZMR3dUZ1RJL3RpVGZoT0M1VUIybkhmVi9qbmE2MmFVNTJn?=
 =?utf-8?B?K3JtYzJCenJPaXdtTUg4cDd2Ym9naDR0YUNINTg2NTBtTUk1RDBhNENNN3Rr?=
 =?utf-8?B?RVJDUHhqOE9MSmZsRjdpdWpTT0kxQmxUVUJCbmVjK2V1aDNOTmNxQnpJYm1H?=
 =?utf-8?B?MVp3b2dGSCtma1YrMDhEOHRIY25wa3NsSkpmMmdKL3J2RHhZUXJIbjZteVhn?=
 =?utf-8?B?dVJoVzV2YlNjTmhWNENaTVorSTlvNm9uam12YmYxcUFBeGl0M3Jtdzl5TDRH?=
 =?utf-8?B?TmIrRERSbndYMFROSDU5blB3aHc2dU9YVXFMbU9xU05NcjVVUFk4WVkvRW5E?=
 =?utf-8?B?WVVJTUVobXdEWnNIallpYzAvYmRmVGRZN1BGZk5qYWIwUFkvcXNXWnRyWFFC?=
 =?utf-8?B?ekNYc0QyN2ZaQ1AxSnE4MncxaDR5T2tZaWw3ekhFSGpPdk41UGM2cnJLRTd6?=
 =?utf-8?B?YmovNmJ0WnFiRDRGUmx2a1JFQWMwM08vd2tvMmVRend4TVRtbVpxUGlXRmt1?=
 =?utf-8?B?L05uNlBNVXZFejJjcTU0cnMyeDlCU1pWSEFpNlJxRFFlWmdhZzZvZ0pHdC9W?=
 =?utf-8?B?RUNHNEVlN3FFWFAwaHk3dUNORzZwYmNkTGJYM2ZRd0Zpa1N1NlFQU3YyVmpG?=
 =?utf-8?B?d282VTR5TmhWRFprMHBha28zTmJsTmlES09BT21HdmRTaHBOQVQ4M1FqMkhO?=
 =?utf-8?B?SS84aTBId3U3ekNkWEsvdVkrQTRqc2VNb3NJVnA2YUl0QjVFUEZjRFpRa0Q3?=
 =?utf-8?B?ZUlxN0ZxUFRkeVd5SzBjQksrKzZERWxGRUFqRm9qMUlWWVFUcEJzeFJDei9w?=
 =?utf-8?B?TmdnZ05uL1BMamdNMDY1TzNKVXhWMjM2WTNqL3dnRWxWSkRDMlJnS3IvakI3?=
 =?utf-8?B?NGtKVDNaZTFqMUszZnhZNGROeXhaZW9NMTR3bVJXbjBieXBzY2huSjNCdVZR?=
 =?utf-8?B?NGhkNHFvVnBQdjMySjJQVUpHV1pxakg2QW4wVnJVVVFEeHk5L3NJaWp4YmYz?=
 =?utf-8?B?L2QrRFR2WlhCblpSRS80SDBHWWQ0VjlIaXlCeGN2ZTZWclNHY3pNRWtEbGpm?=
 =?utf-8?B?TkRLVTBJdDRKaFR4U0dkazRZRGVoR2NxWXZSd0Q5MHZJd0FaYnJaU0djc00y?=
 =?utf-8?B?Yy9OaElXOC9NWmJoVnJaU3JJRm44bmR1VGtqMUZhOEJKaitRVWt2QVpsME56?=
 =?utf-8?B?a1FqdE9WWVhMR09JRHkyc0hOenBycmNkeGdOcFJtRkYvT2k5bW1XY0hGTSs3?=
 =?utf-8?B?empNdXNKVXZWZTlub09oQ3d6VWlubVpXcHJpL1poRXk1elhoV3FiWHhzRW5G?=
 =?utf-8?B?T2pwc1ZpeEU1RUlZRHpPTE52NytWcDBTSnFuOFBod2g4eGFieEpya2dUL1lw?=
 =?utf-8?B?NVNaeWRVU0ZtZ0ZwYkp5SEx4citTNGVUUlBXZUNLMkh1RlI2QVNMV2xGM2Q1?=
 =?utf-8?B?RUlPTHpiTGdsaythMzhBZnkvOGE4ZWtsaytNL2pFZkVtK3BxVUszYTJJN3V2?=
 =?utf-8?B?cmxUQ05zK1JnK1F2amo0VlRUc1kwWTRaV0g5ZEtvK2o1T2hXMXRtcmhDRFFV?=
 =?utf-8?Q?ikxKJxa39soTGV7QsPA/9qjf5EfNfyL7RxEAK0wP7M88?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d649d4d-a827-42db-480f-08db0de86733
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 17:33:21.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g08iP914GpJ64GEkomcKeKjs3vcfTy6Exoe8Ly36cCireXoS7CoT0CHkkrd8Aka+BUZpsiFSi6qg36aTw4PKTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6154
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/13/23 09:23, Greg KH wrote:
> On Mon, Feb 13, 2023 at 09:15:43AM -0600, Mario Limonciello wrote:
>> By default when the system is configured for low power idle in the FADT
>> the keyboard is set up as a wake source.  This matches the behavior that
>> Windows uses for Modern Standby as well.
>>
>> It has been reported that a variety of AMD based designs there are
>> spurious wakeups are happening where two IRQ sources are active.
>>
>> For example:
>> ```
>> PM: Triggering wakeup from IRQ 9
>> PM: Triggering wakeup from IRQ 1
>> ```
>>
>> In these designs IRQ 9 is the ACPI SCI and IRQ 1 is the keyboard.
>> One way to trigger this problem is to suspend the laptop and then unplug
>> the AC adapter.  The SOC will be in a hardware sleep state and plugging
>> in the AC adapter returns control to the kernel's s2idle loop.
>>
>> Normally if just IRQ 9 was active the s2idle loop would advance any EC
>> transactions and no other IRQ being active would cause the s2idle loop
>> to put the SOC back into hardware sleep state.
>>
>> When this bug occurred IRQ 1 is also active even if no keyboard activity
>> occurred. This causes the s2idle loop to break and the system to wake.
>>
>> This is a platform firmware bug triggering IRQ1 without keyboard activity.
>> This occurs in Windows as well, but Windows will enter "SW DRIPS" and
>> then with no activity enters back into "HW DRIPS" (hardware sleep state).
>>
>> This issue affects Renoir, Lucienne, Cezanne, and Barcelo platforms. It
>> does not happen on newer systems such as Mendocino or Rembrandt.
>>
>> It's been fixed in newer platform firmware.  To avoid triggering the bug
>> on older systems check the SMU F/W version and adjust the policy at suspend
>> time for s2idle wakeup from keyboard on these systems. A lot of thought
>> and experimentation has been given around the timing of disabling IRQ1,
>> and to make it work the "suspend" PM callback is restored.
>>
>> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1951
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> Link: https://lore.kernel.org/r/20230120191519.15926-1-mario.limonciello@amd.com
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> (cherry picked from commit 8e60615e8932167057b363c11a7835da7f007106)
>> (cherry picked from commit f6045de1f53268131ea75a99b210b869dcc150b2)
>> These have been hand modified for missing dependency commits.
> Can you split this up into the 2 different commits and submit this as a
> patch series so that we can track this over time easier?
Sure, no problem, will do that and re-submit it.
>
> thanks,
>
> greg k-h
