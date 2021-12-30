Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10532481AAA
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 09:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhL3IKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 03:10:43 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:32115 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234716AbhL3IKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 03:10:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1640851837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ibyWdAHusoYtlUHs/l/VTsNrKZ+LlVL+P6K1CrEZ7M=;
        b=KmPWeqejS0EG5Iv2zlaZqauRA9vmuMmR5KIsH/fTvZjaAdeE/KbXqe6q/9x/k0leGDMZrG
        bILUYnBknxRDikJNzRwxRFO1uDe3EuMlCzT4evssicLbOnPwS2/3ShrU8bykwU0NlpdAHA
        xqX9/6RtFMmUBUTUh90pVcBENXRo/qs=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29-scy6lAxXPK298zGVz8tExw-1; Thu, 30 Dec 2021 09:10:36 +0100
X-MC-Unique: scy6lAxXPK298zGVz8tExw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuzUGsLcIfj6FF/VXZR6W+3WWvX+XYrVAVBWMWVNFaDPg1hYeslahtFYV3y1k746WH8AxVaXIr6Sy+CqWOQEmageI88DYE5L2KJ8ZxqEcxo1RRTc1N1zHaWpp8yKWXT2lG6zkeSGHoxakIYehUE0lF1pcS4sM7vvBi9BBeV73XRvJpYdde4S84AAdTA8J7O2/PMjvSB86WKyycIVlEU3ww06IPyyfkGdHyqYP2/uDM+q6iKz5fAQ5A8HYrRe9bx84X8weeqQYg8alrN3skksPwLF05a8viozV/1GrDfqcgKBm+m7VKtalmgb3M1PZ26oE51+qrd1NPWIhfeiazgf4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ibyWdAHusoYtlUHs/l/VTsNrKZ+LlVL+P6K1CrEZ7M=;
 b=c+/XnqdI/VTefHhlMv3tuf0buPBAFAlUVSi25VamxgxLm7jG1JuVpOGOPWEnOBA7Bwwa7yTRmbg1dD5UxaIokbbkwVteniMZDlLSDcHNT1Uh+lYMZOqLEDFME7Uir+OL14JBJhS/zs9e4yT9mngswKYzCfzbecwQVNvuI29VRAJphhH1zBlXNl4vFWDSxjblf60r/iX9TUsAEE/yKucy0cTrPKaUoocBK1zz3rW3uwlIBT61dXJLJ7TM378JhJsgule3laAKRTnGGAKHRZb6A0gZM1sFcBC9+KAsxYXDZgFIZ9gzUdAoBasaDC954A/XsecFHzPS/Q4DOJeCheU0/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com (2603:10a6:10:36a::14)
 by DU2PR04MB8776.eurprd04.prod.outlook.com (2603:10a6:10:2e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 08:10:34 +0000
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::7547:9d8a:d148:986e]) by DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::7547:9d8a:d148:986e%7]) with mapi id 15.20.4823.023; Thu, 30 Dec 2021
 08:10:34 +0000
Message-ID: <8241fcef-bc80-7f6b-8ef1-5b1638d02c2e@suse.com>
Date:   Thu, 30 Dec 2021 16:10:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Should write-time tree-checker backported to v5.10?
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
 <Yc1X/HqU8zK85xFd@kroah.com> <6766e94a-37ba-6635-1e4d-1e256739e195@gmx.com>
 <Yc1geWndI9h6rXJI@kroah.com>
From:   Qu Wenruo <wqu@suse.com>
In-Reply-To: <Yc1geWndI9h6rXJI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To DB9PR04MB9426.eurprd04.prod.outlook.com
 (2603:10a6:10:36a::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46abcc8e-7aaa-49b2-0c3d-08d9cb6bdac9
X-MS-TrafficTypeDiagnostic: DU2PR04MB8776:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8776653A87A3090FA37BB26AD6459@DU2PR04MB8776.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qn3/mTk2AJh/zUsyxZPhBxeEeBKJSA51aUE6kLtbtm0GeEG1uY4O55+HG0y/A9YwSHJPrHYcDv/fDnO2QMiahUHG3HnmVMnJA4m6IAt3Bdebj6nUJcmCjPplGZ6a7xRRpS9qOTB8FEW4TsJD/7O5xYxiJDgmDyEnafHOwSJKharjEi77F9imo6IwHqVLRCd5JmroVh8m1auVOr/gdF7QYj81yn0FiJMVRYnF7oWz4/c79WkuoydjfT/rNuil1BJCQ3jwtON+LL6p7Pxgv002/vN1qyjzGLoKhfoZ3fe+BIx4qFK17ojHl49z8dh9nHnpbOqsAkAM/bSJQh2dOetjxelVbG+FDxz0jsYT2r0A7fHwMR4odHysb3VUAyu2Uv8mi9hlUBCWGTyXl31InHOQWM9h7qZR+g2KuuHlDUCPtBIWda+2rh7wI0zJCPMNUi3MXpXgfQ8WVe7qM+2/kPaIJJyPpq+2kznGKagvhvSCXIOwYSjvqnyGlh0RA1LApQIor67+v6+9z82A+/MASJoCC0luTVmGe3hab6pEAJ0Eb27PL4llrMVgIuGEtet6UedKvzZmoxEF2MKtmGSU10G3Cwk+G23bBs5tcgOAmdVSf52oHC3XmbjNqkpweCNW4SdVI1UHSHaMVLcUphosfFRUqbwq28RKXkJ/hLOpOjDUln6LwxSGTlMJUaF+Aioh+pBA8pjmpbhvmU5ZEeMjeGX6q6GLch7Z/lRlZGSSjMpo2X0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(316002)(110136005)(54906003)(2616005)(53546011)(6506007)(6486002)(2906002)(8676002)(6512007)(38100700002)(6666004)(26005)(186003)(508600001)(31686004)(66556008)(4326008)(86362001)(66476007)(36756003)(83380400001)(5660300002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVJFUlhXYzJOVXdxWU5uVzk5ZlhMZUsxQlNXbVZDYy9TQklqTWNWVUN0VGZx?=
 =?utf-8?B?UlMrdGRCY2xGb1h3Z1YrTVVodXEzT3h4V3o5QmNQeEZGSnVvVHRlMFJBa1l6?=
 =?utf-8?B?MUtDVlozUWMxYVV1Tlg5eVJoRllmK2t3UTZodkROUFFITmhzNkQ2K0FVREd4?=
 =?utf-8?B?YUljK1k1UjNBOGNSd3dyekMyOHlCQXRyeEp0aFVwb0pXNFpMMzUrY1E0UmRu?=
 =?utf-8?B?b2ZxWXpxaUt5VTNVaVRXS3d5c1ozdVFVanJUbCtVWTgzcmNQK0FHY0JlaE1i?=
 =?utf-8?B?Vnp2MUNxdCtKS1l0L09iZ0RUNVRYNkM0RHJ0QW5UbTYrYVVpUFlKUy90dXh1?=
 =?utf-8?B?d1FXeHR1emVMZ1dCS0MvUFhrQ3g5VHhvdUpGVU4vUzBHNlBKbndpMFUxMFJC?=
 =?utf-8?B?dXZRMGlRZCt1SUMwTXF5ZFFMVitpY1BnTjBYckFsbW5uVldvV3NYQmtaUW1y?=
 =?utf-8?B?eFZBWm90NmJ0NCtudkdxelU2c2c0bkZCVm9pMTlNa0M3RWpDcldIV084SjB1?=
 =?utf-8?B?Zk5XbVFxY0ZQU0RVNUpNMnQyTFdvQkQrN3hwbzJiK3F0K091TlRLQnpIcVoy?=
 =?utf-8?B?TzQ3dm81YW5Edk04aXhsZThtN1lGVDRvaitvdkZrOE02Y2hnWUFlaGp1QzRT?=
 =?utf-8?B?dXluZmZvaXdpM2lWWXRkNVF1cWhWQy9WWXFWanZSVFpOSEhJS1Fwa0ZrOXdq?=
 =?utf-8?B?Wkh3YjVlTGNTdWZCUHNzT1JYamd3NUJjZGhXUEwyLzBGRGhZMWNHMVN0UXoz?=
 =?utf-8?B?cVZWRFgrcE9hSDROT1NSdEN5WHdoRlpYUE1HdldwblNweHQ3bjdYUGUreFk1?=
 =?utf-8?B?YTNseHBnc21iV3FybVViWmsraTFNTG05dGNpSUFTZmlrY3IwdjJCZ3hNV0M5?=
 =?utf-8?B?cFA5MlVLUVBweGhLa0dnNmRkejJNRG9XTVI4Y3lQQnVtdGlydkZZRWRuRmhu?=
 =?utf-8?B?QWRlejJ2REtGWnkxeWR6eUdoeW5HYytwckQ2ZUh3Tng1TnJBNVFuRS9KOGhu?=
 =?utf-8?B?MTZEREF6QmZkd2JwM1cwM2Q3OTlHU3g2aHIxb1ExK3lMRS9GNmdodFRPSCtD?=
 =?utf-8?B?VG8yczNlYU4zb2Q1NUtSNmY1RW5iczQ4YWp1UlRoYlY5UTZsVDlwSUJPUkdE?=
 =?utf-8?B?eEtBSms1eU1TajlWT3ZBV2tFZ2lWWGhFNEVCWVZHT3ZBOWtBRVVoSmdCVXp5?=
 =?utf-8?B?ZmpHR2RsQ3JHYS90U3VYeGE0WURBVDBUSGhkQlZleXd0UklDcnVmKzVrMFFU?=
 =?utf-8?B?UlpjM255UEMvbFltRy9zT2YxODdoZ2wyK2ErZUowb1NJL3hkMmJydnlvdC96?=
 =?utf-8?B?MVZZeXB4My83c2k1K2hsL3hxTFVDYmQrdCtWREZHb1pIdDVlRERWMDArOGM1?=
 =?utf-8?B?bkJWdXZBVzhtNWxJdlVpdmszZVhsVGtOZmp2NFljZUg3WGtXSlFVN0gvdWRB?=
 =?utf-8?B?U3JmOTNsRDd5M2xYcm9uT01RL21wdGVrb2U2ekpGQVVsS1NKeUVhZ0txTEdl?=
 =?utf-8?B?czQ3dm9BRGNiTFVsSlJua3lURmM0V2JKZE1sSlEvQzlvZVBoVlR2SEZ1NVJG?=
 =?utf-8?B?RHpxczdBUzJwU0pxa0o4ZG9vNGo3V0kwb3lERzVWaGxQNjV3cFV3eXNUMHNu?=
 =?utf-8?B?Yk8ybEptUkRoVGttcFpvMzVHR0NzNFduL0cwS3R6VkZnL2l6K1k5MzFmSVgy?=
 =?utf-8?B?ZWVQZCs0QlA1eU81Q1VZd2lvQmIyR1FQVmovbWVGdjFFMGhoSFRiR3FCZmVN?=
 =?utf-8?B?MmNPeUJTdWpmelhLeEdkL09ySkFvblhSbTZsTnl2SVVTcmh6dHVIOFBsc3pR?=
 =?utf-8?B?dVE3T2NrQU1MOEVZclJ3M252QWxhS1BtU0pYQit6TW5OSzJRNmhmYnMreDRO?=
 =?utf-8?B?NTI4Ry9wT1RrTFY2ZGs2cWhaSXVCSFNyL21TRU83dkJtSForWno4RDZRdmtT?=
 =?utf-8?B?TnV6Ky84V2RLQVY0eXNySU84RTFiS3dGcVFJTTUrTUl5SHF5VkJ3OU45MllG?=
 =?utf-8?B?S2MxT29ObVRqWVBlZCtUWkdsSmRYa0RNQmczOE5naFhaeXd2ekUrVmZBMVVj?=
 =?utf-8?B?SzBxZUFCL1lsdGNuaDZrcUpaTmpIT3ZEL2swMFZVT3JISndzV0RRSHo1Z2c5?=
 =?utf-8?Q?qSrM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46abcc8e-7aaa-49b2-0c3d-08d9cb6bdac9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 08:10:34.3120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e3sp49uz0DJ/E0p/Xq0/3b59qaTii1Ydc9tczd7NyRhrtBY86AfH9vsizCJdZju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8776
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/12/30 15:32, Greg KH wrote:
> On Thu, Dec 30, 2021 at 03:10:13PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2021/12/30 14:55, Greg KH wrote:
>>> On Thu, Dec 30, 2021 at 08:06:49AM +0800, Qu Wenruo wrote:
>>>> Hi,
>>>>
>>>> Since v5.10 is an LTS release, I'm wondering should we backport write
>>>> time tree-checker feature to v5.10?
>>>>
>>>> There are already some reports of runtime memory bitflip get written to
>>>> disk and causing problems.
>>>>
>>>> Unfortunately write-time tree-checker is only introduced in v5.11, one
>>>> version late.
>>>>
>>>> Considering how many bitflips write-time tree-checker has caught (and
>>>> prevented corrupted data reaching disk), I think it's definitely worthy
>>>> to backport it to an LTS kernel.
>>>>
>>>> Or is there any special requirement for LTS kernel to reject certain
>>>> features?
>>>
>>> Stable/LTS kernels do not get new features, sorry.
>>
>> OK, sorry to hear that.
>>
>>>   If someone wants this feature, why not just use 5.15?
>>
>> One thing is, this is not really a feature, but more like an extra
>> safenet to catch hardware problems.
>>
>> In fact, just according to the reports in btrfs mail list, memory
>> bitflip is not that rare in the real world.
>>
>> And any undetected bitflip reached disk will be later rejected by the
>> read time sanity check, causing a possibly unmountable fs.
>> (even we output exactly the reason why we reject the metadata, and with
>> those error messages, one can easily know it's a bitflip, it's still way
>> worse than rejecting the corrupted data at write time).
>>
>> So I guess the only way to get full runtime sanity check is waiting for
>> the next LTS.
> 
> What exactly does the patches look like to backport this?

All my bad, the upstream commit is 8d47a0d8f794 ("btrfs: Do mandatory 
tree block check before submitting bio") which is already in v5.2, not 
v5.11.

So all these features are already in lts.

Really sorry for the noise.
Qu

> 
> And what prevents people from using the 5.15 LTS kernel instead of 5.10
> if they wish to have this additional protection?
> 
> thanks,
> 
> greg k-h
> 

