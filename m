Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AE737EDAA
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387933AbhELUlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:05 -0400
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:37856
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344845AbhELTqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:46:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuSW5y58urKzqdVM69FRwo0G71gylQCCgtualUk2M0PTEVy3VDmA1nts3LjVNuz4Y78agEbtew5ZJYaNsJlaLfJ8KDRsUyb8/F+Wrh/HFuxIKSfs3MerfK2+nGjqBpYKNjendtAaECnOFReIAtr6rUKF5Wh3PhdvBLZ+DRrFK4JuFXRlJK/a2cgO3oiQrC2aIrVf65UcswXZvxHjzgc5bYtYg8bhqRQ0AfBhal21Lwp0QPCg0w6fQLN1hMWHQrep29Fz6BZ7KrfHQE/yKNXY5wkH5PQ2T70+LJGRGhEdsOFn5Uo5w1M51tq9GxzMoKR5sfJD1kYh1sIDWjITlqTwEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6b8z4Z3pqUV+3Ovt7vqRxqMSV5yczydOPZaVdaRRaG8=;
 b=JNyZhlmyrCWAqWtAM+oqksyc27Hr/2wq7A4O1CiyqqdAbB+ojXAKr5qiySr+Ypi3rXoBMWAHWPqOg+1m+9oE5ne4sodc3rQwJV+n66+Fl6yCwRwSVEerg/yxK65JvT69P04oBYJMhiDTsYBnvqi7dwY8NZayb4oPKSYwbMEKeA84wvUk/7Mo+LX3bjAThE1O97rApCQ6sE0UZHz3JW1VVERU5uUduXeAe4x8NIOc7ZZ8DHVPjBecbnQr3Da/8b+7aeT1IZpI5UsSiFZCkxYOJ8aiKyYr/X5fE9L7IpepnPlNe1bjQd3EVCctjlF8HQ4DMHalnsHUBuBenMP1C9BzFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6b8z4Z3pqUV+3Ovt7vqRxqMSV5yczydOPZaVdaRRaG8=;
 b=qxm16VhY61bakL7jyUhRc1DoW8CbAK11OG5AS+Ervhnnkjs5v0bXEQa6f8uXNzOFYTDSAs9s1zHiPFIb0B5xsHRUTlr98lgPAG8aexM4EwHbMRL1UJicA+ihyr3Xgv5Tc/3x3Obse+PITj9l2vL74ETzkWz5GaMLdn2bJrFjqfisGdB+DtV3c2OSdOtUuPnEJkiV+76FFEtONM4y3aNBa7iVjjRitcYbvIYrTxpl4g/Ru3j7+dTxRz7sc//yOyYrU+2piKD6shdqrY5/v481jB4UIfqTAYfL52c7FAhG9e/WKIy0+nugr1ufNyflm4VpPuW2VuFYALM3zfuX8t+kow==
Received: from BN6PR19CA0106.namprd19.prod.outlook.com (2603:10b6:404:a0::20)
 by CH2PR12MB4120.namprd12.prod.outlook.com (2603:10b6:610:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 19:45:28 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::f) by BN6PR19CA0106.outlook.office365.com
 (2603:10b6:404:a0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 19:45:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 19:45:27 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 19:45:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 19:45:13 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/601] 5.11.21-rc1 review
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <804c13dbbf4945b8894aa626bb54b8a5@HQMAIL111.nvidia.com>
Date:   Wed, 12 May 2021 19:45:13 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c76035a-a5f7-455d-c856-08d9157e7e7f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4120:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4120D6BFD1729B127C9C8C44D9529@CH2PR12MB4120.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJq4M71WQM7qm6+nMm85GlR30QaUl7rPXxuhDz7QOJKO3nlzYDxkhrEb8nykgyjPmibJqZnHcKngFHX7U+0a/nECo3BkBc2FTnz2v6G0v8SBu0kAnchFE7YWs3qCMb8yYIcDEbA62hP2X0RYrKNa6qypLk7PTbXAzjtcu9zE8cZ5EwnXQNIAGdOOp7/KV+qnmhjcEbC2ffg/eMIAOxnP4E2IA147stpP40FTyiVimrKom/YUsN+Kj0DoBbmcIQfvzqx++UGM3oXJ/DBHFKD0L0d/MThXu6icRPq1LNt1hBGIZsLseM/IhyrKvJknAW0lDuVAEgFePfAPuSaEa2O8KTAZoMZKysSrgYscuVpvRN8QAY3aq0IAFkMc5gNVPnK7uLu2jfaUzarUznOR+qaB9/rwYNNPERB3uVbDEr3sBNUwsXWmyevp0U1YcCg5YtEUCZa+IuAABuy+SDgCU7PccF3FNOzgtspV6wuP/diBPnMf+FJwLM5/b7z63ovJNI+TEQFs2pltlOE4wrsoJdoUNvFDKtRFaEQo5SlwTprH8qju+X7CXVKYx31kxwQbshYJ7VnEAGgyAvIrUix4FHgwih6NxgKRbYltsWZ8z6ecmXTggIX2O/KxAISVPEGUO7vmlCLY5qGKaoYkmc0+CKsqREC1ZhC57F3fBIYOHWOwHN0vvNi9VxQGV6snmPmLTc10hDoDOrmJT99I5zNtp+jqJEcNeHCv/w0cXHe/iVUuimk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(86362001)(82310400003)(36860700001)(356005)(70206006)(70586007)(186003)(2906002)(966005)(4326008)(54906003)(6916009)(8676002)(426003)(36906005)(108616005)(24736004)(8936002)(26005)(336012)(7416002)(7636003)(5660300002)(498600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 19:45:27.9723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c76035a-a5f7-455d-c856-08d9157e7e7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4120
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 16:41:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.21 release.
> There are 601 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.11.21-rc1-g1ec08480ab87
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
