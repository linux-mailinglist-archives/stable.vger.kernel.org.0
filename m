Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9D93AA381
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhFPSvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:51:16 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:61536
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231942AbhFPSvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 14:51:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRSr664/JMP2vN0b/5M+7vi9MzIKwlEP0WleTFdXNqP0gHi0HnrTri2JcfENlc68gG+iZgweqXroXMROhLNJoREa8EwHkhooa+zDtTGSmSGznEvqHG2nHiZNq09SvOHG4Oz9fKC82nUiUrbnNjZwn1WDMAIk0xMv5BkJFN1l6VQyVFS6mCx6tgyaIO6wcuBlqX1vLQMOg4q3m1+9MOzZC+6wTr81rSYYXEDHeGOrEoGOxDMAAyOAhdTz+Shdw/esgboKGfSNYzeEiQaN/YlQ6PZt8BQ48s3FQLEokZI8d2C4oTJmXGlOkpXFkw12ceIFBKHX1JeT0qA/a5mGdGRHmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+V0L61YcbBwijxnUDYcN5JkpuqxsO6oj7TAt9kHy4g=;
 b=AhJMyHtjW+EKPUrlzPAdND450n+Rukp/3qeS7MIl2GS4bNhiQDoy0DInNNvHd8islcXI1o1ljVnJbCHty8IcYeHuxxwXnGC7LfgKx10GgZ5FoPE3qr9botsFOWrJfCE7ITAwrMqoxQcZvo7DZTI2iNpfItnmrQWgtm44U1/I+Eeu1rMvY7v4HAN8raWBnM9q3kwpcQ5AwyRmZkp5038pQogX7yedwzkaxupLiovoqfrmJ8lfL6MGylrSyDp02/0Qh8Py3SFeC9UnKBpBVwEXZ47z3Sxk7ievhkWCr8/uOEWGAFFKJZY2Hg03uHW8Adb51ZY7kOp9qRCAq+3DzSQnvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+V0L61YcbBwijxnUDYcN5JkpuqxsO6oj7TAt9kHy4g=;
 b=RR2anZtYKjCUuxLcNT92N1kRAE56+YxK4I+CZBDAxl0+clZbyjzV3Y846GBUpviAmlY2K/3YCiQl/uZ5rf+rBx1PjYIRixbozxquN/UDewLUQHmvE6kv0cKvRCzWCdS/x9Wj/AWsl7UqRBvs04gYD8DB1rurbIuutX4z85qjSrjewgwlnxTpaRakSMIE5AfxW2tM0EamRYU6itedi+eNIzb93QzgRr50sTqesCA6xMx0aTMw016n8h/lMSITV8P49IjfzupJ6wsgItgr9b2Oeo43rFThju0Y/XNeIRQX6MJd43KW0L9Lom4L+0ByuFjymS8WNKjvNSlaMD1FRoG5Tg==
Received: from BN9PR03CA0540.namprd03.prod.outlook.com (2603:10b6:408:131::35)
 by MWHPR12MB1742.namprd12.prod.outlook.com (2603:10b6:300:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 18:49:07 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::17) by BN9PR03CA0540.outlook.office365.com
 (2603:10b6:408:131::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend
 Transport; Wed, 16 Jun 2021 18:49:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 18:49:06 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 11:49:05 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 11:49:05 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 00/48] 5.12.12-rc1 review
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4fecf44a9f7745be9022c65c61ab08dc@HQMAIL109.nvidia.com>
Date:   Wed, 16 Jun 2021 11:49:05 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f91ed9b-965b-46b3-e777-08d930f76b7b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1742:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1742A8B86D9F23A821ABFCD6D90F9@MWHPR12MB1742.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zs3uT1ov/pKrqHYXlat98IAb9BIgPx7t0rDLmZrwRn3oqN9Fp33Bg9EZw5T67vKioIbYAr9p+ozwufsbWOq9/YPZGnBSiuiXs/rOe33W34B/yTWnKjFOK7HhZ65R1NAEnvCZNbgc6aLbCjaaC6jOQNlslg7VrwPaERypWJuLqtEgOQYItyP3rIAf8RWpyPfB1OCkjedzehf/Ukc6G1ND+xHJ5XL81K2Shdj0GQEGKa8Sf93zprG9teQLoFAB1iAjjnGiXEn1bywxIoJOPitSWY3Yyz5Utmm4sFdT6/isA2bqgqZBu5a8PXkJKwWi+v9/RKXNUpcJ+T0PcIMpNMYKV33o0e32DWqZHKngNFg79zE4GsB2JWSnci2nuFfJYer7rt2wZmGGuFZ6njPHJKCQhK9Q7mFKFm6/HlE1bcWRBIp1okisPhUebs78OKhK6/YSrso2DI3LgLFOttxt8+zPC34KK31wB7RIFoSBuXU4QALmmuvG9WCgXjgCRFXJvAgmIZIP3JE2a+GHbS/hwJ931md0NOvmKFgSILL0v/9YsK/lf3MZEEFUKq7eBi54ym6YI4dJpkh//eZs8nboFwmVx5a1fjQdYhQiRKZWto4dziaLi5u4t9miPRpUDAEA+ld+A3rrWntdXqmKbDOPfD0Oj78RQLTT32+GDkdIWvIcEHe7k1Mzdid92Ipy5+66TMJpjjPFb6K1N5eN04NFN6cTRgsqMhqGXdBIF3CWT2Ret1kZpOh2WC1G7MuEPT7n9/SvIOJxxyYC1EfMOARUikzhQA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(70206006)(316002)(54906003)(7416002)(47076005)(6916009)(82740400003)(70586007)(8936002)(966005)(426003)(86362001)(4326008)(82310400003)(24736004)(478600001)(26005)(108616005)(336012)(356005)(36860700001)(186003)(7636003)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 18:49:06.6154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f91ed9b-965b-46b3-e777-08d930f76b7b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1742
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Jun 2021 17:33:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.12-rc1-g3197a891c08a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
