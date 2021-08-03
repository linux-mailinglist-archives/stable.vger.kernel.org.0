Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0990F3DF0C1
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhHCOu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:29 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:10049
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236638AbhHCOu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtTe/Hgwup53raxRxB6aZYbg3gi6uwLrlsCCfhUaw4BvST0GnzfuT8EXZeZHa8QccqLq76lk4xhsFXXZyhoWijNZz0DVqQT5jdLiiYJLxL9ywmx2y+VAujN/yBGXrg1U8J6lKAc5VInKpbkR7x3cXgnJL3pP2W+Uo1mGc0CBK+yf/QJVKKBcCLjZieZX25wDF98wlri3jm26CyHDPW30fQsMvpE6LzU+Jnt42+nqgTJmp1SQHyyCtRKhU71PV+yzjpvm9wgclNmgiH4K4QiMbHpVZ4N7b/AO2Ix8qTsQREbbrBEq+CMvfrNIa+ikpva/mpWKZQexjmRncMtbWe3DOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/oWhOH5080xvIPgOu0pSsQvW3xtt6YNC8kcMITl4+U=;
 b=lqAqUfxoilhIfRp2h1erEd+2fQ9qgwNKiAf/amCc4vzyLIuzHIUvpc9Ul4X25zycig9IOP+kcEQXPuIbx1SJQh+qFWUD+yMIfwZUwf3ncT0oK+HwLVLxldfwrq5onBoMl4t6ItpmgVL6vNgtCxBE0H1izkcT7oU/9L2t/Lzvhy1k6sbMMw+g6/A6XkBoVKrilbDcG1thWYOYgXjz7XWq60iq+r+bdncTKknVOHTsMF+KobVg71d68uudoMRL62BqUBqAgSPzoIHSD1t79+AuWHyQQ1hmn5z/v4EuPretAsNSXxDBkStaxsZKSWDwOzz4myJatDPlbxjy6OdUS1BXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/oWhOH5080xvIPgOu0pSsQvW3xtt6YNC8kcMITl4+U=;
 b=I3plLrtUpf0pi2oEounA/UrcJbygTdOYwOi9c64SSM9r+iDNKUzNA1wThRWPxpJBmhovrfvjx1Kin3oMoH7dfU7Kvcxa+qp05f65F0grLWaLTndhafIEJthO/xEM99ejk/iSTF1ot+UqYQye43EDvTIJG1Eb1T11dbVVozCBda2ImXS/q6I+LYS7SgBeFxRo0vDK3LxZWzJtIujePUKs5EgA2ovp0GJ8XGDzVMDhEk41UdTieEUtKTWgS7TpINrqxSUL864YHFToFUsu8o80a7bBxWJWKAdmbXGVdeQi/Np5gbq2JoHnjl4IFPNidkekA8RjpbKRfn1dqc+0ZH487w==
Received: from BN9PR03CA0860.namprd03.prod.outlook.com (2603:10b6:408:13d::25)
 by BN6PR1201MB0242.namprd12.prod.outlook.com (2603:10b6:405:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 14:50:15 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::8f) by BN9PR03CA0860.outlook.office365.com
 (2603:10b6:408:13d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:14 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 07:50:14 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/40] 5.4.138-rc1 review
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <32e2c383676e423d8fca6e2ec5ecfea8@HQMAIL109.nvidia.com>
Date:   Tue, 3 Aug 2021 07:50:14 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75f60062-a4e9-4fc9-d74a-08d9568e00e2
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0242:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB02426ADF01613B0CCBA71069D9F09@BN6PR1201MB0242.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3C44Yo9UQMntLRWgTiZaHhcI1VQaxxM5MnxYOaDGRdvaVEZydT3GVl3vBmulNoOesrrY15Oy6CC6EQvUXhMmrns9lOVA1m2tsP5DwF2F9fPqXApi4k6ZzQSxeh5q8k7FmpVRPMhA8H89fZpvYR69Vyw6eyLRJeoV5yDnebE9wndO5mcKNyPVNagzcvc57QG0z7mxpCxl2jl7ONLkCzfugFXJI0ho4jOsHuD2s5QGY+xRwCDo9fdCW+P209T/KaQeke34HZir+AttI1eYu0beY5vKPgBF9OMuHUTqTjjvWMKKANpqpGJO+k61Byzk5qhHq1zBOlmBhbCj37Lfg8KHmqGBoLKhBbOdwpuCX3fzn7MshC7rryG7XJaz3uflThe3zWPuOEJjR46rBwI1aUtQYEldntGsi1LFjo5OYP7He6gKdmAQOeQCMNbPWpi9CWabiKjirW3wCFcb9rZf7v9ARH+U52sVB8n83onZwEkmF0SivQEPO84Dd8Jh2CBiIq0nbWcvs5swVtS8IZyNjGD9wEIALINX/xk6cwUv62olGHb1JT3iKPdV2b5WyN71PP5kqW6HMnITHz0g4OgeZQO84LShtB8ZshsMBQ+r4sz/6JV3wWX9jd257+9OQCUw9s6f6ZsGY389nEC4lgb/gHutpG8nAq3F89P20QqxjanFNO5FFvIZXkp4fYi7Oa0NXLxZ86TpEaQ93FAutimoGvByw4Lav8YQTaBg6xb3qHxvXLsl4kU7PgP6QOuKdk6fdDTx/o8NxuCykVAKuAxX6fD4407+I/EPXWx2NZGSeA0xbIs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(6916009)(8936002)(70586007)(7636003)(70206006)(86362001)(36906005)(426003)(54906003)(316002)(7416002)(82310400003)(36860700001)(4326008)(24736004)(2906002)(356005)(47076005)(108616005)(336012)(966005)(186003)(8676002)(508600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:14.8217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f60062-a4e9-4fc9-d74a-08d9568e00e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0242
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.138 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.138-rc1.gz
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

Linux version:	5.4.138-rc1-g6049e03b1cec
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
