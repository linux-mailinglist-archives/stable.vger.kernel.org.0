Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5D9336D76
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhCKICN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:02:13 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:56032
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230131AbhCKICI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 03:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9KGQAcCq17EtHSc6f0YIJCja3npztw1RvcOHdmvjojjC4vNfVtmoJEe8sDehsWIlOIwrrhl8Y/umSlBY61bed+/PVpgrdtJDNiQeABEAx7Ibc5dzCbrSJ0ndW0AFiEDEAsQTz4GYsINsu1tMvDtN2xEN6IhGdjPe/FL46VwL+7Tnaw9m3ATEsdtMMIRYZq9hDwOm/AV8TTNKM9l7HiehY4THJm8IKyk+7nC+zQDdiiEh84+H98M6JCXdysNp26kE6wHoCLn1YPrSjGPXvfJPv+LmOjMOFv3b+LfLMn9T9S0UuF+gOIa9S2jVWEUQSeixEhabzzGmc0QaR97eoyJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0PEuZLOq+5SNX+teeLGJGDWyEX325X/nA9pgI3FuWk=;
 b=HlmauInufK2ZNDEqwglyvEZ2MzqLAXFi0lTuFukkoGjg6t02Zlb8LJjQV5R7ISRtMYWbvr9yWEqnkwq+Akc0Y9fSXg/spElodiRmUTOe3qxMzvProeXmh/ZWfLuNjjcB+1k1H4zs/gegAbigL49JDbr+P/OASkaQN75WGdEWx4GrFeEhPK6CZ93KzneqNjOnoKjs9MQE/NshaJnwP+kVTB+ws+B5y8CWWwbraZ52A6Io6WdLZMP7NPXjCQ8rLjkXYRcbJ1KhSwbfDUmNIGDQ+xNKrY8HpuaHRaAgOBQYOj630pKrKQ4y3WZKmAnLl6+wspbJTQyCs2fW3FBMSpYT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0PEuZLOq+5SNX+teeLGJGDWyEX325X/nA9pgI3FuWk=;
 b=nJjE0x+5G4WXqnljyqBdD22dYqr3wROqXhZUP6mnLWCTim4jhiemluVPq6O6FzVcosi8jGtUoC+mTYe0R7si6zBvLR9W3zHRajMwk6CmmzRUo+cOYJTCXKxQHrcu3mrDqXMI+ATedW2yRxKrT5RMOK5AxKV6hqIau7tgos9biQb8C2/LRnnUaoJYca25lVP5oLG1IVoKiDrCB2oCR886lQ3bfxjcwD6ZWZiCXKF1LBUikmHkBPnR7W60oJnCNWONQ0xE7Yu+92J3jjOlIWRjIAgkDv/HCs4QWeU9q5fUdy/Rb11BIZHYXhcghAIxF5D00vrXP6Ftz1DKXmZEHwzXuQ==
Received: from BN6PR13CA0072.namprd13.prod.outlook.com (2603:10b6:404:11::34)
 by SN1PR12MB2544.namprd12.prod.outlook.com (2603:10b6:802:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 08:02:03 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::54) by BN6PR13CA0072.outlook.office365.com
 (2603:10b6:404:11::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Thu, 11 Mar 2021 08:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 08:02:01 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 08:02:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 08:02:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
References: <20210310182834.696191666@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <594433892f7d4f46a0ef90e98b88a26d@HQMAIL105.nvidia.com>
Date:   Thu, 11 Mar 2021 08:02:00 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eaf4896-83a4-4f70-5206-08d8e463f3f3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2544:
X-Microsoft-Antispam-PRVS: <SN1PR12MB25446868EAEE7496A4B63B77D9909@SN1PR12MB2544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7SJJfk1iatv3KMlJEdCLuhLCyjHVR1jCLxqnBz7urUIJBWcZtch480xGVDPMOswSRym0gcWPZmH/TMvtXqT+bber0lKX5OSaK5MxeIXvQBUpQwINd7JSbQp6Vp7PE6Kmd1GmMDBbO4h76D3pJqo9i3ErUhIUtgN247I7YPief3sYRclRQgztEPVaBHax7DF88D7PDsSvI/xhpF484I0Y/pybtqX5gDuDW+fDhyyZTYrBCZWrw/5CHIIi5sMGwLtksnDgl6y2QAyOBFbG9L9KKMT1NIKkA6acSmrM1BdFlBLJy+bXh+gB3VQZE/LDOIyj7Mb7kHUSIjhp8UrHR/UBy1QMSGs+2+EjId2adQz916Ec/h4H5XhGEeIfTZ+j81EXtXvKKoDbtbygyFcHwBR7bF+jAMaH1+oJJSfwXhcCFjUa+yGS55ZSqHCAQyWuywR02J/GLpuawjOu2hDdzm3twZ5fJBm7gmISXYBDeOKM6e78UMq0JFMCegBw0d3Dpd2hdHIof7iheOuctq2sO1qCfQn3efX/yfzQJQWFgoxtc5o9VCB89htOwGXa2T9bi5UVQJrSHDr4Al7nRIMCyWmiXfo8HRUGwMq9TYP7VfMV/e7Iq+obeQ+b/fSQ4g4WZDFvRqF0eHEPopBNRJM6GOuNNqjFaECRJgXbDgjtlTwRM1eh0PKJoeAAiLFNlfqMtSqYJR0dXWvV/2Z1jiQI26SL4YC0wBaZQQqxnyzgTAmum9ch8PQ0B1Zhren7Vu+rb3tpUZrknty/a1UKghLs3icaeA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(2906002)(82740400003)(7416002)(86362001)(54906003)(70206006)(966005)(82310400003)(70586007)(478600001)(8676002)(47076005)(36860700001)(426003)(4326008)(316002)(356005)(5660300002)(336012)(34070700002)(186003)(6916009)(7636003)(26005)(8936002)(24736004)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 08:02:01.5841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eaf4896-83a4-4f70-5206-08d8e463f3f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2544
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021 19:29:23 +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.23-rc2-g93276f11b3af
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
