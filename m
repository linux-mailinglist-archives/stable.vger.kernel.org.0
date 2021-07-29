Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC773DAAFA
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhG2Sfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 14:35:31 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:24192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229921AbhG2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 14:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ak0F+Hvzd4jDLuOumBQdmRgCoxGdKVsEs+q2UqVHl9hUlfsrMU73TtpNWsrj0bRfsdWbNCvo+61jEYyvFslvIZ9ncMOd10Nxu/VvvOQ6kJuxpoJiDCgNZafhaodwiUv8KTvOJZEfRgPER5ctVw+wgnV+qIK6nKsl5Q+1WVfEfDssu4+fRczWQfMFv2A0gyJSdAngjDehtZZ1hNoyV78PASc6GXkpxFsD7QAAvSsuhVm8EHL28/xLAmUviWeDgT9yqupiAT0S4JULiuYvmTEFLyGHWhC+RwnEWopFyL9HLdSxiIcFpQn/nL2MwAoMjhh+u8glpwQig//TwJH3uWbT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvzG8Y7e2Rx/DKqsZ/IvOgrzljh7TPlTvJUdguV3wvI=;
 b=SWLg7aCujnTbgC/8AxxABXOdc2DkD65ZrVnB+bbUyDKnCtG30Y5BFRoBJJ9i66DcHe1yyGny3xjnTZjuBlHK8cZTbbkFipy4sBSwxPCqHsrW8JFn602c4R3eaEaWuel7noL5WSzHuJkPsiWUlDxZwN/jwS/9yu3PmDlDrdZ6IDBCw/s43NWp2ofeK1GjGTEaGXOGc2XYGbf1MqN1YCQPz53p89oE83Z2MmulpKH8GuH/ulzn2Ht/8xTzILRXy+fIGU3qDkZNDGTZ9fH7/qjEPQZXogcouMTa3re7L8umSAFfRhFldfXtr1FeZLXqvrpq7PZUMcJX/uuLbZNXqA7deQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvzG8Y7e2Rx/DKqsZ/IvOgrzljh7TPlTvJUdguV3wvI=;
 b=HH+fViKEcusoEOyRXq4DlOjXTd6XVQExyyfV6UIWXpSdrFTIG2C7fFic73ydH8UgIIFDHYSu81ejJ4xLk1Y+yr8MIWN3oU8Lu8Uim9TftDgLAnAJdnYZYGRoipROcOtl+5hWS39NcqbteI+ijEbL5GdDAovdlt5A9FJEMrlrJEZ1g7B0tHsdHM5ouPqoQZiseitCoona880Jp+Rthadjl0hvTwIK2VZ5QPHevEhZdWx0Lpdyzq/uZ/tb8CUfvGMD/yiM+Eqr21gT3qU3aiOx8zwlfct8XwuUzN+y57slbyw7WsOiLtr9k5WXxhLMlDYWvNgJs9KucvWAMRYK/Jljxg==
Received: from DM5PR1101CA0024.namprd11.prod.outlook.com (2603:10b6:4:4c::34)
 by MN2PR12MB4357.namprd12.prod.outlook.com (2603:10b6:208:262::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 29 Jul
 2021 18:35:22 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::84) by DM5PR1101CA0024.outlook.office365.com
 (2603:10b6:4:4c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 18:35:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Jul
 2021 18:35:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 18:35:21 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.13 00/22] 5.13.7-rc1 review
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <db351aebcf6548f4a033376b3f876a77@HQMAIL105.nvidia.com>
Date:   Thu, 29 Jul 2021 18:35:21 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae221701-1391-42df-1414-08d952bf9fed
X-MS-TrafficTypeDiagnostic: MN2PR12MB4357:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43576A11073678C03B651310D9EB9@MN2PR12MB4357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+IKf9y9BVZTqQBBODe0sxg9SUSyDoYPy2Pk30JvTWhLLXvxXqyIs8Gl3LuhNtKi1Hj4rtR4bCuhTkdPCgB4pklxZZ0SzeNXfi9xXxy04ZPBHnumTg3PcuKsGIU6jvMS7pGOAxLEvx4DLZkVCY2+XH0UOHj5HLx/FiaZlzGXrDfc5UqWHCR1QKQ7OrJbwVXnB0llNXAAu9z7ft9lvEf0FIAuvjJa1WDSj+8TqTkjanwV8rgayJqbF8Hf6N3i6rHwjCYTQrUPIUAvuJP7M91oOSO0QwB4mxxJnp6OLdbAeXPgC8f0c1rlcd7lzgcVcU+dmwYqClEUVlZu42byqK+1lSgeZn2Lb0PkRloMxJtziPjcOpXxOCtixvsBk+78evpKp0rT7oycuf0ND5WWaBrb2ZtstiZB0u8NR7GBP8gXcw/ou6U1rn8gCmlwcYbAvt7zigdZrjfLLFRFXs2Cgczkij5lMuilng9LrzxEyJlmEnJAsde96yePcTVrTDf9WYtJvjhZeGl9uyvfI3g990maaoVGyIqqyL6qr5WtZqVRWLzCmkQimcyFqGZKnfDz+mVhyIZ4KFeb6bt08pd9JPtBLqbeOfhIxfqryHxSwPzLP55Pdm1J7aSwFgqcMdDl+2e0loRg7hkhMcaYGd2hqQxIqEYPIsNOE2KfjCzYCNlVwBA14xwApOXbbrfki7lXmAgjjPFuU+f5Xp5jZL/mQMeJahMaG4dwVpctEm72ndOjgjiBH0gXJMIDM75dMvMon9/PTjlRAQomTotglo4P8jrcpIpcgXvqleJj57QZjSLrCHM=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(966005)(36906005)(70206006)(47076005)(54906003)(82310400003)(70586007)(336012)(426003)(6916009)(86362001)(316002)(478600001)(5660300002)(7636003)(8936002)(82740400003)(2906002)(186003)(4326008)(356005)(7416002)(8676002)(24736004)(26005)(108616005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:35:22.3902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae221701-1391-42df-1414-08d952bf9fed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4357
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021 15:54:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
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

Linux version:	5.13.7-rc1-ga572733cda32
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
