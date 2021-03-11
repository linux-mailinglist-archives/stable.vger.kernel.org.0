Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB398336D6E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCKIAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:07 -0500
Received: from mail-dm6nam08on2082.outbound.protection.outlook.com ([40.107.102.82]:29345
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229965AbhCKH77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 02:59:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8Hfu2jfEl5BvBwdcgIV8/QO2XpFnEbAgT+8HJO0iK35RsvYfgraznMs6OLMpTY2bUHPdtjrtpQmdimKSdga1HH38gH1basmFidZKUcYoddfethd4ztGSZ0sq1hkY9W6WVxWsIANRBxlZYo30LfqDvAxmpLOGWd1pEOlgwzE+2Sldj7ZbzxJ5UqpGYCFLs0Suz7f8pzeIoRqLtxCwRFVh1o7FBGMQ+pnU6x5iW/Pm2+FhDVzWffpra8KEX1pA+wX89YeEhe1iH9jYYUJnqCRa7yjri5R7biWXgj8zkbxq1/5lGpRtgpoWUvaNuOmAFAV1cJJmC7R1xPWD+JCX+ZEQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAIVxpbgJpPsTNVY2T8Z0p2u18DpavBIzBeyy0MX23U=;
 b=Kfq2gwHj5MRC7AEtCtyG4uJ343D/uhhJbUJbqYKAZwgT/UBrJOLoVq07Iet2ewNjWFugYGVdXw9mUBLBqPhI24QtV4h6a9hbHp2C8erZZ1A/raAGo4yK3dFcFsMBKBr+bTzKDTfCjZRqv4Opm1U0XuOh06+XfXKWKV1zua5v7aDhGUctFu+sTwBF+SrknCmg8Q3MekHn0fhpr89HVg0Xjrc1PBU9SHfM/bvD+Zxea/4wErGu4b78HXfQPqrSjc7teElQ3MujmUJPn/zM3p7JYsmjaC4jske2SwSZrulhP2PIcD/k94eAM5mAyS+/AozgCwiFh33vebc5JVPhKQQTzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAIVxpbgJpPsTNVY2T8Z0p2u18DpavBIzBeyy0MX23U=;
 b=NmHusQD43ZXZK+YPMxHSYXfvyfqketne9KUs+e3vwIrWo6C6DZHlCuxppcqCZ2a3Svh16MmELhUfA5lAtoxWxFYlbmORTQQiP3Ve9Rh6xCGQIGe5tXhG5vftLDzBAVy5np3emcYIJTkcWbZjz5wyxP+se899h5vfvqDUHpiXKwQcJkssaE0CYdDegZhNQP6jbJ/71dGwYjogi15+vBX6QCK2Z5AsYVZDO5Ww+C6JYCgjhXItQeT/Sn02coV4xTlmL0MiucCORD4HUV7AJJSGfYZIlyX/qCxw6v0fIaJ1Sg89TkLKrn+ihv23rPtZpmobEeHQ8B5TdHo723DIJ+Kilg==
Received: from BN9PR03CA0503.namprd03.prod.outlook.com (2603:10b6:408:130::28)
 by CY4PR12MB1624.namprd12.prod.outlook.com (2603:10b6:910:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 07:59:56 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::d8) by BN9PR03CA0503.outlook.office365.com
 (2603:10b6:408:130::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:55 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/39] 4.19.180-rc1 review
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f297a81767244dc5b63369267b590df5@HQMAIL101.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:54 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbb90c7a-4b36-4801-fd2d-08d8e463a87c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1624:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1624A40A3B5631DD6DF65129D9909@CY4PR12MB1624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cvMvjI2xOL+GXgHV9ESGuZm55WYilwMfKIvRxAb2A2x0qLWfE0nd4YqDL7S9bVQFVrXRZ+l65kt8lQLn3moAvuC3tK20mDrx4+H8fL/Vk68I/lEPgSGr2mWiD6dZAJ0Gkx+5wmHoYgKhf8H+8Gpt+WDz9b6RBDAoRycWdNeCKjTy4rrqg4Bf5UN+x7wbjOY95eG7IZYaoAKUNS3utFcwDdE5mqctTUqsGe6GwUmeSrBjxj6RHVbLtBBYvTYIoJLbAIyDUDQ2cx8zLteKyui9zyRJgIfoM22wFate1xv1cgZyknpIhyo5yjxNM4wsbRWmA1+0sfYue9FzCO6KH4ReJ3wFfQVzkyvZqty9nFRaG82feToDZmMq9VwYnFlWnpxrhPLeT0/cUFNvYFSRK/MC+iMYPZZBcOb3BueTVuV15otCJ/llg2OFV77CxZ1nw1ekry898xfvUhUfqbgW4uKRLeEoFrBEE6LdOIhK5pUqStmf8LGL852p1eGyt4J1j8Wr6K52h0C2z0o1cqq8wbjzjrw/QXZaWKuslGMwtZe2ZNGYPKdzDLkEhQ2CgSLtCMIQxKcYttBUyNS5zlvo/knYUCEKB8dRCbdnWduKpspP8sLEYqu/n1yAoXXzVEjuo8H8nbNSho26YYO1HsftVahxME5v/b8G/zDfmP148IP43/FFeI02PNf9Mh5lJEeeMI40NT4u5VtpGszVh+jRJl863I6VeFiTSrC/yL4mzrMWeBxo22f+giHFUyJNkw0P/uutV+yCQmny6XWbjrEyklihg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(46966006)(7416002)(316002)(108616005)(186003)(8676002)(24736004)(34070700002)(82740400003)(478600001)(8936002)(70206006)(54906003)(2906002)(86362001)(4326008)(966005)(7636003)(356005)(47076005)(6916009)(36860700001)(26005)(426003)(82310400003)(5660300002)(70586007)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:55.1014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb90c7a-4b36-4801-fd2d-08d8e463a87c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1624
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:24:08 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.180 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.180-rc1.gz
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
    38 tests:	38 pass, 0 fail

Linux version:	4.19.180-rc1-gfffeea406395
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
