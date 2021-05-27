Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A253935EC
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhE0TFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:05:06 -0400
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:4612
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229739AbhE0TFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 15:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZ2BJEKoIG1o95dnl2MAFmHklD1ZzJv4lg5FpKXVVbT2lPruydvkjeoqhXzqSxzdM1T2+Ayixx30aQ3pGEkPmhUOUDNh4KiLzgM+RRN3ikhG9EXxT6m18H7iNdHJzSYCf0xElFooWTf3XXXET0LFYvt/cO2/eL4uWOt7LBJFdbxyULxU+s72ZmMaKDn1Fq7pOQ23tsFG1IyLZJKuUVMGU4cKl032/5vVwNdFKXrQ5DYdrkR+sViag81AqF1i+UQT4SAUhrtGAqr8CuOPCqepQQjoMHqOFQ/Xd01jdKJlgdk1xvGzIDhoq/YlxnitXaL5gaOl9EemBW1MNfzTcaojGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zT/xz66d8NYSRnHqGj8NVmjqOuvmZfwamUBF249o9qg=;
 b=WVtq6OfME+qyAOdQYdsL0wF9sqsAhc7594xk4+YZuXM7C1DgXftB0NLWCKD7ogd/1z4cxlma9mDBSYq3DbJrI5WLg87gYEleGbN/37Wr6ffgyU0MnBh/IorHRJB9zcYW/96P/ocFtjoc3TfVk0wNB1vtSZbhXqZlxao5O5TkI6w+lDEd49R6VOtUGEsiWlX4fmLnuJgVTq0t7iI3gocTE2DWrmLZPvZWDOAaTy5JQ4CrUcKWbXZzCLXtPuKFNItujUpTtCpY1tEzL9c/VLTZl67BrsbB82QHRZeio2FdI+IZSbNWLwUyte2IPrpN1WOFsMiNejeoF9dTSF8X/RraIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zT/xz66d8NYSRnHqGj8NVmjqOuvmZfwamUBF249o9qg=;
 b=MQeTVjrQkANNpuyR1QphQDy77lxodzQhJWJZYj7Qj+JEmgNFCH9k07OLifh/QuUh4Y3yFQreVo6mD7qGUfoR1gpvdQ+FZuhaQOMLDfwWE46Rpvkg9y7+tiY5B30G22BITgWem12de9RMadtuWnFOqtft/ztlSMTTZWU5IJGk8NwVBm4CaTYolCo0lt+j9fIr8oLYj/4zXhD5YrtigmIpwmSRfyrwDdE7JWJgrL1gf7UNj1qNycRC159zu6V2kN+/tmJHDcNLD9H5qN5RqUBIAB6nQNtrKygYaLWPRaKS168rcfBrW7EA4w8fxLsopcuAhuSi+OPcbBDeazD99MHfNg==
Received: from DM6PR02CA0114.namprd02.prod.outlook.com (2603:10b6:5:1b4::16)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 19:03:30 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::ca) by DM6PR02CA0114.outlook.office365.com
 (2603:10b6:5:1b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 19:03:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 19:03:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 19:03:18 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 19:03:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <62494df987eb45c2afd5b4e372c03a6b@HQMAIL105.nvidia.com>
Date:   Thu, 27 May 2021 19:03:18 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34f365e-8a6a-49d6-61c9-08d921421dee
X-MS-TrafficTypeDiagnostic: CH2PR12MB4214:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4214C56696A83CC8F6F13799D9239@CH2PR12MB4214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsA9PDZne2RIt59F9SgmPk5UrRJeA+GZrFqi2d2U/7hj6FYoQNdEqkEJV+ljGtrVJjqQKIeqgntVFCBAFauAufoCiPobtiFx1de6joI90+vsr7Dks2FJPN6rA+z/RSL0AWVGNOf0G9PJ2ZCK6yLHTuiQMf4A/cjmvqfRDTByBk8am7VREsrig4nj+LIDRVGfZd6tSWuIm0SXtgxdVAckct3llRPGlsIFV2pn3HSTpKIqxhJzE+sG0kuzLYNGDwuSYlry/S/a6PZzrXZqcfyBag27H8fev7ev5bhfKnI2Y6Ydt3MjOuEUGTdWIy2nTmZrc02nTXwrz5lilAmcjIz/4gnlifo/lVcvR8NCd48o6hKUwpv+bjm23Pgfp565dSGsiFwlLFNXsgbzxReNFW5+o4CXYe6Gm7xosY39SJpOvRuy88p7g7+PYzbKl2V/l8Bu9oh8B9nXz9tAT+t1VhV7P/6X4EAsDEO+S0F2m9h/h9VcdLv5rPmw0+elICR6t/7zJDvfBVLCoHXzwU+u3lNYgfQfj4RBAD/pM3AqzU4FWWxwhs02ftbBG+d9dY2mHnZnoGSkukQS1T3guao+2910ph1UWnO4zs1b+Ymq6KA7UDz1ZvX31uTmiGG2p6MDWWpCeGLJhntxtl5/R5T4sDRO13oCWnEgkI1/wLQ9GguHw+JzyV+rNbqv4MlTD/HPDyTkVx8KvQPWg5YeOBImSC9bL18hdQniSVRI0WPgeIbImdpBnQ0G3xfaU2Cv6Y7bV0sx9p2OejpgAzPwnwZ5R5YGSA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(46966006)(4326008)(336012)(36860700001)(8676002)(426003)(82740400003)(356005)(47076005)(70586007)(70206006)(7636003)(108616005)(82310400003)(478600001)(86362001)(5660300002)(966005)(7416002)(186003)(2906002)(26005)(24736004)(6916009)(54906003)(316002)(36906005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 19:03:30.2106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c34f365e-8a6a-49d6-61c9-08d921421dee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 May 2021 17:12:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.41-rc1-gec1cc3ee7be2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
