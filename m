Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA61C492FB4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 21:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiARUtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 15:49:51 -0500
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:65376
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345862AbiARUtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 15:49:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFZmMHFlPja9+79mDRoupMqIDsG+FYhX0iGIsRQ050PbUDlVOO3MaB5XRYNNSmOeaEwKSHSjnYlzuRnPPBA7ueivNbytWuLLTzxjloBYri0C0hqwD5H7+ebqnM9lae3PpDPS4TmIXm8PizNBYMT0o6G2nvH2Qw2Ghx3IvdQFOt/HNu++ARMrg2wY4LZtbNKQzMsXOQ4Cv1gYks2lUpFFQQjeFLuzpV3kk58vBtFaHqJzttc6SllIS57WaZA9lNn+64UicsOcKVmJInjjgHvOtaTdqsTQV1Fe3E1lX3WjlyPmwRjsz3QTz/k3CQbWc1g9xz0KTmZKpWKctNHdAXiL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFzWxRqL0ZIrMGmg56EO6n3OpBfl6yrZIfVz9DDjfVs=;
 b=MJIe8l9zRPXZL8+4+X/AFNqizVikYl/MSR4KFoS9BaVQMfcETecQnsmFW3IZY5XsJZ4Q3yjUduzA38fW3RWa8WALRN6Z86E/gL65gZ40An/viSXsKCAa01BoODQ9HuXL/Im7rKzjFtjQWWYfQMnL5ykhQtRj41rvNvXAThycL9jxDc9oDY+5S3YxqP6hEYwOHdYZV/NeAvfQ9hbq4FGvLLvhMrNpB5Mhn8cl/zq/g6FZetsleIa6QYLrebeTS9umIjY0cLuuq/V8v64byqSyhreltfNv4DjtkEuDiW0xl5OYkonu3Pfv+fDmN15Y4K3L2RUgv7mcO6KkhsjrtVON+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFzWxRqL0ZIrMGmg56EO6n3OpBfl6yrZIfVz9DDjfVs=;
 b=n8Yfl8M9Uf8DUqLGeqhsTzpBfpucp92zCphKblFMGSi2Lz4O97ZivpbK2/QvPbk3iNQwhUMgwqgNhaboPNgmjQGpSzlNFUISx0pu3uVW3H4l7mu+fGtZwrJ3HYU95KV76eTQ8nKCyyQShvwoUtEsdfnHHcb1xMDgh0sRFfcebqJRupiyLBXIUZbtOOpgAMKEPJK9cvLVMftscGPMVSQC4d8YqDjfyfjcIlNS4JWDVo2Yw6IWbk7zwr+Ip3BXPlR6Shr9JWjNcVm/8PniRIKFEm4O2qC2Xy23XvGGJwJfWPcMVD1M1ut93I0n965HdBpw5hWs6GeNS9ELSMxmk7XgGA==
Received: from MWHPR2201CA0054.namprd22.prod.outlook.com
 (2603:10b6:301:16::28) by BYAPR12MB3510.namprd12.prod.outlook.com
 (2603:10b6:a03:13a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 20:49:45 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::55) by MWHPR2201CA0054.outlook.office365.com
 (2603:10b6:301:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 18 Jan 2022 20:49:45 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:44 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 20:49:44 +0000
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 18 Jan 2022 20:49:44 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ea2e7ad93791401faadf51973c996edd@HQMAIL111.nvidia.com>
Date:   Tue, 18 Jan 2022 20:49:44 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b732fa7-e92c-4cdf-eef9-08d9dac40f3a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3510:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3510A2FB363AB702E9F9B573D9589@BYAPR12MB3510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Rm3UwD5EGMD679tCYNaRBnUZ41YShptJVH1LRx6Wm64J4zV1+lTgwB5VWG/0J+NaW5SHkQU3DpVloQfP47hej58m4VPPSM1kztT/1deq3mUfb4n5as4LNrnI6jk/kIiku4ldyhQtLWBL0qCYj50dwGApbo2Tcy8FW8uqVfuIfq+BiGV0ASVC1oNlv84gIXHb4Ow1se2jRd5QRfnTdflkaY53Ouy9QFvnZi9kAtJXVBPFaea6ddVKaJ5TS1UPyPhktFbNKo5Hp8Gyluee0RdoieqpOgbaNcn4Q6c6yJvJGNBFG+dGORKztzPFJg3U6VXcxKTHrDFUpkudNCohrbcVKlOiws1DDH/urm2Vap9Lb1D49DmD+1e4NZXjAZm+VcJcUsDJWWPeopOZIrWu8pir2+kfsFyKMBzeE+gM3RKbJXCijfCdSLkdSA/iAM2PMqWopAQFkUNXPuR80z8MGyfwHmUoyPK6b32vu4h5/P8UdwBM6WVnOLIsOYl8ieVUsXjvObJ0Kw84UlxTciNV+v4/jvqGrykRfbJqvWXbGwhmLnAJ4Zs8fl7E5Qc0QGqn+09QHjp16mFgW5tWiWUFVtI0lt82Lqmso+8HVBne3lFQSAvLAisCc7T1jBLvj5/KFjl4sKJjZFVtr1KKsUnK/bGJ8TIb3bIZsFzNDIJ9SWh+eR8PlQdaeBL8YUrFMKU7l5Zu2MGN5pWP8nQpzMWl/bWUFxVUVXC47wqC7HSa3M9DWqVJZRQKjcpJKvqPC5gV8bpC69oUgA35QoypYO3myr0+TXOp66+mw9b16iUc1gqrYlnfrOtegrcIb6VQPj8LoMIInT48dXDrkozlHPeQTDnsVdMnwqkuMSJYPf+LcBeiu8KPaWoM1AQXLIoE030ogwr
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(8936002)(8676002)(86362001)(36860700001)(966005)(26005)(186003)(7416002)(70206006)(508600001)(2906002)(82310400004)(47076005)(108616005)(24736004)(81166007)(316002)(54906003)(356005)(336012)(70586007)(4326008)(5660300002)(6916009)(40460700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:49:45.2507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b732fa7-e92c-4cdf-eef9-08d9dac40f3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3510
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jan 2022 17:05:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    106 tests:	106 pass, 0 fail

Linux version:	5.15.16-rc1-g9cb47c4d3cbf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
