Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0413A1047
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbhFIJjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:39:00 -0400
Received: from mail-sn1anam02on2041.outbound.protection.outlook.com ([40.107.96.41]:16643
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S234392AbhFIJi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGWmjzgOFWNOQf/lXo/oYrhW2jEdUIX72G1HrLwWW2CpLC2jaGYavVj3OxCfXvNTr/PyiLvrDn6W6PO8TomInDKQWmC0edPewBm2L31w3O04N2zTsztpEUNGnGk3mIsrLZ/KNkohx4GcNkZURZDM6Am7qxG1vNtb/dLaj9R7S4+NVsJrtXmC3RVNrA/ZE7UauRUPBe/+gp96E4aQqShojethuQOARG5gqOFTX3INkajJ37Rnb4yEiG7iX062HVDWIJM6SniEakdNWhTdr+P2/laOCkVuxcAb2x4HzZXPX/TPtBW4RL+1b6o88gZ9x8QCIse3TuQ9xk7VsU0amXlKIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQCbWTVTcSX7JqNliyBcQIn+SpKYHCMLoeOMPf8FFhQ=;
 b=TnRDDWzH4O3xbmA/+/Sa0oE6kZ+L3+pietwfHrgMXLhk97144OS5UdmH2fI7DYrZsn7cPsPoil+Ccz5rfA1TNc2aamd3mzY1SLwKDNPl4n8sCIgcclVsz80vsHhu/1bftgM12RCLGQX2/E5dt4zpxcPpvNvU0MSQ6J8c5IJEjbCDKZcGW3MmX72g/J+VXcy+c1I1RxaU5WIkvIiKVW8wruRnqLP+vN7HNSrQGompA2EGhNPsV9yz23Gy4Cr6+59XXuF3ijUdcDm+ZjOG1BxIOtqS1FWSZSM7jNZs3a2FDRll9y5MehZTMwYfn11O/VuosBSqf+La2V4QPI4H860fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQCbWTVTcSX7JqNliyBcQIn+SpKYHCMLoeOMPf8FFhQ=;
 b=SBBvV2grfFx+BrC9mh6yO4CcQUd0WTt24HwKagZ57YkUo1holtR8aS7ayzupnTOVChZWXiuS81QCJDz9VeXc6ak4Pa3YOEC2LZmUWknvNo7hI+eY9dEYD6QLpleHjyfaigGgw8wrQf1l576H7dCe7Rvum7PDU18HXLwUiTsD9a+5hU/ZIuOdTvhbeZTDOHLqpA8aWZG/zPGYXLYTEoZXuRzPTOyNeRE4KPhjn2zj280s8/4lk3O3/3WYMjtPZg4Mbu1szruRJu/YgAPHCq4YGx3GR2AmZ4VqpBtwnbqXppMKnOW3dSZab/4qn5TkuIodKbj4lh/R7MaHyh9cBKEdtg==
Received: from BN9PR03CA0472.namprd03.prod.outlook.com (2603:10b6:408:139::27)
 by DM5PR12MB1531.namprd12.prod.outlook.com (2603:10b6:4:f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.20; Wed, 9 Jun 2021 09:34:46 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::77) by BN9PR03CA0472.outlook.office365.com
 (2603:10b6:408:139::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 09:34:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 02:34:45 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/161] 5.12.10-rc1 review
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <942627ef2c764caf91582fd1f2f7505c@HQMAIL105.nvidia.com>
Date:   Wed, 9 Jun 2021 09:34:45 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28c03ce-4643-48b9-ee66-08d92b29d204
X-MS-TrafficTypeDiagnostic: DM5PR12MB1531:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1531926D3E16FD932B9BA5C8D9369@DM5PR12MB1531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCYu5T29Dje/+YPbjj433qFj2IcOGWNujqx/Jl+kVrTP/tM3QNy26suk/6hjFbHXX4lJAfK4B4GxQDIP0B5V81s1EDfebVIMDfZNSL/leOIphkxr5wGc8zFuMreFEbLmJzjA0+QUSPyxwMShUPEKC/MIA3MyT+mUDNoAe1CtCpOCpiO9/Pdkxd56kw8j2DJEf82L1HgNNNcHU7fQQYWhGdp9d9idU3bwx4FYXRd1oi5t/mLvHMjMNTthIYoQNJ8nQn/6k1yc6F+dN5omr0E+2J7h+NEpOn+HV8BsyEJBZVxXfCGaAGQW4ANAYLtEb/KVSPE7/CWmRf2lzlU2/Z5mgpbQiTrb8MoRjbylI0v5vhrn3U5gijuqWJNt8r2TEqa7GgLo2JT37r2Ttqaf14CsR5dVfxfQ7XyKnq4nloDMzRj38Jp4Ggu0t5lSuUwTNHdlm0LAnCkZXMSyQEKzTTkHx82ZVW1nXHE2YK4qAi28I5qoKVybKCHAdcUduJhT6KXkDw5IPVmyGRGQZISQFyzmapBLYpyDLVo9fjB1x95dvk1MOHZG3T3yVc5dulx3YY8K03zIohGB8Vz9fxluakddyiqQ2VvJ5j1TsvlMsOyG9meK8VLvW6auu6szu2J7yM2KuLm9ZDVBk5YH2g4Bh9yZzoDdZCGd6/5X7fx6P7PqQc+apgXlzqooot2s8jn2oxOvvC6tljcJJhaMit5MS6D3e2GbXEtySHqlfkyx7cq2tgZF5GSm+3+LwmohMW7SVgZAlvgM8LLbmN5WZ8+vIvnwdw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(36840700001)(46966006)(6916009)(8676002)(108616005)(356005)(82310400003)(336012)(24736004)(8936002)(82740400003)(47076005)(478600001)(2906002)(26005)(966005)(4326008)(7636003)(186003)(7416002)(316002)(36860700001)(70586007)(54906003)(426003)(86362001)(5660300002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:34:46.4988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b28c03ce-4643-48b9-ee66-08d92b29d204
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1531
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:25:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.10-rc1-g5a0a66f4d817
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
