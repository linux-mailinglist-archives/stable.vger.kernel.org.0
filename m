Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA91A34476C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCVOfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:35:25 -0400
Received: from mail-eopbgr770048.outbound.protection.outlook.com ([40.107.77.48]:25730
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231129AbhCVOfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvlMq3LRgdZBbcbJWYiIFRudZtfrsRaHpHewKqzR+YSlksvHoNJSMe5Dqt85Q8sE2sbXB+v4CVBUUMvEcJJldFbot4lYWezub+BC3gIjeOUj9JG60kgMI3TspgPqn0YoMvSlsHibW5QxazCqEhW66kdi7qY2BvLJ8hCjakqGA6eI8d67C9Xx8ms/j+QZxXnCJ+OyyItLQtYpETwFAq0qRBP0yK/cm6xA/Sbo8wsPoq0qRwLfWxsGlPwzXn/4jkPuCoGCfztC3QF8RtzFvzP53R1FT6wljY5eQZmpJPQ3xdF5edoXaXIPPgsFjFsv8i1GMxRy+CTajQfp9dYQU1e5UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Nkz0GMKa0BkTDMRbBklVFb9fWxzJJOqtAATmTQjDOs=;
 b=kGXa+CJemlnWfReg9Y1irHhFmykdBOXJbB/OqrkQd9O1nXiAfXyCfN/qCHBJahmakhR9wgWBhPiz4bazqkdf0VTxYJYIQ9iC112XbGJ7FPxpKtAfAT7SyFBAZPs5jSvxdUtYEP7LpF2Srah1JrKi9XnK1W7/LDvjHFB4TxC5VZKQ/XjqRlqbhQcqFarM+XzGCA8PLQz596Itd7oN9jiUOapX9NE+80vb+M6Dy+15VKV1Go63p1Ot9JA0nJ9VZcKxOdqk6jokCCawi+cSJ6aP1RWFIAq6xcLEEtcyT1bRt74tkS/Fnd9XOZu5ijB9Mnp5e3gCgxmPy1XnOC99YpNp3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Nkz0GMKa0BkTDMRbBklVFb9fWxzJJOqtAATmTQjDOs=;
 b=L5p3VlgIvH712ebiHETdBgB2LClNEy4C1f0RzACT7CMXod74kycBRUGer9n3LhhVPOfNlDscrinEjBifAspB4rf6JPrtaF61o49gObc/yMyBqf8S06QdAX1BsjQ/o4bfDIxirxR4mvM9RZBpdRT8tuuyCWd4VUWFt7EVcO6+2SFmm9PJCJSeRsEHadpcJYjPGQhyZ8UrAH6gh112Fmt+Z0LXcYB35PpbULSEfDx1J5pO6QTL7F4AvBy0GjBc8pjM+/jPq7sGmUxEUd8QLNOqNyx4fbgZF6luREkUXEeg67e8bG5zmR5N5XsAtrLTxQUZZQ3NKLi49mXOlBoI0moYpg==
Received: from DM3PR12CA0046.namprd12.prod.outlook.com (2603:10b6:0:56::14) by
 BL0PR12MB5011.namprd12.prod.outlook.com (2603:10b6:208:1c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:15 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::7c) by DM3PR12CA0046.outlook.office365.com
 (2603:10b6:0:56::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:14 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 14:35:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/43] 4.14.227-rc1 review
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6ed9226fed00407b859ca627eb6cee31@HQMAIL101.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7632270f-1586-4f20-a096-08d8ed3fb4f9
X-MS-TrafficTypeDiagnostic: BL0PR12MB5011:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5011990C5A2327B7DA84C37AD9659@BL0PR12MB5011.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RQKmmNxZ3VCWwtLlE6uFNe5aUrz4cDSNJt+S58o7GrN/Zl51WmgmGP+o6XwzNMniifs0KuiONANE/Z88rIiFx/PNpBJEQM9oBDFeywfftNcg+wq58W/MpieSlb64X0F1mgP8cj+JOFHE6Zr31nQWcKx5PCZwZtmI8rSGFaXJB5ulvhGtVOFwkg+IglcRnV2OdD0jRGebTZtfN0+T39BA+Ahtx91xvGkWuEpzKkjyK2iygqwHa/MnxG0cpLo7SLHn2C8IEQoVeybAcfi8boOAOwLqw0DOrtPZ4VjyGkGGAnUbUBXUuGQwD6034rWpwu4YKpr8JQpbRoAeZ0LISt7XZVaj9LSZ5A66hxUJFLY5I1O9+3vG/uSuUlhTZ+GYcSJ3NmMFlqV20WRwd7ZNXqnu+8WA8K0C0DHXwyecsSEz+YLY9YDV1zNN69Uo/IjFa7VB5/nLfqW/ApQZjAvxqwg4jQRH6fdCTJVHj+CkMSPvt4hysArlcbEqOMUXCl5IqOZMhz06NEmjX5WmfAA8XnbrIX1KXOx6uu3jmbMzANqLcjHQoAHvQ5z3siKgHxHgZ1J69GU0Y+E1J71ZcEvVIJgifW1qLNYyfyMvH7FtYpLG34NhSr1+aCgzqt6xZ8YG4nPJpPx4Ybb0hEWcKmzSjJq/y4M7hvHdIHSEy0BHalH4dyTfgA8QTwt/ZOhvTCwijyl/DwjMsEW25UC2fVOex4xuFIb67Gtbp/r9YCHLSgrka8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(70586007)(26005)(54906003)(8936002)(82310400003)(186003)(4326008)(8676002)(7636003)(86362001)(70206006)(356005)(2906002)(36906005)(6916009)(966005)(82740400003)(478600001)(7416002)(426003)(36860700001)(24736004)(108616005)(47076005)(316002)(5660300002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:14.6886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7632270f-1586-4f20-a096-08d8ed3fb4f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5011
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:28:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.227 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.227-rc1.gz
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
    34 tests:	34 pass, 0 fail

Linux version:	4.14.227-rc1-gdbfdb55a0970
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
