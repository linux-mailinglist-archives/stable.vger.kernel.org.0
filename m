Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D567E3E2C9F
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbhHFOd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:28 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:51776
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239849AbhHFOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REIKA9BZQcyKc7Mtbtas9lbc2AetmZ3v/LeJKaO98CRzXcaXEk/qdVudhFA+hadB7db0z4FlYmlFYA1H+8UhVpwnmDIj6/FqutmuU4UNA/X5sljrCiuBiXbU5rbJj+6OkqD9xHtOg6rRLPTcj9WdoMsKj6Nlr6Nrz0/2IxaiUM8JtE8pGTRppSYdC95uwAH8TY3k7WcS2+Z/ZmXmG9SSf3c/Lu5r50OT2ow51JxBpfRJWQzJanNlxXzI3M2iHVZZ4JORIAFvLs9Mng0fkMvLPA6Ordi7umvNvzRMKSIixDEw7PclcfDK7b8TKGARO7bhYrHi3nCMVXBa6DkzdwJtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwMMi4sBOSrBDdHu75JfEn/R72Jawuct1cHFHDiJB5Q=;
 b=VQOaAm1Fgj3+ZMjvewET0RFQkdl/So4YUA0ptXW2rBGO52X2Xmr7KJIPoU9e7YZ/JTyWp79iWRvnTCvk4H+wDN1NMwWLJCCKBKRXmLTpON7+J9bhrqOT/DEcYHrA345MMm1h1FhwgSX/9Aic7bBATKKlwuntWvBFmWhGDzFDwxmUJw3l5TF6CgUlAbKxWKAdPi4hrMEB3VMQV5baGFjzYfWuZz/rcZgvEouqqA6XtS0piH2vcOrFiBPv8kkfP9HqoaNCJJmJzFbHc2LXxgIBVtnnRyUQ+1aPtwq4OeLFLVx/Tzc8rSUGPjeAUGthlFtXcxjPoOgNI2MC0GZA/nYGeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwMMi4sBOSrBDdHu75JfEn/R72Jawuct1cHFHDiJB5Q=;
 b=js05x4XIYGuKRFvFH9oiPBUcEhuuqcHv/KSj8JyMw0r/99VLBLimO/V0N3e4srCLUSrs0wZFzXWi6Mgi0+Ek9WCHkwstULSEaSJWOOTkMS/fo/20fTfm3QadfcKV5u9CgStrQqXwdms1FUBF2hKlyXREOJvW/j7ZZG6p+FIX3+o318VzKdcGnsgY5x4HC9209x3YX/LI+x85TspQwI7QKzGcU6IIf0hCAMjaonqBwlt2WGKH1zIZHMUgD5hovMne0oWVBkNbVd/m9i77I2YaWM4D3m1jsNDH+9/PFTn6sGK5iZ51LTOeNzgMfrLQZc8sejSR78klJmPsvUV1qlHJEQ==
Received: from CO2PR04CA0116.namprd04.prod.outlook.com (2603:10b6:104:7::18)
 by BYAPR12MB3621.namprd12.prod.outlook.com (2603:10b6:a03:db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 14:33:05 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::77) by CO2PR04CA0116.outlook.office365.com
 (2603:10b6:104:7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:04 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/16] 4.19.202-rc1 review
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <206d83408d6948d79d45fa27a3a29e56@HQMAIL105.nvidia.com>
Date:   Fri, 6 Aug 2021 14:33:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 310ecb94-4460-4de0-1114-08d958e71a6b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3621:
X-Microsoft-Antispam-PRVS: <BYAPR12MB36217FE44C66AEEA12A759D9D9F39@BYAPR12MB3621.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOWd33qh05tfB5WX0U5IB+xz5tq2CLGwkYwR1cXpOVtRJFBNHOv8QejDKm4MptlDMGfYju/5Bz3bWnPDjdsp1rOEA50TEjgT2DaOGivuEKpjD2FCD7Y0R3xvVJJ7EoqEmX9sWsDTxTHoyRueFHY8jzHPl66euuVzfgWLIwYl7uFvQZghueoirmnzHsRnbthtppmPxKzZl9wiarTQx4i9hfeGwGYkJ+cOcwKKuPCUgL75rbbeNsxgHsSjj8Yn865uppu+bDwS0PGiidZgpxG/FKKna/OgZx2HU7soCYoOpUT6hB6kOILqEYoYSitYiPVa0ZBJ89++C76Il8YlSf9gKnClpMmvul+/eQUvVdvnus8rmnXRTwSGHTWCvyIN6EkuXDwf3cSfD3aTutV9zMb3WJ7UyVg5yMjtrCQZRJl7Y0JoOZmPfVd7QPLipxdjSi1rQCg4oCwhsCd4ujfjQtRj/RghAlEhiLpraxms91mv51jZEPom2E/G4yMpxL3NVaDL/qnQ8v+BBBtuZm1ePjfRzPR4PrE5xeniIOB/kTM+FhOhLzB97iEimBWNwak9R6lrXOZ6ItpxloaY2U/2ow45Mtn+QK9Dp7lJerIuWKXE0lLx243RTGXTFYt+8Rty6ktvV/4D/T2I5umtGI3IViFlQLwwE52SDWo1gHyGmOynjE/W6lO4qTymdGvArbLukAIXpYOXaKox5ql+SrrMy4SCEEPpUvVCKL3Oqy+PiuOLJqy4pPQ49II2sl4mvmaKjj1A2Vyi97xYOh9O4hb7wxfraMgLTMXTA6BeA+klDLeSgKU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(26005)(54906003)(186003)(82310400003)(6916009)(4326008)(8936002)(36860700001)(336012)(966005)(7416002)(70206006)(82740400003)(86362001)(2906002)(70586007)(356005)(24736004)(5660300002)(426003)(7636003)(108616005)(478600001)(8676002)(47076005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:05.1820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 310ecb94-4460-4de0-1114-08d958e71a6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3621
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:14:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.202 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.202-rc1-g9c68cf432f4c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
