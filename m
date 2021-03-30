Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1634E488
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 11:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhC3JfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 05:35:14 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:33761
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231801AbhC3JfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 05:35:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiQmbrFbxkaH/oErSbNVDy/+mFluh4EqXf/Ne/ncDMht2Pi13X1Ksxo1obvOO6Li67euayNWpbYr1Mo0ibDepIUWg8/UuSk/YsqUbxkRPvBDvn5vnwavnTnMpRDaQJcDdDZFIUbd30T9LYygn8ZK5No8kA9TN+Ewzhuk3va+71A3z8Ch+S7PFtuXdVr4qaJ27TRlULEhJhh2fLgKM3PTjuGXhJRDgQ2Ish8/OJt8qhNGWwSKPHZfeJJg8H9Z6VcULoEhUK5cl75UlWkpU2tdtO0tm0mVnATGgw0pXE5SCGbvvJu9BeN2Bq0h6oXX7jVcBMnc4Wu1hSuWZRrUbz5Pbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiDxXAYjX4rDHml3Qh1/OtW8bgRcCCsUfQWnFCt0Abw=;
 b=oZ4hJ0JSkaXveyy/uY+PvpKM/Y1XyFJ2mS2V6jpRwsrcLsxh1SWjIO5i+4OnoUjzN2lG6gK9pJ5gonywDGYrdK1xyu8jZTHyZSNWJ08JvY9wZPyptClALihyjy0EiiCvsnuGxieV178zEI1clWUr0PZxn/T6HkUke2xla+Ah+Aqy45WNAybkiZ/9nSrn6aFHE2xscxufKsnCpqsiq9HLBfVLpc87TKfuJMF2jUcEuDJkSErc1AoOUvkyIZVdcStg+IVpI7FKRsezYyFtGoR/yL0rLVy/FCqptBBJzNroIH14P9X8APmJnLNrJXYkgfAmwIRXHwlthblhAG3qT9a9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiDxXAYjX4rDHml3Qh1/OtW8bgRcCCsUfQWnFCt0Abw=;
 b=jYuXS6KtrRfQDTz99ceoig+YxZ6UU2Tu8IgixX3uO0rZDUC6lYiqCCqyUeEc+OB8zfbh2+cui3WTYJJF8v/7i1U21iLg2lCCITJMRztZOIDDJUhxI/sc69R5LUkIbUK5s7DGfipRfBwZlLV7uVowEAuoddRMXofqgzEZbw7MgigyHeRVDg7nkPIXk6iRbT+fGEvYTCSqyor5h5U6quVENS+aDRK0hq1qSfalyV0reoj9nU2gzAx4bGo8Ot967AUMo5DPMMRZzi4awXw2fya2sTzEkezwx2PO7/lmViMF5VAHxEmLX7L9A9ktPwmbI4OjYGjptf6S3IehOrl4E+nrTg==
Received: from DM3PR08CA0023.namprd08.prod.outlook.com (2603:10b6:0:52::33) by
 DM6PR12MB2826.namprd12.prod.outlook.com (2603:10b6:5:76::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Tue, 30 Mar 2021 09:35:08 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::c4) by DM3PR08CA0023.outlook.office365.com
 (2603:10b6:0:52::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Tue, 30 Mar 2021 09:35:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 09:35:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 09:35:01 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 02:35:01 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/33] 4.4.264-rc1 review
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4e09105ab4f64e7bb7e2ab0e4306d6dd@HQMAIL109.nvidia.com>
Date:   Tue, 30 Mar 2021 02:35:01 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d7c8961-c8f9-4364-b9da-08d8f35f1a44
X-MS-TrafficTypeDiagnostic: DM6PR12MB2826:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28263BF9DDC675B96F7AB7EAD97D9@DM6PR12MB2826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gdnGNYXx6RFhDcoOIGjlX1Kam7e2C8YOomqRGfhZB4kAAOWaCeVCTkKmZu2Bn5494hBod1lzKjeaOpHkogHwDdR+y3VqAeKZjwRDszh7zYe8+9coBUoOshZwDoE7zdk0OjRPKhbaH9hXgNEK4Abnrd+2hjaIH08rCPBtq4VYMULEp4p3DFBqh9UJbet9kFnpJSJzLWmtNBE1EoqLXUauOPNDvScqCTyqpUXeSfEQgvT/o+HWsj7wwA7qYMLwwtnpWPpbb63XJSn/usiYXTTbd4AxRYX+6jgalcCDDHS9GwEjCACQNITXwuTg30U9eLuG5xUtgvaKj3BDcap4jSEPk64NU/vn7/WkJTk2iL8SpbnF26OT1+DZpw2bblpOeC5Llpy7r/dKRODMvjyfByWFjgOfVhOiZs4Rc77cZzLaqeKev+jwAr3ON7LZQx3J4xO9BEUInFxe6Z16YptwgV/30yjX6K8wIcuvFs+F9dfPxbenvIZVOKHLOeb2vZJetMP1CH/y11oZJGDYcqIBRtkURyRQJyuqythxVQk3jZ25kfKlp95KvOLq+0LdIz2jwyHxmzaJ+F94QZCXfk/dnlp85V3c1bWNKO/L29KuDkbZzvlqlzq1RiZaxnRRgYf7ldPso2LqLCshPaHOK2Ct1pkvkDviS5ODLOos/N4a3yIeZKCFSKUm/88y7lMra0cgGH/EBIsqQQCKUImDQur/0hBbCQhv6HyEB+wM/GWsHmArNM=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(2906002)(316002)(5660300002)(4326008)(82310400003)(336012)(478600001)(8936002)(86362001)(36860700001)(36906005)(8676002)(54906003)(7636003)(6916009)(47076005)(186003)(108616005)(24736004)(7416002)(82740400003)(70586007)(26005)(426003)(966005)(70206006)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 09:35:05.9770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7c8961-c8f9-4364-b9da-08d8f35f1a44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:57:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.264 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.264-rc1.gz
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

Linux version:	4.4.264-rc1-g5fccbcb46b88
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
