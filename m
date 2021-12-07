Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22E46B782
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhLGJkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:40:04 -0500
Received: from mail-bn8nam08on2065.outbound.protection.outlook.com ([40.107.100.65]:27616
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhLGJkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXIAhK9Mr1fmK7W52UMvmMhzPr3j1zPOujAsmj8r55Oi6R/B9gVyV2/19b3AWm+cNQfIP/p9PW0ACsR/JLRuAVoq0Sx3jWOeGmA3AUvwAQWmWv8TP1VbkAgNUY/oxbbVaT3i1YQ9aLNI8I/IF7ayH9FhyoCzATTfRa6hmwuuQhHDRs4cUTNCsrNkywC9j2TsXNQNj5MWWBQZfJdYdBnNduFSHttZPJh7dc0fau3QDDMqvtpdinT7hpEPCj8CgzrLcHGywWygFJrYHW9qMj5Gx+gN5jorYMeYnw3DebS9DzlnJKgYK4hW0Std+5kW+wHBAAHIwaghyuhviUfqVXxEdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMZ/yplFjRUEMR33X6xSKtCGdlA+Z+9sHkWpzVGcGZ0=;
 b=GGkiVKflgqUHrLcSiOVtpJmeEmFTBqCjupnn1gB67vkK2jZCTHD/6N8NtOpA2bg5q0whS9qrzscpH9Pu4eXOIV9kPDHTbC0qPKGoICn8N9pQB1ccs+Yr8Ji1AVEXAnbvil3FgXSzKVXadxd8DIxSw2GiuObKG5kf3sfyEiAHwXjz2/7lRHQjooSp4Qc4K/L6gR9QKy9ZSbuSz2KmGCGyiE4B1gWvWARLb+T2XrAfr7yI89iaSEM6qjyBtXBLPryw+JQA1Q5qCnRVhjNXgj08gEHX2b0EMjdy8AEDNSYGtU7DPdjoP/+lFnb2zsFTaucCzYd1ocZvl8Ht4g+EeruhrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMZ/yplFjRUEMR33X6xSKtCGdlA+Z+9sHkWpzVGcGZ0=;
 b=ON1uYICAGOTHeDt7WyuPEwAlFCLLVCfGSiz8+TGbQ1NDtW5QBfpOAIDKXZBBKi13Za9VfuZ45gVfu7keDj8cOvrbAZ3XpcC96tmzm/H0NXKwRNEqAt0d6hijObUo9SFdRdchTW10QYf8Ll3XSMZMf8+VpJ5hdQ7j4LBZp2THACdB/kXfeRNip2gowinq9iD53Q/rDr2rXj1lQ9XXpUSQ/um8QkXGgGESOcbYgeOBHDF9oxKZJjpjXhXmigKA6JuvZGEAbZ20P4xB/m5Ynr2Ku0T4Dle5h7dRVvP3Rx2zfKBR7inD0/pnzeZeqHFAG/cRb9REaw4e3BbuH1q22ZV2Lg==
Received: from BN9PR03CA0661.namprd03.prod.outlook.com (2603:10b6:408:10e::6)
 by CY4PR1201MB0118.namprd12.prod.outlook.com (2603:10b6:910:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 09:36:31 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::39) by BN9PR03CA0661.outlook.office365.com
 (2603:10b6:408:10e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend
 Transport; Tue, 7 Dec 2021 09:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Tue, 7 Dec 2021 09:36:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 01:36:29 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 7 Dec
 2021 09:36:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 7 Dec 2021 01:36:29 -0800
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/62] 4.9.292-rc1 review
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c9bdedac2f5f4bd69659296a9dc87a94@HQMAIL109.nvidia.com>
Date:   Tue, 7 Dec 2021 01:36:29 -0800
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b4c706e-b957-4f36-f8ed-08d9b9650cc8
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0118:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0118EF99D4270A6719DD5655D96E9@CY4PR1201MB0118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJYqF08wjbT0lkMiv4+lUXu0BbHFYUAiTSrwK3Jkx/6949sherfHUHJbZrETIRnSvJyqU//cyL2xkEs1iuhaaBOVj9G6CyjS6ByNT4xE9pu+rMxAz44Fwb0Vse3Ye3/fT7h7RLwW6lqHzVS7W6TF2r4CXZ1RG4yHUA6LDzkIDJbGK61eb26WY1oRLbDCda6S8h1iNxq7dTgLUjrk/nywSeu6cgCajFDFgFr48YUwnD3UsopFMb9O0EdhYcdOv48W4tbAtpI+UWT0L/DH6KFlpX8GZC12eFEuAfKlHRtUM/HtIoghgqbouXKOc1TTIb31OlaMh0Q7M748BJr3Osdus1s5V9DCmPzyMys2swLE+IqvZQHqW5mQXK3gSUbCe4vpmvCCTc6CVbshzbAC6tFjCb9Xtt/NhdWE7jrWDoSEK/fTX64KuzdsA1ZahvBCNeZTZWBnSbz5yB+AFaS40QazR5qxDB3pf5+OihRG0C6gFvTDa7u/kjw292b08clRsKw1qhzPJA53M6nlSN1dvrfd0ZpOAUYKqhwItebO5vzTiD3D8XAKWXdwAd71JmCMZSgu8CHq9JBG9chjEXuumRI7f8L/ifKtI34MFyl6NgsQ+28HD1MxWxUrfRhy0rXxjEZkx/dEmlZaFnlQvkTDdQlMJXABd4w+kBnO85v76yF71KtQFIl5UemC3XZpf1X0Yr91zI3GpAiHAeQoo+fiGDnKugViWjJfNIKsbAXfeJmpiqnwlUcpQaGrGp/g3aWmDU/fSjAMHk9Pq8ZwjOKjLQYEdS5iHvl1ywAyc+vp7LIcEMJQ6VNWDz02Acr4dQNn+NNfUlWEt4moLVZduGD+s7hbUP9lhwZAVY8WUIvOYSodE0kdpcyIXjLSZwMYhR7PyUP3
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(40460700001)(34070700002)(426003)(108616005)(86362001)(186003)(26005)(4326008)(70206006)(24736004)(70586007)(47076005)(336012)(7416002)(316002)(5660300002)(8936002)(508600001)(966005)(7636003)(356005)(2906002)(6916009)(54906003)(8676002)(82310400004)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:36:30.5250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4c706e-b957-4f36-f8ed-08d9b9650cc8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Dec 2021 15:55:43 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.292 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.292-rc1.gz
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

Linux version:	4.9.292-rc1-gb14dcd4dade2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
