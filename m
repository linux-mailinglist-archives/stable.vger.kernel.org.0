Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559833DF0BC
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhHCOu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:27 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:38080
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236697AbhHCOu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFh3Q8koFzxrXGpj+DxR6GXsw84UFGjEqrKM5BT7Xwmt1zFZTE3van87ieGzlv+cDTD/bJEVUsBmRaZ0X/MoW4zaMANJ0hHsRBsk2F4Kz7TXmw44wQPRH3s8twuSOOz+7XdmumwPfCZoh4F4IhArfal5Ck6GsbhAFu0VTeESBw0Ep1Z956C16sNhGfFWSF0tZgwFlL5rVy2CBNwAExH+1mZ2yTovTDo+hkJAe39DeRblGh2mVbRGRbQ5lK4SpCson0SfgdGtLbriW4dofzz2/R2vH7kgn6YI/4OI+shPFjAJ2a6F7RCouL2jgc8DOwrDrI97WuLMNOc/Q3BQMmH8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BelhX9C2nN5UzuXyU7AAgfIohLUT4tXLQ65Nd6nGtBI=;
 b=ZQXzXwIi1HKodjnmX9z9D8grwvWlnrMB8pHIsRSV6mC9DwcmmjRlG5dmPYb3lL/ErnkOT9xA4BwVAOc4u+pDo35ofE0poPdS1PZ689mAbT8OkuzBQLL+S+TgFVrKpkb7ChddagVX4UAU7A1oA3Jd4EkKW8PBG0F5UaD3vdgBGu9NACX8kbeqQO1rRy53wgYyROMe1tTPR1rIo71ayw4rOErFr6diDaO9L0ImDkbKqO3ZAtINHqqBGHMFBik4f+8C73buuCZ3tu8GYk3Ja8XkpeHDrX75GGfRy8ded/lon+y2OdRViJA/4D1uoo+KsJc0HTIAeNucKa0oTnA0xsNddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BelhX9C2nN5UzuXyU7AAgfIohLUT4tXLQ65Nd6nGtBI=;
 b=Lmw13Hk0d4cfYN9QXCmZw0z1NN5e0pLj1JTVtx2Rwbqy5dez0Mw1UeOzj6vMfk1e+rTirCDwXlrp/tIQ6L5Pv+4WWkDa0BXmQJ59oR3x7g+hO9CarlxUbs3/e+FwMp1sqcPDBFB53PLsJR0X6Eumrvca6jINAJGgqi5AAK11ZX7vizht8j0HILh0cexCazVVfd4PTHlaNmhaX4SaqboPMy3E3OzzlL1h9YqJeVT9IhuHko8kmA273sL9WOhD559kFq4zKWQ3q9aJU2S6s9nNchpYXflkGO9gP/2rnePq1ml1TG0Obn6yhTGwgGVP1pxbeaPg4FxmIbu3tl556omM2w==
Received: from MWHPR22CA0067.namprd22.prod.outlook.com (2603:10b6:300:12a::29)
 by BN6PR12MB1586.namprd12.prod.outlook.com (2603:10b6:405:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 14:50:13 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::96) by MWHPR22CA0067.outlook.office365.com
 (2603:10b6:300:12a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:12 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 07:50:12 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/26] 4.4.278-rc1 review
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <af1b7bc540534a618b1e22692d56de20@HQMAIL107.nvidia.com>
Date:   Tue, 3 Aug 2021 14:50:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c8eedef-e9cf-42af-2c38-08d9568dffa7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1586:
X-Microsoft-Antispam-PRVS: <BN6PR12MB158659A525468BF3654227FFD9F09@BN6PR12MB1586.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUaUzCbrasL4H73cTq4YhzCUbj2VfcczDUSm0vI8X3JsQK/KXagoRqnH3XfAYDrE6r+c/6njO8EqlgUB5/h3xZNjT5v8EjSSphzPNw/OxvPiHGKFXSfNIc46BgWg0eXHWFb3J50/50OsIG2Y3QOZ4pZgofNGuafXxbY+fWnt9TxyvjoErgb5tAQmEntQFPralj6V6PznAdmlxsIXHYuOK5j68ncZBKKA+Ogl0GTP8y536rnArR0YkurEkcAQVNPJtcqH/al1LYB2z6IxlczoA/XiUEsk9szbZj3AF8XG6Xd6ludtJXJRAQl4oPyNYrK1lJTfFlx1tlJzghV463s92e/ZYAjK3SxWSY44boZZK7fSY0Q7YbS3R5t3HFJLWF6ga09ZHShA+AzcpmVl5mNiy/5E4aeAtT8vTgHWIahhKMOukqynRXcc2KwZcDNfgirA2MrhyyCFx7T+ihQ/H2MU7gsh/G0VkybubnzUt3RSv+W4VdFCwNZocLAjCqr+E5iQ5AzkUrz+eeOn93CP1zPVFM2wgiN48yXGpPYMEkTo48pOWEpKVpGmGDU2wFkfDFbn+nbN8jfLTPAnd/NofcrZqf1eahUZgVhc4H7ZL+9uf2HX6NSIUXnpf0wcFYj/t56eQq3xw6ZJmIO4XcmttjB8kE1r6eqYHFjkycIwOV/1RVY2rUnKsoq4DKzgvBkJv/SNhZGnEeiRGgLgq8FRO3OvvWdwODr8odDVXj79o8hrwEEIEFWG0YW/bHC/ckaQ1L9d85mIkAHw0W2Z2LT2+bobwc3m+T1im0lt1icxZwi0BGA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(46966006)(36840700001)(86362001)(336012)(47076005)(70206006)(108616005)(8676002)(24736004)(8936002)(186003)(70586007)(26005)(6916009)(82310400003)(36860700001)(5660300002)(2906002)(82740400003)(426003)(316002)(966005)(7416002)(7636003)(4326008)(356005)(54906003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:12.8189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8eedef-e9cf-42af-2c38-08d9568dffa7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1586
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.278 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.278-rc1.gz
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

Linux version:	4.4.278-rc1-g0de2c08236b3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
