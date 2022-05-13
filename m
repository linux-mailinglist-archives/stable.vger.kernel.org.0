Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0D52673E
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381108AbiEMQkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 12:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382081AbiEMQki (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 12:40:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF513263A;
        Fri, 13 May 2022 09:40:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnmYi/+uDVUh4P3czwJxFLLxAoApuL+riKxpwgamEz9vGKJxS8bFC9Nb3BB0XQTCD+eNK0k0a3E5W8wHKczO69rs9FaqaQfRcP6kUlTnlLkQEXlo1MHm0XaVnzJ5YkwSXiVYZVb17PrzvYz1juHAi/DCXX6cTjnE3ikjPyKIzJhtFg+5GHSnuP0PQHgj5q9pFb7Y+Q44dnxF/jYSm2t1gE+VoZFw1ktbi6N/tEusEsWQpb+YuN0RVds08/U1nHQn/FUDD8v7dkA1ouNDX8s7FiwhJGLvj9wy74Pz1nztJ4MTY7hooy55uDEY9BDgb9aOECJlEWpJ35NaJGeTjW7NSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ATNG85VKi800UnaoNj04HfnovTW5eJ50GQy9v3uP1g=;
 b=jiaEw788/b0juVdQ8IAwWKYt/AzxF6ib8fS1rPm3JxQqtrqvSSxnIVuJm24eSJxU+plllAWY+UQ7M5Ug6MHQoDno7xxvbA+P23OnJ3ZKM7LfbyBXWtH54Kb7xpIGy/D3OGnLCUH/Kub7mAuhoswbXkg5y0Bpm+2Vi/1Q8adlpgCTfGP5AhPa/1GnQ+ydciKt535uTRKrlj0o/FUwn7bETAUiuWLYo6XgAhcKXybsWyWi/kQyY8Wq0am937qPv/0Www0scHamIiVfZhuaoOPx2D3B9YOOIBQZHREUmx7/nmAGwKWDPeY3H+WmnSX6Jje9qXgf1SC0/BGxApL9QcPbMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ATNG85VKi800UnaoNj04HfnovTW5eJ50GQy9v3uP1g=;
 b=BZjDT+TFO8fl+QhQYi5m0hnq6g+vUzgQaPuA6SWmNQlcAjpH5cfuhjkVof1KUnOj5TYAy6mnRYvTODvfoI0GdujawH2maAuZ6+Pfdgpg8MH2bcJXrT4MpGCDvikM7MTylFJ06AzWyON0Op/uWxhMi4PjYcs3mE4nIRi6aQysgrBYIYwCRW+FaMf2mVOgx8avy2VmyIMAVNffuQcpfX/Mw6UibT9sEQFjL5Rof5qPGLwilNNZxsEblFqdzKdy+dxUb0EVdVrdccarfEPsaJBolFhNTj/V5FrhIg+mNuEtZYKtF/gwD7lXRhRGpfWohjxLDX36lzZngAkwF4XUM7MCWg==
Received: from DM6PR06CA0069.namprd06.prod.outlook.com (2603:10b6:5:54::46) by
 CH0PR12MB5154.namprd12.prod.outlook.com (2603:10b6:610:b9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.13; Fri, 13 May 2022 16:40:36 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::eb) by DM6PR06CA0069.outlook.office365.com
 (2603:10b6:5:54::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25 via Frontend
 Transport; Fri, 13 May 2022 16:40:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Fri, 13 May 2022 16:40:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 13 May 2022 16:40:35 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 13 May 2022 09:40:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 13 May 2022 09:40:35 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/15] 4.19.243-rc1 review
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
References: <20220513142227.897535454@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2967fb47-8c27-435d-9f0b-83afeae1fc9e@drhqmail201.nvidia.com>
Date:   Fri, 13 May 2022 09:40:35 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6674cdf-3d40-4a39-7389-08da34ff4e7c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5154:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5154FF5E8850E229D6595D57D9CA9@CH0PR12MB5154.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vGTBjIDmc9+INXEpyRMAGOGGUGlMGGJZV0FiKeiWOoC8quEWWggRbb6WkeDUC5ATsOKFYsd/cfPAdbAWLfVlKoRPu32OnV6lA9AW3Ytq+rboLklP4k/UwQ+aTUq8WoApHjI5QCtrPHKWOyADIwe4L75RFqFH52EWsW/1oL6SPP9yBS6CCMNx9GrafbrMuWjmz3/0IZaEcxqymZcStydUgC7/wiTA6MC3YHjGouAa7MaJsOTJUQf/iOfvB0hSo/q3Ir6wKW+GzhdPuDO4Hj8wq5atDRuk/EntlcrpeABnXfmaK4TTXxZDAfy9PEIXui0DwrXpQbm6ewKL2OfMI0KxpV237R3kqbVdDUZ1jsQFLBwFz3PqbNc1G7tqhyJsVBESuglgtdnqnXbG4QQcgGSxe/qCMxPaNnmKXrcSG1O+lBHJ243xk6rRVcL4C9xVUANcMzuwNaKJsdURFIcCJtIVvJhoY3V8o96NwGRJ+MXeykwzShnFJvcKNkkUmIVH2CvFhpZ/MXMIhSmOuoClxoiTFpmO5K9ry7bv2iLePoVwA7FDA6MxaIGqazjtZy+XMs9FACk8QiyYSJWUjG6v7elq+JHaBM050i/h/qPgBmVkILQ8qstOSgG3xCPFOSzx3/QBAj9ufPoqhcbAfOMUDWUzpn/9SP93QJayPBua53jNNceRSYItynp9BuHKaJ4zwJ6Llc7Nv5jM0ZhrRndq5T+VyBBzx35/lTTh8qMVx0QSvvu7FzkDhqizAL17b9CoQ1NZpdJkHX26jfm2ObSK4XtKHosIw28JwombJxDkYZuV2ls=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(426003)(81166007)(54906003)(336012)(966005)(6916009)(508600001)(82310400005)(31696002)(86362001)(31686004)(186003)(26005)(47076005)(36860700001)(40460700003)(8936002)(70586007)(316002)(2906002)(356005)(7416002)(70206006)(4326008)(8676002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:40:36.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6674cdf-3d40-4a39-7389-08da34ff4e7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5154
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.243 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.243-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	4.19.243-rc1-ga96b764d90b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
