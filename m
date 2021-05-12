Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90E37EDAB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387938AbhELUlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:06 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:44449
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344843AbhELTqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:46:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuLXjXBnoXtup8ECIgi10e+wRwr3qLZ/MlYNS82GjJDtX/OJD9itxiZvVmT5DyLez2g6tD6OcJF48tl87Y5rfMR5SRXXcwlFmuElvjmPwnFGvUFuBy/ceeWXFwI+7hQavfTPk2Dq1mt6m3soj365Flk5hz6Q8SxhpS6k+w99KnW3BUd2KpKgFEZX9GuxJk6zuHRs20GIbWTFWz8rAoDksJiWZ0+j7ur1a+kR1Qmcl6DooI1kbhfHFmEiY4cxkSbybCeN5jqpMU5VVdw5HQ6q9wmCAbiLvKUJnVevnLH/t6vcD3BLmYpohEOzj14K3XJG40YVfIoFaurcL1lLRQ3AeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkbeUe4uYhEgpDzNhWx6Es9YNlqvKozYhHxvpEnTuE8=;
 b=NR+wXZlwVm1Fdy6qb+dWxHiRMkCpdgmtvIUJnwyVzrfb8ZPouobKWGHAgkvKgIocoMAo40tAYqwbM4CXsb8Im8eedNjQlroPd3ooa494Z+67OgzOk20VeZLa9AzPPbzbMj/wgth4ZaXFbZyuCzZrq/TE9cJjQVURJY2NvfdPB20QMcyqyxXXb6+QsbVEErl01aHzOBAjmbq2PJXQ+eu2OmJKwqwy2XknoPCNxuPwxdrCUuAzPh+pxtvqnEXcdHlgi6JErA+0UHPMxNcZY4MKv3re/62bY0F63WzqBCwRlj/lcyRZ58/O6/2rq+qiGjq2p5Ty+GJXium3/3hTiv/9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkbeUe4uYhEgpDzNhWx6Es9YNlqvKozYhHxvpEnTuE8=;
 b=IfEW0GoZRbMBrXZIJKdvJLpQZkr70ZpWzexliFphv/edwEjK3BcBXDreH4jnaJBd4J+eRGEa2fnnVkcxY4/02EA1QIa9jLOafoDmdeZwPYVcHo0F7GVka4w+7nBmhJoSH8+ctyukMn07oqw1mZXJmeGKYmPnyGXybhLNXt1DSnvrscLTq3pqeb5ewK2Ablrg85+dG0a+WDPv28uTuW7kWk/sahMfpM09vyXNUxAIfJPs2qjXksVpEhjpsywCdw7DL6/p/zhCKDB2XUmU9YGB4uyC+gpg7GRDhu65ipehxYFcnG+A1A+peL20e5jgNaDWl6SQsk4HAhZIJsuCE0kEIA==
Received: from BN6PR19CA0101.namprd19.prod.outlook.com (2603:10b6:404:a0::15)
 by DM6PR12MB3115.namprd12.prod.outlook.com (2603:10b6:5:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 19:45:26 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::74) by BN6PR19CA0101.outlook.office365.com
 (2603:10b6:404:a0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 12 May 2021 19:45:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 19:45:26 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 19:45:08 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 12:45:08 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6126cf346a284b7289954102e26755df@HQMAIL109.nvidia.com>
Date:   Wed, 12 May 2021 12:45:08 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 847b2727-0545-4c95-5c2a-08d9157e7d53
X-MS-TrafficTypeDiagnostic: DM6PR12MB3115:
X-Microsoft-Antispam-PRVS: <DM6PR12MB311535654B262787D6F940D8D9529@DM6PR12MB3115.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZiZ7V4+a4SNypBrxyi4nqhRqKsI6NRto+GIKyhyXKRpZf+Mb+1beNwyZN9nYlQ7bEVJ+Px095ikq55Uon2brEKOvgBlmIT/SeaA+FCk5+esXlxvBG1Jiy7rnrdrCsHPaXRx2DlQs1ZrRFs15ilZo1zOJ4Ze1SCpCcU3SC6qukkN5pck030NTqMzkduB+sf/HgzbbDuKfMEO+/vrZltD5YuZMicQ7smNNnwMQcZ0R8hEVepTNL/dRTecx18xEn4FzDHGZNBm2je2EVnlHA+OEQDeLMWchS+nnudbu/wLc0AXggJHCq5NItGVrtZ5nlVPAGRs8j2qBXKexOAl3cUuBuof20p4lQN0ac6lcP6zVA0ByJjwML0rgZygOUdbhyAOWiwIRNtFkkvUpfQAsGfkiWsIf1vS9GjADmN5A1yDj7KYfoRokSD11RU0/ZDBpszxgrvhEhJ2lJIAsfNJusTRkp4TXQs6/h5JRkrvt2/hqhzFvAKwrLZs5BIRkMIVXR2KBEjDForXAeyUbvy3qt/BsY2GKRKvK0bvW3o4TOi0ieC/EaP8J/y4T0sB6QVDi05Trse2h5eedYTS2cvGAq8z6siv3UxAulWOY3/KlGDUoqOvuQ0EThM/rBs/PZjHR9/OMg/NVrHOQuW+taxGoS2jdkmCxsvjAYro5BGXQXth1HYMdcEDPFjaxWX8kdDdQEPJKVo3ojXC1jbMtZ8WBVU6N3xbuQEuv0YKuYmF94ckT/Js=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(46966006)(36840700001)(86362001)(26005)(24736004)(108616005)(5660300002)(7416002)(966005)(8936002)(336012)(8676002)(82310400003)(478600001)(2906002)(316002)(70206006)(356005)(426003)(47076005)(36906005)(6916009)(7636003)(54906003)(70586007)(4326008)(82740400003)(36860700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 19:45:26.0474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 847b2727-0545-4c95-5c2a-08d9157e7d53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 16:40:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
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

Linux version:	5.12.4-rc1-g6c1612b79300
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
