Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780D73D7234
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhG0Jmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 05:42:37 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:1865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235897AbhG0Jmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 05:42:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWrSyl8vrChF4v0NT8j8i6cLqEuAylM0sYfIixvEdSSOXSlMK3dk3nnGeC3SmbOsjfeQcxNWWBCIxfWyQdLVE3pQ6m9SWCsHQdS6xb7Sd+ip97L7Shbp4PXREKlUEIau1fSdFsLTOkP8yUMkRSeD9jeLuHcj+qWaV4z/QiPE8Qk1iUVivjzQe6lZdwWTUA6bIfhj5ikfzGeAm80aA1mqyeRm64M5BTc59nXeoZq/o9odmbeRjELhj8W3fkAIFezw4lPntd1qFMRBzkHfAyGkyvEBE1JHwtA/Ftgw+UGspubEmc9Z+zEzd/rSP4mSP3Qq90VB311pg+vuJFESV2Y1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVrcZe5ypGGUdHwp4QQphF1IitUxwIqrrV78/mIPOgE=;
 b=Sj/FbLWk48CynaLyaJW/nr12/vZw7LLhxEqlaBiVdGPu0dmT/+pjNj8xQUjbT+7XvLU3rmhO7p7IO6+az+YKwLoRLyPTYyyCgvLnWNRfbXxNkWinhcRNTADmxZtnnG4ZSt0409iuIEBZJfNNY/KkM9wzymGWiHxwDB1BxLIg+410z6G9TX/5qlWar2Eva+UsuBX3etKOGVODsWScHJ0nqs/UBBp7jP30lzdGu9fmWHxS28YYdQghmonkdes+MnoX6CisTLLFj9hb52xwwYwXN1jY1YRkJ3S6T942wpfkcCAEu2zwur4sVxS/tgjzJ8QKLYfg2icuCCFsFf2SNL18Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVrcZe5ypGGUdHwp4QQphF1IitUxwIqrrV78/mIPOgE=;
 b=S6CChTTxuAnpKBcBpO0yvqcWPEl/utuxzcicmRHGhRAZ5ojX+siufH53K6OzPCda7LTCbNuLG4AU7k+cNw1EU4y0Q24HsL6VTQU2Tv0zmaVFyAbq+JFFSkUe/hswNOPWoyxW6rBEb+7F4bpm6K00oOh75x9FnEbdlEjOrb0DGpZA2TSvrzlVwF5JqyBKDC8pqTr8T/KhMgVWNDEC1AmWRqE7+v5ax967w4sityDGixnYt7Qqhz4W2EIfb0KbxhpLYU9q6fJOynNa0PUC8xhZfoDy3PFelltlXeLIHfxRmZ8BUSKzkX1vRTM0umT9THMX05SGV+UuV91+Pz402+n4zg==
Received: from DM5PR19CA0070.namprd19.prod.outlook.com (2603:10b6:3:116::32)
 by CH0PR12MB5297.namprd12.prod.outlook.com (2603:10b6:610:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 09:42:35 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::13) by DM5PR19CA0070.outlook.office365.com
 (2603:10b6:3:116::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 09:42:35 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 02:42:34 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Jul 2021 09:42:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/118] 4.19.199-rc2 review
In-Reply-To: <20210727071938.046014616@linuxfoundation.org>
References: <20210727071938.046014616@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <66b00c0e3e35499da13446f109463643@HQMAIL101.nvidia.com>
Date:   Tue, 27 Jul 2021 09:42:34 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c59dd488-e66b-4a56-bd71-08d950e2dd4b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5297:
X-Microsoft-Antispam-PRVS: <CH0PR12MB52971B8E0E9BDEA1D39A8E8CD9E99@CH0PR12MB5297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZ6h+E6nc3TGlLh4ghHtyW9Y40BONC+GiOzeYLjMBSAdrQ/sy7ipd/HKxg32+uEzFaRzLmmYKxd6OqgC9Y+TdCBLsm9waVAfmbKTt2/FuiN/3/s8XzzM07WVywGMMGr4a8/6BTZc72dKYCwaLQxGzmvEaQSgMPzBF+Wo/WlaQrJ4KeVGrcv+mrM4Bo/RxX9OGeu0cQvmiYCMn9fWp03EhuymFLHeTdi/MwUFZq4Dkbke02A92UbAdiPaVHwoghni59OEDXmVvEJgfzv82I9eZXDsFoNbsmqGi9plXkf1vL3kx++HXeogrGQRHMLKTMu1EJDP8ixvs8pRsDLx1DkD51CXqyr7O/hoCXKTRu4qzKim3vVvy4WSQwD06TR+CrDn0I0h5ZxYts42f0t/WJi9mSL7D5kwoAQDSsP4paSgvuC3iDNNzabM/5zfIAf9CAjvDSFer1t5yyQK3P14LvSSir3EE471jBf4JOTYZiROxE8K1neN4bfV2lcFw7e7xaasZPT+G1D36F6zH2eAkRGn/aCDdlfg1DRUi8+u8IE5CBNFh0FhAI86MZl4rbyW0/9jfV5TzgODXuqlC+g4RpSygUhu5nOSDAD8ersPa/XtlVxVK5JxNiw9g8I8PgMQtwexzq5jCapCmtTQ6NH8M3eF4GCqt+V254J45tv3tkSmU1I4hwl5rJtKPtxW5gqp6KqsG4Xe3xBPWgQl0wxve/+VNTvG9uk0bAAxleke8ObVpZBePyWyNOs+ELIeYS1DP30I+eZc2ekVyNsqyCpA06CgXUQM4HT69LOvJCIxyaPndLo=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(7636003)(108616005)(86362001)(82740400003)(2906002)(82310400003)(36860700001)(478600001)(8676002)(6916009)(186003)(54906003)(966005)(24736004)(70206006)(70586007)(316002)(8936002)(5660300002)(336012)(26005)(7416002)(426003)(47076005)(4326008)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 09:42:35.4195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c59dd488-e66b-4a56-bd71-08d950e2dd4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5297
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 09:20:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 07:19:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.199-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.199-rc2-g5af2c5ca3767
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
