Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B541C417A53
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbhIXSBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 14:01:30 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:41191
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344663AbhIXSB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 14:01:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZnYb/6ZYEmBO5zImvU7rv1CTd0U9FTyrdFzP3xMgM8QNmegWr9Eum8msqXx8nvw4ENeWJHQMIcj4FAhb6yAR3//KLLbufFn9t81ShgUERfgnRimDYnXTiQdfoHy08DUnlEZ04+K2WSslzsUzUQoUz5pH9nVk5zlk6FLCY/UXUeoCgs0UbK9BnlqUCXvT/rvQZBAlLFBn9NnqzZX+AdE49Hr9Fb9DWcLq3XbQOiemJNBB5ZxJTkO4rtvdzcOqJwi+FzQnTYGOrt52UJC+IOC+W23hL459VNJxtLs2XX/N+MFhNUJizu7iOUyICe/AP53nsD48BnbWYvue3PG7TghDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8Ct1IG4lWXmLysXZQc3Pz8YRq/Kn4RBF6YNcctffPeM=;
 b=PzY/5ti8VNaFNJZfW1PqrMzkwuk7Saogf1fE+1u5Cx+5Ks54fr+AoWgiA7ZffXcEfD83HHIdGzLhmOyXBAP4xvTZEw0kWvIA5RTV1MVLwwW4YDXeEpnF1A/hI0zmDOpND7sGnxFO9wTUAM5dqeSO2J2+HmbrUbTvbIjFqEcn2/ghpNOQkuqYTF1aAaoljnZWJYIOFXh+O51PJ2VEDUDGC/acJHlfKp5Eky1mQQPi3rUT6WoonhKdsDfjWpGz16x/+HfSBYfG/oziyeFDfi1VvSlyaOUkcSzH+7Lw43sfF8dwtqQMBdMU3mdJxDBOX6AlNnIHftm1Zy81cYzR6wesUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ct1IG4lWXmLysXZQc3Pz8YRq/Kn4RBF6YNcctffPeM=;
 b=rYsh5MsF/Qbw9MEbdG5bB2oQ2c5QaV+YFBzVjMEUKBEuzk6kOHXK25GdmXU5W413/zcJxSquxI4GTa6cYRW0uVrsn+27qtL4WLnErLEkRkTM5fTnlR2XTRRnuDlZh53CgCW0k8sdBLwR16J0qpnh/OvmwmtnZGDuz8Oor4Rqw3EGylszbSs0m/ynLnKlyyky7QwIEEupRTa2F0dMU6ssaUm8opo2MSobg2APzwv4v5NelPJjWv8valwfjc9/vASbyidalPg0uaC/iBmh5K6v4Plk8a1W9+aXAFQJVTN2FD/CY+tfHBuzAB9VLADgQ/0yhpilqWBPyI2inQXpnyrj0w==
Received: from MWHPR14CA0036.namprd14.prod.outlook.com (2603:10b6:300:12b::22)
 by DM6PR12MB3770.namprd12.prod.outlook.com (2603:10b6:5:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 17:59:54 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::ae) by MWHPR14CA0036.outlook.office365.com
 (2603:10b6:300:12b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Fri, 24 Sep 2021 17:59:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 17:59:53 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 17:59:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 24 Sep 2021 17:59:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 000/100] 5.14.8-rc1 review
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b90d88613a974b91bbd301a208ec2d32@HQMAIL101.nvidia.com>
Date:   Fri, 24 Sep 2021 17:59:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 647a7cff-fc61-40cb-d769-08d97f851ce2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3770:
X-Microsoft-Antispam-PRVS: <DM6PR12MB377099D2F91A21C2B6E01F04D9A49@DM6PR12MB3770.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCdbjGdojNaGITnYiyp0qMYtEtp892WrMWwrl8kOdpGh4UzwjiGAr1CsftW031bXmDzz2oziw+hm2993WloH5dCVokJs9vAUbjN4Ca6ye1d8h1nkaNCE4a6GJRgElKP9KmDAYUpc1lsNxmMD3MrNqRaTQjaftHv+8kZknVwlm8bDBK5+e+Y4Mg/rYFIxv+vanR1dTNeKOHJx+otfkvrU4X+efTwQ5pwigCI1Mmzn3ICfpdsRqmWBNSVlEbAiUGJx7RS7pip5m4ra1wXiYOiQzQ1ngsjAjs1YOsTsKgwCJQvyvKwfjR4cPXIV+1I8IAuF5HXuaTYJYkq+w3dgi/HWjlsRMeGxN+udnua6pSKC81PoyFmAAfOftS5Fof66HQOhYH0Ou8D5iLF7mQjn7TzuvKbrHJe5KWlPptSV5U6Yj1b32pWyN8lfZjKGX0zSaW8TMPLNTKqirn1/Yl8fV/htwnKm7cZDneJXbfCgxV1/urc9YqPDjTdwdJhOkgB6CQGXfiZj4zMckDMLqtk2TdXtZAxqFAHrg5sAopzwBpO/dTH0Z8Xn2g45CBg5Fh63LVOkMZsmHgby4LU/4lIj/6n1pYzIixujKK78w7xmPg4/hF3gWRPGMf4d4aQ6jYFWa/XTGWTqApN8NOZBVCMvc+fF4toc6CjVSTlK6MAeAHMCRHeccUIm+zdN3HwsyPMjKyYnLzUANjW5JHTxYFEC/p8LpkxvnAuCjRNiOhJyPlO3Zcmpvhzprl8NZM1+OohLbOPwjuvX0WZukFbGs6/loztb1QHFhmFvJaxWT7CgJRUzKGk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(356005)(82310400003)(7636003)(8676002)(108616005)(54906003)(70586007)(70206006)(426003)(8936002)(186003)(36860700001)(47076005)(316002)(966005)(2906002)(6916009)(4326008)(7416002)(26005)(36906005)(508600001)(336012)(24736004)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:59:53.9013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 647a7cff-fc61-40cb-d769-08d97f851ce2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3770
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Sep 2021 14:43:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.8-rc1-g565376331ac7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
