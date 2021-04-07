Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2023566A0
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbhDGIWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:15 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:62209
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234140AbhDGIVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e48yAj1KvWmRFgBIzR6eaWnIDOj6AaR2sZSGSNHtrpJiKYadaTWoZs9jwHL8u5cir0AvSV5hrhU6MTkWy3BYm820Icg9hWklRt7ilQjy2YWptojGhhSb8u4M7Pd9s2u6R8+oZJQ7cJRnsPEsFYTMrNFWI4GYNYwTnBjU7kZmaS4VvGDmqkP1NxUF3SItF7yy25rTf/dM887z0xMPO8+te+eOb+4TgW8ztL7rX+uI4v6aMSW1ttSjYExrqMHRz8+JieBkex8i5nwzOa7DapbYJcKovC2e3vjm1ZbE+3oHBx5QzXlk30D5bEKJFfpkhKwS1Fbt++FFHOoPb7Um3FQW4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aA0i1/QDsLLIiRi4/u1dmMLdVvEDhvTzGjf4Pb4Oyx4=;
 b=EVirdT1q8u9X4xWj8osL1MqP5662jK+cbNHZeyLylKxirmnRpwjkQPiY/RMTqs/jlngmeBIsW3C4OZfRytHeHVn40AGWkV84NGJ8QVlmfX23NStqXlJV956Y8gYfaFy76jD2CXooAGCLbPRukXr63z9VsISX03301XvM9QB2wgYIc4XWQHsAUPIIWgQUAt93xnEt5IPMZjWbfx44UN0jq9SWC8/EEcY/LwdZ/7e13G+2cTbYZR+yo9axdC7BbFtrPIrJTYjyzdMj5WFKtVK94Z8nrbT8iYXcKBqUkAYBqjfFlQxdDmzXJat6QjV0kSPE26kq6t221ewGZHMlnWEVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aA0i1/QDsLLIiRi4/u1dmMLdVvEDhvTzGjf4Pb4Oyx4=;
 b=F27/5Yoi1d0bfWxXgY3ezLdXO5ksgmvwI8w1aFJLuU4FpXRyO0ppcv6tN1QbgZPZhzyuYlGzHoy4YdAXIlfQ/rptO+JZ3aNZ7x3UfUvkv6ARv9lGaVzM9kAR+5JQPE38qOHtZtwmoVUAfqCfydPKbauXgC8q7/HccSLhL9WDrsWlokHB6NSl7T+8ZS+MKrnVkUJ8r/uxiv8gdv6t4pJaLjq2BxILoE9N0YSacLu6Zljp9Mp8fQy0gf6zN2eeCVUoOfIYCa4+K/NOIJxqVWBEg/x1qVUGROXlv4UHB15BKk3gkuSWftTdj7NTHBXlRv4zAJquCtPQp3uPtPGFAeu0lA==
Received: from MWHPR13CA0041.namprd13.prod.outlook.com (2603:10b6:300:95::27)
 by SN1PR12MB2526.namprd12.prod.outlook.com (2603:10b6:802:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 7 Apr
 2021 08:21:39 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::58) by MWHPR13CA0041.outlook.office365.com
 (2603:10b6:300:95::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 08:21:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:21:38 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:38 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/152] 5.11.12-rc1 review
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <726a6daf64974eb3a27d4904785a7ad7@HQMAIL105.nvidia.com>
Date:   Wed, 7 Apr 2021 08:21:38 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e028690-5593-4384-14fc-08d8f99e2aa4
X-MS-TrafficTypeDiagnostic: SN1PR12MB2526:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2526D8F0A7903E0B48C91D42D9759@SN1PR12MB2526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8pAuSPInt9sQZqX0jPzTwdzR7hX1g6OqxydrRZXU6JjgKfbicl4vPmGpzT92Mhi9lksH1EbQ6A3KgmYAikdJK1PaCC3XN9UXenBFKiLxaGK+w58gODM6fd7LJKg2rSHwSYE7Qa1H+3lJRYCm0TD/oucfCnjp2AVFwON8o7wHjQ2uuiVugDCTrggeKp+HCAdIc5aq8H9tNGOomybB1t/a/bTYxkW7u3QwYVaWEQ5+/4/dS6yVEucbgRZgFWaK+8RE+qHrVLIu6jY9nVsX2ITVIX/u+Uq9vopNvycXRTuVL8ZzeN6ncfMGfjksTBp2AeFZJoZj+tQnMmV4nJkyS0s38XQJ25+XWbhp9Abhr7sVs1NM6YnPDfI3ADJsF2rIODqV8jAgFtcz3I+Mojn37ZVdwwa0MScvWIBki1Teo0+0hQL9d81y4BRqr3A+pDfBxYw/mCNMub2p90aCEkU84OzhMRT7I9mkskr2U2ojTiyAJpkmWTO3atduKpEdGsnfvDHzOm3hdzL7rVqdS4QWLWYrtdaahB4kgPOBY+78gFh/pGqx6mUbd1vOXirLKpjqBZx3632OfaLn+wfUdx7yXYQejNFkDtSAEp7zl9404p1XkJ9A9DTELxxFVXo28nXM6HISVaNT+7PMpMUwuW86rdIoaIgynEpn7FK6+KgIkQdfY7BFH9ySeIWtulIuLrDUpl0GnkLKFAs3aRg3snjVPwTSuEIzQZrdUQSG6mYJwBRFUk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(36860700001)(6916009)(426003)(70206006)(7636003)(82740400003)(8936002)(2906002)(70586007)(5660300002)(54906003)(336012)(108616005)(82310400003)(86362001)(478600001)(7416002)(966005)(47076005)(26005)(356005)(186003)(36906005)(8676002)(316002)(24736004)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:38.7191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e028690-5593-4384-14fc-08d8f99e2aa4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2526
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:52:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.12-rc1.gz
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

Linux version:	5.11.12-rc1-g74f1df301624
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
