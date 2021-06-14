Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA703A6DC9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhFNR5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:34 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:6211
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234379AbhFNR5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glPc4YfettpUVnyoTO6aGl3RXBdVc8lgFNvZrStt++JQuVz+FgDSa0Aynwbb6v2qNXAvqGii7ud3oD01LzvJh+d7zMQCZS1/9a0jFwVe7zvWMjzbPySh6dJXW3AurSHIM9IfnJvoy1LRd4MmMaZN53nNsmoVmZPiXsStX6s5xZhPNN8FOSG8ZSSohGeHI64oX2WVOa+AfcYNBLAyRt9fqlatX9lERY+rEybSnPSrkdKRkXImj4RfgTSSBBZ3V+42FbAHdj6FceE1scdK/75NrJkWnbFRec6bNe5fZlAzeBeaE4EpmfvWjO/pwPVi27Asf9McHZK7k+9MXIDkRdMQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4X2BXizWY3F3r3o7NBsyiiHY2EGcsQ4IqPPDqc+ofc=;
 b=jI5Qc8ytVGg+xGMtiCq6KqM+XJenI3LSOjxJD6BLR4bbN71AHV8R0hBLePKk04xzIlGIu1AyWMwpj+2duMbxu/krUi8Mrd0ixe3fMencykTQ/iwmav7L0EuJwG2wv+gsRou8J6+69WQDPlmH2BICTJyO3P0LAR9Ey5YHtsRt59CT2IcybFqv4UnQZ6uYBYqCXnv78Vb5naeYgQC78geu18c2uZ9+OBOAbOlFNaP04aYbCuMpEtI5y4rl2Im3szcF418rxhac8kPx6Gq1Z6JtY0Ocrqti98nqFpCUKcSSlFORqXeOn/IfWz2JBrdVqKtVu201CIVnuQTeN0ViLeHBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4X2BXizWY3F3r3o7NBsyiiHY2EGcsQ4IqPPDqc+ofc=;
 b=g1jFP7SuXWb1CC3q8ySAUrp3mpXejq/vr5BJ9HhWPzSPYRIncLq+x/JxNT/ImPN1SpqJMq5fB7NWO9JujRhOJPqvcWR2IEtWg8NY6z6l5e7+2U8GPeKBlPnm96h2w1uNFifE0Cm+a+kmEXTUjTGEWXTlNQN68DhKoFePRDBtTbhCG1D5wCMa6SxjfwTPpUYv6TSL0ZFynFoORrQUGUL2YCorKqG1shZvDiv5ofXmvw+1krVBMgYPab8WmB0xIVdNCx4ReSm9PMWqM6VAdUfpjLWuPYD56NyQ0wzolz63Uv4ZzA7FaqFTqiNmHBavsshcuheDnlpxnMaTywXEpEa0+Q==
Received: from BN6PR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:405:15::13) by CH0PR12MB5170.namprd12.prod.outlook.com
 (2603:10b6:610:b9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 17:55:29 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::55) by BN6PR1701CA0003.outlook.office365.com
 (2603:10b6:405:15::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <07f96268527b424fb6e628a9be5a3857@HQMAIL105.nvidia.com>
Date:   Mon, 14 Jun 2021 17:55:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce576bf3-5ada-4988-e7b1-08d92f5d98c1
X-MS-TrafficTypeDiagnostic: CH0PR12MB5170:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51709F28CFA2C61ED6FC85FBD9319@CH0PR12MB5170.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Law9xG+st2+xfpExIF7p9Eq2VYMLRK4Aq9bDy4ehBtVmvcE39expG8N4gEYIUnIDtp6RfytFqgTSRvOoeMHzwP3smBzz9S0i/s13Lbc9TTlm6TyvzuHIMBI5UmKbHdkk5eSEZZjnbMDCsP4bCsg7DZlE2uNYDTiwIWqhgIsigNwSa0bN5BC2GuuttVEuuI180lB1tzKGuhvf0cp4kY3o08VIrA/NJsOVOT/siWQF1TbPDwntCBSYbsPQxZa3LkFnUiOjVpQDPasHuMOEvEi3OjNteQ9knn6LK9QcFfUCiZlHVWUpDGDqLbVH0ln0X+QAPaEa8vnkvOnQ3yvXrbsejab85gQwnGpNt0OI+1P+yUIphZgeL3U80hf+sKSd8JDbeH84qmsiBcFTcRjY/xNo8PUmPW6thrVYpTSxPA5dst5cFX9ZZ0mMkcXnFnCrLIYVwknRmF3S4cuVJkp8n/tneBi83bi+MgZATRZiyhAS2KiBhHptrNTkg5j7sGOUDeWsWMD0sftx0KkO6yV63MZUZ00gfNTyMZjJeG20Vh+/Ov9emA3svFxly+e4mf0owM+tHnIjYLh5s1xdGAbNuAX2yWOaa6TseJ9b6SdMeD00oDx1czFvFk1YJ3wrESVbwMw4PVfEozzOJloNMPK2py56X2cDhP9tp1ftvRtKrk17+Rx6KcGRWjo/2Q7JBC7uR99EPHB1C8eWknU0w90gG6zfOuaFtVPDon8Fv61Ku7NfHdS1uQHWkEO6gAeVniEnNnhLQjsOXHIMgHegSiuLOcrcaA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(36860700001)(86362001)(5660300002)(336012)(966005)(7636003)(82740400003)(24736004)(70206006)(54906003)(108616005)(47076005)(70586007)(186003)(36906005)(8676002)(356005)(316002)(26005)(4326008)(82310400003)(6916009)(7416002)(8936002)(426003)(478600001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:28.9045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce576bf3-5ada-4988-e7b1-08d92f5d98c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5170
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.126-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.126-rc1-g4a2dfe908c1e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
