Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4599049F81C
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348144AbiA1LTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:19:46 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:44768
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348140AbiA1LTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:19:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZu3iovMTV/4b8dqQ8iHUe48g3XH9B6dxszTJkC6SW5KhOMrUSwi0OrwSCM326cxmabHOkNMJ0XDSzK1tGflZCOdWele3Oli3Asc1WGrzD7zIYLy00ywVC7DFeHBtspg0QsMBhH2GxcBU2DbjDIPN9BZSuAyhvbHCaVt9VbnYVuB6AdVWFqv42D8LXW2FkfCgRVEPOqMXq/T1hn1JV8HJdPM4hNYoEC5TY47Y0/6jl2L/jcjcBe+0G3JnGxCTmhuf8mkCTi2F6X65RIWML16+ER/sBc+2RsfyGDCJ7s1U+ahOtxLTINXkGfaEXGPYGNujTZwC9CKpFPb/3liABo/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJExj6QHOMrx6j+i7JosIfiko/Bdu/8a3KSfhUaSjDE=;
 b=euHpVNNlkMZ1cPibL+Li9bKJFAXbiTeMFz0bWSOR8B/KvSyeFuGTjSOO+WzA5GdnOavWjtS8Ppr/wySDkjuHZF74ZgUk+sjbVfvd5Y469cOeYW4+ySBMRD3WALN6shM2sZXpat+qezG6VO36Q0UbJw6/skdprGfMmRzSp4bjnm1AYjgOypc4GwMniREB7fkP311iRJjLfXgYU9GzMsbgy7VvZm5iw3FDFyhD7c5LN6HEapJ8deWxyNXHNnRynqiJRO60bv3O0DelB3S8QdFLDSRa+LcVfGojEthhGXo4TSAS3ZPAkY/dh6TX9ANcBysVAkq5eD5Rk26Mz66gZ4MZ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJExj6QHOMrx6j+i7JosIfiko/Bdu/8a3KSfhUaSjDE=;
 b=YtgXqXzKW/KxbtYrTuSxanaZJzz5HfLJLeFlTwyjV0KFr5m8Q36rg3Pj3uvbWNVnpbQBtJO3/PTInk4gl4jTpk3iC2f2Y/BoU2mSg6Z/5QJjjMu4k/3ina4FsWv3NYY0XxceG7qzKTxjOXXbfgLVX2AJxJb75gMriWscJ7phstY2PEgm32t/xIchlvEfABx5nbaKjxF7jlu3fhFWPdGe0xr+NgmMHTF0K1u/c0/G8CmOaTEVRm0h7ZuArmu4ZbjQdH27w7LV2w39piJJo4NYleulgj59OsCKG3UoV+8odkYYsxVJBydaR3NrqUcLGWHUvdaJB6bRgORSwAwqg2c4vg==
Received: from BN9P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::13)
 by CY4PR12MB1381.namprd12.prod.outlook.com (2603:10b6:903:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 28 Jan
 2022 11:19:40 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::65) by BN9P221CA0010.outlook.office365.com
 (2603:10b6:408:10a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Fri, 28 Jan 2022 11:19:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:19:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:19:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:19:36 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:19:36 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
References: <20220127180258.131170405@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d69e32c2-ca03-480c-a709-e6a03b001481@drhqmail203.nvidia.com>
Date:   Fri, 28 Jan 2022 03:19:36 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed1f3bc-8d0d-4c62-9013-08d9e2501277
X-MS-TrafficTypeDiagnostic: CY4PR12MB1381:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13816D4B51F5833B30BAD54BD9229@CY4PR12MB1381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: an1Ax0ycmf0SUrQ4phmp0tEJe/lsGNilloNF3CdWsVoIfc9E6pBA5IL9PLE6yHk6ePcRS57A9Nbae9gnh0po3+a6tdraPcg9/vbDrob8YLKsz9jhiVNu4zWi5yIXex1dBMwIDcf8DdfxVScZgv3wPMS5hZxm58XbdljWfR2l8OE/WcqpZw2bxbQ2dN7Jn9TNEQqT9bko5lmlW63M7PZl2nLPFFqnz6DQ3LW6QIIgi6uSOwRX150mFh/4C4ancEJ1Y+JjlNQWQs3m36t00Y9q7pUjvVt5Z/OGFZOKqsuSN8kCcdWK65p5iaRmW8zBP61ygr5SRpGTTxOlcOEi7FsDmHSXAYouVkKZhF2ITA6p8rciIpn8wWw/5PKArJBWHFSuut/vnP/nJqElrDTLWZC3lYuYs6NXbQEzxAsT4L0vzw05UnIcOxpKxYrQluW1d8SLdJeiVVhi7u/7rhoRycEZwUXvd8NSxdBkZRwiWG5QWWqsNRiIVwpMmpJPpjK1Aw3RInIiDWrJNYUw3Zs2e1p+AbyenEIVzqNtBXrgWIJJM0eP0hECi4h+5VDTYjOuYdf0a3OrlATyJEW2cIsJmCCgzbOBF+Mtc+cLQnfiwIlrQaZa3RqSfsW4nJ/FAALr4B0ILNwdWyprzM+BftI8Kk5F4TV612hZgnSaYioaJ5rULhs0Nm3p6LRev76k2Dj2ThqA+PNv+faSq/LVj0W1Y0xr3yZ6t78D79SSIGGksiQW/loByfWanTe7mRaRh/luevnunQP5uHZ/iw1PiSSMpgMETwTkV1iGKAqIWHBvM7qTMEM8MMvA5ufy4xAW7QWzJ78NxYX+pYkqWGwBjvG6vC+tC++/rsZlWsnpVvwHklZ9dltCTzfRC3Vpvj1HJEO4ZvOo
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(31696002)(36860700001)(4326008)(47076005)(70206006)(31686004)(966005)(86362001)(426003)(6916009)(26005)(2906002)(316002)(81166007)(356005)(8676002)(5660300002)(186003)(508600001)(54906003)(336012)(7416002)(82310400004)(70586007)(40460700003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:19:38.3003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed1f3bc-8d0d-4c62-9013-08d9e2501277
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1381
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
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
    75 tests:	75 pass, 0 fail

Linux version:	5.10.95-rc1-ga2441d7f51b1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
