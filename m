Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7CE35669B
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbhDGIWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:14 -0400
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:44218
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349550AbhDGIVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCG/j7hYSXxWjF2JaneJBj3fiB+K/KCIxc618g4pqv0FvjKAnYYL2myKZGWzwP0XClV9BNQbCZ42onwDQFmZSH5+bbpnj6ryfVTaELztxMWLwsRA2ebTWb+Pg871DdzJgpFuiPNQo41wKtWIKAP9WYG5RVYuaAvo0F8MtVXZ+xDxoLSssZul455mXidR0YebB1JdqnZPxd+a+dpzwbtciDHTPslEazVCKSSX4BrxcPOKGLp9vpMtDtgYQr+83Lers1VitA8VMiBmO5bvETKv0qsu+a4k0o7TmNlxCG4KRgpyK3sKzcJaCTExjkXXWrTDJNl/ODcwEbMZnGOseBFDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGUWOstL/RRMSd67AC9Kh/fzVBfZH+VIYivOr4fyj60=;
 b=lc53xD/yilOcVyuo7LHiCAcaBHOlMeTr3YOtdLIUfLq6dNg8kiM38TXPLi5gGTLwRVjtt0UE0WC26J4ThWQWWRP59E0eV3is64A5Qp2UevBajse5SYLJwISyVsFso9A1DJk/T/SfZzB3W3hvlFNekM052Qw+rgsaaeYBuZJogO0EwcLxGkjsAO4Bw4EvhvfTFAzLBphJiiahAvMsI5AY0DG0GdHeNXZM9KqxASkcGWlgZgt+vKn5vTWqq0g7aNawHJ+H4aOmqu957whSFWvsyXEhBNkAKiFOACmAq7+EPB4TpZriYolDLA/VaT5LTepi8cVZJB7GwfPDy+eyQidEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGUWOstL/RRMSd67AC9Kh/fzVBfZH+VIYivOr4fyj60=;
 b=p/eAMuwEOE1hTYCc5A4RGbYuX8vZFTwIeNJS3l3nAIEVWvHDfghwPFgfsmbwUhdKmUXpjjMqkNaNXlxyxen5s2UGYW9IoJFkZeLBx9Aook6i+82Bu8HN1iAe3SP2XalpZBTOD0hn9b3Ze2k5yVU8K6i2EXWMv7PuQ52qjdkjoVD0XoX3GbKn84wqvoHMSJqBZXzUs2MNDMsNyN6oIF00PXH42xdFCTe9Ro7IUPsEf4BVHBz2aNiO+QXHy2oAKbodeSwo17O4w/s9G69W9H1aR4ksBVfgx9mrN0xSZyaCZoV/SjQycAUwfgRAgui0mlLAT0KMSLQ6O6LfsL2xzlWxjQ==
Received: from BN9PR03CA0123.namprd03.prod.outlook.com (2603:10b6:408:fe::8)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 08:21:40 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::ff) by BN9PR03CA0123.outlook.office365.com
 (2603:10b6:408:fe::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Wed, 7 Apr 2021 08:21:38 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 01:21:37 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <728ad1e8003340bbb6dd097221c00826@HQMAIL109.nvidia.com>
Date:   Wed, 7 Apr 2021 01:21:37 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0466c2c6-e792-4ffb-2f25-08d8f99e2a6e
X-MS-TrafficTypeDiagnostic: BL0PR12MB4930:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4930AC65580325E0C11EACE3D9759@BL0PR12MB4930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxDxC61uOAPB6100T/bfgKQaXJ6uIp3oLtpy3I3yB266moY6ejqk6aKuDkJdQGafKEPtXvYBEJmTGfJSlCxCgSnv70yeGh9k1EaKvYMuR3sQPuMGiwOWdMx3ZdyVs7/xKzHk3x6znfbNeHPINsCckePPu9rq77FkeUwx9seXZSBRmhq8JFB1+iZMQ1y+T77LwCep/bFiOA8AMuzJKJQIIgPkBue4cCTajSSKd5pe2Gtk6J2BZIm+du8RsRaCEon1d/lT1DmmGMeJtnHyZ8fjFr+9iAaaTLIYUJocyb4n3twB5q+0yoZ0TpiaKJB8lYkYacCgm4x5AEvejpxOugT1UsrS0bONwCfKrcNgNRjrFY4QLXCy9wUbTw+EwPBF/l0iQE5UuNlccGiX87Z7FW/ZA1KnDZNzpc+3fFX1EErE0RtH3EyKoH48SVMgH0XBsyO8JVYxWv/Mhk1ChIB/mahtXGcFsXm2sKoOKmblNXkFTtCqCHaJvYFa9rQLh9ddRCY0PbcmRHvZd2WJ0Hls9xc18tR9e1JxP1jbQGle2sRyDxX3qr+lRqhke/Pe3lL4zrGsGu57M6U/uJmYbLLOEnKu0KQT4eDHxWm6BkSQllsIxTujDD7UzhNze76POrhE5t+y+/ms9d4AEXbu40BELaO5IE5rsDa9gGzNxYA+IW+uqzckVQJ06K+/lMHInSaGAmR/ZzvnkAtAQOS5SZRc4Skj6UFOVXqWe2CEN/jl+RYBS84=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(36840700001)(82310400003)(7636003)(336012)(82740400003)(356005)(86362001)(70206006)(36860700001)(24736004)(5660300002)(426003)(108616005)(316002)(478600001)(54906003)(70586007)(47076005)(2906002)(8936002)(36906005)(966005)(7416002)(6916009)(186003)(26005)(8676002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:38.2949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0466c2c6-e792-4ffb-2f25-08d8f99e2a6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:52:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
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

Linux version:	5.10.28-rc1-g17879c574df0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
