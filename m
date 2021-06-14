Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4563A6DD1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhFNR5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:50 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:55008
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232776AbhFNR5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+ZWO0HahHbL7//CKNWqmpVpMcRIq02b6scnbHEJo7o9cKBIjH+FD35VyB78WC5bBkoDMWpb+04/VbCajc4tTFBx5pjIjMvj+4AC64AtALt+FkCn9vgpgs6YVNRvS4OglL10DBLOYuGnIr24DlxClviapQS97QM+RJw7S4OH6+gSkZL6+QyN4z+GEUs22WfBo88ouD9XYoiJqfriIQ55jj+/HEUh74T+cqNg6YFN7YTTmn8LGNeRxgOEhAoo6n2gDomOGsebjyZfPKVPv3uC1AJ3aKG6vlmlpVlvngYj+Z7LKCHAJ5RYjFHtSbRlroaxdQGLArMIxno+u96FMRWO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JZnUNdCM5VzOKdllVlTXscmEdMyW/HTo+tmdtU4Yl8=;
 b=NOo7d07ioh3LkYMF+SmA+A7zgcMCNtkRvfRthU1n+G6z7FmiDuIYSBWL98PWI3ifA7CNScDeZlY6X06+8QDA/oaBAtIaSbe0+YL1uqDYNW+ZZkKnbSWGk+LMw2XbRmDPXoc9Iqw97FBNjgHWhOQErVc6A1IJkOFNGrxBnXpvA1gf5DHDGnK9YJdo+IHWANtOueO47855+ZF7iUNGVKK8+rMd5G0ocGI5O5ptfo7oMklK+//h7UBDKiu4pvT2ldNqvuG5D7yQ/yoMKIP2eT3HYK042zDy37G00+C4S+BQAhP0DX3pUvx17NT1kTNYy0J9l5j/XPUuzRmpQTwJIZB77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JZnUNdCM5VzOKdllVlTXscmEdMyW/HTo+tmdtU4Yl8=;
 b=rtaEMi7tDpVftUNgU9qjYtxlr+9IlJ4/T4g2MWEwaFKGquZg2g7XWd/GuZOPlPtXqXlk1SYsbW5oLNfiCLQ2W7VQKkzmPpxcgT7IAcjw8ee1JS/BhJTU6/9LnBGoDFcxKulZZVg9LMu5EK+wukAjiqfTt6UbErlwJjoxMGVzRIk0PLFNpjj2IyrfHOhQpG0NFZMxZR9URHUN9EHmpoJBkuKvLqOLg9N7Iw/SGM/1MiaiP6bgyn5tyMwugIcv3aL9JFGAJx8Y29d/3pLEA/2wmTHQoY8hn+W20UfEBeyc/8A+Sj1LVMFWVPDqerm9c0WzFXwOKNCvtgcQp3bl7aGPEA==
Received: from DM6PR12CA0021.namprd12.prod.outlook.com (2603:10b6:5:1c0::34)
 by BY5PR12MB3892.namprd12.prod.outlook.com (2603:10b6:a03:1a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Mon, 14 Jun
 2021 17:55:45 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::4f) by DM6PR12CA0021.outlook.office365.com
 (2603:10b6:5:1c0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:45 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
References: <20210614161424.091266895@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b2b98ee2944b4986835018e868c52db4@HQMAIL111.nvidia.com>
Date:   Mon, 14 Jun 2021 17:55:45 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2042165-fde3-406f-1d43-08d92f5da292
X-MS-TrafficTypeDiagnostic: BY5PR12MB3892:
X-Microsoft-Antispam-PRVS: <BY5PR12MB38920D4ACFBB31785164D083D9319@BY5PR12MB3892.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0OLIYAOwUa9uVeIocXYA9QadyPrs2NQX3LRRhp0f47HBekKVxBQNkKU4pjkFEW9srfSUH8fvmzFZe5lMZonMzQ6U2x172FkvDZubyVzqvsWouuR+nyuKd/cV0fk/Iufld1cs0vqGPA/egRyVyK+ADd0RoT3trrm9YqM5aUe30FmJvnVrqQ8J7o/w403VephQVlRmWZhXmj2JYHxhXhiGy01GeM/+fvHAzA1PnT2HAXKGt2YNJWLSIgl9UlkwbPrzPxfSDOJxLqi8lRiwP1P1HE1v5Bvp8e+Q+3uQ4eaF3r3PQI4FVtt6etsXt9mqEbHh4Ng36ic9QrDYaFZIoXWYRAPxNN3m7kZJ9FoxKidhd5961RZ0T78ejqLRll9a1QelCaJ/5uOxsXJfmWSms8OCyK5dKvbatmwxrs+4diek72qNqS1LBbv5yVpe9iJwolFm3G7ugwyUdqVn3JXuQONNLr4BnXSJ2eNBjD3AI/JwrnYkbn/UV17XIngHZ94bstZQLbe+htq3Hf/AB6IdIl16y73Y0FQwZuXFuFtloyDW1jQypNZVouq6tr/QCXGCc0VScNEOe2Flcdlj/Hh88wKTJ64BWa90UGZbvLr1LVjY2y45PufPBLKBEQYSwMv+19qFo4xI62uLTS9sqzyf4vccdsVIkkgFMMl/xEkX+IrEefkLhe0nSJaX2fgmuoMus9wv/RsuS4GWTD3TC+FQdJkwkFXCSnvti/zX68wG/iDPHt0YtHugfxOkfmXQiCqMMVBx6VMxmOm7XDdkWhOgqinlw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(36840700001)(46966006)(186003)(82310400003)(70206006)(478600001)(336012)(4326008)(426003)(5660300002)(316002)(47076005)(356005)(70586007)(36906005)(2906002)(966005)(86362001)(8936002)(7416002)(82740400003)(26005)(6916009)(7636003)(54906003)(24736004)(8676002)(108616005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:45.4575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2042165-fde3-406f-1d43-08d92f5da292
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3892
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 18:15:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
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

Linux version:	5.10.44-rc2-g3f05ff8b3370
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
