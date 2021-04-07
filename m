Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AAB356695
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbhDGIWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:11 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:12260
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349518AbhDGIVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDOEUqLEqS9HKPCsp65YfeRPyhr+AJCSLckL0Fv4DVFTc9UX5NuAowbjBskBkRL0pMCGLmQuZhKRQYB5dnQQXmB2zXzVvGlBlYLn0N4NZQJ8qpVY7Ltj1sxy5BbvmBMFcEVboJ8kdGS9o2C0QRjFynrggc/lLiF/w4/EHx6N2Z4hyt1VwahENGyKCgd2EctA/MtnoSb33D8EI9cgvLYhD8DL0YgYlY7ibTCS5JNpIuM0nIXJHbffq4HgNtpxS0f1DfWt6FEELxBGj3N4JYkOxe47G1WmO44TRMfrFSqR09cw/Vq3RQz2eXCuCnPIhGhDPV0xIHe9rGlBgRITSUCEUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpIvyVt3CPD3K2nZ0cJhM/aoHce1xaRzgluwuf5L0So=;
 b=AakK46/+xbnanJL0CXCTg3ampJCtXgYO6nze6FNSs+Zco/oGiCpPsrXPMfqQIa1nu/vdM3Kc5GMqYYsuZFLw9Q/+K+CwoZET6yHEUfucuIRI6/QT3GsHxRjkCx08Mvccxc/yZYgaIv4mSt4BgaAjbDuiaMw50NSttwWGYjRDZECOS6zF6waLKB4T1ZUugzeU+qQPsn4GnD+YRapCe7tYWm/tC0AHAO7EiEr4BcH9KgJVXVS5meuk7gDixYZt07W4NFKGKd6irn2Nm4fibLQJjVmkDMAxOv22iuA2gqQ+/RKNIxZ9Q8aR/rjJM7GhCOfwfzHkji5QE+FVHDvVA6wHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpIvyVt3CPD3K2nZ0cJhM/aoHce1xaRzgluwuf5L0So=;
 b=ZizrZ5/nd0LYQC6VT5xuc4YpowZg8MrSgPhBIw3Clm31oljSRwaw6+BlqtFZtNdJULIalYTW5/F3XFJMbkoRZ7uuZVEVUCxur5lqbl3ijoW0La3nCGeOvxHMfQZOd1AXaP3VcelqvYZdqwZlQ9GiLRHpaM7wRZaW19sIua/ZHvokMguvEBNBRfyJ7x+rvgeyvVsJBpTgqiNLEaV2N9aBZNRrQEnltfPQImKmvBSG050T5kvYeWJU9ah3LlQZcwgnIZNjdGG7NHYWk5CwZi+5yoBNCljWv6dy91D2hGMQ3vC/x3i6hKfnvwEDBhkxTf6up4IoWWGMsIeLjBNDQFt5Bw==
Received: from BN9PR03CA0129.namprd03.prod.outlook.com (2603:10b6:408:fe::14)
 by DM5PR12MB2471.namprd12.prod.outlook.com (2603:10b6:4:b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 08:21:37 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c6) by BN9PR03CA0129.outlook.office365.com
 (2603:10b6:408:fe::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Wed, 7 Apr 2021 08:21:35 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 01:21:34 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
References: <20210405085017.012074144@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d90830f085074b7da7e1c6d5a2ebd262@HQMAIL109.nvidia.com>
Date:   Wed, 7 Apr 2021 01:21:34 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f072b660-b6bc-45bf-41aa-08d8f99e28f8
X-MS-TrafficTypeDiagnostic: DM5PR12MB2471:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24712DC8C3F2396796A1AD13D9759@DM5PR12MB2471.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mVxlskQ3DQvHlpf5c9ILgZKviLBt8JyO8oCTpCsb8BfHZfRObeNCmmLanM1f3cm6p0Dt+AgonX4Ct97aUwXFmjTw+JGjJSIjRHqriDvN3mT+WkmuKXReok9W54t2L7fAGjdnARhrF7bStsgC8LqDF3+cBT1ullEbNu5TQgIIT4I4/DrsvTY8h69iSRDodc7v5Sj1J4Mx8CFdp7eJKdrangAn5AN+EpIvtmkLpt/RTs357zzr8ehk2J4Yfd5u1bJ/ndw3pOt98++b+LptC9R2/TGp/UDIt2CftsOXPsZQK0SufaHzNGVIaZguJmDjoBhI1VjFOxM+Lop7ELE/oxx92fGQ4szgl77PMZMiYNuaW5enP6J4HS2dbqoO0v19+N0LzWkO5Tf4olCpSnf4AJYcmy51iTvK1tnuF7AcXkm0T5n+BKnfi5itkATgkH66SkPpQlu77X6412SdN3xeQtFHXjv3b8U/3ThkPQBLYj7HgUmyLtqbZ55Hzh2Efr5q88oRK7ZDV1JAmILgle/PZ5VCiEcd87SYRnwTn/plmG+7oVI4THlHH9U0Kp95pI+I5BqU1yOlZ2fsG0IxsXLYlavKrEHvOQekJVaE2hBkoiRc1Mn1EB266eQpxmywhTa6WjjZ6pkqksiqlJM9iRFT5t/mG0sdc1aL1gT3pu+hmu8wlYZ+wd5qyeuDJUDwmHRYNrGGyn6FTjKy3KFVllp8T/On5TGJ9CmxOhNv+PMBEm/Lkss=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(46966006)(86362001)(426003)(2906002)(186003)(356005)(7636003)(8676002)(5660300002)(82310400003)(336012)(36906005)(8936002)(26005)(82740400003)(316002)(4326008)(478600001)(7416002)(108616005)(24736004)(70586007)(70206006)(47076005)(54906003)(36860700001)(6916009)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:35.8543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f072b660-b6bc-45bf-41aa-08d8f99e28f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2471
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:53:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.265 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.265-rc1-g5bb7d387c8f8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
