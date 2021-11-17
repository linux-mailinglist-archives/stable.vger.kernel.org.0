Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242AD454C0A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbhKQRhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:37:17 -0500
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:6624
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232047AbhKQRhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:37:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXVKw8kfIkxTFvOhYc1aC76GXdNcrqBS32tLfmKrhcRxTINLuILj5rRu9Meixs9focM4pA2OnUvGZw+EWxlAaZa1JvQYbtJEwc/DG2l2mugG56MEw3KD3SjKBGHEdzuX0Hsp29KGGSlpCirfE6jIiIUus3ca0ojbq84QDsMBVrxPE0vj52ktnxIXbkChrGbplmbUWWws0faam3juSGhLKwA9nv+rK2SeibkbikZTGy18FWrQsIGIlrnD+i9Ychhnkos8m8V5QWdoyfCb841YhQSjRjAyt1EV2Ty2XVLSIkiK1BcL69oe/sZXcOtvFRwhcgKLq0EKBzIhrtUzplPj9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkVQL9rDaDw4ePcaRkmzj+h0GXE1TMYRyvKRWe5fkK4=;
 b=KmdV2bNOQxVZUQ70FhTteMP+R1xxh6prEXJkHCdtI6xFbwhde4eBo4b+9dJRsy7uwP7tztg+y5eY2ClOK+YjdLOtYJMGciB6xwNZf/Sef9MiMfDChF9eMCIAGVi5iCxKbwMVUWtj9PFiHFf4hZ+I/APJm9XKiT5dhliFnIvs6T1i9iEnNLyKgtrdjMNXEAD+dgbgjVpWexRMHcz40XMylpq10xbzTNweif5HBAtu8FmE1Va8DeMhVFSXxIHba0fIQdK/jvzwNcDZ3kmal5CWE9601wzwyiQH/j7OZwRqGTkv1JdlmdMDx7pCJuFwSsLnhaB7B+TxXvHzNuV0SlRLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkVQL9rDaDw4ePcaRkmzj+h0GXE1TMYRyvKRWe5fkK4=;
 b=QAzGmHiNy+xPbMeubom6G/8EIhZtLQUVa3jyWM37K25+Ym076NYqAUSKvkxxz1qALxExUxTe7ujdUipu1NabnuO+GJHrNQ62KWgQaoUj7aRo+l9Cp56Cf+MHF1DPOFYmCxp4Qm0wiF26jJFv0g1AcppwuqowKUoa7Lf6uH5DthDKCYZphVDFLyQQKOscasOVFAsC2CMETmFr4mcCc1bRZrUNeFNWuTOaweTpWnyx5exi4GySl9ag500eyxQQVcwyIhZjhzuTYNBSmth64mz1ODHIxqgPy3O4ZXWSLVfpS3u8tMiVXOGBrE7ewH12tTWBjpIAgUbtL+acbR9KNeiMDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.26; Wed, 17 Nov 2021 17:34:16 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Wed, 17 Nov 2021
 17:34:16 +0000
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211117101657.463560063@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8086f922-b4ab-cdab-74c9-8307fa93355b@nvidia.com>
Date:   Wed, 17 Nov 2021 17:34:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::26) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [IPv6:2a00:23c7:b086:2f00:fd12:4d15:935b:56c5] (2a00:23c7:b086:2f00:fd12:4d15:935b:56c5) by LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 17:34:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34304c88-812e-4e2a-a90b-08d9a9f07a66
X-MS-TrafficTypeDiagnostic: DM4PR12MB5200:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5200E6FDA51FAAD4007F9468D99A9@DM4PR12MB5200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nrSsGiuxD2rp+Ua7DFocsIhYpNjMaBvGSENaK2Jr44LYuDbjc83tg9i87L5Ge3bKO/AChr7ApbpRWTMC7qNBYuEONasKiF0Aw6SKsTD4815XQM4UTfFgp2g+vqsKOoXdCKTp1+Sdrr7cSdAX4U4CZlqdC24zIJGPajX/tzmjUQVyj22KEoEZ/NJ9d90UkOcgdtEvM2PJOBR8edlD2k/W1sG3YJmeWWnZfAI+qpkmzGJ5YpPzyOTMyeqUPu0GadflEC9KMyH+LS9dsascPvEJbytDhm+PFIbpvGTYihwhWq4mEPl+pgmSi98GMPaeBQIEDVHA3W9yS8e6wIH6A6b1IkdvhOqcyFHfjNHs65BYXOEFtvSY6ixtfleTlss1SSPOMuWSmTWUxFI2AM8O5856/SYAn9Y+b23HJY8tTrchpjX0S5ItjIPtpjQrMY9iuIn/Ow0Tdw8NqoYBDJrwxF6MIJouRFs0A7VC7jJGVC04j2Vri+/PgmsUlnRStJfNb/Ri1JCdP22MV8BvPxtF9x40ZfXeq2OQH5LWAsLe2Fd02S/pYRokWfi9RF3I918d1xe0zFDZHvIXfvZsIEjwFjRRpfTH6aaiqO5do1K+C/65byuK6qzIelSbIAAqsxPuVqqKRAtWy5cjsq0n+bVd2WvhXKobRq+nYdDhJjpXqUDNCeetoxSwnhRgfHWRpxwNKd5IvgyUDBlcYmIuKcvjO7WLcYI97lcfnzD6gW4dFBIVRIPbsHPI0heMeagVmieqdS5MCzO6ti5R6gOEsmPunWEPaQ++/A/2Okzd+1Lo1nxsSfV984EzUCFHX/43N/2T6GeLwvNgeEuoUewikbzONV1N06Cl12SO+D0iLaDJdmT49x1YiV2cnsLFMyzVlxFV8cSB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(53546011)(508600001)(4326008)(8936002)(2616005)(66476007)(6666004)(966005)(5660300002)(7416002)(86362001)(66556008)(31686004)(66946007)(38100700002)(6486002)(186003)(8676002)(31696002)(83380400001)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1lUcGpJYjFVdUV3K05KRzNacWFkcEpxZzdqYVFXME9JOGVobk5xbUZicUpi?=
 =?utf-8?B?cGlaWjVLNXdTc1JkcFJ5K0JBYjRXTkZxSTJHaTJwUlhZYlg0QjNST2NYbzha?=
 =?utf-8?B?T2I4RkZYM3Y3THlWejNMZG56aWxqUDZrZUVMU3RXME0zUHhiMnc5d0dMbkFW?=
 =?utf-8?B?ZXRVWjI4N0NpNmdQUFNTVmlIalBmYzllUlJ1UVVXVVhGWGlqZjBLVTV4K04w?=
 =?utf-8?B?ckhYQ2REMlRJQ2ptY09pMmZiRWd3eUNyNXFMVUoxVGhZTkJkaVBZczFHODFT?=
 =?utf-8?B?NGVpTC9XWGM3ajRkY3pSVUZOYVkyU0YzRXJ3Wk8zU1kxQkwrMTErWG1MUFpB?=
 =?utf-8?B?MG9EUFU4cmhDaUwwU3hZUXgxbUFRMitpMVFqcWZ4dXZYcENudStzcXRhTm1a?=
 =?utf-8?B?UDVYRG5EZmhXZ24xR01yclEzSTV1L2x3aFhaSWRQbnV2WjFLZVlnTmxKYm5T?=
 =?utf-8?B?S3JLZXVQUmpxcm8wemliU3hxMVQ3Sm1LZmNyNFBJUlYzZTNLM0VXZ1RQRmg3?=
 =?utf-8?B?UEdEaXJVdWY3Q1N3MjhEOE5qU0MweWczOEo1WGdjaGdoSHdaV0JMMEphT2ZQ?=
 =?utf-8?B?V0VmT0F3VTFtTHE4MUdRQytLMDRWbklvTnFmSWlWcXVSWU15WnBzMWNSQWhH?=
 =?utf-8?B?TXVydjh3QU9pWHcwZUlpMTBwV0pqcjZTbTNKcFc2WjA2VWRUQWRrdWtSVEdm?=
 =?utf-8?B?VFh6Q2czaU9TaXJMa0UyYzZPbUpLR1REcUxuZklTVUxjWS9WeFo2Uit3UWQy?=
 =?utf-8?B?bmNsbjFvNmlzVkIxZFY0TGdjc21mZmhkblB4YUw4djM4OE12SjNCdFFmOWpo?=
 =?utf-8?B?ZHU0bjRmRFRXRHdrZHdPdVpUaG4zTXlUbmVPOTZxTmIvOWhYUVVlUFcyUnBs?=
 =?utf-8?B?M3NVVmNxMEttV2hTbnIrSms3ZXFVWTJCQXNkTGhCTmlqT3Z6VTZqamp2SW0r?=
 =?utf-8?B?U1lHUE81L0lhMjhnb29FM091UDF2eEZadDBtdjRNV3JMUm42Q04rZHFwZTdo?=
 =?utf-8?B?WWUwUGREU2pXQmM3UitNZnYxSzhJSzUrQ0NYb1NjV24wdnpyRE8wMTUyM3Rk?=
 =?utf-8?B?TWFTRUIxYkNseERSWWlYZC9xWE8yR2FtZDI5UFdIdjdFeHVQS3AydDZIZW9n?=
 =?utf-8?B?Q2Z3amN6MDRMWVc0ZU1ra1B3UnJJRmRXRGVkTW1WcmdhRlFieDJMeEFPTys0?=
 =?utf-8?B?blFoYnNFVS9pQlFlWW10b2xVRlFoOHRWL3FoSFhpTHREZklHUSttVENtOVRi?=
 =?utf-8?B?R09tTU9oTU9PMHlpeDVFVkUrS08zUm0vOVAzNktJeW5PYitOWkJUNU1PMTVX?=
 =?utf-8?B?ZFpxblFTeHJlVlRMd0hnZXVTZHdkZEU0cFBrTUpTN3ErSlFnMFAxTVFvNFlQ?=
 =?utf-8?B?YUQ3dStGSTh6a2hLU3lWNU8yMndNYkNZdFZsWnBlTE5LTzFBdVZvbkFlUS9k?=
 =?utf-8?B?WUgreGlISVYwK2VxZHdUSnU5ZGk5QWIzWGIrV0ViRHVmeXRPbmQvQ0pjV3BX?=
 =?utf-8?B?cjFMOXZ4bGhHeUxjU2FJWUFMRGt0N3FYKzhkUXFIMHlzMk9mdGNibkdJY0xB?=
 =?utf-8?B?YktteW1SSEk5UjNVcnhBSksySFh5eU9UbmZWd2F6c0hDTllCSm90cWhkdU00?=
 =?utf-8?B?U0JIdXFEQ0dDWDhnWlJZWHBBcGhGREptNkFzRjRBOXNmUjVneExzc1dmZnhT?=
 =?utf-8?B?V0NTbDVXN0N0ZnFYY3ExTEZnOWJSaVlydjFhWDlBa0VVQ2VRNjBZMk52b0p4?=
 =?utf-8?B?Q0daM2xNaGM3TS92RGZjK3dYRFpORDBjSEMvWm9aT0RCdzNBL1NaQzRjNjNG?=
 =?utf-8?B?K0pDaytRQzBxVmg3ZHJFNWZ1T3M1dHl5cjBEZHVwS2tRdDhDM0VoZFFJVk05?=
 =?utf-8?B?VUsxbGhQZ0o1c0lKa1V4MmorWkloZWI4cHlYY0piSXlGOFVFSVVTbDhWUWtt?=
 =?utf-8?B?VGk0ZEpURnNQeDdWN25LSHc0WlgxbDQrYms5a2pKb1c3UHFSdXk1dGZtcVRa?=
 =?utf-8?B?d2w3am1BMVNvSjlLZFN5a011UW9GejIrTGZ2dm1qN3hLY3ptUFpRa2ZCbEIr?=
 =?utf-8?B?anFFaCsrRDF5enNvYlJZSlJrdGJVNjJyVGtIS3MwRHV2OXBCTi9OSWdxY2F4?=
 =?utf-8?B?Um1hNmdVWkRvS2pjVU44ckpmaGhWOHR3anJaYk5HZnNXUkkwZXk4Slh1Tko4?=
 =?utf-8?B?Wk5YeFB5VXFyVUI4cGlKNitseXQ3N0NUWmRURitZdllVNXJzWGJpZXNUMEta?=
 =?utf-8?Q?hYsKFGKLyE+VP6S91jU1xR/rcbQb99kwPJ2osbv6eU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34304c88-812e-4e2a-a90b-08d9a9f07a66
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 17:34:16.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfR/Li8jWSgR/L0eXMQVCl/t3xBqB0y/t8bChNSXAhWXUG8vg6uVpOJ45GcXZRoxRk3T2f9tIrztuW/XEgUfkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/11/2021 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	108 pass, 6 fail

Linux version:	5.15.3-rc3-g7c10b031cbb7
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

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
