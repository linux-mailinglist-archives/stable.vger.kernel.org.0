Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5BA3CC1AC
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 09:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhGQHdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 03:33:42 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:27776
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230419AbhGQHdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 03:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVBgq6GHpxjmedX1E83tEELm3tfSTrM1CTqyMm1nfcAIrP6aAa0Kz+xkJQ1X2bW3tJXM8MjLIhWfgzdowVNRmHwWYZ/+6bI4hR9izcHgs619QVGSDZCfHXMSdI9CPjT90CevWuubgMlnfWAigG2SNCGrLLqXdlx4RhdZh+Fott75NqAcmnOSf10VGF6tcMVCackUQQRAHYagioMCtHMakEaoEyquXFY74z/fRmoFFhtH9ivqy375YrWt1wcT5n98rv9B/NCJBbnAqXTrt8U8+EtxebZoW9S7u+4jMr/xt+qO7/6cnSMC1q61UaX5Xfo3CJ0/q7tFdO0VSnPuOz4E3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBiurlDpX5kHpiGl8jtalFwt8rADWTzR/aGec36+dCI=;
 b=WZthFcdbX5HLbRyhT9Up9y48CyLduYlcB0fc5uNMn7TQRzoVw6L5iM2LXyWWR7QtOAATN0LUWvLQ7cB4dqq5scN5zvQOYjXKxRypE4Z9RFikTIR6vvnzVpfQZ1X9o4eTPLYhHiqZ1DlDSwKGv4SF86NGkuv4PwmMlDpqW5lIx4ZBtzXrMZNqnwYO5bZWIzRz8GNiWtblbRrerSTcEr8uHXgCy15+hf4VJ4irvKiPAVcr+yyJQU/LibK6uHmsb3HuT8IC/54LyMb/eXQhJZIm/XMHyjku8/FLsfe0KXeEaCIBUTiLNdcb7/9jDenLvitpImAavZKmiKo096UqdQ+SGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBiurlDpX5kHpiGl8jtalFwt8rADWTzR/aGec36+dCI=;
 b=EryQzZGZADOpuyLfEzV+HpWKohCXs7AEHJumK+cfmUWCu0H1jWNreOc4NELtLZ9/JOWg4ux2/ndbO6zL4XNQsm4+pqd54vazG1m0i7zN/02elampeRfTfaBFq7NermSaSDgPv3WPtwKhrGKRhZM2egkCjMAPa/vk11J/D620ScnsZ3yPMtmunoH4MDWxVLC34YY47BMbLRbXolZvepOgyQUSWBu/rfEi9R5z/zSK99QgphDthVbs197/5vtJ+UpnuvYaQ/LLBoAkUqkYAn9ulVd6nBrdY2Ak2tEYqlFO6OeYokrAcCGSGiW28W7dw2UmY0+GgMbW4+oGnUHd6qkGBg==
Received: from DM6PR18CA0032.namprd18.prod.outlook.com (2603:10b6:5:15b::45)
 by CH2PR12MB5563.namprd12.prod.outlook.com (2603:10b6:610:6a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sat, 17 Jul
 2021 07:30:44 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::8a) by DM6PR18CA0032.outlook.office365.com
 (2603:10b6:5:15b::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Sat, 17 Jul 2021 07:30:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4331.21 via Frontend Transport; Sat, 17 Jul 2021 07:30:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Jul
 2021 07:30:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Sat, 17 Jul 2021 07:30:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.12 000/235] 5.12.18-rc2 review
In-Reply-To: <20210716182137.994236340@linuxfoundation.org>
References: <20210716182137.994236340@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <285bd02c2f2042e1ba43f240ee024384@HQMAIL105.nvidia.com>
Date:   Sat, 17 Jul 2021 07:30:43 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c957a401-5b6c-4d14-721a-08d948f4c9a3
X-MS-TrafficTypeDiagnostic: CH2PR12MB5563:
X-Microsoft-Antispam-PRVS: <CH2PR12MB5563EC9E35C0B85D74EC79DCD9109@CH2PR12MB5563.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o49dD5c6nSStNyfc1YsNd7wHT9wV7C18deoZwZRXJA4xxkDZ9W0WYU4Oqr40jcYT5T4lipEwFJyETlJbdaXctF9j6ivMXOZxoVOonXPAKS3/QXwF1Ig2+WFuXOFEKHV37bw4nU6Pq5/an3rPo7d4RO+xGFp44jSp8cK1uaI7KpzBr9Rxp0XIT+jXU7fopsD2vTzSIsXgjax+KhUoMPRb0wMQfkEo6OYcMz1dNEofBAGinjwIMoqA+CK7gi+bv6ov5/vbZDwswP/mp8v5EZb6x5bLlgZ4Uh30aSbkX1xpv2bW0oauVdG/j8l0xo9iIhK3zNLmCq7gcuP7JZUggwCFOKqJtmmVlNyCf6frjSjgKXjNzCPD1AR787Ahn1pT1whp0lgtAaMEzNkoHsFOME4AwLccOqUgANEg+8r5hWQF6eZpFmU4r/e/wdsHlL5YTikK8SoUpPa6bRgIty/7mQ6gciCJYa2Jv7BZfMQvdGKWbF/BsKNHfswcOBJMxKIXLXt3Zy6OooO7F3hUS6UEMlOWIS6ZiKod31319tI84ewCNj689HkLWVYpnqOehiTMzUT/JEAfKFHucdub/yPWgQ81jJXBh4J0Ric9PrNkHekwPZG7KvmUS5afIB46qBW5+d3/b0vqsg6H61bzQpU+U0qicYLEkIiSg38UvA44k1BTqEMZqS2v0AitOn1pY87G16pk1KkE1LFo/c5d5gLXPR+lOCu6x6M4qaGJqIIkxWozK0eoqhRBaEy7cGYAkDgQeT/TWt27Cq22N90v4SD/bF1sJ3luAOVBV2rETfypns42F7aR8f0B4V8JW1A/uWg8A3L0
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(46966006)(4326008)(82740400003)(8676002)(70206006)(26005)(70586007)(426003)(82310400003)(336012)(54906003)(34020700004)(6916009)(86362001)(2906002)(478600001)(36860700001)(7416002)(356005)(24736004)(186003)(108616005)(36906005)(8936002)(316002)(5660300002)(966005)(47076005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2021 07:30:44.0558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c957a401-5b6c-4d14-721a-08d948f4c9a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5563
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Jul 2021 20:29:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    110 tests:	110 pass, 0 fail

Linux version:	5.12.18-rc2-g55f470748e68
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
