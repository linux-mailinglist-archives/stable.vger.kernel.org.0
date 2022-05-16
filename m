Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BC8527C35
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 05:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiEPDGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 23:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiEPDGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 23:06:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5602BC12
        for <stable@vger.kernel.org>; Sun, 15 May 2022 20:06:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IF9+KN+urOpGCKca5tT8ZQCb55qdWIxynjtOAqsAS8BgrcK29NqgK7sAE29vOD97BM5GPBOQha1jKOxZszq9dsErk+lhCUxF6/XjFSv8eZ8j2C09h1r8MyZ2QAESU5+O0Q4plx8RJCkP8mpbmGMxFOR5DpnnUgMf11fCkU5knLvFMzbU2HOoB9vR3IwrNDg006RFyGQkImlMgyYKsizHCXy24GSDroo6nxz1ieowC7SRhKZ+wTe635P1wYFK+r/7bkimFZIkgKWiTjx0t5PNP3A7t1gCsCjDbnHA/OkehhqDucQoVl1FUdhOlPEfIPhHhkrP2mFCxdBPixw9rkW40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8iRIF59YzpqwdFEzkvyeCs7KobzHjgVCXwH6BHXR5E=;
 b=CORKfFq/i3d3KHDnCn9RLj1G9+yFmpoP4i12QZXpDFV5EhJXEcUHhWYbnWASbxwfXJl1aOSBOGq3lH3IMXFQR7PsQbKE4RJ1ncHUaxBTHGPc39xIlIinYoeXyquKtKjNJwQsccaZIHKGX2ZCcR1JBOoEEDxfOcsY56F9nufc7zpZuXDfzARFF50LV/ww1FaNN+XcvO4tCs+RmCk3pgtx0q+kIZ4nAvRvp+U+gIJUYUxPIQLwi9KX/BdA2xCtvnbkg2XvpKC2e8Qnvl97ctQBtTwBJoRWGRNoYlRfm9CPcMigDrz67UQWRWVuV+NkpdJ9Jq3pQXeMMIuZgmUBpkISTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8iRIF59YzpqwdFEzkvyeCs7KobzHjgVCXwH6BHXR5E=;
 b=MXvxT7/dbOPVJ49rERt3BOu3m9dx53GzePD4huVl7bJJbIRVRE35TJghrvUzV43ltpefLVR05Uz3fNb82ofjcSfy1U5Xu5EipcSY/FnNvK06d3FnrBlDHmnIr5CNwvtt8EDvrwWpS7xqooQcsd36eEtv2+yjjjNoxFPAzZ67xPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN6PR12MB1585.namprd12.prod.outlook.com (2603:10b6:405:9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 03:06:46 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 03:06:46 +0000
Message-ID: <8e5ea82d-42db-a148-47af-a0910b44294f@amd.com>
Date:   Sun, 15 May 2022 22:06:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Christian Casteyde <casteyde.christian@free.fr>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org
References: <2584945.lGaqSPkdTl@geek500.localdomain>
 <eed25dd6-36ba-cd1c-1828-08a1535ce6c6@leemhuis.info>
 <25425832.1r3eYUQgxm@geek500.localdomain>
 <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0045.namprd05.prod.outlook.com
 (2603:10b6:803:41::22) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36f4b276-8231-49e9-c6c5-08da36e91ca3
X-MS-TrafficTypeDiagnostic: BN6PR12MB1585:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1585EDE52055F6B83EE06DF6E2CF9@BN6PR12MB1585.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkrmaEw+sA9mZ3stDTXt8JeMDqXfh7CGVMay+H6eA7Du7BFef1aLFDFGxkxXfZb7Yoxb2rKdeYpK89CH6TS3hpzzhfLFYZhQaPryydi36TSy4M2X2MLGOmomAhJvQSKw17HPlDcQsnOu0qCpOG2Z9puOVnbpramfjbXjpaSKGHqZVnI0KQ8jhS77zTGoLJTIWOrjhTpWLdm5woIHCUXhkHazg1xUHWvrFQQuOLwmMDlCxmjiseB7Ibrg5N2rA2l/jsPVLSWeCucqaVgabu/BVt1tvix3ZWY4+/OQX7QxC+P8ZINw2Hhlte9wAPutoEf3tHapbvj3h58dt/gwM/Ch2BQe1EAjZLDx1llOV/SNzNjjK1y4dzk+qZo0LSYU795nNX6lfTa5dhoZkfzmP5eQ/+u2czKJU83ZKwlg2B0z/wO5WCrrFUyqNp1jPg9hytlrCbqMzoGzKzaRTxA580KenlNxszdSpXbReyohEDfP8hl9yYnZVIMVuGO6k4LDk/Gmu4Rz/63Bl/WXdJr3LCQotEnI6AE3o2bP9ncYykiDPzohHP0xaTVG+x9LNXRxu6jCH6uPA1yqOLnynwMByujMacCfnfYWIvLVhK2CAHWQ1ydz6pgovynsSZ1gLJ0bbGSujvff9ONjNAXk3c80BvSbQlwMP+/1BrRD6sTTlZiyxsqCNiEKbIAr7/tKWZjrsvnXWm9nnFvL9nLA2yjxyENWz3c6P0BWm+K6FWREsJ9fKt9J4c8bdNZ8LEB1RIkjVhY4gAPyZosa9ncRgT+i6z4lFAmmzVCGOUqJd8ECzMGmj3f6wc8TVWsX9vfuQNWlm1fROyw1M53/wp0tHJ+MDZ6x3U1La/SdHooLNqbft7Movso+j5rb4v7TPNNZ5wgKdU6I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(36756003)(316002)(30864003)(31686004)(6512007)(110136005)(2616005)(186003)(5660300002)(6486002)(6506007)(66574015)(2906002)(38100700002)(86362001)(4326008)(44832011)(31696002)(53546011)(66946007)(66476007)(966005)(83380400001)(508600001)(66556008)(45080400002)(43740500002)(15866825006)(45980500001)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkdEY2VBQXYvOXdXNDk2RGhXTUFyUk01T3d0U08vWCtwR2toRVZLbzdYS2h1?=
 =?utf-8?B?L0lqWXZ1SW1lYStTS1ZiUHN5RVFka0tWQ0VOSm05RTFMT0g5OC9ZS2w3TEE4?=
 =?utf-8?B?c09laFNOUGl0Z2pIU3lvS0lVRmhheVZYRUZqTDV0eDkzMWtucmlRaTRaNEFQ?=
 =?utf-8?B?Y1pBMkEvakxONnNRajZKcTZDVzNSWWx4bm9hMEdMTFU0cDk4SFA1Vk9URVhI?=
 =?utf-8?B?MW1KVmhPZVJXSlNuUlJlWmt3QVdNLzZFTmk4S3BoS2hoZlQ2N1NyT0w4cnJ5?=
 =?utf-8?B?SzJZK1ppeDZOcm1SZVhBcjRqa01FYzR3MWYrd2w1bWVxWVZBZHcrRTkwcTND?=
 =?utf-8?B?RnFCanRQM1psZU02bkZZMkR0aXZueG1GQUUxdUgzRnZPN2MyanR4YVVNODlS?=
 =?utf-8?B?a2FYRTBOdEpDV0xYSkpOQ2MwOUV1UzdQM0VuN0dJUTU0Vk9WUTNNUWl2M1gx?=
 =?utf-8?B?d2ZLcXB5djFiQmU3bU5JOXpNZVlxTGJMbGhyZ2s5T0pQeCtFem1YSHpvQ2dF?=
 =?utf-8?B?VTJlK1lnaHhUVTkrb3ljaEpBL2ZwRnVtZG1la2g3ZlhOcWcvRE5MNUhHZmhX?=
 =?utf-8?B?RUNxdGpaK0c2T0ZwczdPYlZRN2hPT1J3Tld1L3JCd3BsWGVPejZJRnZxQUdV?=
 =?utf-8?B?b0lKeXdpVFNEenFvUnJFY0kydDI4dUN0V3RqS1hDdDJncndEOTVRT1RyUTF6?=
 =?utf-8?B?NmR4RVpuRkQwZ2xPOURramlVaXlUbFZwM1FJMFNBSEpidDUvUTZxTmxJbnEx?=
 =?utf-8?B?VXhDYmw0cXZQWlZFUWZVb2NVcGJKNTM0dG9XLzRJN0M2TUM1ZStoWGE3Q09C?=
 =?utf-8?B?NjAzUnByMGNRczI4Mm11RWkxMnZ5cXR5MG9iVmtVaWJPR21ZYWNSMTk5VmRL?=
 =?utf-8?B?cFpiR1ovc01Mdlc3Wk03N2pVOVl6MWdpMlhsaHB5TlA3dTUrTGRXa29sSXlF?=
 =?utf-8?B?NGg0Z3dpSHQrOXpnVUlKUW00d3JQUDVjMGRSSnRocmxJSVd5NXJ3NFhCWUJv?=
 =?utf-8?B?STkvTDYzVnNlbkhKakwyYklQeDhmcEpDU1RLSkdIUlRJS1RjZjJabE5UUjdp?=
 =?utf-8?B?MTZPOTJ3L0M1TzZmQWpnMmMxb3VWcFprMWppV3VFdkFrdEhJb2dYVG1qRmxt?=
 =?utf-8?B?dHhyVjN0VHV5Ky9YTE95QzV3Yitqdjcza05ibE92ZVhFcE52eERCMlVWbmtT?=
 =?utf-8?B?YTNZcVI2anNkaExnMWp1SjNvUFh2RzRkMndQMTdKM1hmNUhrT1JRT2NxalRH?=
 =?utf-8?B?Q2lFU3BnQTBMYklLT01FU1dZdWx0WVZ3Mm42bmlUdHVkd0xWeU9wZjVvT0J5?=
 =?utf-8?B?dklPdCtWVU8xMkRiZFYzbDZ6RWtzYkd0SlpLMnJWTFMyTkNLY21USjN5dFVs?=
 =?utf-8?B?WUJldGcvblZCci9TNnlDWTlBc3cwdHFjNnhUS1BKeGlxUWFUNGdJRkdiM09i?=
 =?utf-8?B?dmVSbmFzMk5YNGFmRUJaMnpjajkvcnhEcHlkckl4aStWeW5TbWpsTnJNem1K?=
 =?utf-8?B?QnJrcU9OVW9yN0ZFNEQzamRJNGhJVHRuc25kTGZoMjdxQTF5SlVMZ0NERTB2?=
 =?utf-8?B?cXphUVB6ZFI3NlZ3emNpbGR0dWNvY0RDbmNBU0FHb09YUXJOeERnYTl0MGRx?=
 =?utf-8?B?ZEhmZXZ6K2ZRVTZlL2ZqRVRaSzZUZ0h0RVNHRDlSQXR2V1V3ejlqSXlHY2Ny?=
 =?utf-8?B?ZWt0S1BIcmhIZEQ0LzByMnRHa2YyWTYveDQvZ24rRXpsd2RCK25lSm40T1VG?=
 =?utf-8?B?blN3V1piaGxCNmQrN2UvenJGWVIyWDl5WVEvWSttSjVaZElCbWpFeU52VzE0?=
 =?utf-8?B?RSs5bW4zUEUvNTVKSWR5TlkyUW90a3djTmFsRTE5dCtZM2owclpIdzZOcGw0?=
 =?utf-8?B?ZjAvUlp4aVZFekpLdVY1dWFQbnVibHliNmRVN1NOQ3hJK1YzaW5McHlBQTlr?=
 =?utf-8?B?SUxGc1Nia08xbUtDTkU5NzJ5M0l4a2FMczh4SjBSUGlPVDZzaFpwRXliWFVX?=
 =?utf-8?B?L2hzMVVUam1TSHd5ZzlTM3NaUWpCLzdvZTRlYjdVd1JhZUtpSnF3dm5KT210?=
 =?utf-8?B?eVovNlloQ2FuQ2FyelBNaEI2UXpONVpjT3pmOFdLdHUvWnFCdlpkSzJ6UWQ5?=
 =?utf-8?B?M1BkdDRFSmlXN2dwRDZ3cTZIS3krd3B3Tm5QQmRybUFoUXJwOHRJSGtzRXlT?=
 =?utf-8?B?WHpTOWllNkhjQ2FzVytqcGpMc1JPVGVVdGptejlmemZwOVA3d3QwdkdCN00v?=
 =?utf-8?B?T1R2bkwxYmxWaU9Ha2ZmZzFubmN2TXR6ZDIvZ2dGQXNCcVVNNjV3NHFjVVcy?=
 =?utf-8?B?R1g5dEF5Tmg0S3FzQU1GbXBvU1RFRTR1NmRDN0h0T1hvN3RQNi9kUVMwTmJs?=
 =?utf-8?Q?hoH9rKKkciD34Flf1GrAmZ5ZGLZib6u6A8u+kqqfH3gYZ?=
X-MS-Exchange-AntiSpam-MessageData-1: gymFnAjc542R/g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f4b276-8231-49e9-c6c5-08da36e91ca3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 03:06:46.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdFwD1Ijn/nHMZ6jzvfo/ZFnNH3KhzGd1ZQe0LmDD5IjU7ZuGs2v9YbzfExzy++QC9JyZHhFM4zjXTbstjF61g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1585
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/22 21:47, Kai-Heng Feng wrote:
> [+Cc Mario]
> 
> On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
> <casteyde.christian@free.fr> wrote:
>>
>> I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
>> This does not fix the problem on my laptop.
> 
> Maybe some commits are still missing?
> 
>>
>> For informatio, here is a part of the log around the suspend process:
> 
> Is it possible to attach full dmesg?

This is AMD APU and NVIDIA dGPU?  Or is this A+A?

I notice in the log snippet here this message:

 > May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu: Power 
consumption
 > will be higher as BIOS has not been configured for suspend-to-idle.
 > To use suspend-to-idle change the sleep mode in BIOS setup.

This means that you are manually picking s2idle but the system was 
designed for using S3.  Did you manually choose s2idle?

Would you mind bringing all the details of this regression over to a bug 
report at https://gitlab.freedesktop.org/drm/amd/-/issues/ instead?

I would like to see:
* acpidump
* full dmesg from the working scenario
and
* full dmesg of failing scenario (including failure if possible)

> 
> Kai-Heng
> 
>>
>> May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change power
>> state from D3cold to D0 (config space inaccessible)
>> May 14 19:21:41 geek500 kernel: PM: late suspend of devices failed
>> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
>> May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03: Transfer while
>> suspended
>> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive routing for PCI
>> INT A
>> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at drivers/i2c/
>> busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
>> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_call]
>> May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm: kworker/u32:18 Tainted:
>> G           O      5.17.7+ #7
>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Laptop
>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>> May 14 19:21:41 geek500 kernel: Workqueue: events_unbound async_run_entry_fn
>> May 14 19:21:41 geek500 kernel: RIP: 0010:i2c_dw_xfer+0x3f6/0x440
>> May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b 67 50 4d 85
>> e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
>>   ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc ff ff e9 2d 9c
>> 4b 00 83 f8 01 74
>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68 EFLAGS: 00010286
>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff888540f170e8
>> RCX: 0000000000000be5
>> May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI: 0000000000000086
>> RDI: ffffffffac858df8
>> May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08: ffffffffabe46d60
>> R09: 00000000ac86a0f6
>> May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11: ffffffffffffffff
>> R12: ffff888540f5c070
>> May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14: 00000000ffffff94
>> R15: ffff888540f17028
>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> GS:ffff88885f640000(0000) knlGS:0000000000000000
>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3: 0000000045e0c000
>> CR4: 0000000000350ee0
>> May 14 19:21:41 geek500 kernel: Call Trace:
>> May 14 19:21:41 geek500 kernel:  <TASK>
>> May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
>> May 14 19:21:41 geek500 kernel:  ? newidle_balance.constprop.0+0x1f7/0x3b0
>> May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
>> May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
>> May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
>> May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
>> May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
>> May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
>> May 14 19:21:41 geek500 kernel:  ? acpi_subsys_resume_early+0x50/0x50
>> May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
>> May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
>> May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
>> May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> May 14 19:21:41 geek500 kernel:  </TASK>
>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
>> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: failed to change
>> power setting.
>> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
>> acpi_subsys_resume+0x0/0x50 returns -108
>> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM: failed to
>> resume async: error -108
>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
>> [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
>> May 14 19:21:41 geek500 kernel: [drm:amdgpu_device_ip_resume_phase2] *ERROR*
>> resume of IP block <gfx_v9_0> failed -110
>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
>> amdgpu_device_ip_resume failed (-110).
>> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
>> pci_pm_resume+0x0/0x120 returns -110
>> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed to resume
>> async: error -110
>> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
>> clk.c:971 clk_core_disable+0x80/0x1a0
>> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_call]
>> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainted: G
>> W  O      5.17.7+ #7
>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Laptop
>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
>> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 48 8b
>> 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4 ab e8 79
>> 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 05 4a 61 9d 01
>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50 EFLAGS: 00010082
>> May 14 19:21:41 geek500 kernel:
>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b6300
>> RCX: 0000000000000027
>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 0000000000000001
>> RDI: ffff88885f59f460
>> May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08: ffffffffabf26da8
>> R09: 00000000ffffdfff
>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46dc0
>> R12: ffff8885401b6300
>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 0000000000000008
>> R15: 0000000000000000
>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 0000000102956000
>> CR4: 0000000000350ee0
>> May 14 19:21:41 geek500 kernel: Call Trace:
>> May 14 19:21:41 geek500 kernel:  <TASK>
>> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> May 14 19:21:41 geek500 kernel:  </TASK>
>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
>> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
>> clk.c:829 clk_core_unprepare+0xb1/0x1a0
>> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_call]
>> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainted: G
>> W  O      5.17.7+ #7
>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Laptop
>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
>> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db 74 a2
>> 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4 ab e8 18
>> 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 ea 62 9d 01 73
>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60 EFLAGS: 00010286
>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b6300
>> RCX: 0000000000000027
>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 0000000000000001
>> RDI: ffff88885f59f460
>> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08: ffffffffabf26da8
>> R09: 00000000ffffdfff
>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46dc0
>> R12: 0000000000000000
>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 0000000000000008
>> R15: 0000000000000000
>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 0000000102956000
>> CR4: 0000000000350ee0
>> May 14 19:21:41 geek500 kernel: Call Trace:
>> May 14 19:21:41 geek500 kernel:  <TASK>
>> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel: done.
>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> May 14 19:21:41 geek500 kernel:  </TASK>
>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
>> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
>> clk.c:971 clk_core_disable+0x80/0x1a0
>> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_call]
>> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainted: G
>> W  O      5.17.7+ #7
>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Laptop
>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
>> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 48 8b
>> 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4 ab e8 79
>> 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 05 4a 61 9d 01
>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50 EFLAGS: 00010082
>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b6300
>> RCX: 0000000000000027
>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 0000000000000001
>> RDI: ffff88885f59f460
>> May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08: ffffffffabf26da8
>> R09: 00000000ffffdfff
>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46dc0
>> R12: ffff8885401b6300
>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 0000000000000008
>> R15: 0000000000000000
>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 0000000102956000
>> CR4: 0000000000350ee0
>> May 14 19:21:41 geek500 kernel: Call Trace:
>> May 14 19:21:41 geek500 kernel:  <TASK>
>> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> May 14 19:21:41 geek500 kernel:  </TASK>
>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
>> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
>> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
>> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
>> clk.c:829 clk_core_unprepare+0xb1/0x1a0
>> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_call]
>> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainted: G
>> W  O      5.17.7+ #7
>> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Laptop
>> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
>> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
>> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
>> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db 74 a2
>> 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4 ab e8 18
>> 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 ea 62 9d 01 73
>> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60 EFLAGS: 00010286
>> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b6300
>> RCX: 0000000000000027
>> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 0000000000000001
>> RDI: ffff88885f59f460
>> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08: ffffffffabf26da8
>> R09: 00000000ffffdfff
>> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46dc0
>> R12: 0000000000000000
>> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 0000000000000008
>> R15: 0000000000000000
>> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
>> GS:ffff88885f580000(0000) knlGS:0000000000000000
>> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 0000000102956000
>> CR4: 0000000000350ee0
>> May 14 19:21:41 geek500 kernel: Call Trace:
>> May 14 19:21:41 geek500 kernel:  <TASK>
>> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
>> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
>> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
>> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
>> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
>> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
>> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
>> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
>> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
>> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
>> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
>> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
>> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
>> May 14 19:21:41 geek500 kernel:  </TASK>
>> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
>> May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable to sync
>> register 0x4f0800. -5
>> May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
>> May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu: Power consumption
>> will be higher as BIOS has not been configured for suspend-to-idle.
>> To use suspend-to-idle change the sleep mode in BIOS setup.
>> May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change power
>> state from D3cold to D0 (config space inaccessible)
>> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive routing for PCI
>> INT A
>> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
>> May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command 0xfc20 tx timeout
>> May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download fw command
>> failed (-110)
>> May 14 19:21:59 geek500 kernel: done.
>> May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable to sync
>> register 0x4f0800. -5
>> May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in /etc/dnsmasq.d/
>> dnsmasq-resolv.conf, will retry
>> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:02 geek500 last message buffered 2 times
>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:05 geek500 last message buffered 2 times
>> May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired on ring gfx
>> May 14 19:22:06 geek500 last message buffered 1 times
>> ...
>> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>> May 14 19:22:18 geek500 kernel: [drm:amdgpu_dm_atomic_commit_tail] *ERROR*
>> Waiting for fences timed out!
>> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on ring
>> sdma0
>>
>> CC
>>
>> Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a écrit :
>>> Hi, this is your Linux kernel regression tracker. Thanks for the report.
>>>
>>> On 14.05.22 16:41, Christian Casteyde wrote:
>>>> #regzbot introduced v5.17.3..v5.17.4
>>>> #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
>>>
>>> FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA function is
>>> suspended before ASIC reset") upstream.
>>>
>>> Recently a regression was reported where 887f75cfd0da was suspected as
>>> the culprit:
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F2008&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7C9eda02f7f9bb4000a84108da36e6734f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637882660654458166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=Pqkfsv5U0d4rWFY7VmpdBzVtBPg8rysBFYH7R5N2Wac%3D&amp;reserved=0
>>>
>>> And a one related to it:
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F1982&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7C9eda02f7f9bb4000a84108da36e6734f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637882660654458166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=Ct1fOCct8SxxhoSSEK%2F4%2BLJlTIOznI1yPp1c2G6bmQA%3D&amp;reserved=0
>>>
>>> You might want to take a look if what was discussed there might be
>>> related to your problem (I'm not directly involved in any of this, I
>>> don't know the details, it's just that 887f75cfd0da looked familiar to
>>> me). If it is, a fix for these two bugs was committed to master earlier
>>> this week:
>>>
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Fcommit%2F%3Fi&amp;data=05%7C01%7CMario.Limonciello%40amd.com%7C9eda02f7f9bb4000a84108da36e6734f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637882660654458166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=npnAo16fiV%2BHE5Uk8CyB%2B5iju8HCtglIf4EVMO5tKos%3D&amp;reserved=0
>>> d=a56f445f807b0276
>>>
>>> It will likely be backported to 5.17.y, maybe already in the over-next
>>> release. HTH.
>>>
>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>>
>>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>>> reports and sometimes miss something important when writing mails like
>>> this. If that's the case here, don't hesitate to tell me in a public
>>> reply, it's in everyone's interest to set the public record straight.
>>>
>>>> Hello
>>>> Since 5.17.4 my laptop doesn't resume from suspend anymore. At resume,
>>>> symptoms are variable:
>>>> - either the laptop freezes;
>>>> - either the screen keeps blank;
>>>> - either the screen is OK but mouse is frozen;
>>>> - either display lags with several logs in dmesg:
>>>> [  228.275492] [drm] Fence fallback timer expired on ring gfx
>>>> [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for
>>>> fences timed out!
>>>> [  228.779490] [drm] Fence fallback timer expired on ring gfx
>>>> [  229.283484] [drm] Fence fallback timer expired on ring sdma0
>>>> [  229.283485] [drm] Fence fallback timer expired on ring gfx
>>>> [  229.787487] [drm] Fence fallback timer expired on ring gfx
>>>> ...
>>>>
>>>> I've bisected the problem.
>>>>
>>>> Please note this laptop has a strange behaviour on suspend:
>>>> The first suspend request always fails (this point has never been fixed
>>>> and
>>>> plagues us when trying to diagnose another regression on touchpad not
>>>> resuming in the past). The screen goes blank and I can get it OK when
>>>> pressing the power button, this seems to reset it. After that all
>>>> suspend/resume works OK.
>>>>
>>>> Since 5.17.4, it is not possible anymore to get the laptop working again
>>>> after the first suspend failure.
>>>>
>>>> HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated + NVidia
>>>> 1650Ti
>>>> (turned off with ACPI call in order to get more battery, I'm not using
>>>> NVidia driver).
>>
>>
>>
>>

