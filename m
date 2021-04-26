Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDA736B3C1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZNFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:17 -0400
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:59872
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhDZNFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcZFPffHBEK2yaWkn4Bu4uWfKdyiF2OJZfqgLDmydNzO2TBWPfwiBmvhyMlHttFLb+kxcpKv9Yz2ZjfxljdyEZfXyXwCSNviPwSUeQeGaZdLz7zo8/llzzP9nkOmjEEeuQcV2cvH7wHwQnYUZFo7KTcdXIbIXWi51j7Tm5JrRH+M90qxu8CrlwLxLa+zLu96qGUnvOfbfa4qoopHQCNz9xrJ7tnXJskAYdQzIfcPjeyTc8sYOb+XaPf57b1LUnQj38kTaaLuFTC/w30TnDoDLgBrhaw31//zRXSnj4IEvZRbRlbxjkA3N7Ucb4s9FPpoN3qRZ/7wDLej5GVIRUfAzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcpoDjJ3zsrbKcPTpCi3v989q27rAbVQ4yWAnSWVZHs=;
 b=IE8AgRrpsbDDnhLUxn5MlBaoK+0MRICOE5CJSJ3UD49y8tezKB506X5ghEmha+YeBngBt+zBUiq/5C0N+O2fdMSLAyS+L4ZiyFHRMUtEgX5ygF4opE7AEEuT4LoaprptvwpbuGgFitEnoWdFWG2gafd8FN/jA/p7stPw2xSYdU87cEac2OKOPeL80fFhOf1U+CQQvDMSlU9xTIcULFWcTp1THDx8haMgn01C5dp9U/ivCFOgH4aIaqf4ruULn6lDjQDVzk9VG9dTp5MF2wgEAbZC5EBXBJVpFMxhHz6db040TWguJeaJ5xQ9vO0b1zLK5R25TKM/qUniWG+VXWo5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcpoDjJ3zsrbKcPTpCi3v989q27rAbVQ4yWAnSWVZHs=;
 b=d7UcMDXGIopU5+g5moFJtP8lkP+TapDCap/S+oPxSWY92mD+KibvPO9EhsaLrvU/Y2jkwpfZsl7GkHbLbmOLvIJgcuZT+V1WMcZ6SKBLlwurOsZ3FiQTOg8JBkyMKSgdF7TJ2ZFYPYetCKzzJadl7cTv2JkAF2D8YaiLohlwbYZ08IxTZfWgLTtWrChx2DftW2fMEk0YpN9qqHO8K+khmoHWR2ckmcvEtzH7wpQBQngFtzmTvZjMfG5Xo2Dw7sEG5BnSqKkje827LLaHOwOIQGQewv8bLNFn9Z4hI3XChtxQZJHCRbmtPUkeZozc2XgyeovSNryDjJejfp7AMFZ24A==
Received: from BN9PR03CA0173.namprd03.prod.outlook.com (2603:10b6:408:f4::28)
 by BL0PR12MB2563.namprd12.prod.outlook.com (2603:10b6:207:4b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 13:04:33 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::9e) by BN9PR03CA0173.outlook.office365.com
 (2603:10b6:408:f4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:26 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <fc49ac5bf3a64f39834f62218cd1725a@HQMAIL101.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:26 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d31f4b-7df1-460d-1bc8-08d908b3d65e
X-MS-TrafficTypeDiagnostic: BL0PR12MB2563:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2563122286EF53A2E6881879D9429@BL0PR12MB2563.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRBsA7y8n1ciIHohl0zx+8qxzteMEZ1oV1OViri2xVJ9fzx3A1hflUfHlSPSGKsASEMkPvyZ3iysFCzb6krxfvLFNgWEj891QhMZXOA7eElbWcKqLzmwViuPL5QJzYDEPkkQvK4fAzhhue5DEQ5HgxcWEK0aEP/AholVHpkB3U43/2oLGpQMTvb1yqLTg8QuhMNqpFOsm+BdRO/QeMaktjecURYKj6eHDJ+TZUqlrJtU0zXc5PfVOWj4pUR7rBuhGlsyzwH/akAWV2LkZpp1wPc+yJ5YQgMMoTRJSQNuVs0bbGOiRDO+6rXRgyuOyNvwvXXO93GFtIsMZERZaF0QoE0Fdr3g3+6aZlxeDgOln5Yrvm/AN3CfTziKDPT9nFi7RnLYHG4DUjrmzqx4kEgrPrZT81MABuFzW/xkBAiz1s1ydPcfFSyyql72aN45PO7QgMCC5e5xedNr4+B8PB/gC7s5OlqoNWajGstxg+RB07yaUJ21mw0YibWaJU/U0t+EnyTZ5pw9x4GRI7lqztm5KTGtrW/qhCfAna9tX/ktkjop4qrYFRCxFFWZHGq4bVRZteeeR0VClm54bpV/Ja5G3owUcdgs7limJsSc9QzZY8qVsDODq+M88tq1jeKlXUYte+YyvbwLOwh26jMfL5pLHsYnG2Pq2jcFiMp/ezjdO/W01FaicecTSQbyVY6MQE7EhRNxFZutVAtG8MfgFLoQDO9UFG5DHm2oa2OX7ANES5c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(4326008)(7416002)(47076005)(478600001)(966005)(336012)(8936002)(6916009)(54906003)(426003)(70586007)(8676002)(26005)(24736004)(108616005)(36860700001)(316002)(186003)(36906005)(7636003)(356005)(70206006)(82740400003)(82310400003)(5660300002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:33.6236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d31f4b-7df1-460d-1bc8-08d908b3d65e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2563
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:29:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.33-rc1.gz
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

Linux version:	5.10.33-rc1-gf52b4f86deb4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
