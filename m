Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04447B2CC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbhLTSZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:25:15 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:64038
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240418AbhLTSZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 13:25:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULJMI4/Ho3qFeCVOPL95HbLfw3kORBQlf/2i1Z9UGYOpsSUma3CJsT1eC7C8RrlK5iNZU0aioqX7K97ifRtNWZJdxHKQV/Mlqn/ZkEttE+7KE3Eo/KbVdWXd9ZlddR9khBV2t+sxp8DFxgyGypX1e91/Ws1fRgfVIezXr0q/N4ge3/o7bVbaRpTwSVTIMIFsSv1Em3OsnCzI2VAwhXVWueMo5h5N6cFT3ZKT3KQZ2cymzb4848JSrwijYgjfVUiGgcd5ee/7/FSvZSK7yGdFkA1a9eyibWu41XVqL0WlC3FNHVTwgwRRj1pOvIiPhwMSVdjxIwIt4PtxSfCdwaFtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvCg8ME7RZR6ENsiLQ/vycef/KBWMuQLIgn+/hVaPEg=;
 b=B073UneCc9dvolrgtN+vDfjw0jq9TbOPifY4pkjvk6QKZL5DK5g95ZeDp89c7Gii8HEq2vNNcwzURTlKafchoo8phnppvmf8v7wzvF2jYQni0Ou9FkkKzcy4P+eWPLmmUJy4iHj01D/8quSEZGHbmjAy+BNSG9MurbgQr1FYH3XIsz9j/sl10qKMr0ifeq+zD+iTaxZ6GeFGaJQwYTc3L4u7qRFGn6nnyWZbX27gUGsoutmJybgRfvepTX/Id0nIh14GcGKS2U0qcwrOFFY12RwpRM0F5y3/rK3Opkw5zpNdUAqddkOI+VWZ6k1T6TjLHudh7sVC46Y+9lPntO/D2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvCg8ME7RZR6ENsiLQ/vycef/KBWMuQLIgn+/hVaPEg=;
 b=m7ZNh/KLii52yBW5u3eeW8VxPrlI0h92OE+Vd2ls465qpWS5sDTYXjO2L1rQWzBKi4hCRoPmCvGmzc7vE2+R2VH67gsM6cPiuHt4EUIJ6g47G0X/5egOA/rJD9k0rWHYvoEb1WJNtNb/gpXznu7mg/qqXJVClsBm/elI+aunWYFP8VkhjjQpnYkmF+EZUnSofz1hK2LbvaMVaOFWbMWdGWRq/BIKrszC4X6Aaoq0RDKPZM6yiKWW4hvk7vK0FHg9xyBkixN6DLJwF0HuOsF7KW/W2QRJzTP+dYmEtoh21/MENpKniKpB3ldel4SbLpS5tZJol7OF7Fzezz4jqFSkiA==
Received: from DM5PR17CA0058.namprd17.prod.outlook.com (2603:10b6:3:13f::20)
 by DM6PR12MB3642.namprd12.prod.outlook.com (2603:10b6:5:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.19; Mon, 20 Dec
 2021 18:25:12 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::3d) by DM5PR17CA0058.outlook.office365.com
 (2603:10b6:3:13f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:25:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:11 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:25:11 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 18:25:11 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <56332723b8a44a48903651666a489009@HQMAIL101.nvidia.com>
Date:   Mon, 20 Dec 2021 18:25:11 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0ad5eb9-113c-402c-7c62-08d9c3e60fe2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3642:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB364254A84BC194B7D7C01835D97B9@DM6PR12MB3642.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mfoTnPxPQ5eNb7OpJ+UEYstsBsI/73/zzzXYvFKy8eoMkz295mWCGSCELKOhy8u/rYBaIOuI6CIo6R6Jny7i9ANOok00Do8ZCvMoQrCeZM7LeJgHpivP/HfK5QUqstF+Vjhydvs2ciEDg3tOqCOC6FYoVBcC60tkrUMT3qviotLLgoq9IKuIokZOUajD7ar6mf0OASfBjgkKIT7+psaNLKFzXwS0aBqvrNbDqBiP5yZMUQx3tVg0OuqnbE7AtqeHw03sISTP5k0jcDeRXmWnqWRHSaL+GgiIGlh7xUYs+Xb1Dl+QbuRidlmaWZF0MmS5NDpWfDUnwpVydLJEUWGZI7+e5neSjQYK8HWkM0HbQBxxN+QEMxjgfrf97Uyc1PcTso8bJ8UrxCQhkDSKTjtPrDTAnzV9KpT+zWjZiwyjBA/pKg7quACKRWMjhtKIfsUazzAUOCihrRl3y2hh5tRGLpN8kTOv01MJcPXW3LsHK71lNRkxetLDU/bDxWgvplAVrZWg41m0r74wKBi2m5+R5K+HNtamZo46oHMwHuQXj2wv02/OXkFTy79lAdvAi8vzE8d9J6Uqv+FY1rjxyyku8/yUaNsmEdaNlyWOcfdlAHFJ7G14IKBgNLXRLxXeTnjYS35s0sb4/bsyJo/PIfLAcvGDbiJg9qg+uAwnosjmGqZDjTEh5mf47vLLUCqIcqBtJ2FYFxpzMHDmqaAk/wKVo56RrSljZ426pY09CreK1F/8zz15aJbkDRafxgReO+NM9FhP1aQxaln2idl4yYpgaERF2jxxLOXqnlQVUls5RZ8rF82kOdkYjyZetyiZ0Dz+zBBQ+ZCukuCKyntwznlNj9l5AnmZoAej/hWgZxB+S5A4AiR4sctaXL1iZgwlVuP3890JNZYFeXOG1LcpEPAx5V7ExaWUHzdSs2CbNkpNIY8=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70586007)(70206006)(316002)(8936002)(24736004)(82310400004)(40460700001)(6916009)(4326008)(2906002)(966005)(108616005)(336012)(7416002)(8676002)(186003)(426003)(36860700001)(34020700004)(26005)(54906003)(86362001)(47076005)(356005)(81166007)(508600001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:25:12.4781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ad5eb9-113c-402c-7c62-08d9c3e60fe2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3642
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 15:33:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.222-rc1.gz
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

Linux version:	4.19.222-rc1-g2b0e0aea0c2a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
