Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B12736B3C5
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhDZNFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:05:20 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:49584
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233520AbhDZNFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzlvfMjYMJ0ev3jzjDc2eB0Iz4P0Tk7uuN5SxliLAudq75L29qT9MMiuTQohp0AJeQCROE7NEKahSNjWcZfRFj3gxRT1HKqw05R7FScJxOv6P4+5zHptZNsNGoDSzzszZQqqK+UPIplzYJozYFNYiKEx4xPnzaO3s282xkvt1IXLipIBPQdEkQJdiE8h8tgw+TRm3rhXl5hnp/sHJ9sbwlVYToIxuqVQ03JIprVrKLEwS/5RHFIF6NteguaqF6zc5DRV9sibm4+HCzxg9qpRkuwh9bNczqDvjonBsREpwN3x8W6oi/RSi25ef/NqpDudjK9f4eD2Ce077gMz1gZT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+O8NHbhIr/QV9xVHrF48MwfVvvr8UdchCsmK6pb+KA=;
 b=IGRmAz5fR2n4l2XPcc7mv2A4xlPH4aXDwNmTOvT5s0NcrpIFRaxUBApPUFYN4tyApxP8L75T8rlly4fYp0l2w4KQykB2kd/YA1Dp/GbahH8ueAkxmFrzKoRBMpWLv11daxxll8o6WigPBY2KsX3/ePuEa3/LmFswhnHvSLl3B0Xo/pSS4ECYtHH/qqfWI5iL6/ElRdWinf6tybRdo1G5vwjnz08eQ5g5ohTqAdP02nJvjsxrB5YOwwg0CqBaikSo0SoMq3FZw/jTfd47RXmhRN+Skgm80a1jq+WEM5yguRl7zXQ38KI26JvfbC83K/qDHk9RHq109bgM1UHlurA+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+O8NHbhIr/QV9xVHrF48MwfVvvr8UdchCsmK6pb+KA=;
 b=Nt6sdQsiYc+43YvL3heZDJ8/P89yLOqkiidMx5gd4O7PQW+FUDkqoVOtTimB6my/mTVFR4t4yakOmJiQo+vDk+XsZFm9va7gRoZ31ArDGUyGxKDq7ZmKSp4oAKvTik4ozq75NpFivGuUnbdGNFQiRpzZvEhewwDw8Z6B8bGQRDKruLZS+JI7Jf3j08tzM3ElOmI7Q1UmpKJMuITbFkMFkIF6DARmppf3XIj+lRxwXKGmJXPRwjU1txIJQe0NQjm9KGAbZBDLEb/nZ+7iDfkX9FHLglthSuKYozVqZxV2700lPI9YhhbsWwcmMEH7sKr2HmupawBAwtECIfX5Ic6G6g==
Received: from DM5PR18CA0092.namprd18.prod.outlook.com (2603:10b6:3:3::30) by
 SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Mon, 26 Apr
 2021 13:04:36 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::91) by DM5PR18CA0092.outlook.office365.com
 (2603:10b6:3:3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 13:04:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Apr
 2021 13:04:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 26 Apr 2021 13:04:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/57] 4.19.189-rc1 review
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <481c22486ab443e0b1e7e0f4cdaa6840@HQMAIL105.nvidia.com>
Date:   Mon, 26 Apr 2021 13:04:24 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a37a65e1-5810-448b-87c5-08d908b3d7ff
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5456:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5456EF7861E3C91043856A5DD9429@SJ0PR12MB5456.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TURb+3l9XPKm0x4gkjbbNLNiNAg/bzJEhTcdU5+Q3ofhqPz+kMTwnL6l5C1Pkz4+55FeskntDd7aIHJ8I2AtVmEiai+Hb4KWqyveZxwu3720ds2AoYO5kWCB+YbFBKuE9ye5WhwdvvyJkDkQaerYGC0pcX4nOF14Q8VJM8YqGLILY7L8RW1yJvN6B8Zj+ap5iwJv1T2DDNraOpKd0yi2PSA2XI3NIDEV5fWAUqJAXWvRJWLTdark7segLy11thyCJ7zQSo9x8Om2mERgy295fqtxdXPZOI3r5IloolmA/7ElyrvztCenw5DOVlxWYzLI/7OmLbWXk8FzYWylsyJmIfx+3uLGy93IDyOvGxFSZtCLN8+lRB/rTOIgYh1WNW+3p3vVocBBybdnLfXJ91NIko/Tmw6NQxLL0WfXs78Z3nWQn7honsAxeLsgfEvO2dRqfJ/6behL1Kahkl962H3EtP3q/An7LU9XWzKFxRV23s5hXH+Ssbvcnyqa9kSPgA6YfmIskxbkHCH7/g1kkvvN7OZTyFXNoX4K6rb8v73ImrQi0V6YwygA4bhFHDn1VeUT13OrDVml37GiyagH/1inwEaqrK22OdgWKer12xjDSMnNDNNJ526hdh0rd2+h19QJ6wZEfduBXwJRsTHzDqOVESX5fN0hKzQBOmtpmum40ZNBLtMYXJgbAmPPDvnpu+kWJakjsqVISQII5qSP3uj/013S7+4q4cScmyb1dfeJxUk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966006)(36840700001)(426003)(8676002)(8936002)(4326008)(26005)(2906002)(6916009)(82740400003)(336012)(5660300002)(36860700001)(70586007)(70206006)(186003)(478600001)(47076005)(86362001)(966005)(356005)(7636003)(7416002)(108616005)(24736004)(54906003)(36906005)(316002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 13:04:36.4532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a37a65e1-5810-448b-87c5-08d908b3d7ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Apr 2021 09:28:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.189 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.189-rc1-g6eafc8cc1bd7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
