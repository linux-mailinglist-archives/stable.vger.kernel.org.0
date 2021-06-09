Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6541C3A103E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhFIJi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 05:38:58 -0400
Received: from mail-mw2nam08on2054.outbound.protection.outlook.com ([40.107.101.54]:54401
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234392AbhFIJi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 05:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeK1sOMMCqLWTKa/uiwHg+6blUohtrRZqiR6xzKx0oOMH+IK/5iDny9SQLjcDPLFTjsB7LIxOU+DgPneKQlWrBK1lv0ssG1Bl3S+rsh65MfnF7DIDhxJAL1UlTMdc1E+k6dkdY3OwCLvGnQD1tWv923nG084Dp8Vy0+poUg+qi+cXkYqg5IgXGlTfL2Z47uaOjmQyBNqihRu2l7ixOjVMBcAyzwqxwz23TYEt8qnrCO4XoRX7NXP72gGu2/jBEVSTOTzEZceO+ZuUsFPsb0vYDYNKEb2hup7xnDWMAlDqMry+y6q8MwJ7YgNylZlon87Ey/uTINLToMcipInEixzoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0ggK9k1R3lBnmPT1Q7cs6kOfEGcsWfK66FJiv+ftOU=;
 b=ATQrCY2/NDpaPY/hmIyisEtu9ipJqyDCgAoBzsE2ADfw99jzbh1nux6hwoOI9WDAgmEk7J4LEMgszlwkDl1yqfsNTn9L3UrEEpFinG57MlxKwT0EQFQAOfX/BgKhw7XUNxNsurXyXwiLJ3N8DFx3d3czJ//VLuFwTVMCqEME5V0/33il/xUuf43UdYXP8XEdnS4s1Rwo8MehwRWGE4ILqECFxeyzIFw/vgAu3qqHPo6EBaNj/L3IBde16/cmQ4kNWYwA9pEW53Ep6BZRB0zvPzwGylDtTfZ2RtQrV4wFCZyLf9Hgl9m3gIILMAJ9dJxB9YsE1HBz1UAUO/jlD5XCyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0ggK9k1R3lBnmPT1Q7cs6kOfEGcsWfK66FJiv+ftOU=;
 b=KHHNp9FsS4bCtubhBam7rSjhBWmJpCprOkuxhnYD+jEoKV2xKuU4rjA5RMmrEwiIfzC8iCRLEPiJiuTFnPbNvimKtyeN7eQPAXTQrTTuMdnzUYBdiK3qCXPaz6+GhMmdKcpMfLHcA045c+Ym8OxOxFpnrgeej2otg/xhZPFxntalrMQgvev0VU8fICLd6mdcxtPO+HvCh3vukYIgY4PuVfcZd24WpaNU43ffP9OC+CeUF3MuEjGECk9d1wUDTBBj/rQMDyqdLQ8+miLlLDn60VsM0EO1tTvJyghfy7Z1QXcnR/WI1mhGjKCZlFz/OgPNOkdKzmZ6Z9NM3HXXoQHg6w==
Received: from DM5PR21CA0015.namprd21.prod.outlook.com (2603:10b6:3:ac::25) by
 DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Wed, 9 Jun 2021 09:33:59 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::c4) by DM5PR21CA0015.outlook.office365.com
 (2603:10b6:3:ac::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.1 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 09:33:59 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Jun
 2021 09:33:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Jun 2021 09:33:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7e81c02bb6bb4ccfbaceb50c0e897023@HQMAIL107.nvidia.com>
Date:   Wed, 9 Jun 2021 09:33:58 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b480d3e-91c9-4833-4052-08d92b29b5e9
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54006B709F82F202295FFF2FD9369@DM8PR12MB5400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oq6+0dNH4UXzWebOyww2/wfC8eMRY2a5FKTmU9JLf8+gtw5/DpUzdjE291EtMAla2yYkiHGUmcOIJuZLLuVDj4icsacweU1f4ThBNjNlaIF/F3OlFmyuiEc+dL+2j7/MU7IOEU4rLcyjsUZrPAHD1uc8E9CRt7Ujzp8GVVQ72UYRWjncF9zuFZU9LRBMTUU4ZdnHTgDt+iwyBED2DJQFW1XEz6CTSIvgao0hgwaPYmCfJKyxE7mU97j4RLva8ok055QMmWMrFPAEd3d35wBqcaHel94gMDtMuhX1xossk528b9cCqle1jKaKFel3axd2EkTkHwbeX+GRiKvK8YCYvpyR5ygCglDcYNKZqgBUt049/3N9Et6F8/Rw+3rSHZxDxBROGchcOdh7pJ/cHq37/gw7/4G/HO5TTxwB58xf+ACBP1auSWO4YJhyUH+2QVf9c/T2HP+KXBrndJIXz6UjfDcZkRtgLraqU7ao3kASqz5hvk3eWs1T5iiR/yW1uZaS8T9XJY1VcThbIW4y+6WnnR1F+I6cReGSAxiJWuzRZArF2U6XNWJXSTD2FYwbxPrC8aOsPPqxtu4X4CFe3uYv2cajNR5MfTwjkAtpD0NqlrQcU5CEdMyJMocGNRw5uo/D+FZ5oh8d1rbWj9J/6+dOSo4NOAvbn1zvM64uxfJ3Eqr7q4Q6H3BEvzUpRdxQOiSntT4mHbMF9LKU9OuXFuHOwncTIMDsSCks7jMgdwkQR6mLILzaYUGLvSA5MQv0Rpq3KvrwDru0uSTIBUHpzFPI9Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(2906002)(24736004)(86362001)(36860700001)(8936002)(26005)(336012)(426003)(108616005)(47076005)(82310400003)(5660300002)(7416002)(36906005)(316002)(82740400003)(186003)(70586007)(70206006)(7636003)(54906003)(8676002)(356005)(478600001)(4326008)(6916009)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 09:33:59.4162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b480d3e-91c9-4833-4052-08d92b29b5e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5400
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 20:26:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.125-rc1.gz
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

Linux version:	5.4.125-rc1-g90487dc4fc35
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
