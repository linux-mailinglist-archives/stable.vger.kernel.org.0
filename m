Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7052341A931
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbhI1HB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:01:59 -0400
Received: from mail-mw2nam08on2054.outbound.protection.outlook.com ([40.107.101.54]:56032
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239001AbhI1HB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC6451Jf1sEAn2kWQKUJ88DqoCjwchhuIwwI6SYna+PfxHdSkP+Z++rQSn0SrpqJlDhaMzf/A+8Cy2tMaefe+wlPYP/98lBqBqS8ovWdNfwHA+RB2wgF55xN4BoBkrtJqXxNHbW+JITfSKwN0/1qfTYczIdO/KXuqVCBihQlHp/PBjeE16Hz2AmSpDipvVivQUzA54oOPYRel4Wo6vwANqQA7/E1sd16Ahd1zLWdpFe3xa6Gn+gZNq2YFaEPGqWdQu+AB8fz1KvlPuFk0FyC6ciRPBsEAxviZcCkrNizCaVxg/5ZSJeTHQ8m8tCYWYylgVNbAXfZy86VXCuJocEo+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ldg24IH4qT4/SuZqxEdEWmIvKtl0PI1nryovOns03Xs=;
 b=JPVsCGl+iruvWMqT6DvcC8JQ1a8nFhrJKgG57xdxanEfCcxWWRLtQ+FhUwObflaAkSjrPJ+yU1YDe7QQdMnr6uo7tMQXMx4VfA9LJhYmJtcL4YdC3A9IcKOKV3rcBv8y4l2p9pgn1Pn75ouZobL2qtZ4uxF1E99H76xDn8fYIivJdymQ4pUA8jVU7mX3yL58QuzUSYNPkxJfR6TqumSGMIcXdQqJxJlG6GYgfJhXZwu5lEgES7k7S7p/D6vA2ug9Gov28Oze6m+O5CoduCRqGgPUqgShFHzfCz7jbynRDfnQTT125fQdHe8cZ4DRT+X2KYWahQTDjeCmyF0bRRnJUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldg24IH4qT4/SuZqxEdEWmIvKtl0PI1nryovOns03Xs=;
 b=YyGXkHFNSx7AjAU8JlHeVxivYPNkjy7TXKUtbMaJNqi6UiVjXLwwKSaJluKFSaZaTRKF/yDRYVyOSGZSH7+LJwdgkUyKT/kG5a5Y1uAPX9AFy0SN5auhG4ho/MF7LF98hwYExQk7LrnnAsMJnD7m2RJxPLdVdOUmNJukoBSRq21X8aCLxBxsI6Q6NRrQFuoQMnV6rajxRxz9ewz6pcxwtVX3uwGqgVO6D5LK4ya3AH7rXPW8higeYuvG062L0j2UUA1cpPTiicYK16KEXHxtl1wTqRLhTiat9gXOjs5J8LDEIcJ2ooRg32MpYJtyFPOqf3KG7lGbAuor7NYTyJ98pQ==
Received: from MWHPR17CA0077.namprd17.prod.outlook.com (2603:10b6:300:c2::15)
 by DM6PR12MB3307.namprd12.prod.outlook.com (2603:10b6:5:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Tue, 28 Sep
 2021 07:00:15 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::e4) by MWHPR17CA0077.outlook.office365.com
 (2603:10b6:300:c2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 07:00:14 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 07:00:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 07:00:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/68] 5.4.150-rc1 review
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fc10c138430d4a459afc35e4157c736a@HQMAIL111.nvidia.com>
Date:   Tue, 28 Sep 2021 07:00:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7baf1f9c-95b2-4f8b-c59c-08d9824d9f1c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3307:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3307553E901B572517B3C1FAD9A89@DM6PR12MB3307.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8855kOJK23HuHrQOHqq9BY2syoTdoy6furWgpd8gmFXh3xUNfmy/5nvBCh3lsA+5hyVEQt+JchSATQJtlfSl5poCXvWR+LOdY+mjZj79w8IUNDlBs0/hy3VScbrDawr+kW7O24NPlXklCJ6Zjv20WSPWA+rD3jEwTUy0qbh1eQvyShLzRlbdyhebsX0ibSY9PHX92dr45VcE9OITHPYj/Bg+nBDdWXKp4tBG/wbhQhQAEB/VJV490O4Ht4n6jBWVVACv+hamdWeB5fyDpwsqbLvuWR9JSfHuxexnQerxPQBXivjJz1o7hOtc+q3UKRaiwoQnnv1BIwlIZU+ByiFwvz6VdattB9metj4ww+VnMTEIcJj8+VzK3Flf58mViYl6vOlbbDQhXps7IM4aaJ2XfhZT/iaH32oF1nMLyF38j8PmHhm4vd6WZDc90SpGaSigX0wpy/OykeIjP4gM+sg+bIwlxZIJTx10NO0LbFaH7peqlWoId5eu5RfEk8P0ITM31alMP8JvMNdFNod+Oz6oZXiDOeWOIFMIbYPlH4TpOgJBuu/cypolnFevvnzTSP/NY1OaRFpD6TK+QyZhQnxRNPqw403T2n0Tr1jHpe9viVEXM0rVXPi4Xys2210jrDrVLXeCo8FQ30sOPBln9B8N7Aud3Q02nmHBWDfuOHFpe2nmMk69wbIHiD1bsYJGhVetQlkQoMnm1xiAdwLg9SMV/Rdz3MGvoFkxnnRoEE93KpReybrNyUnwIs2QDmbUddyBe8hYZOT3DVyZ50EPzRw4UeRPsDKDTJloH5Kq9OrNk0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(54906003)(7416002)(82310400003)(8936002)(4326008)(36860700001)(316002)(47076005)(8676002)(5660300002)(26005)(86362001)(336012)(7636003)(508600001)(70586007)(186003)(70206006)(426003)(108616005)(24736004)(966005)(6916009)(2906002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 07:00:14.2132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7baf1f9c-95b2-4f8b-c59c-08d9824d9f1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3307
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Sep 2021 19:01:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.150 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.150-rc1-gaa1e7cd620d9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
