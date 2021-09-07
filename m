Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E841F402C32
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345497AbhIGPy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 11:54:58 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:48032
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232935AbhIGPy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 11:54:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWK4IRLm3dZDdxT6DyZ+KA6XXO/2ms9jgCttZb/vBhepFxo1lVXjr54N/Jt9oxYhW4N9i7EeO4d94CVzSU6IsBNidKGMB9Rsajz/WMCGY0uMHZRsxOSjvdZ6MQslfofdxRCQXtcucUQA8SbA3GmJeHXhe4sIRi2b5UhAPxfQEJjFEBuUl0DayJQdQNX0E/DotEfHh860TN3HfG0H+CVxOwxJg3ujC3VMiiyPTnRF9taIBhRSTTwKKy2dyNvRc1Lgr/LXnY+8VFqEXNKRP4F3No2GJRHGaxTWJbdmE5os9WqjO35Ub4dzW+kSFRDKv4v89OocezTT1bKV+EuTOI2Djw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5zRmBEPt9zBKv/q906D+a0oznVrjquCw5Rq86nD2LwA=;
 b=LCV/IxXLbfUr0tkwZPj8uveAnAduKpoQSRUcAfL4t3H6ENE6XoKzYBkQ0rYLHwGnvIZrmboAQEil50LJvGh2kqJILNfeJW40tJfinKsPFnTNtEna9V5lML2u0mbkXzxNWOTeAF7E8uHQQbNd6MBgPR5Pa4UD1qs1Jl4bWXIZEVTSs0bP2ghGY1lYH4egKocWxE/ZKB2l44i6SjxP8UUMwQEtSKkNeZlIyblQSiyb3G2ffaJSFTA5Ch7YslH8ZOhlKj67mn7p73TOkIDz2kC49n/pmvhZ3vvYNWuId5R58Scp2tFl+Tf+SNzLxBJ83MtkjcWkeWIdMOt676OTOLkOXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zRmBEPt9zBKv/q906D+a0oznVrjquCw5Rq86nD2LwA=;
 b=ZxgqkzV5TtsQpW2mI03YgzVvp4Qi5lv+gkAQDa8UCPZX8ALs8QeR/KzQh1BBMRjb5hQrHjIQjQOmriYxu7OptXbWW157ZhL0qInNiCdMoHgXZu6hL0wHEaMxnPwtnUzcFUejHECd2vaoMImUlXUSS4FlskuppkiCDAIdxPwokh1iecgZkPxH6Y0zsWSvKnu/I3A/HXgj4Q+IAULNt6gkagOpozk16RZ7+xstw44afYJksIyyXGB1vvUDOBt/qVcUJJtkZ52XE/uNXiPcGE3tUCM/4yz97p4UJGXLK5cfq7mGHKZGHotUbXqn+KzxKFAmC7oHpH7zx1py7BL5qaUZkQ==
Received: from DM5PR20CA0010.namprd20.prod.outlook.com (2603:10b6:3:93::20) by
 BYAPR12MB3448.namprd12.prod.outlook.com (2603:10b6:a03:ad::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Tue, 7 Sep 2021 15:53:49 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::92) by DM5PR20CA0010.outlook.office365.com
 (2603:10b6:3:93::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Tue, 7 Sep 2021 15:53:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 15:53:49 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Sep
 2021 15:53:48 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Sep 2021 15:53:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c6cb68c712304271b75291f50800aa97@HQMAIL111.nvidia.com>
Date:   Tue, 7 Sep 2021 15:53:48 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7d4bd8a-ce61-43b0-32f0-08d97217af0d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3448:
X-Microsoft-Antispam-PRVS: <BYAPR12MB344828788A196A765CC30F31D9D39@BYAPR12MB3448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXyLm1RevZrYX/OPEuKcd4/WVMp3/M6OFvHQGEvwrsY/gRKlEqGHUY4ziNM2+EM095QRV2+FkJ+maO2saaVBDfqFn2i4fHIo9vDFLn5kwolrSrx0cxRxzZlb5V8d+T0wJum6VCscbDBnd5hcDmF3fq2hcznfrC+RSeGpE/4ZD5uc622yr5nVhfxjIM7bBE13VtxiYeUhs3vnLK7nZ+z5J9FLQLHwCzYFO1LNYLGBaKb71+gmV9bICgMrmfYLDHbCP57X868dv27Q7kdndYb2uJReY/FNB+SynxHWSY+iZJd75H5OUWZGaIDhOvYPOhtVDuiAXGDfJaUYlYMor2RKCkqZN/oAsr1XFXltbgi9NRqIaBb1pv/oBzj1Pgq06rccdRHU4tDwpQ5AhRq3XNOQoAl6b2upiK6Ups/mmIuG/4p1DinY4KyFKagwSqldLvKHPSTNI4jM21srv2z26dh26itVpYil+9FJe7PBt0mOI4EHBl68am6U0UIxw78voohcJRNTl8njOfK4RK5u5EAOW1ofJNhA7v4pbsk+mCeicHtxDVW7/eZuQHxoYD0Ju11TGGrXqftVLO4pqZVN8aEaMWpJXVHY1eH8Lq4Dwnbm1hTWOYQleKNfioxUurMHOabneJK6LpLPXrJsC4CRkyJF2JQ8dwQ4iGH1rASjt9Z9iHpWEYiipHfTJsqxQwY/T4kJIF9O6cye2TU/S+xXoNxdUJn0ylHtm4u/XqpyOW4HtNOBf63Yg2U/qFY8uh7aWz4nuNrHr2ERIEYnBiM9zAMcv2rFSP/Fn+fNYEz/ozB5HSg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(70206006)(6916009)(4326008)(36860700001)(7636003)(508600001)(108616005)(47076005)(426003)(8676002)(966005)(54906003)(26005)(7416002)(5660300002)(82310400003)(36906005)(316002)(8936002)(186003)(70586007)(86362001)(336012)(356005)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 15:53:49.5328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d4bd8a-ce61-43b0-32f0-08d97217af0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3448
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Sep 2021 14:55:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.15-rc1-g6fcc0c5f7322
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
