Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8295E453AFB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhKPUeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:34:36 -0500
Received: from mail-mw2nam10on2045.outbound.protection.outlook.com ([40.107.94.45]:6881
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229884AbhKPUeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:34:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hup3aeBCAdWdHgXfPXf9VbBG9czLR32bUh3E0JEZw4PBWCxvNwgoWUplYEdqUKZRf6VtDSQO5GVwopmXtaDVF2nnnt78ZCTyuuemWiZfk5PRdNZUJI8Lg+ppMAYZta8YOVxVxAIq5YtvT8SNej5IhRI5roIKIhstINdhEMDesu6PLWYeqfY93dvNGn1K0Tkl0W4cCZ67Yf5sQDkKKGMXTcCOA3EdsE4SFtg7lWaOHhTV9K72mXuh66y7I560O2Hs+qm6hiVMSsdaajxzrn/ErzEjKt0Ctbfg3yr9oAlggbuJPeWZfV3VOS+sBklUNo1br+NSoNW98C8T5OvgPsifbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDwlVuGJX3ptYaU+1vRDnKmEjjLBhdjrD4qHm0NfnaE=;
 b=dnLMjZ3M0H7giKbv0+RbYSn5DqFtfG2m5Yxuq7KV59m7RO5MOWDb7/Wt5yPAct1vI+64OQrohlKmq44xbA5cHqDJ1caMkHI32vkHl+jd9N7dD532T89mX+KUhswGMWyEkHsqQImz54z2mvGh/yeLTsrxlEEbX8vTSDSzpdG3eZkViFylxXjtz8j5HTykeK4I4UYvAtaprwmhcVu52YRlZjuLEO1kHfN8cWYKUeElnCwYDrX26rBN/fzelPOFgtzPtgGLpp+EffeAsE/0VoV8J94BlqsqLXrH2Kp5+hRrNHcGsluV0zlvOcdytG7k/5lkMf/wZ07sVjuXrKyLmxlHeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDwlVuGJX3ptYaU+1vRDnKmEjjLBhdjrD4qHm0NfnaE=;
 b=o+DalYu6DxGjLiS06vmqZAiM82SK4mBrHnL1K8ASFZfsLMkMZCQ1MA717dIAdeKLnHsrX8HI/c0O9cRvvFiQ3qrzt6wwang45MsgIzkaNV9PhFMxVGGnYjZOzQEeQtaTrX0+3S2LC5HYt9fOhNLpHuihNLZ847I+9kH/TMtXHQsaS0iPHhKkkulbVmirqOAHzSCvWepxSXS20gLs5m8gP5D1wi4Jfq1HnHcBRxbHHAqfqQNm7b9nQ8C3yrVfgbL1MSnMOCdlAs1r8EwwXh1Ct0e+Jau35qKbHAnH9bxnVrPmai5M4iaU2ExLPotLddGgKkz90I4Ttj5nYCR0y5mvnA==
Received: from BN9PR03CA0195.namprd03.prod.outlook.com (2603:10b6:408:f9::20)
 by BYAPR12MB3464.namprd12.prod.outlook.com (2603:10b6:a03:d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 20:31:34 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::75) by BN9PR03CA0195.outlook.office365.com
 (2603:10b6:408:f9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Tue, 16 Nov 2021 20:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 20:31:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 12:31:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov
 2021 20:31:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 16 Nov 2021 20:31:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/353] 5.4.160-rc2 review
In-Reply-To: <20211116142514.833707661@linuxfoundation.org>
References: <20211116142514.833707661@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <bd02d27c31544a69999eca62ab5e09dc@HQMAIL107.nvidia.com>
Date:   Tue, 16 Nov 2021 20:31:22 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c39f0f-1077-4634-f50f-08d9a94014b9
X-MS-TrafficTypeDiagnostic: BYAPR12MB3464:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3464FF32BC639F92C041D349D9999@BYAPR12MB3464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vb9mzPjS8bKKOF9Y/DdhLu8JRTjn8OwdFT53FSUiNyjGhfrRyUmTkQfWEJ4fuhJ9/krXOJVPbZUIRyMWKfhDPjHYGQU2u8r3bSa890DZaD98ozwE9r9RCnE5vamGAUgBNljnjkQ2awI+yF89CxVJ3mgSamd0womZeZFH4MCmhNB8zvRmmDpkDb8Pa/W9iGnhrlSiuBYKsmfu6LbehY2Hmf3xE59qF9Rh3+OtVz1vvcTRvp29+aHn92QtorCp2BWcQileT2hTc1xSLWpVweHlNM0pnPsH6wVQDj8lmi3/K7od0ho7O8FcC/y6Q41nY4vtpF605gv6hOHk6OciUJH79IMf/hmFUKRSiGgq0ktNSDJOZ9Rhf8S8h/aMc2KsqPXzL/7/xv9OlUuqq2gybL7pTP/SYS/tURfAYldkVgAXil3H2hmk4gHDsuWvNw/NtbMgZgI1gfuhyoavrHrdpjXck5T6cIEBqyqSKETsYZsi2ZLRMKNUF8ITBtFcjujs+rH65LUO6aqngQWV8jiQYcYWmfnajLA4C88df2rxZ4WpwoeCLOMkPDCzE3N5UvqKokJ69z8L/hK1lp2yEFPEgOzy8WR/+gvITz3fP4PO0d/qfTj1N5yG9tacKRxVKwAbxoPv6iP/R2Yi2m3VdeqOvFwuPSL66Xx7ASKeDggwFTNiQxk8R27StaLrD1Y/8zUCJZFdG5Vm6ybozF0Gy5DylsFNyoNs2oUp5LU5qE7Mmj18GffJ0Bbz6WycYiTRsD9BmIMssOzljTyMivbIEgNu9kAwDzVhSA1/ZUUN/8S7Wl3rCSq8nFs9VWaFfCK1GkKjPonc1QhB3maXvZEgAPcTUpYAVQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(70206006)(6916009)(316002)(426003)(8676002)(70586007)(47076005)(54906003)(26005)(7636003)(7416002)(86362001)(82310400003)(36860700001)(4326008)(356005)(8936002)(336012)(186003)(2906002)(508600001)(966005)(108616005)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 20:31:33.1413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c39f0f-1077-4634-f50f-08d9a94014b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3464
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 16:00:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.160 release.
> There are 353 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc2.gz
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

Linux version:	5.4.160-rc2-ga24b83ec1134
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
