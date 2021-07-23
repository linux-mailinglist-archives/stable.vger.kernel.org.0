Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77D73D3601
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 10:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhGWHVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 03:21:24 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:40321
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233619AbhGWHVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 03:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRNzksOuot/BJ4mAHafWd1Wlwt3gdzhEXQrm86+0viWa6a0pFWQB+ilKKojx/+xu3DWj3TXho+HTWvooRCr7c7/1Z2OiM9u876PoQt7fUlxmZ1ldPgUvkpdf54nxCNyHH8D4HB6qQRdKgRJeaQm1YW+E/dn6+0BtUnc0fKYXjQqtt/VzijE3N3sOSIhFxFAY3engE4ZfV6syOeGs6uYiwmvlHdMkQUfLzqqQIU1x8zXOEWP051XDo8EDJo+bQmAa49KZNFeq+ZMHsNZT2mc9vwco7M7bauyuj17eRW5SPZ9kTOfTyaGWN/xeajbG4x0Fnlkn+4qF0yQJiutg97wbWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0JeIW+VsalSX/9igOjber9mcpegvF/xWp0u1vTqe80=;
 b=k3CZIyidizb8Ts3bL5eYPGYpuBeXJGssua81mDU5GoIOuIOYLe8UrgXlrC8RVA0GFR7WaJNPP5NFQo2zxiUuBfStfzBFqpWdIfjCIxMsG7N0C+nWjH+vSoCcqdqYkjufAztl1UDhn8MkJPFZcrLiwK3Ogr0FQ0Di6WxyUZ0afd58XY+BymizX5LSFe7qli6z4Da2TQXRxY/H1ZO6kEXBjr9RrlFcJjXSB6pztmiK/fBGiKwGU5yqlTyyH0CRrYTZm59g4dL8ZHDENkV+p0zEN1uO8qM1wagNYV8cUf/1FkL0U7ZR5xPoTV8CT55St4w9IvNmPta2wboQBVZHWjdotA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0JeIW+VsalSX/9igOjber9mcpegvF/xWp0u1vTqe80=;
 b=dCXAAdo8B8o2aStIqh30FyvPUvKJchNebCIMp/CyJ51WEj1gqedo34H6rsLsuCMnokhQDXJpFP4FZuRAllxfKqvAQXbQVa0+OWbloDF/TPJb+3ekXy1plzVHQsfJqXizvrPht49fhVr2E2c6sDhoiRRGF+AJ2sZBtczTtRMd4WAC3OHS9OEwtjh8ttRKJrTXL7PmqsEvbhm2hdcx4S+/adisa22nO9Bq2KAzLD3WilzFlz1QwFYQ1BMrIG1WDsJl0ROS9RTBn8ODOVUvnUTkn+sD5GsvmSQZCaNJa8YmizdYn7HzhaADDnm/EmFbIOLlCX+K9PzS6MyNUvRjcMQn0g==
Received: from BN9PR03CA0328.namprd03.prod.outlook.com (2603:10b6:408:112::33)
 by SJ0PR12MB5440.namprd12.prod.outlook.com (2603:10b6:a03:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Fri, 23 Jul
 2021 08:01:56 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::90) by BN9PR03CA0328.outlook.office365.com
 (2603:10b6:408:112::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 08:01:55 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Jul
 2021 08:01:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Jul 2021 08:01:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
References: <20210722184939.163840701@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5acd354d4c5e46efa19051dea77edd06@HQMAIL107.nvidia.com>
Date:   Fri, 23 Jul 2021 08:01:55 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3021dac6-cedf-40f1-4e8c-08d94db023de
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5440:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5440891C69FE4F404DE472BAD9E59@SJ0PR12MB5440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jd4xYigOssi4jcBxJmVR/jgBlyxCslOLxeFtZg57gG6YzzYAQu9hZsNluSsUfMRcCUErGtPWoAsCJlUx43ujXAHXhoteE2xb1xTTIGPFs83aNRi77kn6rJJyVSq9fSSXRU2N/sLNgp37i5iGxl0PU2rrPznSp/kIOgYZITJrlGEZXnznYwsfgYNBUpibH5qSg3husxQRU07rAaPyn1Ws95usKn7OKoYr7j2oyThCrAvDVLx8oSH1ChOLy4UuXZd/EWjErEYZDk8t/EnBNpaHRf8pXsYy0526/aWo7T+MEgcTOY48E6pfGfN+tu2qoW+Ogv9M+7xaYkV9ppD04x0SkqkZ11FI8YT++2emFWon+lK8BXUIRstfa3E6RvSLk22aay+uHm5ujJwUOc4CO/Mdvx3J0hZrfuh1Ck1nxdj6n5I3HujprK+pLC6IwgI3nOKuK/KIi4E2A18zz1s6m4NK+Ps4cX8BRalEf10TfSKc+g8tmZw+hQke7yOln0UDC0UaYKvTjfh+HWThXZ09UFCwO+hMoxQ5WkXcHaR8xE0jNdzQXOzwC9JUhZbX0EnXkUfupJNqhOYB+yKS+L76X6o1pFEz19ar4vBa9lgV65BVGTtzw6X7sZSdxQNJtsFNm9811pAJ0j8wv3pJXRojRv4IPHJ9xHOFnvYWZwCyYYOi+PDBI8Y25M7tKPxmX4GzZiDLxCnvFgKVWg3zf9V4tax5uItlFTkt8bZmyaHKH5pGFZFD+Kjv1wDqOzZeNw8uNZKd/GFoyB7hVIvp3rLxlUk2L5utCXLmoSjbraYp2Ih9kSU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(8936002)(24736004)(82310400003)(70206006)(108616005)(186003)(70586007)(26005)(36906005)(966005)(356005)(7636003)(336012)(426003)(6916009)(7416002)(508600001)(36860700001)(2906002)(5660300002)(47076005)(54906003)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 08:01:55.9431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3021dac6-cedf-40f1-4e8c-08d94db023de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5440
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 20:50:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.53-rc2.gz
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

Linux version:	5.10.53-rc2-g5e0262e1f1ac
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
