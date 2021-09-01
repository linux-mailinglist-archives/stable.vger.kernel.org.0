Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4421F3FE2F9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhIATZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:25:42 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:26977
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231146AbhIATZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:25:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb7RTkQNYf3HLyhdQhOd26Z58ll6cgkjUdr8fou6Ulq8HaHzAdmsLF+l38NsBjXONg63vcbkkg+zCDc/M2ixKiZd9qNJeY7I44gLne4crXGSeZhW784HouT0Jc6WfXTIrXx8406XSckhL6oHyo1/h0Xz4hgjniv2eEhYJYvPReJOINTyBHpVlRy6SuitMHILo0Uz6ZWLX8KWQTksU2m+snPElzBc6FZzDoNrLgmUQ1+wDsJWR2vdAt/RsX0ZSVFQicNzLM78M9zpW2szcHaP6Qwy0Zfst+WlscYWxo4h8fVqMsBHrDxuj5IBR9FTQAXwjIygM98UIj9guTJNJLj9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=livfvoyO2dQYsQz5ZH7ScdoAgmopnAL7GT7Hs6h2hig=;
 b=jofetzV6JAmFIYUCfkckJud5+3sdmIZ7CcYq8SlRGHHQpTg5eXtWdEvih3fbTcwcvKWqS98MqMtaYB6eOq4UKLlJDo4LiTcy/n3C2ZRyAAZJgL4NyZI9cfvqWRmKFGJNLASLmI9jnAdFPwkNmCp0LTFRLlUvagOOsOCHvJ/e8UrCNg0Cs9r1Uxz4lnW5RwyCMqRXzAWHTlN7yJ1E4GNC/xrrB1CIJ52f2HLd3OmOm8s4N4+OTUfMMlkN6rorhQEvYmuQ7WuKFcaLH9ff3GHRuRH9wb+5hEiQQHRtyhbd45JKQe9vzzNzgs+ktMPkm+zDS2qaKhil9Y0bkkMOwZaIyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=livfvoyO2dQYsQz5ZH7ScdoAgmopnAL7GT7Hs6h2hig=;
 b=sg30nhKG3GAFuUkfDwiI4poJTWkDLJLqRMx3hAjvybRapEJrZgZHrMmLndx0tP7l2Mx5ISIB96Ne9U67ySgxMfHiWDiLiuAnREnOA3IjF/7d+u3n6MSegE88Jzlae1o5gvWBTdQZ0OD4tzEgkPAFAosknKTReMKdC3oDrCPv90pz7mLditWhfArMAlqkc+eg/hfRkKjPIVzzJy+z6y6C2WMzdCAKC3rnuyYhzfhc5z2eiL5zo9JDqkeI4kZYv1iWc/eM4nwDa8qZls88BDTYoQ0Q5DfznUxouBqq27U02gI/luU6bAO1r0rZb8NW1QM3oa6g8n0KWW0GOTNqY7cxsA==
Received: from DM5PR2201CA0021.namprd22.prod.outlook.com (2603:10b6:4:14::31)
 by BL0PR12MB2499.namprd12.prod.outlook.com (2603:10b6:207:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Wed, 1 Sep
 2021 19:24:43 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::89) by DM5PR2201CA0021.outlook.office365.com
 (2603:10b6:4:14::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:24:43 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:24:42 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.14 00/11] 5.14.1-rc1 review
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
References: <20210901122249.520249736@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6d2654db510141d3a1935254ac7d88cf@HQMAIL107.nvidia.com>
Date:   Wed, 1 Sep 2021 19:24:42 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 891115da-6264-4aef-9670-08d96d7e26b6
X-MS-TrafficTypeDiagnostic: BL0PR12MB2499:
X-Microsoft-Antispam-PRVS: <BL0PR12MB24996CD30D8B2E2D74DB8A76D9CD9@BL0PR12MB2499.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuG2Vz5ChssRdURSBq8hzQMfygBlmKfSOEGL+LVEMae6UUVThuetXEkJYDnL3YExroJqsD5oGlzXt8gxs6pNPzXCxcCk1pyDGSBnJLokrp/DeyyL6ARCFwH/nVwMr8gerhxx3ZHy8mJ/zwddcKAgTND8WL0PN3cAkT5wf2/YpfXIa/owSUI93PvgKhXv+WM8wL9zGx1ibuStfMyQAfNsfz/OGrZeuf9OiGD2QTo+qQO5cPcEFw/YsVtTL727X9qT5n6zuH/yfucoUnooqLnD8DfuuJlg6GXSRa10dCg8wQLMZh79HYDsxxPHAZ1xzV+XmhXzv1QF+0eG6IdkRt5CBO6nn61K/HtnYvjXkg16maZujVnL99N4ZkSfUSIbnHXP1xIOcCJaSY3fgTN5xb6gk+Ve9Q12oDD27UpZPih4QGI1KFP/TeNR/ZuRoP+gDmEA13rogMl0SaRo7LFTUWLNwavzEp6xYFmp/DhJt+Ate1fLcMT0t03uCI+a1njOPQ4ioTH5qZ8N2ES63ObwXtIBCj95OWrYHY5VCJnlT/G3HnX6jjx4mHVYp/e48RX243SG/Ootq5QykjkGdOAqlluEr1/ncIq3AMzdGa6kZjimqkfzRB88Y5ZB1vdYcxNxIhBbooEdbAA6hjJt697Hx6aFQ5U7KMPKWz6LGjfH0wWyBRAZHznPx0Jdx84MCs/cEAHgb4JrOdKKv46KEuUjCmNH6kiI7s/mgHKV7mOds9/4bAGDImPYiquwrjyGSuiRGgA1qf7xsHN1bHguudLdEPzFg56dNfo2KwcgDqNj2XqfHY8=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(36840700001)(46966006)(478600001)(70206006)(54906003)(7636003)(47076005)(70586007)(336012)(108616005)(24736004)(6916009)(426003)(2906002)(8676002)(356005)(36860700001)(82740400003)(316002)(5660300002)(36906005)(966005)(186003)(7416002)(26005)(86362001)(82310400003)(8936002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:24:43.1293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 891115da-6264-4aef-9670-08d96d7e26b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2499
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:29:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.14.1-rc1-g95dc72bb9c03
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
