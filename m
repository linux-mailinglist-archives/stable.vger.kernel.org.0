Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20C3FE2E3
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhIATWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:22:21 -0400
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:39232
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230486AbhIATWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJoAIJNGyA4RRG21Y/bOs8R+jOORJoMoOljFprf0gqwGR+zpT4tq2rxSq7JsELOMU/mXo3AcF4KJXESMUrPSJPVxvO0c2tQE3W2gC/OpOntG/rumP+s9GfNrW25o/E5Asha4z7KGzJXyNVanILCze2VbVPTOdGiiWJSAyWa9Z3luuqW8CZBGSRRKRjzhTf4VsC4J8VSEHgmmd2vUH9+aMMBuaj0Zl/jh3iAFkQ7cxos6QU+orVJOrkBRB25CTuqTpmPZsdxlD7oMmBd2+JlGHdw8udFAcPcS+jCk6FDawpGYhvlJqeqNMVrrOz5WQVfzAX7S7gA5xwIBj/Wc9ayg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+tGbdLSNsb/YYggfTJ4jG0tDvIlK7wluSPB1UiAm7Es=;
 b=GWN/hFPyH5Id+amNV0P1vklmZeltoso/2OjPI9dY7g/o918SHATkznQMougweE/fmhounlp+TEpiImUfLZFpMErzSif2jcpToI7evZl5bgSbsnrUxcE9SVH/V2aEp+pfIoIJyD4G2N8eF5eDrRAKe2dXCXAKi4UYL0BtgsjX8w7zvP/59rD3uaK9K8cXOaEPzOnIHn8z0nGhrzpojnGZIqdB4GA8zZG+niM5SKdswqJyKCctkDhMRLKIuZqZU+w+/OGsZYgtmCcrixltoiV+/66ZQOAEsp/IHhV9QS/5x+NVWU8CEOocCxYCPFHczbK6tQUeHCFhIbwc8Leu9KHzvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tGbdLSNsb/YYggfTJ4jG0tDvIlK7wluSPB1UiAm7Es=;
 b=YhIubwUKM2wJSASX3vctrNGx5hn4ei3vnq7BHiwk3lFAFHkdrnBfgCN0RlJb32CZ117nz7yKy3tuOfxikQG2+eIedT+Tu+U3vfnLLepMTzk9GCN8Oaj8A2i1rIm66aou0gMTS5rYrNaQpY1kMTiHeA5ZdS0tpClLG0Qc0keceuGhR3paL+qlX0gybzBwLAH2gI+tLEb4pUVASIuylDHBwda6lfJJoQ7EAocy0Qs+xfz1+WnJcPc8u1aG3VpTVmKzWLJGKCbvI0zVFhkpJJgN+z4ZQhQXwPGMMbNvIJE1/7X49BRmOeS3ACpefc763E1JenjuBEFlVfVKaF+tDmWWfw==
Received: from MW2PR16CA0018.namprd16.prod.outlook.com (2603:10b6:907::31) by
 MN2PR12MB4272.namprd12.prod.outlook.com (2603:10b6:208:1de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 1 Sep
 2021 19:21:22 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::6c) by MW2PR16CA0018.outlook.office365.com
 (2603:10b6:907::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:21:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:21:21 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:21:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0880a4838029408f92ff254bcde84615@HQMAIL111.nvidia.com>
Date:   Wed, 1 Sep 2021 19:21:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67e09fa3-a059-4c31-c967-08d96d7daed4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4272:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4272F7A7F80CD5505217CCAAD9CD9@MN2PR12MB4272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tyF9M47Xbr3sO+/9VqePx8BcLXFgB3v9AyOOdl6eZVzKJkYIdl92t5t/Stdx3iL6rfQ66+qrZcHtsxSlWpIOOx0+4FrjhOwZxycM/QjEyaDkMgGTdBi5OWahX5YdP7j5lA4Smk9PdNgvl46TzsF4ogwAaPdJ9MhZXPcMbiTDOd7XFGqZiYBi9isW4HjAxUO3ZkpP0MXx9YNkMVZik9rC2OPXnglFZ5KHL1ib9Gth2xmJ6DvinHijbf6P3kjUYHzquX6GHV+WGNQd/yLs97ERdmKgCeNcCVYOTnDBQqTeIMfUbhEQdNUZ0JnovAsO8VJBCxO17pFab+j+DrBoUoBYS5XKyCbh8stp0mUGraDpmqCgKvI11jMNqPRwtWJEvJsYcPgyI1dEUPIg7ZnukSODOmSpbb1yqWjFqx2mxzYxBQa+aAnt/l1fHI895VyyM2ETeuLjOKKPU79aYu6vKMqV3x7DNPmXZl2+iZOAO260lGvKglgXyQb6Dd8xH+tsG7yeR4zefO8EyDoRf6tUX7fs9wsRKWttApbbov5vQa8xq0Uzk8whQFkPk4o594oMCP3YzoNbZkLBxUj1Gy5KmTSHuLsq/0suSrT8hZKjRs0xZc8myIJqh4mcBLS599LwY6wZ1eO4U4RvVL8T+VtrmHsvXQj/A1mtwT50BywwC0LqlEKWu4INY24l8DNjFyZyOZq9PHhPYhMCgsPV0vZ/F1LpFAsUqnEo5drVQIlnfhlbHOkwuFZ4oAxQ4bZfsBMY/NK6COBoNbJCg7zixFa6c41ylCnOJc5mkPKYfJVlZqADiw0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(46966006)(36840700001)(82740400003)(426003)(478600001)(7636003)(6916009)(4326008)(86362001)(356005)(108616005)(5660300002)(24736004)(966005)(186003)(82310400003)(2906002)(26005)(8676002)(316002)(336012)(36906005)(36860700001)(54906003)(8936002)(7416002)(47076005)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:21:22.0046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e09fa3-a059-4c31-c967-08d96d7daed4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4272
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:27:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.144-rc1.gz
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

Linux version:	5.4.144-rc1-gfa7f9f53436e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
