Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD0378F22
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbhEJN2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:33 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:38881
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240999AbhEJMna (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:43:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZb6K45dr9KS12B6HtewSECkHum9KoKFKjbTyI2UPNxxRAZ2AJ4JYrr6OPMhfrK5phSCkHfgKtihCa68vIk+/2Mgs1AbMH+XJxaC1MlxOm/gWoQdw3jlQp2Cv1T2RdU05MOFNL9Y1KVYjf2YnpUQKWu1btlRwgu2zeCyJZRAvPd3oiVGhRtK7jwDOr9Z83K9CAFEXErkmYBIkrDKyzv5hrkRGaGix2dXtBQj+OkA67aB0FuqTJiF3e1lz4LzzC+WFxNOIHGzerKNAx3Y6TZ06Qlp2OLYsL0ZpgU19SLgiZcTbvJ2bbC5TNpWZnxPtuGdget7pI6IqxElwccRreKjKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17EjA2OnbOcrLlADnSIrZIv2UJs4nhIj4LPbPqTXuss=;
 b=fZd0656Dh2N8Z2dxRBrPIkYIAkte+apykC8TxpPOcwRgmH96xXy84vJkD8RVGUBX3KeVRzAp4+p5wKmkxNujcXrV8OTc1x4Ph7Mf00x5jkuDoLnlWJMfUcMCRiIL9dYiWGuFmPZ2uKrh/eSyJkaUpXyEdmhsxTFAPmV3xqG7xtObDCOoP0yItnbDrObPNHW6FH6qHNTnwg7JUSzIomOBWAVpWSAdh/7hv8pT563WUskIPatfmxQOXFPyYjzm6Ck+ovXbRqDbygioAxcf0z0ccCvuQg21LsVF7CcmYvAs1iim7JP6Ug/l77n4maUhyukgZoswbNCO4Q8nUj6U04HncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17EjA2OnbOcrLlADnSIrZIv2UJs4nhIj4LPbPqTXuss=;
 b=dFjpIVWmG2T7R0nI7nsfCvKwv+XD/PRvzUrRZvdcuDoyPGvt+aO+5IyMWZtFow3RVvpdyJhoonAO3ObWKXdtK/G3JlHayuSNArFQ8rdY2bA9/FOUwlXupfjIxpF2tuukdyP4+yc5rjysXjkisxur1kuIBDNhomGqTJdipGjV0x8D8GhgKhJlW0jbHKBpvgyCQek2jCPVkfU7NeqqE+KLYGz/4832Oemq91RqFAmMt137iuN3PxCsbYPZMOKriNkIdB3jvHntXF602QCNurMCPTeadTnWruR/uxHupp8Sm7JWX80bxzd3xul11c1Hzm9jjWHrUJ0a/NLHpZtWYdfEuA==
Received: from DS7PR03CA0240.namprd03.prod.outlook.com (2603:10b6:5:3ba::35)
 by MN2PR12MB3037.namprd12.prod.outlook.com (2603:10b6:208:c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Mon, 10 May
 2021 12:42:23 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::2d) by DS7PR03CA0240.outlook.office365.com
 (2603:10b6:5:3ba::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 10 May 2021 12:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:42:23 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 12:42:23 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 12:42:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 10 May 2021 12:42:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d0894ffb354344fc9a4775539d5e766f@HQMAIL111.nvidia.com>
Date:   Mon, 10 May 2021 12:42:22 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64ad840c-4535-4f2f-954b-08d913b10f57
X-MS-TrafficTypeDiagnostic: MN2PR12MB3037:
X-Microsoft-Antispam-PRVS: <MN2PR12MB303712E6547F121E20893DD4D9549@MN2PR12MB3037.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3n2jTZcSZ07zdBWcyACEB25meWodamcSGC/IrWGIgQLx/NDnhMU9K+DQQVcpuRaYr6cgUEOI8S7nQnPq3LyeJka5ijjqnIeWXsu9Pn7is9vieEzBtikTzG2lDMjAnAU9wYa4PR1vl26aNjQd3xBysJQunFO+quyerNabC8jpX45n7qyzwJ3pCtvA6e0GO3Oy5U4jTAXkjxNGh2pFKAS+jDQIfnJWhEFlHNG67/KpBWSFoVWVC/HKIrv8RAkwwqll5B48m6MFkFlEFRoySQi0uXZ0YQ5pu9xHZ1vDSxPxvHTspIQafSvkv50Tq9oA/P1ph6s1jMsfVDG6iOPJ1PyslR2qxuCgDv2bz5WbMJ+v6h/Wkcolcax3TfdlbxiNTC8k0M95xy1cqJZ2JAadpfhvUGh8rVsSAVFjHwA2rmObktUnx2A4Rtzyk93UwTgRejCTVZaNMN0TyxaaPM0kiCQqXSUy3IfuayJB2Z9+kcRdwiLJG3Ym3WncZ0v2DRjS3AWZfXP2cUyFZRHIJ+g7RFNp/5kcswk6+A8OsaqV2J6DthZpDvxFAHPhzNXGk0gYQMA69jiR4sd64IZNLFm/5TJLUjifh7DUiNIOXyy3Ir4AQ2nNoN1Q+9ZGdv785a9g1O7nYYEpg8/4tlGj330ndujpjdWHYl4iz/OIthcMUcH2EIrX8PAh6DWGxjS/H6psLFIlh0ja5eK9omPEDiPKv1cc13RcvU7Nb0lkEyfbB+zztE0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(36840700001)(46966006)(6916009)(478600001)(966005)(26005)(8936002)(5660300002)(24736004)(108616005)(70206006)(70586007)(47076005)(2906002)(4326008)(86362001)(82310400003)(7416002)(82740400003)(7636003)(36860700001)(8676002)(356005)(54906003)(36906005)(426003)(186003)(336012)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:42:23.6163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ad840c-4535-4f2f-954b-08d913b10f57
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3037
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 12:18:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.118-rc1.gz
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

Linux version:	5.4.118-rc1-geb078a943f97
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
