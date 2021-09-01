Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAF43FE2E4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhIATWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:22:22 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:47072
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232199AbhIATWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 15:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiVI2MluOq+SFgpPVQz5RD9pzP8r8he1GlrQqwi8dd6bMbsTpdzmeBruuMO4ttJaHFxSWjghjsiiam/SDplLgnJRzu00SQmZYtaWFO7g0+UaFUWt9e/MS3p4Dt6o9izaSDxVJ14zvaJSRVjIZeeDatGvu+7Pc4rzKE8SWDY2KkT3d58CxPVN6vntXruCH8Tptm0OCA6cANuG5gtzPlvEAsxEt/tZGuzU2ucoZ2j+U/DIFpz1AgNQgAJ7UFuq7hmI2N1/OiYbmFW0kRxIKH2r9faKSAR7NazMLe8gws4CYMiTABTfMmPjwcPPrSZAJyUodL6EtTSI+DNXvijOQPSK0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zAGmdc4+/46R6tes7t3qKo48NfgANAtVeWKnE6qTtZs=;
 b=YAtqrLUhpGzzzYRmUepiT2CMszlY2LfIz2NbirZy9cO61b9mB5jJmus5lRaWUtsgGgsxxf7zIhiLmGnf37mc15M6+bozO8O5cqotu7Z+nTgR2S0Ir9kyv4+V10H7v1u3X/iW4iXy/u0dse/SV3AO/DP+7PkbUD/CLdD8JGs8Tx9BEwBpb31//TvJvQBW8ztL+UAt0vqyGh7ZTYVP0nKWkXnU69t/bdBCjAjWmOF4QrrPbuZ191nElHYCUGHuDENebsxF0yr+SKfjJcLr8MfnDiVbq70ReVH6sd5o0NdpQsT+ZnD8dKWD9u2kuu+F0oZS3aEprepeRDuRHaf9Y5oHRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAGmdc4+/46R6tes7t3qKo48NfgANAtVeWKnE6qTtZs=;
 b=AeQnNnthURMhxDlAqNELVS9tzO8S4Q55PYN7jCLR6QVkrJuVsael9VaEUldKlLJio2N/z6I2QMY6T+NHvytWJcZbf5yVPXTqIZsLgbx9QOFAopEXhRxkEtoqNph0dHIfuQfLD+P1d2B4iGOD1PBDbh8uxGJLcGOGDb6J1brPEqbJ3FeLY3w25a1PKKWrZl0LD8PPYQV5IEWce0sp0fRd+wiPZeaDdP3B0/p9bOyJ0Nhsomturiadq6oXqS2CX/zHn0ctv1ZppGUTgQa1bFIhCXIR4VDuiFcx5NEAVMmKq2Eo33YutAxklM4bD3LJia/zoI8CfAXDCMtYpkAk/R4E/A==
Received: from MW2PR16CA0027.namprd16.prod.outlook.com (2603:10b6:907::40) by
 SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.20; Wed, 1 Sep 2021 19:21:23 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::64) by MW2PR16CA0027.outlook.office365.com
 (2603:10b6:907::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 19:21:22 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Sep
 2021 19:21:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Sep 2021 19:21:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/10] 4.4.283-rc1 review
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
References: <20210901122248.051808371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <33faa1c0321845fba4b234589c5789e2@HQMAIL111.nvidia.com>
Date:   Wed, 1 Sep 2021 19:21:22 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a632809-def6-43cd-89f8-08d96d7daf36
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2414271C4868144E2184F3F8D9CD9@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SsmFA8UrRiAlY9QXEqGOfjb92E+mZFvy7dy0H7LhCPcGkJrTXAhFYYiIXQ0fJ0+dz4RDqRxBM+yKMu3PlCg1B7q+EkSOorzpnqF00lmI7fgKVgoVY+KKcjG7BX2xpx+aMWbbrV0N4G7/1haths3kfUIUMRiPgSSft5jCMoyh6GVkCH6TjoZeAYtVTeEqC0V2/swNeE2uTNS+oRjB3vP/ofbkReToz186OjKYGyeXVuBZpoWxPdwh9KOLu8FXakYp0/Y0Cb8Q+KGowtQr5cobfTV6TFx0OZpMhD4ZjCJcA6ikhcfbG7UcOMSGEjJ9St99fIREpzRnpWirZWXWpl1NYrECzmFpKJBAWXdZnva0UI967YgbMdIjhVqU4no6Rk2mokoBOR+Mu2p6wPQtTXEq3iGjTdYwrygc98JoTsdZ6xgk7wGObMbapIfHMRxqMugqzu0aoj0GuaSnLHxK68zsZ6rf9mTH9LXbyPYIontaJ4WFVzUzm1eFLFHeSMw9nfns5QSK/tJVXErSnN+Y93XuE0I0r7PJEQUrnkojrfoT4L3vdJVEZUJ/EmkmEy0cb4pEm0gy0W5Sfj+zvm2lmLFCPDaEpd7iE0GmzFtBcIHToEQ8Jrtpw0uqAl2hWiY8EP31mpuRIqbhJFzKP4MW+8fbCqmoVlHK9SoPFzYEFhkhnJJ7jt+IQoZ/fFFlN+Z7L5il4yhi4XqeSM135K3jpwiZV1RneuiUK/qS34bD+qYGqjH6WVhSOycQ7VoXgcoe4sojZAEnA/KWDL0V3V1NYFF+Pt0HwLVgg6cBqNTWKCR8blA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(4326008)(70206006)(26005)(47076005)(7416002)(36906005)(966005)(82740400003)(36860700001)(70586007)(5660300002)(82310400003)(316002)(478600001)(8676002)(2906002)(7636003)(336012)(426003)(86362001)(6916009)(186003)(8936002)(54906003)(356005)(108616005)(24736004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 19:21:22.6463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a632809-def6-43cd-89f8-08d96d7daf36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Sep 2021 14:26:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.283 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.283-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.4.283-rc1-gd0f43d936dd1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
