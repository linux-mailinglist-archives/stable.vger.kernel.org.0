Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E411D3A1044
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbhFIJi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:38:59 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:10176
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238042AbhFIJi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqHjf7Z6IZtX+5gx9S5mHHnj2o+qowlOyqtGKHsQNmEpw8U5iLpv1X+Gp7b8bwNxfVx8JpCl40I1wD7tZGTKTiQl0Xnech2OqEb4O1q0n3bFv7fLklLH9Mk1NnnZtX3044El8mVBYKK9qkZIwPoLVPQYSPJGiFAoICgmXFxhRKrl8w5cCxOpXDPZ678knBukCekwTnUDQk6rUERTR3pthkrQjd0ngwtww5jlzL90vLWL9KrsO82SMpAD0RMpnhqm4qzVIKgl4sNvfZDlZjDSAsYSsQ4KMSCRU3BlRwaVBLE5I5Q/hCW2zzULY9+I2ZlmTX8QObHxcGb0Xbq7wi7OTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF09Tk/MIosO0haMuzZYxklghKSCbgbmBW9Nj0Rws64=;
 b=hKIa1Kj/VLbTxbX0sn75VeW3dgDFV7rGdH+7VRKrXxkg7G/BZ9nSkB7XGwwsjp2w2B/JMrig6RioyVkB+6SbHV4x2P4UgDycbnnY4gk70u8B2WQgJhfTyGc3N0K/mR3XOBtNjMt0ZjoSql0V8bLPpUlM/+QIqmjdTGdze0/2c0Ef/w1/MpzfpKCQfUC3YCgH/cuu/dLAzKiyoM+h3FDlxL89cvPzAXDXaxLOIVvUYa6ZeDoSgk21QcKdscPR5zP1NHvE3w3TtnTYJ6GUY3sCmdoQEMm00Z3svc9TG7gd6eips+GEn4cWhBVE8J8y1dQ1O7TMQqKAXERauZWdXFOzSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF09Tk/MIosO0haMuzZYxklghKSCbgbmBW9Nj0Rws64=;
 b=bZAE8/gm95WwKuw+ULgzOFPJ4sSmbdarrNd/czWydnWbis5b02D5NEr5RN0+ZuQIwVM0XI+t2EwUWozNmmMwNlFOAtzPtOUtiQ8nY+yHZwBNmxjN11WzMbu6Nn6Kp29UW9uOMjvyZF6rNcErLmZGLUmnr2q5ZvgJeMXJ3euOxFjMem4wKNw+QtK1FKkTsouB/UDtYQLeGgoIqF9cfsQRfMepo5G5sSKwP6uNGTAErlUXHxo78n4n/OzbfsVEEipNJdeHDhm4VjDNcmzujlmaIVvoTQkUiWVAWSKyuHe5PGMR0rD/Hnmrmm83mcSjsBjzjnJBWq66gNDB/MzwO9qswg==
Received: from MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34)
 by CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 09:34:00 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::aa) by MW3PR05CA0029.outlook.office365.com
 (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Wed, 9 Jun 2021 09:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:33:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:33:56 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/47] 4.14.236-rc1 review
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1b572ac42cbf4a6698dbf7314db9b90b@HQMAIL107.nvidia.com>
Date:   Wed, 9 Jun 2021 09:33:56 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c7549e3-b950-4fd7-8af0-08d92b29b615
X-MS-TrafficTypeDiagnostic: CH0PR12MB5266:
X-Microsoft-Antispam-PRVS: <CH0PR12MB526606633C71A4BA9BB039DAD9369@CH0PR12MB5266.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZghGl3UWPWKcsgWcjoopV31NRQonsYuFCfE90DjLZNnpzrZ1EAf/OVDmnXWIa3tBJIcB9/wUcDkCI1oWYD+HENKdoYCOEF7ttzPIo0ybmwhi4wXKpCw20Xj3Rdq98Er+AzE95t4SISpbNFPmsw5LNqEYIZyACuXJmK8RFM/4eES0/dfWG/qAFWLcYzX2uFh7IxBVIB5DOUQGQZCYek+2MEe6giP0UxhRWCsNUNGsLWYMusytmJhJHww9BBTLdgesi4Zt41uHlWHdTuwkLUPFQ4m5ARkt/GXmGlti0CD//ag0Tr4pZ9lznKLzGcgRhVd9vavKXMym2WeRI9Bix8ZzC1MvHLFT+BtN/wWQ3qUM2TfsZd8Akz46FKOwPXdgr1wS8OgtrXO3YBJojgbFTQY/6SAlUlMELSOny9omTdLMv7DDkA1sf/MhUldWUzmRujb/WKTCaqtRb+JUfTp+Rz3CP4yPTNl2AkGye6lWZvk2ufoYjGcAAJUrI46UOmAqBYt0Q6db1Z73Nj9m+kx/7TKFiVu6uD5uIZwmK6b9OV47QvneoYWfQeG6tN8ah+pC3VWxP/Utsft1E4E15KhDzvbXB2VlMeci6pG673V22gHXSWOM1qVNGExOsEFJeuz2Ovgt5U+xIjhQnVHGfH34k4gSRXt1UO9Z7+rryg0f7YN+4VSicuqbVV1EhvhfBdRfn1cV9KJPYJnCQshYGIH0D9s+ZWoBtUI6uf7JI9yZh1arBczO1J2wpvC4OxuQ7JLVNeXLIoTfsqAaluygHVJGOfCEyQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(8676002)(426003)(4326008)(8936002)(336012)(316002)(54906003)(36906005)(36860700001)(108616005)(24736004)(7636003)(7416002)(966005)(26005)(186003)(478600001)(2906002)(70206006)(82310400003)(6916009)(86362001)(70586007)(5660300002)(47076005)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:33:59.7584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7549e3-b950-4fd7-8af0-08d92b29b615
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:26:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.236 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.236-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.236-rc1-g872e045a48f8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
