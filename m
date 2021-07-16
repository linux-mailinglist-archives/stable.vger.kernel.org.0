Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1563CB6C9
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhGPLiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 07:38:18 -0400
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:21313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232523AbhGPLiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 07:38:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TURqRBAWvcBZ7DxfApcg+aCUF9iFkgdGfmr/3oTzhcEc556XHlYbCtzlFkKJ65r9tYaj1Cx/jgs13wAts0emaWH0rpJ4gbBTFEKbYYV91DTrG06WrkwfWhVlOxL1ZxiJk2ZDl1lLQaqZ5/QfNRfLEHa6vx8Js3LELA4gKs/lygPhPV+wIar20NdUmDlfP6uw58IIvSUNmQ7Yd94BEHrNGkB7tl5GxSo9/ee7/t2rVTd4LT70ySfUiZb8eo3sKqa0bhwonODZqVyIMC2HjJdMDczdzEeLFc3VD4dt2vJZtmrXJKJS9ADFhFc64HqLiZ6zG0mMsexgeDMogjA80Vbipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibHdMVf8NVh2UnuN6G+O1uGtToIng1mbsn50qsNPXMo=;
 b=N5XKx77ydGgAZRz+Yfp6vKeT3bUHsnpfwoA46xA0kMtryLlsd+JY5KWcBrP0fFCSGAG2vI7c14l9r3s+wZ6bGFX3mJv52S7BVucipBXgmlpuwMDxWixk/WL3xJ+WB/l0H6MxcC7NnONJmGLMZ7Z/9ORgEMntshSDC4HJDPWAih20CgNZozW6F1hGFH61NoMyoIpMSOzIfcf88bDGxGJVZKi83U7L+iwWehuwQ31NSNGZZSO/xYXSSgyHdg7Pvg0C1IfuZCEknA0g9/1FDmoZqa0PHvYr4ybzZQeVrg6dtt6TENW+CzrwRX6cMOOgYkTLGWb3iFuya/ei8YjCySGtfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibHdMVf8NVh2UnuN6G+O1uGtToIng1mbsn50qsNPXMo=;
 b=lQo4q4Foo3nqZ1CyZd2MWJu2j5gJ9Xe05t9jMi5QqXBzH2Fa5lhYsrY/qm+Daz3jN8k2zYjMLEsoEYa/PaKuEwVAirPaVdbcglJiuGqrQLhQX1rT0rnXtKps8p8yvibZ+JnSZmSEK16j7lNaYJ4TcrHNqW33Mw/knkgL8H/rRTjtnsHa8t0ANL2J+P+E10tsy4MQqmx7PudToq13wKvz6rLUgDv55A0bKBcs41SjAXJFeMttjRTa41BS4y5CwvayysSb/sok4wJtd6ncTa5C+rSrNSw1HHlY1AwFoavxSXTihqneG5kSXzLYp5j1HHJrEZzi/WbWA2B9PerN/+QWog==
Received: from CO2PR05CA0101.namprd05.prod.outlook.com (2603:10b6:104:1::27)
 by BN6PR12MB1779.namprd12.prod.outlook.com (2603:10b6:404:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 16 Jul
 2021 11:35:21 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::12) by CO2PR05CA0101.outlook.office365.com
 (2603:10b6:104:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend
 Transport; Fri, 16 Jul 2021 11:35:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 11:35:20 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Jul
 2021 11:35:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Jul 2021 11:35:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/266] 5.13.3-rc1 review
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <41ab7894110f497b96b9c58ff609a5f3@HQMAIL101.nvidia.com>
Date:   Fri, 16 Jul 2021 11:35:20 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efa0d42d-d2ef-4bc5-be4f-08d9484dcb45
X-MS-TrafficTypeDiagnostic: BN6PR12MB1779:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1779F280AA0CAFCF5BDCBADAD9119@BN6PR12MB1779.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XrBe4L+gix5JkP/rmKTngQBtNjWqgy+cF6nGLba+IRb3tOvlzfm3d2zRYWoo8+XSTbcOl2aaOmy/Km2/fIXs1fYmk+T4LyIBWoNLAFZAypvdQPZMwFltGnszLT71PNlCaF/SXy8vP29uOZbDwyFUhyyKosl0bQfWN+B09YfPdwjhri93tJjKzCwzHdTuWhtPHySghz9TvnhiKm8cRD3JFYclVpskD6F28GlFfPgBq3zCGHlmFEpux5xeDKDRPBSzeZNF+vAs+p9ALCBOh6v07hs6Zyt5qGIZh0pgZnPb+1t7+6s4+7OHj7kcJWMwn2e8Aj90HAcgwxWUEXzWE+Gwozbz4DR97uSPrj34ho6W3YXYJ3wgrH6VZMhKl3qXAeKoZLYU3t6y3t9Vbc6Yo2/HMwn8ugu5e5JUEuQBBSMlpMpeQFuQkLhQUdcB95VR7eHdMiU817gJQjIyJotH3MurpnYEtIzdBbPFNbrdbI1uYJ4lPwVOeJir1x/oi/bPt8TvnaJZ7V2+0PWH9PFeM1x9ka2tXRu00Xo/sJytwzj1kTkUkPiHqhYgdaSDirdtbsX85OLt6wDSwt9W/nJpFy8ngm0oQGBJvoe0K2bPpnWitXtsO5NKWEU4hAmEGltCYm4TbMCtrBKu6BmMGZcfkqD16myjiIARU9UCsw398KjDXtzLcRFaJEBygwJaiRfdlEZrauiJht7urI7y+ye3Px9ZsSsj4QPc3CRHxqsB4UI96e3RZz/E0mkohPOUZ3AtDB8ffCHq7niwXygVqVX46QyUyS24LArJVmXQ8p+GtJFFxkIomMJxnqIJqz75MWXi2ALS
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(36840700001)(46966006)(70586007)(6916009)(86362001)(5660300002)(186003)(336012)(478600001)(966005)(426003)(4326008)(26005)(7636003)(7416002)(36860700001)(316002)(36906005)(82310400003)(34020700004)(70206006)(8676002)(82740400003)(108616005)(24736004)(356005)(47076005)(8936002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 11:35:20.8603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efa0d42d-d2ef-4bc5-be4f-08d9484dcb45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1779
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 20:35:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.3-rc1-g7e5885df1870
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
