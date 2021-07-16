Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971F03CB6C0
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 13:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhGPLgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 07:36:44 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:60928
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231386AbhGPLgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 07:36:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h10hYKn/EviwTcpn6MRzwRprh+F+2WnIzYQZS2cwR4FMAgheAsxCJeAJHUv551P0p/3riqesKviLzk1rhJp8RBl/KyJVahgcQ7HJGhjIE3NCsWfk/1x60s2WPiTiU0keh+Kp1MvRIkZWgPDULPh1syIQdFkuhX4EciCEDay/zVkdH0wHLdodOaggZ74W6FE537kX3VHaVallwLayfoOv///r67rD1TggkLj5ADt0VoEU7W2/EQf1oFAlIu27ivGu+aJsY7WeyNgGUpTMNrjs22EEKHarH3NJ9YzfFISkiOMTioPzckGu8FEDBtHX4rbdqplSdG78VJ0BI2BYJrV76Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKlfGL7scOTVo/AwN/tcHTGeFg8Th+qND9/XRFjg5Pg=;
 b=NW3j8diSGtKiIp2U9EHKE3KGn1gFCCUoR7T4X0IjcW7PSz+fkfaZwYg8A4osF775/GChmKhY+jsNAFmV2CIAtMrjLrS+s/mTYTbI/Sue7VjD26ZV6MLNSeCRLkpLJofrMcy4OHKVLc3hX4KNPttUbh57GmqkJWmJ4pzn3EHTVTNGJxdQWD5lZfEyG79eDpnaFHx99E0o80bZT19SwwWNIfaJyPlVpJJ5JI09lueMa/Vd+UunjujCplwg0Bj+xi2nexpkyaPaMpBP3CBfwEWFEZiW2ljCoq/OZzdWl7dEM9vJR8D/lbz/J0eUU6CDvNn4v0Y0aPr725OIJ56JwtUzlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKlfGL7scOTVo/AwN/tcHTGeFg8Th+qND9/XRFjg5Pg=;
 b=cY88Sg2QW2YAM77SZqBEVATHBn1xNmid36hUy0f5MEw+7DEH99BjrYl10rRWhBT4YcXmpCscJIswszXttsiXEYnu7B9zvkO/sS+YieQ9Yh6ge8oVeHqGEmdnJdqq5WaLFI13YjQDVtfrKPQM4hmX7PjPLsuHIHLomcLczdhtZwQF7o2BQyNeGbpji3ae2rbu7hUcl0Hf0zQZDeH9Hgzw3gizZOj5hBZP8w405t63n8g+HQQWn1QltUN/u0MJMAjTd1f01q9NItWflD1FoPdXqzxoc0dudGhMghu9299yAff5bX/3DvPXLr9zKJjzCi2dfLeqEXUxvHQruD+DUSGqBQ==
Received: from DM6PR13CA0015.namprd13.prod.outlook.com (2603:10b6:5:bc::28) by
 DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.24; Fri, 16 Jul 2021 11:33:48 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::56) by DM6PR13CA0015.outlook.office365.com
 (2603:10b6:5:bc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend
 Transport; Fri, 16 Jul 2021 11:33:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 11:33:47 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Jul
 2021 11:33:47 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Jul
 2021 11:33:46 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Jul 2021 11:33:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/122] 5.4.133-rc1 review
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b3eade2715ff41cb93b6176116be41e0@HQMAIL111.nvidia.com>
Date:   Fri, 16 Jul 2021 11:33:46 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78d8b9fb-1b8a-46ca-a29a-08d9484d93d5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5229D3B4AE6115AE420631A6D9119@DM4PR12MB5229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Hsa+JGTIOd0e7C1GyOoEpFOB+/MAShhBjoiq2DCW8cWnudKSrMEVYRtNMIo3CxTLZR9EhUBpzk+Z52pmF0CQ6hmCL34NNZRTSFooox04ywWSKWltjyuDz8nqDHnYcYaCvaou5WAwJcUkvXWHC/bqewrhzbXl5j6olbd1KWpEwCEnVtgj21QWb8yQY7M9QIX2kkMSirwFBexEaDeAlITkRQQXF5IMlD4fLsAwuHSehMn6vD5B6lYl3mkAu/ufd8w6oQrH2Z8rA/zh/x/uKc3hlF80NOFAzhpfMZq+oA+hi9eOf+g3bw52JWBB7klvAAWtcD5s+cgsue1+cAmTjUazjzuq13Jf2Q5jGcnEYzHBIPMnMb92IUW6JpBN4ZWX1FSxv0Xub3wLvedcaqa84r7EXgeLYgNCdK7/N64gOjJ9bMoVezy/ciHSg9ohxCsQ4afp/kB9lQtkOxNTHPD/HrTtSh0v33pD0w0UGl1iMnA+mGPRbO3AhvdctvUK6Do9j5cZGKYwp/b1RFOjXqsjQ2b7HAJX35/pGHOIpRHD8aaVoXOoFeGzkImF2FRDj+UyJidpsbBdsGlMRuwzE8OvZyjP6LDWE44W1JOgNiJPPc2ZBYTIWcXAQTMgw/GvXCkyi8DLZRpZTRadirw//2dNxaVZQwsV8FHi8CLhXcDs3drzxcl3jJaDgl9BCWh+9JGQTn3uGyW6dkmEoztHCQnXNRRqKtoFlfloULd+uHkKLtyON+aeA2yXkU7P/85tH6YWscRag++gJhw5d630ccUKjIQcpy5zDdcxgASWWQkKh4XTJqgxgyE5ymeK4f2WoXyUp/8
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(36906005)(316002)(70586007)(6916009)(186003)(54906003)(36860700001)(86362001)(336012)(426003)(70206006)(966005)(356005)(478600001)(26005)(108616005)(7636003)(24736004)(7416002)(34020700004)(82740400003)(5660300002)(47076005)(8936002)(82310400003)(8676002)(2906002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 11:33:47.8399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d8b9fb-1b8a-46ca-a29a-08d9484d93d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5229
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 20:37:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.133-rc1-g65e3ccda8c26
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
