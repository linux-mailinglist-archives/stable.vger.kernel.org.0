Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55D53DAAFD
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhG2Sfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:35:31 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:31712
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230141AbhG2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 14:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOPf3cGfW2PNOok/WvQhdN1Td20tnwqZVDd+/wlY4ag/TqhYDbT+PrmvoSYa5i3pwoHrbv31HDD1SqUi6v7GxDg8SzS10WwJ00yoRC3+i6FIBgMXz66/Zv47BS5Ni+JeTz57bkb5sPw4h63sKyFkpWUisX7TiquVV4WRLUgm3LIWh09TPYfS5rwXQJ5j1oITJyFjdB+pzH8MgDccttZyz29KArdYSlgxvjGRqLMC6XvSBRx6bAuQKDywEJogCDWcQuxBX8h+a+sIfmkvJmS6h+Doa8xs5nbR35oTg1s5Fw4tdkux+whBwfm4fMvp5ij0w7XGhPfqQZVCbznJsEdRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qZEyc9WmdPDU4n33n24DikqvOJP4JoEdWMQGniseqg=;
 b=D7oIV4UOGz5GcZ5pg1ejTD1up9cq0y2tldfTg7YxQUH0rawRJjh53byJ4oicNNOAcM750Iqc7cNJ1LWmtvsR2WhKitM3KjqeUbXtwrI0cx2qbRMge9czn/JMbmiAhR1HtVGon34GyVehZksUqPldiGxk1xNdCWFDYfDePVJbNoUc2s5WDeOWBbDF+FCwWQuyHxz6VBbyukGqnEWi/6/754eGDdiQTTd3mNFZmnVmqUb2da5UCdy6Oi0iOlw/hSXgvkqZz1AkJV9iMpkhqYWy5j6XLSsNxb0VsYQJiU8CQhIf5TKGvDQw1JXNjO0KT8qE8sfNRjLYAKR52gsDrCzLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qZEyc9WmdPDU4n33n24DikqvOJP4JoEdWMQGniseqg=;
 b=tkHfoASGvzme068Fqu7XEO8uknEmL3J1h0HkvdX6Myzij5BP2Zpkrn/CmysFno/zYzRdFG4nHarFIOkvDMja52uDnTgAxIwfnadQOR4S5C8kzKnTih1voIQ2PJy316aUgw2ioUq8tWLp4MMLGlskfupk+J2Ci7yUpW3kJH619AZTJLSgbgY6NVxVBy9zHSv1zaLMF0IMcYvckKdF6f/ImaSfJpKvW5sgrLuY8nP/h3HinYUkUYktLSpdfddYyf/WQXre0n8y1GQ4DiMjtIR3GrdKrObLiqKUZe9X+MEU7b5Sqvw36cNtIes7YpBT9PNhWDF1Nx0wnHGiJoXMYhJIGQ==
Received: from DM3PR12CA0105.namprd12.prod.outlook.com (2603:10b6:0:55::25) by
 BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 18:35:22 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::8d) by DM3PR12CA0105.outlook.office365.com
 (2603:10b6:0:55::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 18:35:21 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Jul
 2021 18:35:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <55eceb48408b4a63a15159f0fd6d4a29@HQMAIL101.nvidia.com>
Date:   Thu, 29 Jul 2021 18:35:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b1fbee7-3d0b-4ea6-1d5f-08d952bf9fa3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208FD6A275308692C26ECB0D9EB9@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rON0m9U/6U+K0bbWbShp/KNZYT47ApUMwDncgGRrEAnXr7DvE9mlwTJrFhREXUxOgUlWJFIuVypKSctEh2+cdb2miqqqX2q1nrHP30jO2HQ12JPt2ChsWPn9VgRlfpgmqpeCJpGS9KrCudQK7SsNZfRLmOS3Y7EP+q2gxoea5dyzZi3j2YsWiGx8WInh9XcfR0Jk4npeA0lHc2pYE4VAnzJ8rbQhyZJO371TYngsVpTLxAokumIml7Nd55e6SvmY280znJvMd7CMyFDbWEqzqp4p5xMPIbOEF/NQLAyiwdMvphwXpFTL64JRkIw4+koAKv6vTtoVx6La3jQCGpQ+9rgZaNJ8iEQl6bnJhL3tS+48KHEFODgwsDA9LG4pIgUO4TjC2FhVKfFjNeKKswV5CD6TBcQbWIQwbwUGC8rIMD/+DdxcbRMgNuyX+N1UTEW43UePREqjRvgDLukQjZQOAg9r90nXFGVIvo9pht/6b1HOb7fKr946k8gQo/LR5PHMxs8106FS8p6rxWx7FXh2JycLFbZXI6Fp6TGf+DBiTNNi+n19zXjoEap4qfHxgsww3zZlfx4fKhW3Wku628T4cMDQj3l0xGQyu+lk5Us/HJqtLHS6z/fnOiLuKECfX2vH6eVX5J4D961/y3dzIj6UjWY0wkZ0oRXu8fboWaCWE8YZaS69WUVBmYsWcQNRWs0Xr1J+3Mylf3z1uukR00l+vChewEk04YjrcFbFzXkGffzUXjAPnKV4VqHx7pP2RjyArAb3QULdbB1RxrJ2ytW2av/gnUMeDYObiW6t0+uX6SA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(46966006)(36840700001)(36860700001)(86362001)(7636003)(2906002)(8936002)(36906005)(8676002)(82310400003)(4326008)(336012)(7416002)(82740400003)(47076005)(356005)(108616005)(478600001)(966005)(426003)(26005)(5660300002)(6916009)(70586007)(70206006)(316002)(186003)(24736004)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:35:21.9084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1fbee7-3d0b-4ea6-1d5f-08d952bf9fa3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021 15:54:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.55-rc1.gz
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

Linux version:	5.10.55-rc1-gdfa33f1e9f64
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
