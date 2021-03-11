Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF78336D70
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCKIAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:06 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:25569
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230048AbhCKIAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 03:00:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn+rAVKu+rCqgkKxtg0CzMABVIXPVscPk3b/ip1hyUCUKQdmBT81EsLQzMnEnMWrmUDX9n7lF8SfIOt4oH+16cJN7uUt36BjLVcetVomrc7abzLwF2TP6a80neNrOCyV82B4KO7d6IgnB3kh6cVW2VRpdMx2IZZcFuMyMv909ERpFWFvpW5MTCnB0Q7O6eEVS5FhZeXUcQVXr1hZwX44hEcxpd/1hT43ylcG7F7GPbUmmxf3loPtUbSQf7mJ6bgjqcT3jzmBSBMLKi4LNc54q4qxHKNcsd3Xs0xI9ZaWaxJARXxS30/hQOBqfys9OGy/HQNIPjSiC0lNPIoa+9EsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBBPL2PlozPUh8JXCrQfjLESdx8IITU4ntqCnl3xyag=;
 b=UBw2iYHnXh4NQEt7AchLG/l7r4igDpWtRq6OVCFgZO4hosVw8+xfi2f0DtTUG8gHZixokZ9xKQ5v6toIFX3pr+6zhvyiawmMhKEKCv0NUAP21JSDBEiIFP2OwT399SjT1oGGV8POmKXt8dk+SIqRvDduQg9K9Jgm0pnt9ENkdSszcaH6P6SaCvcT20GbAGovwBEN0/CwaiLpEfdfv3IFG5JTC+8G5iQKwrI/KYQ3XajOPqZSBnGnUv910gqXxiKuVGcvpnsUiG1QNmWLW8d2fOd+0sG4dgUHW++6mJ8RhF2jEKBfTVdurjljpotMTltFpqniYqNuHwV3RFvwWxBH8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBBPL2PlozPUh8JXCrQfjLESdx8IITU4ntqCnl3xyag=;
 b=Rn0R9mh5XEenaq41vrXnIDHaFKhDFvUeBTaOd2sdg/pP6b2MEyOC8InvrqzTFH35yyRwGZRqosN1x2qqoECKLKy4QVYi82K4q9bt42Bl8PYnf62earVZdF5cebH1HPegUNGfhWlx0PNMwJtvGScsu+CEYO83eGzSNAv1r9S4E5J45PlkZ59rNbjau+g3wcE/zfGO5SnQ0CVeUubfYgiLMTU+YrmQzB0g57iRkQLZDqv7X6dltsl39wX7LVBR6GtdLKtfi6mKlAflFWWZLRARL3AV7GJdjj8OPfcipfSV+Kf/AFLv+LppIfU53wOdt9GFzF1hiEmOH8hVJnjuHiI0FQ==
Received: from BN1PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:e1::28)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 07:59:58 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::c6) by BN1PR12CA0023.outlook.office365.com
 (2603:10b6:408:e1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:56 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/20] 4.14.225-rc1 review
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
References: <20210310132320.512307035@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d809a045c05b40579f05e9cceaa999f3@HQMAIL107.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:55 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0870d89-b650-4104-95d4-08d8e463a95f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37398B126AF7EB80640B2ABDD9909@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJKILwMOrmSPbfG0A7MtybkTiqutkapmYQTlDDq+JCc2l8Y4WzCWWLcltFG+hGFmmK3k8H6Jw1WjgUctaFqgVSCtXu0CKFzCs2EHioFyt7Dl2bEWf3DDcyqH3KUpGChY9UW0LUwgch8akhGxwTIff5lfnpe9ptrlE5KmAFcUJT7MkYA8D5wPYCDcqRllxhg8nktmEQLoOrcCL7Y8aHUtrpUyJQrtRZyS4KyPODe+rf4gzyXTqhlenY8kOk4A9A1C5bPmeHVyaxHvR6IfJQ0KaZKh2JTsnFzopKd6yF1qc5SWDGwJDVB8HGEBKroDsQfzExalOG1N5nf3Kfdkr/XmyHJe02pxPkTjBU5q1n+YQUUrBHAOI3Xqb6yE7iZSUmcgswvkrvw02aEM8yA4heJCY38Oy6HC1psjfI1hKMvP7/l8PCyUKsJQj+ATsGNYR8/K2R0p99CD/yhuyTRh4HJr4GjYKJRUA1UIWcdAMM6+56BnFbYb40vU2RTAo0hCcNLI8ftdaxAvLbv7sc3YZu6jLHeMKK9mjebmW7DbNgrU0d18tppZNb1E2kuyFZFTZbQABE6qDbLjZAPcNSFpa59JcYKO4vszSvJO4uI7TQEWhZjlxInggH8rIHZFRaS55wA+gkhssvNNkxoP+d7fHM8UGnkFcFNYocWg+Z5OXOVsRzegLplPGSy9IGScIEGUtAG+wdWmTkgcEWIFFFIb5xn1FwISk/oIKu+92r2H0TAikdS48bkb0JlzPkEZ0vlTqyDT0peHdHHz1nz/LARvsLHzJA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(36840700001)(6916009)(82740400003)(108616005)(186003)(36860700001)(70586007)(47076005)(34070700002)(2906002)(86362001)(478600001)(4326008)(8676002)(7636003)(426003)(5660300002)(356005)(966005)(316002)(54906003)(336012)(82310400003)(26005)(7416002)(8936002)(24736004)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:56.5795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0870d89-b650-4104-95d4-08d8e463a95f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:24:37 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.14.225 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.225-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.225-rc1-g878d7bf8fdf6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
