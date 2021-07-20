Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3913CF6E9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhGTIwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 04:52:19 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:49697
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235483AbhGTIvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 04:51:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HX/LVuQia9jpIK1+OxqCQcmERHq4kd+BwCZNiicEKauVnyzuX1MzPoFvkkezIqQtwYpg2HYa7dEiN+bQom2XuTjOtstBXWna0/QNVmNitQ321IWcRXhRi36U3iZQDdlJkyq2euUYgBwt2HBbE7w+D8yDfK1eiBUF8MWeWpeaPig7MhaSMiBByVH5IcLUPafHAxzbhrq4s1a8Fnp6QG/xQC1OnhDZJewuynVAzcUzuZ3/B/YsXeYtB9bti3i09lJnIMpjATB1+xB2ZoBgZQLHfw+/IXJYM6ewX3sO/LlRTOA3a74xhmBcjPOcAcBq8Ete1ftTP3fmcxZI93aSZ850+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvcLFGXHjhKZiUZm20jl/b0BSn/WRTjYHcW0asoO18I=;
 b=LkrUlbeYow03QxwF9ovtsmA+iwH0ZLxjl8bU80AmzYVqQpChAGLfXDuKyDr9ldSVWL/BQ/k8KYcbpTxUpD4R2itsA3dq6YOgjpy/eflXXJKiL4SWhLTQeIy1OzxJSoDLxZBA7qEWFDqAE8HJcngsL8Wea6aGQItnVyKbTJeqJa4CPmJH21ZoNTvEQjUUyR5M8w3kDzj9321E1tTTEVl4XB4yi+wHEtuFpwHq1yTyX+QgFlBHRwSdt9WidupmWIts2JCA2O7e4bsFxceNVO7nPni3EIiFFFSyugEy4zt+My32DHNsmPdpZV6QC24Qfpka8vs+eeFn6sVKoxT9PBY/bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvcLFGXHjhKZiUZm20jl/b0BSn/WRTjYHcW0asoO18I=;
 b=RoRy4BY4pG1PYsSWu64dckVT4spb12iemB7gXRDmakvMSBLgQ12yDl1KUTOigJeZXdze5rg12hGlkkON/DrJ12bp8Bt5JqP50wolxMVKHq+ZbgjNqTgA6pNvffIqbr0tCCBNK6GWUrH+8/iN5Pz+Gas3fDVvASMvSHekDyXs4a+UaXwQdOf9k/tsgXnL5eoYyCFCEE8C1sFBRJMFZ4RLvqwT5DNHhM44Ks3/DseByMPIw8uC5t2EPDOLuBBIDv1g/nJ7Y3PG7YwWamlae9F8wvEjS8jdiJS8qA45fixXONEwOdKhBhxJx850ukyL26npDrBNTskdPNXJ4Xftfw7QFQ==
Received: from DS7PR03CA0051.namprd03.prod.outlook.com (2603:10b6:5:3b5::26)
 by DM6PR12MB3545.namprd12.prod.outlook.com (2603:10b6:5:18b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.31; Tue, 20 Jul
 2021 09:32:32 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::f5) by DS7PR03CA0051.outlook.office365.com
 (2603:10b6:5:3b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:32:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Jul
 2021 09:32:31 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Jul 2021 09:32:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
In-Reply-To: <20210719184316.974243081@linuxfoundation.org>
References: <20210719184316.974243081@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ef09d5be1dec45dda359a457fec43916@HQMAIL105.nvidia.com>
Date:   Tue, 20 Jul 2021 09:32:31 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 837961e3-e3c0-4de4-cbe2-08d94b614c90
X-MS-TrafficTypeDiagnostic: DM6PR12MB3545:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3545C9999B66A393F5E2E958D9E29@DM6PR12MB3545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0P+GZcfQJWF/gb4SjVbSu7GacZqWN0wf+C5QEgWI/aSqBo4DqNDP3AfwFVEfBUhkf3bWQH/eR1FmqpgvNUZ8ZHqivumANjrt6+0zm9jTz2i2UHryHryVMvvobeyFKnHhbTyr4S82OPglxRAi6LdLUdM+TgfFM4IzX7BO1h/KGnJkJaFrWCBy5C4X4a43q1bayfs0ZeBMJldT1PeMdJLHsIjiBFlCckoJEhBjnn0V41z8dfo/GV8VoJWgvREUzCAphqJjuOMgqIsUfSxQZeYN8RQx9nkgJ8v+IR9AETvczpfsrhaQPj4Y5lphykhNXWNVXGZ0MV82RHlAxdFmxTVCvbpzmoB5/0Z+qSMz7ngUEomImn+rw9/ogtMhYyXMb19GyXDqilo+2I2LtRj9aboJYu26BwWnJlbt36TowhYxXrqWpvg7njinRuyc24EaRmbTsAND2LRizpPrqXM6QeAXmheTL/7PspHhjAG5fWr+PczNGgnBAnTYOUqY//vH7i4Ltbqklllx3K9EPMGWWt3VyqSTIj9wZt4z9Vuxbcxt/F2Cz4S6F4oCR+6Y3c1bpkPCsZ9vCBe2tsv9/pI3QBiIkwFObx2jf1/uqN2dbciM8gr1hxC2dMswnUpldHryj6yMrPKLgjbx48D7sqwKZHn+o0jFQSRgwWtQVNuqJHUn6U+h9eVFOMbVfIl5RhcVxLICVTcf+CACNO11pREzwvNux+pOk2fh7y5nti3sTlkhStVwDN+O2JBrZBFqzyIixmZkyNUZOCgROTbxOGbS3VL/Yx4eY+APjrlPQJY0Zr+1LYE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(36906005)(4326008)(356005)(86362001)(6916009)(8676002)(5660300002)(54906003)(7636003)(316002)(2906002)(26005)(478600001)(186003)(966005)(70206006)(8936002)(336012)(426003)(82310400003)(70586007)(7416002)(108616005)(47076005)(82740400003)(36860700001)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:32:31.7015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 837961e3-e3c0-4de4-cbe2-08d94b614c90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3545
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 20:45:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.134-rc2-g5b0c31d40d77
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
