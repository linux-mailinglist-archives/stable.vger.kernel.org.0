Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BBB3C6BDC
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhGMIGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 04:06:54 -0400
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:54881
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234157AbhGMIGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 04:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBMc7DpCbpp7P3l9/nfC+dWvMhsYuZksGYxdlyYY8BV0BX5M8EZlxGoRicz6LZ9GS1wTXSZa3ZCVi4yFzC73uPQxuCwQft+r1wbXlAJLSsEH21VBzbSolMkVSfJUDaLDqa0F5CafWeIskBmlH3tHBD47BWWsL9+ULo1WPYG/gJRnt/PRVpl6vE/WjLBTIi1qMxy1na4DHIQkt0twX1ODH7FaKX40SkVQCoYhgehdzXyFBr6zrL3SEOAy6ZQ+eknNKylnVYbA9oTywO6F71DEZr1jS+Vy/U5zlvBj1RNHubnmaeOaCZ61Z0gKW9JOPdzqbzo105YEMRhSuH725Y031w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXe1t9MT8DGmIsU/dLUA3fWdUr6dxm7MiALiGWFg7bg=;
 b=arw6DBT61HpN1BTL657ipNLmc5GPoIBdtM5cndMx8QL92H32d3nV6c3tNzmvldKjWcMEKpCg8A2JVckY8U8f746+BU8IByn+WINcHC/HPPHBMU0FhxCtl/yXc31f4o0c8RdT86cL1d/ukFzLMmUIjKZFP/J0fCPkjRcA0ydbjAVFh+BchU+qGa63XVFFkP77oCicIntpqDBBUifwdtgyoCjcE2EiK2n/IsZDg0/HRTCMoAIa4fa88VgRYtSWLDz8MQuAYNeru7AIGSA6Gsyw2Q7VuTeH2ibj+w33fHU4wwKWyhhPUd3iR92w9Aw33HzG3TJIK4VD+4AQeAYqboI4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXe1t9MT8DGmIsU/dLUA3fWdUr6dxm7MiALiGWFg7bg=;
 b=D9FxmZ8ZoX95605/x6R4SrKOXCLUKaSQGzvZPdYD+4bMyEyPFiQZlVfsYENfOUwiuHNlygoV9+qYF4fxsXez3Mbupn7BR+TYsGAZrVBq3Q12MTapCE+nNIDMgpUHnZHctFCzhHZRjCVq4UfHkj7ChjzYN82xOVtpEpe+/a4U+7bw03K2wvOoUmeVf5ButBgaWHmMW6x8IBhlLPU/PDL3BRXtEl/22SXO829SOxF7GTjxdpDrxqfGjLI8lEsDafBvo0wMU58BWK0UjCxFzT4WRiub1y+cexigZ4AouXGllOBPGALaNL3xpFD63B4zHznhaB12GX4ekGG1nVecE0qMSA==
Received: from BN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:408:e4::14)
 by DM6PR12MB4988.namprd12.prod.outlook.com (2603:10b6:5:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 08:04:02 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::19) by BN0PR02CA0009.outlook.office365.com
 (2603:10b6:408:e4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Tue, 13 Jul 2021 08:04:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 08:04:01 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Jul
 2021 08:04:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Jul 2021 08:04:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
References: <20210712184735.997723427@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <975fa0a9fe264adfa478ac6a69bde755@HQMAIL101.nvidia.com>
Date:   Tue, 13 Jul 2021 08:04:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c42f7ab-2251-4588-a24b-08d945d4c6c2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4988:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4988E34CBAC5D89015A9A30AD9149@DM6PR12MB4988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pAxxGRWpaiiiNA/JyrzVtb6lG9/ENEaAwhcuSthUIK0nfL5pIjeWirrXnqv5wLZG8COeFm6ZVWSi/YZO46467z7H1diiTOeDB/OLVcqCJqxqQKKpV/4I/V8gi2jfT3C1MZqFb/ynu+QfSETLXE6nnGajSjE6qnF1dJ3MyUigLU5te4yeYZcoEoF7b26RprPHodQhtBSp3OUeT8lSa4GTPF6l2v+oIuAXIxUMkoV2Z6T9ypAunARIAjpJt0d6gQN0kfMT3m5VBmb66ULLQnsbg/t1xGL6ncX57nMWz+gqlbeX2P1FZjLt/LZmA1kxJhgBSRCwc3/F3f3VkmnWf851OwNrPDaakb4c2fDau8emc8KUSRcfXGqD8clz0dbt+5OiLmPNSIeu07HgmqMvOgawn8w9AXC4h5+QYfQmX0HBowt/AA9QJ14cx23Rip4yTQunggoJODiyPiQZj4HwIvYMv1oY47mwqTYFnmeFLL7tAm6RLRoF80vXXPdeAA4aWziNvy9u4URLd0xxWWrbmem05PFVVFCRZfWHt9qkGWqEI955CQp1i3SHV+Bynylq/9RHWK+kgHG0o3rrTfDOQFj13uwtNqeTl8bn7SYRe8wEXn5ZrjWtw4m63/T1C63S/q1vZN0eo4o0iYf0aKdf+dyHNYekXpt/z/k6XDcn4zcpEmY8HtB286qBd3w9IlQSTolEw6BB3lACflqMTV7p+vqjTQAw8C3HlB4jgQqa9TBQSc7f3qFb1hP1nBcoMLreSEpH2+oZjHfG1mMIjd7nRzANApatKXruVrmoFrYl45zZ5+97dgLffzHyn+ilgQ0ToWr2
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(36840700001)(46966006)(8676002)(36906005)(4326008)(336012)(8936002)(426003)(36860700001)(82310400003)(82740400003)(7636003)(478600001)(54906003)(34020700004)(316002)(6916009)(7416002)(47076005)(24736004)(186003)(2906002)(966005)(356005)(108616005)(5660300002)(70586007)(70206006)(26005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 08:04:01.7904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c42f7ab-2251-4588-a24b-08d945d4c6c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4988
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 20:49:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc2.gz
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

Linux version:	5.4.132-rc2-g22b22e7110f5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
