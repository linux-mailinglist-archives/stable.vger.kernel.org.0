Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47229336D67
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhCKIAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:05 -0500
Received: from mail-mw2nam08on2044.outbound.protection.outlook.com ([40.107.101.44]:61124
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229895AbhCKH76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 02:59:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK5U6j8p1QufTU4VNcbT7B+tPT+yLfYSFSr0tIdRF8jsg0eKB69+Ji5SUY106Cat1UCNQbaUKkkXd0L1x8AFrTmsXJ9Fu+g4oRBkINbdH+4dx1kFQAzT2gxJRtvVo+JfgQe6ejSe8HXevccmMQWHZT0Q0lpNGyjF+eHPC3NR1U5KcjrzDwkR+Tri/FzKxoX8D/Uhownij6eP7rgUPvS7CX2q7vForGzVDSz37CXsI3WPvLZM7ZyscFTcvoAUJoY1/D7Gfoy3vuGEF3gR66zRaAae/8ML+yCAyzeOVwB28XeeX2/ZjB2eoAGRfU+riJ+mU1qNl7Q9akAnK08BEx2zVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXsQCjCkTStKO8E0YYVh99uCfMZ+vA1Y++5u0YqkjXk=;
 b=KRVaqZ66S95+Y4CyYkEm3hks37AWfMWzH8n5InuwwFBIFR5PWDM8tMQ3Flw1fHkzE6h/EFnJrkk0Aj+9vhocwxOtVsYkGTvDKUGZLqyPtSB8VIyY1ru4CiKV+IEFQ0yKCzdZ0oaHrO0/pBZ1FmGPekFloKAJyjlZOkXk5/sZS0RUMxZzL+jWKFddr5ZtsDkSqzCPwK/KqxDg6OtaFP1lu1tDL71f66Fo/ET9aliCi+bTEoXdx3r5a36QbLspSoZrhgquUUWr/PR9aQ7Yb+QgHs1jL0orhQAJ9X1QXTaXFcVQZeVEignEsCqv/Twxv/RXcGvHSGSqjC3gM4mSF+MO8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXsQCjCkTStKO8E0YYVh99uCfMZ+vA1Y++5u0YqkjXk=;
 b=GVx4GLi1GIulterb7Gxq/Iq4tKElknq7+p0kqA16v8V/TxIecAuxOFcZDskr1P2Qm6lWi/ctAA7vJBnmiz9KOSKu3mlNVLEnX2qRSYc4f2iKWKfSFwd/PWM1GYuNTk3ufHjqyjoVBRFZ1G7pqiI6BtRB4l4SWvX+hIQ2bb15eJ0nFZRKAu7Pri8VIyU4Ie2zZyDLfGuITwetWli1gCNBc8W2ohZ0JaY9SXvWLg2wyRcP2xFDYM9PrcDgV4Vs4bUjPSryXHU9jQKxrmTDOwr632bLxZb1162Obb6z11uoPvd6HPYQQSYKmOG/k5TKfvESW1V1PutXtuZwEl6TYto7Ww==
Received: from BN6PR22CA0042.namprd22.prod.outlook.com (2603:10b6:404:37::28)
 by MW2PR12MB2394.namprd12.prod.outlook.com (2603:10b6:907:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 07:59:54 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::1f) by BN6PR22CA0042.outlook.office365.com
 (2603:10b6:404:37::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:53 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/7] 4.4.261-rc1 review
In-Reply-To: <20210310132319.155338551@linuxfoundation.org>
References: <20210310132319.155338551@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f76b6d46055247f286f0320442d71d0c@HQMAIL101.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f40afb13-08ed-458a-2663-08d8e463a75d
X-MS-TrafficTypeDiagnostic: MW2PR12MB2394:
X-Microsoft-Antispam-PRVS: <MW2PR12MB239415FA570BBFE3B80E7336D9909@MW2PR12MB2394.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Esh7j9RTCg/NG5hAZrbEzoC0Gd7oUyPkYCGKMW/JcguzsZxWqA1eIKtLLrYV0AIOqpuRx9Kmuu0YlL4601Q65rHm0dxCLXGe3shKpQ9qaJ8tNB/M8eI9LiL408yvnsckbyLZaZ8UgSXv7qgVlxKlcb/8wr910k+yiSF0C0in3lLI0TZBDPD9II5KBR/RzkQvXeIQa1Yvpa0u6NQcDAFs28IPx5wqiOwnASVr9EgzrS39X0kL3CA99433kwhDCkLTJjl46o82gQmpwU8UUJV5S9zaZ7Ro2sqTh4PWx37Q3FE42+gx4FH6mF+fniNm0JVXNWTz6D7Jh7Q78FgemOoCjOEenL7i82AWuFWa4Bi5JPFTuN+7Xy6dyGpXx7G8++b86dfyAQ2rnCxK0M2CciYxI+t/vRkPlTLkgSedgiA8HTf4O7DLKOOYEw+YtDoV5dG/mL6ipxpeDV50jBa4YeLaR9PxVcI+wbFvjHLEGQA1oQadSHuikAg3pXFHggKuIfi7VBCVTJ6m2ZodiNA2W+8rmWnqh0fDq53x5CzA9PkqUQ+ng29ZMShLZ345J8jZ7hfPCZVPWEOmZdwHyqbr+UJpWKRbZpK8j+2X6x+hf20mvO4wOEWOISSJExuXsDLrP1WsnilOWDms9oL2seNZ8WUWNXNQU0Z/gYP/TeuntsXC6z9d/RH9rD7OOmTlr6/QdDrDxGse77IzQNSmSOejPKHJ88/Z9HLpPKY83U71N0kSKs6BMaug7Jhxe90bqoyCFq1ksQMBcvPjnZ/pGt3ttNC4Vg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966006)(36840700001)(24736004)(966005)(70586007)(5660300002)(70206006)(478600001)(86362001)(108616005)(8936002)(82310400003)(47076005)(54906003)(316002)(82740400003)(356005)(7636003)(8676002)(426003)(7416002)(4326008)(186003)(336012)(36860700001)(2906002)(26005)(6916009)(34070700002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:53.2141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f40afb13-08ed-458a-2663-08d8e463a75d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2394
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:25:13 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.4.261 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.261-rc1.gz
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
    28 tests:	28 pass, 0 fail

Linux version:	4.4.261-rc1-g9de32cd2fc51
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
