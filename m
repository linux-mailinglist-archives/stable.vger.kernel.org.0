Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACF137EDA7
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387921AbhELUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:58 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:51433
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343705AbhELTqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:46:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajgloMZAGukMZ8CcatbabD2HDsvkHd5rnLyWkMNxv5j7ysDC3FZ4nE1gUzuUMM1Fl8n9+3NesCouGkEHdOQuiFz8PCWkBmrRgX5ClWKGYzKmLReA/RF3S+99arAtMvG8TQXT6u3+NSnGR0AmY/N6J8P5d+oE6KnaLG+pqcHiS+8FM+lBifGTzjBJVSV68sPAaDEzUNk3eUi5wtyYIADKDsMB0Aw8Ke2VF1nhcj+afyAC6ARjaEVCc84ckFXrp/1iY6dTd5zADwM3ggCn2RxSAMhy8s+1xy1wQNDjbC/KupyvO6DchlAP8hyEsrssriT1AXfhVHHSQ0k0Bkoexee2NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAcw5Qk13I6EXD3s6w7zhKaUUemOFlRSVA/0BCP7q/M=;
 b=axcE+dZylbmknyx6ep0+mhfjlDoOR2MJSUnJpaQO1q1ED8S1b3PsLd87S/v6is9lKGITnLa1NsYftupefwKds3Ho/rf38FIvi2aUbDlsnu9ZEuure7G3FtLs7zFGIMrMTG+oVVmXVcsmQfBW8Njl9dDR9YptIyWdY06el+lFgPbUK9ecF/F2gHKxknp61Qk6YmKnBQIde1ouUzX1ueF8nvABuwmwFNcJodMrzTE7EMiaQ79yYULC01t5xXBSOffVZDcEXDh3Fim083Gp11o7FeMkajhlzKdQeabZUrXHBFvrr6KKcyz4ocLGqedkylwqLi0QwMEGySayFfKzYSnqZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAcw5Qk13I6EXD3s6w7zhKaUUemOFlRSVA/0BCP7q/M=;
 b=Ln9kvo9Znrbe/W1qXlj3C3rt42HiRl92MCxQhKCMY/4ydCKcf3jY/w7xLblrUmd7BhxGVgFyV0nLSFALXvESJGIMi+6vVsa489miZ6QI3RTCjXawg++MqLMxDHen9EeFUrDTH9+8pVQ0eu+bNBnCwYZqXHZuT5sh0iPPpy7foxx1oCNwlWhreZiQ/QA0hD6tVV0bA2mLgUCHj8a30cASnFXDIvjbUE+Dp3jV7PyT+SQXe/KbuIX82y4H/qBYven4BC4ld6rot4uMfomGKv8sSliWPDlf+iuMKpuFVM7GxdlDYtITEH9jjTmmO7eS9K7wcCB41/8KjgnQIVNqleV91A==
Received: from BN6PR1201CA0002.namprd12.prod.outlook.com
 (2603:10b6:405:4c::12) by BL0PR12MB2562.namprd12.prod.outlook.com
 (2603:10b6:207:42::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31; Wed, 12 May
 2021 19:45:07 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::89) by BN6PR1201CA0002.outlook.office365.com
 (2603:10b6:405:4c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 19:45:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 19:45:07 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 19:45:06 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 19:45:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0700eff9e8a2456f9ea2fcb73135c2f7@HQMAIL101.nvidia.com>
Date:   Wed, 12 May 2021 19:45:06 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9358d61f-1a4f-49fb-4be3-08d9157e724a
X-MS-TrafficTypeDiagnostic: BL0PR12MB2562:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2562B77A5DAA2F3DBE7B3CF1D9529@BL0PR12MB2562.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: muT9rAsdAtis92cwh1nWTUf57AKjA2H3uLtqJfohsymHSjnTLTLzqF5fQM09V9HWN5RWciW6655rLzVrm8reKoJ+/9nLyRsiprwvOJthvqIkn77Pki2RAsp9NYSA+OsCGxToo3jMy6tvj6wwuvZ+cK2d4EQ9RvayGarHVzhpcuJI1jlDMN7UgoM9aLW12ZMs3y4Q/gN1/Ea8Hgssd1aB4rIjob7BhKYqVUgiEm/kD0hwALvion13P5PIXkbfKd89r8SBsZ0UyLbmUHNcPjmQAmkIE+jgOGjc5dIPYg3Q22iU9U1oU0TimTJWxPHLt6qIHfeoxk3BebFw1DOhmvdrluyCaIQj6ZelREb0N0WSagr3RAjNnniNEqpKtPLgUPLyj7YnEYIIxhenld+6+MBcUX/xkTYhgCHbrAFY1cWrvzESdQh7b/wFlVpMcHojkF2ztfuidcU/bE9KbLKGHSDr/4Hm/SAnGFgzBWUZfQOKsO4Evc2WATtzlEkwSgUWNROyRaNiu2eCmm9oDUDmZX/+/k5D6qVP1T5buwMVofFm69IaAZjtIFnslo+oIj0bKQYV2zerwvWZLnkZzjmxDWPmT8PfGGfasqgmod1WfBRUvryxHdQYw6e2gK0oaq6sGKdcm1PHoM+nbn9kf40JdEn3RYLnJGoc8mHP2z+B41R2PZjyf3Zm458FvLWcPM44CrcBf3H3nVnoAWn7lp2X6yuHLONMzNqAR9t9XToyMejU4GQ=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(426003)(336012)(498600001)(47076005)(356005)(86362001)(966005)(186003)(82310400003)(24736004)(4326008)(70586007)(70206006)(5660300002)(8676002)(8936002)(2906002)(7636003)(7416002)(26005)(108616005)(54906003)(36906005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 19:45:07.5301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9358d61f-1a4f-49fb-4be3-08d9157e724a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2562
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 16:46:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.119-rc1-g12be7a21d622
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
