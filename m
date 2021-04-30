Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A265937003C
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhD3SMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:12:12 -0400
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:6687
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229750AbhD3SMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 14:12:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llRFijDLSlrG0ZFJZwsHGUCrjSWiNHwBCKUlv99qCFIGOZLn1BFS7ol/FFB8UFlyBB/q/C7p05NkEx9RCLFOyD+q8asE+v38cDCzxK9OgnMnDw5LJUg4Mozwmr8lUO6HnnU2EqR1PdO8njqYSakUKK6cXpQVl5NWkAc+7VwFxCb8kVBB7ohf5OgJyvUmkMXijG5jSECukPc1iBCQkr3OnpHABFof2RnyD92u3yLTNCshIhZYMZtAXqj1bUA1iX212kNqv5Odqr0oNezoq1+hYYMV8rYXcp5JDMu3nNUsTMsYYa+JEjVuw05/1V7WhZV8J0iYuOwAzcuV5GhSGN8JQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTv4+cfdsoZrf/TlCsgGZvluBkb27h4JBPPTtHk4z1s=;
 b=WLtvEXrDz87BMhf05sDyyW3Yr1+4gRdsHAKeY904mveRLgvEQXngJdfy09SmDQbDeIF5SlQDJgqhiiiGX41Ws/GMrDjk7p1S2DqXxnbXUxYnC14ZjYcAYCRTFKJqy6fDwT8F5iCg7aUUkwvEWsTXMIpely3nquXET9i/YBBPcSrcrhVbS6ApNXCrrIeEuTvFeOSLVs4MIBXPEs0KBGqCAjUpPiPqaq5uiEtUhgJHY1HPyGO2KbaeifAwz27m1VG1ylnQeE6HjYLPOVAOLziF5NalF2iHPx6VAKfzIz5owBatAydPA5rBWLdeI3KWgFXvc5FL+lilXBqV84IW3AoeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTv4+cfdsoZrf/TlCsgGZvluBkb27h4JBPPTtHk4z1s=;
 b=rEa0hkMPOji5/95hOzWd5vlmUUMVJ7P98/X5e9OUv0DheDxxHsQMlrbO6qTCEnzXHA9Cv1eQV1ngtgnnUgJ1U2XI2HI33xja29L6XEiFt7RM6QHlGJXqlU1PZwxZMWoHX1yco80XibI8Ce1hVdmOLxufV5YIFHtxHkyKgBd21n2pQC9yvDhaKKhhu2LoifWw+gkRRFV+LZ6k0iGo2TnQLg6gozoRzqNgE1qKb4IkAlk5HitfFVDqqn05mfhybOJZfJQz87a1s6ypXb1ZN4ttBjH2q9eo+3N7hdEHqdSEBNxNSMxMS3Vf9aoPB3lN4gPwFuo/WfMRAFf2mbseV2MPyQ==
Received: from BN9PR03CA0635.namprd03.prod.outlook.com (2603:10b6:408:13b::10)
 by CY4PR1201MB2486.namprd12.prod.outlook.com (2603:10b6:903:d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Fri, 30 Apr
 2021 18:11:20 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::38) by BN9PR03CA0635.outlook.office365.com
 (2603:10b6:408:13b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 18:11:19 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 18:11:03 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:02 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/8] 5.4.116-rc1 review
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
References: <20210430141911.137473863@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fe1624c4017342c3a06240b104e8a781@HQMAIL101.nvidia.com>
Date:   Fri, 30 Apr 2021 18:11:02 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c961ef7-f5bb-47b7-0a67-08d90c035ad2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2486:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2486E80C2259A9CEF8940236D95E9@CY4PR1201MB2486.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYuoJpxEoh/HG4yrdV+9mN8aO0OB1K4Qo4UYuLQFhPhBYVpImYhav+UNqSs2yB94tzPF/l1vOzLdB0OaSWQBSq5/RuXkx8IL/R30v5keAfa2iTR5gHFHiYxm0vdOI3RAnGXCzAeXtdHIT9LhavhQQGJgeyq0Rt8ysdFMhUOZ04ONgrkvSSIRFUgG/C3C7IBoJj/jXXBT9tNjUJ39oLII+m0kGfdpp3GPNunfsI9300XbjVGevWYN3sLYL6webqCAoGSMhgbmnpS9YTlR/eTWS2sBTyGsn+jnHl+6oojQsKm7o4fzvdGm+v7Q9ZkmnOLvtfB+gNDW/PF/FFn9wplcWg3KBuo2rmg9e2srgmPV0q3S2IvdrAq+E3y3Q6VPT9o4ARUKW4AuO6+jSpERpq/5+Rkv8S8Zbb+o7o7gNzmJ+TMyywfEFhtldv2uaQ1YZrY+SaU+dxyRvkWjNuDbIVwY07P38aqG3K7vIcUgLPsuCSxv5KMODA6HMo4qrreOCmKAxoqoOzKi1NLr0gbM3nFQxqjYuClRK4RAYi5nysScLHn47ujOlHXXnOD+LW18LXu4DErASXQxuYxngSooIAojlgR/Ri3sfHFpUATcXJCiKYJ0YC+J4S8FiM0uluUkMHFza9SAt7EPPxgH2LUxd8jl/4XKfanC4GiFgm7xznj/1RdTjYclgQOsvS/2w2BoA6wbsNWuJb+NP0VLeGxnc8tCE8t/rIobT9JK9U6GFTsTtdk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(26005)(966005)(36860700001)(70586007)(7636003)(70206006)(24736004)(186003)(7416002)(478600001)(82740400003)(6916009)(356005)(108616005)(5660300002)(4326008)(336012)(426003)(86362001)(8676002)(316002)(47076005)(8936002)(82310400003)(36906005)(2906002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 18:11:19.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c961ef7-f5bb-47b7-0a67-08d90c035ad2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2486
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Apr 2021 16:20:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.116 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.116-rc1-g4f9e765c943d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
