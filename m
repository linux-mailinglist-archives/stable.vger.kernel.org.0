Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F31383B6E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhEQRiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:38:46 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:10465
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230157AbhEQRio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:38:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KORO1cBl2fit9WdpWPLWLz++iMsOSHVjiejM8to5CtUVVe/ohjjBkIxMt5TVVUpSKrvfPblH9oYi80Kv633MEeUGxeW0XZDZdVslTQuUJVpOrC++AB59B9Tae+l4OfHRa1QFkT8xaUrXx+XOtMk9X8gv8sgPJZ3ApCbOeDQVYSuppeT4ZrfWJDjEGPGX54F0ewcnE2SSSCiFecjo/q2RAPYXgxLJBOoc9BVW3RVY0Nd9Fxt+HWlw5v5s1kP4R5+jE7wI9N3G7RIXI0Tzpx3NFiGbYYNfpLLDS7uG/+rYtV9v0rXETiy6b+bqLUr4qWTdEdAiqcSDZty6z8vXSHY9Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztx1Ft3hDkQ9LKINjN2L8W2+Rf5ezg/Y/ht1zHmJmPM=;
 b=jgePs64pr36y+TQk1sbO3Y+J7NuIdk2gn3HGTrBnV5jvNcEJakdAiKPHMaMiFw/8BKFhRhBjz9gtTE+DsAg99+J2wq8mxDbNeuVKAKsDGNwFJ59p+/rvgT0xVRX497nQtRm+mGpb5fCz7D4QmTvAYLxGN5qwQrq8LAZD0Rcix76PWSeAHzLQhJ2KjPE1/J/yK3BOVdORb8dAD18mXVbuZjx0P17XoUG1rpzW+xtY8wSkeABsngx1syB8lyNV0k9fJ4WIyj3C6aZizNTENqvX+QNcvuYTP1FbHfVUGS6aYnKFWsI152Ic5LvyEN5SDxvlhbTHjW0CClCbSYHac4oKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztx1Ft3hDkQ9LKINjN2L8W2+Rf5ezg/Y/ht1zHmJmPM=;
 b=Vt2zM80yqa3T/B/SJ93Zw7U5eL8JZkB0DisjMOEDn7AcUhOYQMXUIaT0XizXMgHI/gnfIuxZvJ4WJFjUuWgZHIi6yFxvcIHZVba6odfSuZx2ivpa99lZRZ8WKMLVDa4dc2YuHMzLRhZvOzW/hZ7UsTX7yUr8iCzUt0Rr8BhpRCyoUMnhfx9ti8Nyf++f53Ge9VqZz0N2faeATkSv7txw7+FwaF5x/E9Ni2HUPV74M0aOyL1u7C/ydBUP6MM76WVKFTXy9x/iSpd6P9MbTUQXuae2RlUq2Lh4DJqpkh6eUDkiJrRmjn8JPwA0yutYBikykHmM9Jxa/6UDZcFowUzHBA==
Received: from DM5PR2001CA0019.namprd20.prod.outlook.com (2603:10b6:4:16::29)
 by DM4PR12MB5181.namprd12.prod.outlook.com (2603:10b6:5:394::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:37:27 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::31) by DM5PR2001CA0019.outlook.office365.com
 (2603:10b6:4:16::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 17:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:37:25 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:37:24 +0000
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
Subject: Re: [PATCH 5.11 000/329] 5.11.22-rc1 review
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e8db85a18ea04a79a773137654c18ff1@HQMAIL101.nvidia.com>
Date:   Mon, 17 May 2021 17:37:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39d1be49-cab5-4642-e7f5-08d9195a6f42
X-MS-TrafficTypeDiagnostic: DM4PR12MB5181:
X-Microsoft-Antispam-PRVS: <DM4PR12MB518144AAF4B594EDCFE72BB3D92D9@DM4PR12MB5181.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwKlk7n+BSM4e5V2a4/SgpZbVGVPaoOrImjaPY9AfKVEJGfsKaJA9FP5woqukkYbnOQaQGYliJISFCXrSQwpMASg4TAU3r8k52I8o7b8kese/05xnKesUZCZPS2ko6hjQQxdw8Om+wULgPZnM0jC1a9dhth43r5SFv1OQBabNRWK3MOK7HUxYGhrjGLNHyVmCneKXo/Cv0wdzv2S2TpjzQM0kTWxpVKHSnuVS3YX2NLSV9ruxaffv0O71A98ZYnd9hWGaezrh94wOT6nSSSN6eFC9wOTFBaU0NJ0g2WXGRvR0BtxQ7G1pRG7cJDodYbnEGU2WmnOCs+3lbyxtc01y0YI2qPahigRrjSgUf9Gj/dB3imW9C7amAtVdHXIxDkB0ik6n/GF/0aLuAmq5Meu+Lv/3OV9MJKuXIJtkFBu2lxP7qQXeYNYs9c11IzaaXwQfPqMWbh5UY5UHseQGb1Iht11RPkppTZJC7Vl6YwvcUGmuDmKpXjDxLAq+60/Ld3BocMD8yZ2SK69PoZqnhwA9cJ7VdMVaH5m9qviMNLimXvmglf0KHYpnORR+OyzST0FFnwovR53WmiMnOet3XrNbRnrEAjin59OokA6lCeAt7yQLu3XNJT4z5XLbhGWDerPKgpcQ/6dwaMa/tX0rORAZqg73IeUhdYspf02PvnHgfzrjWynoHLw1Df/e8pvZKYboioXYfeFAmGcbKTdS1LjPsEwFwRrher2ijbryO55DF8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(36860700001)(316002)(70586007)(26005)(70206006)(7416002)(8936002)(186003)(5660300002)(2906002)(4326008)(426003)(82740400003)(36906005)(478600001)(54906003)(356005)(82310400003)(24736004)(966005)(108616005)(336012)(7636003)(6916009)(8676002)(47076005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:37:25.2973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d1be49-cab5-4642-e7f5-08d9195a6f42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5181
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021 15:58:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
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

Linux version:	5.11.22-rc1-g6d09fa399bd5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
