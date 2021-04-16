Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAAD361D3D
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhDPJWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:44 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:14688
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239236AbhDPJWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW/79QpUf3++ezqU0e/US4K2GpG0cs7uU9/OJyz39O4JEMnfc9t49Z9zgPfFa33AhmtvKHQ/DpfdZrFud7rhYu3022G8R1QupynQ0mE7rdevmov1oX+1ZiDNiiC5kLSphSN4RN1BKIo78m1evHGDoEw4R8DGkQA5ZTiCe9gK+UqsIh3pgvrLU9yXcOBdGW4joGqsqtx7o1hqSQh5hhQkSR9/WPF5SIgLP5ONrBeYLrBhod6TCmni75rblgHxju8Dw1/QmuT7Uv5+jrg27pJQhhoMlB46glKXDDKko62y5H0oefUHWORm99eAcRkWDG/IVp+r1zCXn1NmX6fMtemIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Vh1bGCSF1h2ZSH36y2fqrjZ3OJQKybFlnb2BfGLQvI=;
 b=enbY4D2LaeRcDWSwWhJu8yPPYa8ofzZfFCbfnzk7r1u18fjdkpB391KUvq+IfZRgVBNcVpLQedjAsXD+NA5gT0nwoBe9Xho4OiU9sdP2Co2+SivBiUsMSGiWPcZYfKINU47gatzTBgBvMvBKIWvjGoF9eQqAmWK1ZuQJMEeNTCvqH62APpflh4GRzyxkz3KZ1ntUPnaqT3cTG5o46ZAfK7HVCyf5M1GR0Ylm8Z8o+0lCdgTOdWfFRdxNsmuAst7Wsgq8PW1rm0LJPkQSuJbe1Z/8ONwjtZ3l3S/K7Neypszv+pS6inIc99dnBsxjOBkPLgB2AW3mVsi6i9wn+7vBXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Vh1bGCSF1h2ZSH36y2fqrjZ3OJQKybFlnb2BfGLQvI=;
 b=slCLOkNZlHkdCY4Mgvbo97/of1cLgvcaAq1YawbpfR5WK1PN76eXDb88wpVYUrB8LEi6oIOTiwtZ6eads0tebIW2nZpmVsEaa/hdtnvay8bqXZbICSZDBY4RRQLdWpKmI6TVfsJzVPn3YcJIG810wBVBCDP0UJH77AE4kguZAI5qBdzrkhQAHJfhif5VJHS5mnv1tRQXm8l0FFqGIoW9UPwMWh98FLcR9ByeWV7zAWFU0SO6bA0FxsIyY5gU7jXufxUEnFjrtszch0P4v49a1ePkdMqq+7tLq4YUR/SyPtz3VbY3X2YOrrFgBg5838jvewvIykFBib7OII6cUuKI8A==
Received: from DM5PR04CA0068.namprd04.prod.outlook.com (2603:10b6:3:ef::30) by
 SN1PR12MB2480.namprd12.prod.outlook.com (2603:10b6:802:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Fri, 16 Apr 2021 09:22:15 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::f8) by DM5PR04CA0068.outlook.office365.com
 (2603:10b6:3:ef::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Fri, 16 Apr 2021 09:22:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:22:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:22:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:22:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/23] 5.11.15-rc1 review
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <70093e721f8348808791220a197cffc1@HQMAIL111.nvidia.com>
Date:   Fri, 16 Apr 2021 09:22:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd5bee8d-5d3a-4074-2213-08d900b91fcf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2480:
X-Microsoft-Antispam-PRVS: <SN1PR12MB248053A786E1CB165B20F7A0D94C9@SN1PR12MB2480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2D01JIvrnZijY41D804hF1lTV9uQ5sRQQ0fkwb+KC525dUhygHKnt2j0qFrCRew9GINXwVEZ0tSyELOHEH4isw4zTdnLkbLZqZyo3Hp8iNCBH7hM6F3N0IB8gOewW9R5E/9cXIL6wAEhXoOpZAYc0N5dTdoP4Lt2KI2xcMaQl2Y3EYDJm/A8Yz/qGXil20upBYM5bEQedF3Rw1+nglx9ZxmC9WVQlBIa4iCAgINqfYovn1qDQKcE77pBJC96uJOgNUjC0K8+mrlk6m4JpHaY1dxhJLuVwbNHFZE7XzM5d1OixH1DbKms4t627KdvIFwviIPXWLvJzIZhaIzvqcmO52ntpGtF/djPwkFL7H1lwAEOIMDlcsxgVBjYkXf+a/RhToDMeY+y1OH/c2pkJkM+yukMFDoPenrZmThTWvR15Kqnauult+HZOqAuHXZK0owY8r6SzJbtR4Ya2vA5HKGuhWeVw/2x/+ohICYvhWh/AzHnu2PbjCLgbp+1JJxKKl37QPPT+W5uFabCOy3RURy4mPO0LkDPXd1nkse9z9+58V42bo3ilYVVGFAPZYYwwBhnOSNJOnzd7MYxqFBTeUHFUO2EtYeDXzM7q8HfnG4KGRjgxnVt/e0CLgwO+R0KcnZ0O2YsPxNBRlEdbSCF+N62XVNkWW2pACjxqduUv1b2zF8rEz6+TVn1oU0ZyVovYCCUNIbwmSUPIRBSR4T7VKEKn0+EDku7TeEwLPn2RJe4VFA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(46966006)(36840700001)(426003)(336012)(2906002)(7636003)(54906003)(82310400003)(316002)(70206006)(86362001)(82740400003)(24736004)(5660300002)(108616005)(70586007)(4326008)(36860700001)(36906005)(478600001)(8936002)(8676002)(7416002)(6916009)(26005)(356005)(186003)(47076005)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:22:15.1204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5bee8d-5d3a-4074-2213-08d900b91fcf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2480
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:48:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.15 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.15-rc1.gz
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

Linux version:	5.11.15-rc1-g7825299a896f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
