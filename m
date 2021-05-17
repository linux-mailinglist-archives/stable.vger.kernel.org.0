Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5E3383B70
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEQRir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:38:47 -0400
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:7393
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236398AbhEQRip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:38:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DewM9HF41jd0ozwNLx9LBSbLDjD2eJFoJ2NmL5QqdKAsE67d7SkDAavF2dlsZHf6ZFFEo48E0CNhIQ5uryNQSdW51/FC9F3o/ePeCJMigRO9MeSUrIzfWiycHg2hq+9kt/y3hRmIDkkN/C9EaU1RNp5UdUrlMpLwdcTV6y9Gbvj3IBScwmB8I3mH+WYH0uZUYhygP1xIvnDs1UW9o4MKSqMAAUIAu+JGnGPa5TeQthIRHDHmsItCADful57jb7yCBhFev8GroGIqGgsHNttudL3fZYkc5Qywr4zpl3p5gOLfDGu0tXb7d92K/ihJuv7eQJT0fQf+G8EP4/5QskWUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVtQmXCsQaFxePzsRO2IWiDOP5lg43n/9C6TNKW8Yg8=;
 b=V9vy6N1t0JjuhnqnvICBFDQ7VM5utbjLQ2YED/Sw3PlON8qasUU3BoBc1howgQOmYAK74Kv8sJlIHtLQGcE5gGhwJ4uF0UN/wiCQf9CCwNwcY4oJ7jkMRfDDiAStk6/JbvzSryPcLGhtsMAlLdg0o9N353y8tBK5VbDIJdy4wkm0EkVZZwBDFLbsGflcxcpBiveKyQrj5WN8dYbS76/EHbAnaa41E7bBUUubqUg9EmBaPWZ/3EAEvDo9APAs4SHQnQHrl8B55rGFKLEFaAUWRIQeOI/3KBSPv5c1rMUXh6iix7a6uLfkAJcM8MAXDWymtmlZ1NV0CV2ATqEgAp1ISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVtQmXCsQaFxePzsRO2IWiDOP5lg43n/9C6TNKW8Yg8=;
 b=TKo/V0tVTpPc2ER0vSktnOvPzSGHtjOg4d3vTveZ/FyhU50H+bF4AoYL9VBJD/kI9JMl+HIS8TV/wn78MWFmb/nYQD4dBCouodZTCr3R/fDfzexoTIRIQ+SuLaKcXRbKZeqI8VreWNouGwoNDNmG+WiF3u/rJREWUqgTxe0YuyMCt3Fki0mVwziXh6jA8wMAkQDoi6pwx+9t9LAV7O8Z3zCV0lX7N6fGvcme50lxd9l83ShFmTrUuan0YOgLss6w+zjpAJJ2x5Q+R5OsfYONXLXrb2QUD+lMPGW4TvIFFZyPbSbBkXHHCpHOMsNvpFRVMGDQMlMcy53Bw1q4/R8R3g==
Received: from DM6PR06CA0097.namprd06.prod.outlook.com (2603:10b6:5:336::30)
 by MN2PR12MB4110.namprd12.prod.outlook.com (2603:10b6:208:1dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 17:37:27 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::e7) by DM6PR06CA0097.outlook.office365.com
 (2603:10b6:5:336::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 17:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:37:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:37:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 17 May 2021 17:37:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc1 review
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1bdd37f5760544cb8f51573f9037d595@HQMAIL105.nvidia.com>
Date:   Mon, 17 May 2021 17:37:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc128ec1-ca49-4343-e326-08d9195a707d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4110:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4110F23C325252AA87BCA218D92D9@MN2PR12MB4110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9CKjKolKWdRXUIY0PCAgDdsVToFH7NQKdDl9Ulc4rMPzj1LEDeDa6TnJ4wOHP8mt9K+y14dQx3d4O3UuIxgkCo4TlS68zJi+nqGkyBbYfhOhAFP4Pv9itI0rXpVyN6aQlj8ZMGtdlqLIuXZ9WsORSHGqPQEysQTFF9+eSbgAZfoGUWMMrpAVTABk+xgrEp3G7kcdWmEliv+pzQ2S7/4R1zWoHZMBcK2+r1wyUmhl0naSh8m/RtWpFjsa9B2KmKmRoxILnEOwixR6slirCNDY+MArRHKQgg8iod8WcpDGAibYBDcWXrAwLKHWYi+Lvpi/5MPKncjkkmNvt5rcCzNeUv5TiT1nlYijdUKW+9TSyBuo1zQk6Kz8AYRlKzR+wY7ZZEeJC1AXva3u6eN9f8HW5ezE6KI6WGLBw/JFEhq+OxKFyqvEjHqTnUJbn+dxR6gyC+tdSymn39L1K85u5r5On91PAc3nsxV3i28zb3jV9DqpYwWKz+nJqSNq7w0NjrEHsR/8UZIejMDGSAGYOa2P+4Mz3kxgXltC/rm9EdxMfihj8ispz9btfFhmIXp20iEUpCP5y9/WqcuR9IlakhrWa3dQuHD6ZHJc+5t61SFh+TpHcirOjB0IjAcN1FU5TzfQr3LPkFihJnAYZjsyH3XOVEfo4vZFmBQLYgt0H7YUQpUUOQLvXbjoEFq7vUUyNYWPddawmzHaBgkuSfI2kdliAfK4hU7hUp2PCUa4DfoKWU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(70206006)(47076005)(7636003)(82310400003)(5660300002)(336012)(82740400003)(316002)(36906005)(356005)(54906003)(966005)(86362001)(24736004)(108616005)(8936002)(26005)(70586007)(2906002)(8676002)(186003)(7416002)(36860700001)(4326008)(6916009)(426003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:37:27.3615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc128ec1-ca49-4343-e326-08d9195a707d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4110
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021 15:57:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.5-rc1-g8c6ba5015aff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
