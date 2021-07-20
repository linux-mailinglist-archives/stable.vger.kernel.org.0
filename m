Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120AE3CF6EE
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbhGTIwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:24 -0400
Received: from mail-sn1anam02on2083.outbound.protection.outlook.com ([40.107.96.83]:46278
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235595AbhGTIv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCT2UYGrSbjSx9+BfG57y1xe0Xhrtj4gwUe5jpc+dpP62uFuFuMQN0EwBlTFALA4+StynvcV3n0G6gs3Y3JxL54GJQEt/kg3Ebz306wbctUnT1fb/VZQiJ9SC5piJBgLgugXC/A2R42qdmgWNVaRPxhemzHG4Z2Y/RtUMrrOMDFA64xclc34fS/XrQxeC7b1hSpP2/IThdxAXEECjiTL5vUhRTOzbYUR/KRaUW1Zftati+h8Ax8FAoOoyEp7g+LK20Frf8SezPa/Q+LzcUOCvJ9FMSDHInE9lMik6HeWKn/UqR5j6hBJFt+TTXOmr9UAdqhJ0BD92kMM33s37zNcNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiFiA6KzYe8X94WZiibZOY/4uuoiI144nygHLBV49+0=;
 b=N4Xx84UlrVmvzSx73FABfMoFZ6e+hNXVEldZnH1N30MxNDLYGefDMcUz1b+MWa7xEeHLaVHZyNnH19M5BsDjEoiLeprz/4F/9lgLuHukURP2iee0DdGty+qAMDW+a7L0NDjR5B6VfZP5DdK+7biLQhxdhSonrKwOPKYj3pmyJHhWAhJdNsH7Y/MsUA8muEGwWgKN98LY2F5g47+wopZQHpKdASIfY7iJ/H+7Hj4U2y7Pd2GZqMvec3c6GDZxNNjlxIT/Yx7xnV6eb5/XRc5ZzSWyPpvPVDqp2Jlgi6JcPs4PlXtBtq+3/kkKQU4/EWmt+gM0b2a88XA/oDF3X2dDCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiFiA6KzYe8X94WZiibZOY/4uuoiI144nygHLBV49+0=;
 b=Ar4IJS3o+kD7HlfxqXjZXnLo1C3C1Mxw1otYaIsZ//suS1ertfLe1QbEmxeqMcYXpqNmoshNR3nmVNMAW8dllzUAbxlMTHsWfDb9MLX2IrJo8MF0wYHtCl7BTX/Z5h8yVfiHRb0kj+nX9Tyu4NAPuzsDnJeUvBP8D0N3xrwW90aDIr97Ftg8sCyLz2ktpBlGaUs6Tm388BVy5ge4KEY0B1JI13RZH8m10AM9AgNmIInHOFvxQv8DhrohgCeHtiiD8LqqX8jzzRSFefhlqvdvzhzfq84D5z9X+d0bHZ6ZafXWbwEalQ/G6gQShLlQawe2Iey14hioFykg0Qia8ZGRQA==
Received: from BN6PR22CA0047.namprd22.prod.outlook.com (2603:10b6:404:37::33)
 by MWHPR1201MB2477.namprd12.prod.outlook.com (2603:10b6:300:e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Tue, 20 Jul
 2021 09:32:32 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::2c) by BN6PR22CA0047.outlook.office365.com
 (2603:10b6:404:37::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:31 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/188] 4.4.276-rc1 review
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <89494e20c2f149fd854d48de2c5643f4@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:31 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f76f96bc-803b-478f-bcd2-08d94b614d07
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2477:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB24778ACBF9D17BD62029A907D9E29@MWHPR1201MB2477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ALV3v5jSSjITFV+iNife5pQtnyMeLCXY6cG9Cuej41LU+aDwqGn7mawY5+4m4w6wQyOKnkSyiOl8C9HwlYSc0BBcEWcuwGcjj/wVsgU+4JGIfyupsR3bet+WpuVhYPVWVnTcqgvmF7ii6GsmzmLY/WXUHdVLyXKXpmbM4pXe2FzY9tAPk8Ssyv94MpveVRwQSYUooRt8OSs6r62esCWxSyX89LHVlmjIGCqyBxGgBaZ9BhuKrl+/OiqMYsJdMpDsb2FQwqQMu5cL73jqBRk4O+Xbr1WB7bHq7WPTgW7xK9feVGR7tjaLTadW6dXxPLbOka74/xuA1cUgTDVItcfWR8R9nrJwO5bVpQEH5mgZwPjwyZVzQ+MhOYh5HIhAfcMh3XgkcWJnPQ7betstiA8Bv9Q6FxJZI3wnoWzyshbLiObt6QdOel3rx+5E2h9gffMKbsIlou3TEFMfUBn7GDEsLxshBNiYRrocGI+Inxv4XlUTyklXpOMPVFL94KNISGQ1YpTEJM0cbI9r+00SvsenORxz9o4jRHR/sCJG/zpCOWUBL4tPecmMGXWK3vn1oT+9cLzTv87AAFhrk7IV0SKgMXKTBxA4HeEYJ3mIBVII4DqoeeX3ypnMNRXzD9lSoMbVLkVVifKcYK+UuJ4PDEba64cBC0ZNsb46owhJMrN0HEm4ucU9tPC8PqdUGqvzdE8hzPvrH24CVgcXNmlR1JfZr5E1zlpO1AlUL92DzsoJunL9XjM60WAXdgg4QTl066Jnvq84x11wrFKqLX41jb2ACjH2LZ8hfcwcDkOn4CwM+8=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(108616005)(82740400003)(7636003)(8936002)(8676002)(24736004)(336012)(966005)(186003)(54906003)(70206006)(5660300002)(356005)(86362001)(26005)(316002)(36906005)(2906002)(7416002)(4326008)(6916009)(70586007)(47076005)(82310400003)(478600001)(426003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:32.4140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f76f96bc-803b-478f-bcd2-08d94b614d07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2477
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 16:49:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.276 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.276-rc1-gffa748a4e4ff
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
