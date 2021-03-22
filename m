Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2D344778
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCVOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:36:01 -0400
Received: from mail-mw2nam12on2082.outbound.protection.outlook.com ([40.107.244.82]:47287
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230182AbhCVOfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6GoW3VsGC+nBMSe78QrnGZlHn8elyavrHWSfipwN36XrYk2CU0xa5OLJy+f7vWMl4ewGHupsL1313Pmfcdn1lUwSsegmVzvjcB/oQ0DZL8jpLobQfgrF6J03GSTItQh6P12m0u3OT3ogc31kNx614e/fTlg5wcCnHlKU4YcizsHlZBJJy6BwE1UsfOQNQxkESyawmpmYoA1TFRj5NaBEhN/8/yAF23VnXw2MYZGpcTGzwli6vaTS22DOHMXZe2fVgJ8AjFhlXoDpwOBakBSSIJfVASGbyqYhMBOpozl+5+3A69olAtnF3wXe+HwyE5J2AQ7kKeS8y/BKyP9RpGGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5BzfMV14oHZGnP6Ot9DpLnSFEJtW5Pn3aShCBm6vZU=;
 b=Je1LKMs+9rvE+1/yaaSzmOIJIAkBIhzsCeUyPwCb7VQkXgY3hMafOJHOTPLSDjHkx7ETk6JT+F5bDuIEDpHaxJ9JKuaLjj/SuCUxNrPLXMbDri0XIJ6uXVztoN5lqVZj7x1J3A+492y+EB0+h5TZKaml9PjXx9K98IeY3zDity14yM80/NybY2QjPrJo6Q7zbwFPgwSSL23FcWLw2mpH1wOHX4NybWAvjS9v0IYei3EE2Bklz3nrgFQAGsa0oD/JCFZP+1qkIETxQlO+JZcd8YNHAyo4yoUj4rcI2geM+Zyo8xCds5erYH2WwxtkYbZvf73i5fhZj6KbKPCNe2QRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5BzfMV14oHZGnP6Ot9DpLnSFEJtW5Pn3aShCBm6vZU=;
 b=YpKD7xx0g/YAZaCdBG6fF+Bto4ulEsU9j9tmyN/m+qXqRM/OqY7OeK1ae7vKUXdcOGzmsofkrUW2jXCg8kxSyburFtaV6PJ7MV+bg75sYoDCvsEaF1QjE0B8zjHT88Ooc8EWCfB0XhYRYNTceo1N+iKMi8EhoXLO3ccvQXXhtwVTk80JRMIxRmh1lkPHSBuh6bczq14mlzO0Gpaw2HRgekF/flh/ai6dAbbN+A/u5+j+G9h7QoDR8ABSbcFKMlBNaja0WoqCcffrFLpYXR2PskXwuss/tw00uhSnWopbXzfxFXqY0xO06Ep9VfyLn6kAShInONRekPb3tTo4f74vsA==
Received: from BN9PR03CA0756.namprd03.prod.outlook.com (2603:10b6:408:13a::11)
 by MWHPR12MB1725.namprd12.prod.outlook.com (2603:10b6:300:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:36 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::ff) by BN9PR03CA0756.outlook.office365.com
 (2603:10b6:408:13a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:36 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 07:35:16 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/120] 5.11.9-rc1 review
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <72cfb55fbcb749f884bbfb25bee48332@HQMAIL111.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb539f4-1283-49d3-9c24-08d8ed3fc1f0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1725:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1725E88E83DE8970DC3CEA2CD9659@MWHPR12MB1725.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ra8Je1dZifsP/Qx+YrbhrHgcSH9no/AEdbCMRmaYCKmGfcWkj3L3HunIMdSEfo172NT+nqaLbxoNoUVGMYvG/+90hGlY1gY9c562LxrAHOmCx92hrefucX445H6cIhbQ//8Qy7FwXIv1HyurHYR9RuFaV9XYSCQ7AocmAxlOkws1k0bXxWPwaDzmT+jSGjJdnVQszjX+d/hqaHulD+lrMMZJHkEGmDshUBTFD8247W+rEKbPz6JinruY9JEtKe4y0Fr6ekNdAIPSzfFeRXOHAF/EUg8Q7z16zHX9G8Pt0s51GXTn+AJ/AH9csbRqOtp1T9vbwQHjIUeCdh46bJes4jLu8yMhZJKhBFrSMgwwso2+b+fU9kmV695tlc8PxiTuImyallLIoZ1Vc1VCOBeSBtKeli+xVlL0oyyR4xn3h5Vuf5nEg/HYRhK+nN56kUeib5XfOF1hmF/NPxqxfu8EWRmZ6ZwooCTgJG8TdwWLWxD0SbRRtrujyI6dHl8SEWAOHNBh/caLfvStB3E++haS/b9l9Ax+Kug7FdPxo/tMW3ZWxxaD6Yjulopqor3hPIoDHDyGY0tRkRa0Ds7p1dDi9ZDEo1ZbeygclBiWEC48pRzXjKnAfeWq2bYXVc1PxGGpqKnzfhGreJNUZr8xCiOzlPA8YkcStNuf3RILYZ3uuO2i7WxHd4T04BfH5e7mcp71hzY9d9GEdB55E+aZNbey3SCaEGaPEibnGwsRJJ3J3Bc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(82740400003)(426003)(2906002)(8676002)(70586007)(24736004)(7416002)(108616005)(36860700001)(336012)(70206006)(54906003)(8936002)(5660300002)(86362001)(186003)(47076005)(26005)(4326008)(356005)(316002)(6916009)(7636003)(82310400003)(478600001)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:36.3660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb539f4-1283-49d3-9c24-08d8ed3fc1f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1725
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:26:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.9 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    74 tests:	74 pass, 0 fail

Linux version:	5.11.9-rc1-g3f03c425f75c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
