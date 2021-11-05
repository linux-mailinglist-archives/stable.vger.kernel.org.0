Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6FD4462BC
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhKELdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:33:33 -0400
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:48929
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229529AbhKELdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 07:33:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6ERQu1Nufg0yyCQgp8aQGtVvcEU3GX0DPCXrzjwxHwge5JfBho9SrEc+ja/9zzTsTZYQ0HL4f1OWG5DSqmkS3/YkXqzvSApXvrtd1D0TLi07rzUkhl9GJtmYQAKVcgVScsXBH71sXV53KLLYjpI9UggvqHwO+nfd3e32YmRJtTipKb9LJx7NR1nBiAL/Vg/IySDNZOWyGsfKi4aWgtWafiYONCwV+BgPwFsZx2vlsFeY8KsyEgKHd5TaIrEftxxbkN9pZt2AhT8qSlEc8k7ptjq7iTqRb+wBkKE3qEUpDljINj7hAt+Af4Z7ctXxVzDPkiDQULiiy6rv2te4OhfsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//tnzXhOQUuBwYs/mYYG5rUOERXCcRYP5QUtMPUqXrE=;
 b=XDNuyp6dvOXETqhdDwYf+aeCbbALyZ1kDpMJRwYPHOTzjsECk8hEa4iw9cw6tn2yz8O7ufhOiOLVcGeOoR/LMZYO4tGocrnyvaOgn7/1xYI6bmRrOhTy2rwCHUIb7wJBQj6GKu484Sn8rf8hAi0aFCF0a8uJJY9u/kIN1SZG+3+WsDkh04Ve8asedY/xHUBfJI3zCmpS6tQEaj4aqxrx2wmDY2GRZlMzyQI8hgmrI4mnwGXGyulh8CPp6ng9Zjr8HfZbHDpYeMsh3IsjfgxsTEfWV4Uqa1rDtJ1Bs3VOLZCd/sY2MRalkGXp0GeeS0zh3oEM+ndzQ3BxZGfxc2I9lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//tnzXhOQUuBwYs/mYYG5rUOERXCcRYP5QUtMPUqXrE=;
 b=a5HfOEpEri5bVPih8T6ertMbSPim+91CGWO9phkkHCoJ9XJPUExJlwD2P7kNZTvL5/mEy4XMJQIs0M3ua3y8mNlbZQEfP4TQWbG5Kx6L3Bk+Wr1kwrsV1daSc/dLKXJuwzsBixjjH64JPeT75zkJzCbzJF9wjkssGfsdrfIE1S4k0VzybLi8u1Jz6woehIg0oF9trAdEov8W74YpWALyHz2uoxAil7g6KIAmmATTygwF0/bGb3uGu7qC8ehEEYNOZJlWdi95WTNfc7qEsMXr4wT2+0Lg6zyH/rGaAvr8CJEXfCJNEIL94VVoMhs6Sl9hq80LSnWNR6a0iwxYr1ZGYQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Fri, 5 Nov
 2021 11:30:52 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a8df:7d22:998:158c]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a8df:7d22:998:158c%7]) with mapi id 15.20.4649.019; Fri, 5 Nov 2021
 11:30:52 +0000
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org
References: <20211104141159.551636584@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <78c3c647-c98c-dab6-28bd-67d057c08ae7@nvidia.com>
Date:   Fri, 5 Nov 2021 11:30:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0210.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::17) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:ac67:9a6b:f526:a81c] (2a00:23c7:b086:2f00:ac67:9a6b:f526:a81c) by LO4P123CA0210.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 11:30:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b30eec2-afe5-48f3-6471-08d9a04fb921
X-MS-TrafficTypeDiagnostic: CO6PR12MB5489:
X-Microsoft-Antispam-PRVS: <CO6PR12MB54894FFD48708CD4EB1108CCD98E9@CO6PR12MB5489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GObefGMQq7mGiAn7SNHIai5QTgiERWtCGAMQ5xuI7J+d5hE9JqSIefp9jhx/kRTTWNG4vGg4u5UqNzb56msjLkG0hPNXJvEHG8qixUAn1rV9drC7IZ8SWdHr9aJQ3idrF2N0OZ19/pXG0K6roo8VP7PK1TjAgBSVWfAIWmvXEXRmgBT7ZY+gu9fkjYLN5ahdZ4eHJGhrke+WYFvT1Ext93o3xdVr078fGBGnUM2voqcvTR/MfkExKH0F5SOzuJIELgVQfF+c5VJ0Q4aLOtUMlB9kMTl8JdT6Cn4sfwJ2p9IFDAf5T2lf5zdcFMzAYnpBp/9wqdFHWcH/3KIrw3UjEc4kAyaQtp7xhVr/6wjiGJrFxjJ8CivNKrJ919h7A2uhdSh35Y46SkWuGrVRxFvh9fchl62GG0trhLntWc5Og12zpx0Ii2NGCmJMCvhbTnBtp5fQe4+ffo5QCas5medxAYCe/5ByVFBRcNYAaawsj+glJSJIpznCjI29gNAtA1n/dZM0thz/679O29HcBddAP4dY/G/QpqhyN7DXotp6kjtWXAqfUCy1LQE3oeL6ZskrtBuSbkI7f1M3UXCbn0jp8pfWe3bELlg3drZNxcrvILQ4iBCawL7UT5NCwqV4iY/TpSo3qUeaDa34tG+sTqq/zA7zvmLFPUWHmiAkj79VyGHG64jvisHubVJRb3ExH0CJbrAp5UDpNwfIuuhIN2Duj5DMfencHyDBiLnRUO+x2HjSZYqt62k2XBh0nv2PBviBLLRamzgpxhZNFSgAXw16suf5cVsjMeD7fvpZ6RycPDuVgakQC6cvtn51exelML8K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6666004)(5660300002)(6486002)(316002)(86362001)(8936002)(31686004)(38100700002)(36756003)(83380400001)(186003)(66556008)(66476007)(53546011)(2616005)(966005)(508600001)(8676002)(2906002)(66946007)(31696002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXp3UDlrUzlNbVplZGdoL0FHTlZUbFR2Unkrcm5ONG90QU9VNEFxNGxtTUQ4?=
 =?utf-8?B?Zkc1S2JCTnBNVzdud29vQjFjeUQ2cmtSVU10b3BUYmRuSU5pQlVDeWN5TFVK?=
 =?utf-8?B?ZHFnd3J4dXV5VERqczBEbWRhWWhabitMNGF4Ukp6WWxWY2NtVzZLWmhmdVRH?=
 =?utf-8?B?Z1dVTmRhSHRUcG44T3BmRkk2RVR5VGppb2dqbnFrMUcwVkZrbnBFTDkvcUsv?=
 =?utf-8?B?ZGdGZi81b05tZUpLbENWb3owVDU1bmdOTDJXRHZCbHl0ZldpQmkxYXRiTk5J?=
 =?utf-8?B?amo4SUcxVzVCalZEWkF4RGlHaHE5L0dZSjJKalgvaURHTlRQRGxxbEdwdjI0?=
 =?utf-8?B?eW5IZEk3aHVuTVNaOTlxeHJvVmtmVHVDYWk0SExVbVlmMy9vOG1mV0lqZHR4?=
 =?utf-8?B?NERxczVjeDNMcFBPSjluU1d2QTJGcHJKay9NWFZ1UXVSSTRNdmloanR4YWli?=
 =?utf-8?B?aTBQalFGZC9hZEJYWk1NMFZuQWx2T3hEbW16TXRISTBreVRaNVQ3ejIzemxN?=
 =?utf-8?B?RFRKYjQzZEFQeXRsbWRxR2RqNDdlOTBOTXluU3lpUDJZTGErL1kwenEzUDZr?=
 =?utf-8?B?aTBxbVJ1cUdMTUp1dW9mTklqS0V0Q1FTMk5ZV3dJYWJDTDlhYmQ4UDcvNmRR?=
 =?utf-8?B?Q1RMaVlFV3pWUGpsYmVqaVJMWXBKNEhOK1kzemVxdDFsVWppU2htQVBNN3U0?=
 =?utf-8?B?RmtCMDUwc2MwZlQ3WlVlTUs3djFaRlk1eWFMZ3VqR0RxcUZrbGlub0dkZVVp?=
 =?utf-8?B?bVpSUENFMnlGRTB6RWJQOCt0OUplbmlaN3k2bHZwMDNnV1lJUXhUYi9BeDV6?=
 =?utf-8?B?UEFHNlRDblhyaHdkQUltOXFRdEQ5MFZwRExkY3lNcC9SN21GNTl5Ly9TTFBZ?=
 =?utf-8?B?NjYvT1ROb3NGZkxWOXZSSGpoY2UzbjZUSExTaWN0cDNvNExPUW1aYzBWWmlV?=
 =?utf-8?B?S2NtaHIxVzJvU0d4QWtnb2VNYjA0R1lINFgxWFVwek91Z1pUZ2JpYjdkdS9T?=
 =?utf-8?B?bGZBdzFUWTVEWjR3NHpTb3dKbDJ3Rk1uMzBralp4SzhwVm1hS1pyZlVabXNn?=
 =?utf-8?B?Vk9YRmpyY1hjbGw4WWVnU3ZiQ1JFMWFvTXcvakNZR2ZXTG5mZFNvd0YyYWEy?=
 =?utf-8?B?ZU4vNzlyamxYRFpwN0ZMQ3ZoMkJqM0haSXV0Zk90RzlWRGhPdThUR2ZzZVNx?=
 =?utf-8?B?ejJZOWtKbEtDdDhrWHZVOGlFeVA2SnBFUXJmUDNoYXlqdHdFTmxnMU1Peit0?=
 =?utf-8?B?dGNpczAwUTAyMmxLTzJ4Vmp3UGJZT043cjRDNjUxdUVOcnc5aUFybnhjdVRN?=
 =?utf-8?B?cDZEVEJOMzI4T25Iem9xQmErK1Nrc2xxSjlJc1k1NUFjRWVEbW51QUROdG1O?=
 =?utf-8?B?UG5sZEUrZUtkTzFPUFluMkRKR3lpRlpYaWhXMWtXYXRuckFES2lyYlRTNFV2?=
 =?utf-8?B?MDVPeTR6TU1aNFc1NjAzY25HaFVVNmZJSkFQMHErajZ1K2RQcS9zc0RoaTIy?=
 =?utf-8?B?UEFETU5kazc4WEZPbTN3YmR5cjVqK1lOVHhhUy9POVJuSnBvd2ZaaHR5SmJT?=
 =?utf-8?B?S1lHTmNCVXRyQUJnK1pNNG5RcHVvdVdJKzZzQmpBVGRGamZQcVhQV05UUENF?=
 =?utf-8?B?aFB5bFo3NE5SVmlnSkdobUdjNUFUdm1IMngxa0IrS1FtcDhVVDBjSlJVOXJB?=
 =?utf-8?B?NVpFVHdxdGhHamJ6OFVWUDQxTG8xS01UN3BCWVpVQ1VoZkwydTh0SGhFWit3?=
 =?utf-8?B?N0w5dFUwNHlPV3cycnc1M1BpQ2dPSG1mNmVLNkR0a0RtOVh3ZncrN0dNQTE4?=
 =?utf-8?B?c1lvWC9Ed1pyUnFhVm1KTTNHWWdsN3hVWXk1OHVLTDJ5VUpEeTdZNWEzRGlL?=
 =?utf-8?B?L2JGY3R5U0hZU01PV3VBNG1KU0Vpd2VGQmxDNGFSRHRnaGVGRUFybVowRWZE?=
 =?utf-8?B?cGgwSzkwOXl5MUt4NzJaWmZIdVVXSzlsZkpxN0dpL1Vod3FFOWNsb1cxb1Nx?=
 =?utf-8?B?V1p6bmtKTjJxcVV2VkliZHYrRCsxb1ArYjlMbWR1TjFIK1ZYUC84V2tremJZ?=
 =?utf-8?B?UjR2TTdZdytKS201emNjVWh0UzB2OFI5RHJqK01xZ2JnZkhBZGlPN2xsRkU3?=
 =?utf-8?B?YTNmbXVDNGNpNFdIVWtucmd4VjZrRkY5ZUlWejdqa0ZrNnp4dlU5VlZSM09O?=
 =?utf-8?B?T3lYSnBUOEpsWHdnbjNjZkVDTnc4am5tQ2I4Mmg3RjY0SklTaHVraTcvemJL?=
 =?utf-8?Q?KtWkUPFYqWFdoC71EIYLrOaSOrtQNRx7f1P+PKfA4w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b30eec2-afe5-48f3-6471-08d9a04fb921
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 11:30:52.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03oNLV9FDEzhiLr2ieL5TRhF3CFD4Gz7/P03a2gZxGbvBact9ne0P19YiSYDvBAIS0VXvGZ+fhKDf3Lwa9CaEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5489
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 04/11/2021 14:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP response") was
pulled in late for v5.15 and this unfortunately broke HDA audio support for
Tegra194. We are working on a fix for this and so the below failure is
expected. For now we can ignore the below failures and I will figure out how
we fix this.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	108 pass, 6 fail

Linux version:	5.15.1-rc1-gfeb80b14f66d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra194-p2972-0000: tegra-audio-boot-sanity.sh
                 tegra194-p2972-0000: tegra-audio-hda-playback.sh
                 tegra194-p3509-0000+p3668-0000: devices
                 tegra194-p3509-0000+p3668-0000: tegra-audio-boot-sanity.sh
                 tegra194-p3509-0000+p3668-0000: tegra-audio-hda-playback.sh

Cheers
Jon

-- 
nvpublic
