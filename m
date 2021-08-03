Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6E3DF0C5
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhHCOuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:32 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:64224
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236599AbhHCOub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lX/N9VIN1b+1jiPMPN47EDzMe5L5qxa8ucFwM2y1SLVX+R6Wh18lJQ79J0eGZxYRfegVXHDGFlj6F0c7k6hS0j1kEon+kHSZn1LinMtI9CNwPowxOEvQyvugilheloQjQAbE4N2YQm9BolZ/LprWuFW8+9SlvQ+3d6fTb0MtLx9z5QHRPxdORqCKsYOl+pbY9RXzBvpmjdNpa67HYWeKGx7SyZhihZeqk7EbbN0TZPp81Pl/KeGk7rb0nS04cOVWfeOfFvGFAFdSoZoHagIk3V8LXSd9rSJHVi6GYFfhpnx7q0aEw7ycTqZ7DYFGn4b+DNkal5avjG16QS4sBeBluA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fly+40zLuIVO6A1RsFXWv1XFox5u6FfnG2bLIakwsB0=;
 b=gj1D4OyhRpP3jFbndPdCPOhQMuhKfdhy+GzflX5Z9fSUJaXy1tFjc4mPFwHfrAJi7JrZaikqycA2UY4VKTo+GDB5XMgbHERR/EdDtJNV3ph34mcBka97NQtPev6fOkerLayjAY8XvVn7xQ2+97s9z8NwRVx26kdDtR0JJ3OQcdhIdkWkBpZRYkrnU8vTKsmkx6byML+emOftMPZgHrhgzR2Ij6VVfYl6QZOKZkZ+JIhAP6RyfjHVapLwJnIUGW3N81BX1ARaBJOgjVwD6lP24YhaopQvea+hvlyB5kVUQ9DzsiWz23GHKUB7dwJ4GhX2IbNj25ERvt2yIbwI5dQ76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fly+40zLuIVO6A1RsFXWv1XFox5u6FfnG2bLIakwsB0=;
 b=hPRV1s/kI4Fo/65QP7hT/9TaOo+gAcBgCJWac74tThOONkeSLOH3wNx8qAxZvySWpRdz48a1nkQT+ray+UDYM1gBeJaOrGwaLPPNpuDgDmG2XgWi3CuC8oQUIPNpi0V2fuWB3GtP/TjzY6EOL1v6JRf8Of8DWOXpKJhxe6zkhK1pOcvbYLQY5sjHOhOv6CnXx1vLN/aVozdD+7yzN6ZNY3RW1cHFW9NZF5PNzutcbso5uXFmH+hZCl7ZgT9PEfdyahrJ8yy2CEPS/SSvDDJeKqtv0W4I4h9khX/ushUv5wqEmBB14S0w75PmaKk3FdzZcCQmAXfVj7aTd+1Gzp5L1w==
Received: from MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23) by
 MWHPR12MB1583.namprd12.prod.outlook.com (2603:10b6:301:11::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Tue, 3 Aug 2021 14:50:16 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::13) by MW2PR16CA0010.outlook.office365.com
 (2603:10b6:907::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:15 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:13 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 07:50:12 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1322cf508ba445e39ff9fbf04ec14368@HQMAIL109.nvidia.com>
Date:   Tue, 3 Aug 2021 07:50:12 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b80f237-11be-4948-d2fb-08d9568e0149
X-MS-TrafficTypeDiagnostic: MWHPR12MB1583:
X-Microsoft-Antispam-PRVS: <MWHPR12MB15835C98F18525B9EB14056BD9F09@MWHPR12MB1583.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJSke/ZB6FieyKuMIRs3sRuBuC1vvv0OcA4e1HiDFh0K6j+TMzaQCm1rUn95bTfUE7fadmSHEEk502Ahq86xc3tMoJQIesOO0bzn1Pk846xThWc7qWoarfJAL5ebLgB48gz4LImdtokL3NRfCp08sroH2NE0xpSoxB1FFr+b7vOJKuVwA/Rskl82eu2bqYycDGxLspDbPo+jH202bvjdbnIL/ptFFZt7N2EVkBjo4VtwWwA1hXEll7nrfHwVEJRcK7RUlyQZWG+YuUdU96/HhqZbihdKt8LHoFSRoM1RNHmG/ACpt4Vf2HKaekoTfDNc52Fxfp9iMhVKaDQLNG8J2vAgH06K1s7uFbKpV8JRpwum5LR4n0g38O7CZJBaDZR6O2O6ax2Ci1D2YYlrWgHA3WEWPbEdpqUMUEHdO318fPEjq8GxVXvYvQfWoEprngPsx7j3VyDC5xv8E40czWsp5Y5CbXYthQ1GkMlXyhxVRrJU/5iqO2LIlVL6bEWHIRfa2l2sSjApwPm7fRAHcwNl0CLQGWoicMuWPwLX9ervi5pS8xP8W7JBuMWZ0pIYbL454SPIWGdBEhivwOfbm7xSPfAAyvnQwoXU4dR9mLwKHwP2P7bstbhc61He5oRXcnWbXoUwEB0cZ1rYlVR5NkS6z+fu5v+TOPRKKUy5npFEodIBTmq4/k2TsnYxkDts9kahC2FYmXurraBghycFdnahvHJgspC/VmHXLe+YxiGTC6E81uWhPyBSeJWPON5wR+Da5tG7YKlD3H/zluZsPEw2vSnfxBRjR+wnAbtOsdvFoVY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(86362001)(8676002)(356005)(336012)(4326008)(8936002)(82740400003)(7636003)(478600001)(966005)(5660300002)(36860700001)(54906003)(7416002)(70206006)(108616005)(316002)(36906005)(2906002)(70586007)(6916009)(426003)(82310400003)(186003)(26005)(24736004)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:15.5506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b80f237-11be-4948-d2fb-08d9568e0149
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1583
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56-rc1.gz
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

Linux version:	5.10.56-rc1-gf9063e43ccbb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
