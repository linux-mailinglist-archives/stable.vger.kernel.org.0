Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBFF387F82
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351512AbhERSXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:23:36 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:15425
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351497AbhERSXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 14:23:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkMNUbrUiEEMnTt2CwbXHcCdRFdrMSTFvkafV7k6VDBayAYV/Z1KKbYDixqYHu1MGtrRIBJHOhQ/hCAa8PBpcYRju3mFl51cU5IWpC/XVx1KnLvRKK/S2n6N3WbEgyCy9NaG9pyvrlTuvWf6lGdGZoITBOx9JqzWPtcYU/O1tz3J1iC6P0lwj4G4vQw+Uh309lzV8gQEVTFiBkKcDKIoK+o13K/s9r2SN8ftwbNdOwjwITYPrh0ywOh/Fx9DmfLjWFPc6DTPuLLaPsPaZSlrGFITF8lZ9nlMmTFG+gvQCcVwhceCckhwIqHIDKV8dyHzm/qmNjLya/KcK+SjiFrWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZKiYsD0VzU3NOYYi96PKjVH87NttAY50mlHEAOuxJs=;
 b=HBU7cdqp9TRNmktPB3e9NrcFKfFyyC6QMELe3070inVOtez8VUrs8oRWNP3FJ3cNl9HXuKyNQZtPHXlVMCalrnH5xgOLNWwtqRFgR4c+ZT6a/t8DJq/wuo7Dn5DV0E1mqZ+hTWxIkbQdGmph4VimkMfQW0EResow+ymZznr758mlokCjKjwtxR8j3nWwxVPlMqFNW29Sz+MmItPbQgTOg8BOqilQbJd2HQw2BqE6OBjoj18No03+3jPUlyyVX6QA3nl9m7BaxeuOloM+1T6nPS35dmS+j+82oah6XCvYHWo7+269Z9nakAW7lagMNO7NhY3KMOJLlbMocsy1uB8NBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZKiYsD0VzU3NOYYi96PKjVH87NttAY50mlHEAOuxJs=;
 b=CC+1+YBmqpAoebnBax5rCzSwHQozp5HWINjx3ML408zxNZW9u98VmSNeF2Zv5ekfW/nfm4hL5mog33zCF+1UpjjvP+jdLerNijV0M/X6HV16uPb2gleqw7859eph5BZ6+ETUoVEqKcOuF0n7bQDfWCpnKBslQDYmqTje2JMnUqIW5vG8HPmgcHcBdxrsG2mv3iDhfw6Ww6P4WYUt4coCwRp2jZEci2wDgZkYk+7Hy4JJPSkELy8semqjif93xLymwN0eusTB4LzIHFj8wfdscCLMhHwjYDIOi9JKCMe5Sgw0CP9MdvGC7SH/KzEUp+XrN9gPHmIdWS0bvMN5yOCiIg==
Received: from DM5PR07CA0100.namprd07.prod.outlook.com (2603:10b6:4:ae::29) by
 BN8PR12MB3204.namprd12.prod.outlook.com (2603:10b6:408:9d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Tue, 18 May 2021 18:22:15 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::2) by DM5PR07CA0100.outlook.office365.com
 (2603:10b6:4:ae::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Tue, 18 May 2021 18:22:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 18:22:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 18:22:14 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 18:22:14 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc2 review
In-Reply-To: <20210518135831.445321364@linuxfoundation.org>
References: <20210518135831.445321364@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <812545e166b7488bb74aac85d3c1a58b@HQMAIL105.nvidia.com>
Date:   Tue, 18 May 2021 18:22:14 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 035f27da-f3f5-4fa9-49b5-08d91a29dd34
X-MS-TrafficTypeDiagnostic: BN8PR12MB3204:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3204E414A8E5636CA59956AFD92C9@BN8PR12MB3204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVVI1TX0VU6BoBE587/V9nyrH3OYwG+Z+qNU3QICSKy7KgP4C4MyZy3sKObTDvCZCBoVV+614bdepSiFFwhz5ELl6HLh4s5Y1lJaQ3xXkh4MLMLxFa/kd15uMGU/zf1Fmne0CLGoQPDtM70PuejDyu0BFfdU10LqvApai+dOfhG1WhCg+4yAfWwjg5gMgPTH8V6cw4g8Kwej3RwWEzk1FcosvkTX95yiWXQHn4WuJpsAil2Tg0YN+DyfkTuSwMuJOKqS4TWmVq7xuWldqmhwq1kfqABByv0mqV6GPTaxBg/s5UPCkPsz4loQMPGO3IkKaRmnzKHAOqWOcooJ5sEiI+l/KCTJjpzuYDr5ea5dd+aNQ0P2RwuazCZWUuNqKMW1J8uZSxImt6aGn+yMVHvTF535w0zwu6scNtqS2NNDWGrG3VMrjoYf+dokZF9l2Dikdsif/L7/yWrcLQV09FuUUCS/MXpRNX4zRiUyDaxucFkCrU81vRv4Qpr+cqP4DzSU1ucns1Y+FkWK5D+o1jaGYc4iL0ex9ORFSu4QbRanWVtSrp/EIRnlskoZLYGZ13ghsXhXRIh2YiG2IiRkUGHtq1kxKCIy5m3PAVoBdGYslTPaYtN2jBEGW1i7X+KMFhcnt2rxFtT28NAnKEDFgFDyFH4+Bk1ukgMIfuFOR9ojJ8WfC7mSVGCulowQ1ntQYMGhm7GCnSAKIXlQgKUg8tlAAu9xBFLbuo3IzkfPyuZeNbc=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(46966006)(356005)(47076005)(8676002)(6916009)(7636003)(7416002)(36860700001)(82740400003)(5660300002)(82310400003)(426003)(86362001)(108616005)(186003)(24736004)(966005)(54906003)(70206006)(70586007)(336012)(8936002)(2906002)(26005)(478600001)(4326008)(36906005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 18:22:15.5709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 035f27da-f3f5-4fa9-49b5-08d91a29dd34
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3204
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 May 2021 15:59:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 May 2021 13:57:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    104 tests:	104 pass, 0 fail

Linux version:	5.12.5-rc2-gd9d51f8654b9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
