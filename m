Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E053C5CFE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhGLNQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:16:42 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:6433
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhGLNQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 09:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoL3J9iU/KXobg+jPjhHkvI83rG050cuCGm7Af2spwzu76UE3TPQc07WpQxoAkZilqTyJ0mKNx6hrQ3SdIBNPdCK6pzLuAKqjGb/MprtmK90FFQMwo0b5hZ9c8LaxehBl6Bp5niuRYj2li5MbYI+ALW59wZfXFAPVIKBecj71Oqd/kD5Do4fXUb/sRya0f7uLjGXdXeMbGOprGSS3mgVacj3LahR2Q10WMPvLbFoXZt8UwLWqchFAJoXY5lASb0XkGMMjRJb4XB50RTwUXJ4gdKNbLUHIq8bbsTjMsAMgvtdhrYF9ClOHLAInIsaEr32HKYO1BW2E/Co6UJ03jZwgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h62qIkDbL518JaGAmkGZTa9WSjY43ISEkddqWr3aCyk=;
 b=ONxFC8qqewdHQwZADOQ0bQMv8bYa9YxLOLJ+f8TKry7M9O/Md6vmSZnRdTJawGJSCs4Q+SB0SIZOPEX+u8MSk9JsfyM2Vha5AdfId95m/s4+fhkYlYEHL+TOFyvd2ccJziiF/bO6KnS1xfxCwgeYqoAb5qCAhKrB1rlVd94x+SdwJi7MiEgxKWOBjaMOHLDzCxDja0tik2pyTfX9R/ym/N3v2Re1mjaRdNl8qkb/5KXM9OjRq23lXJIhaHgp7jVRfLkUwp2ytymsi7TqleiqFOLhKhVj4Y+dnU4OqocjtVAFrHAf9uucmooyDoWedPQUkz3+eb60nq/qjRTz7MQfSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h62qIkDbL518JaGAmkGZTa9WSjY43ISEkddqWr3aCyk=;
 b=FTwIDlVdxMM+P39W5bx0sJxmc4QRoc2JZ7bxjL7hO6g5rJ/IOXsXq4hECB9B5x4/1vC73l0RK4mKfF0hbqJ2G5wQLbi48ySg+3aAFjtmptSd0UsVlAtVywkGJaoNNROj6lUW2MgeELiD3ZqQ/mp1nm5KNIPpAE30ueTS+ylIOXdO1I40y7Ll/13qL7OhmI4UZsdZcf45LImDBJ48nW8JodU2yWN+wBOSz1G+AO4Ga7IZV3kSQoYlwrQA5BJd7wJKDi0yz7yemFUXnVZDnp48iT2wLbWGZGkcOOrWS9mATs8vJw88TGNcit5a9MvhSNKbxm4CKIu/1pReuWLfF/25kA==
Received: from BN9PR03CA0207.namprd03.prod.outlook.com (2603:10b6:408:f9::32)
 by BN8PR12MB3442.namprd12.prod.outlook.com (2603:10b6:408:43::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 13:13:52 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::8b) by BN9PR03CA0207.outlook.office365.com
 (2603:10b6:408:f9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Mon, 12 Jul 2021 13:13:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 13:13:51 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 06:13:50 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 13:13:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b4f70158ac294358bea84a69ab4c9b61@HQMAIL111.nvidia.com>
Date:   Mon, 12 Jul 2021 13:13:51 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e102374d-b738-49e0-bea4-08d94536e4ef
X-MS-TrafficTypeDiagnostic: BN8PR12MB3442:
X-Microsoft-Antispam-PRVS: <BN8PR12MB34428E935F07A842638B1D02D9159@BN8PR12MB3442.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bRHs0zTGnFM1mruUJwt8Uxz4SYd72a7Sh2s+J4+8pzz7ZLVeUtYvmczQbNhlN8JlqG0LOQLC4O8OOOpJgypQXC5l+7ny37zgoo61js2N2WxnhBkHprvcqNpsDU14F3fPCoRykVdRF4gFkMMqoAOUEOun6tkbrOqV5ztOv+nfOC6kzkJp+hKdpY39YOgi5bXV/AmDdyiqRCyu9NO/tqus1lJ2q6Q18UyUEO7rLtYaZGodDOtQmZmR3zuEXuiG1GKmJUV1tLbYc/pAdRF9LoyEVNweknrgOoQHKWHLXGxbsGRCOz04NRFZwEME+9eKI/nxqypHCt+7+rHyKwCdY5QUeMKjKIiFlIO0wQa0LqFYZNvtcLt5Ezmb1RBhhH4shJO/QG2d/a5Xkhq1SepgpF/Ip1t/en0Eno98blB+yJPrllRRz5XHELiI7SKSogVVTC+vJf+JGjsNlz+JlY71AG/+UBEsiD3GR4ETU4URnhxa85S1fly243s8HGSXUj2DFPTwF2cQiNt+RD7O+3DHhOfG3j9te+i30/aUYoja4BT59y3+AKLvPlWJHK+a0ra+fYIP3u0JrVbgzHWLe0Be3py8ojp8MTTi/uPy79O46cbifrv0uZLRByFsYZ146VdiFQvK6np7yV29a0O11JQTp4MYq2/KhK5rvIeNuo5r1X2YJf+3XZHnu37EYlCswrjUEw6Y9g8FBV6G3ODjfk2sL9lbCLVKuduDtINLOgCiyMQrc7y5Y9Ua9CbHjo10PW3xJ5CuIYw/aCeMXpVUsGlzaNO2PmrJ11LWB2Tw9z8v+gnjrPo/RuifR7Ry/QnB5noCOGVd
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(46966006)(34020700004)(82740400003)(356005)(478600001)(316002)(7416002)(7636003)(966005)(36860700001)(5660300002)(47076005)(82310400003)(4326008)(86362001)(70586007)(70206006)(8936002)(26005)(54906003)(108616005)(186003)(6916009)(24736004)(8676002)(336012)(426003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 13:13:51.9234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e102374d-b738-49e0-bea4-08d94536e4ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3442
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:02:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 593 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.50-rc1-g3e2628c73ba0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
