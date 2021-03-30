Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAEA34E487
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhC3JfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:35:12 -0400
Received: from mail-dm6nam08on2044.outbound.protection.outlook.com ([40.107.102.44]:26329
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231549AbhC3JfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCUKm/8nn8cqM5TaikCLswCVVWxG5aXuOCnDklEBxhJYvlV3hCf/nge0PmugQM0vN2MA06s+p4i4YZ9JIEZP4LagdvZ4S0RkS987wYo7u8ojWRb0/iaw6YgTp5lBPqbG85ubSPmSGFlPss4rfCKN/kwgNrTUBj3V4WI13fVGDnD4cRED7HVWStI+zV5s/aVceqIDziV7Y7saz8I/hJsXTgz0dyK6P0uwAApZT+ia6nZvYGGb6H3xFDF7KGhP+mBXpPLGLZtnoWHrnpLFqLMCr+R0od8lNdfB22SpU/2bDUOp8uD5pdsV9pqlHyPiiJtf+Ce/nKx7JhObYrrIH0i8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QW/dsIvOv6IEG+opo1bJX0kszfWZ2REYJVKIUJs4oWw=;
 b=fKyJYF/rNMY8P5lFvkPgQhrktCDFLFE0h/JJDl66gbOlkW3iZfSLJAujIRNhrsNgx3a6jMaYntOr9FUZieVk3E5gsUhBHzy6FR2U+FTrTJ1MNoXypVqJ8DGjsARBEspGR6F/DEddw8PT1x1NH1KhV+Su1I66X/31Nk7JqIx+s1ekAUN8IScZHH7oG6TYU1ucz7dlMHBVHjKaHGqtlm60L1ngoPY9v1QH7INVIo1O88DlmdMgE30ChpP01hy70fyUKlE/qLRLQU+bLTfn2VH9glolvXeL0NnhYD15YT2EQMhYKC7PXdzIn4Rxy66ouNRAOBuZ8sfxgh4OIRz1gprYRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QW/dsIvOv6IEG+opo1bJX0kszfWZ2REYJVKIUJs4oWw=;
 b=po3RLd/qjR7tXTNZ/MUFeifZIodEF4R8d+WqMsUWsWqzbvmgfmxu+6geYIjsFwC3if8zC4SO5cL0DpXjyXl3DxewIMVe+T2yaKgskDT2UlSEQwP3owN0X8S6etVy18hx4XVVt4tYdfHFy9aTHnPZZBtpOhS0c9MwHClswlStPs8SyHXpzV+JPf48YjsXdFBM86sQyJ23euq/ASTvUjX8xgxE+Xasj51qgYrZGkxLFP/oJ9au/P7rnv/v7T3st4mVah3uVSNcAUvUxmO0rmaradkqgWyIjRqDpT2V+dL2p1g7iGHwiAloLJ4+Q7V77KWP4rG/2VL/AWrRBt7K9ueu5Q==
Received: from DM3PR08CA0019.namprd08.prod.outlook.com (2603:10b6:0:52::29) by
 CY4PR12MB1637.namprd12.prod.outlook.com (2603:10b6:910:d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Tue, 30 Mar 2021 09:35:03 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::90) by DM3PR08CA0019.outlook.office365.com
 (2603:10b6:0:52::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:35:00 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/53] 4.9.264-rc1 review
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d636b0777db74ef59f2e824607851765@HQMAIL111.nvidia.com>
Date:   Tue, 30 Mar 2021 09:35:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae209aed-1594-4c0d-1862-08d8f35f172d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1637:
X-Microsoft-Antispam-PRVS: <CY4PR12MB16370D508DED7C401BEA59C6D97D9@CY4PR12MB1637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCosKKT9cUjxmf+1qMgd0IBuw0z8F9qe5Mv0cMYMuSGNJVzyZVFa1VCOyEhUH+GFYFVgg+AGN3p/HHPtwfEwVXYh7Q600DzTe7q5S9BdUxQFcBMKGw+hwTxaLVDU5+fhTjmGaiohluzh57Sa5JMdgcrGgYrvtCpxvkgd9Do+UVXhJ02mMSNKn9FX4OPe9jX1jrA6P9UVeRX5PqexXRJ/xne7yXMSvCfzFICvosyV5Wbcak3Z4SSAvwFN7BOTLI7RBh5DahFQtRKQ5/PVUs1p0SKThgeUqFekgGbx0ynxUZFw4B4ukapusmarXWgsBP1T4w8IugJoQSEDD0hZq4BLxlkddLJgQtA6EPN1Jwg7axtwLLpHh9TuYQenHclzyF4NyeYaaebF0BPnr1IRBq5h2lxhDde0s1Q9JYgIwlgQ4hEBkw2sAZ28D7BZLz0hZjQ0Jkd6Ozkk3kdhlV9JMSx8EtO4AwlWjjgVSRt13En2KDo4HuxqBbA+ed3ZZFvXR4loRnezgN6C2eAqlcC5+u8u6d68pjltrJpnob1jcxvTE1Abxn5qVpOHbhL58tbyqZK71TVaWydgU340quiZ9guam6tkbuGG3WMNRX3EYHMmKqJIbWyeR9qXSZC1Sx0uMWsBCH5lW0jSmdRaJ3wUgl6VjTZKU9wg4S6CgWjOyN4g3oYG0d2kpnSyk7NZQvWb/I6sVWPXADpzKDG8AEiIEu5eXc1eTYt/qXKw0qV5CExtBT8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(26005)(86362001)(186003)(24736004)(47076005)(70586007)(336012)(54906003)(966005)(70206006)(426003)(82310400003)(108616005)(2906002)(8676002)(4326008)(7416002)(36906005)(8936002)(5660300002)(316002)(356005)(36860700001)(478600001)(6916009)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:35:00.8129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae209aed-1594-4c0d-1862-08d8f35f172d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1637
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:57:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.264 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.264-rc1.gz
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
    32 tests:	32 pass, 0 fail

Linux version:	4.9.264-rc1-g3c2295cc6be3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
