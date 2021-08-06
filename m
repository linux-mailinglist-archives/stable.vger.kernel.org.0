Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE53E2C9A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbhHFOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:33:27 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:59873
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239842AbhHFOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcM+BzsE+Qvejccs4fScmtw+R72Ovozu9ar2K7XUY7yFx5o0TO8/84FbvYRqOqsEqeKzbqh47Qwk45ONCOyxy90C4IbbzNIBrR3dqbISaJaESeb+x+u6h4+dUxn1iiS+XDX0YQzxLrmuwmVhm0W21XulBG3J8Kjo15Y8b26NPLDzzGOWB5yLzvHyiL1GpiLibXj9bSW1EKF13quFtWNP5uUL4cZRySo3JYkKnfIz5bLCAuhPdE4X0sTrogpgtU3y2/UNnihQ9wLJDpsOGvVGGz+tgi35aQX3FcE+ZslpYvKyrmD0ckTa7zn09ZwRCrYLpnc60KT0RIybZZYgxeDSLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1XwkjyOyt7AxP+g89Rc5N1Y/oaXY/j+hOcgD46raQg=;
 b=AM8Zsks2am2eETH6lk6BdjoAZcrFa+SAKq9Sr0ch7B/vHEFCk4AUnTszMrTVp8WmRCWPIoEMky5a9s8KAZ5HIkxDnWCfbsNqm6Y6xJOapbYrKWoVBZzA0yNFfeTfzOP+crnW/iYX8wu8zDjZpyI2gSN5KJ7lhyAfZx/Mq59apRPVqUc+25sVcSX7kh2CHFU3oYZSLxQG8LcZOBO76tLtGIOP56AIqrh7UtqIYSQGBwNoWyrEdHxfD89lu7tpub5t+D0sucTPW3Aoh3s0RTa1KxbjDR0pRmacN3Uxz+AhdrTz/qsyUhB+ifbZK8zy91Otq+8zCKjCtsCn2/94U67kuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1XwkjyOyt7AxP+g89Rc5N1Y/oaXY/j+hOcgD46raQg=;
 b=D/qU8YzdCfcuIWT3iFwTthaXh9YTP1MKXoe5qPjRrREKV4rQHW4TCA4gpY15FuQ+UL3/T7wkR9rEwfApUIbEc0Gy8Ab5GyeN1kKxuTkRelCAk6bBX/8YpqhtrOI5igzihxAhcfNyIspTEg1CzIAMoRf/mMwt1INg934oCCPzgmKsXRy3Zi35DuWZk33PxwzvTY6zoPWEO+lpvkAL2xOUWYdQocuqcajMgpwDAvg0BOTb3EGQwZaY6qXaVPFn9lD1ks6HudlbYkm4xTaYBTPddmOEpcGYnDR8wPJs9gMmCk91toeXYY/bxMoN0TcrxMsSqcNMoFy6vuZ0m7oh/Omv2Q==
Received: from BN6PR1401CA0006.namprd14.prod.outlook.com
 (2603:10b6:405:4b::16) by MN2PR12MB4487.namprd12.prod.outlook.com
 (2603:10b6:208:264::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 14:33:06 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::e6) by BN6PR1401CA0006.outlook.office365.com
 (2603:10b6:405:4b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Fri, 6 Aug 2021 14:33:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 14:33:05 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 14:33:05 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 07:33:04 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/23] 5.4.139-rc1 review
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e09fa11b96454c40ae93f973b1440cd7@HQMAIL109.nvidia.com>
Date:   Fri, 6 Aug 2021 07:33:04 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ccbb833-d6bc-4b87-370c-08d958e71ac0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4487:
X-Microsoft-Antispam-PRVS: <MN2PR12MB448701B1DA68008EDC62A292D9F39@MN2PR12MB4487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGxz45mSQoHh6yI7qKa2/BaqT1fAA1e7Bo2lwNYvkK9RpwI9r/rUKG1fvdC6yhoOJ4xbYiqN16oQphLtA0B6oopfTfyrtw4UDQ4xfnv1aMDf1dEOLEQEnQv6NYzmEO3Nr/WQGWyWPbnE1vs4SK0VByQDUWu/+M1d2/hwQ/bHu36nnJrSwIaqcODWl/LZbHwAo4fv4U/LtcKRLcF4FbmKGaBBRBy4BVYFZvcy4xnN0Umo+u7kwOOtXmMLFs/QpEbrwUShsIgu60GBk2Dvd4hEd8Cmw/U7YErenEjoFD0aPIT+boXlmlRyykJLyUbvDHFCu7ffU6AfTAEHuzSkTFrrJZlDaxeyPSA0F+AbX8EBNwKFHlliLZ2gv+EqkrryNAyzM7wqK7D+nD9BbHHv7GLu2W8ZBefP65TNPsVZR5zGQcuwET2Z1lL/dw6roEB4Sqw7/kis+fU6VuZN0Cklm0+hNCyFsPJ4hodHaDMXrPAqOhHKnJLpq3CGUOFsQA2+LQe8ziqZrTZ1pV4/2p+uZg+ti5LfiKDDSa1XHRlY0oF5gzg9lrgzM1tLUVq9qA5ZJg6IXlix0SZlEC7yzLfvC+7yfhtvf4HRBAbnk5GzKVgAHl2M7GPjR+iJo2QNzHcCWrn88+Kt3eSnVozr57uH71/jjewX0q4/W/WeB0ZPgw5h3NZFnjRz414ACx9dsUyQ66B91tNaZ3CKQB/m+W2TE5WgeyTOooBtKHFR3jVoXCmNLC8iQTfIa3uJE7I4UUrXmNa38xfvte8f8Hk5dxG5mJzjDg5AN/t5p4EUe5GenWRZj+8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(426003)(47076005)(7416002)(70206006)(478600001)(5660300002)(82740400003)(356005)(36860700001)(54906003)(6916009)(108616005)(8936002)(82310400003)(8676002)(4326008)(7636003)(26005)(316002)(2906002)(70586007)(186003)(24736004)(86362001)(336012)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 14:33:05.7461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccbb833-d6bc-4b87-370c-08d958e71ac0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 06 Aug 2021 10:16:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.139 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.139-rc1.gz
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

Linux version:	5.4.139-rc1-ge6d9a103071f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
