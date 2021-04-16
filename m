Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6914361D3B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhDPJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:35 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:4289
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239236AbhDPJWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cb+W+Ybb6dlomrncrIpsBi5snsORYhm2waTFCOFTh7XeO8pEJlynXbDbVlOyknYrui1vM+AJiOspGGxukr1KujAYxiAmgRp/TURmHvTH+1GuOb9eps1LnnGXp2pZIQ51vWtVoYa98WIPJC4fbChAcgAT+RTL92rvaaSxT4nXDUYshAeh3uWw8/1TUZRk+BAV9o2IuhDrGRwiWkqABtWM3itHa2aVCf/Xs6UnhQ38PWhcWOMQwdgrhQ8k78nTxJ5olSdbzejjdI+yFv3TVSiPPQQEjx/Si2itOgLC0Vl3AQRPChbGUl7YUKwWdDABtW+3IdlHnPoFiDeh+zQlStNvdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5T58uR8O4EQ4qDXZIu7cR4+qWV8qteM7bZ/Q7fuV2s=;
 b=LpnvAtfDT31DqEJrvoom4Z7CuzII+O5cq141HQeNCMD6h43DKe5TS2Q5YXhPj1ydqQ0emvD3PUS3QpdHxax9mwVwcL2EyAv/tVwVYTvfz1Ps/q5ydxYyuGCOES1djMfvNmfnYwuT5Tyl3Cq2McIY1pPrsXu76OTAmKx0goaGzENv4Uj4CpABOJlU/dkR1hwdMiCW72SJ4d2sw7bSVCm5jHBc6wPf9Sq/0mBguVoQ8meL4aOBjK01iDljTn3Bu0tjwILY9EfkvrCvFjtHPCZygwJ4ht6BLukF5DYhxs7Ho1HDfnGl8obaGuKOBazkG/VbgbPcwP+Ghtl5GZtEqZbw5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5T58uR8O4EQ4qDXZIu7cR4+qWV8qteM7bZ/Q7fuV2s=;
 b=CieQ5qouuNz3cTEQXUYQ1AKSV6kTA7JwzM3CQfzh0PceyFU7LorZGRp85dFj9FoJR4ZYiHd5Nv4mqhSFgEp3sAkeC+KG1eeYvEINzOZV/wrNijRrCy0J8C8kiWsYgxbepgNujJjn3rUdhuYW3lZbLZdy9swgE7CYjNaepZD6JEJVIpzqkAQlzl02+zXiQX1Vf3mEv3smo7KygDa98zQnqlZ3EgmXjdlZfInIw+thgqPatbGcqNISRo8yR5/JbGKgoP53q26cqcuchcFkpE518JITnYs8tEU1169ILbwuqICbS3zCjwATPZXvOsnQcDXWa0vLg6bxoxZkMgtu1Po/og==
Received: from DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41)
 by BY5PR12MB3859.namprd12.prod.outlook.com (2603:10b6:a03:1a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 09:22:06 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::ca) by DM6PR02CA0100.outlook.office365.com
 (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Fri, 16 Apr 2021 09:22:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:22:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:22:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:22:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:22:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <48787f3d4a884e38b61738a7bb860e55@HQMAIL105.nvidia.com>
Date:   Fri, 16 Apr 2021 09:22:05 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3901b208-f28e-4a0e-c7f4-08d900b91a30
X-MS-TrafficTypeDiagnostic: BY5PR12MB3859:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3859E62365998D80CF7F949ED94C9@BY5PR12MB3859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NEb/mTu2qLUFLooOeYJEJmKfNZ91/WF+WzXjKGRLpqBZuUA4pg0lHsm2J6hJ5DNNcZ55LlrVnxuappalW5KqkKuBKIsRiqSuS7J2i/rfQ1X1K7y448K4IVLzlHl/NGfhsFxosKf0/Nnab9RBQUDfHpdHhf8Uj70G9deHMoH60XqGN0cBbuo9AFmCoSVyODwSjkazzo8VFKcn7p3ANtgQ4KQo5UPsxVQ+8mVRB7QCjFclwOcher1RlJR5dLtykUmyPrMGE0Mh5Ld9u8rieyeNVr3kliNgrSis9yDMJ5Wd4FnPCSiQZEqpYjbJyQ0ibNvT25D5c+Gpkg3rUA91WtECLjilxRO0rhLzoNhgHppqdImjBbCcx2L8rXqS9IhAPEEG7BrXUSj7oTMzIeQauNZcnEBnb0Nk5+zJEEhvjJnXAah9jEplh3VIyGut/5nSgJNiwHuWAE8GY52D9qgrPxn1ikMW4bFAbJOAaFQpLlm5WZebwke/V9cjlua8iQMUwiUNbTNdpEGLOrUpc9yFlNhFBXVVGhKjj2P5QJlIGxP/oGD/7VgICY0DGtW6IYO3Dlgq2daebm9F480lKzWMZyaho0tz05DdBeK0B85I3aWL0JX0fwxdl3c3f0kB/8lvAaz0qQ8p8GeUaQV8qdASpq8jX8qEWdQ/tYiJtO9XtUlhqmmMYkzmMBr5YmXe5SC+A0lGDSOElmaWxr7kr3MEQcnm/2q6wpS/wCQHujEzx3zAVPg=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(7416002)(8676002)(7636003)(8936002)(186003)(356005)(47076005)(426003)(4326008)(26005)(70206006)(70586007)(336012)(36906005)(108616005)(54906003)(316002)(478600001)(24736004)(6916009)(82310400003)(82740400003)(86362001)(2906002)(5660300002)(36860700001)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:22:05.6920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3901b208-f28e-4a0e-c7f4-08d900b91a30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3859
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:47:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.31-rc1.gz
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

Linux version:	5.10.31-rc1-g32f5704a0a4f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
