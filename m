Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F67D361D32
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhDPJWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:20 -0400
Received: from mail-co1nam11on2089.outbound.protection.outlook.com ([40.107.220.89]:39104
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239784AbhDPJWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTVsRDSUoDvHvJCQz+Y1lp7wwY/Jsv6frT9HkRbO0SfqM8OoRIaqRHtd06RyLSGBlVfK0QX9vqN64CFVJLSQAjkRbZeHSQ3n64XNcgQ49jueOGZ8F0uDoSCpZSmKBav2bYnIbezLNui77g8O1k8jCP0AoAOjxv14AaZoW1Df9BwqFPpe93jfXeoDUpKiiQNvZ5XsjZG7d20IW/84u/p81mzwpxYaRT4ouhRDp+lgXF95tgEweFT6VD5YLNPOGlveNAmkPwQo4Pa21X1XQIu/G7V+QsgiaJveeFLxkUErCfsy73lAzOEHtxgoJp/FBOyO/AiUslofV/EmHovId3ylMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjowG6nWVB0msvaBbbvfy8E9vTUvpPBfDZzgpKjI8SE=;
 b=hGufPutuyGtcEb5kWplYXJX70S70GYe6vl/SDz9pLkQXbIxzOEJzBHqoCrbghGS6rU8BRSi3BGFjpozv/XJ1BUk2w+iKSbJhB29lAeWRgT8vs1nQCqAJBMPLl7YhMyc2M2RUl1ADYPZ4gKQK2mnHLbvjxt+PzS+tgMhnLg+3VZTX1eQX5B4ImHsrLO8ZMC0fhK1n/3w3Hxmt12mVsz4kceTQ3jrsnjfJrFDXCoBk8HgVAEJhh5zbyLw7NSxMqXwPTtMXd2lYCTjukfPgLbub5Xptsmp2Jquwu5/nsG5V69tBNPD5fMkFG8GV4g0yGBn5XhHmQFQIMPc4qZGc2qNUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjowG6nWVB0msvaBbbvfy8E9vTUvpPBfDZzgpKjI8SE=;
 b=f69MTx7Oy/UBK6hbNK36snEKobGf5HH5FGxRRHWYMi4b3PI1ZBdshT90HJD/0QiauRxChfiyCV/YT7yoiOZQ6cKJkt7VmM7meDFY+Vk8TJrSvyPePCGNz5b2N4Fi8jXrsKFyGn1scQHNJrFz+RFxjoM5q7WgFSLS2vW/1h/ujKsak0SvxNMZem4P/4Dar/X4+kfaWx3eBxHLsN6L/BmtSLYRlvgnyWCNNJbI5xtwA2NlTpJbk+nfHqloyPNaFhsr7YpwhdDjwQdo/3DskwLZb34DKprEoLiFmqFvnjEsEHH3kHU/0xRERKOe8gE5E9F8HRj4NmDTgKQkutmT4O50Ow==
Received: from BN9PR03CA0891.namprd03.prod.outlook.com (2603:10b6:408:13c::26)
 by DM6PR12MB4861.namprd12.prod.outlook.com (2603:10b6:5:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:21:53 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::a7) by BN9PR03CA0891.outlook.office365.com
 (2603:10b6:408:13c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 02:21:52 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/13] 4.19.188-rc1 review
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <20d88864c71047c3a986292ebdc66ec8@HQMAIL107.nvidia.com>
Date:   Fri, 16 Apr 2021 09:21:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9adb03b-c24c-47b8-a220-08d900b912b8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4861:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4861D62EA9723828407E8F35D94C9@DM6PR12MB4861.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGYi2geLZmMDHQ2PxJj7MiJOadkw89fk4p7yzuMqoDyEz0/tkkytlMzFsyRSqeu5AGBheFN0l2RR2fbklkqOcc6QVl0mRQj6DtDGjP630ZUPQEA5PTEkOFIH/h7nduxUJwh0GB0X1p9If2mo0tQyxge4BngXf23V6DvlAHG/XGYh5EFzsrTP9SbUBjv8tKnC6IYOdPU6dbAIP4iMIM95YMsn0aPxF1ac/vRQfU1p5xAIEchOiCEH5FIYXKVS74LUCGc+mUukPjwkYdl/uC+R2gvfsJl0SZlELwRVdC1omgFnSkgDHTeSspA0k9urdB/riejhmzYUtzfVKMJsixK34Q9aFvEO4tIVSSXHcxEytOScwyy3pJQUTZJ/w9rnoLBX+FlX3ecSB4SdP+B50K9arvkGCDlNUze6bwKeDzPw01LCYzix+FE2fF0fWLZ2cbqdX3oTCJbA/TVr8EocxoRiGMEHxoAKYxrnEwLi/AYmp2WE9ZhA5hv76n0+MjbevXsznPmXaCwjgRQTngFgf3k/bGf2epHtLPo2CRgmbyyhzsbQviweDsVIjHDJ/bzDhWmNcawWHgJpOx8Gf16fVl5C95LlonotQjWSy2uxyeBg+NrWDc04yllms2XUVyuLJhkQIfGu4ZeOe+l6AOwZpYGe7FPaAxdYq7AcHCWzDAvtoPNoCXesk0Xqfno2gffkX06hcOC3GRqL3VjcuFAVEZTYP1LOgiSmTc3L+TDYZgfkQj0=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(82310400003)(4326008)(426003)(6916009)(186003)(108616005)(5660300002)(356005)(36860700001)(24736004)(7636003)(70586007)(47076005)(478600001)(336012)(82740400003)(26005)(966005)(2906002)(54906003)(8676002)(7416002)(316002)(70206006)(8936002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:53.0836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9adb03b-c24c-47b8-a220-08d900b912b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4861
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:47:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.188 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.188-rc1.gz
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
    40 tests:	40 pass, 0 fail

Linux version:	4.19.188-rc1-g9f5de887b160
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
