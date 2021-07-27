Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B03D722E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhG0JmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:42:23 -0400
Received: from mail-bn1nam07on2084.outbound.protection.outlook.com ([40.107.212.84]:9814
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235978AbhG0JmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glL21SS9cyjenutzB1VoMAbUzS4XFglSUmj4sWvGhIMd7ZL96fk6CLwGu3Ld8pEEeciqKIqt5RdOCpeQCu8DyJabUggJTGzhJ/o4hjoAG9uZO2aZQk6RSzanGM2llhDsS351arD+lwG3+4ZJPeetPvOccI5gFqt4LZ9xl0s2DJTM43fGhsIDfdJcFSd9tw+Wd1ZpDm/cZEXyOXaTWRDTYhC8Fw/Cwfsa4AhLhJr1iIJCMIKPLE8bk+X//E0urCrvRg6Luqg6ny4H5V1NohcztyZaRWgNUVR5QLa1A0SV7/R0delbgp1i1x258G1piwexz6S2N47viwpamw0NCXu2+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THdD8CjJN0tv9g+TYTI7TofRLoF7u7vlgPHvnbvREAY=;
 b=hzCQOfX8+DtW18mQsOhG91dsQ6+as5V96qPOU9hEVihtoIElVet0zVy5HEdIpcL9k76wh/I7hysAwHwPPp+0oMZI+kQ2ZrLb5QIJlnoihHf1LNmSr+UwQyFJKaPIzM6pvRlOgG5AO9A3ymZ0xvsYxSNLLzHOew5VOojzuWaO71iTbkC6asTcSHAALKA+SjMQAoxig5uZ3YRNeuXEQjW7eN4kHnE/w/pzPMJQP+pZvr/fCWprScbjBPBXWaOQ5g0dqhhI3qWp0lJmxERnymgsdgruf+/yBCeqr1+AFhZiWu6tIIs2x3jpTizLhLVdI01aoLwxdb1UJ593ZVhSjwznFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THdD8CjJN0tv9g+TYTI7TofRLoF7u7vlgPHvnbvREAY=;
 b=gSwZPaGQvaPjcqc5SJwSqknNLZPFR+URxD9sO/TKPKlmXaOBVpx+8HG78bokSvc3HJ5eyNkLFzxbxs1AdFrB0Un03dnq2bXa6TMmlCDf1Qg+qJOdlE6+iTQrXvrt2N7YTZz4OtIWcjsSZihM2cwQ5Pcon56FPh1zilpsr7RGcaFPH2oir2qe54AUZU/0+QK8EMNrBdo8jGLUuN9JubBe9aJeYqdG87Q796DTkOPC34Gp38u0RWSf7X4lI7aEcMbmduVWrLhYvpFwF0WOPaCHQfJECXRtjiW6lFhRMrAYvIEIzaM+TT+ubzVVMgXqO8fVv07l7c6Ca1ORWipNjHcNsQ==
Received: from DM6PR03CA0027.namprd03.prod.outlook.com (2603:10b6:5:40::40) by
 BL0PR12MB4723.namprd12.prod.outlook.com (2603:10b6:208:8a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.29; Tue, 27 Jul 2021 09:42:19 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::94) by DM6PR03CA0027.outlook.office365.com
 (2603:10b6:5:40::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:42:18 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 09:42:18 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/59] 4.9.277-rc2 review
In-Reply-To: <20210727061343.233942938@linuxfoundation.org>
References: <20210727061343.233942938@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <68962e13af6643168560a05a188e33b5@HQMAIL101.nvidia.com>
Date:   Tue, 27 Jul 2021 09:42:18 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cb374b4-1472-4f1c-4edf-08d950e2d340
X-MS-TrafficTypeDiagnostic: BL0PR12MB4723:
X-Microsoft-Antispam-PRVS: <BL0PR12MB47239C0AA2B9DDDD07BC752FD9E99@BL0PR12MB4723.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJVVAmmjW1d82wUJVnuXzp1J0ynMuRhUgZ85EgFWWuGCPs9je5u+8mYK8BVZ+TI9yhV0p8FM84IUJnj7AAWzqNDN1DK2hbGolcZ0E1dIGAuL7haDwszAG2ZW1fm4RAO6UYrwFU3HXxtpCzfg7Twi22niLsOgRmJiO5iGsMFADh9MZpydoxjenMXltNzMT0O06Jo1J7ZdKaCjnzagoPj2urGxEFFMaq70URuy7Y5SY15GS8rpzb+brlkcTcOFweUyWHcDwMOtrlOjHgUoN1/c/9YMXKAXPxGysU+UYrqrEG21ctr74ax9YRXrdin6/sHVK+T7/gEmlLr1mZ2e8xcQbSo7v1hWwHL/hI3HcgQmP8QFWvjHPVlI52m8ra8y1/ZjoTCH9baf0nt8wCw0pfnNL4/X0KCW7g8mof102DXyHsehmCqCeOjyL4lkoJz8vWG0V4E7YMkCQeBFTCK80giX9woM5iqG4ES5dQThFoEEQa8YnEIrJSSB0S5oA5dpFOziTumBkkWDt4FCS+3JQc3WWq1DdZw+uDDR+G2wM/+w1gNEHgdMgfd5znGI2mJN8kg9Yrx2QauVV96VYSjaHWTaYfOYQXUgy9R80HQgfFEoxVPdpu/TKwJwf+DMA21BLie+gRxPExYoAEi96QXEgf4r0lCDgGDgdEvy61rwlWMyD6zOAFuyQcjfyqiAVooDcBNJcRKvrKaBhHo06RjCpDeKySxwl34kZ+koMG4xYndQWQ6GULKIMyYFdJMCOZ0Tht4TFUJSJ/JBGTs5XnMkEVcy2NQ9L2OBGD/NgGtO7IYkyBw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(186003)(4326008)(108616005)(36906005)(24736004)(336012)(426003)(8676002)(478600001)(36860700001)(82740400003)(356005)(8936002)(966005)(7636003)(6916009)(82310400003)(70206006)(70586007)(86362001)(316002)(47076005)(2906002)(26005)(5660300002)(7416002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:42:18.5284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb374b4-1472-4f1c-4edf-08d950e2d340
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4723
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 08:14:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.277-rc2.gz
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

Linux version:	4.9.277-rc2-g7f2ed58b6df7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
