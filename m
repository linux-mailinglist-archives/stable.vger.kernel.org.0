Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7956D38FCBE
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhEYI2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:28:54 -0400
Received: from mail-dm6nam08on2078.outbound.protection.outlook.com ([40.107.102.78]:54592
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231504AbhEYI2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 04:28:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaAvgiVQuAcbceUqIBiUecS7mHG93kQQhuxbsT73o4Yo9y8Br+HCqHZRjukR+WQMBkPhyEMC+r8NpgDVn0uDQEn0OsDLoV+nSpUBUC70mF5od2gY71J8TeWe7YAdFy937Y9PNA5XoGm4srTBSQsNLsaX0f7tJpuydhChUcQzBMb+Fw63P094P+LwLymDBrIuRwegAQkXiIqnD2Mx1Megf3B1Q+dS9BaYf4jmx+/X6SCced4WaTlQ1xaeWL6Efj1qRQ5lRtCp4WzCmnFPdWSWyHNfe8GLboMjre/FSVOLHnDYuRNoOX15q7j0bkOUPbZqCFozmQ4Z9XevKQxuhLYu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpLGm0IqrJF1/QkrExRJ3oxSBcqIz9EcBGFykBcTuVs=;
 b=keLjORRgdBsFqrN/vcfAcnl0xO7VP0oFHj2OTUwvhq7NyXTMXV9FJ5+ZQI0/O3z8iEyXxujXYcIlO0let+YNy0WxQN6JFOmcwxZWCs8pFY9t8+tYXjR5khgIl7VSZMtpwjTLqX4Eklf9QGPZJjCFjpl3oREioorqaO39JArELsW9AwghqXEQfFzgEBLg14yo3d7+LIkBMrk17rDBftvEXQmwkIayA1vh094FQ3g/LojBX5MWGHPsc0diR+rnEAj4l+sPSSsPm+IG7crHXVSTyslKpm16FoDel5o8RUPjKy1aTXjkAB/9R2aFwDODNsNeaXVNjj8Pud27wsY45FWoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpLGm0IqrJF1/QkrExRJ3oxSBcqIz9EcBGFykBcTuVs=;
 b=ZWtPeN5xPO8W9ytx6ajNWaMx6m8vtKjmylQKxrnBTEJCQVYmHcRLdsG1uY/XwpGVX04s6GRWEsdyRDXaXwfumyWdSYWUrABOvy3GY4+SCfQ0pJbZBC/Ihog5cqbIrd9f6FQE2WuEAe9g97AZQrpl5w9Ie+RBNEsYPVek7IGnLO8/b7VCGA/HJzM0s8tkycnvgE20MQhVCq4PNcEIAWOcAnn6h9SUMgMCgHp2HkkfG6xmFn6CmGDRs6ID+hYh7UxELJfnSAmSlXBw+l3sLc7OsY8OBHQeUKYBhny+EUuRxpEF8lwP3yJe70mTHHjCHtYVsKNzAqNb8Ydoll0Ju6xsrw==
Received: from DS7PR03CA0163.namprd03.prod.outlook.com (2603:10b6:5:3b2::18)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 08:27:22 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::da) by DS7PR03CA0163.outlook.office365.com
 (2603:10b6:5:3b2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Tue, 25 May 2021 08:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:27:21 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:27:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 08:27:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/36] 4.9.270-rc1 review
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c1e0fd8d89d74fbea9c7f9c59a066129@HQMAIL111.nvidia.com>
Date:   Tue, 25 May 2021 08:27:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbf89a11-bdf8-4179-22e7-08d91f56ead0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5045:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5045352FC70F68F69FA7D5C1D9259@BL1PR12MB5045.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJ79tpwNPWzlkVTNoxTu/EiADHTvESfHpOuS552pNlo0LlB9RO0jcWXFyFQcXN8PX6kInQOz/yk0QzkgYk1iXdtvgs8qVQuJF8Ru4MGAfCoHfmay3kWVdw80x7X/DuxDQ5v5EWOfjASnqKPsXf5oXIdwpc7Qad/e4ods44HL34MR+5cYb+IyBaqghaP/F72k+2ABSOutMO81hts/b12lqREC3vKrP9OPCr3mThyJdT9NRAWPVjoppUxzFaJCicZtcFM19L9jcR+OluzWGaMJI+cD7phY/Sau7IsqOzKn4fKbY7ZfonjXHUviim1Ec57KAQ/+ss2z7PN/mWCuWuXhS9o2e6WT/1h+xQ08w4Bwhs/i5oStvhMy0cSpFPzEQidFPJfsNAZwk2vB4VWekaiIReiKlmQ52zc0nVqV3aEErHw/hgy0X4Qn9jV25hjVGmFnXaHD86WyaOjuFO8+sCgOtOSsRwAK/2rzp/wySTWqJQ7o3cWJuUngFmlbMMwmPsyZ52s9sqquOHm+lzia87A9DfOAD8y/0Ev9g0rh77GI44SHj8sX8BVvazXVFN2BImSGmZ/axNkJ0aLcGNz7toj6Y6+6/pLLsGU6UpPg0p0rmM8Q1bKPJJIyhgNwWg2Sll/YYGjEarF/pLs7cnFBRrjiXTdSstRFwnkMIcOOZTQ7LTBCQTPd0zgDp2DEm7LkMHnHl3bZq+UWNoLfI89p00rq1T+U+TOgav0Y3Qaa42uDu4IR3qgciogeTIdHiTyGqcN/FI69lWFMuaZ8K4DADjF3pw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(70586007)(82310400003)(47076005)(86362001)(24736004)(108616005)(70206006)(478600001)(966005)(8676002)(6916009)(36906005)(4326008)(26005)(7416002)(36860700001)(82740400003)(54906003)(316002)(426003)(186003)(2906002)(336012)(5660300002)(356005)(8936002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:27:21.5773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf89a11-bdf8-4179-22e7-08d91f56ead0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 17:24:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.270 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.270-rc1.gz
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

Linux version:	4.9.270-rc1-gc1efed5276d2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
