Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884C03566A3
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbhDGIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:17 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:37726
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237437AbhDGIWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:22:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsJ4vSZInw/yZCGQrFpBsPRSTxWMZ+OoNRgoXcsN1DTWgVIS8jtNQk6yAsNXZ5mFMDNba5quXMGd/0w3Gl/KMqucKp29Dit0gUX/yqVFVCemMZEzM7vIEEOOHtiOmZcRwNemERoutVfLvWheZqdR0WYXIj+32aR/A1SMpiENkJCoi+k4fYCjR6dOkm4jBld0slNYYoOtgrHgwAaK0vVvG//P1nW9XsF8xgAE98+CQx4xJzE0PRYD7lq8B1yf5copPXrIzoY/ntyU02rkKm1d/n+2YOGhrs4bU6Q7MempgSDDUH6ph+Q74Ugq2kz69Jo9X0ACopwu2ZaFOpLEowVFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVD9LotFBCKG50a7p0XTiiwsyH5RlMqDbyZEsXIAYu4=;
 b=iGq/6/StSdvQP56fcgux00vQ29V89vXfLVZCorMM/QodjXIzVHo39bHOfblEBQ9RwKp/p+TIghZg46qoPL0/LzJfMTDBWsypYvkJimPBPVBdsfQJWE5cbVhOc3tpX04LRZChxbxb9EURiAsx2kCoeMAoQPNIBDE83R7OT4s1HPAIqnMgXMdsZm71hTsnluYKo8MD0tnMXq2ioDrOdPjPNtAB0ztsEFEbvs0g2dXydfdh9ZNN5hEq39cAfNBhvAyXQqIAS0Z/7y2CmWSCVKzQvP/fAGQy3Pg69EOW2Iv3QRwE0lynCtWfPANWZ7GfRMyYUu4zhdeLTQEOH1w78wXhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVD9LotFBCKG50a7p0XTiiwsyH5RlMqDbyZEsXIAYu4=;
 b=bzvr7pzkkSPt1favXdhQRxn4RuU77WxaIQungslx4hPcOAXpinqPj20bQ4KeuWYvJIUpIUlCyZGefpseaA1aySpNAdDhXMMfgK+xPhadRJhWo9z6Sk0c4p/JheTEsSByNAv7Otsf8bcjjAZJ3SIb4en55+4W6TCoqEhFVammGYtwGmQk6NA/5Y8XObkJ6urJa1z3KZbCJKTRw0++pPSmAxHlmjqIPZXQqo6sJtQFIFLhDvvnnYpDhgxG23lGkRcydvG+mm6PjMgjv5aO6nlrXrAhFYJdedFX9ThPuoP4EzGhz7QnuNs2dBRLa3tpB7ineE57g9ebecb4jquUPiT8CA==
Received: from BN9PR03CA0577.namprd03.prod.outlook.com (2603:10b6:408:10d::12)
 by CY4PR12MB1335.namprd12.prod.outlook.com (2603:10b6:903:37::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Wed, 7 Apr
 2021 08:21:50 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::42) by BN9PR03CA0577.outlook.office365.com
 (2603:10b6:408:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Wed, 7 Apr 2021 08:21:50 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:49 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:49 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9d26603c91264ce4921639affafb16ab@HQMAIL105.nvidia.com>
Date:   Wed, 7 Apr 2021 08:21:49 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f32aeb46-63c3-49de-d4f5-08d8f99e3173
X-MS-TrafficTypeDiagnostic: CY4PR12MB1335:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1335EA8D71C5B63D74AB637CD9759@CY4PR12MB1335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgGBhsgpi5OReQaSFqG8pYE1/3TG3gxc3liLZ2HF9cZU/dn1S7tNajAQRb44a3WEbYj11WXAnIauXbZHed6m/AW5E9NmWStX00sQUmniRnnITDYL7eqB9LRTCPuw0QKv5eV3l390KzdwOJFTHoV9hiYo8jb+ng1PilvoADwlMouTORIgQCluYj8hEOVUEg4gczc7Ew+tIRYKT4s9WITW+4UiYGo75P/bPVktHGDXIGcKU6GdJaZCJo6wBtUP2ykVpx6d48kgJB8b6L1bS81JrzLkl34MMTeuJOQc7fgmzDYCSO5cyRHKcxWmyzWX3vvbBnJNMS8XPVQDcuul4v2i7cRladLqQ/Mk177CwYjaL9mV2+K5kTrth0FzTNSB2XPCgM4XaHZ/QsShjvJuzGej+E23yQGOXQyc1oOVVJYziXOEESr12tsR5p1oosDjOp0Xs/MNslgEw5G3r1TSbT0qVIdJErGgL0aZ5i7/S0ZFoFikBcVbTOddJCHHFhX5EAHEh2VMpwUk6pvFAtf9b6tW36PHFoMskzVtCWIpDtRaZ2R4oxCfA98tOwNn+xmm1jk0qWNrZ4DIWs3KXvkQ3va0l/4jAeY+j5cCT+mMPs4Lf1D61bxRRHkYeZecy/SsDVuJN+EZZvt4oT5YHip7gmesfPU3Ola8yJ2fLUNqDetYNQJXKG7rXJijighU4J0TPxagUYvl4V20cxprjFOhG8J+OfYUaFyeekaiiTLG9FFZntY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(83380400001)(356005)(82740400003)(336012)(426003)(26005)(82310400003)(316002)(8936002)(7636003)(966005)(47076005)(36860700001)(54906003)(108616005)(2906002)(478600001)(8676002)(70206006)(36906005)(5660300002)(6916009)(7416002)(4326008)(186003)(86362001)(70586007)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:50.0949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f32aeb46-63c3-49de-d4f5-08d8f99e3173
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1335
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:53:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.110 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	58 pass, 1 fail

Linux version:	5.4.110-rc1-gc6f7c5a01d5a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
