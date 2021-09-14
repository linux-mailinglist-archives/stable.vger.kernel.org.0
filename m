Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699BF40A88C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhINHup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:50:45 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:24032
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233734AbhINHuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzJNODkysmSTpQH2ZpPQ6k6VgGMiCwjwNjbM+dzKbIKh3reF6gzXP3nTSifb6ESSI9KcRRgVhYurQgfwtMVZ/qgfV0HwzFjZ1q0LghzsgIvdtw0HN1vjpt65PZs5gIJ2byO/0IFJdYGoC9N8eyckwMnYETMH5Nm5b9J1rV4yXLGjEpaJDczgkav7a+7LPfkaIRpfT7A/XPRwgRjxYoQIEpdO0pr+IyLyTgZa2dWeIq1vXnDKDyIxaG/I79jstitTyLRWL2plOJZTtDCT21Rg8OJU7/yTPCyt73mewbJbnAEN+VGZSUgnCNzvGef5SaQLIhOT50QKBAeJ7FE/8U5erA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jw8TNikic1b6N5pwUir2wdASyrs04vOayAfwG8eIVcg=;
 b=nSHlS1mM2LUieYeubsPs5MQTuX4hj6fSgpJ1giq/69S+2CSxqY/IsXAHhdmzIZDNjGBKFAoPtBNokHznQGMspm61UvVABG//Ua77V977PWmmL6dnKxdnS4/eXDnoUMsz7ZRtUYdBHZOsEuI0n7Dq7LyXRAUsJz0bQclkKiXEt4I8i+2U07DmTXGUUIsVGJtHishK4f32rIW3bCKX86nS/NBXrVgAopj35hL/DACIdPT2Cdnvqb80BATPGvIXziSrjAfxh2CRYFak1yvUrZWlXdCxPrt6WMUv+JFOsPLx2JJHG3q39lJHa6zXTkqqvrxTmkdcRmkehFfjdielOUQlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw8TNikic1b6N5pwUir2wdASyrs04vOayAfwG8eIVcg=;
 b=kn43jCyIrhYNw0JSS5MxCVdCMnLOCkWH8Pn3V9IrvXyYwOVYir51voGf6INRPLqIAEHpmaGgXQ5N+ESWN74c32JbL033m4EJ9eamcJoszyC0DvWEyia7W5kg1qFuZSAKeApBfP+buUvdKjCcwu7vEdhqDgXdbnYEiJhLcT0+4RMI6FjSDLPBisff6OtWurrnax6b6pIggWmPnk8BVCvwASd1wELbhRZh5FZblLzonyLXPp/iYjC3c93nGOP23lsYZMONm1+Lnutgtvo4ppKkUcpaTZKZVKAjXgJvZ+DcWjUcAjR494BAglZ9x6dKWTVLlS6mCrhj5X4xb3DANM8Wug==
Received: from DM6PR11CA0062.namprd11.prod.outlook.com (2603:10b6:5:14c::39)
 by CY4PR1201MB0008.namprd12.prod.outlook.com (2603:10b6:903:d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 07:48:58 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::59) by DM6PR11CA0062.outlook.office365.com
 (2603:10b6:5:14c::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend
 Transport; Tue, 14 Sep 2021 07:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 07:48:57 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 07:48:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 14 Sep 2021 00:48:57 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <85cd9b7c191140bc99142f7290e5622a@HQMAIL109.nvidia.com>
Date:   Tue, 14 Sep 2021 00:48:57 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 579ccdb5-033a-4381-8d0e-08d977541c02
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0008:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00089668124355AE91756289D9DA9@CY4PR1201MB0008.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdjD886/oV6TJ9DTFYUxO6XepWAgDhG4qlbwPc9TjQaSqFtBbGrUu2LNqk52bDmJmNcF2yikyOOH2t9pgSCSIJrHezZocBvffg11CMBEXXMoGtObQgg9V+PT7eHNx7MW67lnsFH2VagFH+8lEyFkC8ImKBfnFdsCvgsWBilsgP1VcGq0EHlzTxI5Yru9b6YOpMX22lMTs6Zua0Hiya8bnohAjK6+VA9iaAUiHCveO3CHoPgz/5YEAiP/irlaBQ2KWsK2U8P8HRSnxLRgoXpKvhKapFVAeppgNjYvKjLjlCDCtm2NIleQ9SxkEK2S5fCFoMo3hv5T9dI6wEUlI6qozzX6iMuSPGdMJCqfGdI7g16QoBJqUaM9JcK70/4AyHmNUrDOg4i/ci9XePqRCQU6MckbjesvdTMVQMUEIijeQO+ExjoL/BrWVqQ1UZ2AzErHUvm2oMTY1P6xXUh94YwX/vOHKD3Hur4hCSB1I8h5428lCsuciO2vHgHE/SlYr4fa2SKn7PGUhtRdYCoR7jTFukMKGbU8kRNep13/5MdB8UPJ9xPrbTyMKzY7UGXpLBVolkBUGGhAfn5S6xx3ve6y1qZKIzQC7CkISGWKlsc1agqe9nfUyF58T1dN/CrWFnMYhB/lsbKg+4Q620WDqTRhetW6VhQ6UHlceBQyT1k7j79nsn8CSOQCWhEwbXLdGNhw0h8NH9binvd+Io09fGzJwSd5wkHjfBBf5+pgHbLjqXv4jBB/FYFkNklqxqT8aQJ/NTdnhAXEgRdBjbJ6q0gEffWzv96NtGHIEow6LRFEDPE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(36860700001)(82310400003)(26005)(186003)(54906003)(356005)(8936002)(8676002)(316002)(7416002)(7636003)(966005)(5660300002)(86362001)(70586007)(2906002)(478600001)(4326008)(6916009)(70206006)(24736004)(108616005)(47076005)(82740400003)(336012)(426003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 07:48:57.9440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 579ccdb5-033a-4381-8d0e-08d977541c02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0008
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Sep 2021 15:11:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
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

Linux version:	5.10.65-rc1-ge306b25768e3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
