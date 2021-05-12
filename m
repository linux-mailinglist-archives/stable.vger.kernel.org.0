Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B54337EDA9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387929AbhELUlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:03 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:45088
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343697AbhELTqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgWGPi9JdL7b5JKkuJ2bFX24U5mQemiUCgasEshlRBAMzqSK9TC/E9OWHLqwunCn4xAl7IX+P4Co2Mi7W/XKenHA1i2S1sz88ofmZXUSYGkognyXPSKSWrvGGWFkWhB8w1SC+KhsBT++ksrSI1fOG58EeI6mvNZV31ACHK3rTsaB+R+1wVolFStejJJQZSBUHSEITdKCYlfphnxz3p+FJIZmxkx4ecj3AUfTZA/VVNfM5VnGCLwhlv7T+he+3nM6M1YFFvkap2vn01cvzKJKHmMRm6i39THoiKhnJE59w+G6Ha6Xy9NWHdHv0gepYVx3fhbQGFUdm1cXvw5a2lZUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObRI2rSFQROzqjRgZvo8UhMVEm5XLUdnH0BGFBKGl0A=;
 b=Li7M0DQidknDtqHLQ2Lg6xqUWH224aPq0J9LMpoYeuOwCgzpRTOQ1wyItwG+sdaaW8g+kxBw5I692X50TPxql5qKvY25l4fGzJWgT2Y+tSmmrqRwdxEYg6YxGIw7vf/gNeNp//GDQwSJouws44UCSKfMdtT17xC8kkCPtYkSN8eo2btV8lOx2wCJvpkpMWY8b9+jl0ZBJMEO2tgav2FaEHmvhJLbQ2D3zU6MamEc7w8NRues/6jc2EqxpRo+MiSTStcW+Z/HqNvnUIs1bOyQlMZ0aTB1YICEVugYAjw0TN6Bo35P78eTgAbDnyDVYskl4ELGCkTCeNl3c42ZvL1mpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObRI2rSFQROzqjRgZvo8UhMVEm5XLUdnH0BGFBKGl0A=;
 b=hWfo5e56M7CsaGtfwC1UJFJ8hIO10OOWL+DzZmGyq/tuBYJYLi46167vh3+9QnLnBVffKSQEwJ27QTkwS0l97gCD8yohmQ6iyhK92I8LnsTXvwN4S+NLPhFS++oEfW3HU/hZiGN0WKr3OmDPDfyQWcnWMF8UFAe10i40wRKtI0HfTcQzaDQIje2lCe7UUc6bfYjGWydw8uGb2FKFAAvhUCxqltN6OmXCm5iFyDXzQ6NZLWVuuHZGJEtUw4WeyhIbP7+Xc5c85wikuk3VXX+77mtox+eSBdo6Vgvnr0nQckiTYDXGFt29jEysQxsd0V8luH6+31ijciXVGZ4/W/WfJw==
Received: from DM6PR10CA0020.namprd10.prod.outlook.com (2603:10b6:5:60::33) by
 MW2PR12MB2587.namprd12.prod.outlook.com (2603:10b6:907:f::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.24; Wed, 12 May 2021 19:45:09 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::d9) by DM6PR10CA0020.outlook.office365.com
 (2603:10b6:5:60::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 19:45:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 19:45:08 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 12:45:07 -0700
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 19:45:07 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e982fbf534c14b8daaf95874fb95995a@HQMAIL101.nvidia.com>
Date:   Wed, 12 May 2021 19:45:07 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02917eca-d9a6-447e-47ad-08d9157e72d1
X-MS-TrafficTypeDiagnostic: MW2PR12MB2587:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2587ACC5E1480013BB3FD4BCD9529@MW2PR12MB2587.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f4fKQ3AaxrUb7l7M0lZqGCtUnDY8ev6gXsVb5UA/+gy8W0Pb5cLr0j4Gq75//G7gxp62OdOgAfEBeH3BR/L6z2qFi2XYjxkrpPPY+f5ox9i/NYk67AkwAOuiZNTPKUjuBXLLoMCdzszeElPOLomyET0uJ2ZygZ6cPUbKPW5f1xGL2IIkBpvrCW2RbfhY8k+R0JgfxO5dECuquNeMWBtCu4fsadZXXHTS9aoFtmGaqosLKOGo8JzQYvtMplLy8W8mQPpg73j9eUTedCLb9dwn0B7+myHPY4cjdzs04Ob3F/wBR7TPADxWYDe4X6l6zk8byUXQsGd/bzW1u65RbfkQwVMublX8j9CABxWW8EweaPUzIZcZBdS+Z96CGhfz/2PZ6uPVMd+gSFhGBiwn2LkrARD+1ecLhPF1YQDEHQ1BnlumDNSSCtx6sf+vi+z50q3eDXg/woH1fp+xqHZroqRtU5Yp16TePA2aQoaP/K2Uf0nOjeEVgsUEb7kHtWgvqF+9BeQ2p+m7gV4WOkiofFZjEKeM3Pe4hR+5AGoZgUGnRPC7iaQj7Woal2w5Q2y01VIO15tH6wKB85gtjSMws2sUecAC+xFCTNVpmmW8mJaqQXJm3war7PQynEJsKiW0oEkQrOnc9uyQPOnhNg8KDCCxsxu01sfPqlHqnARu7cS/grJCeNG7oL7YsEU0LExRa46Z5K6Bdt9lu8lDKhPYIkGJd7Cayd67PleI1gXLwtuhuQQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(24736004)(336012)(108616005)(5660300002)(4326008)(966005)(7636003)(426003)(356005)(498600001)(70206006)(8676002)(6916009)(7416002)(70586007)(82310400003)(47076005)(26005)(54906003)(8936002)(86362001)(2906002)(186003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 19:45:08.4837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02917eca-d9a6-447e-47ad-08d9157e72d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2587
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 16:41:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.37-rc1-g77806d1ee43e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
