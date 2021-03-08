Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D80331482
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCHRTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:19:10 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:24417
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230477AbhCHRTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:19:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1iyw9tlqxOnk2mlx2PJE0qqJi/Q7j+nlcztQHPWM3oDsigYf7nA4x4v+RInpdbqTEbTGxZ8jy4sY1P9E5lM4Z/7ummP4AWiwXvhYYpKGgm/GCFCbq7TFknNN2AzfPD79FtakOo+7ppVZ7STq6d9Fv5PrI7P1O+h64yfnyyXG2R+kBSChI4Se/fLRxBQryVVG7+e9+ZnQeZQDCFFashWji1LoNtPnx3bjfWUMgGHmL1p/s5ZzgznZLW9kQJcXLVEmo4eqPKadVl1V/6stIrXy4XAUzelFe43MHBfiM3tYoTR1gFG8X5n3ZvBduuD+9Yeg5Vofdvn+kNZIUKptZkpfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCZi/1Twa/vK8rZBjirK5ZNmPrDg2vC/pKyHTBjlk6c=;
 b=kd6fBmcogHJNWjorLC0xe8Ns+/IQihqnkN6Od/PsdinhabB7wfa7bmEmV0HdtlY/FsMXCSqCg0Pphd5EPL/vB9RyU6HM3na7E+wAABqYUrpgIIMInhQnBa9zmalv8tGf7DFHnsYnDmFEXYJo8MTB0wkN+a4NKkv+aoRfoTdBjeQ4V6VJ27O/hLk8q8gziWFph7xwvFnutOxpBrbXT2sDJlFCM0k8kpBI0BX2+ZL+KdaIWa4Dkriq5zDftkEtKsx7cdQ3eB/2hVqp1jQGJ8/9jUou0cnPHvUrUNQiN9tPymUAQfPKZMhWtrvVkfZMbCpOqOOp74Z1mGwl99H8pW2rCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCZi/1Twa/vK8rZBjirK5ZNmPrDg2vC/pKyHTBjlk6c=;
 b=vW5GLAGCk6zK/7RQQvVGBMK1yljpxf8Ya6fwhNMyTpu6qCubt5e/Fu2HAHRvkVfff2IlzXs9ANPILv+9AfuOKa2XKysFVJNpm0Y4T7pUhgU9JQCI5YTImfXT0BM7ZDY7Tp2NGAv8pla8S9I7JjaNWJ/X4zTnZtkd2laHvJKRb9Y=
Received: from BN6PR17CA0058.namprd17.prod.outlook.com (2603:10b6:405:75::47)
 by CY4PR12MB1687.namprd12.prod.outlook.com (2603:10b6:910:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Mon, 8 Mar
 2021 17:18:57 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::6) by BN6PR17CA0058.outlook.office365.com
 (2603:10b6:405:75::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 17:18:56 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 17:18:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dc812c8f3e334ec488891435bba94386@HQMAIL109.nvidia.com>
Date:   Mon, 8 Mar 2021 17:18:56 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee33f76b-ede9-4db7-7a69-08d8e256419a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1687:
X-Microsoft-Antispam-PRVS: <CY4PR12MB16872D23B77FFA677BE2FEA2D9939@CY4PR12MB1687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DeNGToIVBsY6H2sOeOBn6C+fbCQQpF9RXAbtqK5HdWDHIzBZYeE3rEsv+KhcFye6LZpR/D9SshJ7Jnx7f2zFXoXN9ROQ8Mr9jss4AR/1/uJpP07f/ZxKuMQJRDSBCyKEXe+Xtfygi+m+7M6ooB5D51kbFrfZ9hue69D7GapKnQmsLloRUM6RfAKPAE0uDIHqGlKJAiIayWSLkgrxnweHa1IoHJvuVn7JFYw2JFV5ZWyVi8ghhtxMd+UB1XkTVZ/LIcpG3Z9VwGSeYqsAJTlFVeTOllHnydqeuPbqT2bpt0O0qqsufEGs9JPkbUtZ2O1L1kjLKFlacYDQRX0ktw8fcNU1hm/K5d2i9+GhdGe6u9ZJFvQG/WIA4TX5pWuPuz3VvS+1D4opB5rf6VBlRSHtWderrbuVHhb+2tQFFG3rnicnyVMOP17/i4kFtmvrJH/IAc+l0DK57o/aEpWEfmtuqrVvfnAw4JYSaDQ7W/h1krByJ6QBOXYABM8mO0V63O0Rpmx5nHMFA7V5/hksp18p0DsvyMjo4qtCBREt9FrkJrCN77Pf5EWEpREHeOG7PXGnY7P814+xensqzbimGR7BrWRRSZGv1iPdwZtxNwPIQdVB/5Xm1h8iYMGdpjuSa9RdhNJIMBRuoCayXgd4eDiX+d3KYODca8JU4IWgo/iovSjl0HlxvPkmqz4tXK+FKz5ki94y61ocsOn8zGcrDfWc3XJklnt178B9BldH6u+lHVx6X5HhVkKJlK4FFSBBHV09U2gkhDw7yEv0p32WAd/+JA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(108616005)(24736004)(7636003)(2906002)(8936002)(356005)(6916009)(82740400003)(8676002)(36906005)(86362001)(82310400003)(26005)(966005)(70206006)(186003)(70586007)(478600001)(4326008)(316002)(336012)(426003)(47076005)(36860700001)(7416002)(54906003)(5660300002)(34020700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 17:18:56.6953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee33f76b-ede9-4db7-7a69-08d8e256419a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1687
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 08 Mar 2021 13:30:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.22 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.22-rc1.gz
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
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.22-rc1-g9226165b6cc7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
