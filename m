Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C83D35F9
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 10:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhGWHUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 03:20:49 -0400
Received: from mail-mw2nam08on2041.outbound.protection.outlook.com ([40.107.101.41]:49505
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233619AbhGWHUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 03:20:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cW8DMjlkj0Bsm7OcKcHrGINUpyknNxD74ly6XMEt/T9nsdmHSr7ZzqQcjEnhVKzgI+x+oY6Sa+T7/lkl9LvQ5xrvVPmhuku3jb/xtiOS+mwnNk+06iHIb5dLUwGL2m0KCSECA6lGLGwTLfFX8Gxx/x996yQjnzpRTAOCcliKCUfk7RAvNb5GNgv9Mi9MXUQoxYW5Kb+ePZey2rK1mYSRLtLN7GLmnoxQVVywXUBVo+tg6fK2KYy48M3Y7A+sr5IoE6tayGdD9JdeGGnAO7flAxewEy78cJMu9a1L5OwN+O7MhNrwTLAgIVl8ttbuB4dOB+ouKVPWp2K3kzaBIz49Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P17aGy4O46hSlFwi1YmWJCoFjlE9ZdsHAHia+I3fpB0=;
 b=JRROGWiUw5sglDAQ4R+YyVvxzJStTJBXIA1ZOqjWMsFnelglp5U4f6EvGsUD06sWDwKrvQpvsOODOi7ouEMbO9q6eLQAxclGBjxhsdciYqB6UubnVTET7ekVrWbiDqCOGMKpqdFV0mwF5iMSD8w/NicqtMRvHhzxEzhcTZ4vEufA3fgzN0hIHneIItRyTC0ho9xGvVoDPrOEB4Vd8O0TDHzX1XCeMIG95d5q8JKGQihaWPl9MYrSyd6+qjBw+KUXDEMgLDstvbZGRHp1XttrWmk2csL9rL70j/muXm9RIngXhyf5FwhGI52IWNhOF4UtZ85l2mCEN6UbmhVy3tOalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P17aGy4O46hSlFwi1YmWJCoFjlE9ZdsHAHia+I3fpB0=;
 b=mGXTctkpAaVMy7JX1FgwDIlSwcO6S6YMdSBV/yHudAsP52AAvJ08/6HRLCKbc1YYe9pHDzLIz3oDxCqhjL/Ro3rFHn6KSatpbfCZjNlBOzFv0cBdrgEjbhoUCH/xylDJAysdB+hgcxWhJIpB6n7Hnlw1mitSKgokRM2ZrjJzUUof/yxTAg3rGBx/YQpjYL5mEw8qd5Y4VW2BuRlKM41II6RL4TKZrDHq5BAmkJY3ZxHhrLPSeF4f4Mlm+y3e+Lv7Gjt9lPPDqPz6eKdtN3OlpUS/TnuEaB2QVjnpPS7bTgI95Q5xrVTGo4uUyNuFTDnZebq6yttTYHLTgk/mFP3rjA==
Received: from BN6PR12CA0031.namprd12.prod.outlook.com (2603:10b6:405:70::17)
 by BL0PR12MB2449.namprd12.prod.outlook.com (2603:10b6:207:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Fri, 23 Jul
 2021 08:01:21 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::4a) by BN6PR12CA0031.outlook.office365.com
 (2603:10b6:405:70::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 08:01:20 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Jul
 2021 08:01:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7b98d2f97c1346df8acfc6325b1678a8@HQMAIL111.nvidia.com>
Date:   Fri, 23 Jul 2021 08:01:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef3ea641-ebfa-4f70-518d-08d94db00ed9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2449:
X-Microsoft-Antispam-PRVS: <BL0PR12MB244931844BC5CC0D4A2441DBD9E59@BL0PR12MB2449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BmgE/W43QZHYOiIa65MOnrB8VJ1p2MXbCdwrAkj7LxUK5LOPkRd5Bne+F34rq/oax6aviwcS6f5fmLQCC2L4kXfYmxQGZFSUt3Q1TUZu24HI37ILniRU5brkNP6w1qATUz+6re47k+c0CtxKOk3/VzGBoIV+vnzJ34cK1BLFOYEvF3z/Raq8GQKRAJZlQrExVh2gUb9yMFe5iBLrlPsr7FETkw2i1r7o09EACfoLWKHORH66876EYTuwex676aU8PKDFgso6l49+XXySqnz+jjun7k/GXAEscYvjFP22OBaYvgCCdiakC5XnDXGBcrhY/8epm1dpGWtNySOftVF8a1DSjrvzpCIlpxcz3SK8zceieAabO4KImPlPMff+j51nj2ppOkzGKr4QDYg0upd39ouXDHIe6N5p1WhPOjp+SOzs2P9x0Vq99JgCEOzk0Pk1/c0b6OfHJHkZDjHbjSv2AcFKogNH9kheIitzXQcSQ3Zu+/cUyxaImEeiXVbrIucDHCjB8oJnzb4eZbHod/7fpUgNotzcKT7tJnTevmm1hEx5nj20RBuNJw7CcKdbokwr4r9ZIu2jCZ5Kpd6yGQ44odTN80gLPoL9yoOVUovdGVTSg22UG6MYAsnkiq4uBqPJGbdxhfuPKL3XgixLGQjG987VCJzvKeBOaUwjoUg4R+GnFVDr8sQ+YyZMKArMy1MaAEKGg5MKkfbpZFfFeoyJ8wZL+ubS6t4vR+twKEnjm3LVaawhe+RXJ/lCJ3YUq5Ko+XjcB39pTUQp0nHeYukmnztyy/89+vI5rCl7DoCSsU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(46966006)(6916009)(356005)(478600001)(82310400003)(7416002)(186003)(336012)(7636003)(5660300002)(26005)(70206006)(8936002)(8676002)(4326008)(2906002)(86362001)(36860700001)(966005)(70586007)(54906003)(82740400003)(47076005)(108616005)(36906005)(316002)(24736004)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 08:01:20.5623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3ea641-ebfa-4f70-518d-08d94db00ed9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2449
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 18:30:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.135-rc1.gz
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

Linux version:	5.4.135-rc1-gdcc7e2dee7e9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
