Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63534228B1
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbhJENyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:00 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:47137
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235654AbhJENxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXJTYWHDxBvVs2RUda4SI5uD4oAGyEmobBPRaLWjGKYVtn08Tc/Zr+w7nEYq4p1k5GPXReyItNiIUyDgyml1nfxyruLEsDuMoEBQgczz+6uWr934z33WvCaUtwCzz6W4F48j278tI21iFyiYaSpJ+ptBDnJWl7/iACy1T1hHVzABiWRApGGaQF6vtbMMQ4IFtxg66Rwgp4q4Q7cYW9gT16SReVY6d5bDgdo/Zhr9usO3lG9yD36I/OnltYgxUbmE+Mwnk5ZAkVa3OkfZa/m4himBHAyxkpKjTOgyQrhiS6+SRWvpvqqQ7cZng1R9Dx6YnSBJ1qJLMenqeYChamHHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFWMItnUeekyvV8lG9OV75vKYJNRoQdpv1hxIsipGFQ=;
 b=QEKLS7CgUovyNlVzJiCmYFdFWGvKvsSe+sKemLgFbVkOz6fU4G0zFyTIjktAXIdTwHCqciPiPbEX83fUM3zclDq7+idqoKFZn1XkpOUCYxEDNQBs4Ch8NF+a20dtL5f+qfS7laED0IMj/954uGVPUazw5Ft0qc+kcj0s+CqhWdQEJQw8JTj3s3D6AR8j4B56ECAp/lMZK7b/t6vu8bVruwNoTk2FwhLbz3ckf/VlYHPKQsCiMqYsiEqtbmEDUQoXnVgwavSHiwteSuLglvHtKjVXmstgH5hjX6pr7T82qgC6322oS94YzvJy0cd76jqs+9iV4spGpxXoUVTCZ8hlHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=none pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFWMItnUeekyvV8lG9OV75vKYJNRoQdpv1hxIsipGFQ=;
 b=ijCmez0KdTJAub5uBKcrD7q/WSxu68LRGcDlj3vvXCsYj61cL+7bX0K+fLnQdy83qqZop0zFqqoGkrY6ZBz+osQ2vavKDD5NF0dKOjbgpyQKWudSdiyZc17Pcw1Gv9pB1btLpSmJw8TcuaNPj8Mmj4W76HNa/QylVlf+Gl7iXg7CFA3opwIr8CiJUsFlh37oLb+UfekWkLxIsDrlcgXajfFX85H7Mj1wNh8aTsABjOjdRgJGDOZkFdfXGJU2aGg6tih1g3scuuXDV2wevbnHywse/GzPrTfHqFC10hDcZ9xOmHyRn8l7CigOop9uYSg5wAoEZwBtiVzrBZLBczGVCQ==
Received: from CO2PR06CA0067.namprd06.prod.outlook.com (2603:10b6:104:3::25)
 by MN2PR12MB4608.namprd12.prod.outlook.com (2603:10b6:208:fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Tue, 5 Oct
 2021 13:51:12 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::57) by CO2PR06CA0067.outlook.office365.com
 (2603:10b6:104:3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend
 Transport; Tue, 5 Oct 2021 13:51:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:51:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 13:50:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 13:50:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/53] 5.4.151-rc2 review
In-Reply-To: <20211005083256.183739807@linuxfoundation.org>
References: <20211005083256.183739807@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b24a164a03a8442e830ba7873a810a96@HQMAIL105.nvidia.com>
Date:   Tue, 5 Oct 2021 13:50:19 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1397ae8-41bf-43f0-fe6b-08d988073141
X-MS-TrafficTypeDiagnostic: MN2PR12MB4608:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4608E4DA8F97E27D116064A7D9AF9@MN2PR12MB4608.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KXgEQ6ni8KASgMIzd7fquA8UPrL7rq/qxZni26fawcEe6y9L43/qO2wWSXp+Fm2J7pfz4Dy4X1HQl/7xqIhWoqlmNHN7mxJU9f/FMuqbzYD0OHnF23s7fZxD2tralOjLLh7Ais86ooGI+4RpBjRPHSsm9a24w+N7mT8jus2gPKy8kmBNQEswlnoA6uaXsFuqs/C9nhLG6rVgiFEVMySetWVNx57imQZej0FlOvZQ4q2Ln/Jq8o+qXYW7BL0kM1LWa/zO4CzJwqG8nQsVzxQfF+cr/8hqgyyENG1XpYJx6lRo13qnJ5QYaEvWo2SUKD5zgL+3iS+zQicuOiFvYZQw57RZ6d/wAB34YilYa0l9g4JnBXM2p33Xxk8eoe5d5qaM6kV1WUixPcNZKXjG4jIJ4g2IiCZ4Io/wTWIuYsYn/t9j4lYzOhu5OtFqekmkIcFavye/Sj0PO+Xuv7LSCqcsi7urFDypWyUqT+SttVcYJvQoIsW2XbIbshA/gGxHYZbQAQcUQrDHYa6pCHDzbblUEqPhN1b2UADmGRibrB05isVX+OXah4UY2yopr4eZCySg9jTcO+N0OojvgZGn86g8IDWi4o6cJxMfSeCPRfB7nypvVtiX1W6hDQy6/Y0cyJbBLxPpQiMHDaFTPzhBOa923NUulSaKA2Wg5cu+YKB7cquIz8yCHsVHKRQ/IwqZX66+hGt/NWXbuhF0zZ+NsYxP9MfgsjfNTdTPt47D9O5CNTb9drn0emYFUV7s4YSUHXQS7i6LXQdsNHPihI209HdGd3FEhuWo9p3Mv9o5/jvBc0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(108616005)(36860700001)(82310400003)(54906003)(316002)(24736004)(70206006)(8936002)(5660300002)(70586007)(8676002)(356005)(2906002)(336012)(508600001)(7636003)(186003)(26005)(426003)(966005)(47076005)(6916009)(86362001)(7416002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:51:12.0483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1397ae8-41bf-43f0-fe6b-08d988073141
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4608
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021 10:38:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.151 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.151-rc2.gz
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

Linux version:	5.4.151-rc2-gf7188f3f8d71
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
