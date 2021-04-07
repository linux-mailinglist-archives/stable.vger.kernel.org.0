Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37584356697
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349518AbhDGIWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:12 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:42743
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349534AbhDGIVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFytybHZo6bYh3cdJ8j1MVgyv7Mw54pHm87CTBUGDzTjOjiDnLSOvHPsJ61Zjd85GWvU4Jv1ZKRwTeJtABN6pRv1GDRZHqeMBzfRHVlNucR8FJ5q5w/0GT4+XrWXiukmTWqvWjksAiOZHnjxDkQxe/A0u84gHKL35ErqawwFGRugayAdGWbFQfZkzU+usWt0uCykIqYI0JU2XCCS7wHc69GC1EZyqkA0cWKrKIn4XP498aY3UVVWxwZ589WLBfdTO9twReJuYdU6FyXzkp9J9Vog13MDVPxnrqjpjdxtGIFlzPfaHPO8nYkygaDtbJbBAkcoIfSjrIM1QmIwYTIeLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WINCOHXCVPttdUmYnWJkbQgr+aq6pzSEtjrSeKomgyA=;
 b=B1dyUgmryAN4609LW0i0mDSFhrL0gEentev0gs64CHEkr4z92GsHuX02sCArgsze+bZf3529IeVYY9DVXxSLzJ+HwyWg5UtV1W4J0WrS7SE/+ob9EBzoRXZN7itZfMZLf+L+C3fREenV4T8XzlJd5jL0mcC1s79T+SpuugZA86mLeCKg+W5Z8Qbf05CHe4T4c5zYN5WvgpJQQ9nVkFhCoqBywr+oEDnPOnGBa2WLgI4lfPjKpVxEAH9fb38unSjxccLG4qy+DosKe8iQ8PHdOnGP0i0lYnh+Az6JtDpYApMnn6dJl1Nsnh8SxV+3dhzh+H0z+QjOExwKOT7kfbrF/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WINCOHXCVPttdUmYnWJkbQgr+aq6pzSEtjrSeKomgyA=;
 b=q4Yfvwwpax+diiCckYGYH0HDruqdMC49l1u6AAlJss1GTWEy8CdsmclvaK7UGUyTM8K+Z/AET/u0IaUT//qIjK9xbZ95e3/HbOIvk680SmaPWRPMbAm6Z7YLK07fEgKdJkGp8nPuhEb8h/mc/qei/mygxMQsmvgd8/EGcJU4/41FfsJVubKqtTI0ePGLbiX2vHSvpuWdCZozjvSSWhyT7WPpA7PF8veX8mNQJoBWTsvqeJhqbqqCof14Q81eg6xY4mzUPaoFSeWCLsv4kFtV5xweTOqzHwZeXmgb6KuPkZJQAP84ilWGuVAoMNNBxhvlr3rUDgTgNMDJsy156LAXYA==
Received: from BN6PR13CA0047.namprd13.prod.outlook.com (2603:10b6:404:13e::33)
 by DM6PR12MB3210.namprd12.prod.outlook.com (2603:10b6:5:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 08:21:38 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::17) by BN6PR13CA0047.outlook.office365.com
 (2603:10b6:404:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Wed, 7 Apr 2021 08:21:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/52] 4.14.229-rc1 review
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8e7d514ebd0448ed86e46295187e829e@HQMAIL101.nvidia.com>
Date:   Wed, 7 Apr 2021 08:21:36 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65a0a415-65fc-43d0-bc00-08d8f99e29fa
X-MS-TrafficTypeDiagnostic: DM6PR12MB3210:
X-Microsoft-Antispam-PRVS: <DM6PR12MB32105CE828B81EC4CDDEDD01D9759@DM6PR12MB3210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zD9bLOhYwqrGvs8H5t325HxxYutcq0jAYsPwEDFHKo59SNu9v4vNCkoyfDd70RvyIKkGYOfnwzjck7m8qvuHGaaJouOdjyXGgMTc54b2U8SjS6HsXpzOmm8a79Ld6/27ppk/9si3UtKcsncHphgD54w9PaZDtC6b9Dsn+erHNvj6Uo5NhbFnW9dK3jJ30YVFlcvhEfGgXkQJP9RSGQJxVCMw8uiI6xKOIk1DDjRhYYIQ3YJwjtZI8jdTm3oC3UKAKPgEkU2S6F9P50r2EHMRkbsQdhLjRh5EsjlEX+cj5lf/DZsUd4GVHwLGIUoD09lv7piAqIbykuU/kpXx7Zs3Hxmo2Xyv+5li94e9j9rcp13a8Go5E6OlBMAnkmMGVicSnX9O9LpAaBlZAW2G12oKiqwjqQ7RNK2Qw18loki8/cQHelxQ6ytpL7g7NvJQf6rOQIpv8ga+jExgvb86hoiCSk5kX90FoEB9JfeiB8aE6T7KpaJUiVAuhLm18XwxIVESDUtU6Q3dm/Zr+YjkhDB/HoxsrsrVrPmZAayFnW9Nehz6B3mHclIH/Xp6GiAgkVwxdvHgyeLdAaZPZODIsgKLRGw5J6ZbUr9nXD6dJaLqDFpb7xyQ2YpWQPnD7H59jH7ATurQjUQ9bmX1ErgaP8meTgVOmBjg1+xCXCv9/6yg7US+ZP3dhopgjI0g6xuGL3xiKhEZm3YUGUCyZLTrDw6iEfgyINk5kWlWQ8PzyHbSw9A=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(478600001)(70206006)(70586007)(36860700001)(36906005)(5660300002)(966005)(47076005)(336012)(426003)(316002)(86362001)(2906002)(82740400003)(24736004)(108616005)(7636003)(26005)(82310400003)(8936002)(186003)(356005)(8676002)(6916009)(4326008)(54906003)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:37.5613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a0a415-65fc-43d0-bc00-08d8f99e29fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3210
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:53:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.229 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.229-rc1.gz
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
    32 tests:	32 pass, 0 fail

Linux version:	4.14.229-rc1-g9d1c6513551e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
