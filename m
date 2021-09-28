Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6641A936
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbhI1HCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:02:00 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:59105
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239024AbhI1HB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:01:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os1noyRMLZl+6lcqFTxODfpqxBVBfqHK2XcWgYEEjwmPtX+UXpKFyOYU34LRuQ2Vn5OFMe2wnSn6wYI3mVS23MGlXgwuUPjWpnrHcb72YTJkctaukf001ghHXY99NkhdJ0AV4qxgZ2+e85RB87n6TlhcaGrmUyPd7S6avniG5U1QXyBzPGMXutQbCMWTHSXJLwwqyjXh/uQWEbbo+eO2W1NeAvpgOP5HbTz5aAZXXdnAkKbxQf+IjEr6b9xek2dHJaD0fifkbysDOpGesQriou7pOoOIqvbwWMQQAHx+dTeMMctHux6+DQwjLC77LxxC7HFh+yob5whqRLRV710Bgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F2tS03S56o3C7LMfwU2neMBk1A2z1HuiAAo+pgguDR0=;
 b=BdP6eme3Y+N1NCirUPWCoIj0RVShKCkR6UFkcT0L3HGTgE35aXtNARMNKUYYXgfeXOqHjSch5LqZFGM3lAdR25mfYynzSyVFgkGFQGKZ7hM2nQlPIkHJtRIJXbn/XxP0Uf4X/SLXoBJlDuWL8NyTuxtYqwGOlE03jOvsgYgfAjmmF/fpZ3/vlMN+FAFLyhU9oZUikyOo7uIh5kKL+i6AtdRg/ewyUoUiCBEhNwzS+uFbZqE7HGPhMDJ84Oxv0p88RiVKlKNJEepNJSaFlBnX8igreBhGbINwmuiFb3Ypa4AFhNYt6ZRs4iYEcWDRc8nB3B2lUMlEc9bRKTrf7cdHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2tS03S56o3C7LMfwU2neMBk1A2z1HuiAAo+pgguDR0=;
 b=hBH21lzPA9371ED/GvkekOe4frlqHtMazi+7Hqn+ptDSAFKu5HBcFxsANMTsbW+ndV6sKieCxw4ElUMTZ/ckLaw5AGwn/Q9nQi0QXpSreP97EuJly4b46KHqs/RWCbBRlkq+0r3W700juVoiQHgx7zyZ0gFmxL4BqHEHST3w/X/NSmsw1uNn0J3OPE1BxasfTW9viQNVWa/XHTjwZGZoBAuoL3FiXlY+XZSE6etnRRNVF8bPiizajTtwbtXs4uXkereD88Qn3L6B8gxEP0D3RhL5MSky1yWolqCAWi0P+sW21a4LJfIM2ZW6fKiSiodwRjBoLwJq1gsvlKq9czb8xw==
Received: from BN0PR08CA0005.namprd08.prod.outlook.com (2603:10b6:408:142::20)
 by BYAPR12MB3046.namprd12.prod.outlook.com (2603:10b6:a03:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 07:00:18 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::8f) by BN0PR08CA0005.outlook.office365.com
 (2603:10b6:408:142::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 07:00:17 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 07:00:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/162] 5.14.9-rc1 review
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <831ee1412b184d82963eea0980b6a657@HQMAIL107.nvidia.com>
Date:   Tue, 28 Sep 2021 07:00:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3a5567d-ed60-407a-6410-08d9824da114
X-MS-TrafficTypeDiagnostic: BYAPR12MB3046:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3046843B3A1EE975376090C2D9A89@BYAPR12MB3046.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l727aRWxo+0vOgKb+EwAdPf17oCcfPNE2FfN6GWoRvnGjxlJcOhlCcm0UYcjaUDvPPbL2itimX6Sytn/o0cGT7HO+y7wLepb7nEdZxRLXbXKOP/4rg/nLDVgI+95eliGuEXG4ycXVVrJwYFpEiesnIzPnjZbW0K8UZjY4tELP//lqGeyxPeAduXe7vx1D8uxLc1bJycj2xRrUSlm08bnm4zyWeOUIJC1HcyD4EC0R1x64ZDJr1DhMETwoi27OWM146hrKQKvDCyOSlBnSh25NT6h+QyWMnMTtcvlvC3Z3EOSt3NkNBCrZAzMpopV3h0YFkAotq5XVQMeMK1ZhaAe5KIZsNOSGSfp8qnOrjc1arBYMi58ZHjn+sTUGP8EQIDPOwRveCFUiJU1idCCJZFlfx0onKA/qWE89kFfx6MZj5nOFXna0AcBKaABYT6gSkes6YsWrClEVRT6VVZHxD03ANv1RkDlCDCe3CmSW9Gifevg5q4AfA5YiuWMnDpxRdHeQqUqVt2JcZMfrlXk3kfMvooQ9nK2TRGnj5/0Qjgk8xjqDyUdH1jb7P8ZVj5xZIPOLogr3tACWzROMU6ua5Mh+dSA1Xpc/d9HEiCAblT57VpdWiaSD+p7B0xZN0yrjSsEte0MYq+T6smF1YhJoLeFuwXuKQmHYjmZwobfXSHKFQHRjPMKWkRpgo38fM1oP2XmeqqvVRc6S++HAwHye7pzxJu5lrMnfu2KR8UxxXTOzKQVZXldirmlBEN9EZ2bDe1GVK1+tAcnD2Ms35rulOKB69PNSCBf0DYSrSOq4pO6UIw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(108616005)(7416002)(5660300002)(8936002)(6916009)(426003)(24736004)(54906003)(70206006)(336012)(70586007)(316002)(47076005)(86362001)(36860700001)(186003)(4326008)(508600001)(966005)(26005)(2906002)(82310400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 07:00:17.4537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a5567d-ed60-407a-6410-08d9824da114
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3046
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Sep 2021 19:00:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.9-rc1-ga7a751350fb9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
