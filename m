Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06B374841
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhEESzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:55:50 -0400
Received: from mail-bn1nam07on2065.outbound.protection.outlook.com ([40.107.212.65]:1185
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235016AbhEESzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmKs/DFUYiCL8dDbgL8wT03r07tOiZf5hZZafq8tC8XK8xol3iJ3Sehg2XiILcJj4/pM0vdi4q/NBWPFYWzg5yzp6MKt7UCXWXEG7OBe+NrHXUj8LenEL+dw4gSX7iTU0ogtjPvAP6IAqmLtAObvCn8rxnl7Us3P7RUOybo2qQpRHzo/+ktGi+OMBXlhgpKDTqIMDr2t5L4s0F6FixtK18xwtzX9QOoEeyERK6E9Zz5pMc38Sb0Hp+QZhDlxl24DNsRsyE2D+iUltIAXbaIctrCmnBD3+/3cKQyxZS04P4Y7SGBkTr5kv+Kgk6KXjv7bpSHk/WZFiJpQGJR8QRVgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg5fYBrMWPmvrezE9z5kptRosnPPAi6PXOcJ4h545Cs=;
 b=CCPgcxbuVwyrzvqmRaHp5vDp79XfGBDwkPbvFi3AnoQPaqG2IGwfE6yGii2QOAt9dODCi/V6gr8p7zqFA8lS0XdVRoSSIqB0EqeLCARmplq7V+Is9O9lNrgtiiBx1yFLsYbLgIOPvyCVZODa2E7UXWrmQPD/XomtX8cpCYOgfiMDWrkZpJazEv6dGCIFE2i3lu41FUxbebsIkFr1dr/HJy22Ba6HJRwCa2bG09mBIor+GVhZNz4L20GW8ZWh4BkQ0nhGezFBmzmHE70LEztineB520cWlpZDf7E360SNaKkRe+dWf7BwkBp03fp4gtQESV25+WjzyWwwHf8gxzjuxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg5fYBrMWPmvrezE9z5kptRosnPPAi6PXOcJ4h545Cs=;
 b=Wvxsoz+oBEURD6wBELCQyQ1VbujRg0vTRZzv//Pws8WzUBd4OYIMSU58iFZSfo3tNHQ5EMdxFx3IOYLv8iqEHwozOKZIX8ysJq7wpxOjCZ/MJVP1xvlc7eUaiCeM+pP427e07pp7P2Jn4bBQjFhOteeRQWIKzXX18sQYzPG9eR2EeSTu8YBdcouFThBC9kGbYrq3+cmo42uexIFhaWEAuVN+Zt/p+EUTA74wx8SU6YLnFElmg4zmLMAEth4fVctZn4Hw6NNN4Sk8YsoiGAzEayQO7lVUQV0hBT0BYe/GRX5+AxWnSXK//6LfIjxq9ItC8kO0DVbjkcafKSV0FP5+uQ==
Received: from DM6PR02CA0044.namprd02.prod.outlook.com (2603:10b6:5:177::21)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 18:54:51 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::58) by DM6PR02CA0044.outlook.office365.com
 (2603:10b6:5:177::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 5 May 2021 18:54:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:54:50 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 11:54:50 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 18:54:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d4f85ffbdefd4678ac69dc3038781fc8@HQMAIL111.nvidia.com>
Date:   Wed, 5 May 2021 18:54:50 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dacc4292-8c37-4a63-aca9-08d90ff74351
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5480CF088AE9A744F90E7F0DD9599@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYP7MpAK+IQAWSEeoQkRgnwLPFgyfHjUa2+mOdYK0zbOdsAmipJ3HQkL9WBaoTUGklyPfu8Jvi6FfQRA4aYyaZfu0gfhsJnNfCsT0DrE/uYmA1LHB8pszGyuCITqzupZpzOXHbFGjjAFpOmCu03RoHb9Lqa+RXbz+KsfFt83cJwEWombysCUkU9Gj7PA9XQQfLYBel0KFvUE7L+2otdDLmeGiw1k6ypMRmX5+wCgOBxy0kStwOeO5LT/AKsNLx5oUlzdRTmRUWsHMDQfikLZzTbeLQyFrmmoXv0OlrGnMtfVZ3qN6NAm3sGz3Hp2avrBWBHEpJk2c47ypRYTyXL+xv2X0Smu9JTBGeUSCZK6JL0Iksb84ArD9ld3m092da3xEYCslFqzs41OP7HEeYeKpuMsK691Yfln6msua+qHa7luGICKOYbyIIe5ywaQPYf3Vien+VpRx50sPWq5mviGZZI2fQbrcWcVFjnbYcN1I09PBZBDxvTMiTuOOjbQl1iI53ZoxKAq3JlQYRpEAlhZT1MPiW/UbK1HKLfMHF6bEbJIONFeVEU+hbuN3v+Uz45VsDSFUejrctDPlfaseWjrAgQFBsyY2uRv/KiF1fqDwdMCrNHktCXOUB8sLQz7j38PNaoLotye65rboKokQYEMLREn7vAzGkX9bDVdBN9y0w133wgMIW23lFGWTUqO6G93XayKexsq+kVXHPYpJpXsbT+Hs+0pzeRXoynIIaSmc2A=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(46966006)(478600001)(336012)(82740400003)(47076005)(186003)(86362001)(36860700001)(966005)(7636003)(82310400003)(316002)(8936002)(5660300002)(26005)(70586007)(54906003)(70206006)(2906002)(7416002)(356005)(8676002)(426003)(24736004)(4326008)(108616005)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:54:50.9161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dacc4292-8c37-4a63-aca9-08d90ff74351
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 May 2021 14:04:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
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

Linux version:	5.4.117-rc1-g73e74400c797
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
