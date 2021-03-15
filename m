Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2833C37A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhCORHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:07:54 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:47617
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235939AbhCORHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 13:07:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvQtbuEh+EMZp5aNGXo69j+eP7Qjc2W/eTOo+RkwhSwqApW68Sh7Qb8PBVphQ2xzjVlP0YlviseTwKEKhC3WAs5dGVCjd0umZwNrbNMwyTzn4WjxQKA8vIDUR75qUcsYcVNmPnRh7sHMgurrbzwKzI9DQQknwSwf6BpK+uWgkn0/GEOHkEUBCKJuY0PFr+ZTASemN7HZvX6ywB9u2Z9PYOu57D9MolvQEbUQuvFlvwsTXWOaAPwoZnPO9H76ty3hkH4v7VrZebSvHLOzoX5+D4rayGLm/zir+t2HljmjI0F6Gse2uueA4tfHZH/68mLlzHqiCVl4ZN+VpOsBnTypEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlHT5wuA6ObW6ZS6k1D0MSdkZigUP/7legn19D0EQOo=;
 b=GLtqMnn9ZjMJzqDblcrVfTVIHq7MMk595vWF4EBF4VtSNSdfafMDi+K7ko9spi43DHBJfNq0hQKE0NWKFenhZ+xK7JN3jtwTctSWeUwTGx32rLb7A7rVsTm0YOa+nrdmSXDcfFF75VmVI7qKzb0HCLd/0FOJVNX4Kwgvh+0afTegTNvRxUt1/jq5Er/f3y8xLBOUkNcOVgg70igt4ZWpK91UcRV+mZlqL+cucIAAVYWCtYQflXQf8KhKmOfesIWhSfN8qRRa3WnB0KUgttinAPGnpGLfoSEqXoP64bRmoMkmiicu8N5h1/dL4EfzqOkJCmgHY/YoJb1QFQDOOPe7dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlHT5wuA6ObW6ZS6k1D0MSdkZigUP/7legn19D0EQOo=;
 b=QjTIDA1tn46oVcUTK8lGlcUd1S7ihT+aFV5X6ziAigqofvJ6zoNR3mxmFB8v2cY02CTvBS8g8uBFPmxjEd54IMM+6NMPnC/JZT9eJWCg1aYMNSzRerFdFYprjfx7si/Q96Dt334ncsDE9PEHzo7XpQ077TllRFnRE9WnA3IkU48IwQlbibVKR/ulK53WGc8t+BltPzmIsqzre6JgKC8KXHdBRPo55QRwqAHk7v0TLkx3FLcPdDhGTfiDkymfolSkVkHAaDVDCB3yR+VQ2/veL7gGgcowU2591u9JnJfAH5h4AOnzGT7twt+Gub1FXmVIkeDhQG9lGC07QR8qHzLNUQ==
Received: from BN9PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:fa::7)
 by CY4PR12MB1623.namprd12.prod.outlook.com (2603:10b6:910:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:07:14 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::73) by BN9PR03CA0002.outlook.office365.com
 (2603:10b6:408:fa::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:07:13 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:07:12 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:07:12 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f348850a09e24980b052cea382e40181@HQMAIL107.nvidia.com>
Date:   Mon, 15 Mar 2021 17:07:12 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b702dcf1-32a5-4b4a-3fe5-08d8e7d4c786
X-MS-TrafficTypeDiagnostic: CY4PR12MB1623:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1623C4ED48689527FB10AE69D96C9@CY4PR12MB1623.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwBkOPqDpoLVSI13oEXlAbBAkT5E5SW7pQ53ifZy94FNGR0iKUUIVcgt+6I8t4fN/Gv/CZJ2MI36SM7ThlPiZnwiyhQCP+A5tqTrBMim/vaBaf1G83okl58Xri3VKqh6CsHuWl2oZIhgTtB2NtN97sojak8Bjvow4MQsfRm5ISLPv5zSKexD7t340DTw2ujqZ0s3yBYZG6hxnhVU8R4Rhh7ycGN47XtqGcwpLYbzghGBhKoVEY22QAigdUmKq3P9w+0QRGrRur42Y0ioT0cJMWuwQEeR63vM/nkvUziIScqHPSpr3a053FzoHB5WzJJLEpUloo2JtbMDU269SEgWcS4Cr7L8YnpM5KOYFhXGwfg2synS+zn7Py4v0R02E4zEC4xpS2zdzpowx5fwzSilWWpMqqHa4bH+R1UHFD37r0H+Edgs7F+4tWq86z4tCoYZARFc+LWcPYErGanxTURIXs/SqIDz68uTAFq+oBtiwCrBCkqmjAaC0Gvgz0uw81ApM3pFGRYz5FhEwuyLAgu3avXRrmJMbQD5+3ZB2Aj3pCVm1g/hv0crq+AUFyKeJ4+oZSxK9fgYX35Aj0v/K64YvyKUtxKLw/ardRvh/5ZuKK7++qcYSNUUi7YSwc2vyhm0hLZeg0aBcLRmTDKJ+7g4yTvqczmzzqMMfTCTxsLVkSGhZEreTBqxkH+Y8wwzxxLmXHqFjP9guSmFSW6qznXt2JGXZoyF9Z+UjveX0PFjPN0uAVpFxyifJoPjhYXOCWksYUTVlK0cL0nE9Qjn13gpxQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(36840700001)(46966006)(8936002)(2906002)(7636003)(356005)(86362001)(966005)(82310400003)(4326008)(478600001)(34020700004)(70586007)(54906003)(8676002)(70206006)(82740400003)(47076005)(36860700001)(186003)(6916009)(7416002)(316002)(108616005)(26005)(426003)(336012)(5660300002)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:07:13.7863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b702dcf1-32a5-4b4a-3fe5-08d8e7d4c786
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1623
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 14:53:52 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.106 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.106-rc1.gz
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
    57 tests:	57 pass, 0 fail

Linux version:	5.4.106-rc1-gfed4321947f0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
