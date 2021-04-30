Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B573D370039
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhD3SL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:11:56 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:48865
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229750AbhD3SLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 14:11:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9mqvY1sRJBZpQgBpeWzXRZr2eyadg8aP5esFFAWr1SrRXL+gueuFDtBoTJIoh9JZ0YMVzGyMbIcO7ROTZz61ZSy2Of6c5UlfGQiZwtsamXgrr3GZ6GdDEk4rX+H/47U0QcaXxq5LT05pecBqGrA1Lq+I740KniwFkHNcexHMzOG9JTItil4aH0ViHGxBUYdGNCY51CMh+5n61DX9UuPsuq30WpdJ1H9mq/AP2vwlbeAJF85K4EnuBPSug6XAPkJNVH868IIXnghxrTmiKPLoh67aWHRgka6H6cBepD95eQAXWq/uZbikTEp5LlJg7Aiagw2jTaK2eGXEahO9NyZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFTJ/vm7KxT53NkUi9l+WKbq11Hm/GTtUZ+5ClzmDFo=;
 b=M+hXAn40ZR7caz3w0yOMk6R0SBvQe+R2on0F1mQwZBax89Nb1UmvLEX91eXuKWk0ZraV38wiOnZOUsKttpC1G/RwW6Th0xlDR9VB/zgxmivXx6gJ/6JC17IA0+BriIFbGC3uLphPOQFP+6wGatDV5eEBORGwXLBVMjhIN1ZnASEodbQ2MS1yoTwDwX69cswQGWUz/hCSdau5aomShi22XXUh1RQFYnxrBHOcdngWykuAsR4Bz4ecwJeX7KOFvLHoXcKERTtffHbTeh0jojtdcZlkR1GVK5UV1oEdfTdVe5dz2I+HCdfnwq8e9I8Ot+48lzwc++z/Cj+tPACai/jlkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFTJ/vm7KxT53NkUi9l+WKbq11Hm/GTtUZ+5ClzmDFo=;
 b=maeOmozjV410IKPZk9GRJZ76Ecmxv8yvvlfhBWmrAUu/HKFpjzl/FyRXvvZDtupgyNYpPgyAdptZ/oZPdIyg1f78d5rmjgroRrUSBhMRpOZOK3n3FX7gL3Vs1El9jKj2XxYynCMSXcgtdNuPdoIcCtXqL53E8mFduuyNJ/Upe1d7U3CtybRtzNQ17SkWHLr6Ki7Kd/S88OknFA+KyVAfH0z6gVXKt7ZriOZxgieH2RHHgUx4yKZ06r/pEe6h4hFHvlfOJ++MhHNHEu65+nOfLa6OunEQI9x8FpJmYG8Onc6TLj6FYj7nEmixWEn6GAR5CkO4srZQo0QALIvJ4b43fw==
Received: from DM5PR05CA0019.namprd05.prod.outlook.com (2603:10b6:3:d4::29) by
 DM5PR12MB2584.namprd12.prod.outlook.com (2603:10b6:4:b0::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Fri, 30 Apr 2021 18:11:05 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::87) by DM5PR05CA0019.outlook.office365.com
 (2603:10b6:3:d4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.11 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.32 via Frontend Transport; Fri, 30 Apr 2021 18:11:04 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Apr
 2021 18:11:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 30 Apr 2021 18:11:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 0/3] 5.11.18-rc1 review
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
References: <20210430141910.693887691@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <89708897f2b94a1eaf15a8644eb4de83@HQMAIL101.nvidia.com>
Date:   Fri, 30 Apr 2021 18:11:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bdf9d27-45e8-44d6-281f-08d90c035209
X-MS-TrafficTypeDiagnostic: DM5PR12MB2584:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2584758351E24C63AB9C3545D95E9@DM5PR12MB2584.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atayh2nMZPkVyO3mlEZbmbqf6MERc6YXW+Hs/rKquuF4K9zQN9h3ep175wO2ktAdUSWQRo3/++TwNefzFf8fJ4chrAQ6JYXHTAdz7T6iYYua1kANVes0uU5vr7dW0hXc16C1/JMsvDCKzIVSBnEVfK32fxtS7YgHGbUjfWkjZiCPwDieHKxR6RAx4lv8/JnFWDsjSwt0Nk+p22lF/vaqv3h1sGToWggTEkrjR4iQM4K3x0QJV5wvL9dVIFkE1FC8inYXxbiXnanmW8R22igTsry4Vc6JAyDrG2LU/4+BczsAeN2hEo13MgX1tpOGKR1IXAb/c55qybNiBfSHMSI79esjQo5cE0+PtVXKL08+qjIlBCbxZRt/JyeHOgTXIWGb+BsgxFvfAuApswxNgiVGAlc4OyZ3w6dRRTD3yKKjhdw9NuGk3NUCfnC5RtzdJ7VgG+IHszixUyJrVfzWaRURQV6NMbuIABuD0wiapNkXOCDaepnp/kJ1GtfFHh/jnT/qYbXFbxjvJf4r2qqoh9d2EWy8YmcVudzZlk4joq9+52H/xvhGKKigmPxGuZoX3i7hAASw7Ai5iZXTgaEWx/h3Px8MH2W2CLZ9tAgEoM/vKUU4gJgmoboj0N0XQf1A5lendVFxyaFvd8P+nHDi6OcHFV0l4eqIHm+yqAYEa/lAYik2sTKHfZp+McB/D06ITlKbz561tCcVsVSMBgPw/ECFu/YaQMNsOO2TU1LEoEVccQ0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(26005)(47076005)(4326008)(966005)(6916009)(36860700001)(426003)(8676002)(186003)(7416002)(8936002)(54906003)(82310400003)(336012)(86362001)(24736004)(478600001)(36906005)(356005)(70586007)(5660300002)(82740400003)(7636003)(70206006)(2906002)(316002)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 18:11:04.9303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bdf9d27-45e8-44d6-281f-08d90c035209
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2584
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Apr 2021 16:20:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.18 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.11.18-rc1-g517c2bbecb70
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
