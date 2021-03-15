Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C033C380
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhCORHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:55 -0400
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:1303
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235947AbhCORHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjjmgOQQD+3vVjv4LwhxMuw7cOQ7jyufumRq8EGBOHRnKlhvdKS3YSk6eryCI5TxUzux9Rjj/UGTYJVMhFHGUFNz9IMFEVzAuXmPL65XNSeEHDUX4hyDVvcCslpGVD3OtnXW0LdxKm1nN9PT4O7RE1zkVPaLL//WJS5bCZLtuX4jHujuqxY4p1m/3XwthoX1ygv67X61H2v72ZmxlUuvkHFoTMpQ/y7NI12bmlSUIzuyED2nvbbWMgpeHjxtE9wap17a4rNSKbzoArGgtkd5P9Xq2qACUcNQuVtU5JHKUUmO2VrDkL6yFC0fxA4SWttnI71Od2885CHATafSmWNC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiB7ac3YGNx+fb4d6yF/TRbf1QLxIqDnpLnu8LFgpq0=;
 b=CqKWn0oRasLnaE39Bpu7ydnVUwu8FNTL6Cgkyr/tdAlqv9hWPaXEtDl7Du7Bm1iQdseEkTScI5gA3NkyCk0xsR1+s7qe/nX9Sed7AYruOO9QoTTiQjwZ//dJ9fWbsLtY9KmgyHQNaJMoh05WrqBy0WQC2ZlrB+ZltcXb4UEPVCTNkimFlExLXrYN7fv9T70LykKchrWkdpGWPD0HAjVYMrhSl5BV3Y/hrE0JYvln/hsT2kkXH7qGkF1q/2VY4783SvdldnMpouR6cu0J5kBTekh98v1wfWNFMFZGTSEvMEdRBOMzTm+1+7oQhOturBHvWuGNkn06RaY+kMMpYjAS/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiB7ac3YGNx+fb4d6yF/TRbf1QLxIqDnpLnu8LFgpq0=;
 b=UafGynx2f3xshXNQq0ld4PrLY35QrRIwdftOQarsW8yglfBh60D7PB06XWzuM/ObPKRYrqlBB9Y/h8V1vJZkf6lzJFXSTZDGXEoBy7yqJCqH8zQ3hAo1WynZDsc0+1kmUKau0Mza8xI+S8gX0wdy+rKKto6pGwkYrLhTa3xZrxYSmhqV1lw2qgRRJVGdSxXrrGS5dFGTPq96cFgnjYd5KOG3obsPceKZ2RAtJ3uB68QSnLfLEV39ep39wGjA0YZQsyDhaWrxNKxbb1Za8gwKjjJcDtnjKa3CanRYsf4cEWigC2XYxvzzzUM4Rn0JDmDxUa4dIiPWWjHXZ+s34PnNFA==
Received: from DM5PR08CA0046.namprd08.prod.outlook.com (2603:10b6:4:60::35) by
 DM5PR12MB1433.namprd12.prod.outlook.com (2603:10b6:3:73::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 17:07:13 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::c1) by DM5PR08CA0046.outlook.office365.com
 (2603:10b6:4:60::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:12 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7fe6e8c11dd5486cafe957f1a43e0069@HQMAIL107.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9c6e8d8-06e9-4e3b-2246-08d8e7d4c676
X-MS-TrafficTypeDiagnostic: DM5PR12MB1433:
X-Microsoft-Antispam-PRVS: <DM5PR12MB14337DF076ACE4C69D49C50CD96C9@DM5PR12MB1433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jooVRymgDGWOOFdEsNqIMi/cUldXr6j/zRNLUgPpY9mhXaTLMPqkloE8uuuuPDjsovK0ImOqefPNtra0BFGD1PKGCG8OiVPF94E6XHgUZ0uPdK7WkUHru3tl0PDgRqEPAEZ+ZgEeccQcae/ThxFYk2xfO3wnxIeOzHmwFttN8WWw8xw0aGXD+0/ixUL6k3Sqi/rmGqj/uRTS0mxg+IHrp6Z4fW6H54/nCM8ZaZV5c/zvcQ/nGy46PycKDmbs/BTf46f4+isr5aGSVRtRJHJgZ+N98h5M4bSQMKJt2ZX4IVEleFVXkEsAVnrRcZRx567xej4HGT1fBI2Wy61ufRHLLK9l6XFwPRWKVi/2yh00ApqxTwNhVJrowm7H7jxKm0qIo5vMz+znAsLOrIt7ZFRfxhapxbgQV3gYn6vWP0b1qL+H5LBdyAyRy9beLIo7/YrYcDo8FbOzVSt7g9gM9dwee5j70uCBY2CRWBRX9UXk5MG2mjqGAe1hg2NmMGTBGDvB52eCMVH2m6iF7nkGarYixcP9ckh1coNGF3tlSqH8nMHwUKwbM2Op5p2CuVVWj2nUCxKImCGmpehQNnN/F5Y+uhL2Tjnf2zYaCsehJxVHytULRhrNk/asl36sw+Of8JPX9Waekq0AasHU7qhj9DZ5N8Ohz9+djGc/VaAsOgDj6z5hGqLxyDvsRSwMcKM+YpeoBMXbYdYFJrK3BDYyEFo1ssHsGvmaaCxM2GWhh8KUuv7iVpDd24y3POLIfq2A0gQXky8hFprPzufJFYvHz1zgSg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(26005)(426003)(6916009)(4326008)(478600001)(186003)(336012)(7416002)(966005)(8676002)(316002)(36906005)(7636003)(70206006)(70586007)(36860700001)(54906003)(82740400003)(82310400003)(2906002)(356005)(5660300002)(8936002)(34020700004)(24736004)(108616005)(47076005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:12.0199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c6e8d8-06e9-4e3b-2246-08d8e7d4c676
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1433
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:55:51 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.181-rc1.gz
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

Linux version:	4.19.181-rc1-gd3582f299a10
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
