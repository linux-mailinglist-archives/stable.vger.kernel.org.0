Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADF735C741
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbhDLNM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:12:56 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:52193
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241721AbhDLNMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 09:12:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Viur5O+pO8/aKWs3dobKB0Kc/rW8YDWG+PatMJsv2n7Oz6ysBxUzkkxbTj7L3G8cQE+ng7+Uq7vy8ccadsutSeuJDyjPjH0faRNwg+DD+bToIBwBxBcSfyD+5UXBaIZMXGUNslY13sE1FUbNXRGpKrFiMQPFbMACS8GCwhpZcvtl1Pyu+BdEymfAguNM3ZMBsE2NTx+9hZd7le60QAEctlpKZgIYzGwGtVplwhOIY1OSRx+7nc7UWTS0R6dUe0gmhBsOLzPg3+127i6C8IqnvmdNKbooSGXRNIHDI8wg9Y1087nxzWElkPMvT+ftX9L3LNQ3LftYmvo+JBSKib4PTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rd/G8IIlDULSjJ1JOx7+6bb9aGvHkcuQexJ43Xi9pAI=;
 b=Np3N2CmhABkAaPkjV6maf5CTiB/vX9Jv3jvbufKMI3HFtioJV479tCmdvaSeFu0qimTXBEyycMfmcmRXVMj2xuLOdA/opcQELxdEqj74WPYGb1CmVrT6412fOZK+GBlb7+6RunaYKGGmiaa7j8K8iYEnj1WyYwIioFMKd4OpWVozpeBq2a4Ndtfw0Lajo5oGHkr3zR2WPgGgU12eH6hJveSmRuUl3ngo3XBmAd7ti1cOzYu27kEHvmN7Pnq1RdeNY0n+0QhZufFNVDOfACN2pMAKfVq5Xcj8xQTA6tn0KxDQn0Gvs3Doe8Xs9jMhujlwUokilrKuJQD0U2oEuUC2dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rd/G8IIlDULSjJ1JOx7+6bb9aGvHkcuQexJ43Xi9pAI=;
 b=Fn6Al4AVITNXgwAnFkQK1xhR9pHVztH999NpITDHBq9XXnyaXeJKFfbT561s8KH/lOQiyRWWCoKUc3F8Lh/ujNyof0P2dXFg0xOxHM/HkaRApX7ZzoUFy4hXw6UkPe9IGE6LQFJJLLFmtR0CAoHB/ZYeWUEEaUh4TdLskm5MOJ3CXVj3kF08IBpWQvvqD2L/1at5aAIu/iOC3EtUwg3sJap429P+HWd2augo6ftBb+EiTVxEHKd2jfH8NrkjAPi0NBrnr0FvXkhObc1WtJTKkZtD6PNAwjfyg1PiqdYhuuO/zpkuQqb+Pw0gqWCry8YjFP760pPl3NxNyjcrZCwScQ==
Received: from BN6PR1101CA0006.namprd11.prod.outlook.com
 (2603:10b6:405:4a::16) by DM6PR12MB3977.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 13:12:34 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::90) by BN6PR1101CA0006.outlook.office365.com
 (2603:10b6:405:4a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Mon, 12 Apr 2021 13:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 13:12:33 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Apr
 2021 06:12:32 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Apr 2021 06:12:32 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/210] 5.11.14-rc1 review
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <18f426bb77954f7898ad64b72d45b150@HQMAIL109.nvidia.com>
Date:   Mon, 12 Apr 2021 06:12:32 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3765e114-9a34-48d5-0c11-08d8fdb4a278
X-MS-TrafficTypeDiagnostic: DM6PR12MB3977:
X-Microsoft-Antispam-PRVS: <DM6PR12MB39776707112909DD355DD7E9D9709@DM6PR12MB3977.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaT9NkfxgoyOhmeGqlrRVkEP9cvz1FR/4uaVw/JG2RinXISkrCGiwdcD1pxFNQf8TLes2YgBKWeDN9yvrFl48cHZVwsblG73PxylrNT2PqjZwuDIwCybV8gGaDMnX8qTS4wvMssiuJ6zuVLjvnvLxaZc+bGtwTn3ZisjoFGJbk9nTIR+0rAODwEG1jWUAIAPmLEhKCWVwS5JetCaSuJV5yFNQFtx5pac3Qa+hnY5TjFuJvYfXtlFnTzxUgQRaCKvh/McwPPwpHDR6cQdLG/J1KX5NHm6xirJWCNRTXY90jmDK7kSSaz45E8ciIqUv/UhK0NVPiZQwyaa7eT7UsjNwE9sdxu7/q+i0T5sYYN3FIi+vT8h05mAV5Sm8xjCjBYTvhfsn19PRHfF5XDFE6oh8mSPEmqTsMDOSpo74GMt0FISD0j991Q4dTk5OxGS9b5WL000pZ5gmDy2XeM55LGaRntqUueZJmzZCYOWEHJzp5TKP0TNk5AzuF5ZTkMlSgJo+1UxVI3ENNBo4iYUUaErGAGAdqSl+Wqfn4aR5yODrRi6WnvEskftEAsPzfE6DXlFjI2+X9oY28wZYaPlQSyJ734vhM5cDNF1Pr4oNtfgAeEJGCtHPyP3al3784eB+FFKfDIUtvvcp0RN1NZSlDpTmLxxl3upqX8hFHT9wesUIS0HvdGK5YFhZUZfYd4hOLjcMTU2OD5xt6Q7KX0nuBZhnUBFViBzO2xPxzty1XdKhZ0=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(36840700001)(46966006)(478600001)(86362001)(5660300002)(356005)(336012)(47076005)(82740400003)(8936002)(4326008)(7636003)(54906003)(108616005)(2906002)(26005)(6916009)(70586007)(966005)(70206006)(36860700001)(316002)(186003)(24736004)(82310400003)(426003)(7416002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 13:12:33.2833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3765e114-9a34-48d5-0c11-08d8fdb4a278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3977
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 10:38:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.14 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.11.14-rc1-g7ce240e32fd4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
