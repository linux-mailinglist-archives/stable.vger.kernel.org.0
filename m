Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED6846B7AB
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhLGJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:45:04 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:27456
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229510AbhLGJpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:45:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6Qkob1l+u0Dq9Rxds6+exI7eRwMItLAd3NkKdbNXQv9gYP2KU7PknRz8IDHdpm4d9GHE9EWlpKkEWY4kylC5IY56b+9ViW6lRHZhsLD6sRAhgQ1R+weM1TdWaWOQJL3kD/uWQ7rl9c+XwRj/rzCHLZvZ4WxBWLFWIj5oKXvD2pkQR5u6lsXHvHc2TPedfVxk5UOpPMCHkNvRK6fpH2PyQpDSBsygBinCiz/yhrytjwbBANB7SDgYVAQJaOqsXN2yV09ZSE0VNLkEOt6q3+ySsJxd4f6gL503qT3Pn30m8r+9vzuHVEd6X1lBrxYfuLwQ9zwQSJsijLqICBO0Tk+TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srOYUinA37NriO1CDEharsp1OFPkjhKFjOD07ckakww=;
 b=c152wfINOPMHMmW+XbIiS899uvbIJPDHEKcH96AS2tcNL9HbJTLBsxnu7d46unVutse5vq5VRCaSs13s0EcPLdHSsl7SxtQoPrrYa7RjyyFGfXdSBU5W4jGjrdiD7XyfcqhVKolxlCnkPJtB5tz8LsXcB6RxP+3g5b0DJ7sh4LoXemHpGGfHtgkAD/pRS8vysePKxGIG3GdOl85hEo6gV7YDHpNABqEGNWcl/0r9WB5N1HDxDACyV+CAfIO9z92m1d+KfPXJATHv+mkGJghV90WfqvGQYa+H0m/03bZPO8qFikdExIOuefKJOIYEPGIEJ8v29QJPTChTFTlkt1iPxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srOYUinA37NriO1CDEharsp1OFPkjhKFjOD07ckakww=;
 b=ApLIlU16YevdrB/7Hvx4QhUNtf7LsgNBuGJELgZAFHoEgz3MQyMExqyn5RFEDvRwYvXQlKchu7m+bf3DvtPc6znLWah+We6t9gXtUdB50JU+hQBgCI/JxgqFUmYP7wk4G7Sj74jY8KRL2Ig25M6FrFERTFqTjqfhvILF61KVUNaa7Oz1HsRKIAHKDt2tmAAQcmBxDf6s8oWujBz645ivdkOGyfwUB7VMxOX1hs3y3GyQnCdOtALNKYKAvyHo4AtfcMXIGQ4ui5NUMYOMlzwd4XD+E9bdvEXkIajkWQIZBJtwH9Wu+0TFAWSvVzsBWwVY//Z9pMcxgzjqJa1cE+z30A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5459.namprd12.prod.outlook.com (2603:10b6:303:13b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 7 Dec
 2021 09:41:24 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 09:41:24 +0000
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20211206145610.172203682@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <01a5648e-19cc-ef83-4ac4-083d50a5dc81@nvidia.com>
Date:   Tue, 7 Dec 2021 09:41:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::29) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by AM7PR04CA0019.eurprd04.prod.outlook.com (2603:10a6:20b:110::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 09:41:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b91ab0-67f1-4f18-fe18-08d9b965bbd5
X-MS-TrafficTypeDiagnostic: CO6PR12MB5459:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5459D31C122AC537406F8106D96E9@CO6PR12MB5459.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f7VM+Ci3nxrzwJUvtXBV+uRI7EGQ3lqLKN2doslQFGYKCKwr4ngShQK2praddDj50qV8ReHuRD9OcjHqKfVKbOY1bAKaZSp9nAmODxLosmBYNdoCgbdAhyhwwQpXdECdB13Hy+M/GOv/anqtNKySnxLdEcsYIi/aFHQ0YAB5SSNDzoLUnsJ4D/HpfLCh0W/+8PPE/4ylq6WpX+9jCTDke4T7eMRtbHNDJLPjTJXdRVdbpnUOHqDl7syRoqMGhsDmBh8gmnDR7wv7yGBtJ1qUzYf9eGvxL9SREZW3BQO4A7Nwyru0Alv/ZndU36LezQ1gTAzuQ99zWjwIIYlo76BN0UFjxpgbcK6bb/ibIrAFCAUCkBxBMKmU6Gmz4XB4K3yU7Ad8rBsiNed0y98bgBkuSxfU73wPjJL03TZfhYSybtK94W5ZVQ6VXRt2xQljbwN/NGSPtKmu4xVLLiMVlAHgSO5hjDtzqE8P7WEvOXO+2VGYm+1Xl7s7eiX3UOKxEua1Nt4vSzTClBH1fIyHM1JlcPHYgI1N+ClUUSHCbZkpco3cmbJKTb+MXUmWgdRC0lu2vA3BMJ5fjlBQqsRz9Zlydqdt5KkD8x0IFcDFL7TrS1GnPyoSGtCUr/rLo0i4f2jin/L4UDPS2fFR1ktmlI9azPr/fuMq0KAKs/ukShnXMnelhRCYcZzIgPP+SgxdAAEcYSeN5S93XWQyrqP2BifqPz7kw3CkM7gd3JsCjwkhbxPzavP5UFkRwXXx64mGN8Wzjh02VbztTi2qHBeQjeGabdrq3ldiEZlt0gEnuX22h9lvBNJWEAqI9ctL+Bp8R920o5+b12LFl2U1H6FEOWHzlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(66556008)(2906002)(53546011)(31686004)(66946007)(16576012)(66476007)(4326008)(38100700002)(316002)(6486002)(36756003)(5660300002)(8936002)(55236004)(956004)(26005)(86362001)(6666004)(2616005)(83380400001)(8676002)(508600001)(31696002)(966005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGY0UWttbGxQSDEzdFMrS01uZFd2SXVUOVdvd1kvSG9KV25jUFViMXdXd3p2?=
 =?utf-8?B?S3dEZi9HMHkra2pGMHIyNkxzRGhQcjVyQ3dZdWhnUjFVYkE0R3BJKzRFTk1q?=
 =?utf-8?B?QzBjY0trR2dENDFNTE9HRzhTZDBuR0o4dHFmSUhLdzBTMGJvU0hmY053a0E2?=
 =?utf-8?B?RERGNlQ2cDZJeUxjSzF4MFF0V0hCUStnUTYwd010KzhkT2hxNUJhdXp6cWli?=
 =?utf-8?B?Q3AwUFJmSlNLSm1KUUt0ZURKZjMrRU81VHdmUXhsQisyS0djOGo2MDNEN21y?=
 =?utf-8?B?WWtIeEdkN0IrUHAxRGVTcVF1UlRLeFRNRnQzanYxbUpiekhTWDlXbzVVY2Zl?=
 =?utf-8?B?VGpEYXFsTWVhLzRLTGd6dTRoSFlDanhLRWhlMkt0cEVONkU4b3BoazhGVU1S?=
 =?utf-8?B?cmRpMnk2UWFCTG9BWnJRYld2NGFZK1VoS2N2cFNNc09DMGF5Z2xyVWxmSlRy?=
 =?utf-8?B?bUdSdHhVaUhPNXFIeml5L240UXR0djl6VjBrUExjZldtbFlZaGRKMFJtYW5S?=
 =?utf-8?B?T25tSlQ2YWw0M3VMMzVYa0UzUDJUNGVYYldrV2piZnl4MFB3aVoyc1BqTkdk?=
 =?utf-8?B?YjBMSmI4eTVyVjFOMmxZdTBxbHQ1bWduQkx5MlJFNGp4QklpcDhOSHlWN1Zr?=
 =?utf-8?B?NzBoT1d4ekE5L1YyT3lkK2kvZWZEbHUyMlZvTm55eXcxMXFRYWYyS1ViWkI1?=
 =?utf-8?B?TzN5ek5DR0h2VTYrYWQ0aCt5Ti8yMEJWcW9Xbi8zQmJCcS9BcW1WQ29tV3hq?=
 =?utf-8?B?ZnFzSThrODRiMXdSQk53YnY3c0pRdjBOSWdIdTlUSitUVHBtd0c0elc5bm03?=
 =?utf-8?B?TE9aTjlPaUtRelhoTXgvQ2FUVXRPeUxmZVRhY2M4aExOYzZJRFFGcFRqSk5k?=
 =?utf-8?B?ZTgvL1NXbHBTa29JSGhGU1hFWTg1dWFLT3ZSRlFGMnJnQnpjZ2VpcitGclJa?=
 =?utf-8?B?djgrby9hL0J3Z0FRVW9pWFNGZjR5ZXo3RUM0b1JWWW5DclpISk9DV2l5dkV0?=
 =?utf-8?B?YUhwbC9XdHhPYy9nUDVMb0RXcnhxREhiY0ZZa1J3S2xXTkV6ZEVmRmppNjRW?=
 =?utf-8?B?SVp0R1pOcmdiTjBkK3FDUFYyRlFKRENqQjFOaGJrQTJyYXRTdDFDUmcrTFlq?=
 =?utf-8?B?L0tTbU1NVERuVHFUQWkxWGZWM0h4UHljY0xPZ2pPZDBJbnFsQkVyaTVIdWdm?=
 =?utf-8?B?dzlWSnpLbE9ySTcxOURHY3pqclg1b291OXRZZktxVlZ3Qlo1OCtjdk96OU1J?=
 =?utf-8?B?TVZNQnlTeENzWTZ2b2J4RUVNMHJWWU85Yno4VFFvZ2lFZ0N0bFFNVUR3VnBL?=
 =?utf-8?B?alF4QzlvK1Z5Y1g4S09nR1RkN2U3ZHp0ZGNOR0lSK2hIR0UxK2lxMVZaUm5w?=
 =?utf-8?B?WUpSUjJGK2M1SjRLdHEyaGttbFhBenYyL2RtL3l0ZUlVZVVLUk9Ud25PZVlZ?=
 =?utf-8?B?am5wNnUzbGFQK1NKUzNOT2hMMkZvbnhOYlZZblZBdE5od2R6ZnYvamtpdDZK?=
 =?utf-8?B?MGlsR3NKY0NwN0gzUDVwNFNzTUYzd1p5bXRZb2xNWEVmT21vMUdnTk9DUW9m?=
 =?utf-8?B?emR0R0Y3RzlKTTVGUlNXQkR6c2EwWXdvcllEaExhQ3ZKVXJaOWlSdmxUaW1I?=
 =?utf-8?B?ano1cFZwVEJaNmJrbkgrdWV3WGFpTzRXRE5BcW9lcXQzUXJLcUNSeEVhWlJu?=
 =?utf-8?B?dXhwcG0xeGNWK04rVGRwV1Rld0pDbmhVUHc3bGxqMVU0RUd2ZGFyRWZUdFJY?=
 =?utf-8?B?YkxpWnVyQ2ZYNkxjWTdab0VrNEhZT0dONVYrMzUwdnkxUWVGYUI5RC8vUTkx?=
 =?utf-8?B?TGZHZ05qWUU1WjJVOFQ0OTZxLzRtSUxWVW9pa29GQjJLdjZDb0lqRHIvTUZG?=
 =?utf-8?B?TEo4N2wyM1VWaW8xQTMyRHBDUlJaU201RUJ3Q1V0TVNRU3RRTEF5aDgxK2pM?=
 =?utf-8?B?UGpDQ3dEa1M5VXQwTUNPQ2d1UzNGYTRCd08xQVBjY0drYzIrdUdwL00xWXRv?=
 =?utf-8?B?RmpxbHR5Ny9VZXg0SG1mMjNEelRBSG00SDlkTko4SUlieGVTclcyWEhTSzN5?=
 =?utf-8?B?R0RmRGFIblFZUi9QcmRpMDRsZEF6SWV1NmF3YmpTUEh4dkY2eStiVGNGNnNv?=
 =?utf-8?B?cmtlYk96ZHZEa3dyT3ROaFh0M0FsTHZqeDA4VmhVRDhDcnJsWjdTMFI3R2Jn?=
 =?utf-8?Q?Ug5hcJnGmYBAC20LF4D3pdU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b91ab0-67f1-4f18-fe18-08d9b965bbd5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:41:24.7897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UvqtJ02DZuU+NcOqg6oYmbaQI5JjoTbjHp96Z6yAFIpoSoqUrLVq/WEJ3tPgVzkhs7m+u94QT1DXy34eiNd5TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5459
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/12/2021 14:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	107 pass, 7 fail

Linux version:	5.15.7-rc1-g47c02c404f4a
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
                 tegra20-ventana: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Still waiting for the necessary fixes to trickle into the
mainline. There are 2 fixes still missing from the mainline
but should be on their way.

Jon

-- 
nvpublic
