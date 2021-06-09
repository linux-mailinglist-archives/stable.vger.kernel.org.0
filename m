Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB63A1043
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhFIJi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:38:59 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:25536
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238035AbhFIJi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgZDHaj67XH91rCR15mRtv5uEOUBvSRiOcLDD2HUGmREsUu4IY427Fbq0kCob03wyQkEDjTVQNIyaR+ODZHJvu0PWIQGAZ6vl7mxKp/XAeMKtsr6tJhC0uKi1l+Fe/01EgPLTU1gU1sB2oDGuQPortXUaok3VKxvt55JkdXGdQDHIoArP6myyfuoG6d1RXRtXi1TiCK5jD4BPh63INfSZsmrIXazSVtBiwrJx7Dpqp3VC6qJwHf4dFch3OoYAt+a9Dlq+jWzuVN+LRUbESCGtnYWnYg6gkWUmnwHc6VVMum7YuRAhdz7mmt+CCaNOJBDqqw5Vyk4h3AUyWwYXnLBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsGl3JNGMAbrOaeOosuvL3b53fPKRl55CCdqPgEa9Dk=;
 b=VqN7l73f5u/S2qNvLKviNAeQyxHq+UD0rQAogsHRU1QyJ62N9eTVO3ElRbZrcDW//hE5MQPqUuW/Pc3xlDdV9rZq0LVuD/PJ7MbiRgmr7g6ZQDBgNxz2EhSOuPgvqOl+KQHmt6LGGiQsxrpkQ7U3HlrqR+6gGBDU7e/RRkgrG4tGJG1jPzMBCNy6dtYPSZTSdlVF1JKwqsGxTfwczAR+yFjchRMqfQzE1BXYu+LansKt7HAIKZecwVMPTrCNLtNs3+eEYyhPsGfYKw2L+qmjouzcCVAO0HkwZop39+KX81+2pruovJtH/EBH9tBl4Idrv2Fr36pj/lmumrSm7p1AbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsGl3JNGMAbrOaeOosuvL3b53fPKRl55CCdqPgEa9Dk=;
 b=tYCdFj80gQHKB4Z5VlV4YJlpkezrqsGA+uFCEpSOhTVx6p3WjhrHVrb+872l3CFvVUF63OIQvR23nFbXBH7NW3cQZa5VmekLB7MytrFg01NhsKmIxcP+ZjLMduhyoQkVsR26WNMTwo8DIBfFDVtnmQg0C7aOx0UK8wxhEg82vk1E+MpvyA6Lb8TcVwDh3ZGaxRFGwRqZFkpBiy94kUCZv9lMeBBJemOMU9doNVGkDcsdJ4tfm4yAaSiUfr4UXjmPcpGLnYcNCYb91RTAlEucdnTQfw01N8ZZyp2LqWF+26mQ3N10JSz/i8MU0RTQBP5mg4vjBFfQ3lybednkkwpWiA==
Received: from DM6PR05CA0054.namprd05.prod.outlook.com (2603:10b6:5:335::23)
 by BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 9 Jun
 2021 09:33:59 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::51) by DM6PR05CA0054.outlook.office365.com
 (2603:10b6:5:335::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 09:33:58 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:33:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/29] 4.9.272-rc1 review
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <53869e8c722f40da87349ecfb42182d7@HQMAIL105.nvidia.com>
Date:   Wed, 9 Jun 2021 09:33:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ae0385-2b27-4091-cbf6-08d92b29b566
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:
X-Microsoft-Antispam-PRVS: <BYAPR12MB31270F50C205D11AD78F4A0ED9369@BYAPR12MB3127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7RLGssz2RsAqyA+LhKVLhV/Sp2o+EnUi8Q4VKAvuq4cU7fXElg2t6UMmU743b9WvI/gxxaZIucDglpgADbT2Z7XqwiDLRMqzEAtkJBgAOWRK8Qm6O3fYtGGeICtbo2kyxjms7T64QeWy0BEcCEithOL9crX1WWtOLHqx/pcXy2mD91Z3s6SEgBhlPOIzj2irAvgWyRCEFQAo0StTZwb1g3Wx6zleV1fMWgh3IGojgGRHHNEiUeDHrAhoqax8MWNXaTL2vKtpjLHTwtFHLZDjzJwh0/t+LD6uAds1ltGsXJJcqj0RSyxjlXZEkwhsofU+3dnW+E15AJvPnRbG6iftRJCVRAad+0wpMiJ8ebNXaXosRAk71P+jJ3Q71p4ejCtXskJqzrQcubTfCOYykD6gg4I4rZdbSeCjjii7A8o3utaZF/lcyc6IcpObnzjmAFRbegdkEGzhKKTOJfwcdlH5KOIdRtk8IVocqKmavEYwH0liCkPhd5JHreRR+YLZ311tqFJS+bQNu1DYwOsNOLKn95n1Rj8yhrUYiJgchkCo5fnDzQXxmg9pE8SnQqz5EGhul30LvCU1h5I9QZTznMMw91qnZs5Bjp/Q5qeGjD0DBdKAq1DMxrL8oYnLnC/8ddKrlOoAOmGSaC5Ci1nctVYKjUoHBq/X5+Ui7VxqVyy4246DPvFlEGFTxEr4v9it4oUKCldbo5kjfO9OEhNmvgICLC7AGUZ6XkK5HBEPW+vaC7uDV7hYF5gyi0Twzoy5pZIAFGv8UW6toz69+rSk7VZdw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(6916009)(108616005)(24736004)(82310400003)(8676002)(356005)(336012)(478600001)(8936002)(47076005)(2906002)(82740400003)(26005)(4326008)(966005)(7416002)(86362001)(316002)(36906005)(7636003)(70586007)(36860700001)(54906003)(70206006)(186003)(5660300002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:33:58.5692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ae0385-2b27-4091-cbf6-08d92b29b566
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:26:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.272 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.272-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.9.272-rc1-g5f3a05577796
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
