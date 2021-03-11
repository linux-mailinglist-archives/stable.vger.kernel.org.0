Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA5336D72
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCKIAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:00:07 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:31457
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230154AbhCKIAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 03:00:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Psyczv+svpMpdF7QtAhFvIAGQP7EdWxs6ul7aNYqNtm7sESK62FMWdqRTlMj2zr4UR87NmkKq+qSbypUIDV57jCuOIWjMQ7UnekZkrNaAOFD+HSixLWLFsLoiv1BmlRx8iHeEjpHPQEbuD9RZN8oPgtE4+XXHrOiXMa0uxskmRQQGS7rjIuk1dAiuVDQTWJKEwHMlH1lNs20HS2QjvWMWMkKWGopAvf6FDXijBOS1m9/VZAkhlXP3TDBJqfbkak+ddilpVOfOGvs1fk0DnpwYGtBDBTA7ixChyrRv/eK0wx/InL/u9q13nM5lpX9PjV64FUZCLGkBGrbij7wuweIGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWhX1jlYJONlXyjqkkgWhdOl57WJQC62kUak+0F10kk=;
 b=CkaK07Ej+aNIfx6+ITEQNxk2ImRRE5WHN003BE3FgyEJxMxD+o/c71jQoetztSXwEQdWGfjunldy4NRfBRvS9fZ8VFkg/H9rqJyt51CUo8d4Scky9Jd3VdkjUUDdR8Ycym1sKsuxLi6n23BxTCTRySD31iEc3an8jgBYxroMDHLAeAgveQQc/jqCEBAIt9F4O7OQWGfcEvT7NBSxHn2E5pYU+2kSLojQnSO0hPng8iu25wpz4+js237vZsmpa+w9dYNFXqcoOkMMOtNw6k1utgcHPo5Kc0LOFqCkQNtXQxlRyNTUqxWO+lvWq/Nf5A4261V3+XcDSaO2hrsLWEHf4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWhX1jlYJONlXyjqkkgWhdOl57WJQC62kUak+0F10kk=;
 b=mq3q+uwXbYg10Pu+IDOzghCKmhEZ9lXRwBIC+bcLn3VKwcD0yDttYEAXolswwqs7GmzcyNBmXjIpvkePVo5uRqL5cbezQiOBDK4CtD0Rb4GLa/Ll+L1LaBGwF/5Las2cdIN760vrwlZImxzCb716XfDkbJ8VxnOOB2td+Dc/gmvDy2+TgR5SoFi2HVcjrxRMXNmt6QkmbSZs6N9zqoVJQn1Hd42u7FrBA4+UOjmRtLB3xP8e7E3+C56dhRMtw2jR/GZYoQ+lOQTbgb7xaCTV3dgSLF2VIr5Co8f9FljXGIshjJ400k4P7VPMWgaCZM+5yihDIzyos+1OLN4pK/Ql9g==
Received: from MWHPR22CA0005.namprd22.prod.outlook.com (2603:10b6:300:ef::15)
 by BN6PR1201MB0019.namprd12.prod.outlook.com (2603:10b6:405:4d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 07:59:58 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::ba) by MWHPR22CA0005.outlook.office365.com
 (2603:10b6:300:ef::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 07:59:56 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 07:59:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 07:59:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/11] 4.9.261-rc1 review
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
References: <20210310132320.393957501@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4c075755687843c095425f2602fc9e1c@HQMAIL105.nvidia.com>
Date:   Thu, 11 Mar 2021 07:59:54 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be1bd9ad-4fe5-4c30-be28-08d8e463a904
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0019:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0019AEE724393D10E30EC0E6D9909@BN6PR1201MB0019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7sL+uOaG/STmlLwl53ANtzndKdg/SVzPtMrBF1LT3WlS6l81KEmjsnbJkqpzgRFRSEmtSPQjLdg4PuEVhdJl3ky1QXTXyPbZi0gUp+kMOfdWpS8OalKOpnLvZM6fWOzVnROizMxejx+tBslIUGs7TA24fjQL6Q3ZlEPJJf0PHnah2G+jefkgXBmzceWihS2VMY83/aqhrW54cKMKzlNM6+OZmxRnVCWMDqupsj9pAOJwIiZ33vWsH5SBvMrfm1df3ZGnIQNqSlxrtGZCtQwAnHV8mP6LGq5dSdaeSfELlFa7mJiCib0xqUoOggpjCozPfNVpZUqvawNPNGY+kv1GVxFfcAbgejgzHJEZjImQBzjGN19783GbeTnbizqoSwNXki9/W2Z2zMfRPPLHReCGBZw2HpkEjqRk4NT3+1U596mC8VTaELHN2ODyS5NCi1dIlmbVTMmGIf2Uvl8UAQvLVrwOddw9qTqP+OsuKYhj3fbUaRXA3GHU2v7sOAf21rbnSEK8D0lTwgEpCf6x/8hjiuKIikK1e7WtIjUlNp/0TZo3Vj0VhCh/FBIgGmBmQJuqbK1qM0W+4a/PkyYsebPzcroUXecMlsLGzkCYFJ7auEVx9s0VasdRx/U24KTQdmha2GRlZcvWV5Q3j5k7xAu8R/BprWPkNQI0UQsR1p4uMKKtifloN//zbQDxXS7gEALZ4mLz6gInhg2ZtP/wLxCCJZPCobE+aurPctDTUynikFP3FLAQ4xIiiUbysBCTfsdWYd2iukMRksDtkU+57TqNw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(70206006)(2906002)(336012)(47076005)(186003)(966005)(7416002)(5660300002)(54906003)(70586007)(7636003)(86362001)(34070700002)(82740400003)(6916009)(8936002)(24736004)(478600001)(4326008)(82310400003)(26005)(316002)(8676002)(108616005)(36860700001)(356005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 07:59:56.0461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be1bd9ad-4fe5-4c30-be28-08d8e463a904
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0019
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 14:24:59 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.261 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.261-rc1-g8bf14e5a6c5c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
