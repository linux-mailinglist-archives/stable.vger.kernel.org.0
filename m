Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070DB49F81E
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348131AbiA1LUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:20:00 -0500
Received: from mail-mw2nam08on2052.outbound.protection.outlook.com ([40.107.101.52]:36577
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348138AbiA1LT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 06:19:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llmodGEvPal5wP/5yIsbkzprWfOw7B54I/cYmCsK9DeSwnatiQW1OqCRkKrIZh3vADMEGBdnC56CIkomg9EXCLS1b2tCjYGNk5dhedGaBv4yz2w2Su7Ti9baI2LuWVu1jcPdrXNISSApwqGpZE6QY1xmBw+S+yCCv32JWlK7ZnpW2deOMoxTUq4Skugw+zBpbHfVA/O5Mpio2W+DV92WlQ7Ft4mj+Cn4kZJ1flMPwmvpRWebSnsqKJY4nYMVJh5wfulrRkc28R5IJb0KgJcWIvzDX9nzfC/WWD9zmEDvJYsJce6Bn2fUX8Sv7IivMoYKIWtBZsGEpW2ItGbUsllCgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbHsKnadftFEGR6pNXUC96NSw8V1EpLKl7wf+0vmtDI=;
 b=d1emIEyhbpTV1zyeqtl2xt3g3rvOIJxD9jy87iuoLXPD4chpmhi+pEiwbFbff7Hc970CeF+Onq4E+ViqG2yE5uCpBBG1fhj6lZYMUJ01STopAZh6ocnGEtjTHCw0a2C7FBuDJIEC4ogrsAgHpWun0T3NYDwISTy5lxvp4mNpMAEasmno2j6E72dPPHsoRD/5ty6jSLLTfO5qNkhSZ5ba96/bfXTlgImpUEIVjJWVyDkWFN72Bq79tqjO9PmIUzNTcHu30V3aIcH7Mh9rf7HFBHGNDUiUoYiowwGZVv0afGehaduUe8YOoIZngPk/C4kI0zhOFeqk/iPu7HdNS4a5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbHsKnadftFEGR6pNXUC96NSw8V1EpLKl7wf+0vmtDI=;
 b=o4WeTzQYmkQRFxMdmiwbBPqcBexPanNHOExitE73EVXHrfxjhUuNYn4tuDPmeYtBWj3dQjluKCKNwmMNTwUas6KyKVFMgZ6R91FBmKZxTdWvr/hch7uGHEUgkQWMYttqM6Fe815pipC6bvVBARieTrFhCQAACvMsmyL0IMr59Lt/uTZo/wmaT30fDy6noflBdeXI3CjE18LaFXv1EEP5FHLtf6w8Nm5I7M3Bz6fz7dgeu1JD1Gmc3hyCk1Ejnhb28+S5pQvtKfL/ypxid6rLhFlEu4RbpCFV4DM5D/cjsofjas7jDEwT2Xtp7jglsEbXqEzPUZOdpz579i3dt9yI9w==
Received: from BN9PR03CA0316.namprd03.prod.outlook.com (2603:10b6:408:112::21)
 by BYAPR12MB3240.namprd12.prod.outlook.com (2603:10b6:a03:136::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Fri, 28 Jan
 2022 11:19:55 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::9c) by BN9PR03CA0316.outlook.office365.com
 (2603:10b6:408:112::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Fri, 28 Jan 2022 11:19:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Fri, 28 Jan 2022 11:19:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 28 Jan 2022 11:19:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Fri, 28 Jan 2022 03:19:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9 via Frontend
 Transport; Fri, 28 Jan 2022 03:19:52 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7ee66414-e6ce-45dd-a80d-244a615307d9@drhqmail203.nvidia.com>
Date:   Fri, 28 Jan 2022 03:19:52 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59503ac7-2195-4d70-e464-08d9e2501c04
X-MS-TrafficTypeDiagnostic: BYAPR12MB3240:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3240C4CA331F10652F9D8AECD9229@BYAPR12MB3240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7eRc3+SfsIXEfidMT8qQpRNVb5sEgUbf2/yvWM7ndwPoiD/zydJsfR2QTx9Jzf/nW59t96xtsZKBgyPAUMMkFkeja38DK+aNwUQwtuSAzOaXWOhPkJnblDA1f4ObU2KrJQBc7nKs9EyEaXAYELt0CFg9lSq3AJmg1AeHsqDGGyIJNLRaOxSETFZucCi6g37m/mKLbj+R28JqbS33B+4YiLpzhVY1KX8ktMrLeuwJ8grvT+VoQYiIZbFEnHnkaNHoXdHyrFcmjpTzPV6Uw1b5jTA14ANAkHmf/wa+f8BjlutKJRauGYEvInHtPrJwJZZSBczzV46YQ97bxxJA0Suv5Nhsjgnelujj+XmKgLNZw1ARGB9tC5qRqsF0KyY0wWLLWskgHiOjNzaxXXzKXbFTfJX3mo53J2hXKzc4v4l4GPUjaFfj9FEIM1CAh5u53poGtLmbAGa4P66F3O5GZTpFrPSN3RC/tXEtrp+ykhQlwOzY/ktlDNDDX8Uni0bWo2qhGbpJoF561RxySqAlj5zrixGXtq9fCDpjC7VkBg07PZV4gSW79Dl3rR+jMuv3P2Nz3oiGmQymKdTcP2wC9ytNiaXJFGUnzpizOVQqUO/xal50QdjEqdDl0OZmMbHBuXFIgz1wzvYfahPfF8atb+djvpxErqNDvIo8stTJZe7+QhuOo2ULo87OHyOBLJ3BbDFxYWVNsNjFgYITrujq2wPUcnEqcAYRDVNdDWOFeYnVEwMa5HyygcmvgjC8BEYK7hyVopH4Ku0ZIgHFPIGe3o4tmAqb2aqDDzeBfr8JIrKi/cs=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(7416002)(336012)(54906003)(40460700003)(508600001)(426003)(5660300002)(86362001)(2906002)(31696002)(316002)(186003)(26005)(31686004)(6916009)(4326008)(70206006)(70586007)(966005)(8676002)(8936002)(47076005)(36860700001)(356005)(81166007)(82310400004)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 11:19:54.3260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59503ac7-2195-4d70-e464-08d9e2501c04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3240
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:24 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.18-rc1-g1985ebe37ea5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
