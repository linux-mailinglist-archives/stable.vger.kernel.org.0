Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55199374840
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhEESzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 14:55:49 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:38540
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234983AbhEESzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 14:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6Z5nP6+r7PFMz6H7GLVDuKG1SGBE8/T/cbQd1FMtaViA2GReG916C6dSfo/MIfAWLSljD2VD1LIL5axO0XNLvgiGtW30gXBUH3tOjk8Qv5B/89IZsnN4z7jtPwYFbCV+UCQfsWJWJ1WiASNbkHYIzuiCANC250Tp6z/PvEpKOekg8Twxjl4kWyWdIEdUcnB3DIouz8s01vNWJbNSW1SOYq+n4teAq0csPEMhiE79q74T4m+5nXVJtyLu+YwTUiR+cBZsAr/jdzvZrALTHZlkiG8REKv9jvnyem6lRGGJ5TGo3q8E44oDnUbMf7V4gnUY9XHiAtHgjgSSbk0EPVTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyBsz6FkcJyJek5GXaEd25X7essqkU207mn8PsHAP0s=;
 b=J/MJzxuVLTHAgyGxjvo7z0YNDOB6YYjM81cNxP2I9BSXQ+mi8EVM4wJ8bWs/wJp6UaSFVN8fhqlJO/gWCWdpjGUMD7vlyJDwrlwYMfhVqOA5WVGO9l2hecS216RkrVdOh98mGeUAHAOLdynLvbDJq3xAlQbFkUqUButr/E4sYBgDXUeSOyAlckO0ADfjzZWkPC43Fdl5/zxLTMsGDMIG1WPPcLYfuICQCxO21Ifjt6bmC6rLPttHJjeelSh6Q121HuA0tUIBfUpGC1wRTzvnU9QG7pZc1XWYLIp5evsDEU96ijn4R7YO6uvatEqPth6E3vmCnyjvGD7FznPXmkSaFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyBsz6FkcJyJek5GXaEd25X7essqkU207mn8PsHAP0s=;
 b=Lk35rghRDK3BAXYQ/NYwl/7XNs6Z923AiWxxD3QPmFV1UVd3VHVhT7wPwu+zNh7JiEQs99OkXmgPwRT7dnNeBjKPAReln7IO8nA97hvUtuMjxq51mCF7EqFBU0su3PjiYZITv5GMZQpCG4/KRcwui0FW0wu1tvDX4sKfKxIvxy4bbcw5HENbgQme+SUHEXqLWAkVQSwvOf1SZWtKKeRtvP+KPTyAQcNij+vu8oZA3idfG0fbi8eS0RkzB6LcTQm7t8jiwczrC3iQIF1vlQik/MpR53axJ3UE9VMnmDNe8th4dX1VszsCID+u4ygPbGj+K9Jn7LQuVP5TSEHypkOOuA==
Received: from MWHPR15CA0033.namprd15.prod.outlook.com (2603:10b6:300:ad::19)
 by BYAPR12MB2999.namprd12.prod.outlook.com (2603:10b6:a03:df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Wed, 5 May
 2021 18:54:50 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::59) by MWHPR15CA0033.outlook.office365.com
 (2603:10b6:300:ad::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 5 May 2021 18:54:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 18:54:50 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 18:54:49 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 18:54:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
References: <20210505120503.781531508@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <72a9a3b7fda74b35899a494c02159ef9@HQMAIL111.nvidia.com>
Date:   Wed, 5 May 2021 18:54:49 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7087142-10f4-453f-f206-08d90ff742d0
X-MS-TrafficTypeDiagnostic: BYAPR12MB2999:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2999431B243A138E7EB7A896D9599@BYAPR12MB2999.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Ay7RrXREZNUn3KWMCN7paN3cZA2qxf9pAOmsUi+YecgszH6/u9F1uzsL26IRXHnnro/271b9LGP5Pi+O8/C8+7k8Je1qykLIbK2Pn+69K6BmikSBDaRpbfKaOICjckQQiQUeyG9acDz3K3d9pAKkgBfjsn3/JeUyWTSOeLeUY6A6EhrxsOXBOGE2spTicov8IO4UHgAJ3/sjR+ZFWqHhdtVaAsmwaL9uVdH8uQm746e3ANvK0uL0B0Aes7DoBfIg+XZRawfLhpStWO2v/bkyggH4mtLiceQlJM/eSrGCVzFJPjWzk5SaK44eKtBRoTrhVj8md0UVANjFCeF1VnMx42IuEevr9oNUZXBTvZl+6UHGcu36cVf5zQA6w1TFT/Jb5Fg2K8+QOReXV+XWWO9sxARI7plCt1LFSk1w9eYXuUrutrpwRxi+/skDIherXMsPtkR5DKZofahwwwKpHjJ734FTzr3ji7L5F/APGGN9agr6nktjjzjNuKviKXMT5w3btU7gMuWqM0AQbq5CxkLcpZpJW60H1CJIetkEoMC1P8DYZZFBnY9CK5pJg5woIcqueHUnXb2xCLu6gAsMRLci9jsjmm6G6LC1p+DVi8T4acNrnuMTJDOLqJavLmasTIWDmoVMZbOjbkjrhkwrCCQNfVlW/X6OYXsqWwpP7JRxUEWLPsFrihRkte5H9L/VYAwEkelFWn5e47xtWXMWoytA/EjQZpXrbXaSgBFTjChBQA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(4326008)(966005)(70586007)(186003)(2906002)(82740400003)(54906003)(26005)(24736004)(316002)(36906005)(7636003)(36860700001)(47076005)(478600001)(7416002)(356005)(5660300002)(426003)(82310400003)(70206006)(336012)(8936002)(6916009)(108616005)(86362001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 18:54:50.0894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7087142-10f4-453f-f206-08d90ff742d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2999
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 May 2021 14:05:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.190-rc1-g5a3ba2f90f87
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
