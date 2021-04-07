Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398A335669D
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347461AbhDGIWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:14 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:60897
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239336AbhDGIVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Se78FhYqu5EuhsYZy9iGHKhxyFAyDDqIFVKBV/gUnkLgxqE0/oaSf6cJbex0QKVy0efbwWKv5Ck+r+I6JLSfJdNKXHk7t6N9tTkboNd7tQNcvTfOpWyF4H6+llwJH1CORNVPDnDGc+WTdAccWtGf+gEHoQcaVOV4ivdczrwBig6NJ5d1ma5j0DXouB7mtwQcLJOcg8nylwl5zMNP6fTWHSFnberRiykTYZWr1wquVWTVcaoogD9Oq81sX2I1cBhni2LZxGL5kjAGdmtqBcZsGrclD5w7JBdUSZ2q7T1fYhOMz4hvEEuQY+eYh2rhFhPRU8FwVySc5MoIEQcp6nfTew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6BtnWMi9LflJEveExW+TU/1WO5ZGV8odiOiMiVFjH0=;
 b=Ztx6uePEuVeir5Gs/5ecAzccPod8CLwj5lBgsSdsDFKprP+gB5u3MYogh96RSvWnDzK55gY5pGWB4TsUaED97Yz95AT/TxxEohj9S7hWogcU4KeZbxFnW1AG0qserZj27GyS6189F44pregGAFyUCcT2Ee+jZBi+YDl7cX+rRS6kstnnmhGKmbFPHeYUW/S+JpSUk548y11fIDJOfDmPP3iw3+AGhWrLHwjrqHShKE5MLZRdITMyLJt62KPDkuVbz0qiL62J3exw0fJ2AqzGyECsPE4JLY9NUolpgzsa1Jbv5tlr9K/2LE0yseRbhuM406knIFkBnBZB8agP19lpSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6BtnWMi9LflJEveExW+TU/1WO5ZGV8odiOiMiVFjH0=;
 b=AT94yqn9zsXYMLx9vMCOYAmDtXILd349npBKOPFzT2XT/slLEj8IHrINfa4EDWnY6l19nuDQKWrNNtH7s5VfJyoAws0ckkXrtxHadZccskO/XkrHOiJJA7nkc89JuyI6JHtqyPqlxn8miJLqc1eif5yQtyXJ3AbLL8FzXlRFbPRk6wv4jOoW1iIq8Ut4jHg1czDAiCBdI6zmZaHLu47t6JW6qGUsrod2hzRPJo7OfblG0O0G6Zo1twrIj90wj24fBENgoDjjMNYBDgYkRukM0TC1w+eYXvW9FXkwuLP7PZLTCW5Z/Dox156gN7oMDJ/g6GNyLZ4fvjvAUdUkFqpujg==
Received: from MWHPR13CA0038.namprd13.prod.outlook.com (2603:10b6:300:95::24)
 by SN6PR12MB2797.namprd12.prod.outlook.com (2603:10b6:805:6e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 08:21:40 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::50) by MWHPR13CA0038.outlook.office365.com
 (2603:10b6:300:95::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 08:21:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:39 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:38 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 01:21:38 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/56] 4.19.185-rc1 review
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ea29c2e53f5940da9905406e9e7510de@HQMAIL109.nvidia.com>
Date:   Wed, 7 Apr 2021 01:21:38 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab797d7e-1d8e-4350-b538-08d8f99e2b62
X-MS-TrafficTypeDiagnostic: SN6PR12MB2797:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2797802FC9115579822E086CD9759@SN6PR12MB2797.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaVUZhzdN/FqTN7zfA/TR66NWLJ0JttRMJp/Sf6lbYZOAYPzbAaMp0ZtPt2mAXtw9MLBNuIPA8mdpn41GBmbaK6+XeT94v2IVv/5SKJ5V2mLDoH2/fdWqFUCFfBuiM0xP8BZ37OkXDobxD5McpqEd1BOebUwmq8egD5AEwlN4kl5d31SJHXt2QOqvBA1YvLmbErn4IjAlaDSV6W1Mtvi47HXu5XmKexMzmDbGD8lmTwVIRQsM4sqlfDSLWVRoyevK8XhboS+6NVmI/Y9b3YZOlksV4I7RUxjqrj2vLTXB+bs+uyKG+glNNUNlQvWltww0EBs0pjt3PXUJQVukZHfz3gswn/LpJKLMhM9sx5kVZDirU2SJyRbbBWeZpvlumkAf7Raynpd8OGNdNELbsBBN799At3lNi6dHLZyauYgzJsinEpDux6dm1P0qAECpfudRoOq7K1fhUYbd3OTWJnS5uFo60q3zygp+dQh3e7V4JZDMYoyvpI16ME3vHqVbXqX4m1mQvuSlpCzIVAAOjuVnuIXcNv+fSwIZtFZKisd2adyLU+BZy+NdfbshucUsi3/d93cr69nnore2xC18NpCknU6i30VjZgk46XCUbA7K5yGQZJ7Eb7rMuhSYsPkMU279/A/0KJXM3HHP31ou7FvhYGisrWjy+tSbZLXlBU4S5+AP4iUK3VWMYFEDo6yQ4GNr4Qrie2AWgdymbqnyTUpllqCbIJD7CQWBwuxECYTAOU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(36840700001)(46966006)(70206006)(186003)(426003)(82740400003)(54906003)(8936002)(336012)(36906005)(6916009)(7416002)(7636003)(478600001)(316002)(24736004)(356005)(4326008)(5660300002)(966005)(2906002)(47076005)(26005)(8676002)(86362001)(108616005)(70586007)(82310400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:39.9814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab797d7e-1d8e-4350-b538-08d8f99e2b62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2797
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:53:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.185 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.185-rc1.gz
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
    40 tests:	40 pass, 0 fail

Linux version:	4.19.185-rc1-ge80ef2122d5c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
