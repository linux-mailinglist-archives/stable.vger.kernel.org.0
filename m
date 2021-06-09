Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079213A1050
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhFIJk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:40:26 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:38209
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238097AbhFIJkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:40:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ukg7DpBImwUHiNnUWQ5v5D3R8KIxyn1kLyGXRZH7Y0hrZIZ5mHpaNlC7pOSUwrMt7+9efRtJOF0ASlkj5ZZxUpxi3tQSakKpAdW/rfokDmoBZajDNFSwebndX3/ODOULSnUCFe0SgueKlKQtQAzmnW0K7FNmV9pivxnYilEW0Csv4lXRbZaI2+YiA2dF6anqolg+0GpZZcKUPrz4sINacJFyU3qo4VnMVhEh4h+CbesxvPfAPVQQTWaKPLk0jofXYiSxbE7IysSVERjtLbnJsGzZfsLuAWdh+5muie5giX/CcZopL6m/WWcRXw1oZxmdmghHjLc8HXOR5HTySICO4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOtkZq5+F+mHODFZSPd6JPf4CYe7crdJ20u0N/ZFPLU=;
 b=OuKBcvJ40k5Eej/rQq3rRgTPwpsCTz+dFsvdjpIauHwhXco61GaSo8lNiOZm89sYaUAUQCgitklGLwEkjy4Aeqo0+lsdkfUJkDqrzQskFQo0JtaukSBCq9vi/3Tl/9Lm8Scz4gdXC2BOofmuTU4KwrhP89TFTxn9eNHHS445cIAtTDTVOe5LLWZkuM9ynEFCAdGwyMYeIO0XPj3NNdozZRIsxghiRPhtz42jjdS/foO3vXPga0nglAbwi6xb4+tcPyO1I7bZw+H8nwRv3AI6Ver3fI+Wr83h6L5cTtGBHQOIhJ7UVxjpklU/EvZ5z9mqFdBHyPfnOTGNVgTxmcAawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOtkZq5+F+mHODFZSPd6JPf4CYe7crdJ20u0N/ZFPLU=;
 b=X0iq93hBBwJXk0NUXjxCBlMXiMBRe4JUvx8ao689vwJnI/PYbiSCXlPtRRoU15nwRTuZLcHy28C9mClQaDHaB9urJdPsZH21Vbz/E8WWCPwNgtLC0akLYf0ih+a4lxGEmMgM9tQm1lZGrvBjigbfFj11OSe1EyaT0VVlPmxFR1kLP0b9v0v4UK/rweP+l2wIio6oQUNyDtQBll9kXRolRqEeTVUMgl4TbMbVeJuZwVcVgs8TXc6G8juj4kgY9NjJIQ2kmzSqZgmu02lFJPiifLJP1Zf05Ha2SMF6JbfLfj2NhjwJqvEgo7ubPKARdJSxH4fo9TZ/vcybJw5+fDYAdQ==
Received: from BN9PR03CA0542.namprd03.prod.outlook.com (2603:10b6:408:138::7)
 by CY4PR1201MB0264.namprd12.prod.outlook.com (2603:10b6:910:1e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Wed, 9 Jun
 2021 09:38:30 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::1b) by BN9PR03CA0542.outlook.office365.com
 (2603:10b6:408:138::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Wed, 9 Jun 2021 09:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 09:38:29 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 02:38:28 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:38:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/23] 4.4.272-rc1 review
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
References: <20210608175926.524658689@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7b1fe09c788e4c10821b4fdf52b5d0df@HQMAIL107.nvidia.com>
Date:   Wed, 9 Jun 2021 09:38:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99c6bbdd-4aa0-481e-7caf-08d92b2a5710
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0264:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0264AA7EF50A64E1678B69FAD9369@CY4PR1201MB0264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZeL1ldM15JjbxLVX6vCVzqYlI8IXS91jE3VMQJaRa8cgqo9ec1DrurXgomFukkFELbv3rxlr62kOO7cEKd6EWfZ/puCkdhhngMI8gLtJzC+N7Jyb+vR3F9wXdtAxx2TaK0hhHvnKTYvYtSSXkdT+3KjJyVGWccBwJKf1wyBx6dtpP2ak+moJs9KwrN4psIxWp5HtlQKYHSWN9GL1sl1vnJ8HEwFQ0duavCwILzzgJUTUhmUz7gb+b1oVzG3vz/lEmTfvCBFLJzJ92PKCdVv/srscmMvWL08bd1r40nDbeTW1dzx6FiKMHYr9DTAC56PEs6gmpuRdatlS0cv0p0ntXUwuuW1xNO9C6Sc4A/r+DT1HeJoXJPeK6bGBhpe913LCtEcfgmqp4978kDEE3YPPlohYLslqZi7yVxzOzeyCfiXt4TTIlTpyQqrGtitOEkduoYr+w7kGfaFggOf+7UX+IQpsfG/TcBxl4r6xgRMkCQOOmi9DFZnkqy5pDJEsg/L85drc2zbqL5GwaH6vBYII+jWWcg7nfA3k/TGk5zIei9iBRHN47IcS4MRMpIn2LM3CI3XIqm9r5qvSwLTmxRSOvHuv6+0vy54YFdtEPlrH6+2prq/cQjF/0YgYLOf1s3lfeAOtLD0S+fBydf7kg78pALn0C1wows6obuXFD+B4jznnL3g33NUqUmTXOPIUaXaKkLq0ZKvNnDTIUOweiP2XS5IGAy9l09L6n7w3JUN6pBs7IL0Jp3Bc9z0htH2SJpvZMbcncOToopAjBUX3PZQXw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(108616005)(478600001)(54906003)(966005)(24736004)(186003)(6916009)(86362001)(7416002)(316002)(426003)(26005)(4326008)(70206006)(70586007)(356005)(5660300002)(82310400003)(82740400003)(7636003)(336012)(36860700001)(2906002)(8936002)(47076005)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:38:29.7302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c6bbdd-4aa0-481e-7caf-08d92b2a5710
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0264
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:26:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.272 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.272-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.272-rc1-g1aa9f2da3002
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
