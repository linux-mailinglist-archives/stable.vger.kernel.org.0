Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125CE3DAAF9
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhG2Sfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:35:30 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:6592
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229620AbhG2Sf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 14:35:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5h0Rq0tJIV6QdEH0D5MrUyKc2WEmrujPL2hR8cnIAsSziVj20m6OElqMz1m+E7nV/wUNKjXbtxk8sz8wfxYlj1RgE4RpxlMWRyhkscK/WjmeuE2ijhVe0D9s10dia0QekKDE6S252eqZajs2JCH9eQe0U3RffVuNzMyszF0mDeWuddXavv4iLpwQ9lJ5MbFWKvg1f+8eq0ZiolAeK/obIDfrZ/tAUo7j6bYgfxxKCymCzSpUDm+dJts0VLbIv3UtdzS3+8i6jEmEXrtMKH0g2AVjdg+l4SF6wI5vKO2BPy3P4YiAPGqfkOQ8QG3LCY5TQ9/DIxyxDUDmYCNl5VTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZJ5S586C/faqjpiy3hw6Z0yTzQvU1QEHFrmbD/dNno=;
 b=dAc+VSQ3zlegqHWiU+5QT84lqUZDykhRMyS7T/piRiPeRKa4VJ18mTzOtzpturUBzCvcm2quLW4ICgNgG5yiM3Orbi9bShYiJpM5Qhp5E/iEx3FEUfU2IP5srzDCfBwkp45c/GcgAyVeH/jpZxefaXuCUWzILv7+Qtx6FuWfR+X8kdUr4W8C/HwJW3dDgBMvFviFf24wBTlURSx2f0a4I91FZYKUnOEGTV9W5Hn84MIV7EoFI92WsoljEPdYwb4Mp3KlrUTMtuyY8CJghrCfPis9WFnVoxrwu3m5CNXhnojmVN7GJ0OosBsCDuFFGl61f4q9cJloVlwjezz4vI3m0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZJ5S586C/faqjpiy3hw6Z0yTzQvU1QEHFrmbD/dNno=;
 b=PlSl9CxMzy9HzS5tOziwo8+bLlwQWJDvIjXDAneHZ2etqwo3TXkKXwBWk/4JwuE4t8UX/JMWLNStpsR7dasZAnI2EJHAASMBVhWNlyUfAd5RZKupxXr6IlUwHz5A6kwP4Ks1fwwPsU6EovDDs/8ai/A/RdjMHvQXZ4D2PuOZL8HqPKv8gE0n3N5WYT+tSUIRH08Lui7yqa6TAwmOQz2J8ziRH+Z8yOPawoRPvp81BRXDlTpbGiF9UcoFsWJznlH2XxhcJQLOIYm79byyedp/eLDTzbhm36zTpXZZmnLwUAohdbYsRWNHlfRODZ3v0Cn6Bj/RbW/fq2cWxdR5GvU1hg==
Received: from DM5PR06CA0063.namprd06.prod.outlook.com (2603:10b6:3:37::25) by
 CY4PR12MB1781.namprd12.prod.outlook.com (2603:10b6:903:122::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Thu, 29 Jul
 2021 18:35:21 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::72) by DM5PR06CA0063.outlook.office365.com
 (2603:10b6:3:37::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 18:35:20 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Jul
 2021 18:35:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/21] 5.4.137-rc1 review
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <57e7c5e6cd714397a5212eed24ef4f86@HQMAIL101.nvidia.com>
Date:   Thu, 29 Jul 2021 18:35:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0600113a-9569-473a-2e53-08d952bf9ee7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1781:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1781C6987B3343220B101D99D9EB9@CY4PR12MB1781.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8dBWm1U9/1cKSVPozPlwBsRnMQ8XKgykfi35iMGihHVNp9rstF4/PJXL4FaxZ3ZY+TDvBXv6B5Q4uJbRY6AX7BrkRuwDYwXgJkz0ovOv1s7a3/96gB0aRaHnIEKwLJSWXA1BZffTYYN2eZA3NCck2FaU4rzxQu1/UI2HqKZhkXp9vhW93neliK6q/youpx91Ft8cUuzWDZ4kCoqpf4pmwuz9DOP1J0yIYaO4y14gGJDmipMYLdzEsY0tzD4c3w6UYt2Agko7EjXvT5uWnbfBN6NE/TbVu8Lyx2dzjmal6n5QKGDlIhBcfeyRf2bnug97kMUkUM8a0a+JRtEVrO3OhK9n/ShTAtosucLeAHyuZl+yEiCgkw3tO3Ul4tfW7RPaJwFw+gsBC6Kfb1W5zjpap9R35q29VDN1696N2vtRJF4CnzNGWb9KlVjFe4X0XdlFg/BuvRqWwseGURQnvqJhQZ7bKeFu4fo13iKi83qpGL3snBqkKHyXdeqbV9nEGvjX2oeHhZUyirjEbunpuiwQJEJSO3P8FUUIHctOPtQoxcywN31RGI1YshRyqg4aipLcGTeQBd5KbKNmw+lKJmn48yPh34FcdmrQ6CC0c2eIvBJLGmA1VmS75jeufbax36UOZgSBmogSJgx/5eWZbYu6VQ7ir/dp9josw2UD2tTy0qg5eYi8oabcHz6bjDkfI0fZNwswKHA5ZivK4/WhY/W1JdPMDhuvLtDJWLcRAI7kqjOPTUKVQkYHiRNZQl3vbm5+ba/MDn7VVLDXyrCBFDB5f4ehAW4CKwOyqjgw3zvh67s=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966006)(36840700001)(108616005)(82310400003)(26005)(186003)(24736004)(316002)(426003)(47076005)(36906005)(6916009)(7416002)(7636003)(8676002)(54906003)(478600001)(86362001)(36860700001)(966005)(5660300002)(70206006)(8936002)(336012)(70586007)(356005)(2906002)(82740400003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:35:20.6738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0600113a-9569-473a-2e53-08d952bf9ee7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1781
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021 15:54:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.137 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.137-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.137-rc1-gf73de39e1fb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
