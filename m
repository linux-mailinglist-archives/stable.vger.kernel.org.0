Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC43A6DC4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhFNR5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:32 -0400
Received: from mail-bn1nam07on2058.outbound.protection.outlook.com ([40.107.212.58]:10371
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234128AbhFNR5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+vD3X3hKlUSyVtKxTTnoOru3kTJQeSdOxirn1DemybInJ9xUVzaPDwGgFv3rvjTZLMmyTKAMHzQN18G5KcbP0BFfwPqoLbq2//+NLZZR6AVYHIwYkxDyVrgZ4dXqQUtsVWU5fHXr+/wSldZNDt8C0znJCQ1FWsWRmRnELmKRLKrnm42ByGbuPLla+tOosSsDWlyTPDQFzKQgIIpor8thfLk/bz/wRNQ2LIui7WVMLFS5Qad924QvBHvbE10ebHp2wJaVbO5BrnN7e1dZfRsP8IzJsYtmqgsZ5G7ewuKgKgGZJzJWaefYH3UPuBjlZoRUFQFrMurzlZZTrasVS/YeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KLXkM7ICT8vYtbFz52EWLZkRtDAISbhwplOm1kTk18=;
 b=ZYQoneG3VQR4t9tPP1uXJbgwVElQl7hRID4LFLFPSEPn5MEiedS0Cv3lOXnSsnw6YheeGqCT7UW/FFL4jC0iEIYdQF0j8s4TAgs2CrKPOcfoWqcQRzYrXuMJeJOe8w6G1CA2L4ZKmW29uYZv49gmlWpX3UASl00pmIFt0GDNEGlS7pC19h11aeKvE7Gd9Vo/glgLi8BZ57fgYcwQ5e6v2RcM7ewW25ZYQ19zlR361OBSVDJ36m0gLt4LCHnpOpKRomT/QK/9HNZ+hPXfRYxzvNTwtgGikvR8j56p7uFOHYRyeMw1J55Qkr+Ic8Jw+i2S8TLvNj39mb4eswj6h6ckIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KLXkM7ICT8vYtbFz52EWLZkRtDAISbhwplOm1kTk18=;
 b=beaIdAbAPoFRbLs26B0CbNYvb4h3C6i/WTD97UYsBXdZP6zYKiGSOGGQiw6ESxtmgxMjjyk7XDR+jta+XEc8sO1tFHzSNVgcWzrl76tWJXjoZEkG3wDBL1Tb6wTYW2lokQX2p0C1I8H9u2lPfrwWf/IjnYL7ih2GIUFWPliyD7trC0dIgnhvMOlH+fRcmCIA0eqrUCzZ6Okhg+KzVjJRUZBwC9ZEpoGP4CVPmNkHyRsgDw6MleWzx+X9WINEYtnnfSYaJCHBvEHgLnSrCJ8hp2zXXkFRNRh0dfIwRT4bL1q3EvpGVqtHj5TyeU/n0fnKnY4Fl+OBUouYmurmxwr8ug==
Received: from DM5PR21CA0043.namprd21.prod.outlook.com (2603:10b6:3:ed::29) by
 BL0PR12MB4674.namprd12.prod.outlook.com (2603:10b6:207:38::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Mon, 14 Jun 2021 17:55:26 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::85) by DM5PR21CA0043.outlook.office365.com
 (2603:10b6:3:ed::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.0 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:25 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/67] 4.19.195-rc1 review
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6d5caa62a5864a8eb1a03ee68d9c7d5d@HQMAIL111.nvidia.com>
Date:   Mon, 14 Jun 2021 17:55:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3eaf286-4284-4eb3-35cd-08d92f5d96e7
X-MS-TrafficTypeDiagnostic: BL0PR12MB4674:
X-Microsoft-Antispam-PRVS: <BL0PR12MB46749FACCD8DDCA4E4B36458D9319@BL0PR12MB4674.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhifEwQcsZTOM3930xpzGiOgnbqiIf9JaTpy0EBsplPdHPm3ptP5SEahTb/rVfiiZme1fXari3ueRtHd6RuI5LrSSktExB1y97tOV/cVOuR6y4cq8qXCJIIMjS5j+zF4TA5NJEXIiuTnQKkTkqUHEV/mZ1ycf4H9oKtZUMJcRr7d4uDSK5XfyM+i3lEI+/04YilkGVR3W/TMULk6eYhJshGvhbJ9YZa1ddwMxtNKECS9+k1g0RdX/vYOSk2EpXuXVB2dzWCrdF7r9SnPSPrsv+o6zw8tzWctLipXeRtxGWATGSEelffXwFOWAXSoTexGojmmzEM3x7abtFZboRT0qBa4VZWk3yRCD4K50jyavwtAfq8yCeex2b2UAm5peF8Qtmc/+GCOb93aLv898To5cWU6TG13HpvnoZ0Pxhw3gcU/wsCC2JsRuA/S72pUHCZyAxDD+2gletJwyZYbS+ANAc4MiOuvYVFiKhd6fEMeuD8/lNyfTDFEnvXpoKi94I9F8sRFRVNo8gP2fziixmRUBXHIm76AQpssc4R+bxIVd71EcPodFH3LP7RCWu25q2lnlsV7+5Grvl9Ei/ciPPVjrBm6UNDh8K/7FvnoJu407cFrmf6bL8a/TdLD+OEYE2MXc+uc9b/Hg/4z2HQvzgyOL1nAUec/0WZTk4ipUPJfhfC8yCpFLqTCcTlYrDaH9hU8wFFsEG14bROfuUfwcXEqyArNigugwajSwsMPQyA5oRRshHHe9SMBBBnxkp23lbEAyDYqb/f/WB3xtvnlYkIdSw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(316002)(7416002)(26005)(82740400003)(36860700001)(7636003)(82310400003)(186003)(4326008)(54906003)(8676002)(356005)(426003)(2906002)(36906005)(478600001)(8936002)(966005)(5660300002)(336012)(86362001)(108616005)(24736004)(47076005)(70206006)(70586007)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:25.8665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3eaf286-4284-4eb3-35cd-08d92f5d96e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4674
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.195 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.195-rc1-g3c1f7bd17074
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
