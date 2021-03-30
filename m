Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E734E48B
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhC3JfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:35:13 -0400
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:21505
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231680AbhC3JfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:35:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHpSBQMi9adovZR2wkwOrjF7+NCB/jbHh/t1ZnvRce32/2VTVfM71lS56XQRa7k7wx5inpGtX1o4EUow07Q9KDDKPLMP8A3n6WIQcJgqteSeDWk1zM/AEdSfhKQaPPQfGyUj0k6v/rCcGuVyNpbWU2oT3dnqdmv/3T5Sf6G1MhJ3TmEhQ+60QCxttIKmEIaEibt1lNFAalbZAW5yNRiovhg5ZYTHIUDM7mg4AyqcMwqFr0p+TT3J0hpK1NQGKyz+wgnP5Q/fAHtDRMuSo6EPbT2fiDbyeQpqFeS7kYBAu2hMKU/HCiEZZK1dQOaEodRiTiW1txTAVocpR6ANbfP1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvQv5STgID7/eXu8dMSQANRtNOGl6198DLdwdpyLjuA=;
 b=n5yr5SRJxdf/SY26/RoJsrbTRy+Fr+wzWZKgJ8X6NHLwNyNDQLwWNU/78GnT9S9DjoF8E5xzwwHrlfLL5eRSNTgTIxFMAa+ZDo3epo/iOVoTC09nedZW95SxInECyg4Qzm7+Nq188GSJxApCHHnaOFBosm2+nwoN9wESCwEhY5ghqi8nMl3XLZ2JDZpwKUX60nZR1wL37aR+JO7H+o4Jw3Ntg4R5iGLbMqGvZVFcy5cwopJO1xa7BQ6AXADXO8Ww4nfv3NClWGAOX7O7k8HTZMbL6BQrVWkR/hugzkeE8pEVZqaMl86gQ3y3aLEKZZ7QwRsRvgpCID+MYD85Ec7zvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvQv5STgID7/eXu8dMSQANRtNOGl6198DLdwdpyLjuA=;
 b=tZ9oP0SV1zgMvl6f1alwHGt5Ninzj7XLorDx/2E/gUfPMJvtpaCfGk4aE5APuSe6fMW3V4GhpgaK7qo9x2YrjdZN606PdFHczuEvqDwCEHbKGX4sMuaXKW39v9FE1K5sZKwqhBlpQjVEQIltl+JhN63kbjrDV8zbH112133y2Yao1gB9aRoCAB1pK6kFi/o/kXcfoaIBJErg25LtZFuzCN+1WWf/apv7QEZXq58Lrnm4c/wS8tMmDcSmMhd9vb3n6FSjh/krC64ADPDrOglf6x27u/XbiuxRKXkj+37T60bH88nKkiO/WVpkwfGY1bMJgS1b20kLdPI0HhyKz8GmkA==
Received: from DM5PR22CA0022.namprd22.prod.outlook.com (2603:10b6:3:101::32)
 by BN6PR1201MB2531.namprd12.prod.outlook.com (2603:10b6:404:b2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Tue, 30 Mar
 2021 09:35:04 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::68) by DM5PR22CA0022.outlook.office365.com
 (2603:10b6:3:101::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:35:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:02 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:02 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 02:35:02 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <56289431a1874cf0aa79a7515d4ce646@HQMAIL109.nvidia.com>
Date:   Tue, 30 Mar 2021 02:35:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d85b905f-8ad2-4e6f-0737-08d8f35f18ad
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2531:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2531033E6B3C404A6CC9B213D97D9@BN6PR1201MB2531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxowbKahSUgG8WiE23HCzPeWzI6QcSaFirGu43OFx1UAovBgkfB+zWLWOoK72o4UDOzxw8HukqrC2dnecRqpZn78n/rvSoI+dhFWB4n1m8tz1NGSpMxHq3sn68N5Nmn9Qr5PIRQi4VwDpSzsptzZKBGMolsKxUApO3e1jF9RkbyckCLefsFRPub4s8uE4Q/6aZaMsFQHk9GEmlZ+YI/ZzuD5anM8UkD6zJFM+xvaWXineJ5Ln4pnb0tbxjPelTM449JhOLM2I7SXRLxTISwDD05x6h20q8PV9MOqeLKxB4oQmeba2Lg5tKmACl1tivKrnqOGKkEyAH8xWBSpxjyWxz1cvv0wLrRhDyrLO9mHbuC/kDbf8BHXcAndyFPzoyVkA9lPEu7CS+2G6BUfTTzqVh2dD5g2O/uGG4W5ikjfKVluXB9ohBPzV6l8U6aO16heKpta3cRStbEG1c+3dbA4Bx6UjA3qL7P+evzlH+8yoHEyisgx7AqUrK27FyBGhgETrrPEX37ub5vfalosaYmhGNYmTt7w5gj5x2ZhQb43Ov7LaXBDmVbZ4EPMYmacm+UMSCUPhiU4kmSP3uDevJUHqEepC6IHKXcEvQq4ktLBNZmZH8iLtm9PTawAKT28ZmTRQDneGoE8VZOZvU4oz9AkMnwbL2G/CNJrJtS6Q5PhnKx1cHyYZ2CrisDfxhAQ3ct2Qojio1ySHEVw+kskKISVr1zWPb7VfUrZ4uQBMCq93Rg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(36840700001)(46966006)(336012)(70586007)(5660300002)(24736004)(108616005)(86362001)(186003)(426003)(2906002)(7416002)(82310400003)(47076005)(478600001)(70206006)(4326008)(966005)(36906005)(356005)(7636003)(316002)(82740400003)(36860700001)(8936002)(8676002)(6916009)(26005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:35:03.3251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d85b905f-8ad2-4e6f-0737-08d8f35f18ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2531
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:57:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.109-rc1-g7b78fa4bf15f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
