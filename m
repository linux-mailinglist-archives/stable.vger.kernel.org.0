Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E53D33C382
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhCORHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:54 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:43873
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234432AbhCORHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmF9NS8XwfXwcop739o/lb55/eMhroLm1dboauYmu+S3eVQt6vVDTJ28s1Rwi1+tlUm7SXkLOhHbLXcTn2PsaeyV6M5n9i6Apwk5bDCFURiqpdMofxyijjRJQ8ciOnItxr0OM8jZRpXR4L4Pq+kkV53gTghyjJPgMc3whLAakRTojFHC4t66neWCxygv4bzqigH5E8TxX9kHcl+mTg4cqWCPOJo8QDAdKbOwxHXfJPioKwlLnxmoMm5K6Wii5emsrg6CDiL8hul+T6o1e11+gQNNdj+C85DtCWS+Mu5g7yB8CMT2MUfaMGqqg5TmVVK6HcrHb1cd3yattKkMWvX13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnXDJyKtYsq4rQzr56Sh7+6nbZICrpFrA4wBDyGgbdI=;
 b=P56FdvFZ/DbB0if/DVw6nkQWfMj5/a5sh0Z0KlXlj8zr5cSfa8mMR1GOZCFvf/goutn/dS8yDrwjTi9VWN2J4Xe/wgdEg6sqHhfw5W02/UsYNKxdSu2Czhzs+v8FLJJ3t60PMehSYYIS80qsQ+UozGZGZ+WfnZK/vXpbIaepHTiWPcqE0shTOJAmr456uF70oqAfi8/8COQT9CbiQHc9w0pUJ9MtDtJ4SHIIBiGvxKrTRinwwNIx13n2bVtzKlSQgCUpZbdlaBk4e1dzdmI07mOkKL47EsoK1V0HUlm0Zu7pUog2zTrX8rA54FBeUwPw6MtllfhwPeY1C64IeTA1/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnXDJyKtYsq4rQzr56Sh7+6nbZICrpFrA4wBDyGgbdI=;
 b=s/HmAI8z+B/FBxZuaNh8gMXkoAqW3cLJCqlKLaWBFPr7Y6o0AEKOM5vMfTTKWu9hHlSDMnTb1U2Ae7NMAn2BFQ1yQtfZExA+AFkievR2AMaO5MdPsmsVRImMFckmTVy12d4NWeMGarZK9ymj0mGM/QtaxTld1ZbcXRbjUAi8Ipz7yaaUX5e1YZwaMdl7rDCVChX2jeV3xBAHUQ2T+hi/sj+9McVonXSlXRXjdkMTZoT4dwVioSklSIK2SAhF4XUVPKiTyHSzv/p+vg/uGDcZT8zNUpSEUuU6/HVh/zdW3yMcjrT29JoJ7IJSRN9HjH9E6ORo6UML8eskpFyrkYsV0g==
Received: from BN9PR03CA0661.namprd03.prod.outlook.com (2603:10b6:408:10e::6)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:07:11 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::e6) by BN9PR03CA0661.outlook.office365.com
 (2603:10b6:408:10e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5d4fc16fe9394a00a8b14a274c5fac02@HQMAIL101.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c075707b-9f42-4a0b-2d65-08d8e7d4c5a7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1607600FEFB3D634E0F55ACFD96C9@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xZJBxw61fXlu3UmYcAAM462CT8f6pBTzAtamMd3wViceNYl+yNDME3QefZBZWakYefYJvvq4PyzecEumcV1ntqsfyW/3yoXV1OCahQQSMUocSVbbEHUoDCBuLyznevnd5QJrA6SxbS60oD2zQwNwQRtOa/RHZwFjJlaqDlYkkaDrOwVUUFKd51zK8yp1sOW5Jrv1osSdL0LrtXNZo7IUoo4Qq0rPcWpf60OsRz+FIqxGVVzllir04OtdhUH5fBBLBct7hroz1YVy/JR6xE3XZafiMFiQky8xO84spjkwxTz/Yl/DdhCMJhSmSolTQuIKIG3jwgvqkhG0juGvviYO0JSfzlLLwZ4EB1N9LPGL8WgPgWbhARCSNg7kGieDwMy2IKcOVan6y528J19hhpf+p7W8b6S3e/gPEr1wsX9jprsLSyFXI77GFFQ4ame1CAvnMuOefg4fJ5pAbqx4lFuWnvMkgkl6+WXsJQ4o8YCJRCaFAYL8oDurgD5vlgmE99HqBIouvXVASaZ3bZkpLCRw0wKfTd/SI3ENoDaOLxbH4zT4ekwP+gySTASagpYVQxlC+Qgr+OKpwokecVXU1as2gPc1I1hOBlesZWjajiu3+oxcSjvPcUwLAJ1BXZf6ZQzpljZxIzY4O0aJTacwpga0rNTk2UwZgBbDgY0qIA+axLRzUHA+cX2pO/UVbVCyL4Ovh85Wi7keRsCy1jz7Xx22v0uxocr58pi+iHQM46oqvxKfzaW2v9LY4ctEF7mW0n5VQt72ACpLTdAOjmrZt/G63g==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(186003)(4326008)(82740400003)(316002)(2906002)(356005)(108616005)(36860700001)(336012)(26005)(426003)(7636003)(5660300002)(82310400003)(70206006)(47076005)(86362001)(8676002)(966005)(6916009)(36906005)(54906003)(478600001)(70586007)(34020700004)(24736004)(7416002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:10.6416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c075707b-9f42-4a0b-2d65-08d8e7d4c5a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:51:23 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.262 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:51:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.262-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.262-rc1-ge010cc44e05e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
