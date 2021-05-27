Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5743935E9
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 21:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhE0TE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 15:04:58 -0400
Received: from mail-bn8nam11on2043.outbound.protection.outlook.com ([40.107.236.43]:61856
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229739AbhE0TE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 15:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVbiqgdbdiT+XVzk/cMonLlOwaFGM1KhRa0KYHrIpJBCPwRDgaUuV9qOxUReHsQsJw6Y5A9Rr5MVa1bpGIkicxb7ZaITdcVo1BxbBWonN6sSVLGOSa4wFGn563WgCPK2zrVJ6sb1qinINWf4b3Hw+c1MrEWnoHOrsoytCalSK6GmFVlzWWACqZs2srRQqI9HxHDDpCpjLgK4v4nKpHvpSQe8YJeFuTb9mA5CCpUgUQW5/tcmI2ewpSevrgMTuskD3vkJIVcOzjDCGyOgvuvoKivKaDKabfO2Y0VT8fVoqex1kMoeyZ+FQpeOqsYNJq20tNUaznAUZSp4PfSF09Jv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW3Gdq5xMqaItK5ZoxUJ2SMAXey1YjZysn9ZX2YeJ/I=;
 b=bJgXSCV3KrbQ9qPPAcXFsY1iTLtw6A+vfZxCJzKj1nsM025bEzMOGgcFjUPMRFzs7WTws0m8FOxpJlbNYgzzSlG7pyJMtacmP3aPwAHVsXN2QkIdW05Gqe1scWbE0s1J4alrqT11aAIW67H6cVSCUeZxw+ZpDKbiQOAbk//ijeBQQsXGzcDUuzJRqQKkfgWJsq83ScbawsWo/m3L+re9ulXLzjY6lgblMzarqhT4kxOm9GupPn9NfBx1kRtrryZ7VFl0ysnDx86oZK+PNn7sGRIaA4HAtTxmujPvGLO/AWkqKMYc5za1O1qA00zHncG3ZTKPcd29Q0siTnw3Elu/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW3Gdq5xMqaItK5ZoxUJ2SMAXey1YjZysn9ZX2YeJ/I=;
 b=pcqZchWzaoAsWYzakvLIOUnAqSV0PSnDxHeRojeD+MNUo8o/7F5DW01wbWl7w3jcArKnkMTEF0I/+75kx62bdI9je/01q414Xo0gRC9yaLwvDjIajuCI/+XWA8OuNcqgrsIOFDLU4fjVBvljadh1uHSOmcUVj/ILrbYSch9yWBoBQop9sJ5ADZVPsB6oTICromqhqAAKJSsABGiryqQ3bVUQ3sAmrP6cbtmng7fs0JFjPFs3jm1yJgsXdbdCZ8rRnPVmfqbjuav4VJIVMPgsuLOkVOlRLvdZuRuCHn51GAClAlXKLN82gM9CdiF4oHFkqZiwk/wyrjwjC4ntaAUtRg==
Received: from BN0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:408:e7::27)
 by MWHPR12MB1375.namprd12.prod.outlook.com (2603:10b6:300:10::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 19:03:20 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::6e) by BN0PR03CA0052.outlook.office365.com
 (2603:10b6:408:e7::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 19:03:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Thu, 27 May 2021 19:03:19 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 19:03:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 12:03:19 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/7] 5.4.123-rc1 review
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
References: <20210527151139.224619013@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9dafe389708c43e0b2746ce672b0482d@HQMAIL109.nvidia.com>
Date:   Thu, 27 May 2021 12:03:19 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dceaa920-8a1d-4b36-ba85-08d9214217d3
X-MS-TrafficTypeDiagnostic: MWHPR12MB1375:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1375B7D938ECB6B3030A7651D9239@MWHPR12MB1375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqhIx7iRWD5C97xaRo3HcGMeD00243/pDwZpeSZo5FI3mU+b+1PCnizyRkdDP3qnSv5PzRXttWUEKzQ8QQXLvsNSXfk4m4TXy6h85vVJy04lLBNhIHCKSE7e65wQbFyz/QmYkDK/x75JKKzQbkOEjkyeAfxgktVzE6j8YI4/K+w2pKTjDqvYHg69hEilyoZL3yWlrhce5mZAxyGPNoJBH+gqAOV7VHX/p2nOFFBiFjE6mvpQ8BrAPd9zajxJOIxynJctvH20y7WbqWYvtMmABixVTcMq1n1w080ZufCXzUFN43w6XQ9DN9mrRgW7zPhOcsW5hNNu0/CJJa0tZvDpWoIRi1HXU/v3ZQSBVCFpraEGvs9doDqRBWWja+2Xbn9hXgPSHoEPuOzolusZq11Q3yWjmkQql4FNNwZiN7hE9utnnaZQ8oU6A0UdBS7btOw/NwPmZlZUg+gR7MvnVuAcrEcbb/WkEXYLHrO1UlL111KLgg6MqXkuZS6pGv52VIhmmC9UFvo/5evW7xF93OOXpqYj+9e5XZ+KS0Ca6Dm27j7n9SycEhi620FVLQFTgu61nKd932LPIfXPXQNKsCZHo2gEkGygDxU6oPL41QhUvKczAqrRLZQVZIyrZPqTNWtcZ+y1ncJeMyfkQ3+WErx5zp1cc7P7HGR55IaIWqHuMMf0OEyc6ch1yb2AO9yrK0Fn/ER/3bi2Q/S99dNgqQcqPqCWFCSOML4V1VLawrwEWJXP4hCOKYrRyn/PmeeUK14LLeSXiylEYgm39TGTUW2Q2w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(108616005)(478600001)(36906005)(8936002)(24736004)(966005)(82310400003)(6916009)(5660300002)(26005)(186003)(36860700001)(47076005)(4326008)(82740400003)(426003)(8676002)(7416002)(7636003)(316002)(86362001)(70206006)(70586007)(54906003)(356005)(336012)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 19:03:19.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dceaa920-8a1d-4b36-ba85-08d9214217d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1375
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 May 2021 17:12:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.123 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.123-rc1-g69500752c057
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
