Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FA938B330
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbhETP0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 11:26:34 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:26161
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232335AbhETP0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 11:26:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzYECQbgeoAvzSFqhKhG2wn+kw/Lom/VpVsNHdPuAi9TS0bIwDHj1ZXYpkAR3NcUFvfp/LqgQtLu/+Ml5BJZi3yv5oyrCjbw1ehOSot+D66unBK8dFjiBAL1b4QWlAWtaGlgnBCX6cCU38oVUBBpQ6rjfc4Q0tvwRNcNV+hkiw+ifrC9cDM74C9BJEl/2BAJZuKWwY25qcUK5EyF4O1ohV4lgpy+PX35UmYrT5se8967YwSJtqOaVXmk8G7rEauiqVQHLPaIeHN0BgCJHGeQM/Jk018kf2mObzBUWSAPSGKcdWDx4E9O10mss7o4twAz7qxpjn/MUNRH3aVcAH99nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U0RjutjSNVIwBEIqm9IPqnMHBH0Z0KUCxbh0ewBxVc=;
 b=KkmycnIHnQPcJj3KdM12iPE0BncrRXAaxIccE8/rjonV/prlLntKVr91RbznJCGtl0r8xHLg5g4GaYLgqeAY2Mr2S8isvFRqXbhKsdZIRJ7wtDINt0QOPD/dLlESQAhepvWWds8xFF9FR0eDtcDxCWwMNdA3HMgNtAAhwPvkhfe5GHBT+W7txnHuvcz+bZwpi3iXn/+8rRtxe0pzrpnjdti+O+TL9dkvVHOP0ysZHsfdR/tZk3G41Duyk/zF4tkkKYEZa9Sn14mxBA4XKc70U4jyIrzgHuNM4WnoAOZVd//3ZhqeHlixFF6LtKogTCfR9dNBPoxDhLSgLVCFnnp65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U0RjutjSNVIwBEIqm9IPqnMHBH0Z0KUCxbh0ewBxVc=;
 b=g1+S8ik9Bn1s82a+2KiwDhqo7A9aPLy8KsomNhMPA9F6t1BP31o0QN+9h5zAlMOOzITRDVO/TcENe311xlcF5D3FkIlVwXXyjvH4z46FhkOLJh/AdIkbkyUNPaAp9pI62bxS1DTA0c8qG5EvDuelsF0N5I1/OPhK9Wq8y0e925GsZGV4b3iGtxfpB9b/7Db00uP4r8W5JPeYXBTSQnJAiVixoCqofuI1pvqu7JvhFBnGQsxWjUtO4RSQqu3RzMQEVI52rwDqpN0GgP3nzRnGNxWncCbrfKyy7Lm1QqBPDg68YC1to3IogqlDHTSjluXyD7lQN1SQVE0p2fZUaBZssg==
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 15:24:37 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::58) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Thu, 20 May 2021 15:24:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 15:24:37 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 15:24:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 20 May 2021 15:24:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/240] 4.9.269-rc1 review
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7eb1f3396a1a483997fc5e35cead918f@HQMAIL101.nvidia.com>
Date:   Thu, 20 May 2021 15:24:35 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d1dac15-915a-4f5d-c2a3-08d91ba36118
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:
X-Microsoft-Antispam-PRVS: <BYAPR12MB46143A2FE0E1C65FB599AE14D92A9@BYAPR12MB4614.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rfR2zmy9XouRyeD4TA7AC4/rosATowZ0bagud8YFIVEwXgLIuex/AjkmIHg9B5qXrgWvlq1Zjd0qW/qo78mQO1+18FQtSJkec9KNVkHsnzbpDwovirrSGhumykpGZouTwwkU59isrKHjMODvgNQq+ubNiZdijo0rcBKN/3uafvqegVIpOmZdM5GWmEnbDyLHUxX1bHeeY3bpQ+zEJCB00TfoLuvtb++2RJBHGRhLYU3efrIcSXhBlXbStRgnVnC4MsDnRlKu4nYyy63IvW5nK4kbfZkGYYUe3ejBw1lUNLglFAaZsvWoB59QubH4LKLWGIpCzWBqMSkHtJxvFH0XeuqYCMIQz5wXSOu1yMwFMv9yvC3qq2WRg5ALZWdZKiLH13ACoEKWTBJ59S7iyyfqYYutWx7a1KNruZD6dLYUGdF7UT+vIQh7pr9frlR5AUd9BljiFkW9dsDJ9INscaVRQHi6II4jIsTeATXudfCbfumcxNkKCZwRsM2YcvrEusw5puyN182T+ZAde4iCDMS4elqK1LkS4D9gFYkRlhzYl+jKN7deiLNDzm/sZX1q7yImGT7d0uNyz/bJpfDk0plYesOABSt9vOygsnrWl+K7gPyOA9Q+qjelDtVa3Zccr+YylIhNTsS8K7VXAFL+VWP2fUdKzyDXW9xNREdoYED3FUHfxO5r1BMcD9Fw6QloCofxXz2WdqS2sTAdt0XOQ692h2NUKTY5mg4u5IqpgEoPfbs=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39850400004)(376002)(346002)(136003)(396003)(36840700001)(46966006)(336012)(426003)(4326008)(316002)(36906005)(54906003)(2906002)(966005)(5660300002)(82310400003)(26005)(47076005)(186003)(7416002)(478600001)(24736004)(7636003)(70586007)(70206006)(82740400003)(36860700001)(86362001)(8936002)(356005)(6916009)(8676002)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:24:37.1138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1dac15-915a-4f5d-c2a3-08d91ba36118
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4614
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 May 2021 11:19:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.269 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.269-rc1.gz
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

Linux version:	4.9.269-rc1-g8622fef5eee9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
