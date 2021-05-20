Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F9F38B32F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhETP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:26:33 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:3169
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238420AbhETP0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:26:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EH4Vf06UnBiJZyLkGxLtmkIfKF/6qxsI21Ppc3OnsZL/sNZLTVAYntP7rUPhlzdJnQBOdZe6Aj/HgNeCwLWb8sUdOuJ6TPNYWegnczfM4xm8TMAND33avr5Oz9bCbFuMMU6PGyz2GQN28ngfzb8L5cBFoM528kL4FmKvSmltZilNKakMm6olAV/+Rx1CQjTrmbr+mSRK25cuHJA4YnLnhSeAwJISwsfQn8i0oiHHv4cYG3vKUxZMhUIKu5ZjS/cJAwrVfeRB61hkF9PhPvyIsTssAabrY3u+NcJY5OW6BiimDZnIHRlmE9sYnbr7J7sTj9dIaroGsBktsWLnO8PVgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XinxZH9f3EQA+YomWnK9UagWYkbPilOLWzt9bjJU5og=;
 b=GJ/OORHDDGJWEKQlt9bZluUEHVLlzA4w2X0/ySP334GE7vWyysyA0K/kMukiag+7XXUYcylc8CInAV6JQCpBgWEYjFtdywpAIwrXyhCB+H04KT2/muykxDAU2zX683FvKTwMx09ZTDVmzYFk7EAWvossn2WKMYhS6ljpggxM7UahKTPQqAxQneK9UMtZ5HxB/2uScPehApwHp9EdQ+YHbJxD0ZkuFhKwdzupdK8WyyVeHge67W8k2tYc3O8Iaomy55UfBdFMcxVH6px1Zb+hiPD6Plxhe3NeKvyBBB0TTq/xhK6+IMSfVtCsQRpCBU1Av0h6tHCEQkvT/P5Uf08kcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XinxZH9f3EQA+YomWnK9UagWYkbPilOLWzt9bjJU5og=;
 b=HuoOruE6OR2fYhM88HZ2vRU/mOGajCJKOKWlfR+wX2zrIYJJrr2ZtVUbbCX49/+a5gDuiaxtr1gNxTuS+Dp4jUaBgU/zlCcX0RoTa48gX4m1FP4f5YW/bq+osRQltLswN9+fjVDzKbNSdKXYeIqAtivaWph1s/qTfvnfbelry5LyHVg+dz98ptSXy8GhhlQ/w88ViiIu9CRzPPtFGu92BtEqF5Y1cnq53t7Pv7WF1TtPQ2bUd4RHGSUxcAk6sm5XxW1eJvIXJgGXUCA44IhRbSWfFmlzJjSrXF8VyC+lWsO+DSdiKdVKkDeqe0XpMiFtpzJX6hPs/w4NtP2WOe2UHQ==
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by DM5PR12MB1899.namprd12.prod.outlook.com (2603:10b6:3:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 15:24:38 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::58) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Thu, 20 May 2021 15:24:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 15:24:38 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 15:24:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:24:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <af759529c68945ffb1982b157539f741@HQMAIL111.nvidia.com>
Date:   Thu, 20 May 2021 15:24:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9abe0ea2-1f43-4ed3-c7a1-08d91ba361cd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1899:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1899A496B5052E908EA239CAD92A9@DM5PR12MB1899.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JW9/mRPeoFUHyhYYXgqW926/Ykj2PK31TzbHgLbmmgKu/ndIhPWiP3IONc1vncCMbaVTOUAhuk6X1HBFDn8mLpg/Foaiu5mtXOG80REzld4E3qGiVXpMWEs00Vf+FgY64AHPZWcKpbg9K5g2sfG0txqgO0rA3VYwD5qXe3ZA77x6t+9fz0I4jS3vNrCvYMx/EnU/FIIVX0HARAgQ1qBTQB8tXswTS5zjfPUtDNPnnQbmJ2yU4GEO5Hyxjnh47oMDnSz4g4mp0TTxbK1w9xq+Fn//tVyPSdkdYBUHr54gpkF/LhfyFn4gnND1l4IYQfdfcb8/XHDeWGUY9flcKWnM29o+uNzAM9rjNc7fJS39QXmUnKxt04O9zlWtFgbpPc1sao0fiooLMo7WK4i7DCH5eX7Ln/iIBqpmHgBK+SsjHNRvGZLWuhN1qOgt/aATcUbBx0u/RzQOdpj8cSt3xRxg5AeOB2hhafctC0FKyayrqcc3LZqMAoKePNy4pt0cd8a/6RKJpLu3tbJchuF+9RcZCu5eGxYif8QhESzk2OwGCwTZaVSP0UCnY73kgj29aOaPeULfaS5+z35UC89jbGKaaHzMsCq0T6fRhUvhaApEdEzB8uQPnUIvvqMWIEJGv34mtmX1TjoOmIdOTiIi1nt2UV1UWpx/uLoFHExJZtCWJwZuE5/IsWE39YyFeMhwUAME81fhNkjKHtvPgfiLMQ05IBya5d9nxMK2Vwlizy9t8z8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39850400004)(376002)(396003)(346002)(136003)(36840700001)(46966006)(82740400003)(54906003)(26005)(336012)(316002)(7636003)(36860700001)(5660300002)(966005)(426003)(70586007)(24736004)(108616005)(36906005)(478600001)(4326008)(70206006)(356005)(7416002)(6916009)(8676002)(2906002)(8936002)(86362001)(186003)(82310400003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:24:38.3011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abe0ea2-1f43-4ed3-c7a1-08d91ba361cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1899
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 11:22:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.121-rc1.gz
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

Linux version:	5.4.121-rc1-gd1968aee6ca9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
