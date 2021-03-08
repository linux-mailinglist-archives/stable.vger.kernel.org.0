Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB333147B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCHRTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:19:09 -0500
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:4898
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230466AbhCHRS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:18:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lX+rT7wv9T7RJfXuR2tt7XteYF0CXhoIVm0W46PHIjUHwJHkWxJnAebLxHkvJaBaB6ApZXmUj0gZOuSIjFoqddrSUH5KVPGSzMR53XLKTUHNqYhdmoqiKBozqpM7/P/8muAXtsjYLZJG3qL4yIS68w9o2GkNag6Oiw8U76nLP6H7KjQ4J87wHBsUinKWN5Et2d8f2Fijtt+3V5koZqE8VHe6vPMRvqxAGDWICGzLIs7W05fff+GCI+cKS0HlJTUbLQA/+5LOXfr0RLTf8216jFfYdMS++TYRFWIMGhe34dI5acZMgkoGWLn8ZcGyDpl6dPDuK3WCXvj9Sf8ZPHTr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbxeTNLB7KgukVigF/GekFFQkUhcTIWYvPVC3tOi3hQ=;
 b=BeY7v9QjvN7yyHh5f8dCGbVRS9iOOiXPAbC5Xu7WwpPNBQouz3mmOQB2Tor47gK1kOhjUyUwu/fvUoM39lgZQiuKT1jhlnEcY5fCPdxCGhXXXEw5i2ytaFkDBUu6xl8OUmatcKdATOmg9h44w1a1XOIhGs0X3L9JwBhRqsB1RAqRpXq1Aifnp1Vbp7/54cLSl9HUNT1ibi3cmVOe5smenHJqW1U8vIUtmqzRDBYTK+FOgiC2NF+vDhnikzwlU4+9Ju2kHQyT9+UpxFQdw+TUljk8XNixk5Yhaxs+H91VEuqdOcABZrvpcVE7kuvHy3NI0XHhsjpLX5m4QTe9Shbu+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbxeTNLB7KgukVigF/GekFFQkUhcTIWYvPVC3tOi3hQ=;
 b=BW5e0hcIyxp7EsBDEs91X3Dg6b2lt5hmbZoxjfuJpAyHI92Lv0dd34jHnpGOxxT+CqJSj01O7YZ1EruvnvOBgpPNuResKT+pNWa5wiwW2Rr2UagSluMWKgayMvZVYpTznvlpBaXMWXhTxozIfrR+M+OCmy/WwICmRq0nREooPgs=
Received: from BN6PR12CA0046.namprd12.prod.outlook.com (2603:10b6:405:70::32)
 by CY4PR12MB1237.namprd12.prod.outlook.com (2603:10b6:903:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 17:18:56 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::c7) by BN6PR12CA0046.outlook.office365.com
 (2603:10b6:405:70::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 17:18:55 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 17:18:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Mar 2021 17:18:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/22] 5.4.104-rc1 review
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <47f21432b3c24ccfb826bb08fed67e29@HQMAIL107.nvidia.com>
Date:   Mon, 8 Mar 2021 17:18:54 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4880bd67-1561-4c52-dc39-08d8e25640e1
X-MS-TrafficTypeDiagnostic: CY4PR12MB1237:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1237CC2BCE67D872F8D462CBD9939@CY4PR12MB1237.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kn0PvShMGL7BN2hmGf6qj0LSYh4UWdywYMBXovWP1D8449D+WVq5LtGCSqTrzJBO2pfBCi2Vlixz7zR+sALaKU9amSM+JENztU1lfEto56FGr6Nu5SJamz0t9zIholTDfK0MupK9HBDFQwn/HXM6zWlnh9d+DNpGRK9/pzmhyBy8t0T6Ev/V8gADJN77EJi3w0xV/Hn59J0qy3AT+PMNA+FRR7nHGOd+y6YuP6IoeZP2udC+LKaTQDci82wdtk0rAdqfolcLDa5SvaKymLVZ0uIcphwyDDcbW7sXB7UxJGx5GpRUDrhj05AgwinoA11n0mZI5VSXZuaEzyjB3pTziEkxtkbjrlfPfWpjiuMnnOyFYrSg/fFV/Qz2LvQ7XHJRZMX0fvU7KxLfUkUxv5/Irnoi9R/LpInMc1K79nQ454xqC9wMA2xEK9xxqcJxpVU6IZMV5mprs2SB38kbsmBIGAovJX6MHV4KPU6y81kFTRpV85CR+neiUbASNUUuCwESSgyW1vskahJiRnMM3kAzmCryrbpwC3iSDl5OpoEDKIHM7fTatOgyCfhP0p2SLZYLPpfA/hZoXEhny7U62LWlVQEw6Ozvllodvtrj6aC4LertFxGgMJW6VcI54a6J1cYJ1BbdFNp6fti7PUFDJcFKdmqwlkjmI0s8HPnYEAfc11Wxe1vyp16is3weR4usi+UDhSK0Qh6KGSo8XxOmKkTUGFdhREDCCoYCrS0o8VrejTo0JsWj54NklytLotelKQ3+iDI67/9AEgXMynz9Zr7WA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(36840700001)(47076005)(7416002)(4326008)(5660300002)(316002)(82740400003)(8676002)(8936002)(7636003)(70586007)(70206006)(36860700001)(426003)(108616005)(2906002)(966005)(186003)(6916009)(86362001)(356005)(336012)(34020700004)(26005)(36906005)(82310400003)(478600001)(24736004)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 17:18:55.4934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4880bd67-1561-4c52-dc39-08d8e25640e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1237
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 08 Mar 2021 13:30:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.104 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	57 pass, 0 fail

Linux version:	5.4.104-rc1-g1d493929c061
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
