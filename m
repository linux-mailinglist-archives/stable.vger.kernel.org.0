Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A6336B3C7
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhDZNFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:23 -0400
Received: from mail-eopbgr680063.outbound.protection.outlook.com ([40.107.68.63]:14919
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhDZNFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UctLWlQB5wkKvOvEL8ZxleB/nbCia0WfILN90qrwB1uTFA5YEc0qf2z5x5dmnUO4d0f2y7CZ2Bb8jdHKfO6tv2oHo+SftSaEqcrQO/AKyH7rN92fpNhy2y2AsmIzF5qdd9zZx0SraaQ/JXd47gzpQpBIJGrEDmigIIcak3J/31JdSiqV1e+AmJzg40COWQYCihxx0A9mi05+u5p+HAmw/WRHPut8+44EQvQFcpKEpA+BiKn8eJEbeAxWovVfDKTkwovnitQoI2AS3wj8cHAjRUGf6fBspS8QVGxSbpZotBzqCTgG2jgkXB+ceOxoN/eqx1KzLpIG3w02ptCfIB27bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yeHdbDxRIbWEWB6erBGvdHSASyNLe2T3DiSuscJidE=;
 b=E7g3AKOe0IhJGnEb52DpK8WcWkbREeYrnmUHR0gCb7pMW0S6D8F7IpgFwQ/NF7u2MHlq4GRTw21F3D5v8SvdKYvWtJOIvzZh3UWiq892ZA+nS0zKMWesj9vmR8eqFXJwgLwmdg/SmQ9wmF3MiykeY+q5df1Jx1J3o7g+zgpYDBroJp9c8Mk1r5AuEZRuGNIgLN7SuQMQXFk2LpqgCje5CP3kCf5tHpr9CcO9rfHTFGdf7b7mG/Ff8eHE7EXeyOUxhOBGakS6vvbNXwAkUmNPi3oE5IZ/3NOPMTOs5Quioe/dEzILCxJoTH+3Hu0QifxwIeFj3/Au5U7gn+w5AL0tCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yeHdbDxRIbWEWB6erBGvdHSASyNLe2T3DiSuscJidE=;
 b=shJVm5UDUbw+meAFlkOgbkoGngx7I06JuIC57Ka0L+kjmssSb1Spi+SRLzLb7dqklLheirjDdlaTXAOuEuOGRonkCFr/cc3OaDhoQanyGyhTjfe7Jwxiqzar7hZXXPVPecsj3eOyjcJwcpFGyFhZSFjEaQURIzPCYYyMHu7jNLwMAu707IJoWHU5fc7/YF5aaXk6sBpBdSubxE2mnU1AWaPRZrHNzii7Uk8kHj0YAo316jEn9Ji0Lsrvfq3LJxa14nCVrHaDuLSCGsHXvn3j5qahxxXCs0xQNiLqQzOlS4IXN9/Gi1zITM9A9zZIpW89RN2cww8QFFxt3Wac1MdSnQ==
Received: from DM5PR18CA0093.namprd18.prod.outlook.com (2603:10b6:3:3::31) by
 CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Mon, 26 Apr 2021 13:04:34 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::71) by DM5PR18CA0093.outlook.office365.com
 (2603:10b6:3:3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:32 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:16 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 06:04:16 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/37] 4.9.268-rc1 review
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <34444156891041bdacc0e874f6619edb@HQMAIL109.nvidia.com>
Date:   Mon, 26 Apr 2021 06:04:16 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c611f511-4cae-4b65-c943-08d908b3d5c5
X-MS-TrafficTypeDiagnostic: CY4PR12MB1494:
X-Microsoft-Antispam-PRVS: <CY4PR12MB14942C5E05FC9940B1900C1ED9429@CY4PR12MB1494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MM21InPZnkzehxINf8cMEHO5ZdMYB0sUxeeuRbxVqNpiFbDjAepOao4beNuEBtIZqcsTlGHcFF30wY//lZW0YtNoy0HW4o7qDYD6gJS+FtWSCEh2ml7jTZAp2lItUQkbUPAkyHRbVo4qnJSyIBd3Imuo4RjnRNdFaeErTaK32Cupz1oI7cBf7CQneFvomiqLssn9VbVXDuqUXCBb1HzMq6Qj/vpKq1/Qam+yc00TVueHnDigVNdJUVvE82zT3Xxmh6dGx2iSrYwnOzSe7CpYqAutiz/yiH+aRmuuHGYw9WgdIbnRHisT275kqt4HfeHHFz9A4PfM56nKIBnrt/HAKDsZgxSGe9nPZCJvbyBlO78iFB4ARFy6nUDLDkK4vryYwbugF1VWJWhXoZtelO6hRzZzX6dkRGkRs6vWDktU0zIJiJtku5fx+b1aY9f6plkAPqU9oexe16MIowzCU67Huzah78bhMKvPBq+GisCqeJFlmjC8DtHCKBHnfto2YtqW/sCwU8COXV/Cq9doJvG+dnttV+NQtARQ2C6amhlm/7vyMrH9q6qF5It6c/iFvvG62TL8ty5AcBJPQZrwdv3i/mpbSIU2gcQ++TimJ2OPSN4bOHhggOz2qMnbnaEuKsRcDmhIl7wU7lUZJpz0oda6q5rbfjmMOBwNEpHSEo7rJi2cuem8lLu5RObJMTHOGiLJvHhlxN7jnXkWyFW88SyS1VkPAESoOe/zaskqFsQok54=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(5660300002)(356005)(82740400003)(86362001)(24736004)(7636003)(108616005)(26005)(4326008)(186003)(8676002)(6916009)(8936002)(2906002)(47076005)(426003)(54906003)(70586007)(966005)(7416002)(316002)(36906005)(82310400003)(336012)(70206006)(36860700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:32.7103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c611f511-4cae-4b65-c943-08d908b3d5c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1494
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:29:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.268 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.268-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    29 tests:	29 pass, 0 fail

Linux version:	4.9.268-rc1-g0f9e08cfadcb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
