Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798C834E53C
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 12:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhC3KR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 06:17:56 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:23649
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231699AbhC3KRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 06:17:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iULcVX7peZRrH9z4I7arx9zTnzOIkA8NBt3nb8pv6eQOKFdtrPyhawVydjEXBN6pTQhqfsQDNJNqCE+JulWD1CuT9+kHyrXFKqSR1KqMGH0TBgELa3s6mHE9Pp0OESBWor40Nf/iLGITjsyT2vS5lI8ZrS6D/n7mzfiNiF/QgThoWMNx7Q2ogmlC81knFILeHtEx2GVmTapdBFbrj/0fEsUstETTObaVw4bW0sAxud3zJYc/7iR66hRdt2fKMk0E+B0JHethQOCR7SC4ARzevmq+kFawTvwPJLxQOs2e/n61M2JCNoqVoAdn8MfolPn1KlGw25+phlHP9dhsweUjUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy6FCbOUOlqHqDsVDmPxrPG8fxR7RlBKgkGlfHBVHTc=;
 b=JQp2bV2dITthH1stBzQILBllwNjk8r8DpM3GF+cqSyRFM+mBJzAAQq3O16vXvXxXZzuuMKTPriG/TuqUjfTLY4oZyHzSpNXAyKHldXeOErfRErM3nlAsikD3jShWhHs3JDiBA7dBEH3LWFzKAwaHhELR/yqPg7Sc+RyYk16HUcWeSRX3DOVmkpXDcqbnDENk+MJKXDjmLbJz+TSgK+qZzTZon59xr/vYH2BqbrWMH4HUvowB26yy4ZVfLqQpglfmcqp3dPjofAgbmV5PkRucVaAFbz2MWVnPnvvwxJMvBpnKrWJHYrTw6QLAQXNTErwoL8CvYPzFBfQMlbp2LOyWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy6FCbOUOlqHqDsVDmPxrPG8fxR7RlBKgkGlfHBVHTc=;
 b=VTq0nwejLsmi3R3nEL1Vb/EusbW03XAXI+NUrCrOsYfBnxgqtI1OqOkxMqdAl7dZYVbqEbhx0fTbLIxBULEHGcPdLk2qkoFQQ28M6JwqUY/Pfe8cX10bjD5cu2yXIUHHsSliFAlmjKMVoTlt+7RhvntHLfVpcW36QHOgyrioDvCXSXnyqbhxMcQP+SJA/lcAta1QhfFJkgsLA7Fzubn1o7NazLXyiyfIlKzzvjuoDXyaNdPxFdfj3DCj88QwHj/1MroqlMyZ/oKL+S83GcKBP/UR7/P0nGOqwLRAPm/nivaNUAXNm8zqoFF4rCyplnMZBAQVfTfWhdqfeYGIHb2pvg==
Received: from BN9PR03CA0390.namprd03.prod.outlook.com (2603:10b6:408:f7::35)
 by CH2PR12MB4168.namprd12.prod.outlook.com (2603:10b6:610:a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Tue, 30 Mar
 2021 10:17:30 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::29) by BN9PR03CA0390.outlook.office365.com
 (2603:10b6:408:f7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Tue, 30 Mar 2021 10:17:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 10:17:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 10:17:29 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 10:17:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/252] 5.11.11-rc2 review
In-Reply-To: <20210329101343.082590961@linuxfoundation.org>
References: <20210329101343.082590961@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <62a3a701a5a74eee97e35c3b916a7efd@HQMAIL105.nvidia.com>
Date:   Tue, 30 Mar 2021 10:17:29 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e58d940d-ba8b-4ed9-c09b-08d8f365069b
X-MS-TrafficTypeDiagnostic: CH2PR12MB4168:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4168D0E8868516CE76E008C5D97D9@CH2PR12MB4168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuKB1ndkHRe/61uUmvSniyEtwN6c3TsCwnn1qjuFTNnMe3U6Q8msYGMXUI7pEJsSjS8qrKjQ6zd2hu8KzrLExXBwiTinqtC2QUgOtLbjwzbsnLwH/iiYS56n/zI91R+h7Jxu3MbVwGj5D9JWb9zIuSdYtBEMWWpRJ6LXK7wH/TQLuhqj2d1ApQOCVYAe9XNe6+j0Q/jcgP7DRBz1QoY4g85sBDgk9fbBRRg1KGfBsYoVqsd9T7iIafaQihZNxTNqTi8gspUwBDcxuFR82AJs5L5asSONvnCyQZihp+IBFLW/xfcACZjIWqHEXPAkmDRePmjUDAID13ctVZ4CkxLjUuGGI6anJxn/Lx85N9nmuA4xmeuWjVoxeZJg23df7Ms42DbfyfXzhx+r3mQG0cYK0sf6SgEu2iEhAtUq2IoB+9erC2/SXT3Zq+Ohk4D/NGVnJ2WDL7nXYPBGlaTeiU/uR76YvI1g2r/sqOceiigT2wSxClmdYtNzkuoaDddxWddQ+wbOP6fuuIKVihJRgpacGAjJQ2NG1REuebAJpEsbDtiY8tlRYnbQhHnwUSMWEF+cgCtmEG/Q8nfCyvhR5kUJZfvQG1lQVwgOYXCWsPdzW9/OJujQ6Z22tIVyJTQ2gieRqRb7zY4W5E8sulhOuvM8m+qlPmnPovJ01hwH7KqEqVOtc/CxRkn1kOMBnbQa51sTlZrGxG8i4q5uFT5KLLmpw8gDBRcZcgAuZAy+XH10y+s=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(82740400003)(8676002)(36860700001)(7416002)(4326008)(6916009)(36906005)(426003)(82310400003)(26005)(478600001)(336012)(8936002)(47076005)(54906003)(966005)(24736004)(108616005)(316002)(356005)(7636003)(70206006)(70586007)(2906002)(186003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 10:17:29.9363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e58d940d-ba8b-4ed9-c09b-08d8f365069b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4168
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 12:14:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.11 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.11-rc2.gz
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

Linux version:	5.11.11-rc2-gf288f3edc688
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
