Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647CB3E2CA2
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbhHFOd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:28 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:55776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239864AbhHFOd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nebpWuvJ7XWXzZanyZEzF8zYrlja5J5FdGyKiw0RVk/B97v7Ss0HLdeO70CZKSXbXSNcF9H/urA7QfEgDgQ0Xs1jpL8V8VzjkHKbeH8+ZgPeB9dDhcTFC7glaVVKNvy886lGqJ6CyBdvTuXj2Y9gDvj4CU4f4fbZ7iFoaoz6P4VsoC7libe3Otxp4H2tZ09lXPgTvnLbzEgNQTl5CUSWdjRLT/iCG+K5l2eYlgsTcYWVK74XJ/b2JI8XZyBhWwWx7lS5kQiLqQaOXJ6AJtbpcJLtp8rvfz8UBVE8mOGiVJGMUZ7+nEgk4EtxtjfaYcIlB4yO1Gg8fHBK7OXdQMLNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnMcEpFEmgWmEgOTjSIx+O0GXyYPxc7d3wV7mzWhQJA=;
 b=O74DdDPD4MTcjqw5JGlOZnl9ymWPg7NGdYNKPiyQ2n5rm0xB984cX/zevSNaoLsDjJWj0q2PIJA2UtfSyrLvqkguGo+qvflQ0E+q3OvXQ0r6PXOCS7w34GMsemt52WwAAeaqoMXr7+/doc/DRSYrMcdVHvCfNzuchg8diukqNWvGddQkCowhifDqFGf6P9hddB4Nu1QmQnm2wJEHsZOY0j7uFbrLAE0QtRl/+7sTQkibr+/zT494rPolIswqfeBpeQy39ah5pexUwUdv1vBthclLQsF30TCJ1VlSqcmcxs6A6CejpgBIw2NhTqiW04v9PzmfJILx90JTRVSDWJY/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnMcEpFEmgWmEgOTjSIx+O0GXyYPxc7d3wV7mzWhQJA=;
 b=RUpTCjYtnBu+NtEGgl88baz21vJIaYPfh6TgRQPg9hRLLl4VR7/6GcmvWghm8mDagj6KtGo8DBPoXpKUXas6UC0UiSnC2Z6CdO+iMw8HlCPrlY3yWvsYiVvqiYG9EChnyNI7hT4EBas+gFiDVzz4Ad0E1+NNEz64ZxR4wn6GLNqLrpZNb0J3lwHxwMW/ueApquGBV40yIAhXOb+ex+QttNCmMOfqKaHO2S82ZAK32stmpF48OiYccXDGkoFzUStH9YlKBsvZDNgyNo1b9noT6J4GYk5NKto0GoztjLUgmzNpwrwxgNeLAGVTgoRVHnsF2yOCgNxhLjj13K66YuNtXw==
Received: from BN6PR2001CA0037.namprd20.prod.outlook.com
 (2603:10b6:405:16::23) by BYAPR12MB3591.namprd12.prod.outlook.com
 (2603:10b6:a03:dd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 14:33:08 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::c) by BN6PR2001CA0037.outlook.office365.com
 (2603:10b6:405:16::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:08 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 07:33:05 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 00/35] 5.13.9-rc1 review
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <75a74869fda74980b48dd0e52278d5da@HQMAIL107.nvidia.com>
Date:   Fri, 6 Aug 2021 14:33:06 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3980b1f-da39-4a6e-7c48-08d958e71c39
X-MS-TrafficTypeDiagnostic: BYAPR12MB3591:
X-Microsoft-Antispam-PRVS: <BYAPR12MB35918492A07891C30012848ED9F39@BYAPR12MB3591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzvIfThTjlnkypjS5S+xJE11WZn8S7Cy7ZpDannz57IByB65xEzradCg+Rkhj61jYtSHNypURAzDblAvma9lO6SIzUGvkXguH/8Ib3mPRlELXRNwuAcw6WEYHBrhYkzeFWnRGYS6ZpdWHNWIyER0baBibmP+/fADi7gybBWFz0DJNml8TN8Rhq0WMs+vXyAEmYbjwYY6BCko1nKmM9Bf8n7ACw5oRygtqVxNDR+xu5o8kBdl2rpB1X5xD9/zGP9sbpXRwz1TGgFs4AWKmeM180t+7fDOQ9XCec8jsuqzOuEOW7q2fIgDLvVpepDNnBCDsa5KFfHT8N9gNJUb3QX56ToVmfb8j9XqWOGrhpkn5wsx0KbuSY9/pvf1uqbo9KrEAVACj1+7GeO+/54pO0ceJL7VhxShrcF4BvNLFsexINRJuIxqJdz7MkQPVHnLtYGxiWIp2Mjfgq3jN/EKIzCmgQ9xQLgEefidH/sspmpZXsBMLR+4cVyUD0dh4QGRfJ+wc7OrKF+I/ZICjcbmutD9ERcOepM3wdANpok7WBoBS+vgXVSJoipUaWsFjb1yKZ57J7nkkYqvqLW+gxMf630X9mRN2LGSaeeUsy49Zd6F9TpXPe6gbLWYihM2s/t+LTy2Gqd8TVfEh9XWRYPDqDCcGdj88QddA0NVSrRouw/YwrFGUlXFRsJSUG4DejpMso7AWyVJYH67IqP8R+xheOkacpVZpS2RD6Vq8NydmWgImlPt0YkAi9IdvGliKj9I95kX7hgx4SgN7LMejXqd3aC8xy6/ezKSaHp8Vwdk2c1VTjE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966006)(36840700001)(4326008)(82740400003)(336012)(108616005)(86362001)(7636003)(26005)(5660300002)(6916009)(966005)(24736004)(8936002)(478600001)(8676002)(186003)(47076005)(2906002)(70206006)(82310400003)(36860700001)(356005)(70586007)(426003)(54906003)(316002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:08.2345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3980b1f-da39-4a6e-7c48-08d958e71c39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3591
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:16:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.9 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.9-rc1.gz
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

Linux version:	5.13.9-rc1-g1eb1590ab470
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
