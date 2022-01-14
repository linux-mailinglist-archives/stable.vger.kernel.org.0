Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E0E48EFAC
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiANSJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:09:47 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:28730
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235405AbiANSJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 13:09:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqIwZ2ZtyUkuqewztFTQgIOoixBYCUL5wUEKDFgO24mVqMyyt0FRO1K7UBIXb3YdxvlzTE51XVeUOjcviTDZqQob+nNmUbiUvfJ+3iM0wrNgm0s/cTokhQgesZol7Qw56VMpgz7O71sUBgFSb4zybMxGW8DJiK8CfU5YFd8Ebo5qHDvf54Of3gOYn85iwNJgyH/43emNHJtihBOO2dZprNhI7/H7OyenCD0HCPz5Zb8WzjZOLb6Bzd5OrO8Ow3wG2wvULEDFiUi4yuLqDGHrcE/t3YBFNNjiLGdwKY2jyxT2pi/f8FW0eWU/X2VKeSe3UjBOiDFyOeVwnAt8OYFEQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2OPSrtf97JHbptnx1hCw9cQ4aWWaahvrsBvPLTbu38=;
 b=KCgMooSial+GjAnk/gmUFhyd8i1C24zAEgDnHLVrrGBV3H2Ei3x+pMdL5VMq/XY8aNZWZ4nLqIYYlp1ALBZmCs6OBeLT/CpaVpUkuKxCFSX8DwiyrDN+tu1HlP5i3ruSXMmT/d/EnDiZ9l5MJ/NnwgHqNRdAr++VBLeviy0MJcLtHRcCuMoihL0rL+zPpN+x80p61k/kF8KXO6HmORgHcIMvuFHWMCUd0C3u6Tv0REcVn1qjbNI+yy2LPRYshZM0gg/AlM6aQNfBxpn2ngGs65hsEbMxwHTDJtqUNlFkhHuym5B0f93iay+k6wtEceQtcTB1McEcbuMloCax8BfyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2OPSrtf97JHbptnx1hCw9cQ4aWWaahvrsBvPLTbu38=;
 b=X5Y5SLGNPtGRo6kqure5nS9zpVMs05AAuFuD/Iuq1LYgtAsIGzGqjNeJhqJQ6S9vwDomLnS4ltbhho6WnOMGZIdFi4846Sj4z+Pe2jBJquM7nYEZ6wFX/TBq/2RX6XtlGR5zdfea04KjgeUymqMocIsBzczMFSG3Bv0qmoPZ6x22JPDmvv7dU6/CbQs5AWRh6M7nXWe+YysAVTff1ifbND97Ju1KyAv3r0CtKrRQU0OxXCS0EMpycC7yz5U5XbLP4RgS1V3eOrkzJ71FqGofl6YNaYqcpVL7IdwUsgMQptS8xrUs8yv5dvTtWJu6no4PS38ZdiYSvga1GetIpq3sog==
Received: from BN6PR16CA0041.namprd16.prod.outlook.com (2603:10b6:405:14::27)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 14 Jan
 2022 18:09:44 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::23) by BN6PR16CA0041.outlook.office365.com
 (2603:10b6:405:14::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Fri, 14 Jan 2022 18:09:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Fri, 14 Jan 2022 18:09:43 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:42 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:09:42 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 14 Jan 2022 18:09:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d4d7a9ab12234532bb12775d1f208449@HQMAIL105.nvidia.com>
Date:   Fri, 14 Jan 2022 18:09:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc79be92-c736-4d5c-bb2e-08d9d7890a97
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB02144D62AC919C1C0B5EF531D9549@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75AwZy4vePtcwLFL1hV8j1BoFkpZngWAt9z4+61agKQXWlTgi5yls/uc/SBrE2P2uYKPEw6xIdMyo6M4sSgBMF7VZbWXOiWv827Z23VJSrJwRMZ5Gnp1JHidEI10Jlb7HMdYNo34nPh0wdtDzHcAErzXmOGZN5x3g5fKK9n/cqK+NVDvB1pL4GWzRp/mlaV35Y/X0A2u3Bc2x6cpFFOwr1dz4qM3DPDM0NyBmX++09/ccvZW3SpcfPVPsCTkvHSt7A6i/Zmm8UHnjl4JRsNcDf6ncQ7Xgz5ztPLCQ2whjGCaPG4WcTHdYmTu/IKj36+tntOzy2OK+pv5PovKZb4nxP8TNvbjOJlvD63Bnn01GCReAPN7JHdami428ZKxUm0C7joeFTW0H72DHxqk9BBaS+SUSXluIG0QOfsXt0oY4dYLDAMrfxU2zgdxDEXNwJSti5cMH9okXB4q7Fgs9s7am8RRnpLlZcGRIvXsvCzb7+muBjNYj7dNCxZkdpRaDR4rT/5AmnsDpwoswj26WS1nOcPt4TPf5YAf+CaVjje5ONiAmPNBOFlT9yrO50ji8CYibuSy+Iz0866OnDt6Cx/J2hchHQpZQW0h/4L0XcAv83WX0HlysXJKrV69ez7uHY+jisDX9hZvH81Uxv4fT48zfQ/IlTPzLycHUhY83ypjKcBkVA5ttb/Mb7Bh67AoNrVLMUNRbd+vpyhEukOA/Wk/grdkU16DPR46FrTttTMvo4mLAMgYtyQ4ctE5Re1tCDhfXm8Ekd/QkJoBuwjY3iUHBjpAscEDQODkubqWWY0Ryi90SxuAc6/8vYkLV6SopHygJyt0oJPSlA9RsTbMGtnB3Mu3ii6aeuL7JQsUTcJngNKsGi1jQyHkqWRlIM/eVRnu
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(8936002)(316002)(508600001)(24736004)(82310400004)(426003)(6916009)(186003)(36860700001)(966005)(54906003)(336012)(108616005)(70586007)(47076005)(356005)(40460700001)(70206006)(2906002)(81166007)(4326008)(7416002)(5660300002)(8676002)(26005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 18:09:43.6280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc79be92-c736-4d5c-bb2e-08d9d7890a97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 09:16:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
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

Linux version:	5.10.92-rc1-gfe11f2e0d63b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
