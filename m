Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817D7374845
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhEESzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:55:51 -0400
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:58721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235020AbhEESzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:55:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dt39h5ei3coZvqGhP89xcnZKRc4nAt4eQHA1U6I0YLz1uqalYULrIljUwerSGm4/g95x7MN5HXxVebRpvJLx6l55VHY3uChxaqfBrrh3WYR/+hN/k6fHhIiSUCFez8fnzdsYvkowKxpON2R6vRPVZRHPeehLhTKctqE8/tPVpJLY0fO5zetu5MVOP1ufKSdLVi5J5zB5xwH0vOMcSsz28mjEDJ8FjQpNE4yu1SjMKvzTsHebWgUpYqmLodAXuX8IMFjQHBCi1gYaShpfot3n8hZSdSr/k45wqlDI/Dh0T7+rHwOeqyg1tcB79f5q42xiNZB8WGSyDzEZTKyOyFintw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4S0FFJM7tCPVvsoUZIFYWeOrsufJ687c8F5GqTy1CxU=;
 b=MLzCnLSShF05wlymoeqFn3UQuDSh45Bmnt5vb7s/pmV/aufpUiC8/P2w0e+vX2csb6f+99mg3ZbVN6SBTClAORoYSgk4iP+MXOtyMp/bhI3LqzqNFz9KaA9zr+6gqTqE03nwXbemsn5duTFmB8dlqCO2EzOp0Hofp2COaImpIXzzkjMa4PrLLamF2a29Txm/mpuj4Kn/bfCRPvX+zdsTug7m0iEJT844P2ZlqXv0A2qv7sl+NkKnC2oFsJq7syRFC8JJgAlsxWkHP/5eoUzvwG1bkbsxRngrw7ddgZUsuHG04FIxzURmMaDJrxzVsvcuZgQQ3E79yFwhGG3WiX0KTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4S0FFJM7tCPVvsoUZIFYWeOrsufJ687c8F5GqTy1CxU=;
 b=qb7luryxm9jZNmMFZUh/jAvxMkQ6AYLesYfAI3nCP2I6f8ERgu9bKTip7W0mqaTyfnnmBWI3cRatbrXYpCr75d2ttUO6WbF3myef414O/VyDkynrNZ/tSHZOOg86ErO6vVh5QE1BHfm0i0GV5adW3PtlCtYYCMgXbX5mW5T8nCRAyHopkcHHBexBqPmNw6cNhOko28NgHTLFEIKJyftfVxXd0I7nAWTc2pWxoPOPqCF8NmL2jWv0CudoZ4gO7XIK+69GQ7KTg/AtR0oboNio6DbYnFXlHsFNSEwUopsPyrYGfeU/pVsEcKVBGp59OjlwkS7O4IogKPBMrEnNTT0o/w==
Received: from DM5PR13CA0069.namprd13.prod.outlook.com (2603:10b6:3:117::31)
 by MN2PR12MB4064.namprd12.prod.outlook.com (2603:10b6:208:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Wed, 5 May
 2021 18:54:52 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::90) by DM5PR13CA0069.outlook.office365.com
 (2603:10b6:3:117::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.11 via Frontend
 Transport; Wed, 5 May 2021 18:54:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:54:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 18:54:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 18:54:51 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 18:54:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6f7bec530bbb4e428cf1b5faf7f5b6c1@HQMAIL107.nvidia.com>
Date:   Wed, 5 May 2021 18:54:51 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc38a633-d89c-49c0-955d-08d90ff743d6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4064:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4064409F2331D1B29C673F70D9599@MN2PR12MB4064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z37M6gfyu6qMRsg/h5YM1OoJGcOGIoIm18FLNnyM/PhzknBr5g6bNkTNiTecxbz47TPmLVXkQzU6yhKTZA3UC/P0lzZU8t2o9Xv+LektgbBXJejjEkKNSgKHZDngBU2POPGeP/UBPmZXcYrjH0xVM3O9Z6gnCY+Ejsllnn+rKZCVrQDt48TOIiWPMXwm3UK4NqwkDDilpDgUNoAr1gik59aJ2GZVZLdKxFbLazhK66CodgSf6K2q3hpDVPgeBSM38y1BtlVaXRLcKj6msoftvfdHGMsRb4x+Dil/V5wrejacGZ8AeAZ8PdyJUHmC5DIBHg4yoeH73S7jcusiOtHDXe+DOBmiSIa3ApC3qu6Wd+33qL4kuqPk07+xw366ayHZ5phX9MN9RzyJsbn/KP2ym2PNFRuzd/6mHxJYnkB4qW0lqkia/4OMXqGsiCqt2mmJgKHi0Jz9Nus1XURMrSVCg8gNmYsbKukacw/2cm5hZQQXoDzP/9I5Zi879+IggrkquVWeO0sXOHz0ONuzpGzE6stizv/7CYP1F1b33ArSuPjuoqjTtE6451qfQtRgKiFxJurfBBOAYnlfvPuo8PknHjAZSCAYqlsCKtZZw9paTXh5clobz5VX5iDNvSjjsODnDHbX8Rx/S4lEOGWKtSZMGnxoGQON8QzdZsmmk1oLKX7CyCRwvs9WI9DYF727+F9dQBxJMsHyslVWOXzqjwe5b73RTKbNPub0OPzC24AYQQc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(36840700001)(26005)(6916009)(7416002)(70586007)(2906002)(82740400003)(478600001)(24736004)(7636003)(36860700001)(70206006)(82310400003)(86362001)(47076005)(356005)(54906003)(336012)(8936002)(8676002)(36906005)(966005)(4326008)(108616005)(186003)(316002)(426003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:54:51.8061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc38a633-d89c-49c0-955d-08d90ff743d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 May 2021 14:05:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.35-rc1-g5f894e4a8758
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
