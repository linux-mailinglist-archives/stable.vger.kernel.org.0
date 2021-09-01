Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8613FE2E6
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhIATWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:22:48 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:5488
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbhIATWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:22:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDIis53pde96AH1jYg8xI8gN0KeNRu/E7Q4iPn4YnNfFahHyNk3FECawz31vEFJD+tx+g69o56fSoh5LdCMhtkov/B2OzHP6NqTztkjrRqIlgMpbbfKG3GLl1EbdLO5Smp1xmghsW5BiYGp4MgoFkQP3aP86g2SUbnndHucoYU24h+wDrdiB6CkrkKAwgwcDo9ucNPAX5yYb733W0GPazMpRsmZ7SnBWtOzdWZZcSEpUJ5a/BuH6bhD3EYo0KaXGhuF4b2usjcw/zbi+NtfmIwTsnEIYzNr7N+k6wT6ZB5oeH+sySWEt2TfGuY2ljFUiF7I3uAnxFaDyn8QrlkuTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zAGmdc4+/46R6tes7t3qKo48NfgANAtVeWKnE6qTtZs=;
 b=T4tSq4CLl+FWxFdwNhx7Tv8oHGtqTVLLqMwOpUrwRw4Mq2yQMfedOMLUfFFnUXqfF0mSvNQBOKOm4E7K0MtDYlpJLQeoaif7orj/uSitBbEts/7SmhqK8UoFggcKE54ckhfIw2DYf+QQs5AW6fjzEirbTHSrO/1gNcFhdP+8xMhMIsHbWm9llGPkxoqU9WXPeyWtWUHQ1nD159UnAyKdUPCdV/gOj1m7Hbd6CtPKLqe0gw5isJFdVN0kH7XsiajLH51P1Wc+roIV6kMhU4LgmgBOyQrOe6a7SkfPpSVuTFgX/NRBxnVAw2iPkWwl7GbGMwJvnCEbmt1Aw1y9dusVAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAGmdc4+/46R6tes7t3qKo48NfgANAtVeWKnE6qTtZs=;
 b=KIkmHjxH3Hv30kWVaciRFIqvs62u8j4oRXeJp9rhk8pFK62xvTO6IrvGF9SOV8BfojQSY3zAOGCtt5O6IEALPkgNhvP1XutYPIltjf5CvbJx0P/3j3qTtGzSUBWnnP5eYYt29eXj9xgzIyNO2eDu/9sepD/xZmn/4spzumYBpUWzgwh6U9jy6CT1pIePruliZm9cpKzt+n5yFstn9i4PLoZfrHgig87s8MCrg6F6xCu3lqgUVPRBnr7X9tsvshJ0CkS/inf2FpWv/ITqa37QMvejyi+nMKRU6Skdp15CPBC+9/Lp6Xzg4PJjBmbjapNKyglmEh4BHaXuH9R3vqF9uA==
Received: from CO2PR05CA0101.namprd05.prod.outlook.com (2603:10b6:104:1::27)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 19:21:49 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::b5) by CO2PR05CA0101.outlook.office365.com
 (2603:10b6:104:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.4 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:21:49 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:21:48 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/10] 4.4.283-rc1 review
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
References: <20210901122248.051808371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7a7ad82499f6434cb8259f22bca917f0@HQMAIL105.nvidia.com>
Date:   Wed, 1 Sep 2021 19:21:48 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc5c592-f746-44e9-5548-08d96d7dbf12
X-MS-TrafficTypeDiagnostic: MN2PR12MB4390:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43904C72CA5C7CF81136C14ED9CD9@MN2PR12MB4390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rmz+62EgOoobSL3q634fg+aJTuwCw4SnYge/OhxfCcD9ovYbQw0u+0joGmaWJIRkqAmRREGBWjxCul8uw/TpseGiVX02ke2/ajIpiaEjbqQ5PTVa2zsJ89U2Wx0rvZ5Zb+W7WPM6aldYiyQL/0+RKgkroyT6ZE4ld7BZwfO1nzZjcJY/MEzn/yM/c7vBDrMoeUcVpDKXcfdROD+POlmDyGeCxstg0lDcFsNmGzJi1jOqV63ZEcaPU/OXTM8PhPSrEfQWjqh5BIAIaJe2WM80wLPkIo/l+DXr1ttwsblS1SXH6XwDlMoXlkgk3wTKlMfgEpygiT/q9h4awHvU6ITZ2r/IRo3OJrR3IcRbVweLecvPLRbEmcUjEoOHougUcm8XRNllPq3IJJC1A/6rdppQ0Egtgu8xNPrQXMxrMpqfYOHh38jO3uxswftaUWRjVUDUi/oN9lPcNIOBWPqzRkTRkuxmN7ztqSKVylto7oz9i6LSKXaAs5Camv8jKLecGneIoiR84wrSS378hH/Uq4sBSmwud6DIfFAXy+DVDj8j3eD8MV2ViFIQ5jv1GNi1eSkZj1n3BKz+iELcCdhRvNjm9GiDvgBgbQDkJfGdOOzY+ov9eRom3LBq4guul3u1hnooZ+hO+gi0Fiwjvq4GnrrDpG1RN8ML/yp/gI24XX790p0ydvfJDxtGruvBTJnVJ+Ncxg7KVejGfKvFxoUpjXYuf3eIhD81ODKb4X+dB419p3I9KaJj3Psj2WrKJzjZVXhKAPoA4x6QxChsLdZRUsoKym8+7eGFb5U5fIcsWYmdyYQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(36860700001)(478600001)(2906002)(7416002)(426003)(82310400003)(86362001)(54906003)(36906005)(316002)(8936002)(5660300002)(47076005)(8676002)(24736004)(70206006)(966005)(108616005)(186003)(356005)(4326008)(6916009)(336012)(70586007)(26005)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:21:49.2485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc5c592-f746-44e9-5548-08d96d7dbf12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:26:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.283 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.283-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.283-rc1-gd0f43d936dd1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
