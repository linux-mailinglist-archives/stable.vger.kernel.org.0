Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031103C2812
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhGIROL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:11 -0400
Received: from mail-mw2nam08on2089.outbound.protection.outlook.com ([40.107.101.89]:22112
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229546AbhGIROL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUZPkbKrhSSA/ioMoO8SPeUxRnbq+C7bxv+mJ9wwJilzsgRDahROPrPIeKZWzOmVnoebnueQWzkM/k9HyoIh2GcSIsPGjd1joVxjwZdySDhzZrsmkgRhuNDmz3UzFwZ1umFZfIHNIBTR9nt+1Bm1MMxQj3+HhWAdP10q5QjXuc58XX1e0s5ubulFaj7bNoB/vKNWxdcMe9cahdJMxTrgIoTxwFNt9o37yF/N3bPZlKF7Bpgi2LPuUcpC12jEW21KGZUh4KBlIi/1ulxybS+5L5jYR0NGv/PUgtBIblaszTy136NuBFufnZZvoJytyWiTUINaKqRC5rAqrxogoIRD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1PoA8C0QxWEGBisvvunrx0M6A7w66HZxfGKEW0CORM=;
 b=KGRMBseeDH1P2nrSAYcUgYuHOKQwfuJ9HiAuryvnJeO0FOJQ+lxA74ldrzVT6a5wQjZybFkxOgLdb2Nuhu5XrhgsgeJNQyiqd99MHDKSerVRp54scC/k4zGeHCm5Xb/AUAkpZ+eKh84g/BuNxos0VrE3MYVH1IB3U2hUVS+jVuyIz5kTZ7wXGatvVTum5UJR+DF5rxAwIj13smzAvgdw4aJ+FmgD1SZYDNG5iSVfmJiPFsckcwNYXHp61E9jElC55h596W74yKOJFBllEkigS567Cjm0Nwhg7W5KxJYXgC/AZcm//A6I1idZoNWC8+L2iPrEHhWYjR/QJHR6CZujWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=denx.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1PoA8C0QxWEGBisvvunrx0M6A7w66HZxfGKEW0CORM=;
 b=WAjo7B107cSF7F+LBdtKYVbGjAXKhbihUUc75sh+WmpPY6J5/Ry+58X/q+6+v1Kc/Mbc8aELspYblNp/7EqrHxByKpMA8AzNddM/MuWUAXyF6YJb5qcgAq/7EgICVJ/nbJ6D6I8DG1t1YnFeA27aHELgPXWmVuZqTg+eKnvXPHeoRDlIUIhhdgMe8cMQG2hzJ3bn36Dah2L3ECnB/dMei8DC3ZbJNDr7VPfk6npoQnTZbCclNvNncHy1cX6UAVdIFURjSWCuBRPS2CQKEAWA3Ja+jiaPLGTquzBQOgRynraSOXrZ6O9UiRb+nZYJuArpsPV7+cLFWo8XwfoW4PCWtw==
Received: from MWHPR21CA0039.namprd21.prod.outlook.com (2603:10b6:300:129::25)
 by CH0PR12MB5281.namprd12.prod.outlook.com (2603:10b6:610:d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 17:11:26 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129::4) by MWHPR21CA0039.outlook.office365.com
 (2603:10b6:300:129::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.3 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:25 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:23 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/4] 5.4.131-rc1 review
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
References: <20210709131531.277334979@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f984d8b37476464895054333dc181a19@HQMAIL111.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:23 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3909926c-471c-4d42-36fa-08d942fc954b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5281:
X-Microsoft-Antispam-PRVS: <CH0PR12MB52818112EE64E0927A27C13AD9189@CH0PR12MB5281.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KDuDFDcFrvbHuHvjvbENvMuA/4+iiuNBQTJ7wEGWHhDtcdDA3U+eofHEKzlbVNIEf8vrd8of3RvAcn0Qj8BkvhTzwaRH54NzrMFBDSeOy4KvdKWoIgXw/Oihil8uKX9KMRHw3jZwa/Y6cyq3LnVZH05Rpy2xnOzJ5Bq5rc/yBNDOtVslsNgJ7zttceTwKLvlRHkp+KWWC36NydyQ8Hcs7+8JgUufoA+ZtkDr7ryeLCGrUAf+ZlgZTCiGXK6L1f15N9RpbK8MDYuQwn3XhlfxL+GPZQTKubp/9gV4rNDCWK1MHSdGfAIUg54xcW2xC/9UPM25zh/MnrZjn339fH/RtBwUOZc+1toF/lOtMaDG3O06Av4W2WFwXM5nhV7wum+1HSL3PTMfyxYeMzdckEf/LXeo1nQAhPbPzsJcn8WdZk95WzbAlAnYk/IP4ko+2qLsFWtQ8nsU70uhhrbM9tH1RQ8V2ofN/hxu60/E7W5PFFLAblFoIGwpl8hUaj3ql9RSAZfBbtXGaHDCnXOH3p3GP/FnjARsLeYS0qFmgOOArXTwTRTpHF72DJ+e/8EFoD/RoMUKkw91kZnKfFqU2YV5pqWvMO4Pxn3+EHPLCh5IcL8MEgea9xfTPsLlEWxuiRPD/Wagp6a/+EQr/Uv1b+Ch17smfxJJhVwCXChlXt9pRbSXgHwoXz10so8ttiY95pSRjV1denTRN7AGAKnxFlU34Hm9qufAlQ5pqN1jx4BqScVIViQ1WINm95kmAK6q2mvRfyakwIaeqEMSlD8QhNw6s88wfIV02ztf+YlwvGY5gAQP8epNIQRg4HLHjkNfwnd
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(356005)(336012)(7636003)(82740400003)(82310400003)(5660300002)(4326008)(426003)(34070700002)(7416002)(966005)(54906003)(478600001)(6916009)(70206006)(316002)(2906002)(36860700001)(24736004)(47076005)(86362001)(70586007)(8676002)(186003)(26005)(8936002)(83380400001)(108616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:25.2472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3909926c-471c-4d42-36fa-08d942fc954b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5281
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:20:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.131 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.131-rc1
> 
> Juergen Gross <jgross@suse.com>
>     xen/events: reset active flag for lateeoi events later
> 
> Alper Gun <alpergun@google.com>
>     KVM: SVM: Call SEV Guest Decommission if ASID binding fails
> 
> Heiko Carstens <hca@linux.ibm.com>
>     s390/stack: fix possible register corruption with stack switch helper
> 
> David Rientjes <rientjes@google.com>
>     KVM: SVM: Periodically schedule when unregistering regions on destroy
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                           |  4 ++--
>  arch/s390/include/asm/stacktrace.h | 18 +++++++++++-------
>  arch/x86/kvm/svm.c                 | 33 ++++++++++++++++++++++-----------
>  drivers/xen/events/events_base.c   | 23 +++++++++++++++++++----
>  4 files changed, 54 insertions(+), 24 deletions(-)
> 
> 
> 

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.131-rc1-g901498b26305
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
