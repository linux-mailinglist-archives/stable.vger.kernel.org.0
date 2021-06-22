Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87733AFEAD
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 10:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFVIGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 04:06:18 -0400
Received: from mail-bn8nam08on2078.outbound.protection.outlook.com ([40.107.100.78]:59392
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229807AbhFVIGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 04:06:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBJx2jeXmtSNhIqHObX3g2WnsiF1FEHPgJ/3fTR76nwvZZjso5i5giXe2VXUG4iuIZ49IHyyiadnjrBMLPxXllFsYXqmu9qno9LJLduRVSLwJJiYb2O0fXIY1p7GtZ16muhmriZB+MtNQclhN/yoVMx38wwKICEdmMC5R+fpU/j6CcfA2EOA+1k9l/uC4Rmfl2W2BWyb8aWcm7PYggAR2r9WWl/lrrTEIHsWXkkB+E19ofulL7Glw4ucMkohZiwug5lvS2rhobQ7WWJl5BCOfF8GfduvpfUyJXxgkIWiWvHuCxSxx1FucxOOThYHH5j+DJWnDyCI4rdB9LEoTd6OeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0pw2zMTVcNlP6ZVzO9avWwHlWWjyiCIn905bfhyzak=;
 b=U3gjkIsxGTOExrsj0TJl0KGiSrYpRhYlch/HnJfD+TqhB2u8hppM5R6EtIZBfPMrzRoynFtYEn5h316u5u0oY3v41V7rPUCIwHvlSxUR+UHFBv4JyVv7zY/+k+3ZeHr7T0cXdFEHDZw5ZZ8XAXJXgi2BmnS0mHt2moIeoHNGvs/Mxbae32C7sPF9drYDMUE8gb7v2E6jOTgwHcHjZtEe2NDGOcU2i+hM23iwxCZ8swfUjJJpmbs70KcjLu8vmk2D3eo3gKO9Rdx27EVBSmtxfxclQf7qwsBpgBHp4pTt4lSOTowuft1HxZsab6erdtY5jouM0KAqcgEQTVoTECcSBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0pw2zMTVcNlP6ZVzO9avWwHlWWjyiCIn905bfhyzak=;
 b=jnw/vzDnBrE3NVncpB/Ykff+TX2jGeE+YKKJQGxkr17k/OqdbRHCgiG8ozx0AYliODTHsBcniZsxMTBQLBXlVWFdemk1IkmG2YXECsnra0hfng9d78ghrRwM7JL9fdsVuOwDuzoCMPMhz+SFDBtqY5IgAwS6G30uSF9LdGjcRCOUISR51D+5iLzluzWVJxN+uTO/0v2Sw+1P9+8dL6AYVN3uwlV5gSX4cDSWjwtYrFQ+VLDEDb+7IyEV1DtfV9hD6XgxuhZPvZoJ/s5QD/3vpZBz9lkhMmQiz1LAWYUY5hL4BWL3t9ENcqkuQBkn2vVdyTxjw8FJM+jqd2hcKhPikg==
Received: from DS7PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:3b5::8) by
 MN2PR12MB3581.namprd12.prod.outlook.com (2603:10b6:208:c8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.16; Tue, 22 Jun 2021 08:04:00 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::8c) by DS7PR03CA0033.outlook.office365.com
 (2603:10b6:5:3b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend
 Transport; Tue, 22 Jun 2021 08:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 08:04:00 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Jun
 2021 08:03:59 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Jun 2021 01:03:59 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <215f188b08b74c15ae5978eb30069786@HQMAIL109.nvidia.com>
Date:   Tue, 22 Jun 2021 01:03:59 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb92da8f-3512-4e62-61bd-08d935544b64
X-MS-TrafficTypeDiagnostic: MN2PR12MB3581:
X-Microsoft-Antispam-PRVS: <MN2PR12MB35815CE251CEF2DE5A65339ED9099@MN2PR12MB3581.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4dLNgkDA9gyqx0HHh3Ivy++k6ISVFEFYc5pE1S+g0CZyw6tbJb8V5RU015Pb4A92yWKBjweouh4R46iZtjGJ011pI5cO8ZiceOe7Le9pcT6dlNqyJzVNanWaHGpsNYDRubK6MHDWuMXLrbK3WZ8QS9Nv7SeQPi2jp5FDie09b4tMGnUS5hETFpbvIopzh65JaPWaPteVpkfeRAHYNkv/R8AtW/ri9cuYBjb+Oo4Ni23oDwpG6Flnf9vII6gf0fhL2dsBX0FBcKVeiBXQ8Xev90jA5FFMWafi/SabAXCW4brkfRpZPHt9sEQTqzwtYCr+8KY1Xc451yn33OTfIJVHVSasDk2UsSjE/h8MQuIwxAzoJqCx3Pnp7b4cy86YSWXgIa724MSgBAi3H7ngTI4hdaE6bjrwVrb2zRcxyEJT3oAOKLsjxVEpO6xhWB/S+IbJfFyPJSnuTDWr2ZTjX0aAlFag+ed7D40Xb2EviCDklltuju8VmJXPdsVdf1f7ywxYFOGstgKzoe9RCca+AolerH4g6PhtEUYKjB+mWlu7wiMdit2GoI99rYUBrvnIy89jzO5WEtoZQvBPTSN4/85h7W4G3IkyvOTF7EvFZsaEFzwAhc5twz4BvhEfPVid0dU+wgGuHhOgAYRVj/w2eVaIAfqbJi/udKgF2Re67T+6G1TWEDAXUrcGg7mLXVXklp1/leDHfycxSfmTyQLxOud7Zm8kbFtNpTFljM9yasYDD/NpRpzQ3pKmIEp/aEJWZxLFVuOMo5a66som1N3B6M2WA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(8936002)(7636003)(356005)(8676002)(7416002)(36906005)(26005)(36860700001)(2906002)(6916009)(82740400003)(24736004)(186003)(316002)(108616005)(82310400003)(47076005)(86362001)(336012)(70586007)(54906003)(478600001)(966005)(426003)(4326008)(5660300002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 08:04:00.6881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb92da8f-3512-4e62-61bd-08d935544b64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3581
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 18:13:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.46-rc1.gz
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

Linux version:	5.10.46-rc1-gc00b84692b51
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
