Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400E935669A
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349576AbhDGIWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:22:13 -0400
Received: from mail-bn8nam11on2060.outbound.protection.outlook.com ([40.107.236.60]:58913
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347496AbhDGIVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:21:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm+sY9i4dRv6i6Eo9BeCT+evuuSLxdXMgJmlgpK5hPKq9wciaOX5LaqQh9WlO0YtP4cKYlsm48MqBvShhGaby2YFMBfhVibNb/U+LTnVdUhWZJ1twPbPE+0xdMmvw6dTLEkwZdqoNJi9xc/hHWxP7JoiLN/Gh8NtqCAZqRiGEczlnAWpUu8TcCD5QuUMRw8QTAb6x+BGpHZdLSTlBebyABo+jtP4PiKOUdwBpEieGYeQG/WNAe8DYnjH9dcJiVtL+/vJRORPcoElFHedLBfhD/PvCIb1AYPnEX6IZfrpupSLm7H4eiVQbpWBwirHZVCY+gaWZUZKoEkW+w2Z6mxplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdoWr0BDNf+n6uISnlH0/zH9p9oYAIDdGy4D9QKs2SQ=;
 b=ET2bYyzig37E0dS44ML4W7BAKXJ5Gm7YUnEr/kGH3ShoXlMALKIJp/F4GBwJzYQTVwA97JwV/My6GHMG7yUAIo31mUZPz5bvU5CcQriGaV27KEAzp+Iu6xXTLwOvLghivHOnSiLNI9tswhv1LmRb6BjaG4Pez0aHw4L5Iyo1rF6nHSHSvQ07KBo6kP4WT5PpHhY+YBvrB1ZjdJCPYVnnPrVoA0GN34l65frD/KiqN5fXH00FC28g8WL8PyTr6EH5XiLdYd0qgdmgU1mkruOqeU/cBPUL67NTkTQtFP1sLAmNGxm09jr8lqhsh8xsk/0ZWDzk8B4KQg+X3aw4+RfoBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdoWr0BDNf+n6uISnlH0/zH9p9oYAIDdGy4D9QKs2SQ=;
 b=ueyzkOV+6Txvyx6ji4oWAiu8y6u7RR05Q/1ZJxNX2fhARokRiE8FvwEf/KoxuLGesq3bF9Aj8KOb/IhZTbjWYpTx4OoF757mG5Os8SFM801V1nhdNAVQxNKlUmBbhkJflM9Ghhj4dhBiDf1gqmtXfXv492v0E3pX5ejNAuaqc3bRlFbOj5FU6gxbc7jRTf3P3CqTd8Ua1zzfh7IUQUFvi/0vUUqYwENSJlhU5stP0xKppOiuu6sp2qfGb1wsmHs20Stgl1PSMsqMA1/7USCbcV7fVqwqq5PzI1O9PUrQVSo2K9Ir8GbAEfKa8gDnABtHlwNVu4R7DVojZLQs9uiV/g==
Received: from MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24)
 by CH0PR12MB5108.namprd12.prod.outlook.com (2603:10b6:610:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Wed, 7 Apr
 2021 08:21:38 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::7e) by MW4PR03CA0079.outlook.office365.com
 (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 08:21:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 08:21:36 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 01:21:35 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 01:21:35 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <0aed01725fb244a28172c79e21b517a7@HQMAIL109.nvidia.com>
Date:   Wed, 7 Apr 2021 01:21:35 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 667e917e-1bf3-473a-eae6-08d8f99e2934
X-MS-TrafficTypeDiagnostic: CH0PR12MB5108:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51089E088E4C6351A16607DAD9759@CH0PR12MB5108.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKlpHehp9MDZBLVpAjRo4ZgG0EcQptKc9UwHsGdVSDlF+4FkvVg5OAQlsnDoVWH4ofbjIbB2NtwB8wSFSlQlrdiCHyLty35vI2fApG6IwRpjLxW8ighvsb+TfTnfO7XyNHBLlHz54MH/wcsZhswt8JZfPvqylIMfGM3KmnKHcbKDTyjokqSMgh0uGVF7Q0MbYrAEom+Q0o+fq8u2tWZrNog37mEoygEaT/rODFQleFdqhz6v4Ht6ndcZ1S81lZEpOy8bSUlyziZiFEXiSEOaFtb2/cxzHN+IVfo1qCfGNWuyDrreHAgdvLmeLYdiCbUQVsUA5TcC96qJ+LE3pBC3tiFB2H70X0AJtNaIenrIfLVgQJNLXkEtoG0DM62lilEkrxOCn6Tmefcr5DvKRMMLEY/rd/98Hy26LeTt2Bzf5eTTvMOD9lF3PqwzemsnEeU/rqjW/ksc2+iYxbFBtJH8qN5KcvXSo7vc0qwVVfZw0dzMuXdq2F4oN+ZZsCKk8aHTmlXxdhAPzS/OAmIXsjgmlVhNdjAifsXQKdXrSEGf0t+hGMd/xPY7csNXjHzB8jWw6qNoS/RvK5fU0AguKVrhAXjk7kgtuCSwkS3eUniusz0wg52DqAC/51bvdG6EoNW96bJSpWMI/myT/dFGlOi6UnxA/VB2e4aYvD3ipieYDkeJWWNibwbazEY2ivSnIbzxrOI6kUNDADv3C/JfTFr4qveI1fjsLaQ+ioSSZljUWts=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(426003)(5660300002)(82740400003)(36860700001)(70206006)(70586007)(356005)(82310400003)(47076005)(7636003)(8676002)(54906003)(316002)(6916009)(4326008)(478600001)(2906002)(336012)(966005)(7416002)(86362001)(108616005)(24736004)(8936002)(26005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 08:21:36.3758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 667e917e-1bf3-473a-eae6-08d8f99e2934
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Apr 2021 10:53:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.265 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.265-rc1.gz
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

Linux version:	4.9.265-rc1-g570fbad9f4ca
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
