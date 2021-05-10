Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CE7378E67
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbhEJN24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:56 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:25569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241047AbhEJMnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:43:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RenM6AMVpiN3KRPjWy26DOyzqou4M21qGxFGOe/LdyI/iPnwEgaD4OVJeR7HBBHpkw2Zz78xuYBrZch0yQ3DqdU8PJcDv8A5NFVuvuhG3rTJQmWv2aC8iGj25VZTikrA2TQ6OAOwB/iwiV/YapBV35KbeagzNqHPq+l5y2EK30GTI82pU5nlKhn5r/m74sGRHUxQO5wPX8c7toy6o5Wi8rrSSzYCYnBgVUubzbqR21npOmChLLMD7VR0cmqUZN8nG7M2bZl1hWlPSzpV7XV5s0IzICegK7W/b8b1T7+Umb1IBYqb6/DZbcWAc8IZCpuOLD4PmanRT8r8kRa5q3/ArA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOA3lhWN80Hmw73DXXFJ3aUWq4R0zwuGTmNs0fe1HDo=;
 b=NxPVDgCsr5IUASFfvChkpGob9aSv9nhHmFxlJg/psCSmAvlAhCBtWhX7T7CIlUy2KBEu0uC3FIiTkAUkXrJxAbL8ucNlm+AmThlqV+UBZmPKghlLx0Fs686f1xqzgjsJ/4J3sCt1RWvQtAa1jnz2Aw9pGOWufjUhzed5N7GA/AUof4vAlPlbe+9kZq1+6e3Dy1R7BBNnJVlF1aEHY6Yb9nGQNhrY5pdtfDjoGe9ZHMzqe5pEMJEDlWL9kSv9wXXTZKqrEgHSiU+5mW4YI0UzeUiTLNY3qQGnWTZ6hznvv52254eJGEGhN8zsBH6P2EgA8aytxsf1TyVGmEBLV0ZCbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOA3lhWN80Hmw73DXXFJ3aUWq4R0zwuGTmNs0fe1HDo=;
 b=V4maVXtuRJx5Hv34b0t4JwD5x5qIuYqoG4XhuFw/O5ZRST/4L/rEAepU1HID/qXadfRTCxtiMU9IsYTixbkXkaNmtz+jsYwsUERX2zDV6S3ggQOnjlPHYCQXvoCeR7ZBm7csgHVnbobxV0vMm7fir2AsETdqhGb8U4bPnMWyaOwx6MBYKeQqBdQUSRzUw2NPt2qUeHwAvaeaE91wcISOk+jemmY/zWEKOJ7ZDHG5wK6bQNAI4BUTrj03ON4H4oV3ti5eDo15Bm72C6xU5vh7FQjNEdq7x77GaBEpCQpHJrYJ78cHEsz2QU5PMZDiqOmomh5mMOwBK7DQcre0eyfrGw==
Received: from DM5PR06CA0095.namprd06.prod.outlook.com (2603:10b6:3:4::33) by
 DM6PR12MB2747.namprd12.prod.outlook.com (2603:10b6:5:4a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.28; Mon, 10 May 2021 12:42:26 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::38) by DM5PR06CA0095.outlook.office365.com
 (2603:10b6:3:4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 10 May 2021 12:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:42:24 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 05:42:24 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 10 May 2021 05:42:24 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f810f0a61a234e9ca0f1320771250428@HQMAIL109.nvidia.com>
Date:   Mon, 10 May 2021 05:42:24 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37b356ab-7852-4561-ac00-08d913b1100c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2747:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2747C212F499334EC3750751D9549@DM6PR12MB2747.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6q6Mwnb+s8AksDYkLIZPXCiEbXiWLBomS+JsvaFFlPkrm3s0w4eIZAFg3tBQ6jxW29/nq7UzLwZeF224Mrxzs32H9U/T2QZEoG5BGy/ikVfyJZM/GdWJy8iWzI/f+Ba3jNgDa3RDN22C3qouhGvsTnx+MSp7ifpC7aDViyHfqc3ygAAfrfus15KyZ+fwEHOVIyDRiVHBQTMY0flLNukw9x5OOscW4bcoVFQoIRurMM20iOQjazs2hKD9JJh8cm73RxtmiGivVkpBffO+8rwXlBFt6Em++aHEiErQ3c5Njm9VlS9SdhH5zEBQPi94UIz86jN90Ma53cAT+YUSBUvFNKsF+rxSSCmuNtGc3d8vMALK7i0tPBYsFSd3y5uMKiax7TUOVmGcgUB3LUBoNJF6QWBSgsxcp9MG6x1WdvmvqMxk1lNm7QMkZ8Fij3YMAtKgAhSqll42/DT+aepfFO2XNYMWtoRfioFfkR5qz2Evh7zNUxP9aBxK1s+/CumTsCi3zIk2eQNY2Rg9x0eAUh2tlJZFOV9aKLezigoqDhdTUS3Uuwjm9F2SrC5e1g0R4WkJNwHBS4Nre7g3VYlZQHZaeIyEi6JW8X8aUzM1Ss7sC1cwzj0vHfe37u6jyhQd4BVf2/DV82hsNcLn3qAd6wZOU/STAso8AVfFBaehysVDTeFc5ARfC07njj1nyMBszpiWMb2Gi9Z8qUnp5Guq36fjfOaSUQ1QBkQtjewrvOsfUqA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(966005)(86362001)(36860700001)(108616005)(82740400003)(24736004)(82310400003)(478600001)(7636003)(356005)(7416002)(47076005)(2906002)(8676002)(186003)(8936002)(6916009)(26005)(70206006)(70586007)(4326008)(5660300002)(316002)(54906003)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:42:24.7931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b356ab-7852-4561-ac00-08d913b1100c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2747
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 12:16:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.20 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
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

Linux version:	5.11.20-rc1-g44eb32ead9ee
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
