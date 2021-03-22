Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739B2344774
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVOf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:35:59 -0400
Received: from mail-eopbgr700055.outbound.protection.outlook.com ([40.107.70.55]:13536
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230096AbhCVOfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 10:35:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8PbbilZy4cvQDs3Fytdo2gRogoPb5q1YNcpdE7U/qdfcHCVWD4tE3KoqTmnEEEhEpf3Xtwd0A9w4cRRKKKRvwup7BEwTGRNkFgOh+9HzbZRaBFf1cfJkyOkQvTwrZ0/EBy+XI+gMWK2POuXNhP2eLqSAQEAp7F9UcmhVLM85ls1p4wNqhnNu8KShKnhVoM9C7FND46zyZsPTWqDXefCU7n/YVRKucKx73TcVis0bktaib02/YPykAVBJnTNCWaIuBhuFAkajyf6N/A5exR1tKVwPxvJe638i35QmkPw01G9Z4kgsX7ou+aTOcu2duGwvW6DtmuL07b0iLbCnfmKew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUiHT+MI9m4K8s32X0wjM9W2tA56/MB3V8YHVJorGuM=;
 b=gHIHnPxJ7Us5jRvkpDbr65Qnj7n6/tmHzbDbRP7QV6ox52tigRSBSAJfin3jDeWioXthM7uYHLMdQRhV7Zr0XQ57FMUcGLMlPocYiWRkJzEVexP7dlU/uz+pzFn2uJYnw5jFeCgWDKKrxQURpHssmSC1Db3/h7T0LJsnLjxl3dIkfcbgdJtbKi7w56JqfJuzWXRmQDrB4OWmSQa3ypGitfXpi0Qnv1n/4WhOrFJryWYHdr/8gGD24+lpsnKKLjDvnAYkfO0jVBO9C7prPz0dY/iOQDIeXFtdGldnMTllvnW5cb1bT9zDzas/PYodmooZShXKLrblmKIe56WGJit3MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUiHT+MI9m4K8s32X0wjM9W2tA56/MB3V8YHVJorGuM=;
 b=qz5jgtlzZ2rIrJIPIwHUgZTFFzoZg7txNKWopMym5ZetRdJrvzX35mjA5RiY2Gu3hhTSX3ywGBLrveYtDGzTOmx0fiI6HI6I0URfcSJW8iSvcCKbxfIzKHaZ7CTgIipPPpr7NxF6fPB4sp0W4RBrDtfbILBD1Pm5idUlkx2Q+lUO+YrpQhfj24mVuV0gX1uPKfcPPFZzytjCa8YS1JqrvJ3Mm66vEl6ULqrBRnYbp9i9w3rx7+RjB57cadBkKqAnuyqRu0OR9IeNCMFHK8GJF+YYYzZ+UE89hTxULAFSP4FrMHg2HVzl2mL9TEzcbobVmWrCobU/UMwvlODqw12D5A==
Received: from BN9PR03CA0772.namprd03.prod.outlook.com (2603:10b6:408:13a::27)
 by MWHPR12MB1886.namprd12.prod.outlook.com (2603:10b6:300:10f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:35:34 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::b0) by BN9PR03CA0772.outlook.office365.com
 (2603:10b6:408:13a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 14:35:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 07:35:14 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 14:35:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/25] 4.9.263-rc1 review
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9c34b6f05d5e4cc38bffbeb168a9b8cd@HQMAIL111.nvidia.com>
Date:   Mon, 22 Mar 2021 14:35:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdc94dd9-e627-443c-b429-08d8ed3fc0e0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1886:
X-Microsoft-Antispam-PRVS: <MWHPR12MB188690C9827D2A1E6315FEEAD9659@MWHPR12MB1886.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtREg3J1K4F567FqzTw51G/d00JGHYipD0idsZaY/zaMPy46mjsVHGKI4lbXIx2BIApX+HV3RRNrg1ZfQ05JqVK0ugeY11fVzVQVwwrwkHwEdS2LBV9QT8zGL6wjun6bCmFr+d+bSEtKLkVOiSiYK2AYMp60V8Ek51n7JnCjwwiTxucp+kPnzH0vOkqVIvrlmwE0I0wR/y7QqwGcm2pHdF8tVMrOMsL1Y0cUMCuNuRvaw00FiI0EuSKJe9nD9TERziU0TDTecNA9WOO9BGYs24XsR/DyNGkMcHR3rS4QYHg34Vkvz7PZ6b9dWS7F+IbxhzBsSMjJ9ZW4Ccyzux7zjd2vX7g0ywZRQa9nhGpHif29bmNYOzc7GokVyyRjt3ujwsLPpeASewJRQ5FTHAUbgOwx47OL99eWTwBEURg97BXfRPvSVpNQzTThWYsdgLtf7Vc1kGeGY+CP9S2zNVgchBGNvMDcGXxtRPqhsn8xF+6ZgmIkHpG93D7CWboOvzAoUkERdOl0/D04C4O7Yyiie5kYIXpPN+dc9q+ivBwKkynCWLzVdB++2/Paak1+QzvryJO1zBvP1hxiAOjW5OjzlJt2GhTV3RUGdX9spwsczsYjlrS/EwsE742/lIPSz+zN4e7yAJErFOnrRxvbPEy/A2bdYx4LzIRfw/81huVYMV/BSiqGKa8uFqaUobBVhuNLcC3cOmX6CF1YDYX2Zw0v1pqbmSA4lKNOZwyB88SIDvg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(46966006)(47076005)(426003)(356005)(2906002)(336012)(8676002)(6916009)(316002)(36860700001)(82740400003)(8936002)(478600001)(966005)(7636003)(108616005)(7416002)(54906003)(186003)(24736004)(70586007)(70206006)(82310400003)(5660300002)(26005)(4326008)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 14:35:34.5950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc94dd9-e627-443c-b429-08d8ed3fc0e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1886
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 13:28:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.263 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.263-rc1.gz
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
    34 tests:	34 pass, 0 fail

Linux version:	4.9.263-rc1-gee852ebcc01f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
