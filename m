Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DC33AA37E
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhFPSvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:51:14 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:16353
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232053AbhFPSvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 14:51:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgjRlqlbTyMsiOmQZk3mjrDYz45fB2CuuQ9pzF0k90q3UrxEm08X0X97X8bvWYYU2+6zOSrFHPDd0A6S68LdApVOHc5ZEY1Q5vgvYU2QB00AVPHdd1uuP4qQ5LeYrnK7dGUEM6Wu6r71hVmNF8lu/cd6ifnUHOe7oLxPIuFiaqse4RRtaY96DZgYGBJ8k+LK7XHP/sJpfDiOWduRgjNQ1pvn1SnDXvlAo4nT8aXRT/yPADML3/bgyjD8yjI4teIZGxv5BjvfilOI+rzDvIz47JVoOYWDxicg6jWMDoXkgOYJsoQJdrq+0yW+Yekx/vnNSjdtcsxjKQivtQCalMHGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhO6CKLebdwoDMmIBDXeE7f88OmzTHptIhtuiwS0M3s=;
 b=XAZjDfl5OrRPp+XteVKB/aQTB7qxEjioD7LJdE4RopA6YKWFuitrL+GS+kmQnxnruJxScifsW7WNilxK4Gvu5CJIoCYtxD+E9XcYDnqNoZrywoGPXHPDd+b1NlI6peVnDekuxOq/1Y8QwKVZttQuxlX3eIEhpDNt43TsAH/kkG45RmFp6FdmdC38vYl4VcsMlUCx8LUV7Wb8geSz+uyLAv7cNl/9tNJwaCI9DvSL7RRFdPxGVZIJ0M8f42B5dlXaSODHEJZ7UAJyOOSTZf4Hti3lzzF8mfQMbmiht6Bd3B39cxtD7Yp7a1nz31VufX4Jbac/FZLguW8nAezOQEdmTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhO6CKLebdwoDMmIBDXeE7f88OmzTHptIhtuiwS0M3s=;
 b=aNYLb9Oykix9i3XnJVU/o6cUCvf5eBGJ5+1MVFhpyqrb9aItZCwb/eOEwvhHwSmGPIRaU4CQXmelbzGqNR9yLtiipIDL/NGzWDf79KqEj7hc+ETZms0JEDUnhEQcg3TYmahVE+wqxtsOzts/qdGmRPYcVNHDNOFsuJlz9avhbY+CzjOWkfMLREMnAbq9/YmmmUUv2TKjfzDeUtkUQuhEUM+prfQcV/EK10gdvTtKxwfITXNMgZKcqaGTtOJ4giScQYg8ni+hWj8F7bckQigJiKMf5GgxCyC3zVTXvKlV1Z9iAH8A1mhZtw4IQTRJgQma/1Fwzcfx2kOIF9Y2J4avDg==
Received: from BN9PR03CA0549.namprd03.prod.outlook.com (2603:10b6:408:138::14)
 by MWHPR12MB1311.namprd12.prod.outlook.com (2603:10b6:300:13::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Wed, 16 Jun
 2021 18:49:06 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::ff) by BN9PR03CA0549.outlook.office365.com
 (2603:10b6:408:138::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend
 Transport; Wed, 16 Jun 2021 18:49:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 18:49:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 18:49:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 11:49:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/38] 5.10.45-rc1 review
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b43076274282452bbd5785359c70ffea@HQMAIL109.nvidia.com>
Date:   Wed, 16 Jun 2021 11:49:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 629aa60c-eb6a-4918-7ba9-08d930f76aec
X-MS-TrafficTypeDiagnostic: MWHPR12MB1311:
X-Microsoft-Antispam-PRVS: <MWHPR12MB131164C6409FBD52219DEF97D90F9@MWHPR12MB1311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXUydLGPaUYGOelvG4H8gd0Gr+19F4lmlrO3gqmB6laG5myw2qy2k8Osk6JsG5kB3EGYW558zX5ccow1HBFP+SOdOtgYtbajfb5way1OJ2BglrIM3RxpRMXld4DTMDe3jL73e/k2O6tv2l5gs2f5ydR7QFB6PltQ4OkTs72zSOOfzWmdJ9YcbOX2RCU04rqFJs3yAHkw84+4iSIVmHHfL9BUo56uAW025CKMqTmYyTEzZ5pPU4Zs7KHu+i6ILdANH0w3KLqrj4FxQiv3WGUy0ZXV1ewwwYrM1TMxNmzMFpQ4j9nqdkwjdXxO8eMpAm/0ujSPF10ClPhV1bI1+VmTMeXcjYm6XsB2NdXpgnQgsR0Y1X5pZraFXMT+khzcQiIAo6qVpQwUrAl8x65ea6EUu6HnK0+X5S3bi0ugVfaI7wwMcDH6q26Rzl6b0it6NVtTMJJKSEWVhkObZmt+u+lb+fPT6RDMvV71CgP5Oi/i+ox23CG+xXqQTpjCSrPfAAcM0Gru9Vl51e/+d0cR4kR1f/EpVuWNURR95HJGl9A/IBIUoc/NZDyxUT/BgpqDZ1nHgQ2IPCkmX3Hr4hhSNzgm6Kc/o5/qEG1vphQU9jhMFw4zNaB6muagMra8nrDHUpAxucjKRVsO6dce9E4/JxyUwcs8gn2XikDABUUAZSZ339Cl3HteSsDjundv9ygRQKY+gJu/KhBlJMI2TP3+EGh1PF3ZvG4FOMXC/EkGHlccNIYXfrLMMqJv/bhH2yP6Qzwu6UC/AtGIg4hB9gHNHDyGlA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(36840700001)(46966006)(6916009)(186003)(7636003)(4326008)(356005)(8936002)(26005)(478600001)(7416002)(82740400003)(86362001)(316002)(966005)(70586007)(70206006)(2906002)(426003)(8676002)(24736004)(336012)(36906005)(36860700001)(108616005)(54906003)(82310400003)(5660300002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 18:49:05.6825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 629aa60c-eb6a-4918-7ba9-08d930f76aec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1311
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Jun 2021 17:33:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.45-rc1-gaba9bf2d6e40
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
