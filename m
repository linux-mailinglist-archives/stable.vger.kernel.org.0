Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6035C73F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhDLNMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:12:55 -0400
Received: from mail-dm3nam07on2060.outbound.protection.outlook.com ([40.107.95.60]:2624
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241706AbhDLNMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 09:12:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMNtNegT/kwg+efEzCJb4e43L8uoOFVC4A/+PuLMOVpB+y1jvTE43EbNrbQNf0cn9yachqo9StZafW4jg3RFOv2buYODvba/iHU1Z6g1/ZXwfa5qBrKNDTOUiXLJTNf2CZiy6rp5I35yojxCYeVwnEWkjmPFEa7nrael7THw+oC6iPJb0aE+s/gLemsgd8AsxeDBjbTPh5Q50keukKkkLgCJ5bDvLaXFwABzAuzDEDyrAuAR6NUPHLRr5zCY0zX4jpaE5MTofzd+gMxPWdaNeCscgIyFgWt9MU4rNhZx+GUIu3jT8xpzhKndMrYTAVkTR4d/uEZMlfs5EbVUzYM7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3pSW9F2qXibKjzDUUUqb/Y0FIq5g9lEp5lHH2O3/s4=;
 b=fcMDbhZIkCLp98K90bhPCjKNfP6tIA8EJGcd5QPEQPRF4iRg8lwGjT32qAgFgwa2PkD6HcR3I1hoRYITTI22b74lI+cVQaQ0+S4cWhheN5UQdQF94leJuS+zZkqGm5r0Q1jBNsh7OwzH4GZ3u4AzcMf48ChNp8cEy2JuKwH/3yxxnFwQR57ApckrNSmAjqxjUlNX94IIiQXTxsBl9tcfSKQm8kRL+EWFu1ArpJ150WBm7GRH3cetw5L6eCrfBEX42OZ9kQ3mLixbUZHzB9hpVo7UTF9YsUL9WOU8gnyelhR4ctWVPW6gZREEh8/aA0ddUEarwe1fwrhh7gNlH9uetA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3pSW9F2qXibKjzDUUUqb/Y0FIq5g9lEp5lHH2O3/s4=;
 b=lBJ1NGmqpTL9rQAe7Dj2jE3XEnjmLZ8z11nvfqWqZPPTlfYe5TOq8At5f1B2Uy5M17nuTlXc2qKyyvGYBnDD0J0F++2GofvDASf44/DOPnKNaO9OzhfqSDURlUg1rQTRT/DvRBRfaGWeO1BhjdMXMJqQmhoeBrfHOGnn0Vri+IS7G1BIGpCkcm0LIJUt1AnAoSyl8YG+LBt5vnj6+AWxy8RdRf8tzapGVUBCS6K2ePlPWmm5x9iV3ErMQCOYyvytyaBgFvu92Yk6kG71yNechP8HnbjeQkhTCCWlIzACTSZ/6EkVVS65EGiJ0m9KuhL95MeVr78cb6pykoe3JNZbBQ==
Received: from DM6PR18CA0034.namprd18.prod.outlook.com (2603:10b6:5:15b::47)
 by BY5PR12MB3650.namprd12.prod.outlook.com (2603:10b6:a03:1a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 13:12:32 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::df) by DM6PR18CA0034.outlook.office365.com
 (2603:10b6:5:15b::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 13:12:32 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 13:12:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/111] 5.4.112-rc1 review
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <27aa61ecf8d345e3b77c4a6723c50bf9@HQMAIL105.nvidia.com>
Date:   Mon, 12 Apr 2021 13:12:31 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 714460bf-3bd8-48b1-b659-08d8fdb4a1ed
X-MS-TrafficTypeDiagnostic: BY5PR12MB3650:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3650DCDDD7450E460169E9D2D9709@BY5PR12MB3650.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgkN29/KtpyFv8/mamM3WIZxo2cm/FBQrY4Rh5gUoW0hX/L7e1bmXSqLVSRwOCpvrwII7ubMMxdSs11+S67rdbt0TvWqG+ZEoO9WbAQH5AZrEbNAfrEkHlKDuitOSMqDU2hIsaNHBY5hoQK94a0CMZ/E9O85KyUq7h0IHJhkbxHKWzTXPsyJ1mR8B5zHtRpsSeDFsQl8I8affbdy2eWvAJAIBPvlfhuW/pe2aKqtOLRorDfFwjr7fT3QuzRcx5n8pH49iSY4YQBzoZ3L0knm+tnyEblCmfKUydPdxzKnCzU6ph7FRomZH0o1FMJfePRM6TA1S3ALmj4XQqpJkDEi4uN5K2GxJVvfcWYUqFD82S2CTOLHSkp1tFHyhhan/184xJ51hqh32zcQH+oE4kPP6B0WvuBayEdqWMA0yVqmEdpx9H/i77orkePu39Idzjhu7LPukT3lCQsGiuhYqTFydhKEqIY63PovDIUkc1eYWY6F8QzLvJEhCekVjLGUz7+MN5uqom+7NrrSp53kuGSNJkhsRmQdjD7z0k/tijNOi7QBXyub6TgXyVobfAWDZiBMv6c3ZaHPenvM+d16wumjA2rqjnJZHl5etIZKKhjx4G8+oE4+qDlpExo77YlrbfZcofZDU+AzFbVYJ8ejssV+F2jLx0z+e+Xis1Kx6GwA4QfQaEuFbYAJQB67on0tQuORV77srsblzY5HvJer3av7xN3s3KfM61BaHXUrw9Jpzk8=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(5660300002)(47076005)(8936002)(6916009)(26005)(8676002)(36906005)(70586007)(54906003)(36860700001)(7636003)(2906002)(82310400003)(186003)(7416002)(478600001)(336012)(82740400003)(426003)(966005)(4326008)(316002)(86362001)(108616005)(356005)(24736004)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 13:12:32.4506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 714460bf-3bd8-48b1-b659-08d8fdb4a1ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3650
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 10:39:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.112 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.112-rc1.gz
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

Linux version:	5.4.112-rc1-gf9b2de2cddd4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
