Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9140F4A8
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 11:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhIQJWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 05:22:00 -0400
Received: from mail-mw2nam08on2054.outbound.protection.outlook.com ([40.107.101.54]:61281
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245590AbhIQJUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 05:20:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOtKGWn4Rh9I9JLay1anIrif4Rnuj8CxhJLYC0P3IbdiCtB44D8uT6jvOthOjVdkZNmjUdn4lMvFoHzcAds0J/jLkGdxQq5DNG/t4rEfsQroUOYNearfT8k8qaSW60dhq0b/MbY+1H9Uho7jA65lwjLsrSX3AvoE/x4spA7pkgHJnbsODotowcaI5uUxXIbTvqQ2lryEwA5nsvofxvKJpcLQqVjZHNd2qSMsH0iQ7uy5x9IejT9Jdzn1zd/zpjJGcpL5r08E5zz0ZMMeeNy27I0g2LHLBqWSomQwsvrJHNYIzAfwKPrD8/iC484N5gcFglb2P89a+sX6vFIpgKwD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ep3l1pJFcA8TZLbofC77xdmwgzt4aRKSjoiww2higQo=;
 b=R7f6RuvfWD1yfK9rm1Uyv5vo7ho49BEXbs5aPA/owYeUspgBkdpc8M6FmbjjOe4GY4Fja/9Hz6doQripEL3ixGefCUgLjxwO/aZO/lwi99suTpE0U2aJLswMI0YXACDTRW7Lcs5naVALrjQrMYj4XWLUo7T0XwL7B6YZvNzNkvrqkHYheqP0WG4pfzx3nOkzr+L82L4fA2ut8eWQPWqotITOZ3YtMKVgFgR+mUGmwHAPkO8dAt4qzwTZijcSamhGRAa8JvTz9PuHFxbJ9A4RTNIjuh9NhJFELN54IiOJwoAyJWhtGNltr+JpnGpYDJb14vAdJQEwO+lN7gVUrAjFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep3l1pJFcA8TZLbofC77xdmwgzt4aRKSjoiww2higQo=;
 b=YXSgjB72y9/Ov6oq2L19/Ahn6jh94e86Xe05FXaFRQ3GqXtpfUQp4XaqVLh8uXTaV6MZIiJXXIuYzW1FWWfjw2OQHmB1/kj0chBkxRVUgq75YT/coMcnhVQP/YOZqXSAxmJhgNX+RN9JJs+p346M6I7da0IXsXO0LzQARgb8Ht8+TKMv6D2eExeEvfQI5+5/HnkwVAggHJSIeaag2PwDgi8KAPbBHgDp7uFiCFNOcNc+QOm/ya+wFbYwb8SNEg4gpswH1e0xkS9hdrxsTwTAyJgyDD3nBSVWv6EUg7hflv51oqTVq6wdx9xDt50N59I24MIyQrBswlOElZrCPvzZqw==
Received: from MW2PR2101CA0031.namprd21.prod.outlook.com (2603:10b6:302:1::44)
 by SN6PR12MB4621.namprd12.prod.outlook.com (2603:10b6:805:e4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 17 Sep
 2021 09:19:10 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::47) by MW2PR2101CA0031.outlook.office365.com
 (2603:10b6:302:1::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.1 via Frontend
 Transport; Fri, 17 Sep 2021 09:19:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 09:19:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 09:19:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 17 Sep 2021 09:19:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/432] 5.14.6-rc1 review
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a221a97b1e044652aa5a02eea71d9544@HQMAIL107.nvidia.com>
Date:   Fri, 17 Sep 2021 09:19:09 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 567e3c21-25a6-498e-9297-08d979bc3545
X-MS-TrafficTypeDiagnostic: SN6PR12MB4621:
X-Microsoft-Antispam-PRVS: <SN6PR12MB462153CB4705079345188DF6D9DD9@SN6PR12MB4621.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HgMujTof7yxdkqhXW2CSEFV1ZMP5C74quWEmto6CmaKtUB4suEOsaPnmUKKzW5tdKnCRFGm0r5nuaCQSWnIW5aqIVViFaLMCAlwGJUkbUFptO57JJDN5FUIIZBNYD+pcSHKtQXddLOhB/OaJP3uBc8ntoY4kQQwnCyyyS8uyGo11G0b376eqhtSblRqqpfuztIh1Qc8bLKjPGa2hJTxNHC29nwqz0Lh82bg0DPdcwAS2nAnTK7vGveaKb4qb+f4JOhK3CPnQj0vUfTMTFJoMaPJlLx7GBRVhIuo5ZpBDO7mc0Sr1tGkVt4OU7RrbmPFPML/ust0AAyFzm5/6O53ovkNS3BmceqRReTnqQlTysuP0yI4nFrJlORpY6NseX5fFX7LnAWsKcGK27llZWWxN6KlvbIqkb+Keu4pdh9Th5Hh4rUW/vR5+MM1yy4TPr/cgfaYmS1PjqSVUnxy+SwawtAu4y1PlUCdbegRmpFhcfxS86Ea7i5BmGZiRY3TEe68h9pXARcJx/guWxTIOs24nD8auymfgmmCoyax5/bEaCZ4AjbjhiVzsHv/7nZeN9hCY3vGna3X/LDugEuOf6c7GuW/PXr6KJnufjqWiL/D5EYb7ZmofJyB5B0yVKd0vVWy4OqQqrTZJfbEb7VuOlJYDlgfcAh6Ly3fSoqqyNi3QyKxf7X3Ohn04h7fU8XxQE5nC3CRc027nleDZyiEmXVsg0vvp/fFGXBriDC5ooRCAHwoHlTar1HI6h3Cnx8LW7O0tP0isDH4brfOVOxIE7V0q8IV9aEBkos2TiA9I2rfWIcw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(8936002)(70586007)(426003)(6916009)(54906003)(70206006)(508600001)(5660300002)(8676002)(47076005)(24736004)(7416002)(356005)(108616005)(36860700001)(82310400003)(86362001)(316002)(36906005)(26005)(336012)(186003)(7636003)(4326008)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 09:19:10.3051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 567e3c21-25a6-498e-9297-08d979bc3545
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4621
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 17:55:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.6 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.6-rc1.gz
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

Linux version:	5.14.6-rc1-ge47ec8b38d19
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
