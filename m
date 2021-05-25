Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D05138FCC8
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhEYI3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:29:14 -0400
Received: from mail-mw2nam08on2069.outbound.protection.outlook.com ([40.107.101.69]:14816
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232305AbhEYI3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+Q2r0gF5pGk1V7WOq/qsmED/Kve+y9SlM+9lsLaiM/r+pxRTeTOT0lM4aKiDaJ7i9F6QIHtEuZl6G22z62TMBii1S3ZD0nPmH1t1mfb4XQGPhgxIR1RNt3csU2dj6fxbahs/W0bFzvFi7Dmv0W5lQ0wM8uj0pCu3OpRYXBqjivBM8uIFc3wrLGaiUUr8iUJwb++NbaBpBbClJe+t6A/nvfGn0ifsi8cKiyAC6kzvUOUIlIJ0OhE9Ev7o71wQO3y38ocdyB3k4FN5sba24hjYEiwc+tLzQUuYIqdB02mEccyoFJjSTAcou2ePWfiEcVL6oaGSJGyb54uenYCbjvBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HLT0WkWFM47l81Y2/pnZCJQki5Oi7bsIFIFKH3/++M=;
 b=lCJUyQVOtguOXL3syu07AJjPdAfjOvSAW/qt8VTeBgh7iQs8sOkU+eWxbLZ3Nbba3zJuTtSwwGLZWv27Ek6ZAQwTiO1oAJPvM3nSojYV7/xjIVyBvLDEGmQQBfskfp/GWwek+eJxAS0ZDxqtHd6B+Q4MQW7ELp5Xfz1afnZk/rox7iozacw5RLBzmr9B1nFDWH4WRxWh1KqFlm+L8cSLrShDPfCpt24tlXd9VGPIglPe4JDI+QvfPeJTMozsWMSfW/IV1mC1Bdrr22uQ0Pl65GmvizJPrm/Trw3qFyy9KALyaHtpCHJVxR9ojO+RBOkBmYd8LNtUzjJMmU1M/osDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HLT0WkWFM47l81Y2/pnZCJQki5Oi7bsIFIFKH3/++M=;
 b=hiA7z0IcrBWtHEm/bmiVWNCRRVNOUItZq8BJyXLD3NN3m5qYrMwtW4aHlPIy9wRZOPC+VSuh//AaGoyuZS2Fm6Dcu0TnBEVuXOnimoRwU/QeDaJ5YRqBMMwnqUERvC7+5PV+DCeABBi3+mu4M9HpNQYbnhw9mMJ2PD9zJomqtvApRWGea874j5eHP0klfhO42m2M1hrbl+NhU7x0gf7YT7Zkp/8yZTJs7oSEiJvTsd8RsZ9J8e7MJ//Fymq24BsMHpxHSYEfnN+KQIh2yj3UUZzq1RUZI+J+ClyGffvN4tLRkaJDCNWMptf/ldme/ve8fpviskeFzQZtF8G+xSZYmA==
Received: from DM5PR06CA0054.namprd06.prod.outlook.com (2603:10b6:3:37::16) by
 CH0PR12MB5153.namprd12.prod.outlook.com (2603:10b6:610:b8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Tue, 25 May 2021 08:27:43 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::19) by DM5PR06CA0054.outlook.office365.com
 (2603:10b6:3:37::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 25 May 2021 08:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:27:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:41 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 08:27:40 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/49] 4.19.192-rc1 review
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <05e73854c3ad43ec9be677e69288f123@HQMAIL105.nvidia.com>
Date:   Tue, 25 May 2021 08:27:40 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1a30a77-70c4-47b5-a760-08d91f56f68e
X-MS-TrafficTypeDiagnostic: CH0PR12MB5153:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51530B93411EB0BB11F5979AD9259@CH0PR12MB5153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1CWqMqS/w8k0XWfVLdDgjm4j46oK3GBxPZVRTwGI2eEG3ToQcKiileZVkPCjma4ZQHEZ2pRQmaHri9kz8g9RvvELJgf82Gngcfd0RhbudPT8YnpfXhibCf+8/saAdUX0VCy0t8dpR6K8AMk7vApPQzkDFJfKtMuWjG5P1nYjVz6L5p9XvBvyVhw+haZ1DL3kzTTD2rRSpqMUsijS82cTWKdK/JFcYDiXi4X4r6fLpHIHaQPTUEXelalQmNi4hGXTPAV5K5xkWa9VKxxSO9/kvrq+lLLnfgaioml+S2l9TNMqRjkpOrnsBWK+b5Jo9CStApUyycrfpizGcxFkhi23yoTCe0kDPAnYmYFIJGG6DVhZIsVVM0vytx5EK3iSznAWUcPwaQleHwq/h2/FsEGbgc6srp2G9TS2L/jPYNu+m0oPSxzWjcHOeLHG8FNHg0jTTl14AYZ7UGkRmq95Z0sghfXcEJJOdWQZclbXucT/4eTVeP7mJlXlDu/ImF+oMYBQ6GfQ5FKCFr38Oxt4O2xt29Z3lA03E5tEDWTFtx0xTHwX6gQOgoUL2SI4xnnkFdaxavyyDUEJTETcZFTeybpXOhdNQZbACkttL7nRXRl3TYbnp5KkvFDwtUZeo6aTZ4jgyvB5OTfWhny0ZwArYDplX3t/MdwZn/AkYmFIxJK+oMFLbssPWnGyADFEH82gPWBdUexIxsscO3UhCIMsOktgbSONLt0Ewzs5kTOHFlx2s0JJUXUafWyDRYUr+BERo/nVPVttkk62hWUa3Jwi11rzQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(108616005)(24736004)(82310400003)(70586007)(336012)(426003)(70206006)(8676002)(5660300002)(8936002)(966005)(36860700001)(186003)(478600001)(2906002)(316002)(82740400003)(356005)(54906003)(4326008)(36906005)(7636003)(7416002)(26005)(47076005)(86362001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:27:41.2669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a30a77-70c4-47b5-a760-08d91f56f68e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5153
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:25:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.192 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.192-rc1.gz
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

Linux version:	4.19.192-rc1-g01268129ebb2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
