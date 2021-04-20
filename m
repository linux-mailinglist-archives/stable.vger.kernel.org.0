Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C27F365220
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhDTGON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:14:13 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:55365
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229843AbhDTGOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 02:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS11oVMv+6l4A8pbDF0rNsfu+EOO4xgSMjye7Z83ER4Cscg5MgIWCivdHfdUwxGheKi1ajcC7qruAuQ1E1XKRV9Fa3W6MUIS5KxiQnxm8LNOrXyiXB2ULlaKWOc8Lw+i+Nl/LTRLsUamFrG22OgJIvVaHXvvwts3r/mnromJDElRTQePIPlIzzNJO4cpZgwnAu1ZI8MPFY4FbgIhhvGbIVETryjRj1Np8MieYS6bp+63RMDTJ2YnS9uOKLRvHqTvJVBlT+VuPKnI4bU4EwSAQMm8SHiLptgBXCmJfFzBGJ70mZCMmSqcEdOM/yId+n1PGv39K8rzPsJYuwR+vrdraw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D5pUE5hZSJ7RzLuUOnH+QAvmwRH+fCDMDBjiuyzv6E=;
 b=Ngn5GWYkClSd6vJHDYN/WRtyTz5qm81/FZ4HWshr8lxtwK+lZRkBzAkh2nqdTC5qgi8A+iYFYBGETAtI9zpjlLcSbswe+jDRJfYt8TPaicwn9CZtujAfar/9RC13cQMrkjBUDfTVnYcGADzu3HJ/uLQmwZSDpD1XzrMMslwQzAF+u7cQ8d7Z2We04oiqUNakFPyRE588tnC7YGKgZcxxgwenwEOBVqogzXKkQ9/nnhXGG6QwLXxkJjih2ikB8k2KvJcZNZlfr45bkH8bCK1SDoAxrbdzOdorc64jYhN6eQBvBVwLMxLgbWcyaxENzaM6xAD4Jw36PivwE1m7nKkRTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D5pUE5hZSJ7RzLuUOnH+QAvmwRH+fCDMDBjiuyzv6E=;
 b=bq2CEynqy99GP7mLY4R5D/T+ruHnvMVJK9DnnLyTK4VjqvQ61+Ujhd65RsFHZKIssIWl8piIOQWylK0yvtI6VM2Hu0GLzOUrMiNYh4HYbUngr73WOqDGJiwy0RKZ0eaDwbUErYeqgTR6XHlQmfRzIwo3vhgqRsQE65bjFr7+1HQrJjqBiZ+mzFNaaKfAnjKjOAG1OcGZ3pT/Wxrl6qIWourk9VQeY1rMu6yaB/9LtLs7unmNfRAFE1xEOAa6r6fUrEY/cPQN/MFbRlnmjG/GTCg5De201/lXNmpvbztSaE7mKDklcxwNSp0r/bS0CcgATNcdkW+ZB3wF393T4gBc5A==
Received: from CO1PR15CA0111.namprd15.prod.outlook.com (2603:10b6:101:21::31)
 by MW3PR12MB4377.namprd12.prod.outlook.com (2603:10b6:303:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 06:13:39 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::f9) by CO1PR15CA0111.outlook.office365.com
 (2603:10b6:101:21::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Tue, 20 Apr 2021 06:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 06:13:38 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 06:13:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Apr 2021 23:13:37 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d862f52eb5dc4de5a1bb76c512b99d40@HQMAIL109.nvidia.com>
Date:   Mon, 19 Apr 2021 23:13:37 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a6ca21-79ba-442d-10fe-08d903c37011
X-MS-TrafficTypeDiagnostic: MW3PR12MB4377:
X-Microsoft-Antispam-PRVS: <MW3PR12MB43771E5EED0132181906642ED9489@MW3PR12MB4377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GY3hu6amBy+R+IitBHH5CyLCvo5xdxMDIAFYEfTtD9k/e8EkTEQ+PqZ6gtaXkcWb3BH68g2Nhmb0UFTD3g/wg7yRKFPJbwZmYh5BjA0qIGvM+KScgHp2dLAdaHVdbhuPkjMZ94VmtIHqhxQPoWVt0w8OsBgPw/Lqbvi/502IpV7TnBtQ/hjnoaoH5YzIGWT4hSehz5TqxAuHWykluLR01MaJf8JHB5Y0jBZ/YPtDQT91Ph0ZCLInWQwbtgKShg1V1lHGvRkg71u7O1u99hd8fqqnreNXUfubZGBj6uGb5Ydzfcj3u41CdnHPU1Xd9yBVwa5dcdRotIU/pQQn1lDPalPlHRPuLVlZpSEEZB12jo6WZnB25dMscgEWPXid7tHcEayUjhi6s1CuafffNuW09Y+7l2udx9PtccCQvUr+Mc8GjibRYaF2bi6fI0ADFCUASUYDjeMt4nj1Nv+8ntc4WGwI1le81j+mpUs4Gz6UdmgkC06G6Tb/70oLoVBoWaTV4J5jRO4ERF/mL/k5mNlLD6VZYV2iuljNU4v7PHtrQn8xP1tbJc8IY8mychIyXjl0zTOSFH2TdsNsEVt+vQITBZgDOvTxu4dm0pd1bIzlRaIbBMQ5+ZNorqxocR7Rilxt7lZvYsPNK1ZM3nWKR/CAvemULEoBKmzl7y49ZO6kqjPf0xhIdax13FIPPls6MYyFXFnGTzXCxY8H8Wd/S0gZJWGqiAC3ElmZjGeYEhCns1g=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(36840700001)(46966006)(8936002)(2906002)(26005)(54906003)(356005)(478600001)(4326008)(47076005)(82310400003)(70586007)(186003)(36906005)(108616005)(5660300002)(966005)(6916009)(36860700001)(426003)(7416002)(336012)(8676002)(82740400003)(86362001)(24736004)(70206006)(7636003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 06:13:38.2329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a6ca21-79ba-442d-10fe-08d903c37011
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4377
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 15:04:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.16 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.16-rc1.gz
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
    70 tests:	70 pass, 0 fail

Linux version:	5.11.16-rc1-gf34f787f0e47
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
