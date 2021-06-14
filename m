Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9283A6DC8
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhFNR5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:57:33 -0400
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:48181
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234128AbhFNR5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 13:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5sHqwJ4gOy+H0BnzqN+8dFGjQV5zMhB08/0l8h80fm4To7GcR5UTJKbNDJbPHqLR3TQ3P2gM7NcVTu5figFOGMJuWw1mLnqABG4ric6pl5B4ejFfiSzYBNXkbxiwRKTjPcHbjcIKxhloi2TrcxdYG8/3BFKc0+SCYTvB7bKOkmuxzN09TTy8umVMHYSBoEjp161+tKBwF5iDJZtO1huFUq2SFnDGfMNVtu9reNl29lOR6nIHt5XiPSUr156ZL6ocVTACEtHJ7bqzj6ugbUmtfHDe+K9NgEUkNt/pTUynexIPqNUp/ZHXhEr3KktPfzN4q9+t2/2sHxvtlw28HImHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+AdrhKc4BooZuJa4ExXpnAOO4mL4/2sCT3AlgLM5CQ=;
 b=blK6wLBDwNrayb/+7SGf4NSb/891AYPcLSkMn26K4WL/S56Z3Ygv9vbl8i8nsptvAitthGCqj0J0J4Ptb+cBBumcTl+l9gsyzLXVR0WCJCBXlBJ+c4SwGUxwKxm5cf71n8O9oN34uWjZwX1ZyaR1C9zK7sHYSnzCcXrKbJDddjeS2hTBQHK1c4caveNRkQWs0CXfF2G7gRVkRuL6fOYqTRld9/0X34QTF+dbWKkjuCSrTH5u7co99xoxaRmMunFOYIV1xFhO1VYGf76/nTlA8VfcZK/YrrS4YebSuc6iWsJabyPKgQ8aVffFGZIK0p2GL4p3quu3NQmVRMVjjftpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+AdrhKc4BooZuJa4ExXpnAOO4mL4/2sCT3AlgLM5CQ=;
 b=JbkRO5WpubnllyjOdhwbPdoMcl4umHP31A3QwtJ4euVg3tDxfvG/7nLNpFDrBYlCU5SYLQtk+LssqdjFn1VclSRthLo7jG14Yh5LZKhenjAKHYA8EEhJkPOU/jmAyxVz+91oaqR+qVxzc/KMdTjQXRHeyIQzDmAm/o/DxWOSs2A439NuOI/R4ePtW9E6ls8XI87THC2Dt19HwrKkE7A4d+JQ4Ca7hmt1MEOc+6yp3CnBE2A1H4ZOoq/852j0tjPbtuVGIH9jm7DGRnAGBlv7Cl+u+FMazAXG5yx5MkCuJkbDIxArJpsM+cyPVUkzz7s3dI/LoRd/088MkrYkbnYzLg==
Received: from BN6PR1701CA0006.namprd17.prod.outlook.com
 (2603:10b6:405:15::16) by SN6PR12MB4733.namprd12.prod.outlook.com
 (2603:10b6:805:ea::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 17:55:27 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::d) by BN6PR1701CA0006.outlook.office365.com
 (2603:10b6:405:15::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25 via Frontend
 Transport; Mon, 14 Jun 2021 17:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 17:55:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:27 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 17:55:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Jun 2021 10:55:26 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/49] 4.14.237-rc1 review
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c7bb8f4f0ddc43f8b4395ccc53c8217b@HQMAIL109.nvidia.com>
Date:   Mon, 14 Jun 2021 10:55:26 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f1a53e-0d5c-4fa7-6663-08d92f5d97fe
X-MS-TrafficTypeDiagnostic: SN6PR12MB4733:
X-Microsoft-Antispam-PRVS: <SN6PR12MB473328FFC0EF7C2680E0BA31D9319@SN6PR12MB4733.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+S784cJNCExiR1R5kM1QLsihf44F5EjS+OXGdor6vYklmbVMGBjyW5+WHAocxybIcX/+lpcqFD8h76ca1QVHhfXrtDF1Z6Ew/fxyUlCPqP2dVBdqfqqQ8hypQskGVpnyToXplMGmudPmSwMqrBu/Ltu5sR4xnk3OIqKmaQvdzAhKT6bRajO55fzFYN1f6j426yuSSvhza5NzRYwR6QI+avSVZYVKBcaKxcMOJgjG9Bs2BX3X5xjZ8waiAygC0A7dVQsJ5RylZG5E2TbWCrhaFjoHsn8dJ2l+tE1o465c83P58xPl7/x0wvViLTedTMUxC+uvt5JqxeBnPVLPnk8diG38FC9F8UAWY12zCLexPhvnXrhI2dThOjKd1KFRriTE5bjaLDp8++kFuyxkTZ2+jFXZp+w9wlW6ZwkvvrDloYYAzvJUEuDDZE1YApHtippobpY2bQ3Ef78WoxgrzjqIs96rfhY2Vm/Jkczrtd+rdm+VQ5bDbhG92rCUtdsKoFSAy37CoRA3TR4TvTzcpkhEM/GaQVAoGxJmaHhZK+5TZslLv0bUUim1VF3tlbCHAuxmyvZShNXJAtAgEts4TBG7HK+yzbgkXUWWvyEILIBgl2JExuFRDCRVFDRolHSRZZL6y7/HHWxlay7EuapI35Gqd+CLAiQr/QMxDUo1zye9477DtDMI/LpaETdcnoGkWGR3iZaynQChrIkFqXlnkm242YfuH5eJo4DrJEv59/r452BD9GsZ+nsf9gnuCgSZDc7rGi++T319vHfIKzVbjogbg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(82310400003)(966005)(186003)(316002)(54906003)(478600001)(6916009)(26005)(86362001)(36906005)(8936002)(8676002)(24736004)(108616005)(4326008)(82740400003)(36860700001)(2906002)(70206006)(7416002)(70586007)(7636003)(356005)(47076005)(336012)(426003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 17:55:27.6402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f1a53e-0d5c-4fa7-6663-08d92f5d97fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4733
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:26:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.237 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.14.237-rc1-g2e03cf25d5d0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
