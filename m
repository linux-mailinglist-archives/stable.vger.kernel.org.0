Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3776E3C5D00
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhGLNQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:16:42 -0400
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:58465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231365AbhGLNQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 09:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8+Z49ZtaBoTtdrJ8Cn8YkhNMptT55RekM+7XVMkDvq0NfzS8xkaKOtoKIXBVQEfXzo7mr40JMADqkQMUrW/sRcmZANkRJf33i7TP812xAqSVkccgNJV9cHoaYmSJRwScQXRIlhRJDdCOX/ExAdJlQ7p70xnrpJqiGmtg+Yz5ZUnE1ijjg8VC4Vgqb705TBYgaC3ufAWqPaqCuki6BlZw+sG+76bYNyTKDAeqsvydoDyf0ZTKcR86/vGRKSoQsehb5Y4JOGgwJLg1+BdSv8q+1mIf+JiOkHcnOzZqAEtgqdx1KT7FUJCwwftg6WiqyqRyxnppqRJ8fVuv85UV/b91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo4dSxnTlt2gS96OLDWxV/WhshPpml7+exVwL6nKdKI=;
 b=es2GuyWsI0k+fsAWCvfWNvm97m27+RPML95vOzOZkIgN85fpH9mbe7uAKpDjdCsGyNuj6pMqU/DlGqoKipyhgQ3MJLhl5A0ZxVYf/MZ/6TOhZ4LrZiXb43CI0c+V9i89vWW5fuVFkE/JxeAj8cJz6kHcTPd1Y4TtPnzvYZuFvfy4xqoX8nHHym4+yodp0o7BD0Ne5i1Z3Su0EJ2ok2duKBxpmXza9I/cujl6zJXRomspTM5HpoWinTDHUCP33x+7P2dmMtb2jhUbnf5+o/rILbt8K/mhIiL4wXc6X5j1XGt1PdQxfaRdH+5JGnHRymUvO2XFhFYdw9XXGhn29T1Wqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo4dSxnTlt2gS96OLDWxV/WhshPpml7+exVwL6nKdKI=;
 b=dIWK+l6rUszP8qOOSlHWJW93ikYAV9McF6OQyJT6hMOvzj/kUIoOvyy0ledvOjOLgtkcABIlGPSagA0vLstcsGjz40JCj53BqjwLD+GFx5LRrvx+jZl/Y2ECLt9bBnDFVOzexoL2JCOheYzQrig0JyrpU7JLqNR2M3FGOicmPUHMBG/4daYF2dLqZltx9qqymnRmwcmgMT5fxQ5M51VwGWxl5j8f5z5G+FqAKbZd8Q0DdajqoeVdyaRlciS3ob6vpwxpBmsAFiPkGSOqHYYBnrjTEC1KP2d2bj16AYA5UOG89OFG/Lnk4WRl/QMxG9YARps14hqPZBYin+nPRRLJKA==
Received: from DM6PR21CA0019.namprd21.prod.outlook.com (2603:10b6:5:174::29)
 by DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Mon, 12 Jul
 2021 13:13:52 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::ed) by DM6PR21CA0019.outlook.office365.com
 (2603:10b6:5:174::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.14 via Frontend
 Transport; Mon, 12 Jul 2021 13:13:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 13:13:52 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 13:13:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 06:13:51 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <569f263a71c34ff4bcda9aa9912e569b@HQMAIL109.nvidia.com>
Date:   Mon, 12 Jul 2021 06:13:51 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69c6ef86-7c3b-4d02-099c-08d94536e53c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5199:
X-Microsoft-Antispam-PRVS: <DM4PR12MB519993A6FF83AEEF60BABC68D9159@DM4PR12MB5199.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TY4v3eW7qBnDS14NYuyjtTtxL7pF/ldWhzF/y42PHSXtXqYlTmxxdYNr1VIK8sqdfVdn1HI2S+RUMXAWZwOtfhqK5eg66CooBfaZXIaHop74dDq+LRuk1poSsS4BgoAeJvg18gnM3c/59RVXGKu2sOUHm/E7wI8ckVgazKrP1X1xfqTvZWITVYxeqCFEFVgujIRjNWobRAbYqPFBZPimbAn6bpTj9W0ZDCK62lqfRGjMcsNodbOaWQpFa4VqksTA/JJ7BWHJ0PwpSS2ArhT+1h3bN/DEaTGDEAFENtuC0K+Obut95imAk6cr4+ByaxaTbK8lpDDZkoa6Kps1M5bZOlKijd/v67Czd247rBndqnaFg+QorLanrlg2+2zzGgmv3fxM5tnKwM3ujbuTkt0Qtp96rx4p9+D9Dd8zAXvswRlHR/V4FmL/OBTl6AfU8oPjTvX8rps0Mct91/HzgPc2m99VCNYuwZY1NO196CQz2977Fp+Gak4ikDc6yfx7Fo1n3MVTAD1xA/MsVOexg/EZZGGYkfC1WRt6j6kI0eTN89GkmU2Bf81SSHelAXc2NsDpw30NqhaYnR9dbjMbgMwV3rLn9lha1ByOxQxj2jMZo8PEnrh2ZRR6TyJFXx17MFT0e3U9oay+/ruko867KsvgJRggL9elcsowZJqte6xy5TO8PqkQE3yDY0GvtPXtSNWrcUf7S+cAxyFxy82gke0c9Km0Z2iIdT2kFRus9h/JN4tTKg6Xtkp5aq1nea/6YIVF1T3Zrq/EneA3BSVPwKnZcCvSrL2Telr8XDkai6V2ImUtyGO2OIcXLigntqVao074
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(316002)(36906005)(82310400003)(34020700004)(5660300002)(426003)(356005)(4326008)(336012)(7636003)(47076005)(478600001)(36860700001)(6916009)(8936002)(966005)(70586007)(86362001)(8676002)(70206006)(24736004)(108616005)(7416002)(2906002)(186003)(54906003)(82740400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 13:13:52.4954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c6ef86-7c3b-4d02-099c-08d94536e53c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:06:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 348 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc1.gz
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

Linux version:	5.4.132-rc1-ge00f43b5589c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
