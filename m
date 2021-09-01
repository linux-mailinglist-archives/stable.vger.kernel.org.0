Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303E93FE2F7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhIATZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:25:28 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:7425
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231146AbhIATZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwUZWB6loLXWMLo91LdngemDtUqXhQxmpxMuAKJSlf8PIgtqI92c+BIsHsFVFOZ+dUh6DkWhslUmZrRMw8Kj7oVAsXiVcSyVFr/BD3nyovkr9u8fTNt1aEF20an0yR2YxVhzVHuxlUPsY2viobFd9ZN2DLRgMsCsm2ohW4thi58A3pWG+db+sCK4ypHCF2JyLt8gawmGQ+cGwqoP2H2kXoJ79jNymAxM45vGdw5JSSypjMfC8eRPC9n028jbECeGMAn7ZqVfhpfPEZiSqp4Qvo2z3wbI7f+qnXCooagoHmEVX/Wm2sh2U2yQzFvMn8lARBddZPZdnpChoQNnfZbzvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WX16mSnFXUgjb+c0MdYuNmgYRPkOSjiDu59TWA143M=;
 b=Z2B+om8dcyEWyutV2fh31QsncWwQENnIdb2VUYDhA2lTEIzMl0VIzd9sgp0YewNlkrrGo9uUOzuGUe/sgA/7AJYFFPx7CPArSDKsmtAbBTnW6HMATRzTUjzsT7SlvBfs2ZRXQlTupp1drqnoFcV0at2kWSzKrl3T2dviA6MlIvaEmIkydzkWweGtHV2xtYLUzXsitBgHRXp5mqU6f1vGzx+zZOg/40p1OO60DpJbdLchL8emrKaMHRCCzndBASNJl1t4BOwAtbtGFfCrY57mNxxQ0RMfFkL7/B6iNdL1D07mhoM3o6Qp7yvdKqTkHbNlYhMbY7yAG6jg1aA2597OMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WX16mSnFXUgjb+c0MdYuNmgYRPkOSjiDu59TWA143M=;
 b=oO/NwYyWL2CnQa2GUzi94baaL1o2CWdFNSbAWnmZPD/m3h5M432OyFzHmhCBD13RI/ebO+ov8O297J1iH4/myW0bxhUv2eLwleHj+PsEvClaXGm9rtL3OdY3ZcjhWxrevja/hmNyKq7N5FnevtqChvVWIVmwZdmnqFvx5HkfijR4CqMS+aNBwf/dbCZc2VXXoS17ZbDn/XfREDkbn/LEpfSkr3MSTzPBUB/3FuqQ5il8jYbyhIWlBLDeQ4/0pm5iTvQ4/z5IFU4nGEMfWTdGBFin2iRp3foL1xLM86rskFH01AHbavYqTj68pfsV+aeiymXTM/bUvGi0iKOLjwUT5Q==
Received: from DM5PR10CA0001.namprd10.prod.outlook.com (2603:10b6:4:2::11) by
 BN6PR1201MB0193.namprd12.prod.outlook.com (2603:10b6:405:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Wed, 1 Sep
 2021 19:24:28 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::b3) by DM5PR10CA0001.outlook.office365.com
 (2603:10b6:4:2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:24:28 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:24:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:24:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/113] 5.13.14-rc1 review
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3a9b627013c84379982471828c2f0deb@HQMAIL111.nvidia.com>
Date:   Wed, 1 Sep 2021 19:24:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc6e802a-1d7e-42aa-5e57-08d96d7e1dfe
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0193:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01931D1218A02E57383778EAD9CD9@BN6PR1201MB0193.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4wIR9HyWLutJqpwnFPEac1i4U3+hSZWq2em2lj1ALznu7pylPCtEzhuMgi1cmDLdS5WEOmIpo+ZV1PWtPIj+VUi7Y7QuZMj9DESwQMSkJv39ZGFM3hJ+7iy7i/Jvq7+8yHfPH25kVyBb2Y9SGc6uVtu7gvPjYrUln8mKxFEJFRL6i61V2YhifLedSG2MnYjvOQPWTPFMBnqcuAnkhPY6OT91tqMv74YjabNrjhtxWJ1Kz/Ey87Wm/XcBPDMhbr/s2jYmvteb7rT5eIYkvEKOjbigtT30DqzBloh3YE76NjovohaE8yEUdctH2FV0A0quhX5St5kF2mI6jCytND2XnIWJBkoESVNuiyGiicoyqfPMZgJZ9Xl4nAUPa0nQA7031NIeTIhqAvKMd2XVZWmA6Y/S7Y6/uouCd9b/FzuB7fV7Fx8cOz1yWXkYVkJmjoJqGNdoPTQ8ZlkdnqV8rJ9JRXcl39/Q5UxV3pgkqGowG2a/RlLPbALHA/OdG4xyRQtlSAaD79WNEBkfx/oNf0mBbZNNBTREF7Fmn/KcpiZyQ8dp8Y8uAm8L6b43/2DePAuJLuQ0tt8KwU4JOClHVLpcsyh93Q/dhm8y687OSNmJyQhDh7+YniOuJpM0ZAUTsDRvuVL2CsYTym0mHJ9tWrhvDDON0n3uT4GHDElFPXM7Z4raLrZWxVrTPjcPQ5qb+GpEMWv/SII26wXGjda7Kdpv3A3PrlseQzSUdV/KmUY7FP05b/pTxZqYuomogD+gaszzrIayhwdtlIRY3Xg+VOPd1Z8sQtzslWkqeEl7HAoJG8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(36840700001)(70206006)(5660300002)(54906003)(4326008)(70586007)(6916009)(86362001)(336012)(108616005)(36860700001)(47076005)(966005)(426003)(82740400003)(7416002)(186003)(316002)(7636003)(36906005)(24736004)(356005)(8676002)(2906002)(478600001)(8936002)(82310400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:24:28.5002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6e802a-1d7e-42aa-5e57-08d96d7e1dfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0193
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:27:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.13.14-rc1-gd049bfc3077d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
