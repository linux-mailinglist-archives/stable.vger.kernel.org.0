Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8C3AA37D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhFPSvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:51:13 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:58593
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231942AbhFPSvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 14:51:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/k3pnjIH+wmuIntfbqMFXyK6nY8nRKaZPspULqvGzPQhpjHKaEr+LvsKBKMouZpKXAOmkWeF8MrtYZn0ZgIVJxLKJDLSg3x+0zUoRTRP8cHCFxEo9NaKbUkKXkzjPE/9FmbDjqciXUxVO/B/ngu4Rk0IkPjtkHFcNJrjFBJ4ZNqRnZyhY0fYdav/jWvoInpsgWLH+oG7w3CINQeeGOI3x3U//0UIAloxUY4TxmxJTdtL048MYIYX4DH2Uz/M1WltmaU8OvhDHLPkeUV6Z1bLqSnl/XjFH6kP0VUoW2ghFggBPw73PUYcka5iF/08gu9Tcm0XY0xf9tDg+KG8pSFew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Arubd1M1Fg5TsKdwVls4pzxeytppUy81FKuWDW+1TRQ=;
 b=EIgqJBohLBM3vIhJnzs9QzJOS6HYuvYb/MAg2Rb7mLqEMhZovFzOqSzqigbeqotrjBBtbqSIIziOEkAk8KGZb8MnuYe10xhw/vpnvVqt87LWfzYN1Zu6dyKbPU3nrbHCnZ8SAY+S/a0a4iK0eMY+reusbx9F866lSIKIairjSZd3okL0qtFdmgwgfeP2IEs5u9oUh1WyCuy7wxI5lNRJTj7b7uW4VhyPmr03uZJ2LxCQcqM/KFLI1Tr4ZGjyE4VRuF7Yx0C+Hph8w0q7oeMWeCYsm1toORYLz0yOGuo0/F4Us7/iVkKRYq6KQvkA+X4uOm3K7d58TNzdE/FsjUtVrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Arubd1M1Fg5TsKdwVls4pzxeytppUy81FKuWDW+1TRQ=;
 b=HIgOJTIABNK388DT3Ud51XSMC4WHIbprc3Qd9jsWgY1wmyXfSUk81/om6h7V/gw35d+jd8B151nq4pysRK50ixKE44F0fR15tDZdppJ7LDEdGJjGKo4PNjYCbvQIibyXWWuQv/5wS5UD5MPu92TW+5ObWlKTrofR/Kh79VImTFB7/uAhwvA/jQlgAbndXgv5htXGC5XKXVjGh8/hE7FG91mZ7ZJy3tV6A9wyDdbB5Uf6PnDD873csTDUKY+DrWE8BpLxzRtannTd7QQBpX8eemFx4DtNnxahsEfIkCiWBquFn8VCsqbbW/vSsrIO0JRKsMnjbAB1wfRF1Naczj7TCA==
Received: from MWHPR04CA0039.namprd04.prod.outlook.com (2603:10b6:300:ee::25)
 by MWHPR12MB1183.namprd12.prod.outlook.com (2603:10b6:300:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Wed, 16 Jun
 2021 18:49:04 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::5a) by MWHPR04CA0039.outlook.office365.com
 (2603:10b6:300:ee::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Wed, 16 Jun 2021 18:49:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 18:49:04 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 18:49:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 18:49:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/28] 5.4.127-rc1 review
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6b1a98a846d84cc191200ebac1995dee@HQMAIL111.nvidia.com>
Date:   Wed, 16 Jun 2021 18:49:04 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7b84f6d-f60c-4827-1686-08d930f76a3f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1183:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1183CC7418F6AEC32AA76C16D90F9@MWHPR12MB1183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L08Oiqwml9KjZv4CEiJSTCYla4I4q1OQeKRmwaT0jCGQ0DhFghjjl4pddh1t7xYXWPVoXySeQNDDutnNuXuAIyvAFzw+Y83zKaz/PDfJ2eaBF8GXe3wkB9Jsk+dLeGiMVGYgD3kLhMfczUnPXkT4eU6aZskuffVNFNTP7dxObGlYqpkUYe/ub8WtKyZl7zdVvOpKLXb6/lnamM1DRMLWDbTN8WRvINWBVfs/FHp6RCoIhoKC1TqFBiAm9JYx0EsM2y+COmUpN65z57bkGZQL+fEJbQW+NpBj3hxf0Iay0nrNbViWGZoIK+ocDcCGMcDt5iztjqMtL3jjCKcXnQmYbU+6i6yeJAGckvNpTgbtj0nZmmE3GrVOtJHQBVAPxqYMIvJoanyGGEjQNAQ2ezlncRhlyoieHCcFhZ5Vu8GvW6TSLWUYHDpt+8rzWh7lEQrVvsC6ecL3daC7k7qZF7IEssFP4CFO4s41PNLDYxMqrE9VyoF3nOgBXhuVzNy8CjAq8EzQQQt7eaRzQfvM7apBMfmi5vz0Zb4hDkjcDZJ2Cb/6zzkJcvs2/zfaotMHyfAYg+Yiv5NrHjej4LNFE3O8QSK6xobs8erB2f2VMp/Qcf274DYJOYGoLaJV6Na28NRzq1AnI0zIDhZOyjG8WU2fbAc+jtbPYF6vUtLrq8p3S5SZRCQyqL7NuWYfHRUuU2VxxnWx2npRpT2l8cnxfKsWzLXh2dQMSskhF4ZaUPfyjErBK8bRs3r1NjgWfnZce7cYMVPrJ+z3K/BXIA4mGJtgtw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(186003)(4326008)(8936002)(70586007)(336012)(36906005)(7416002)(316002)(70206006)(54906003)(82310400003)(82740400003)(966005)(86362001)(426003)(5660300002)(2906002)(36860700001)(108616005)(24736004)(8676002)(6916009)(26005)(356005)(7636003)(47076005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 18:49:04.6101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b84f6d-f60c-4827-1686-08d930f76a3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1183
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Jun 2021 17:33:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.127-rc1.gz
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
    59 tests:	59 pass, 0 fail

Linux version:	5.4.127-rc1-g4e778e863160
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
