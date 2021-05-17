Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C1F383B6C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhEQRip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:38:45 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:17248
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236374AbhEQRip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:38:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjfqDAOvwn8clpetpsa0e7K+YOUfugdHP1Y6PB2hlg0M1UAJScpt9q7sZOpnUjyf+tDH/0OigBEKG4oA6IcLWZivPvmE4usAJXUQ1rFTJiDluE20a0OrZtADNKuz54Un+pKggyDovbuqeSZV5KtIHMTVt+LTfVKC4ptUJOy4iZZCgCzB7h5xfnfm8fvEZd0sWgpluyyQJql+PcekZlzXjVfZc/+fcwu4iSmeKnrfL1EWiw/LNhqNW7m92O0khDACGUr7rqr6L8I0AAyF1RBJ4X4mfS7BZ0FsO+ndnF6xBsIEiGS9099rNi+64OL7A6Wsq3jjDjrm8tduwV39Kdom6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2c3Gdpl1B6c45tDvHdC+vcSjPq4TVmvVPpY7sgOmCI=;
 b=eBzEKGQotftSh5aY0j/ub4CFDkAygobptGWs643Q+qpboYGT5A9H6J3FrRrYPjLbSb1k0YlRx9zFgn4isNTreAahNnX8T/GKBZQxEOUm4hDsAtqBH9vjlidC6myWBw2+zdCcUUTeMLTTrm71V/zIU0GQd6JhA0xCARo8yOpCDdeuLZWdVrz9kjksnSOFhwqFzKU1bgx0v94K5dBS/QE7qpLVF85c/lXgMGca7M7bSVXI7gQuzZ13IkAX9bdFFfYBiJkRhIL8X7suz8rQWNU3JgDKeSvuQslHb+2AKgz6o7k+KRgMiVSihJ2BiKwCUO9Jna41HRccV4epzlQVWtW0EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2c3Gdpl1B6c45tDvHdC+vcSjPq4TVmvVPpY7sgOmCI=;
 b=nkJIm8J6HupTgX0l9Oc6qxbRIBEjz+48A8alXXyOa/KHwCDnTnS7vvFqEbumJa0/bg9Uu1V49v2q3CTCdY7FGsbuSine1Qm9QiNBzUWN7gy18Ri2R0Mo81pd768hVVzhtocmtPbePkuRwjjugud+qYDBX+0gjgx2ZbRaPXIH8oMF8WIQmYru9mNWcCPaAGrTTtgvneyNN5hyhkES7/s3rKyDzMjUHKVK0645d2aNvl60+567pj8Rjel84drqpi2mEImLUAvo5krJGYsaVQQQqQDEnVLIqJYjCpXSQ49OzyGbjWVpYjR/qGcBmb28qS2OSR6r+D9bOj5Gqgx764qHFA==
Received: from MWHPR18CA0044.namprd18.prod.outlook.com (2603:10b6:320:31::30)
 by MWHPR12MB1149.namprd12.prod.outlook.com (2603:10b6:300:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Mon, 17 May
 2021 17:37:26 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::f1) by MWHPR18CA0044.outlook.office365.com
 (2603:10b6:320:31::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 17:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:37:24 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 10:37:23 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 17 May 2021 17:37:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <cb10d3b6c62c4fd7ad7d8a146702ab3f@HQMAIL101.nvidia.com>
Date:   Mon, 17 May 2021 17:37:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97cf42c7-62d0-4c9b-de42-08d9195a6ece
X-MS-TrafficTypeDiagnostic: MWHPR12MB1149:
X-Microsoft-Antispam-PRVS: <MWHPR12MB11496A096956E6F559E6AE32D92D9@MWHPR12MB1149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 27F449AB1sOA6PcgdBeAchwLX11mOc5YBgKimLSfTbm9QpLxfJxehpMWsi8BXmDR3yPIN0GK/wpk2TG5TCjYwsCfb9i8wOmdk80RJv41X5tou3xfQDexrLOLrTAGv5NjF0vt6SKTvOn1Znah/V1PhqrVmVMD2IzSc/nWhCI2lFY+XnwMrxVGStknVLT7uNt01BWLJ8ZvZjIijfykj5SwwTDHDnqfQKav7xrAUOsnCSmPioF0KR/I9BAqs47s7IWcq09VOveg+OXU/cgLkLgh+YtjYFRzDrrl3qUzbxZyBb51Yl6hjupePkZkzqvBn1DibA5+LRyrahyCqoGbXLkJwzHSPD7BLGhnRKYgUWbSdaExyVWSgyQsUYGrIchRQnLCGgxGMIYoBmR7dIX4IsHKUOxO1+zlENWTMhuRF58K0xQt+FlVvisCCC8/AbIGSMjcBgloa5TPhprfeSrP+Jk7OW49XkFI9WhSQ9Ly0qeyQPHADBP9c5r8QB05us96EhHkrdW28FVxM1L84WLFfj0YmdrGe1QATub8dRZAsdkD/OZ4HgMhf1OC8ladjxCOwZJunAuRFHKDnwH67DFXMP3vFMfkHgk+3dar4oRM6r492bY/WIrGMhjpIphuILROtRiZ34AK9cxRfQ+6Sb+GiMKQGoJduf3NApBeh+mkADGhv2r3L6HoKoMWPZ0TwUblV6XKlDNjGBxj2NQGzAMz65RrJega6jymUiz2/gkwYK/lCnkjCVYM291az7q9YZj/yYoLNJCyl0r3hXzYj0XhzUriDw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(46966006)(36840700001)(8936002)(24736004)(2906002)(82740400003)(108616005)(86362001)(356005)(47076005)(5660300002)(186003)(7636003)(336012)(70206006)(966005)(70586007)(54906003)(6916009)(36860700001)(82310400003)(4326008)(26005)(7416002)(426003)(478600001)(316002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:37:24.5368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cf42c7-62d0-4c9b-de42-08d9195a6ece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1149
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021 15:58:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.38-rc1.gz
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

Linux version:	5.10.38-rc1-g7ba05b4014e8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
