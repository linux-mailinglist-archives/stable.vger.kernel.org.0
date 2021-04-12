Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2098E35C745
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbhDLNM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:12:58 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:20237
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241705AbhDLNM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 09:12:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDU3lQRfYkdQDZ63tOqyPd6hYtqFGmETxJt/A1N4Q8XB8gy1JSbWC15Ohnr2wUxP9YEHZR/MwxswYslO7im9RQJwvMU+fk+HofVCNcBnk8RMqIFCIZujXNFhqIs3fLq6hVCl2eHL/LYYja1nmSzzsGHRly6H3UCEDFDrO7fzW4+UW2Y/81Q3xWAq/5NM5oZaDuX7K4OuQsOV1pDrx3ovw2UXqrAdQJMwKcQYmnkgIkmLJePGnXzubf8moL3n+6tq0SQm075jjZwVLLYed6Ye2SFXX0+xFbpj0ZnjrW5AUihcpmF7iJFgCyMAxOpxw/4CEup2/GA8Y0YQlRJPuA5CHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWjdrakGADH4stFIf7P+1jNqBaUONnxv6DzkxvOkdG4=;
 b=GHMdR08uq99Nr34fQNhxqpU9nHMolDdyfWna1x0QmM9VQQOTqWNFDpLKQKOkKyFv0qoc5vcvG58b6VJd6ctenw38kCk/R/En7fU+sWwMGf+wlBNrux5Qx1uKZdBWuUJ9EtY64UyVTQKGDR+yt8dhcXEaaE84lVoqKTIz11KIZC/19YqhEqk9Ef+zgb8+wXn9mckM+ym+3pp+9tUauY/9uuKbPCNWVdMXWa5ILgEmipAo0byEI5odvmCiAVlRw308f3/5vyCN4lgeEs6cdfQoeCTxnMZhKceMptd6M8/ETNFqGwBDle8GbP+G6oNGSxPwibnTBwVCiozzqqXToAhcNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWjdrakGADH4stFIf7P+1jNqBaUONnxv6DzkxvOkdG4=;
 b=PACf2sG7aj8XRIbW+brsOwjbun5aosNNAYebsIXeMsZZ+CbQjCXhs6PLfdHH3ln6BcytS7fYbdzZVfQHAOOQD/7yn3i2hRe1zPYITfoMfyt1Y7koEj1xGIoVzZJy00KcDLgea18YUdWco4Np20ei2ytO6MRHLv4QDcYWTCd/c23lazax7MO+Ou6t9la/RlaNkGni8ylDmOrHgNxl/MnOPKHGZbUP+EqMx6rp9RZAN1BLxe66r/CbELFomkPpkHEibVFx9yfrELGLHP54ddyyhrk+6IYiLQnW11TyBI3sDbYS+ep7IR2A4YnKyO+FW/h1VGptdLkNvgx+LWd8fO4Iow==
Received: from BN6PR1101CA0002.namprd11.prod.outlook.com
 (2603:10b6:405:4a::12) by BN6PR12MB1506.namprd12.prod.outlook.com
 (2603:10b6:405:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 13:12:37 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::a3) by BN6PR1101CA0002.outlook.office365.com
 (2603:10b6:405:4a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 13:12:35 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 06:12:33 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7f765f07a9994c20900600a419386d37@HQMAIL107.nvidia.com>
Date:   Mon, 12 Apr 2021 13:12:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e9c3ddd-7037-40f9-532b-08d8fdb4a3fa
X-MS-TrafficTypeDiagnostic: BN6PR12MB1506:
X-Microsoft-Antispam-PRVS: <BN6PR12MB15066C64DC5C2C626DB3FECAD9709@BN6PR12MB1506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFfQOwn3sUeTdXOJA9WFPoeSjLPvgagOzZlX2oebtlraFpPY4p0q69pcQmzHKWLMKlZj/BS5pibN7CUClcAqf60kgzwPibahTzSm0DJQznMPCOY1cLCRC03L2BX0OkDDgWSP1UPFlAFe8sfyCqlRdraZYOxQ6M++pfQcvHXJipeD9tgnBU4mk01h0CuTgjcmVrCGHjmrOG79zAm4evi2c9S9NBastyN5R7+a+jywZa8T1hqaoSIExdrvlOssmGQhhounUA2dZ7qKIWAvE7zEaVuo8lVoSq2qFMxr7qWJeIWe217biOZrvkDr1pKNBtVoJbUnw5G9L7z05yufKrdyhbMguacjOPR4CCJrklnmesRTQvaJFbGPbWPBi02tRSMIf7ilB0OVRSACZxYZsKXgU1tVWm2NDpvs1u6VR+7A7p99mnolsmqa78GiXDoJdx3H4A4YnhfCYAtwauBDcr0z/E1LPAaJDk1kCmCpCUDUgVdCTpt4pqo9U5PTiKBiRtMkM9ceLC0IUDq4Cew1L50vUmTO+p7SKS9sp2EiEzhq0LsMhwWoENtH2WErFD+QP9GwqOwm70bRHaniiu8x5SVln3Iis1TmxB7rAw8obTT3KRD169Wz7Gg+r1Bb3jbq15n/L9Ky0Rk76uzWZuwNVXfHnf1HDwxpZ7/SwufyUSIN7BaI2Y80RXip8jI75hbxWoUAIdfMPzcN50i8HF3PQjtUOLHuP8gqjvCEaNXSM2KQR4Q=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(36840700001)(426003)(54906003)(7416002)(7636003)(26005)(316002)(336012)(36860700001)(478600001)(2906002)(5660300002)(70206006)(4326008)(82310400003)(6916009)(356005)(86362001)(24736004)(70586007)(8936002)(8676002)(186003)(47076005)(966005)(108616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 13:12:35.8128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9c3ddd-7037-40f9-532b-08d8fdb4a3fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1506
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 10:38:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.30-rc1-g8ac4b1deedaa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
