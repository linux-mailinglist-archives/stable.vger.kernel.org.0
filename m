Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21ED344777
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhCVOgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:36:00 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:33889
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230434AbhCVOfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2Vt94z5cTvmVGR6oOTH5fIeom4UUifssfwJ497YTnlVQxJ8VBOmnuS4WAaQLYmPCV04zwBuPm+5wCepbx4F10LfbPKzIdm5TgsY1dBAGtFvSoQxeOAwQiX+imtESmsew7lliSnaqH+4oqgM2+ofaktE39O1fg4zngW5/J5eGH3dOMVjwipBBi3vijB5x8/nVcBcIO5eWp7U0vhrlEplNzKKt8saYtB+srvGljyODpMowLjGXMr8Fn1SCy1L0ADC8Vn4awtmuzUm2JThTz85LAMsc5TsMrM65kh45fW5uYTXXR1eH0Rel+Ep47r5XiPh1XNxrokXxrHf0o2DHRlEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBVQFpr7Tkyu252FeXekQs8FZj2zXoBcF9dFbWv3BMY=;
 b=CtGveTkYAyhZbxv2Wq7szfAl552ixRqDWjVTcJufkWtHcIfzS2B9YXMrya81U8dzqVyVRqi9dQ6ugZEPKSnUaBTKPbEmri48KKFQ0dlg6kAVsjXz1nDGTDosFgGzZE3XLgZgOVmyQlxN11fTm4shQITwMLmeGlO7JVVKm0Nh3dy9GlgotOUnmgVpgsIg9WDzTnq7TQfrdmyEph2Y4r9SuiDoo83lcPHzpgnMZh4USKCE5lzlBqcpcL6QMCe1iMKivhzcDqdms7pkQctje2Lj9GD6XfHVvOcasvp5Uc/Avu0NQqbtnaENZOoWFX4SFm938tkjVwlkAyYh0a+reQ4LVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBVQFpr7Tkyu252FeXekQs8FZj2zXoBcF9dFbWv3BMY=;
 b=RN5gokRoxSBEh49jdYblX7vTF5MN/oG37YiNZ06WXYJkQbvFztEnflmcpfb/Vpy4LPSPDQWVAhttjOhoWTjWdiIQIUtnpnuEK/5ObMWxCZK5XLss7sto0Bs9LTc7d3EZjRO+oLJvv9Yd9pR7aroEgfHSf5evBVlLWYfQAamQKr3dK8Fg6fpAAPHSJ4vgcc4NQzHmFtub5iK/p88kxMHLC/wI5MEUmsPcF1t4k/deR2wgG5BPqT1LPd1p2oE5zs3btF6OrEQeD3+RSF+8zFYraLexyQTJTtqmmX2Pe2pOzuXVGnI+EJdvjAf0jtEAM5aBig64Bfmwi4Mrt2m3/u7Q2w==
Received: from BN9PR03CA0768.namprd03.prod.outlook.com (2603:10b6:408:13a::23)
 by DM6PR12MB4761.namprd12.prod.outlook.com (2603:10b6:5:75::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:35 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::f2) by BN9PR03CA0768.outlook.office365.com
 (2603:10b6:408:13a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:35 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 07:35:16 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/157] 5.10.26-rc1 review
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <56c2745f539a4607ac4e9393d5b09e73@HQMAIL101.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b3b256a-398e-4cc0-fa5a-08d8ed3fc189
X-MS-TrafficTypeDiagnostic: DM6PR12MB4761:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4761D385563196DE89C90301D9659@DM6PR12MB4761.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aj8PKEl7nuzVB/H4BwYQ8XoznKjEs63w/TPcOUxIMNBz0J5tReLuA4qGnfwr8UP20SSu666noO6kRUEKwClPdr6Y3fyehawIjf+al1lOlw1DyvnQqk6LtZUvOcqdDH94TBzeUKeWNTQ1HFGl/YNtxlxmLrE2j95mvefBe7j9n/S0RvIQs8LwTOeUUBkI8mey43SlCTkGHbU6my9nJKG2hNGsEk/06uQzm7+5TPji73qAEGF/cQgd8ZpZ+Jnxt4XRERsgxVSrUxqaMdAw5YsXQeeCf5jgkN5TIuDL+DAeR+MuguZykcaGKdmkebZS58cV/HpmXc3ytAcB48c+ppGNCrQEV3VJ2bEfp3sDgiiaEUbZbPcIAbCOWsGwd/Di15NQoGnfzpVosmJbnW/aAWCFLvkG7U54ROT+v6Xj5ar0oHNAbriNAG9dDsqSUIxHIbWt7BQmiiIIMGNpYcBJFzY4ZLYPssNOH8ohJkTd5Z3LupJ58HoCmfC/GXlU+cgG/78hMdIOwVGyPd4E7Xgdphj27fpm0G6tmfoBMj7W5ZaXMh6lchXRi7yJRVAb7rYvWu6wiRK03Ub2EBufHClImzoJ+A4TCLYzNXwPsyLlwZzABq0bTnmFeQA8bYf/KaMdvMJKzw2YebZrBSlzI5RnFo+hhuTmBzBHgfoHVJ6iofWaVjrF1f2Z43ylXJxTEt1FHOpoRwuBj4ip+B+hEWlo6dJh4hEXZYhgdRjhGrQFyYll/CU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(46966006)(26005)(5660300002)(356005)(82740400003)(2906002)(186003)(24736004)(82310400003)(108616005)(36860700001)(86362001)(426003)(47076005)(336012)(7416002)(70586007)(54906003)(7636003)(316002)(966005)(8936002)(70206006)(6916009)(4326008)(8676002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:35.6923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3b256a-398e-4cc0-fa5a-08d8ed3fc189
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4761
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:25:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc1.gz
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
    74 tests:	74 pass, 0 fail

Linux version:	5.10.26-rc1-g67dd333971dd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
