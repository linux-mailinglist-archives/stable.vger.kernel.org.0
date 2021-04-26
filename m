Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5036B3BE
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhDZNFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:11 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:64769
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhDZNFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBtTtOWHv+uuhur3cHezv0c4ZGRZLPq0RMWmpbxrXaNRHnRjEwiMKbk/W5AwyF4RuiflLsKrmVmiF71ED3ervjzNQyTGAErS1x0AOnNga9HDB+WTUmeHgUUCF57LHIBzHgHIe7P9LliHxd6G22MYHAi00/VDDenV0IujeuV2i8OBik8pvoN2pikhAzEfvVSjzCSGnltxWbU1LR60UHryRsGsJ22go+Q/yL3l8sJnoaInj9hDEH4HTEecZSzQft//xe4s6BHAD+twU7iX0FEU35otCeTqO1txAhLWxuzFFFyfQ1Rb0/ooY9unov4JIFmRsOfUM3zBTGVxu8p/1sY4ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx/mRx+MdlqI2osONjpZZxIMldUVr/cDr0vBc2pX8qo=;
 b=MBDIWQzu81bL4e9pkR2KWJzRzpPuQ5dGqDWRDQ/qKPRE0k9MtlognFD1Ofar6hOXxyGSLfXwBq8piQKUx6G9l2cI2CS2nIrMBuLuunDnuUrvqAOY+kzz128TGbbjd3r5QHRm9w/GiTytdCGSDrcva1GZ5IBlcOFDpQKYk75cE8f6gLXK0FnliEZJfau6WNND2X7+FtqWQ8ma5iFCcXo4Q/AkEY2kXbqdRnB8SnXqsfeK0PgfAHuOBO+9TT97xn33S5yUoGVb0d3tMu3TfAx/OKuNPsJ2/KVpCSeW20/BCcF9WGkakyA/wMzQdNVHh3OlBq/Juhiy0H2S7z8C6iHMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx/mRx+MdlqI2osONjpZZxIMldUVr/cDr0vBc2pX8qo=;
 b=q6vG51qY7erYozjP7iCSEZxZZkvHXW2CrOsoB/SsRJnWaLxfZLzuOz7i6gyIi0N4qAUt1qqjdQ5S1OqMDYlpIB/Cooj13vFGtUUNx9OrdlLfN0/uIRV/KVO8EV0ukN7tAPg6e821NATNzIOJfpdIdlGmZeYdrOjV/GzlCm46YcFWGHQ9kqXwUtwOUXaPEEZLKcNgMVHR3egmPe6jSSPYKmXzhllyCSx7u5qjmIZQlIaqMl22WfoSKZ6j5X7BRQYP2p6LplHSJ3/dt6htBbgTYDvvq2E/0U/mfLMe6lMIIBIMyuEa/caV9+3EjX3tz1oaYAolLYnDEWmSvw7KylLtyw==
Received: from DM5PR18CA0073.namprd18.prod.outlook.com (2603:10b6:3:3::11) by
 DM5PR12MB1130.namprd12.prod.outlook.com (2603:10b6:3:75::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Mon, 26 Apr 2021 13:04:27 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::78) by DM5PR18CA0073.outlook.office365.com
 (2603:10b6:3:3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:26 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/20] 5.4.115-rc1 review
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <97f7c9e40d23434b865315f85b4df5c9@HQMAIL105.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d77f6647-e459-42d7-0782-08d908b3d242
X-MS-TrafficTypeDiagnostic: DM5PR12MB1130:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1130556AC07EB6F6132B4DD9D9429@DM5PR12MB1130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/R9lj/I2WiJKW2enjIH0MZEdTweApwR9DfQwwCDS7OGo8nhLDJBCbBTcehQqLxK7y1Ios98ZwNTVWvBKhCKT5pq6evOmYTFnlqsORGXftQ7Mbee59au3aHKu0GuAGvLqnfO4CyqgKY6EwX3cC9NWTpf1Iplw+jsYW/1AzPTo+bHskTnh2OvNSwnh36KEXAtsgKHDdFA/2JddSno7SIZXSD08TBYGginJb5sZdh3bCPHojh30WKCG6tXVCVKTSWGfuFNWYxI5iIl9PwIPhQUEWxwqDyEyVCr1OIfN8K/iy1bUagHlTpIv6lZ2a+Rgk0/GvVM1BVRzOPPB4bEleBi/eFsRw60oLlo4cUvJA0TB9PiH2erHBi79ApSOHErrLqBjwEft0iqzga0SVBq9hq/QkjrNOuMN6IDUzVB8/hJEb+Q4b9D8NeECwtUwwGXwgOkakUbkt0eQIXF/QI8QxHfhLXllD1eELtjr4nosDFGcUAT0+q/Yx+KD51LIZOMg+QEPlW0J2WSxizg9HXQneHI/wwIsO3HM1Obx15nUcO1Li8o+niMg9tUP6KP7Mq3ngI7dy/cdXECSM+PZ9tzkCouTa+Gti2vzJCVpp8pWSH3j7FXpJsgniTbbTE+XU22OprGXv2LJnwcTV81zPHta9nX6Z97etyRSqQk/TN1JTD4aNESuc+SslQLJPCyGf9Gwh5vD7GcekQAiT3pu7PQzuIFrhGnE/D1sqra4JRU/obPnAc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(7416002)(966005)(47076005)(4326008)(54906003)(426003)(6916009)(70586007)(336012)(8676002)(8936002)(24736004)(108616005)(478600001)(36860700001)(316002)(36906005)(186003)(7636003)(70206006)(82310400003)(82740400003)(356005)(5660300002)(26005)(86362001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:26.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d77f6647-e459-42d7-0782-08d908b3d242
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:29:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.115 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.115-rc1.gz
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

Linux version:	5.4.115-rc1-gf9824acd6902
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
