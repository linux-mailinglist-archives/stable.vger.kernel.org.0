Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68205383B72
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhEQRis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:38:48 -0400
Received: from mail-mw2nam08on2065.outbound.protection.outlook.com ([40.107.101.65]:32608
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236411AbhEQRir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:38:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwbh1DlgJlKFc/P/5zBpZ0Dnknor7ZEZnuASUjjS9iUyn0cwxIP3EsH4MqYP1EjG7CspZ3KCQ/KCwWuhF4FMjsM8AK4HQZQTvA/Xgg3vHAH2bJVexYrV9WrVpKLZ3YRzpI3ESBq0e/ZvWdSdH26CmEfd9d/yRZmEGeD3fBG/Ee7TrpBARwrxKrwHI1Dys2HPHbP3K5uDJa++O+F2MYKBPdqXEGH++GQag9g3A2/EHHmI9cr7E7MQW4WVVIMQTsaHsLxz1VbvV9HOCXdDspR2ygrtpZxbPoYErdevOMtgTNWM8Tr4yzY9HZVjSB8CG6bXf8HIuSFuSyZ6y62PrImByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h53KdW+3kZwYEj8fusUobgArH7pq48MUzMmNijQAQ0=;
 b=Pw1BOQzKb19zEvdRestb+uO2tIXkpKCFBiYVqJAhcp7szNBFoDF3mRThArSANDNe+5s9zPiR/2T84jTATSelET0wID6roPNpLsspQpKPXNHDemyjC0LNCoWMMsaQKOf8RS9MxW2KW4pRQM7gyX86ndGhp19r82If4P/1Yd9+pcj3P3ZwVEd/JAJCXxKTKg0nMcBy0Kuxb6EA88cgmu1+IgC2oiiO3ywqJoYJlDCbYY1m/42cW36187y1oK/o9X9uZlT1YU5jAZDhpzBVlXBmsCv888Q+fMa76QDOqaRi9pXoeJETPaFN/trj8QIXwkY28wEzMxjO+64W46DHr3QL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h53KdW+3kZwYEj8fusUobgArH7pq48MUzMmNijQAQ0=;
 b=bSGnff+4Yfdm91PmYKrCy6AThq/hmp6/lrdC4l/nONcv8r3R5GVT3oyBRXDsEnQOWTmkpGAPyVpxhy+1sVUF3496YgQyg40B1apClcM1APZNaDUeTu1nAk9k34wG1J1zs9Tdjt+n1AXdWc86rtRxflYEvt2MmRrY04wiiecOblMZxd2cXifgqnhvvWlklOGdzG0Txz4QXKrtIiGmZbvktZtaaqbVzYKzKYWedUVYqVGkuu9nsALJ3xifOcktP+jAZfw9UCv5Fn9xrJvkoiPt+NLOjlH6Vvc2WWXhdijRimIFb51PfE00KztfQ89rZCTBXUSteaOWEp2f/9XHliKT5A==
Received: from DM5PR2001CA0019.namprd20.prod.outlook.com (2603:10b6:4:16::29)
 by MN2PR12MB3135.namprd12.prod.outlook.com (2603:10b6:208:c4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:37:28 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::43) by DM5PR2001CA0019.outlook.office365.com
 (2603:10b6:4:16::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 17:37:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:37:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:37:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 17 May 2021 17:37:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/141] 5.4.120-rc1 review
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a7784d9a0ed242fb97f3f307b212de91@HQMAIL105.nvidia.com>
Date:   Mon, 17 May 2021 17:37:25 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2efd5fe3-560c-4178-78fd-08d9195a70c7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3135:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3135B91F86E762695BE5C3FAD92D9@MN2PR12MB3135.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8gsJP7NbZhMRAl6yHGW0Ye9PdxOUPaStBhj64pSz7aQtxX78nMYAEj9KeT7AKcorzOoducxqwdsSAe7BB3SCAR+4sJZI4HmJvK9731HInWYVODXluugm1vbc/y/WbVQE4dK9BOb7yTnokrkXsNjGLQx3Tb/RMl6tk+buwW6d9NXcJpF4hXqlr5JFs58P3S8QNi29QeA/JbsZaEoYusS8mBCQd1FZCeg5uRHzG1VQGBkIagORpdOyV3cFgiCC17sAmt1RENmRBgN+o9miQ8rWgaCHAi/NzFR0e2kKt8nkccoG16tbarqqaUhPe9Ll5iyEfiIn5NKqG2SZvlsEGmLKvPP3I1Fsz42k3Dgm39fTp2Rnhl1Nt8/wkOAA28X3eRuM7cXkzCa0Kx0wMFKGMxk7GP76KfC9Nb0ev9beJCQRkEILOrY3+1ihsa2Eg9C99eZxMgToAhzce3uVjm6mUNkzLSSBeMT2aPDuQ1mLRE9MRZw8U5F5GYatubuIv9RXhpKTzujh0Opd+Zv3EUsnLQ4fWa7eqz35TXJ18icwIw66j6DKV+VtiRlJLV0YWAlhYcGYfcB5WD7gMGJLwDD95idWfPmXn1GBmkLsY6JzdSRaylRlacsB4GIoa00FHLqF+wdFEZgxcnlEL0AkzbDRdD1QjXQYBn7KxfnykGlLK7OHJJwXuL01KaxcceFvCbN2pMqxFNiPV63eVKXy6UeONMXOcU2+rzC3ABwFjkLtUUjqX8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(24736004)(108616005)(70586007)(5660300002)(356005)(26005)(6916009)(2906002)(336012)(54906003)(498600001)(4326008)(186003)(70206006)(7636003)(47076005)(36860700001)(7416002)(86362001)(426003)(36906005)(82310400003)(8936002)(8676002)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:37:27.8418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2efd5fe3-560c-4178-78fd-08d9195a70c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021 16:00:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.120 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.120-rc1.gz
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

Linux version:	5.4.120-rc1-gd406e11dbc13
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
