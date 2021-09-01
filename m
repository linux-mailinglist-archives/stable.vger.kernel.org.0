Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6814A3FE2F5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhIATZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:25:10 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:20672
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231146AbhIATZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuHSUYx3u6afMquoA7qhC+aarQj+iu4C5KPGUTt6HIfUe2eoWO5323BtB/iouMCT2Dd9Vw25BlXwiI+tJHBNjIzVYMPnyDgr/YkJhv/Q9XXEBkJCHpAK9vI19pPHh5nuJmK7dk1/dmGbS5jkwKg8C+T4VQxpcmCH2391FBVfLqFfTYiczhOnepQG681VHFnBIfDKDwQRrFqT7Z2emKXXk/NttQYY3rRSaaKV/NbM5s1Fkt4vb0xQDbyiAHYyzTJE56JYXheZy6vV2S9WGMResJMQ7ckj0o9wN5Lcg81p35Y85arC5ED+0XxG3r6i8eZNl7Xem8lXXUpbc0lg2InilA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PPfLRcEEVSxm6glqNXXpQAFEDVMD1/abII5j+GOqV4=;
 b=MauFln2QmwLhv5T47X3ioNBdVmOCP88OB/cyXVt/GglGisZkWhcV/cjZmzt3RtCUdQ8jYvjITwF+lHAf+Ytd9R6b7dRdJL9pZ39o2ALfW5OuGZPjlr45YIs31m+HPg0JwrkGBgswX3F+q6bGC9UfY1GEi9qm0RYVlmQStGPAL8SpbNYZ8RI99b3VdhiUySCZLFKAo4RQhOECSH/n5q8zVhT5+uKEfwBGN2xfikvAmKI3SHkM8c2BJPZnH6DxbR4rdcbNzELeQRmgmY7Qot90sSXX3hOKiHyyIezArpVS5GIny7sS1XbGNUTSWBO9ijmCUCm+LlGSqNyGJ0FtaSlvjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PPfLRcEEVSxm6glqNXXpQAFEDVMD1/abII5j+GOqV4=;
 b=nMHbL+NPVfyqc3sueYNYIfjba3s9yHvM8L3DVS8VKwnnRVKochtEc7UTU7T654TxvkCzFZ9KgylIOdG7oC4LI9nMPNErJ4D/Pz7innCDBFmmbZqXmA/zMVMeKZA9cq7Pvht0red0Nhf2+5Zo5+j6XDa8Sbv2mb/jPFvPdqG/fKgN+VdYIYF68FBqdcGSNTJUiaTc+SQODEvQDejxWFb4iwWxr739hJUErqyuyHXAPGRflzFw7qmxs4ENhYArVjFJxzBCkb80Dg+ivy/fHDXGxbDca5wO8nQzWijyjNaFgvQckpdNXSEOoh3xZdTx2IkmHCK6gSuo8KmmMmFcxRATgw==
Received: from BN6PR14CA0041.namprd14.prod.outlook.com (2603:10b6:404:13f::27)
 by DM6PR12MB4809.namprd12.prod.outlook.com (2603:10b6:5:1f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Wed, 1 Sep
 2021 19:24:11 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::19) by BN6PR14CA0041.outlook.office365.com
 (2603:10b6:404:13f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:24:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:24:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fea32ef23c504bf481f644370ebb6417@HQMAIL105.nvidia.com>
Date:   Wed, 1 Sep 2021 19:24:10 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d614a21-e76a-418f-d755-08d96d7e13ae
X-MS-TrafficTypeDiagnostic: DM6PR12MB4809:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4809413EE4FB7DE69860E74FD9CD9@DM6PR12MB4809.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pCjNPLdtFPr8UQaOdYHRq0PIyirvJPdnG3VjLoJWqG/cCXrTUYmOz8UNiI17vnG17hODsxPpbayOZX1WiveOZiNQbBFUQr8e65+yY9iDs3mVAxb9fgOyunWC88LWihEQFYUZogPtg1Zn/J6Xcw05+dIEU+/2RpYsdXUnruPOD5NehRSq5GhqsUNEz1EdrIQx7hsARsUJsl9l7zoAV3Ls/joMKsbLjQPU8TYHR1ydyUOb4xXggSWcdcTg1OT+9YR583G+cXjCrSibHF/cnY8CZwWFFZqckEVPPUpMWdrg45Fex86NrYVMUIbEv1IMeJ4t3NOh/QCpO0AnJBtgcGsiy3Fd8otAoxmpR4x5UHVr4yIUk8eivgym93dtCb3Ad42ly3GKTymrdTniY6HuzBkJ7Hd5IaOFwsSkcxAMecsGAffBrUmfeDEm0nBAaU/5mVu6eFn7+3GzGYn2yuH7WEaBElR1SyqBUw0nHQz9znYYCZUk5c/QchrF3k4HilNIbJpMERzT9pevum+pgrzGOHcbaI5IX6lXFHcocQAQB2bS9CJinkj9Prfz2gibwgZRLkudtj5T1bmYlmokIy1VLGRTg+G8hLKn/4WPLhKS3+iE1VoK6mPio6cvrJ3ZSYdxFsIa/LMsv4VoZYFCfwIm3oej3mt1EPxjeuc99b221JxPRy5hczr8V9LTpENTlvHIgGNsf+KHfzfqesrH33ltRW+30r8meFgkTDMd0qZUMlwXhLpZ1bpjtu/LHJwpZ4vSR//izrwfv7cL2tev/GCqNYa+qeI3oXbbcAPC1Nb4RfVl5U=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(46966006)(26005)(86362001)(4326008)(356005)(8676002)(70206006)(36860700001)(316002)(186003)(36906005)(70586007)(478600001)(47076005)(966005)(426003)(82310400003)(108616005)(24736004)(54906003)(336012)(8936002)(7416002)(2906002)(7636003)(5660300002)(6916009)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:24:11.1519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d614a21-e76a-418f-d755-08d96d7e13ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4809
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:27:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.62-rc1-gab8ec6b0cfc1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
