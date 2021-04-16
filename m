Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C336361D35
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbhDPJWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:22:20 -0400
Received: from mail-eopbgr760070.outbound.protection.outlook.com ([40.107.76.70]:29717
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241741AbhDPJWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvEKuqBMilFFz7dlL054FyPWLVDDP+nEM+zATjjtbsHU6JDaBIm1JRr+5XVoKIymvgDppGHAWdnM9jZej/rQ//OT2bze9Z/NhNY+OH40t4cT/DzHJ2MHINnyr8xY0KTalY2z5fhwgwTUja1Drpn1h2Pp9B2ZE4wtz6BBLUrcu8saU06wFE3q/vvYf2QCtTCGdY5dsOvYXRHFO5k4EcIZx9A1KbhNUqtX5+tuSf9g0QJRxifM7G1kkLeDuU0QBWBKGCeJ/t4cMSwp6WxKEgtpJPLDNK1kCtkyv1S/tEyrgxX6cU/DPVcZy1Kf/LL/RC8Z0mPdt5D/elwjbWmRl4JhbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAw55BQeIvA4qMi21uTBuNeQ58zA8JfHIk6BQrBnv8I=;
 b=odRULJMG2dTtGlGj2jfaA9JW4NzDcC0Sxcpi6pw9vYN8rNgYGzfjtSyI6PuLm9Y8DvAF2XB976nR0PZZnZe4cnTEelDJ3kdOKtAzbrdXlqXkWjSaSycdI6xtXvviQbouRC4ZVx2iUW0sOfMCYH/CUKQ51Fv0wJlCokAovxeMWZkgopl70IsoA1PR2TVDs+8e9jnYJ7G4NsaCATDpVhTLgR0pHkWxpy4sg1TdyPK6V26kXzdWhHJAzGBCFQ/RRvTCvzXVDp9/3bvx6j6YJhqjmUEjTpbluigKc+9ysTvQ2JMpxEU1jRDp2Sn1Uf51FXL1jQsE5/lGk2VQgc+0AXFiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAw55BQeIvA4qMi21uTBuNeQ58zA8JfHIk6BQrBnv8I=;
 b=JMxdmE8xm3rvNA8SplRo2BI6bEoKkYglauy4dr+bvSuoOKJNdrWW0DDpTRhDiOcraYVdI/IyTExdQoQcBcavOX1oM6Sfcp4T0rQg//kCOzSbGJR96C+FGC5nbIaVBe4upMCtMwmTx5CGi7EgHHxgyxSbRV7iCFp7RHGGrZZWilOX0NVc/oCUY3TzRzmpaSe9Chhax+S5AsHX0K73QUwgnmoA2kXYWqAlVn/XAtSnRtXjMvK4c2HtsYyRqnKzdjCwdtIoV1ieuEAEi2HvXNM/MlaCAj26v4/sRyMrsEjKQQsQsaFQAIkVnO2v/qZK1oPNrYbKzA/JK08uLfNM1OByVg==
Received: from DM5PR13CA0067.namprd13.prod.outlook.com (2603:10b6:3:117::29)
 by CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 09:21:54 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::e0) by DM5PR13CA0067.outlook.office365.com
 (2603:10b6:3:117::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Apr
 2021 09:21:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 16 Apr 2021 09:21:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/18] 5.4.113-rc1 review
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <eabb7de3900b406ea8922161a83d4f15@HQMAIL107.nvidia.com>
Date:   Fri, 16 Apr 2021 09:21:52 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 117bae65-cefc-499d-1bf0-08d900b91302
X-MS-TrafficTypeDiagnostic: CH2PR12MB4119:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41190CC3DCAD58929347C51FD94C9@CH2PR12MB4119.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpCnWdNjRdbfWNb72/M7a6Cz/qY+hq9SnGH8lSugzKOJZHb3GeXojw1lDYS4JoG+1MHd7804jv1a66bI03ugW8xhX5f+QWhimKLlK8S/Z/+oIxYYXOecgv9WULsD6MA/i4Hzbp6MQgPhYmUwwevMixlc++qd5Amlj5lAoZKlaMvFOZGEKWbUuY0FqnqdSSt7prq5uqUjnbDXH01WU55AdNGyb4bQ0lYWGe3zCmAxke5DvoYSTbzhHBzjc9/K8bPeMhP9THZmfxjUG9lnGJXDIzpbkvvwuGO4OjeRcG/ncu0vrsD6Kxvfuw/VYuaDCg8fyT6waE43fTHWdUfMOcsFE7eXzr0ROTb2Z7bif0PZOFDZ2LsrJ0O8hTF8s4/M28yR33EiwQuGwu49yZ/ycIL2JwoaG6Tm4wj2MB0J19dMFWmElA8mg6xj6Kq0oYfDn0vGClHS72zZFrzrpN3o++W+vg+wj72FDCB9rHxnoPe7fR/L/60ahB9MoU4Mh9d7Da8kHYJ5ESDt6y+lVkBf9y3t2q9TMXuU7VsKa9EQe6NzyF7H85npVc9F+f+/op/3TGlzynWoqQdq/A7WwvsHE1R1E2eTXfvCdTZ585yaD29RxDyBI6PF81t1NkFD5iSvXq7qS/7f3FFk/RcJ+n26l3wBRzZ7F+LugxKjphLwKpZuSqE1KxW0Sbx6M2N5Brx7dBpoo3zkSnQXXCLd35glblKMHtGonqT0ve+jkeFIBLcsX1A=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(36840700001)(2906002)(6916009)(186003)(7416002)(54906003)(82740400003)(478600001)(108616005)(24736004)(336012)(36906005)(8936002)(4326008)(26005)(356005)(316002)(8676002)(5660300002)(426003)(70586007)(36860700001)(70206006)(86362001)(966005)(47076005)(7636003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:53.6441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 117bae65-cefc-499d-1bf0-08d900b91302
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 16:47:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.113 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.113-rc1.gz
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

Linux version:	5.4.113-rc1-g0d80f6c61d6b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
