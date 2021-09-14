Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA85A40A88E
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhINHuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:50:46 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:10431
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbhINHuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca4OOBjI6DbW3AUY9AE6aHD1Y+XBweFLQJQha2bsagWLYK8Q7t8zsHeTwJvC9lw4cHiY79ESVhD10e+TYWTKvWq+knk6CL3uZeEg7ru/N/NxUbalb1BVZrPi/0ZW88CjvRWRLsguVaOAP+miY2l27TUvz3cKkUycfeW2OArTs4ntFn9oQf/gCqdJyhdrrjzQjnyAxMIZGpM1oH6N8uGnEwS002hX/ejUuJ+2pBg+dIh2lXatE4zOWCNhD6z8J2yZhaMq/XZqndokReVeVAV9kilK80prOuvPSCRpQighZEcm44/RHjjL6jUsYudsYzVrVPfHhMtAO9C6uf00fs1yEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=u0GLbI5Ac6YBbPS45ZMEPhB1lXeZQ9w0gU81I2KvUtU=;
 b=jFSn+w3mIx/rpaj5XVn2Ti1e3+w5DUisL7ZeRNMlwQmeNmepzjQaVaOt67NaEoYFrLXK78c6G76FscvS0kCJChljJHDMA/e/uAI6FALtHInE+aXQbcu7eTf0a8azSQL5GNiqkd2vuZPLHHU/0nPnTNi8zWI+6J+ocLkGV/G4qe0LBaDsicKbiu3ZwHtbxUYrpMwKsbRiwpe7hVWO1Qf06EhHIG+QTQDkzgpZaln4JWWNjGmV3cz181yc2eXlNIwjK71/UwyJ5lYCq9h/AHWe+VE2/6LhEHjgbzzPw6edJxLWXFeRrEqlEha9iFzncCCDZpyzbj8u8p9cLz+M+ZS3Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0GLbI5Ac6YBbPS45ZMEPhB1lXeZQ9w0gU81I2KvUtU=;
 b=b+NKlcN6TtXRcUl+EIxrmb8j8CmkiYFnAjdOPwLr38q4WkiVWEdF15r2SR/FG0K5MypW5V9O06cV66i3eL06w/YexCwQdj/sk4klNVBnDtU6bZabNLMnLTmoY6YqVk1NWDGAAZDcYWhaZeZtb0KJUue3tRxINTwgDJemnQfeZFSIeIeePh4N70q5+WNPZAYVflbCHaaBYfIcGj2ZwapVzza2mRhx6+mja4t+B2mm/s/fdiR9CRqvSdZZ1E50RMXujPmKqd39uJH1zOKok3ZySgScUyTNLFJKNlMSEssmek6crQxdJMaVLhfS4UQ8eiJoVKUcyf287/AtETuUQ7GWiw==
Received: from DM5PR15CA0026.namprd15.prod.outlook.com (2603:10b6:4:4b::12) by
 DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.16; Tue, 14 Sep 2021 07:49:06 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::29) by DM5PR15CA0026.outlook.office365.com
 (2603:10b6:4:4b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Tue, 14 Sep 2021 07:49:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 07:49:06 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 07:49:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 14 Sep 2021 07:49:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <efddffb8185d4107830b22e8b7c3fb0c@HQMAIL107.nvidia.com>
Date:   Tue, 14 Sep 2021 07:49:05 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 205279eb-78e6-470d-d2b2-08d977542141
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0010:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00109CC02DC83DF52B381185D9DA9@DM5PR1201MB0010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYGLQmuyPPQwE/6FlPlhvrembJPwi7bPQrx/4nJv6NAAr2DLLoJoZ97o+rXCyqtk7+a9DzERd6QJ8i9qB0nvluBPUnN1i39Qtj4BL7gCLLfjHcxrYwPsSR0Ch6j9y38Sermdr4UTUeWI4XiHgosfjKovSWsxi0sYRBjD0nxwHLN60sv1hTEKDIKvzuB4oHZXbAH19sR2UF+F6mcQw+DUbugq+apnoBRhyvIAj9zcKFLSgRSsLzjKVMGynUg3WwntX5ytPifg/lZRWy4/z/oNXfjXUM+RKz/s2BsuUb28GGwCDjDpFuLZDatsfAGZQXgD3wwlODS/9W7guAY2rKzJrH0KBMvLnmF/d260CuFLFQQ1TWWNe9HLSpZiafy5v2nMoQ4ueT3gBjpSiGo2nSTFyU90lFN1Z48Ee0SZrJoRjpB/qpXK+hh8y+JzF5Rnr4raGRVTHrWhnf/9dGeBx29tdHLHWrgcqwZjkCmaoiIqiYNdYj1F5WRGnZ+QxCiDCFBmonxPLvAx4Dbri6eewsBQfMWRfb3gWlWWhmQpQtvSvBlDfQ0vxqMFj9LoOjTgnTz37DIUvCHeb36/FYpDHWlTnuWKFFw01yOdC8x4FZ0HY2ZWv5p42L+7WFD34emka4wGxFpjqQg0dwSJ+kqU1ZXYWYXDLl3Km+FuIBp5wDO4OMv3rc/JwGuNSpuiS2UWfkf/h+oNjdyVgX28yTiE0DkFwHaAO9Mfd6uqyKjN52kb66CCg/U25P30oY2FmkO1JvEHRl67LRKYTAITktzqdyHn99pnaLPxPJMETki0pGAHEL4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(2906002)(70586007)(70206006)(54906003)(5660300002)(336012)(26005)(966005)(82310400003)(82740400003)(356005)(108616005)(7416002)(4326008)(316002)(47076005)(24736004)(36860700001)(8936002)(426003)(7636003)(6916009)(186003)(86362001)(478600001)(8676002)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 07:49:06.7426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 205279eb-78e6-470d-d2b2-08d977542141
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0010
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sep 2021 15:11:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.17-rc1-gdaeb634aa75f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
