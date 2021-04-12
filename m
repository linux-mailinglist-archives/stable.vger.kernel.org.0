Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B835C744
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241845AbhDLNM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:12:56 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:53345
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241722AbhDLNMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 09:12:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bcx8bWRC/nVVv4NePxzXJB4Pt33UnE6ovHo79g9Kmo7qwiqW/bmVhf1rC1DmQNbmdQotWwigYaG7i3DEMybOkQYVHuRBmtRWNjRZxFHWLLIPKpKKo68sRJRJMD0C1HRFBteIDpkT9gNd4WcdwGFw3gbg1ukAjv2rGwetu6PyZ4h0j89vQzbWG1LOA6AfL7+86f7DOkiwvLo9eecj4LXU1frZIEo6W68Gl67kHnHuuGWannSs9GLWwzsKm2gy0gH9mAoWHaA60wqA8X+ijKghbC7IXXxs428l2poMzkDBXTdTZCQSLEXl6He9hy27c1wshMIOLdm/MT58hLGAXtb2vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yo6/2kGhFsiXjMu75Gdo1u9OLteKHWR9EA+ZKGFFRDQ=;
 b=en5+cjRtUirwHlrzGAP/dYhWtx7ug35URcGmwYSQDJVMO78DQPfum65uNF7HevlRxx7szehvKk8il3NL2nv6Qk8/RNID+lSFeMOXyk0xgZd99TVO6Ce2HRXOJdDLrp/ojbJ1saQAayeLUpXuEhbl2Ej81VOUsMzyaW4NYVdHW+DiqwBBfWzxlXXdZGWhhONw+O3HyToOqnePOTlvBg0ynGlpZJCAPQvXmXjMgqC9u5XyDjA0F4iU/xznPTrOz+22I1IRthjwh/R284mQggHhwQ2sCrU/CUdFESVYKWpsEzIbtU2SWCmQx20TfcUuje1tWcH00oJSphpTtOMQ3dsU+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yo6/2kGhFsiXjMu75Gdo1u9OLteKHWR9EA+ZKGFFRDQ=;
 b=VzgjLZRmCtZF7eREXZ4RM1V8EpkHHab0ht3mm+B5eNTz4GtswyIiXwMH5UWRfQzUMhBB/EOTpOSMevkyv+wgAM/eDX0ZdZf8El+FYujw3vJF94NhARHdNGolr00n+VcTBZo13Jam65huT8ia395iWoAcg/U1SLi9xW8OGd6K/hPuqPKbnDdC5ynHn0C3rlS5Uq+IKiZHjiHbjrhHSnOWsfq4BL0FneMYYhVI52uWJH4mjmziREvQ/7ghlaPVLykN/9Kg2dEKOEjuwMdVXaPq8lqk3qXMHe9PJMbbaiYkziXjavJD/y8bvVFv5RNh6TnV0NbkhGDRtKEGdcFXT5fn/Q==
Received: from DM5PR12CA0065.namprd12.prod.outlook.com (2603:10b6:3:103::27)
 by BYAPR12MB3415.namprd12.prod.outlook.com (2603:10b6:a03:d5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 13:12:34 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::ae) by DM5PR12CA0065.outlook.office365.com
 (2603:10b6:3:103::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 13:12:33 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 13:12:33 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/66] 4.19.187-rc1 review
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2977c2f2afd4f0a91a52280924d6cca@HQMAIL111.nvidia.com>
Date:   Mon, 12 Apr 2021 13:12:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feda00a1-39cf-4b7c-b0f4-08d8fdb4a2c3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3415:
X-Microsoft-Antispam-PRVS: <BYAPR12MB341552E1940CF262990438FBD9709@BYAPR12MB3415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYrMQYLaJgnE2x3m9RXgnv2XwCa+A/F6j8r72H+ikkZV7gFEr8rR1XDmbJYFbkP4cjQuFOMLp+DgdbSL01tsg0r+u9tk9zr86KdLqPwcq1X4fQ389KXFyYH3n4pQc1gsbnPrZRXHCLtfUDFEByXB18hUj1sbgtmIJYJpMnwbkfO5kwFWGiXDxVdJ92KdvJ8XS48x6f38idhQfkBLQ8pamppJsGHuNn+cIL5kpoM5ov07DYfnur5kXq9o+OlJ8gnwrLqUem9n6679ufH0Rv3EQkqbN+UXhGsvKlpOd9F0LarC/P1m3m25Oku7OO9m04phsTUf79yhuQGzuRlCYw3KrOJTd4pl6Arp8iUNAikQYM5xfc0misvIzaFkEiPnxy+LOqSHHvfAKcR4YGjYEOXLO3AMhcvXslaEL+TLCtSn0b7vac91hB+9JrHmWoV2YAfAbPyMQ6sXu3h1KupZvk07WlHk6OvPisiyytxfddKaWTgeF5wDnObFWHOVygYmKcHTcXQpF51u9E6fca5O6AzjDUIv4d6R1XuO0oImGxVk9dFevlzneLKqpayjo9IbxLQCnCNYjsfCYNrbRaL+KT0OngZzsbmVW0yNKy2M9qOWYsg1KK6MjsESW4XTjOxiHHN0+Wh8wBpiLAsx/7vCviyAY2EYk2diGjhSg5o7kmNBJSXQns7ii32KwDzX7wFfSLni/FsyKlZ9zseTKFAWlZD7+AzZe9BkHvqoqcb91vx3ohk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(54906003)(336012)(8676002)(5660300002)(356005)(108616005)(4326008)(966005)(82310400003)(24736004)(316002)(36906005)(86362001)(26005)(7416002)(6916009)(36860700001)(478600001)(70586007)(2906002)(47076005)(82740400003)(186003)(8936002)(426003)(70206006)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 13:12:33.8600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feda00a1-39cf-4b7c-b0f4-08d8fdb4a2c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3415
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 10:40:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.187 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.187-rc1-g85bc28045cdb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
