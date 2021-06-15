Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7FA3A7906
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhFOIas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 04:30:48 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:35405
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230482AbhFOIar (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 04:30:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWPMyovaIYOrEBD8zGIJIhEuVv+mJw6h7O2gOxS9J66+u1TR1kNi3tZGwxFho4mhA9YSBZByQ4SfB18n54JlNNOgtKea3lPmxKQmsc0DgX69bU1GjpfiQNY2h2yu3OZUkzuV6Uxg2TXzAQo+lDVFLoMrh0o+0evBHxEeIDF3CzsE/Vy8nVF7rbKqI0YuwpanywJd6+WBnNkhbkDZIy8Cu46yU9apZZLDYU1HhZzLwEN50N6QixSKkVWsRJCkFKNJSGulg0RBLu5sm5y1GN/IQxP+xhztI01wFlgccJ4kvRqsGO45TtSmCzBUnlwZO56MvEGgqC1xqLF+dcBs2fnGOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pic7AxXNSyEfdWB8iKBKrvuXEujYnzSvAosvgQv9yo8=;
 b=W29WEh7H5uA9EK+htFzZ3NfAweOPR72UVrvRYgnzoMXyVOZnAXSbfk/7MiI3UCtZv9yVyicO8yHoA+Hq8wViUoqA++8HgaOw2RkQK+c46pXetpEV0aQE+t8eBgMdLdxiv5F15OCk89feeM5JAm+f4nrjRxLZFHeQ7hewGNF0zUesbwbQeJqCqDW68O+SRzWiHGIq180Cc62/x1nDO4kvgd1fOAZSL/fiLpEWvkfB8j6xVR5VD9IQHKWDUmkkOilexaBLFbZko5rAyCBc1f32KX7mPUL4hvUBeBbuWs6+TB3ySaDttUNoQKrQa4WsR+ZfrH3zPkE/IkprzkUJ5I8FPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pic7AxXNSyEfdWB8iKBKrvuXEujYnzSvAosvgQv9yo8=;
 b=Ni1Qks0e78eXotrOJMe2S5mke/6FZZ6Z7rENEVUXQfCPzZ+NwFie+DIkCqb4m/PFtK8xnRTjAPL/pZTzm55stjljDkeRzPAmcQoRSXmk17girW5wXT4Hhs0VR5O1RWLYAibta7NCPTErl9tbh40WVW2kWJpgAHZGtvW/sBCOQzT08i6uS5ur/w120wxa6zgdSxen+Mnq1vDefCzonNcW+ro9LVsePJe3RgfioalHMvrt6Yvffg8p1nstkaIyNk/is+DRdG08ynMlkjSuUK3aGpYsUWTUZR3M4L7KXnAm3Tki44WKLB52IHisCfegSs2ebdPOMuY3KXYnGTIRbOuX1A==
Received: from BN6PR13CA0070.namprd13.prod.outlook.com (2603:10b6:404:11::32)
 by CH2PR12MB3717.namprd12.prod.outlook.com (2603:10b6:610:24::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 15 Jun
 2021 08:28:42 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::a6) by BN6PR13CA0070.outlook.office365.com
 (2603:10b6:404:11::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.10 via Frontend
 Transport; Tue, 15 Jun 2021 08:28:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 08:28:41 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 01:28:40 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 08:28:41 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/41] 4.9.273-rc2 review
In-Reply-To: <20210615060657.351134482@linuxfoundation.org>
References: <20210615060657.351134482@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <572521d29fda4793affb650171633277@HQMAIL107.nvidia.com>
Date:   Tue, 15 Jun 2021 08:28:41 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cefceba1-b00c-45ab-dcc4-08d92fd79543
X-MS-TrafficTypeDiagnostic: CH2PR12MB3717:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3717F5AB2E473CA8A850309AD9309@CH2PR12MB3717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 31DNcjk/RDIKJH7c1GZGuaROeOVWdDqx2sUf/lzCHKtFW9YoXhU/QesXrktAREi9MjcmhLgAJ49Jy1vmsuOjb7aFL3VZvh4rXKBipF4wIVttG2vz2YToA/D8sPICbnWFLKuXpGgGfGZhyTXPE2TxqJ5LPpLxdMuLD2yZHGPYO/73uwriSQ4o5hfVfDmYx1fMHRUt8/97NnOK8fr+Y6LkagbfGtZIftOTjBgntwDRE5jdM4/VWKFXOqzNZJymi9RQl5bYY07NuPE+IugDbP9WqRbj9EmQwoy/RTNsDmYFkyMuJYBFA28yNkg/IlB3DYSbzGz1gMvDOCbBn0sInURG6HAemiiPHouF7AUDBLgOT2giIO2ud/76nRutQid+Uw1gX1lqZTHDnnbPNNHa0lITxqiBZr4olvoSpEoYj5LtSQ+eLM4P/K9s2cBdbwlQTfwMR9de16gOo0I4kL+pP7JcBSgs6+LOUDnOPu3RyArY71EJjuS7dk35I/dzmw0tJD0CnAairWtx+k/z7SkWhcrK7A/v/4V6g/gqnMOLkcrshpnq2CtfeImX6B5SloysOAHKANkD8XdfgdblYZeSUuIPALoPHn0CSYXiMa5LNmtsVPHN6Pvb4bvyEu+GdbhqkaVHOlsproVlQ/9Pp2LTb+vKqQX/1lvSYHuBQYgp8knZLUD05zd28GqXj+iLAXSGQz1jASko5+eArnggjc6OMRkr9mpttUTSALtA01Qh7yEEBvzQCa57k21AkgQk7VYRSeMmang0PP+jXpdu0k2yZIyGlw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(186003)(26005)(6916009)(86362001)(108616005)(24736004)(36860700001)(336012)(70206006)(70586007)(47076005)(7416002)(7636003)(82740400003)(426003)(478600001)(2906002)(82310400003)(966005)(5660300002)(316002)(4326008)(8676002)(356005)(54906003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 08:28:41.6653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cefceba1-b00c-45ab-dcc4-08d92fd79543
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3717
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Jun 2021 08:07:19 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jun 2021 06:06:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc2.gz
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

Linux version:	4.9.273-rc2-gc59bf9447416
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
