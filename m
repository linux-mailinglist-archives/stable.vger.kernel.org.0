Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEB49F816
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348120AbiA1LT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:19:27 -0500
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:6720
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348078AbiA1LT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:19:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iK2Y29fNxSBIoYUuYnlXWRSyU5x1QD93DYYV5UCUPdKaErFofzYJiG0Nv4ZbpsMSu8DU2/+YngsKvtMEiyQpEBTnqB3z6hNefucO4YkyXVJhWy5HGWG9x0Vy/lbu0B/xGeZ/KSIjLaJdFTVlforIMyhFKER8LHfevhxkWl0V3rpe53SZx8JlJVUthXkYwH3u3rntMgzcCIdGDfd+rF8Fyj2w2gDZlPvGU5fPj5bMs0D9VSbGNfKGr7hoK5S43BTbcTGls6sv+qPcTAagiN4jPQjIT+qEJb/ZpCZROO3hCUFeZVMAFGyRT0YsPegZf6Wu5y6bTU1O38IB3UoyioKY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+y6ZcV4MmcKRVZU1KTgTvSbfsBGHpfzVdyWRI7zBoQ=;
 b=LNhFdi7Lzl6H/PYONVmQXA5ISP+23gChSs2fm6xtRaSC9FSt6NGtHfoXMcpCzCNHOxoqQo8j/eGWI/YHkc8120oVU6AhxpBT8oLK9jbgASGeOkswBiZyHk6IBenN6I2H5oAaXmHRzghhJScGOoozsZUZH2gTT6x57JKeNd+DBPEJTrWnVV3vTTwBuc3U9Lhk+ZYYqt3Fl/UMGZI7UbU7g7ad3Zp+gfi9UuyLdX2c/ziXInnWgZyEbIvD/JFRF+scuguwSDmkrS30FdilLDGjngXNsM+G7f3n6vIwY3or1zdft5XUab8MKspSxQm4RXQsCxKt0ffTYzaGpikkQhGjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+y6ZcV4MmcKRVZU1KTgTvSbfsBGHpfzVdyWRI7zBoQ=;
 b=mButCiiIAfFrGCcnZy1YxaaFK7AexKDqZOrrShG1dbONBBkW3onwE5jJBntpzWiHmmmk2Ba2m7EBnJuwl10q9C7Gk5mxg2/GyjFPfohEMqqrMCbV8V0HpPiKaKFZv2wxcaT29c5seeTPEN2Csl+nWO1CmH2A79TZAoX2NK+W0rxQ91gaEHxJcrkiHwusbK1guMf87BDCVWGThGIQIYEn+DET5ZuSzBeuhsUQa4EgHn9Q5ndXTsKjhX1aMGUaeh21oAG05XzpAVaqmW7SYmz/73SMkxn87n6wxT03XmlVCub1tndghfnn54pwI8a2inZwQkxjWc/0VOyaH7qnQZ6Gsg==
Received: from DM5PR2001CA0016.namprd20.prod.outlook.com (2603:10b6:4:16::26)
 by BYAPR12MB4789.namprd12.prod.outlook.com (2603:10b6:a03:111::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 28 Jan
 2022 11:19:24 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::d1) by DM5PR2001CA0016.outlook.office365.com
 (2603:10b6:4:16::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20 via Frontend
 Transport; Fri, 28 Jan 2022 11:19:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:19:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:19:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:19:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:19:21 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e2237d00-f542-495a-be4e-a2fa03f90c19@drhqmail203.nvidia.com>
Date:   Fri, 28 Jan 2022 03:19:21 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a2d2735-15d0-4734-04e5-08d9e2500928
X-MS-TrafficTypeDiagnostic: BYAPR12MB4789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4789928D32A5E8064DF7BAD1D9229@BYAPR12MB4789.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xf2v2bQWxrlSB5p+k+vO/THA8QqFb7Rjhf9jMV3noLfKMH9MEKPX5JvhMS63AQhpFDYlT+fD2Ovwm5b0W8IgtjB2JEwqG1yfIzH9Y9yl+OcIrHKFQYpILosvzGDBxBo2NxOzo76mFH8biMoNMEB939cj/9cJLeAODU43VBserzra2cAFmfFzidFh2cH+bbXU55Z7ZPXTedfAWYbbJnKfSe2lwAuKbKMCXiIs87plBkhlKQ3CBD8+zlTM4yZccSf0iVjLfolFizxXjG9yyNB/ZYC35ChDlbq2C0zD/f1s6X3djKuuc/Ddx8leE5F0qfg4+rXqz4Op2r6G9v44NF3GKK9TJ542SwJU0gpJywCLOxWUKPwGwAjtZRWJ+jePpnzH3kYxLK/0xnNnQyKkPmO9PvwpvA/hMX7YUSJmElVaO7BKTXOT+bg9sPT2nO1lmmebftoiA9unOXM0nt5uzD/t2991eo0zcxZbfYJqAgTyhZfPz36fUWQsfNHe0ILvgVp/2R0MjLZfNZqcn67uhph3ob15xvwBIlFzWNDtwnj5oc4m4QKBwstczi/WM4d12xnBB+7Iuf6JcS5O03CwNnl3uzVbB30Xtl1DNX/9/4PqXXeG7Rzcm4jEeMBLCpZarTXtj0W8xCvoammZuMjvXaO9eJQWlPXsK+Nw+PU6uJlmhUt3lHA40iN86wJ55j6z7pkBE2sg4QPv47u0vN0JmzFqwa9dk3aWGhxPnSaxnn9G0s1zxljgKBbIgyKrpLDv545GwtSJVIs/R9yvjj3ULp7tUFDVFXQWanASHKrSdirRQKS8aHy0uq0nL7atl87Gaq2SLqSLKV+UvAd2rWjgoyDQMC9KaqXiulrY3QJdvtR82Ma82piERB7+A/cnAgyZcicY
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700004)(46966006)(40460700003)(82310400004)(5660300002)(47076005)(356005)(36860700001)(966005)(2906002)(186003)(81166007)(26005)(54906003)(8676002)(86362001)(8936002)(70586007)(508600001)(7416002)(31686004)(70206006)(6916009)(31696002)(336012)(4326008)(316002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:19:22.7420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2d2735-15d0-4734-04e5-08d9e2500928
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4789
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.175-rc1-gaa3124a3444f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
