Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C59938C293
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhEUJGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:06:52 -0400
Received: from mail-dm3nam07on2050.outbound.protection.outlook.com ([40.107.95.50]:24576
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235308AbhEUJGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 05:06:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZT0AqzHmBZaZ1y5SKKyE3JXMC4vAPZNU9QUzBONt0DEXTd+tqvQzXINHK3SDpWdZdyOjunfeSuraD+STdPZ6oBYGXvnDpkb813KgegkM5jYXb54kO65mkxO4qWGx1IKrOUq7a1ijVVUW5oqfVP2PY3K9gy1W4TtGav63heLeayYoGn4osOpGFFSNUerwMePHVntQvoqZUcnvIKGO097dF5KSjAACl3P6ns7xx8AJr2NpxSg2eDFij3LFP8zNWjz3rz5HDgoIVt9NBsYWKopajJTJWthuipLD8ztjKUhb6qSRSlL5QGn0jJNeokBgF6uk8SaZu6La1f+xpiPKR2mgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWbajZ9gbp2LVd7YY5chEYebbs7HpRF551/jyN7MSOI=;
 b=FW/8lwKRaMWDup5g7daGydUfgUdkjAA0fTQA2LEUCAbeDCmMlqZwgzY5QhFcOItupNihxjCkYOxQKQN3G1AWCw8QKDv4AFXvd21TcXxAgOkkrmaNI2Q6+qSD/IbJxXwNemI7sQP4Y+9a7v0UMcnn7bZjmvHDGVKyd4BbuPBysrF/Mqy6HdEToa3Bd3R/ZqnmZKYoTvel+SxAzf8DaUN4L2p1oimKmPIsNhfAo1hCUdq8a17XX61ShppV1NakPXMHaqct0Hscm/K+EPieFSoYRHY1o+z+zcbjsWSCqUiwXt1ra9xSh0Hn1au54iynxVWa5sEi0plHuE6+aC+6fxSWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWbajZ9gbp2LVd7YY5chEYebbs7HpRF551/jyN7MSOI=;
 b=qFA4KEl46Theb4JT6bx+F6911WRbfWA6J6gp9nssBTLT+raXtPSyIm6OrT027RCXLykVkxJrsJF4eJ1tYz0UpWLXjn+ciKy4OCsPv2yHrsbyPikw2KvttXI8YdHEz33fIwtXSJqFlayLEgnDJEZbf42my6i93Rvb9y+sivfHOluHnO/solBFbIP8CvdQKyvxOXCSHStm9MPHFvBWnAxiQS+0vk7jsZFoJv4r6gPgR+LXiVigl0fTF6W5Zp81oknj2GjfjVnomb3MpVthSq67MmJ1Lnh66o0Ns1t0KnlZ5BwyayQCgO71Kxxz2UVrR2yYzyuGdz6f3bvcAIq3S5V1XQ==
Received: from BN0PR03CA0059.namprd03.prod.outlook.com (2603:10b6:408:e7::34)
 by BN8PR12MB2897.namprd12.prod.outlook.com (2603:10b6:408:99::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 21 May
 2021 09:05:28 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::16) by BN0PR03CA0059.outlook.office365.com
 (2603:10b6:408:e7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Fri, 21 May 2021 09:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 09:05:27 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 09:05:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 02:05:26 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
References: <20210520152240.517446848@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <93c23b0e38044f43a14e8c74caabb975@HQMAIL109.nvidia.com>
Date:   Fri, 21 May 2021 02:05:26 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44880ffb-ec2b-422c-c995-08d91c3793fd
X-MS-TrafficTypeDiagnostic: BN8PR12MB2897:
X-Microsoft-Antispam-PRVS: <BN8PR12MB28974A255970DB725FC00DCFD9299@BN8PR12MB2897.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F43S0VFNuiTfHDoQxO0ry7n5SC6ee55rMT6ZTimkGJ9ILtKpudN0F5ZbrglcVuL9zlGIFFY8FBBxUVQhlzGurSc9I0Qpe2xC+Ai+tn8yWj/p9jhvama6emCAlxt3Fs4XtUFQsdGcRFAARVojHKRahdPxlSf8KVy0OLVtgXdrF0OFArRB41viY5AEDlU7hB3EkYKOJBl6ooH02vAzBkO/xNYWaman19wyU1EM1LRTDy+ny124tYJ4N7imE1TesS0fSPHUbVWbEIinK4hqVw2od85/N54cSAeIZLWjaN3DkXLg9Z3o9mUqPbjeX+Hbe8xjSFMy9MiTZRMyUuuIvjil8GeHwNys531RNk6SbtsybUMAu956vK1uEJFvD6832vx7iak9mrFIOltCVDHTk9VQ8QFnx7YhtqX0vrJlLqBwKAPwqn9XbaRgAnU/rS7zoDoQNLqyem64vVBeJhMYhvIH+G2lz+Bw9CzBpmBDnNfQaL1z5ggj8PLuBOB4vGZQe31Ajor+7XJvYQh6k9GkqR8gyYomUPezMZk4nuR47gxEMeZpsmxGiLgkgMnc/kCMDC91he19iM0vBKrNKaay4ozAAVEKGyLShT4f3vHspZkRunL6iOwuAgQONtXljjTRJ5WwhtC1r/11rX7AxwwrL9S4eedrJf3/XciRRLBernM5lkH3HbKEnTwelV7tYGLBuwwytFa7lZeh3OoshhZ/EYraLgPt+hyPb4r6VAuT3cgH/jT1Qc3VeTg2aJvIi/k1n1RllWkFEGImRRqYjQultkx1NA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(36840700001)(46966006)(426003)(2906002)(82310400003)(108616005)(36906005)(4326008)(86362001)(316002)(8936002)(8676002)(966005)(5660300002)(24736004)(70206006)(70586007)(54906003)(356005)(478600001)(7416002)(82740400003)(7636003)(6916009)(186003)(47076005)(336012)(36860700001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 09:05:27.9408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44880ffb-ec2b-422c-c995-08d91c3793fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2897
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 17:23:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc2.gz
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

Linux version:	5.10.39-rc2-g4313768a0a3e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
