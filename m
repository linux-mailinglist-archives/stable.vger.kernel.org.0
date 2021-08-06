Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6B33E2C97
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhHFOdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:23 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:58849
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239174AbhHFOdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWeHkTeYcM6Fx52oqq/+bENjn3VQBgtic7poX/nQwHdYzLcjXEPyVYmAxdY36L/ZOQZuNaaCUgbedkaTSVxqPlY8fS4jZwN4f+6/NDxQCYGHQzNBft58IGYQjjfVQmARr0r1gyBB4MSGumok+ywROK8riYlXDDBWsDUdCiT72Wy77utrvpKT+GvVfC75Ry4mgZnpb5hs0CZHkDK5Elz/G+nNuL1FIdMZsyk+FRdxvV7m5hHYCBnTHxZodlCtN8xQstK7nWay9tad2yeJgZeGrPUYuF+aFn8RRBblfxoU6J8XuYSfg1H8Oqha63IXei0fKs2mx8+TahJ8uxe8/I3NMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkTZR/2ENK/WpXnBpUlTZlJWOuGDRfxMU/dfZN4XTz0=;
 b=P1tXizw6C8XI1pPEpbJQOZnt3I5XOT2T9lO9M+v4sr4NnwGTICc2yCFjoLRpfPLcmo9A2L+fnHBCzCiEhXTtDJ6keuxg2QRWjfpq2U+A9ZDNx2WcdvQQkniD/5zZlDrDI9mJH72gdluZwcUTFa9ucog+G12xFTOQ0y2HG3bjsFQV+bRvxUFJ+hcktlW2fMKedOyZJTtNh0gVmlgW94vHNu7o7+f0+16cjNpa7GeTRD3GrI7gPv6OpEeLZ5iqpfg3kk0VNaaSUUHc0WUGmmpN08Bi860EzbC6FfHPzKlir4CVJ5oHSQSc0AFbLbbhpjY9ObFdNbUz5Wev8gE3ye9PgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkTZR/2ENK/WpXnBpUlTZlJWOuGDRfxMU/dfZN4XTz0=;
 b=ElG3C24ABGki3DmTZAlhqVAUU/07+sVltckREBQfD+gdkJWVfxeFHFnDSihN2XWnEm6PWuNiAYaMTCEbF23zICLw2X8MTL8Us+gdIG/QsyP9OBIxgqJCntF1ycJj+WVAop6XjDQbNTgurV2yaPctxLKUmuNnOHEe/tcDJHTXgi33BCpyHGRbeWblBJa8S2HjlETee8c+I0czgp54z8AzLonBjZ2+kW5mUYGoNvOW0KgYFyUVEM4ce+DD7b75PX2PtCwkYVmNYRayrJ8FaUB2OxnWgAONbcBdDvsnK1GAd3MXwv3X+LcOo1OXYIIDTcv8OjPtYr+AYdV/y1uLaXTOLQ==
Received: from BN9P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::12)
 by MN2PR12MB3805.namprd12.prod.outlook.com (2603:10b6:208:15a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 14:33:05 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::cf) by BN9P223CA0007.outlook.office365.com
 (2603:10b6:408:10b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:04 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 07:33:02 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 07:33:02 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/11] 4.14.243-rc1 review
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
References: <20210806081110.511221879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4730da896b6e45aaa8c76fea6267a951@HQMAIL109.nvidia.com>
Date:   Fri, 6 Aug 2021 07:33:02 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a4452a4-1e3e-4343-200a-08d958e71a43
X-MS-TrafficTypeDiagnostic: MN2PR12MB3805:
X-Microsoft-Antispam-PRVS: <MN2PR12MB38057096456DE665F67150E6D9F39@MN2PR12MB3805.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vfHjwj1xxRJvpXxZgSDZLxEJ7qlLQXDNG9ObTO4oeuwaHPZVrFxe3TzEHCW5njPAylSSYKNJsIEcoBNKDFh2J9lIuvzquzMz86rUr7TOmsGkWncGfdSj2z9IcFb0+/1RbwqbYVuK70hD7gvThVyW01ha/+TsmAD0paZHRLyc4WxwUBcSj/EdD/2dPuDsTKn4ENfIBxKXAhIqXK3AJcuLFxV8D72BtwLHwQBLzXT9VcpYhjlTVpEfCRBRRQKtCJ8gsud1wcVOkXD0eVfwQIZeO3gHzzKskhP0mvHdBUUOinq0Cpk6H8m9VqXqaW9XLL0COMMO/+njgps6SQcTZ1puwyjdEXOFp9UJ/9S+JzZOnlSaUuAYKl1YejcT/ohToQabLk6HE1urea5SIyUZUoqEQg1fjK24DKfynx/gEfLGAuaktHODSGdHqa8m03coDfHbM72T0wWmBiuFEgsKGAwDIV8GK9x8Ar/M3WJnR7YkJbzQ/NubIB6XO1/OQqt6lQva0XW01XVA3W5IfPT4COVVwlR5HUMLGIeoiZGz+NXlErLpSG2ZTyyagk+BdPNhOkNvpNYNSAVGbBFpWjcaV7i2aSjSomDpuAcr/mhX8m36LFGpBGZcwzLVknSzC9Gj93UKoHtvMb0ZiiWZDFJ+7ZB45ouZ/FoH7jb6UL3YAV9EGGIaR9i7uE206o0gwfNcDjW7NL5yBBZ9zyoJeCzw7IBVCQ33i0noQvk+nn2IKT9AMX2OYtEsq2IG8KX99QeAajdY4Pl9jSoKVsHgdluIG5bsYZuoZQ6g0oOMDGfJl3ZVasc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(7636003)(7416002)(336012)(478600001)(47076005)(86362001)(82740400003)(36860700001)(426003)(70206006)(356005)(5660300002)(4326008)(82310400003)(8676002)(70586007)(966005)(2906002)(54906003)(6916009)(26005)(108616005)(24736004)(8936002)(186003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:04.8273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4452a4-1e3e-4343-200a-08d958e71a43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3805
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:14:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.243 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.243-rc1.gz
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

Linux version:	4.14.243-rc1-gd7decc4b25e5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
