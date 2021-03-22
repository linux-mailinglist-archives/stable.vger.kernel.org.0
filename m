Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2616344768
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhCVOfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:35:24 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:25121
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230470AbhCVOfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmbpY4G8lKqHPzBQNUhFmVSXKbz/9vXICnij0e607BZBm4xAObVsqAzsV/mhHY71vt5QceyEpvQCJj3QdpGQD7Us132p0I66B5fnIBagG9/dtCyovJW74SA3KQ/X9bK+TICmXJkbLdHiH2nPE2MNCHFTNqwLSTHu2COFwwxEgIKThHBoSeWfjhwLe9OH2gV+dwUCTcxMuduif87CUHcRqdezSY2tc1/GkFqtjiT9ne9LHGIAc7nUxKZ045Zmcqo2H/taF6dfPojgJFx71GANYxZw0keAvazKSoN5t0JsOwUlS4nQGAunYbjiYtYNzh6jcjGzIsFn5iQ6nJz8H/jzSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD6mXVXfr28b8JZFsrDJR88/pnmifwk/2DaDzvsk9GQ=;
 b=FckefeN2X8zk1VTI4AVhTZw1+pmeVj1KoZJgxTXWyv7IDxo9emZ53KE+P1K+hvQWGE7EFea4G+gvexThZ20GFc4oFm7PA0FocMHMEB1DG+ZS1jj1fYxmPo3J7PQ99knYeQgWisxJGO64bmmnhwiMg7tNnqZqCbPF5l6/6SUD5+U/oBeU4Wf+TYk7KmY/b1/ac7S7SbI4WfeKWGwm+stUDL3MaI5qKmPaAJrrn0EdQsG+lMlwts2gAC81SfNRXzWimdGJPHhaBP666ADEGOszE5ZcYsHkTbK/Nz/0gcJ0NlKQR5oQZX0DtSEJNzofcxFsABg6n76GYAxkSX7Cc2EPcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD6mXVXfr28b8JZFsrDJR88/pnmifwk/2DaDzvsk9GQ=;
 b=mVac/5qK3BmxtZZABSs8fFnK8ZK3LY6fBFamBfgOJa3FZjAsiYZOJvfE+n5N5zvxu4IAADMH6OplaTQuhNA6YBIaCttyZIPX4JyQDg9lB1MxTS/LxrAO+bJC8feqvGflFPO+r89SjuMtjFYG9h2JMjwyBMKHXM3HcnrMl0AJGsG5bULwUp54FyWHnoSBL0/mircW3cAHiXA/T8aGwhnz3APJJkqkp1i39oVhhnn4U7B2NeQdaD2Cn0RBPhaeoHIkBJ+r90+btqJ4ZFnFAuT3bxeSG5dN+7Pb6JeBKwq1no0jEwdEXjOo3A7YjLzYNAC+rZIAdpWnYFvyUlqB/TMxiw==
Received: from BN9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:408:fa::34)
 by BL0PR12MB4609.namprd12.prod.outlook.com (2603:10b6:208:8d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Mon, 22 Mar
 2021 14:35:08 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::ef) by BN9PR03CA0029.outlook.office365.com
 (2603:10b6:408:fa::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:07 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 14:35:06 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/43] 4.19.183-rc1 review
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c2dcafb567bc456a87212b556527d2e9@HQMAIL101.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:06 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e4a2729-696f-4b13-f949-08d8ed3fb0b9
X-MS-TrafficTypeDiagnostic: BL0PR12MB4609:
X-Microsoft-Antispam-PRVS: <BL0PR12MB46095D47FD8958E54665069CD9659@BL0PR12MB4609.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZwBWByehHRnRZvusqZsqe1oPrt2FXxvARXIROsxPLo7tLp3i2CYB6W6N0dc58a5k1QoK9cUhHO6lB2tX7D0/j0hZQUyzLPvziWDp4dEqtM2w4QNniUEOvMgm5kcUQiERhRRzZc33+hfLr+5TIfpnQ+zNW+qEbLH1+NGiZxWfOHqRNTSS+V5svKdzYJhA9kkaOaSBK1IqeJR/AdQS3yOhy3zOWQNEzIr6+M4/RwuuB9YQLAnmbxtGpxhTI06XW5pIiI9rBNyyH4KVeAk3pq7mULPxukboglpdfS8IC1c92nFK3vVq5qs/eVYaAL2Z1HD6KrtKHsqJW2TP8T/aCqxzkLRZP2MrYG2bkX6L/RxT865XYLqn6PAghlAVaMHdYUL6fyaojeDBRqRJjO0XNjMb9pHHkuNW9NQhqbWkLXn1IuTzKbvH7V3q+dwDYNCVGqYAj44A3FEiqZSkjm4BPnJzpjWHfySIQc4s4xMRcZlc3J4e8IUqm5aMkg26/woDQaPz6RBHpNjXOIGKBDoIPVJPRqM7OyQKEvNjh9SPyLRMpL+UPbX/KQB/Ubhf0fXPMYV9WRlRudG9Y7RbgE7A3Ko2kIUOG+8Jwu+P9EMJ/ZUFbfnKgeQ3AdUJ6GyG451wu6MMDxAyYPSrnA2CyB03MDp2Mt+HktgwxBC3pn4HcJK7jMzr6frYTrTPq8BRRUrqVcpcZ/1k9fzsoxNbHCbj5rO95EA7n0b8yTrTzPhtMIPHO0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(36840700001)(46966006)(7636003)(7416002)(6916009)(82310400003)(108616005)(5660300002)(24736004)(356005)(82740400003)(86362001)(426003)(54906003)(26005)(70206006)(316002)(336012)(47076005)(36906005)(70586007)(966005)(8676002)(36860700001)(186003)(4326008)(478600001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:07.5036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4a2729-696f-4b13-f949-08d8ed3fb0b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4609
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:28:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.183 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    45 tests:	45 pass, 0 fail

Linux version:	4.19.183-rc1-g155590e98805
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
