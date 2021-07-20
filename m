Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86903CF6F0
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhGTIwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:24 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:3424
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235596AbhGTIv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3oW/PBGnD/96XoGYywx+v1czbCa+3bjJt32b1y6IAhMyCft7Nh15GrFXa6/OzuyXVpXJ+VrSaQGQ2XwoZ70nXHiCC+M0hSkGOGuOXzxv3AmsuuYsdiR0wa/LxLO4iTHbe5pRl8LISu40zSuAGUnuq57fTlNX63fqNKmCGrAdmInRLpSXwe7/82JOCLx0fnrPr02XXgoacbDd7jbaDOEMshwJY679u7coQKD/SNKNiscORcS0rEtlKk0a+X8NHujTb7nBRAbhTecGKjmolNWhs9HJCVlTocER8i+v+hvE37wbfOPk4ml6zAFVUZCYfJdmS1xft5nmrpgPm4RnpcWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG/72874Eit9+IaNGIuRySF4TkwuAyJfzQWA2s+oVUs=;
 b=k+87qwkT//pWqQ9Ev27FcdEnTgonAMgIIxLXR8F2a8nYsd2Kv6wfTrNiIRUlht/FgpFsC46BraNBbo/NVlHqWUKK2kzbwbanoZOVdeksGwnP4IAzWbv3rts4w/I/R8bS9By3dsC4hMKFOo5ztza92LaZeIJsDV/+0w7Sv+LW/qPU9KABEjyj5SZdrr/LBE+Q3JL59kZLSBKXHxaTwBQ9ArrgUzkBvLL4oYwx5nrWqDt/jXS20lwI2NR0jG1uTBtBK2stgIyo1ofPr+MJGonz6JIzByi/4C0AO2it3rm1jT8gCg/rqeWdT1R3gXKSU9e3MoOm+JlfwfeRJYA7iAuAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG/72874Eit9+IaNGIuRySF4TkwuAyJfzQWA2s+oVUs=;
 b=Zw9/HTIIMOvQjmC6jGuazlGS4e50WsS6oUhIpX7cxn+Qyp8fETupJYCiu2svZD/znk7Z3df2ZTIf6UotQ6na9feKU8ILKtf5gdvU81RlGB8bsb2Y+8HavVm2BimgMyOE9VRWI3pP10uOsDv/IA/G/X489X+I+wkT0K8vm26rOtEEiTw52GVIzZRGuRPhpmiVmmwV729csmtF/4OLxcnZqtKuAH068a+6D7pqzCxHFXhhJVNIhJw+4BkChjHC+8DyU2r0iQ9fnzVdG3WuOzCmSb64sIwLI43QoD4+kul7Fs8jHpOWtiY6Af7HR8PWQULW8T8UyH4JAD1ghmpaWttpeQ==
Received: from BN0PR04CA0012.namprd04.prod.outlook.com (2603:10b6:408:ee::17)
 by BL0PR12MB4916.namprd12.prod.outlook.com (2603:10b6:208:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:32:34 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::b8) by BN0PR04CA0012.outlook.office365.com
 (2603:10b6:408:ee::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 02:32:33 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
References: <20210719184320.888029606@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f5d08c0457d94a67b6002d5952868edd@HQMAIL111.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:33 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0de0852-317b-4b32-ccb5-08d94b614e35
X-MS-TrafficTypeDiagnostic: BL0PR12MB4916:
X-Microsoft-Antispam-PRVS: <BL0PR12MB49169F76A60497DCCB648FBFD9E29@BL0PR12MB4916.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3B093JDdu+ErmOfwgO5ERCzBP99JLdIJULb7pKWCbmPtelqL7WgE0s/pzit+SABiJOKdMs+16FENg9oFiwrbk2IeM1Q56aqGS9BlEW6Bdhl7zdftIZqrKxUzqT5CsXmCz/K4k6z81DK/0CMFuNLtay82SXUXCQqVxXtnn/iluP/nHw3myJLp6/zUCZtj9ps/EYlbcBMEBcIOjCF+er9zqVDU3kO3jcxAsQRXnjWJqiSKchoA3Vy5ph2YtWFEY3c1+VZ5sAMeFoPBHoon12ZuRoBdFRM/c/hGv5Fks3jhooVTvLCFWUyUyczDl/Tx2kB+ZYUEKBuUwv4Nzg0uios0JyAXQhLZKyx1bIWTKlRK8AaJy2HWJ5oCrBqxMIf+zypCdC/8TbrMtEDHEJRLlsXfBHldcxevaHIIKfqrd+0bFgmNyYtMN7N9oQ3MvNOLn7izlqN0wWIoXJhKErNNz5XmQKMZ2PhCidQFlmhM6MAk1jENl40wtADCpXwF4L92dggoe9SEmIutBG4S8daqngMYclBHxW8bKNtYQtQC80gZxYD4EiJJFmOKtFQavlB3ypoTPHHdDLsnfxXFkhdvlrOCrA5wPozk/au0N6VyRIn+y/GijYojIu/97P0xXbo7nUKr7sMJJSY+aP7F8Ht3XM5icRdxAtZQsD2D+YBCBcpzkoz9PLKzlPRCcZ5U9oUyAj+NiGpizxqtZtH4umaiER75vuA6oDbq74MQMcdvVF6Ub28oDTHwWMT3YcjxjW7f4dyTmQXaNCxDI6qD5hpMj0p/njZyliqHyKYLcDdqYkKpJA=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(46966006)(36840700001)(24736004)(966005)(70206006)(8936002)(316002)(8676002)(54906003)(336012)(108616005)(70586007)(7416002)(2906002)(86362001)(47076005)(26005)(36860700001)(186003)(82310400003)(5660300002)(4326008)(82740400003)(6916009)(7636003)(356005)(478600001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:34.4076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0de0852-317b-4b32-ccb5-08d94b614e35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4916
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:45:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc2.gz
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

Linux version:	5.10.52-rc2-gcf38e62a0dbb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
