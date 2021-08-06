Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2BA3E2C9C
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhHFOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:27 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:5440
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239851AbhHFOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PioMW7Qq9VmFYWd8G0Al3bqUFKOBSSBLRDLZMAXZNu3aWKwrU+yzVWwGimbOeatpuhtAbt89Y+5TOCPiRTCkwo1b1RjYSN7EWQ9cV3u/Wd93nnrfxRus9z3o1oNUBTOV1aTA3A9ahyvdO6B3xidf1A3Ielse4ptoNjMYNNoxrAVTXlb4ilBrx1UOCEfIdirhJelS9tmCClxCHQ/MFYIOuyjiIuJEAcvI5DBL1ej798L3wpczI0hHcvPeLgM61wD64UJAhIkhpKhezxTe3hpEFSVpZvTv0P/c1siuH0IWIN7i3YVwnBL+hBz/vz0F3BLW3gzxIiMWvENpRwK6QML6QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL0oCLsbArYiwimD0FGcIqbtBwU+JlmljxDtMTNTDao=;
 b=OWw24g+9VDQxzqaey6I78ogUZYnIWMUgTGyudPqsC4iixrX0sv8gsKB7iOyU+hq1Kuh+Ll2aWWwZh+QunSOxWfEWscgmihKfS7+XewOXY1WxSLCjVcXsYo3quaetifnPZ0/lNxIl2Wexm6NYkcV4zq6ST4RmO3h6wD3WZo89j87DIpqDqmgekbQ8TIzDFV+T9lS6QPScQPSprkWBeDYE571VCWjGjbymspl42utVjisG7Sx3wx2GLgwLZZ1LBN7ZEeiOOaaWHDnuvBFFtiDOu+wyr/YY4PjTQOWaXO/ssfoEayuNUi01UY28vgks/cpzS6VEYZWV7VnnJWoIgP7CcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YL0oCLsbArYiwimD0FGcIqbtBwU+JlmljxDtMTNTDao=;
 b=GKYiI2YM1AWKn5pcTAn1gIl/r6Shfk7nOClBn94tg9zVDJ+d98qBKzVk+JOlsX2wNQIhHRbhEJdxMBeUEYyyWvLFYEN7Cs9Ol525RFHRrkryTeeIQeZu1fEZwJMiM6vTP58ACROPcrxR+su1Ntl8potpGga7d7lR2SimyHY74SjGyNbn2lLeuwpQMdVrIWc6QS7TlyBn5zchVuhnF/prFJ5CVaMOmOnpCLziQgTcP0PncCHmgwTRaosGHDiIwptBHxxY2mnBtsVDiaGjoJfRu0LGKZbkMeBEck6kX2lbG25/Fk3sqRtws4KH+57Mr1rekq94pqieefRRLL+gb95LYw==
Received: from BN6PR1401CA0020.namprd14.prod.outlook.com
 (2603:10b6:405:4b::30) by MN2PR12MB3293.namprd12.prod.outlook.com
 (2603:10b6:208:106::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 14:33:07 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::7f) by BN6PR1401CA0020.outlook.office365.com
 (2603:10b6:405:4b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:06 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:06 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0e9685591b6f4bcba7382d038c2b999a@HQMAIL101.nvidia.com>
Date:   Fri, 6 Aug 2021 14:33:06 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4ef7d0b-70dd-4c91-22c9-08d958e71b54
X-MS-TrafficTypeDiagnostic: MN2PR12MB3293:
X-Microsoft-Antispam-PRVS: <MN2PR12MB329345EAB3FD825A1A423FC9D9F39@MN2PR12MB3293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eNECzgaDCBthgPb5QbNE4oEAYUd0F4E2D3ZfWH+6NaZD9Q1vzQRc+eyaXzaTHS3C+CrDrsFUfgMS3gCNR4fuCPs6UZ3yt98qr/kVXN1klosRQ22WJa9fDuTlAaD/1fo1iwd8fpljVCmf0H43sn8eBWDUL6io2nVmvkudiRGRrUhsrLfHiPYl5ziCRnHUGgkrDEpXznfNdhr2efwI5IejoVoPQma+CMErDav7tL6Bu76z0S2Zp0bfxtLzB6AW4ea7S6s9GtYyU/01Y2vH9pToR5CUco7QVaVEv3ZuQqUfasPcWcCMBdQ3yE9geoNK3uidd28hABGAx6mk0CkMvEcJDAlHFPEB+EjQqqUTUpeDueOX7gP6+Oj8cKhs9wZweWIgY8G0ZAYCSmuiXrH3yfAJsFKvkrVW+7LHpVBoDwl0gToo61nQSpH2PozMWYt6Pel684sTggn85ruT/ErEAGUD8eTnUPmM8XSeFxGNYczgpAXLW3dzgnp9LI605wLVwEGAaDpYNTMhofkVW07NZYztSl/IItwtXziMAl5tahWbNiOuE4SGl6byYMkdBFXnQPO2RKrthBkT4fInERdxXcpV2pBgpHgkwWWKzl5OW83XTuBlEzSiOwAkVXgUrYGUfSCEEtxQc9JitM+lcIj00L/G67/0ooNtKz6U7C35XH1cTqbCaBFOOHU8GPSILD4LtY7DKiDCJXanl51Q5IZ/bFTFpL811tLKKCaIMYuYn9Z7MtnOh7l7xaOub5OmRJ5nTDRmtLrsUEpW6Uyc69IXHY9oZlfMddgSeTg9bdBOdHXLiU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(82310400003)(36860700001)(6916009)(7416002)(316002)(336012)(186003)(26005)(426003)(54906003)(2906002)(24736004)(108616005)(4326008)(70586007)(70206006)(8936002)(8676002)(86362001)(7636003)(478600001)(5660300002)(47076005)(966005)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:06.7175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ef7d0b-70dd-4c91-22c9-08d958e71b54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3293
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:16:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.57-rc1.gz
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

Linux version:	5.10.57-rc1-g2966d5d51229
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
