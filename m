Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939AB3DF0BA
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhHCOuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:25 -0400
Received: from mail-dm6nam08on2048.outbound.protection.outlook.com ([40.107.102.48]:45888
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232748AbhHCOuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQ4UvwfGNqmmiR/PInSuVOvVOXvCB1sCkDzpK7Dh8NicYMw09SLl3AeTdzvQbXbaswaF2XamBSe0QGEYn4kNpnf3k8p1/vDoIlnT2E4qKsZIak1d/BRYE+AHO2lDFhuNpfVFNkUaKxeuXyT8fOfyK9R54exQ6MyNTFVtjyWxyQIGe61u1fWAMCHNW5E+/1jWEWPqobQ67N8M+A+QqqQe2Rb7x91fkiqwHsDIXbIcQGG6hR8DP2L7pxwUPW2TVxFGiEcQxEq75V4EolqkmnRYaeqUpRDOLEDj8pEKcChks+mu2s0OGMY6uwnThFtb3Na+GfKxn/SqdVGMi3OP6FnwXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxbngD/2lG1uHcneCdDSfVbLo3GiQyLnfJ6iMjuubGk=;
 b=YCk1ZXY2UUZDjVsiqzBdaPU3ZfppNPQVpNzd5xGD6fN2aWsjHxtky21Fsxw1rA2luvbF3J2Fud/qA20oLwxK9um/l1WsjlBPc9ksejeWIhAZWEWQQGO2Vsald6opjabtcHvAq3+64cPxYC3TwQAxZF9+9p74GuWE83SPzfVKCyE+Ic1qVxob8gKK7BTxqWYMboi4Uenwe9MvFezFaliTXs7lSWDNkyHwmqbndrF9wBsuC+By+iyf57pKBCzAqgM4gKwef7FjutvTMyTUpzsOa+PEcdNPfZB0AzhfXuuaOs6553UcqLrf88S2JeQSjBVcEvPJswCSreNOvYbhaLm+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxbngD/2lG1uHcneCdDSfVbLo3GiQyLnfJ6iMjuubGk=;
 b=F/UYtconivMCfVef2r7WpZYYRK3UyIiOsJEYOIeA4es8NrQYREvirtfbcoprS1H2bVzzYOYE89DUih7z75xE4xcy7yUUPl19CEaueOfaffm9ygSbfnZ1Hnrz6KiiQKmxWB2wbenIjhA1DzN1dPvwGg0AlH3uBR5aNydy4WvY+KGTE7JAXtqXEddS31eujtPnXl3irNPozKi6eXemqjhpGMR51FSqtbvT3nuIOkjWGnolkJSyKJRJweh7evDip0isqAlpVq0ay7lm/pPRKylhTzMc3w+sPQq99ZYWXCJl2O7bcfehHl4PrDlVMu1RJljB2uaLbXrlakP+LEDHUnH1Kw==
Received: from CO2PR07CA0051.namprd07.prod.outlook.com (2603:10b6:100::19) by
 BY5PR12MB4196.namprd12.prod.outlook.com (2603:10b6:a03:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Tue, 3 Aug
 2021 14:50:11 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:100:0:cafe::49) by CO2PR07CA0051.outlook.office365.com
 (2603:10b6:100::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:11 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 07:50:10 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/38] 4.14.242-rc1 review
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dd879c7ae76643b49073bd4510669c1b@HQMAIL101.nvidia.com>
Date:   Tue, 3 Aug 2021 14:50:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca396a4c-84e5-4a1d-0a38-08d9568dfed1
X-MS-TrafficTypeDiagnostic: BY5PR12MB4196:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4196DC60095F88B4910A6C52D9F09@BY5PR12MB4196.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rWMquRxE2Xz0Xu2qvS2sG3AzhkMQcwXmP/4vQXDqiMJGLDdUdruIMEzMpcjFZX4gYTgO2Su5iOxnTdaxG4AE4LS83aUrgL0I5FRjEp3NTznhAIS+OwYeMtkOU/H+6zu73F3juyY4PFA9fEk2KxG1BW1QPvqJcfB6EJ3umWWuagraSf0Az1yuZSFSn2+jCJEy134V9nsQdN5e/z3AWIqKijeXyY7wruT0k5ssjjlQenprxn3Jxf8mdujWtk721AL2aQKIVqSDZP/ANcpxa3ZsScm4rVYeoblbY672OgtJXc93EoFLC7ONzHRPbQqBvLofLo/mqBGxMXp801M5OvF0OI3HVCB7oZnsbpolEXl909r9O86aHs9nEs++T0Nup2w46UTF4K/zwuMRVodjkMDCuWaF9JIgV7YuWuBlVj+taEgGarTSqlGBk0eHr8j3M9CdcVz68+r6HHNCURIbv+f35DHS+seHVHPi6MgaGw7i3TLLcEDbUy/DONIFDnH0vc+XqLPvrkDkYsz8pxBsH+S4J79qt0FY7tAnyrz5jBJyBIfgNANVe9cpXmzizm9/k+oKAtM9pY8M2mulPq0vgcINzunizzRq8VQiG6ykbb3A1ubkEXMqW6+oTZfkRL2fWGYxr+D/IbtVAe3QGZv38efLBVsnkcNfbyTevieZ4UdtHQq7JoE4SGyU9GxMOz3QomzVg/JyJt9pvFjcagAbgb4QcYE4kK3sF5cy0pUWfqfGHHDzxXAbSqT1CH1aezAg8qsk0EVVKcq661eXKji+Qih4Wez7wM5tpwwBPpqQiyO27Ww=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(70206006)(7636003)(82740400003)(108616005)(426003)(356005)(4326008)(2906002)(26005)(5660300002)(70586007)(86362001)(24736004)(7416002)(54906003)(336012)(6916009)(316002)(966005)(36860700001)(186003)(8936002)(82310400003)(478600001)(8676002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:11.4046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca396a4c-84e5-4a1d-0a38-08d9568dfed1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4196
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.242 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.242-rc1.gz
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

Linux version:	4.14.242-rc1-gec038bb8339f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
