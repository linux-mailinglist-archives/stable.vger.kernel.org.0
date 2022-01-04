Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D20D483F68
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiADJxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:16 -0500
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:44001
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230272AbiADJxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+EfOa4Z4tEaglDDRq1etYPT4ZIGvKrkmtg/yyYH6wrBFxnRlJzto3gA7HYoKh3IzmZy6Ti0G+uMeiVb9Tq3ykbga3cdjL3o1G2gXnI+X1WUUMpZ5wQR9Foy+LXAYmeT8zqwUyVawikhAebyNDH/LzGPbKU3+EAMRvrQdqpNMy5ABnP1Ol/V12+4eEnOllIWciqg/yUf8ZSYNRb7Svrsr0oxK85a3zENrFsOjJJZORD//UagUmgI60AWqMaxdqdmFjx1SrAJcGJ/v5ye0vwZv8HxYyfVLFYhUo68+LI7PW4hdIq2Wh586f1sNDuBkIwyGGzeWCrtAXn3545ia9HNmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpxJU4fVusxr2+h1jCPydBoWvrwqBpBezJRiIvf2+VI=;
 b=l7TUHzmRxC6uIv6mhXGTek8CDAzU1cp5LS8h7kyQxz04dpjChjKFzfGYXZLBTmO1VAcIBa/YoE6eDZ3tiBQ55Geoiv88x9CFPb3uEOtbsTJ+lSlS7mygvFKOkG4xg+wxUTvgznmb/f+TE4eKkV0GVuzd2FMIZ2sENLtyCQbEsAdBT95ENpc6WBRGT/eXoIkxHZx8hu/00dF/5G+6s4LG1181Ks6Gq2IsIF3lwfvKUrQy4nsQh02bv6dTA6TCP83JLyO2J7tg6MJKtRDOgRwFG8RlvQcwqa8yLvCM7V3UuRjzEOrd/WbZG68xV83DAI4esGiSHF3RpFlJnRxmN0+P2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpxJU4fVusxr2+h1jCPydBoWvrwqBpBezJRiIvf2+VI=;
 b=bBx1PnXubRjnWJ+UtQu00IopJGcgzf3Mbvlbp9WHJsZQA+UTivBUPCtuIVh6ywAVj5Itt/mZkM6zwGunDZHSU+FRwvP1hXLo+JjcnivSsdiqBkbn1hA8FGMw0NI5eRHHB9qL+lWETFKbcP4QusuioV1XNtTcSw6+C6G71BuWTnZ0gO/OFFUfP+Rz0/fATeQIfVjLQEAhWDtDgs8MX4m92MzOsRtUHwYwE3S81skDrcXCi1l74jLF+LzG5Ddj+KhTXLaK4kzojhX5qORcm0tjpxPeLVfwMuPc7g6kLdmvIQXULmNnf7qDzZNJUo3HoDooYtiRM/2ZxWP4VsxKT90Y1g==
Received: from MW4PR04CA0179.namprd04.prod.outlook.com (2603:10b6:303:85::34)
 by DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 09:53:10 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::78) by MW4PR04CA0179.outlook.office365.com
 (2603:10b6:303:85::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:09 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/19] 4.14.261-rc1 review
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
References: <20220103142052.068378906@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d54bd7b47321420ba428a88d7c2a6ed2@HQMAIL101.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:09 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1efeb670-977f-463e-64fc-08d9cf680406
X-MS-TrafficTypeDiagnostic: DM6PR12MB4926:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB49268B189E1CBE28A9325880D94A9@DM6PR12MB4926.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //VB3gB8krl+IhKkAEO47YShz9D6a5aN3d5ltOY6I6xF29oi9Ba1Xo5EOVs77h4tsBXnbFkb6G9kKwAgqM0KwmAfcBvxkmhMuHXUQkh99o443mZ2CN+TeCrRgNNtHRozDL6lc33h3w5TcvExVPphehhoiUhm4IhuWhjFyRnxsbUEr/enjQDtyCb5S0ZFxdfyv5u84HuN0EBLYBeJ2utklNEmSFVI4RH4Leog6zPJCIisS+yz6jQerEBZ9VuxfYM/One0bl+a8E0By9SwUFcQMC6OffQcuXg0wKwaG6oTbM2mOIKXnG13wD8XtDsjjgUUaPYvUol9TW5S7iN3HV3DUpKmXYUNX8hsO9GVLz1oVn+A7ngxjoYXQPbHfxEWfFKI5m6EV5XjvMYPFSSTxGazSLuccgxGf8CknD/VFNMIb3/RXQvIIJNZIhe3iVBRUNqwxpTv6XET8AnvZFGJVCbfZg2dVbnmvjz41XbfWVrDFx3gCNljeNY+GT/gau1+EpVq1R5j1jE/EJnaPw+1rafnHpi+zsDtjooaENZ8F6pPSoGxkiJ47qKxCbo9U698LKwdCrdMIdkjd/g0SPH4AOZNZReQB4GdVO94OEx+VF8+qHgKWJiTTxvOSYYfsvZCl/zCJlwoMgg/WgH8Pv5Ez/g7ZU73Sgi2RUY7vIAL/87j64+MIEy+L2qXgb4r987QqfJ0hvW/guEMAgal2jhCZ77BcTNkxjUCGygtvxo72/PBt2P2yjvFxbv3DPG5U7NEPqf8ayPWOWmlJiGpEsbfYnV2BpjmYg4M139cNVPUaZueKJ64jE45xF4q9tOC6byYuvzoVMWT2VrfSuFdErMyMAsMvs62VaM2wtAxO+0uYxCEphC7E4qKHZj2JIwdV8uCL8Zy
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(26005)(4326008)(186003)(966005)(8676002)(82310400004)(316002)(508600001)(24736004)(47076005)(86362001)(108616005)(356005)(81166007)(5660300002)(2906002)(6916009)(36860700001)(336012)(70586007)(40460700001)(54906003)(426003)(7416002)(70206006)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:09.9462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1efeb670-977f-463e-64fc-08d9cf680406
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:21:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.261 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.261-rc1-g1e980b44673d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
