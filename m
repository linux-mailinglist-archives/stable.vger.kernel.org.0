Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3934C3CF6F7
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhGTIyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:54:40 -0400
Received: from mail-bn8nam08on2068.outbound.protection.outlook.com ([40.107.100.68]:61921
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235596AbhGTIww (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:52:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuCyr2hOV0ZoRbJPI08hIHaP8iIkvJ60CyAjS/FYI1ku87bYGB8kMV1sMrJLGZivs6hJuuWMY3gqHDfoKt5YQUVRzuPR9q63e3HcZADzxTeMIvb+bvDwH68vk9/gfcglNYv7R7RUDF282OPxfmXLf8n8wtC2OiY15vI/3f4gat/ZtBuIRZXRTMuueITkhO+zVv2wzMk3C7rzT3Z1BCrI0x6Th28CcilHucIOX8sv4Y0NcNyLmpMwZdupE49GqaFZloKMsCE+9pGYtwTKO/fJ9FWI9N3jt6GhOc4NF1X9xVp0BL9EXPB4pTaNFYA2FKNh9/BAO/Lsvywv/ma1NdJpsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwKbKWm0QPwzVt9n7TiFV7lPAx/jK03s7u2P8XksiWg=;
 b=jFRf+ZkwriugZIcVQJdU9TuZdf98sAln+9htgA31Ehn7ECxS1VsrXYy/grVdCUJYW82vsh15XcmhmgSR24HdvzXOoaE3ZATB+3/A2Tkws3BKetFlxikl4u3qD/XHmO/7Ml0TZjv72UMoqxox7VqQwV1n54xBadoi+oSCBRixtZ5RJ6siXx8jhsIufjmRPYBYL4qqNqk9Bf2P2D5zWlx8fdMIW31yn6w/a0OnjUqnjchzE+ttOJ8FZz77qDgbzZDo2gY4MukJpD++DK2vMus72ZUvOIUkegDhQe0VWw0R++qWXL/gzb6EvV8iyYezy3qoAmQ8Tz+KiE0Q81HfEZYAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwKbKWm0QPwzVt9n7TiFV7lPAx/jK03s7u2P8XksiWg=;
 b=KJ5FfAZQ3ygMtmZUUVe5dh9DPWbycYMlxkcNBQiAPcXzNFa0uDOlYB+KuYQFUxTR2MBEIYS+Nc+oEkVD34PFGIteinqoSRt4COcYZA7nRRen6qg9H9eKjNAtcqy2Ut4m8Da51DbwmoAwUXKiK90LLh1mpEUWoMu+LvrmvRbOo59keLoIOm5po/aedZv1BIb0NSfLge3BaUf0L46ovoO+yywX+ELgo0/c2IuGk1U/HtT/7YRbngrDZ+KSFkajlEPmx4Z3A6KjNXtykvHM4jkg7rsVAKQnKcU/PuZfMD718V9VY41vTL4losX2pNMbyyvj7d+5EZO9MNcqxLR14GLPNQ==
Received: from BN0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:e6::9)
 by DM4PR12MB5326.namprd12.prod.outlook.com (2603:10b6:5:39f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:33:29 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::76) by BN0PR03CA0004.outlook.office365.com
 (2603:10b6:408:e6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:33:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:33:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:33:28 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 02:33:28 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/245] 4.9.276-rc1 review
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ab41e60dc6944d9dab314edfc3de1855@HQMAIL109.nvidia.com>
Date:   Tue, 20 Jul 2021 02:33:28 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37265704-cdab-4b8a-46fe-08d94b616e7f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5326:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53260325AB6DF04891D44016D9E29@DM4PR12MB5326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RgUf01CdN+xM8WaPUvT8CFL2+Icnf0ttBxslwWL8F2fiQWUp09TWdok8OQhd4lNMXd9g2YS53Id8PpOkICfxn3Q2iJslotyMq5qFwwnfL4sH+f5w2BJI+tOotf1R3BnGEZkGjQgsT5Gn9wB4dJULugey7ZS02v1ARAfvHz/d12d8dDHktINoyEsyJOr1dlAjXwYgZr9dTGvwCbIvZH0Asm0NANUESMl70ToxwkBFgBPNccGxfz8m1Hstk+tTVNIQpum40RcQRYNB5+eu7oXjy47TkVnPPcgHd7eQLoI4Ey91dby6OKxEHbICmdzLY9j9sb6YBCmiwZyMIzo4pFEFIiSpxp07dv9s7zQPfX7lrnCg044dmRlT/DEZnW3yK2R6s974r5kspl1UhwiSLLLdiYp7jkDkoFk3Xa2r88/yr6BlhthWTIqxkGAbY+dAXlpnl9sJOdWxUiNfgyNQrgv1/2VenXjL8O/e8ofM1RFM1OzagQ0rBcH/faFZ4DDu8swhM29EExRqOA2wX4V4JaYtc8d/PJUbMurICxl2vVihVE+CQwoo38fL1Me6rjCWzVHnsAhYK22DTCh+10c+B0VB85tLnC6wxe7QENiCQz4Z1r4MoxDYnmvPc8Y0iDEn+owCG4D7EjyzMr5bzL0uuHoYtux6tiTyzWzY3nkPeEUeSckBmeU2PSqzrE/mre0/syhqU4ojwSfZgyIzoUSJNaUYGw6GuEWzmJInZ5+Vv/lpTJ/7oKq5nFF3KEWlMpv+Pf9PWcIKugbYOlu3hbzbNXn7V1D2blAJI13nU32e+bgp/04=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(26005)(70586007)(36906005)(54906003)(86362001)(8676002)(316002)(47076005)(36860700001)(70206006)(6916009)(966005)(2906002)(5660300002)(478600001)(4326008)(82740400003)(186003)(7416002)(8936002)(82310400003)(426003)(336012)(24736004)(356005)(7636003)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:33:28.5782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37265704-cdab-4b8a-46fe-08d94b616e7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5326
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 16:49:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.276 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.276-rc1-g04afcb7e33f5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
