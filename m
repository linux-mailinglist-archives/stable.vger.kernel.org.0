Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B126D374847
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhEESzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:55:53 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:64800
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235022AbhEESzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:55:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOXTkJLYMAGLAdj3uTzl2A0Ek0niY5RbI5cRX9+TVcPmlkKq5E1gAI/qNdGP62FXPRXu9r+suVDBpNTFAYJ4JzN6x3hicxaMPQ/NtKFQhZgnf8UZVQ3nkhxlUVdAh0b9YNOaUcvRPuhZAka0M79ffxZFNI72tzdT7cWNjv1SUN/TNPJRlpuPkKWNz5uNKaF4QDC9BFSIUHJTjKB+20GZLiJKI70IB31eXGrJSYO+tnp2YcGKPTO9mhsexLGuklG8aYWSocq7cHHcHv849yJDKfL4wPeWoCJXiycW10ECfuid/hBFDBnm4b60sVlx29mtREWUZkp9jdgXAc2+GmBCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2zukSQ0fH0MwcRlA1ToKu4KVJICPHP1HR/YXigsac0=;
 b=VKGb+TmaoeGYr0yWyRhHC2YWKRDxLiTkJL446KHkRQRp021ttEKvg3gD5brM21vP15EBccK7JD80JoD4XANJMzpg1tuayt42fZTvoHQgrlGVSBHQGVN2wJ3mCCsVFMqjPoEvcJh6+1Im0Xxwp2kMgZSaNpdxYHoTaoeasCTjgm3VxFIV3TvXV6cWhrY93IZ7euKTE+lqHCGe/22Ms4nbrfHkWHYz4u6hfuQNaksjlzbGDrGwbIUxvHL1waIBeuItsTZgqQOOmLnfpx6ptMDAm0GG6Qu7imFQX17zsap2wdQlIHyXvGVGVZL+ZfnsRUzyC+17MHiVR+AlRUHdsFTS4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2zukSQ0fH0MwcRlA1ToKu4KVJICPHP1HR/YXigsac0=;
 b=aoY+xiOoGyvJjz/OMCEO2/9GWz1SK8XbvNVzuPwt/gGFUNE8QP0LE/Qp1oiW4W1sQKDhzLMxoo3s7GfBZPjffU3Bs1GdZHXfxaWD/SJDbJcOWnLEoX2a6LtkdlPGfh7rhQJyP8jnhDWspdLFdlLKUk5yGEiVvgTPZhkQOYGYhQzWvCB4uW9Lpd1LScaNCOLh0r5guwTkQJIhVAMddWemCvPy53yEHm2ySrVGYVidRyRS4rSOtm5rL0najX5B3pY9bb/cTqw+RLB9sPv/KTyc2N0G2hERADVBmfEazDdjM4rhTVbCJTP7Zp7au4nB9q9k17ipM3YtWLr9QI9S0DZEnA==
Received: from DM3PR03CA0022.namprd03.prod.outlook.com (2603:10b6:0:50::32) by
 BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Wed, 5 May
 2021 18:54:54 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::82) by DM3PR03CA0022.outlook.office365.com
 (2603:10b6:0:50::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 5 May 2021 18:54:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:54:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 11:54:52 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 18:54:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 00/17] 5.12.2-rc1 review
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <79a0288bc5a348d787c3a806db97df1e@HQMAIL105.nvidia.com>
Date:   Wed, 5 May 2021 18:54:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aad98881-4077-4ae6-04bd-08d90ff74499
X-MS-TrafficTypeDiagnostic: BY5PR12MB4243:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4243A9B6007AE5EB40FD585BD9599@BY5PR12MB4243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yF9wsX4Nc0+R18IXeXmBXxRXdr4FIXTSBeEFVKvDjGOsXropqJY5GFq4duTiHzIWfUe6YjGFDy/lRH1ZqfkJ9/Zfxpx4XreATmIg/QPcQlPSkZnR81u5OwcaZ2dmXzjY6olqOIKo/e086PApc/tguCEtf3uL08K8We2k/ETEbaX8J+rSIrrdXROZ1PIirukfd4LuPa7rMAB+5qsLPsI5LjtDtDCle2zti9zfnpXrHGc4AuHuTxrjfvo9RhHXBeKZa0cjXIoL8hfW3kmp6knyphu2F+fmv4+FlvL/mURV33k86BK1cZyyGYUtl73j3q9gKNm167OYQf7YycxU5PIiA+SsiYh7ACCl32+2zlRE/Tb/SdRQaosOW+9r8vfJqh7TG/qKPZbAO2qp0w6RWdsUVc7PbwYgf1kjatYdkYnA06uyHRpdh3RtlKoeWXQcBz1dxVCe/s8ylo5ciFCrCk8ngKzAW0uyHVclt8DEALGS0kgZXdnavkDOYAbB/UrZJnEFQHQ2s3bsKUU1bTFtSniyGRH4E9tBHYMT5OD8O8Cmmvr4/17PNbh8LXn1ijQ4qcQvhD2bY/q1mFr7By9cTBtq/C5SI9PrMMc7TbuCNB2+mV683vVVp0pXFCg9sOvt4uibuXXTEdtLVaUvK6S+erorq9D1RLmhi0ZwzkZq+sPnzPrHhtof3UpIrHSvzEZx8qiQ2lvwNUVy9T5Vu2kwycvx2vosn2NAUeLRNrpwn7vk+yg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(478600001)(966005)(47076005)(5660300002)(6916009)(426003)(316002)(82740400003)(82310400003)(26005)(336012)(186003)(108616005)(7416002)(24736004)(8676002)(8936002)(36860700001)(54906003)(70206006)(7636003)(4326008)(70586007)(86362001)(356005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:54:53.0824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aad98881-4077-4ae6-04bd-08d90ff74499
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 May 2021 14:05:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.2 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.2-rc1-g77358801e46c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
