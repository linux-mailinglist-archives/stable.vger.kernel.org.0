Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BB3483F73
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiADJxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 04:53:19 -0500
Received: from mail-bn7nam10on2069.outbound.protection.outlook.com ([40.107.92.69]:42849
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230311AbiADJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 04:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meswaGFNUTEk+XRllD2Bh1P6sS4HnVFptpSIM4LjFk6EAY7aqYvPVqmIVjYYkjhMKmOgZ06OXTwrovmIBnSpIdQkYlOWaDyJjBwUg+KDYsMbEItGC0jx/UPQWuMJKYeM/OHQ7bwyiTQHLhnTwkWGqQXNx27p2Z61HGfjL86OG0JHKpsVa7szhaDKNKmPZYVvU8DhEwfBMaMVHWqterDa613hmxZOh3FJszDY24jUuTlPVqhrlfSkl5IAGDHID2BzyUNdMTAkS2FcFStr86YmS/u6INkzLbRCf+gSmCwOEdfsoiz6b9OoXCH82o/RvFdEi02HAv7A1tbB1vgUciA/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwA5EfUa+2CPOD5cfPelpFKtHNmawW7H5lOye+g56po=;
 b=jepbCM9m1bEwYLNSMBuwhKY1M6Di4B63LvpEt3dCnKO9gnLFeplJujXj2VtzTnmIuBY2vOVRdnBftQ70OtLh6OzgCaCbMYkOgkpNsaGXJzpLmohTsSbxMeHEyFRwWcMArS8uF+X8kwbkN9IpTD+8+U6y6PwUHz7l9a1VM21dSBbfLepp1PTUYnX9PZJA4UG14Jq7owd2JbfQkjk50yeehjp9iMqlWYP6g37GeIErNu72aL9ajI8EFWyGdo/CkPU0Y9Ut10xfyU95Yb5b15YZI/rNtQ27lwYwSd0JAXMbK/b20U0MP3BxzREh55Y5L+Oic5mz9RgUBRucBaBFgHWkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwA5EfUa+2CPOD5cfPelpFKtHNmawW7H5lOye+g56po=;
 b=uOTM5rgbe6jCUIH98DVbZIVKsa+hx8fvlLPp/AIqFFB05XlKvNMvzpnBa2nk8iVfADXjc9Lmm9PfXR9SWoAEY5LcoUyR3dVnoLbIf5JuYYYX+NLj+9FoyyxNbvSDsMF1rFxQgPveVdOrPgCjlFIPvXgYneyHWXIQSVlSQqri6zjWkk7AkZRnaXepMabbPplw/3fD6Jik+IHKgnQu6vyT2UbyaDQjv1Mx/6MoLNkqM9FaTRivWhvdhWZ5ntjbOBvqbnrUoo1o5j6/KAWPJsg/QZVtcgfGHFeZR3aOskd5qzX2OWuWmZNSfCrGfDF1s7hL+us44Y8l6cjUIEwGDHmhuA==
Received: from BN9PR03CA0342.namprd03.prod.outlook.com (2603:10b6:408:f6::17)
 by CY4PR12MB1669.namprd12.prod.outlook.com (2603:10b6:910:3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 09:53:13 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::b6) by BN9PR03CA0342.outlook.office365.com
 (2603:10b6:408:f6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 09:53:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:12 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 09:53:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 4 Jan 2022 09:53:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/48] 5.10.90-rc1 review
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <827cbd411913483a9da02bbd1a57b65e@HQMAIL107.nvidia.com>
Date:   Tue, 4 Jan 2022 09:53:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99f195a6-9216-429a-7286-08d9cf6805cb
X-MS-TrafficTypeDiagnostic: CY4PR12MB1669:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1669E0B773B9525F7974A362D94A9@CY4PR12MB1669.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLZWmMIgfoN1PfaJG7eyycF1XgDZZNUENNkKvuJkjsO0en0t0Lu/JiFDtBmzPCeN7fk4m2Sps16AwfYP3/KnLwz2T0H0vkofnxfeDKbCvmAPAh20UDtC+3tO6JdBl4fIOQVS89cAIHi2PiCDLRkOogJ25nJbomepPmeE4KaQWGH7Ptm4FMm7y6fqLEZ056dR01+pVfdCUPh8UutgHFtAHIHaNFaijF4sjAobOoo3dhiYOujmY2eXA90bYaYbZg6yGbCjQtr36G/ZZVdxNLdAGe/82x08b2uzbndrU19SduHfldMDzv4rmPQcQd8HK+Q79mrEA+ZRVLuha8T8o8YvPTleF+eVANonQPN2OjOzgXOShBFTw55+ZhsblD7vvdR8cShsiTnTb3R/M4CPVHxcb+F6FWu21EW9HyUVvpxfwFCvDrv5owSjz1wu55GBu8pP3fP0tk3mbpt+WyRUA9G++d7Wrlk09uzQNZQqf7puopEIVCacsYOUi24VbhzKVQR1dhUpw+i98NZS6kmaADBkjh+qJHdPW9LC8u9zssEovS2h8jPyCGcIsPLD6EyKdf1wYAyE7NUU6D89eEZeuyO2YbHRRNjzfI3P2h/fXNP2vf8gRMt4jH3prUBsuEwBr/JlPuKR/J6ZztaGvaCfMQ+6RlXiDrnycy2/eKB82Z/G7ZzWOIWha45FIeVrMHHNLS6RoqRX4AjaltC7LXFZgro0PikSkk4LKAnUluslC2liD8mDDVBdbWcqk2NGAtcwSIuTIMEhQsX5pbwhHEZFve+5acwMyLzwJCXmohn6BFWfX46uLffvMPFUUid6C5KuvBXIPxPYTwAYfopNJk9FcQYk4nnYAXoqqMqCRdXIKiUrMEQkXxrjnzuZepnIGsshtetK
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(81166007)(82310400004)(6916009)(36860700001)(356005)(508600001)(70586007)(47076005)(70206006)(54906003)(2906002)(316002)(8936002)(86362001)(8676002)(26005)(426003)(40460700001)(5660300002)(966005)(336012)(24736004)(4326008)(186003)(108616005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 09:53:12.8528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f195a6-9216-429a-7286-08d9cf6805cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1669
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Jan 2022 15:23:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    75 tests:	75 pass, 0 fail

Linux version:	5.10.90-rc1-g38b2ec850bfc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
