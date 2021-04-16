Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07D361D39
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhDPJWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:21 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:48224
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239784AbhDPJWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7AcalC3VhCAP6lZCqnJWU9Q4HTVRMdN8pI67iI5aR8Gqj57kw07reSPrGhboFXGC/6lbMsJzvUWfZ5xCqNo7yrPu0TbzuqB2AdnIdpEjGoZZNBClHGDM0Hp6Rx2BEUKj/96k2ihnV9jwbVTgD4/4ChLw8rhGJO/uuqPh1MekLCqsg+MQJQ4X9OUStn3iO/2CR+ahe1GeJuwkzNiFSOQN68nL80UfIMqN1IZS/4YfifAF6bVwO6m+sCfqQmwsu0iPKiYzOH5VxGYpkY9oDEJ9q0Ts+96DnEaxbAz09C2ZALXblM6PIdCUIhBZXRGst7U8rgOmirT1owY914Ps9mIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khzLGSCdjmFGSYkHJ8qfP/RmkcBZ2G5tSYXvhbvB+N8=;
 b=U+XKoGrq6OEW8SbFWe7GQT/JAg1etq3nYrLc29l6FSwnxoVqGuUMU+4YKTzv5LEgqkVMaIH0WFtzXILYYNpWoa6Kb6qg/51F3JEJ5IqbKhzsaz5KLyT8w9rtPPvjbhsnbwd0nUR1eMqivDsF30Ese5GflBF/LHCtUVs9ES/cpZnRgm/s77i++xRtocVXZ2j7eVSC2SkjBKd5U2e38Xq4Trgw0KLlTPHlzx5YPxgQKSnYUErcC1iMpajx3cU0oroENgG1ib49vaS1HMuspLOz2JMT19bN9RFlW+ENDa2ATQt4vGXxPS3ZpkiZYGdL8RUO4RgcVv7anHKuGpJgbPEDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khzLGSCdjmFGSYkHJ8qfP/RmkcBZ2G5tSYXvhbvB+N8=;
 b=t9RLy3NrDtm+/QqdpyKlFIlJ/Vc9ZNE3SBC72X14vz0ZFUuhC5I1UVvSgsIaGpx1TT+3oOL61MoQnF5pUyjNNYqYQN/ms8H1P71fw9NyvfL1HQ8YN+Ul1KPnaUXPo0kXlK3hQVPht3/9Ocu5UaGnF7nJUSxAIkoW1ql6tYDB2wghFTKaz1RaQW1J/RsSHBOfZTeEIV8bH6PXm4YhtsUNuQlwiL0iO/0bgHnQRnuRqobEAv9+zhBIOZ6JJC2K7szIjsuCxOx173UYkWBmKLxkhElAFanmTOiJLjashYzsoLRub4Qtd2K7fDHXbdQND+08ZQEdCtS52hADzz4xyuu49w==
Received: from DM5PR12CA0072.namprd12.prod.outlook.com (2603:10b6:3:103::34)
 by DM6PR12MB3530.namprd12.prod.outlook.com (2603:10b6:5:18a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 09:21:55 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::b1) by DM5PR12CA0072.outlook.office365.com
 (2603:10b6:3:103::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:54 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:21:53 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 02:21:53 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/47] 4.9.267-rc1 review
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f03d716424e245619868bb42d8456f6d@HQMAIL109.nvidia.com>
Date:   Fri, 16 Apr 2021 02:21:53 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80e75a5d-936a-46e1-895f-08d900b913ab
X-MS-TrafficTypeDiagnostic: DM6PR12MB3530:
X-Microsoft-Antispam-PRVS: <DM6PR12MB353085CBFB7413B9C87040B6D94C9@DM6PR12MB3530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmhvBR/wuAEBF6rvy6suesa6HWtTpRSNmAzp+45odHuoslLSL7RhJjTe6UfBJ0xaQgXeW8FfczhFdu2M9iHwBp1iZLcSSsixDs9sMtb4HU70hSJznTIbf4ku8RKxspnJ0Lfc/+6Dj9XqoW3AcmW6mqAI7waokQxDKIJgHGMS9L3NZo91EyHUxwJpeRW2S17pRPtTrwSoc7uLcgQRCZ0HuPazXbAGOY/sYZeW+IZW2W72H0x/ZVdQfuyn7VD4XdfteGNYaOlNMc1mBDQ2NGcCzm7E0NSV5cTQV7bWPMHZp24WH+rJutTbAoijnoLpi/NIrLxwEjIcvB5KysytJxEwGfZgGcU6Vpu4fZzZV/eeMGKMQy+vmHOIKup68dLrINrVbs07xr8JRDdcZLbWDc7OnvyMr+oAf8G1mJbfGpBNGhzqTYZKQtWeI87X7THXtC9URSRr5PppEwuj2qOIn3xJ9u08Aj406rFUU8juXgF4ENXVfK8urJwcQTqnarOXQV6h84n9eImawvBFrEPgAMRBenIs4B7DbMhohFIVhABOF1P/CMUkV4ggueLxZ7QUQ+z7b2bg5DVamHhvZXz1eSL3wK/3LjmS73SvpEw12c3DgSxopsbztW4bOG9dwZ0gSI0zztv+N/OfIUbTcfIEOH6bWtEV8SwlEivnyF7DNh+fdoCuryPACmDMQXneKOz4+zqta4SSPyLJlzYnJALqZ+ayU7SOIjzDndEr1p4AljJteEA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(36840700001)(46966006)(6916009)(47076005)(54906003)(36906005)(8676002)(2906002)(86362001)(5660300002)(8936002)(70586007)(36860700001)(70206006)(966005)(4326008)(108616005)(82310400003)(478600001)(24736004)(186003)(26005)(426003)(82740400003)(316002)(336012)(7416002)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:54.6695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e75a5d-936a-46e1-895f-08d900b913ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3530
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:46:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.267 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.267-rc1.gz
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
    32 tests:	32 pass, 0 fail

Linux version:	4.9.267-rc1-g5183cf83a541
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
