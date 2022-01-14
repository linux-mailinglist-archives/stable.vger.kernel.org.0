Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBE48EFB0
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 19:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbiANSKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 13:10:21 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:30976
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244078AbiANSKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 13:10:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyaWLrVNqIH+M2plCdbsq2xXd08nGembroSUuZD5ttmcj/qsb2U9oWVzzfO/fRfopPrdWQhkKHtR0s0aelAh97N7/5ZOgIcCqrt5cYvCKP3KyJMr6l2fbvyWxjH7RmHN6/m1PR4WjGCnofrySf3d6Z1DTqmuWxCl8qwpKu0HRtUZXKs+qx8dNJ9PVew+OM1hHFuiAjcgDm5HL5jF9i+5WyMIFtlu/OLOoCkEI6KxK72lzMI83QPQbBXHj3crZdXvhPkBUsHFf+vg0LPnTEcFXHa/jBEzqAtHCcUOnuLf6uEytr3cOKdSihTEk4yVYapiXPWdaKYMH7cZZLw6fsklyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyYHG9bEuaTOAxbwag52B0uzqZem2zSu/cqmZ+Ugltc=;
 b=l1FjmJ0OscW+Wc064qna+5vV0y3fDSFPGHwIib1IbW0CbRaSXI/hKxho+tE+netI7dR5thTeNGEwFPbvVpue+Ou0AfP9oZIDLAIuNOLDuvboAwCnesHzkeFicFoki5doQh7XMh22uR51zvzrw0Q2wAs7DQWpgHdCTrjtuAL6CuqcYWM7rOXcB+OBWEN2FmpF4ZM01zQ8oqiGIKzJBBk3KPSBnmjUCp1y7Pm862G9IH+kvdoXbvezdajCG0NDKPh7jE+KG9TfUlystPLwgr9D98u3Mhn+Y3xB8YGHyojfDVOGnIX6ta1Oy2BntDJQ8XT4Qgl2UxapSsCfzfYuxd6HKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyYHG9bEuaTOAxbwag52B0uzqZem2zSu/cqmZ+Ugltc=;
 b=Ia38jM6A6lPkVJHNEQeQ8IotsU6GROmvI5SNRGzsfuTbOO0cJfhuL2VgzgDjqdVwfWGLyuw1g/hqchSu2Vydhlk9ugBDJDUTyuc5TBxtLUUJmkObwOUZ19G2OGm0XqILllb6EZbqelIt7zHWpkASr2UsKC2fy2IQd+MxYLZM2CkWVIJYfnYTcdJzpM2UZRVqcGdmptFVGS+7OFUpHt/E0UtvDXTV3fmcrSGoyOKxa3uia8TBNCAW/kchD6H2W4/27ToJiouMxOrcRn67yzguXaSNjEAapiIk7WgpQG4MnRgStS5MXZ7r+XNPk3PbnPD804q4cm8icO7M8fdnXSe5ew==
Received: from CO2PR18CA0059.namprd18.prod.outlook.com (2603:10b6:104:2::27)
 by MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 14 Jan
 2022 18:10:18 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::eb) by CO2PR18CA0059.outlook.office365.com
 (2603:10b6:104:2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Fri, 14 Jan 2022 18:10:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Fri, 14 Jan 2022 18:10:17 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 18:10:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 14 Jan
 2022 10:10:16 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Fri, 14 Jan 2022 18:10:16 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <84d4f1165da7441dbc704485e3ab88c5@HQMAIL105.nvidia.com>
Date:   Fri, 14 Jan 2022 18:10:16 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aac384d-9d31-46e0-166a-08d9d7891ec4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3181:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3181C6D1ACA872DB9FAF8F82D9549@MN2PR12MB3181.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fryhH/V7k1jb9orgWBpd6QsbEuB0siu/Dq8G7sFCYbgUEIg23mSpTSIa4RwkjWNjH9Kitz35lX33zYJtk7BIMkLorC4joC1tuvQIjeJErl06C7oAF/wXYA/mN6Xd9mbT0Ip2sFQ66JI7Ml48A19KzpObyaTLZdFGRoWhv9vCJsGtOEyp1CW9aXOXzT2kFMTKTIsKoSyCeeZC7aNk67WeFCA4lBeLBuzEWmgVOFY8SSmLjdVp9yoTH0/xY/rLtceVYQ0C3uyjWehNu6ZxvUD5306/eINBT1heJeEcEH50cX9u2KOkJHQrTopdP6Xsf96HxfGoNrq3H1JP7XRFMqO3NwyL/lq+Gvz3VQPVb0TgdT9ugkwEgquAfU4HKKVVmoUF6LtNIIKc97AcuM6dzwBk0dYOZUpd1PGxFDgeQeBCtZRtvXQx8IKcoz5vZwtCu6Q1XiiwQjnjd1l9v8mBpXhiuElyL0YHngfk19IM750k3NaQh2r4Ab5nXlzJ3a61JPuD/esGAv8xI6josDp4bbAms+GRvQYpfeuZ4IIOHxkU2hIfcP/z59AlB/8g64FE9VSFAkqZolGi61MY4aWifktQn1c15onDJfExVuWuKQscVwrBFYt1HlP8UjV/ZXJVljj1c8eO0fbVXhwtzyIeShYfSb3y4fw9Aex+ArxTzQWvYuI8hcQPyPbnk93KCOXHjaFtPbWEp2JXw4v94GUTu5Azyj9hTjMmX5DTwHOhY19eBt+I7sxwjpiKWLe6bONkZoSfVtQytzw6/1pNyq9LnARYgqifG1vNH07eCCnCTSoh2m/dG2CYCsQQrpqBuBCezi0lsU4lLsoXTKh6fGYIaHyzExMoWRmZexyJdZE1xrQw2igaIi7vXSX9BaT9ZS+KSrah
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(5660300002)(54906003)(36860700001)(7416002)(24736004)(70586007)(47076005)(26005)(6916009)(40460700001)(426003)(2906002)(86362001)(966005)(4326008)(508600001)(186003)(108616005)(81166007)(336012)(316002)(82310400004)(70206006)(8936002)(8676002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 18:10:17.5357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aac384d-9d31-46e0-166a-08d9d7891ec4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3181
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 09:16:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	5.16.1-rc1-gc8e806b92342
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
