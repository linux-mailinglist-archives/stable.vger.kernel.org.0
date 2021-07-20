Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825323CF6F8
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhGTIyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:54:40 -0400
Received: from mail-bn8nam08on2050.outbound.protection.outlook.com ([40.107.100.50]:57185
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235524AbhGTIwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:52:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zk/ZSfPxB8xN5h8gF4JJ7I+iIQ/khEiJ/4XdjX+DVjOpNxA4lh0X6THWEUUR+7uwfyfZUQLrQCBBhURAaNk4sbpA+tGmFto9Vyi7Cin//qm9vKF8VlvLWYuNNM82IJIW+IM+DfqOI8p+SaO4Ci7kGXLFPGuyeX+63q8aO2BNTVsN1X/xtnHbrrfiM0ht+1MMpd+qbgAUnhTirtLny0VW07bm9oKf64IdG3lqEyEXFTeaTEWoDdumjTGeTpKcf1AwDUPgYrnxhCPRdTUEaoCi2d06ZA+z2ocTaMXVq6j542ouBtudJ0q1MeOXIg7QiiJjITOkc46m4DWYrxeS67K4sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvcLFGXHjhKZiUZm20jl/b0BSn/WRTjYHcW0asoO18I=;
 b=OSUKIB2TCyIekXj4biZ4LCh49GodlVFy0PDOOfkTcdOY03XNwc4k5a2uE3kI8OWGlCYVflXliVsNrDWKOgLZshuOSE62r696W4cFtmyFpwfkGRbdOnQsRO7pXiHu4MsypzMGeNfmQcNZLpn1RseJiqDNJKm8EVI03zvIQHV8WymG2N3g0+nnynaj5Sezxtcyoh07XxN8oj3vIMg9XvsuGCXLGlgiQn4G3oMZHGD//cxTKoIRn0mvAxpyqXJN4AYzYzcKWCasjRJ+wW3JlJ1ywG5ZXw2xDLxadrWxYhikUmFeVhBdPZRu2XVVdAkhAPKbmYwAaxTZyFvWhfAvhoihSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvcLFGXHjhKZiUZm20jl/b0BSn/WRTjYHcW0asoO18I=;
 b=ryvnagkSlOzzae4ySrZ7lxwX029mzvA8viOwlJtjNE8wlR95WUwEfj3s07GeHdvXFQtyymMn8g/MgLWsl6sLRNyVIqh5ey4AUv29ZnOGnEFlOc6d5SKEYcR5XpvLSX6rSoqDrdFkzAOA24d3zICK9VGxG8SKaSQs0JFZpxeeqUQiq4y0n8AWA+TS368SLgawpuDBi6qJtUDGWCYyXbSw1V6yYXdNgf1cPHpzrbz/g7OUdaxXz7hxBp3VyitvJmxTA+9SYnPAsMG7wvS6tel2f78I5wBdVoh6rvdShHvmgCvC+d+jpEzlJ1VhZzNiCvFNTblTR13e5mrsv+ymx9BMCA==
Received: from DM5PR19CA0018.namprd19.prod.outlook.com (2603:10b6:3:151::28)
 by SN6PR12MB2672.namprd12.prod.outlook.com (2603:10b6:805:6f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:33:28 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:151:cafe::16) by DM5PR19CA0018.outlook.office365.com
 (2603:10b6:3:151::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:33:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:33:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
References: <20210719184316.974243081@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2b909f921d4c41f2bf984976e2e54f97@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:33:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb0609af-f1b4-4bab-63e6-08d94b616e3a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2672:
X-Microsoft-Antispam-PRVS: <SN6PR12MB267248C79D40565388E37C87D9E29@SN6PR12MB2672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVIhPo5d63/Jnmn/GsyvVV+WeBvy0cJ71AUTBEVmvr+LfIaTrgXP0OPxFmPCKiZU0JqdrWgSBP6rHYbdfL/g1ewJqqceEPd4e8VXd7BXRtLyfV7DQ4jSRLNsqCBfemcWItIwT77a2b86op7Lo2rXHB9T4CY7N0pZPPVHMgskiHcglXQUW4XAfTlq3Jdeg2lnP8KiCAfACFMXQ5kKcx96g+91qCFzBf2ifZM7yj+ovVgD4V++u0ZOOVbwoY9QQXXpnldauaLLc8vcdxnpLmFJKt6Z1vc/QJoit61i4Ymj3tSNeesBrUDNT+npXLbUWSEDBjE3dFRcDi5pu3SHylKIeLZW3VPc7mWnXuH4dzpoPqRWrXaF2X5TwQ90Ckb2VNVGZhoO8z4Uq00DdmsJHwd4pGw0hXNNAKdj2IM0Kd4m/0EFAIWrMT9OMleBDKdihC1iat4t/wj8Wl16RR7MTowmid1GccaOcS0fjaW1oITBw9Y0NuZlktNlQDhLjNnftEwnG/MThv7TG6/x0Ihu2FI/mS7xGzKYp7sfxfV40z7p5ClB8NTDrVooZudaX0W9luiCkPmBLeGwH95p0v7b8sNhmKTvIsiOKNCSJ/j2qlUtyDj1tRfjtACeQtRIX4L0u0F9CqyTN4BNUB1GAvkdgO5T8osn+P+WDe7A50YWUz+gADx/ORIdekuY2AMH81gFNT7ro+CeFOTmwC76b+xCRmA9MX5Lrwmo6vPI0Q62kqjrdBpZvoN/21Rnylku5273msYfOUtX1OOfOKoV5XnYvNO23fIAt9J/qq3kL0SCVIFXt48=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(356005)(6916009)(26005)(186003)(82310400003)(82740400003)(86362001)(7636003)(47076005)(5660300002)(2906002)(36860700001)(108616005)(8936002)(8676002)(336012)(426003)(966005)(4326008)(36906005)(70206006)(70586007)(316002)(24736004)(478600001)(54906003)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:33:28.0838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0609af-f1b4-4bab-63e6-08d94b616e3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2672
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:45:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.134-rc2-g5b0c31d40d77
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
