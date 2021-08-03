Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4463DF0B9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhHCOuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:50:24 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:48727
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236687AbhHCOuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 10:50:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9fRYg0eaNouSuVi36htwSoMCRFjKXjqXLem2VH9krEGBgKm7qtsKq+XNweIWJoGHsc+pCTuMuoHUl9F56rfLnZEeHMxNE9e0LZgnFhziCiUzj29pc3ttdZidnQkrwrLSlR8CVreKI8Jg+o8CO34l5DjiMNeNjxpBc6FQcJdA6aVPACeKxN3l3QehUZ2oKs62hlwUzTvv36r+pDtnEJaz4ZsxSxrQ2HWgyUI1KtTYnF/CJcC0zixblu6BoLPk9+RUnTYTeTjWzMPuwkkYNBcr1JA/6eKRo3XJEE4o5ERg13nuJ/8OsrM44LwuSR3u7T8q182VkbDFbWJvLxs17U68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr23/BO5Vqrh1rMujh0jmAijVo6FVUvFGEr4Byv9EF4=;
 b=N/kpl89jK5i1ISWXzoDoDJp9B0wk1oWxePRQFzHt/g/2J0G1H5juxFNXe9qBx6SZV9P698sd7Uj9PStUS2RVO7pNuFQrCOEoft+ORAV6ZPAyRM6XvE4opY0zuh6ojkdFl5B3peHrOH0qPnD385VRMt33OQddmFdUQSU+rY2Ujc01x+80ozmf1k+yFCH2vPs0F2pZWtTFzkh/VhIkDD3/lPQ4hpG0CkSpsG1wdLh1hrWJwA3dWODMI+yl0wktUN75gmmfwDjFKjzcn8QtVsHpAoQw/9/BfsV+l1x/8bANZKjufw1fsSd3+JZIc9hQPkQq1QUdb3vDJ/cvDm2nsAkW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr23/BO5Vqrh1rMujh0jmAijVo6FVUvFGEr4Byv9EF4=;
 b=QJMVtjqjKbMpMdtaJXkC75q+PDWpCr8DQ9G46/cglnUx6xH+F1Tg2AZQu9LNrvlRY8mES0GNB/c+YchyZc3QhmJ+QRm8cICdPAkmXS9/rlnxGLuudPymLc6/Mb8uhmiVBqWij6RLicP4D6VUlSWEpPmhXbE/KywCBT5wVXsonJsRmrqyX+yo4lgpDdmCHGCIRx4dkBYnFF3gWUo58qJCUcxqzHyKCofO2RqjH9S8vp8TwzK/r9XhfOzj3U+rKBvpF1Twutlhmta5mE+31TPN56xApCWWuHtL6lr18oT/62E8SVJs24CAOScQy209lYHS+V/pxj9e6GFBcK1o/1hMwg==
Received: from BN9PR03CA0939.namprd03.prod.outlook.com (2603:10b6:408:108::14)
 by DM6PR12MB3689.namprd12.prod.outlook.com (2603:10b6:5:1c7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 14:50:11 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::55) by BN9PR03CA0939.outlook.office365.com
 (2603:10b6:408:108::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend
 Transport; Tue, 3 Aug 2021 14:50:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:50:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 14:50:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 07:50:10 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/32] 4.9.278-rc1 review
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c774860583044a1da9bb653dfaa1a68c@HQMAIL109.nvidia.com>
Date:   Tue, 3 Aug 2021 07:50:10 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a3f523-2006-46e1-3f95-08d9568dfe94
X-MS-TrafficTypeDiagnostic: DM6PR12MB3689:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3689CC6AF6B3D61412A432D9D9F09@DM6PR12MB3689.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/zF2El9N4dtpUkxSjewFonBtkwDKxtBvpqNmREi+xAMQjktu2IwhJsNjRCfgrOoVsVcAzKHi8TRQqjxeNLEaaRFc9xawWCDJLn9ubc4PNDvnxEroSRi933I7178qKEp+8xg4o5V4tk0wERASVNesSI62wwflUzEPcBgtn3WjZsSg/5/Iuerv/C+o4cZFZ+9K/lxW4CsD6Nn70V7FE7d7SercidsmdRHktxEw5eBw5OFAyhgioODo2ugIDQdR54rrodE2Ix7zlKGe62aA+24GHIG2pDzzKjYqlejrDFPuB5YI6bdX/KvA85GiB6Dp4MnHqfkZrCWDSgvNquU6q/xnPus3nofPqoJGKaYnVdXfeVPKDhNeg3nj0MmRgH/fbs1Jfx8gbE4UcEn013K9d+SpJMJqVW7hEMi+ZQfODeZlEVGQ6XQmoAPRAl0RHguRHnFlkN6pVsHTLP3GB1h7B2vebdxHcQRYW9qSLQK2xTeJj0vWbuV6YtsgcqaThiFHVY940bu8gyOuouRrpvrEQHmzn6qcQRJlXGeURyrbxbqHWkRp+2Bs4O8v67ar8UlWu2D0ZwuKeD7S+W5Mla1rIKAI8qG60ulmxXCDBTzDSx9Wz/ZhSUMvwU07tKD6EWbzfcAFY7AWLumgsQf9162w8dDaN1f9+R758sNpXDq0fsQqmbwT2xCJ3veeiVI4vKLkWWtjZHjp/7pZFW6QPEyk3GKvucXHylltUEFfZCknjTqdKaTHsYsmRp8WsRifMXbuUYT2IMfa+qwzeAgq7AX3T4OeeUYTB+b9KwAfQz3cCDyYVU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(36840700001)(36860700001)(26005)(478600001)(336012)(426003)(2906002)(47076005)(82740400003)(7416002)(8936002)(186003)(36906005)(4326008)(108616005)(54906003)(966005)(24736004)(356005)(86362001)(6916009)(82310400003)(316002)(70206006)(70586007)(5660300002)(8676002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:50:10.9052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a3f523-2006-46e1-3f95-08d9568dfe94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3689
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Aug 2021 15:44:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.278 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.278-rc1.gz
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
    32 tests:	32 pass, 0 fail

Linux version:	4.9.278-rc1-gf567818b24a3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
