Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E1449F825
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348157AbiA1LUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:20:14 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:20445
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348153AbiA1LUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:20:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3dMuQUyW5frirfgQ4UxabxFVyvJYToLLSFDJ2ye6B4/2+oPpmdtAFdlJBz4PYfTiUy/mNgsaT6qgzpTY9DfvKNxEcYR0DOTvla2YAJpK288DRv30wsX+0IgC1mepNqJ9nw9Ahco3SbdWNS7JJ7frqeUSXwc7GkHU694ezMF/202RHzE7IdDP6Pvnoq+FzU9SWDcOdTHdwnt4qFPeZVjTEa2wrIVbqJry0w6sJzxrT8j4Is895wOCo7Nlkr4aB5axgJh8Q8+UqH59rNEk+GiEew6rLOwPHF/+MiDnJGcCSV9d4TEi6DpfaUMJ2SEaZLkGNOnk5mK2dnU17U/2vZeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpaqGedXz1c9Pp1+XG2Of3E8k/dYCkOx6+ysviKpyrU=;
 b=CIoFJPh/sAeqtZWdOuFwzitatMiaabUPPDgVBj05mQGUbzM9qGOyu61yShh49XYhkmrKmLdEpqtrYhKobR5rTPYBgr7LK7FHxBb/NIoGUs18hkLK5ss0hPAEQGZ2R3a1l0ON95cUtI0bfE/gcAHit312nBeVZzMs0R8DR5+9+IZ5LJg5LyeAQZvtjIJfdo+vS4/ptoYE1fOEOg/IV/+OLlVd4Xgt0zse6oMZG7XOLJQsY9oju7mbj+yiVTzlYd10AVodEkPzDhEb7nF5+/e7zxnivLuJtNM5KCTI4HjiGZnL6RGhEW/RMdW5hfmZ/aRzOOfau5pQOL8Z0/5jSYmT5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpaqGedXz1c9Pp1+XG2Of3E8k/dYCkOx6+ysviKpyrU=;
 b=UWrI5Ox2W+slPn90nYpHt9pVcJCikwbvXzJG8c9++KIhBkh62fF8jfYT+aIZP3Y3mfrfADsBHHP0iyuiKIsuZWqdudN3zfQfkOa8C5zKglMrUAj71yCQlldIcvCTn5WnuYr4dPrwVWn7wrPxWu0XPMfI7iDur9eW+RRfJCwCege8VNmKNz1HtZkKEBjxEKnjaxNtSdgc6aKKabLtQTDZZTfyBtKYJ/91+Nt63KNc+I/6SYC84r1+MKJVJVyAZyQ6c7YVqLF8GZAb+WH8s7Pfe22gnEYwf6m1no7BSZHJkdZdnl5UH/NLm5GDl2BQythxY65ThInSQZ27kQJspTup4Q==
Received: from BN6PR18CA0016.namprd18.prod.outlook.com (2603:10b6:404:121::26)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 28 Jan
 2022 11:20:11 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::a) by BN6PR18CA0016.outlook.office365.com
 (2603:10b6:404:121::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19 via Frontend
 Transport; Fri, 28 Jan 2022 11:20:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:20:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:20:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:20:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:20:08 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <04595e18-b6ad-4f0d-88d7-b0b2909ada7b@drhqmail202.nvidia.com>
Date:   Fri, 28 Jan 2022 03:20:08 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8cd398f-ab61-499b-9363-08d9e25025d8
X-MS-TrafficTypeDiagnostic: CH2PR12MB4837:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB48376E40DF9A61E4C5BCD564D9229@CH2PR12MB4837.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6DMjJH5FUaIjgulsi1NoB9GCIP25Y7H3AlMp55ztoBZRrAqG2PvXvtzmCtMSkLHwdeBx/3R4FWmpNFvpBM9FjchyD+bsLXZTN2Z8fGJwdGYh1P9SaPTLauFZZVbOINuIgH5hNQpEjVM/p5t+iBE3mgDZwqUkqwsbPqB7rFObu5AejLJ5JBSXayo0ELiZCXVJASUnxba1joXAKyoUxwZxAJvUJROKzNE6EYzgA/O1ViZkCAoHAwVndJwdrSQubZ8Kl8sWDAOBTECOESPUcSqyyxksZOIEtY8vAaRhy0wmLZeSq0/6PjV56ABJfqCNrA1GwSIdqQkfehwXryV6lSspIZBozwhIU8ib+dYahSpEvNNiIgkxn2dz9VLCQgCCHc70lMxyk6MV6u9tFgcqK9DWDdBBQBGn8G/zZ1m9msQIYGPgXibMn1BqDMgSFgnrFpgroEVZegUk3fBoKeOH88QlcIWGDhwHv6RYu4O39wilzOpGP7nveLay6hecbfmMkiLpARLdHtfo3isqR1DO/mtPU45pHjWptQNISdSEcg/qxMPM2MIhS5MMqlX62yBRylCIbV6iRdXta55U+pO832SxFyuQCsvSFzBb6p0ZEPzpFXSJf7tsYbanePAWpWsTamXwEKceiYclhPY3PLIFuMAzYFkormE8t6qGFdavtgcTzTUlOLSA1QjxiukxHp7lvXv9E/j2BtT838naXDY1WIcrjl5zKYQJIlWxselI9LHPvBmoIHIQS8KvFXtE5y7zRYqb0DdZVdBIT7GEOhbir9jA1KEb5sh+za5dIPJm0k2C3uEDoNJuHghn39IMnACpLuD6xTcQbC46XPYc20fzJh8K61gtBDMfvFj6ZyNhP8FjxzsuGZPEOrFzI0TkNhS2OA0
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(316002)(40460700003)(82310400004)(186003)(966005)(26005)(508600001)(31686004)(70206006)(70586007)(86362001)(81166007)(356005)(5660300002)(4326008)(6916009)(54906003)(8676002)(47076005)(2906002)(8936002)(36860700001)(31696002)(426003)(7416002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:20:10.8128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8cd398f-ab61-499b-9363-08d9e25025d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.4-rc1-gb894c0fc760c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
