Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85DA361D36
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhDPJWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:20 -0400
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:17857
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241734AbhDPJWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYJ/ui5n24ByfpmWC4mwBJZH6GGckgwhrpZGxnZx8p2q6Fhq3O7I9aiJc1l6DNYDxdous3+rsVtEkVcpfPmEzeEnzvmS7VJQ7ouM3AH3arfpMyG2MQSnpdVZ1zf4wis/jXnvgZkYgD0zK5CwtNqCkKH/QmJ/K+eM7dhX4kVwIzlxpw2j+GWuauagDaXhAdKICc+Tn1e3Jq2QPwMcNifsKBqeEaYy9ROlOuSnzRRHdh+21EMC9p4IX/Gu8eAqSX6KXt6iGECYDgUMHjkPt77PsBFDduWwoI4TQCyIj7qH5KtJN1fPL4L+1NW6wvgIw+JUf4apsgs0RtQtb5jDYBJxBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNXfjJycade9gIadtahbQpaUPh/iXnhWmbN3UYM05RE=;
 b=gtTKCTsGQwRcwG/PWXBOwCd36YpF8BplrVmwTm81GbHPRBd6hGAkAZPBybhO8//EwadRS63Rga8Et0Lr9paBbS16oLm8s5vQN/QlBfEjHJ60N+RAp8BHthTxTIvXFbqj9FrpRli1cVqOg/Yg5UVhtIG9bw5V4E2aJc7T26LYnfMGKepowaU0qsMa8y4fkYKFBxXMlXSvHYeqLJXdABpllaFsYwa1eJPO+oD8PaB70LI9qR172I0xunaWVdx6J0bhxcDj906ZcC44pXB5yIFSXWByUpGaHTw5VEbT3Eb1WF3jMEuGdBjPa1R5XVdBmCtxKoKoA2/tqbJFxmvYp2xesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNXfjJycade9gIadtahbQpaUPh/iXnhWmbN3UYM05RE=;
 b=E2x73L8jp0NA64G2MwR3MvtmYoGqLGv7UxbqgOphimnxiehhwh+rnTK6UQZoi1IAWVE3yOmfbDxlGkYsLpGqWMtGgaX5mrdozv4UZdgwyUfKBoPH3Q30gwykgDAL2ACb3R4C3J3bQ2FnGH1CRBxbPnsGhy1zh5CEE+z/u2K4I8JWoKewXmicjUqMO1jvqPZL0PIapPaU/dfNzXBYzJ7pAmzLuHwZja6o3s+y9ktraNmwyVVpuoFT0I8rDCPUI9Qw0LX4VIaHXK8x+UqB5rv5M8MU+N9nXu+fNE2Fq9WG/L7/E//c0r5yERrkwsN6FBLhP1qM+seV5TYu6xsSsfLiEg==
Received: from DM5PR13CA0069.namprd13.prod.outlook.com (2603:10b6:3:117::31)
 by CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:21:54 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::82) by DM5PR13CA0069.outlook.office365.com
 (2603:10b6:3:117::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:54 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:21:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/68] 4.14.231-rc1 review
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cb935fe2d66841bfbf54a36ba19d3307@HQMAIL111.nvidia.com>
Date:   Fri, 16 Apr 2021 09:21:54 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eda13c24-01f1-4ee0-52a8-08d900b91398
X-MS-TrafficTypeDiagnostic: CH2PR12MB4055:
X-Microsoft-Antispam-PRVS: <CH2PR12MB40553C60ED5E01DAD85B8849D94C9@CH2PR12MB4055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0b3oZwCzs+fjOW/2algw++nFdfNrKm5cjIWAMA7lemHvvwfO2UcCgLQjuFacXlbzmsv653HHpBlMQkvr3ughWp3rHlChLyvbtqs7diTm7dydFN3LOKCMTSr0z9NelcMk5QChTnQX8IOtl0/Kw3WdM6wtzhKHDA44fH+jFgPB0+jGTMHV3o+52DzRp79DH52qQ5oI250XjCkDltF+gQIl5c6e3JjcCpn5k7gE3qnsU3oON4+Gm/d7hLP4WdoP/qZ8SF9YM9QL6+ClU5yquaeiRNdr+GI2j8ejF6GeIu7m8eFTmrBdfJigPYVv5wtK3E/QpSHRVd8kSGp+Dgle1cjppLDIu99v92iV9rYD9c2l3FvJdxrUshKnHpf/loTgx3eTwq4n74UBxDeXy06YrCzm18gOc6/NQRvMZDmL/IVF2QTm9MqgvuiI3yJHwj/b/7HpBeC7KCxsJA6lacVDkFg0JUJrpmZQvZdCRB9yzuKuzVhT4KdswwbqAI/ct7bYbOQv5HBsmin6nNPQaljKpFMXbkeBg2AsfUTk136lf7b08PkCiu21eubl5O5I+R4EDg+tH8ye+rJop3FVl/ADf7PRGZBBzTkcTwpxRABxVUo3f6oMMysnDUfgk2G0YBl7/28LNvgDcI3V0N9NeOgmrZnGgozJrUWGf3+pFhzxkAMCQP9XRcjEIeHyBLOpiRO8EvXpQjhIr713VLGlyKKG0zwEyh6vLyo8bYMrJfyhUxSKDc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(46966006)(36840700001)(8676002)(8936002)(966005)(478600001)(36860700001)(47076005)(4326008)(70586007)(108616005)(70206006)(7416002)(426003)(316002)(86362001)(54906003)(356005)(36906005)(7636003)(26005)(2906002)(6916009)(82310400003)(336012)(186003)(82740400003)(5660300002)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:54.6245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eda13c24-01f1-4ee0-52a8-08d900b91398
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:46:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.231 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.231-rc1.gz
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

Linux version:	4.14.231-rc1-g520c87617485
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
