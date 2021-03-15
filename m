Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85533C375
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhCORHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:46 -0400
Received: from mail-mw2nam08on2088.outbound.protection.outlook.com ([40.107.101.88]:59329
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234049AbhCORHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faVDjpj+YOgELiG32dXGWd3KMcd4P37b5lzfVCB9s8J6JFzWBjv58DudXlKAviIqPJZW+wHcjORsrLK/3SJj7PTkSJlY9oAR+g5XQ7cKzxUD0gXxLOH2zYXLP1uAOupp7BlrZjrlhgPXLMENUUxfpt17U3sIbJOJVP6YG/31dHpQN9P4FLhO8/OIgXjE4R4X2LtGalAQDLOlOv4a5yIza4OHP9Z0xIFNJsawdjX1sN2hGirRjahXaIQ306NnPuM1v9CLyvNeadeHz5QhRGthzvP1QDiYTNqCh83jRvKj2kaVHGylPAvUul0MmN+Hd+U3MV/f65IJqTcvTsOmjWPrUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9hilsbsR76Mp7FjFvvz3MvAoT3FZMWk7/d/p2fRKS0=;
 b=LMFY7sCqXbHcOemU1NNgL9gsLCcroZrsiJkCgxOQRfAc3lBE0e1bGugwlDDlNiHqfNViN+hdjSHU4YDSiIOojuoEWYVyMx7uBC2q4KpgHySO52jcc7kG2mNfsTAvjgClAdE2rdxn5VjwW0NktgtIaprFxdnlOFGivbQGhkQ3Upd+OUQwr5ukNV4yG/CJaVV9k/puwlSciaRTHjsSNChEAj79dsfP9ShlZLUvhhv6wvd6uDeRfZ9UqqOfP8+Y9Tv6djt7ZG+kuagjxmadYHZu4x0qqF1XNKeHSsuFcOHg/IO8MiDeWLukzVJo93sKkr9a2xS1yh4sA1w3zwxZcV1L5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9hilsbsR76Mp7FjFvvz3MvAoT3FZMWk7/d/p2fRKS0=;
 b=q/bJ61mmX0Oj//g79zSN7vmCtwB5p9qdXKwoqKU2z24a+Ua+hJl/EjpsDe+FYZ3SlbHYqqGfbkxqs+9595Vxfolua561alE78lSDT7hIcvcKqFqzHc1fM+NkaWf+LZqrwAx1T/EdB+LNiMPENh+Blc84GVofPKmIzp9YgQaxut7ViXp4iwmWIrBGIbtfQuf9sDRWdPnyZajjUtzvG9JaNjyuuQRyOI8Is6GW60c8TfecGuXwgxWXvsMOaMbzxx5x/rB8x0p2uJODGDpDSCzezcxE9Olwl6b0VHH45DMH/tbhIkgzz145joEjilXBxAi+WeKaBZmSUif2Nw/0nH4ryw==
Received: from BN6PR19CA0120.namprd19.prod.outlook.com (2603:10b6:404:a0::34)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:07:10 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::3f) by BN6PR19CA0120.outlook.office365.com
 (2603:10b6:404:a0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/75] 4.4.262-rc1 review
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f57f8a3ac7584d4d947855a3e070dff6@HQMAIL105.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:09 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 737ab2a9-284c-4ccf-87f4-08d8e7d4c53b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479867C5513533C9A795432D96C9@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCRk9ktrBbaXSHFdoFiKFnxmgyGfFxytoWTpIXa6MyVTpFLU10OoSXzYQ71A+DJXuy6GUeg1+6TuVet+wigWkZkLJlGoq38orcaC9OH+Viqw/jW/kTvlHBQb9oamskxK79PfPziMy9M5n+l9b7CIBSI8eFdm8mL2eSvc+tjBpd1IbrQ167XcIsrGtWGt3/fPsRUtp4YTjiztbl0uHgfpOjcvF8SKucHYvvNInyMbfOb4EOmJIv+D1+6zFN36PHVdRWc/w5dYzxLDyOOs1R9sMlxqiYQoC0nAPKOHruPxslHQkAG62FA837AB0O9Vmgtygk0S/jBNESemNEab/SushCkf8/3eIwuMkoaHZXuyE1uxUtgEVZnLSWiOsCiBbHOqaiCKLrXsijDjYZlNQWact9XRGO+38OzRQqbb/cwFnWldhuc8PR9grfKdGPUi+Q6PmUMiBC47Bj2MyZdHM2bQJ3ACC+PiHMnk7WWlphml+Iul61y948SYQVm0wwtu9nDK9x1KUKNcQwvhoBBA+z7XLp1GzyzcOj7qrd+yKQbpxmGBJ1JI9lkS9gGeLlYoFFgDnx+x3vgDRjaT8c0yTCtJN0xSGXZXkNl5X9FNUwq4wOn7HbPJrILtISe+jCYTHKo/hGBzaZPLjlhjvoAFOuB4PdH7eY+xvoUXmGYiyn61CxiAQQt46tljjgx5KfPbC9Fv80gIXGaAIUsQ1d43nLZBuGCBofVhgg38/IjvfTUm1r9JzMdr7+73mdKAP5x2PXQlU6o8QSdeMyhvAe+nkW8aaw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(82740400003)(4326008)(8676002)(7636003)(34020700004)(24736004)(108616005)(82310400003)(5660300002)(8936002)(36860700001)(426003)(54906003)(356005)(316002)(47076005)(70206006)(6916009)(186003)(7416002)(336012)(478600001)(2906002)(966005)(86362001)(70586007)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:09.9452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 737ab2a9-284c-4ccf-87f4-08d8e7d4c53b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:51:14 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.4.262 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:51:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.262-rc1.gz
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

Linux version:	4.4.262-rc1-gaa7c5e8521a7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
