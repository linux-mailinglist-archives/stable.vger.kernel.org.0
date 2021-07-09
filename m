Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978AC3C281B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 19:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhGIROO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 13:14:14 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:60295
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhGIROO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 13:14:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbDWoGIJSdGv40sjlN/y9LS4/AEW8Wnd6Tcrp+PV0ixrKYp0tgrjX6q331WC/EZ+7bPFsgR29topgmO8piqeaWNs0jfO7T6CO1nKuDjKiIrmm3iIdfPbTmEfFRLka0nhQm3IdrNB59MrEhjZ8r0jxsXutJIhdK2fffTngxFTQbM2n+89uCBhmqu58KE3mOobtcZvgV7BikjSE5ruSzHMPD/a3AX5FoCEwxV1HpNCQbezHwOTCIHArp2edHCv0bQlBv9plB+0vidHTFjX1ESaxW8ferYeMZE70jTCKTXfW4PHCDql4JqT7rgD7iLj3+WeeUhVlTr2EyzBlyNFS8oqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TW4BinqK9D8v20J1i8JWAr/O2HxkwOcYxOn74l5cp4=;
 b=kvVW3pQ7xaLxYkhqtBLhhKquZ6K9Xs2JEZyAuIxqJrCp+YQ9M/F8hB0u1KL39tXvEu9tAbYJsUjwPPDKgnlueyqELFZ7gYxE4hv76ks6IbS19YtBd2WUX5SJs4v1MYbrJjIqhL4xL3tVCBKqqze13KZTkID1VFkRh6FDhQB4Wh7Ddyq5SuuemxUAquGoFXBlcpYiEy0AQwa1/dag1exsVDLPMJIplsCqRTJPSId+P/p0dUJY2pi/Ie8gekn/rfm3cCn/PG9SKhESfGyFBkJVM2jh9738klZpzHyAdgbNKxNo/Y8Eq9I8Unigec9u52ORrFkz5Q8Ptu+cHCPU+ERnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TW4BinqK9D8v20J1i8JWAr/O2HxkwOcYxOn74l5cp4=;
 b=MNilCOu+RSuq2FQDcV/EueRs2iCWoc8A0msbu7G2iYfHmo6VKuAXtiQOhDsbGT9en1EGEd3cwPFejdzdENKfLseMyhnOIvjCV5rVZkNg8+w9mKsdqNGxRX1b0qe/jO+20mWVOssCpXRueHf4kOcqcW4xUOpFVxm8pK+X3soOT0N9+1XIT066cC2U5hQQhM+TLTriw5bg8PSEk3Bcbd5DXUWVcUuyvcP9oiPIc9EN6rny4AMaYDN581ZkjiSo/IhkWFZf5SGI7wfIvlPUCp9gL5N4SG48HQL6UuBKW3bOzvdwjXxOqERMB6dn4ZDXUspkcIcG71NuA6tGNGK+hzEH5g==
Received: from MWHPR21CA0046.namprd21.prod.outlook.com (2603:10b6:300:129::32)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 17:11:29 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::a1) by MWHPR21CA0046.outlook.office365.com
 (2603:10b6:300:129::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.0 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 17:11:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:27 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Jul
 2021 17:11:27 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Jul 2021 17:11:27 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
References: <20210709131537.035851348@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4dc88f6088834afd84804e403cb2edc1@HQMAIL105.nvidia.com>
Date:   Fri, 9 Jul 2021 17:11:27 +0000
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1235e109-b4ba-4b2d-fcb7-08d942fc975e
X-MS-TrafficTypeDiagnostic: BN9PR12MB5340:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5340073186B8089B5BACE39CD9189@BN9PR12MB5340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxIilSdbtJM7b8NBCgxp1fYCAqMsFs1pqXhXvb9ejmdcZMQpd42zaerOkrqlaSsit4weoLcvQMY2blUw945Lu52qXAT4JibeeDpUtemwfsW3cB9GJdgJqN/GAydfo4xoWUbbF9GSZEKXch4MqtBS0qnyI89kngpMUtM4TA1SA5+PJWRSD56i1lhYzDcVFVHNqSxrbuUu5E6Spt7W8bRcOqFVdJCx6hH8BYVr9XpGriyNE5HRkp5s1Cyq7AdoHoDj4tz4Aj9q/Z6sv8HQP79e8NT31fVnkHorPbKCaygrY+4WP+eLmQiSJjX2v9685HSvXrmYM0oiDp/5JViPNP1uudnorEEgxa6ocG6NTjH1/CmsKgEXheGMlDZH6KDvipCYz6V1cYHqmaT3FGuZualboIYqTYmLcb9hyHGzy1mzYe04bfpule5W7hnaqSy51BZkSst1fsapUAajE+ihk+vwY1vaZp7oEFYZvdtp0sWXwwriLhrD0HKQNdfLKLq3ERRekGMMyYUl+tLDmjUK0gKfjVxzDM6w9t1cQapNBNkF8UTKXwFdhRpCLM36iYXjhWGWh8C3PWXO8BgyaIANVMksYrdB7cUnHC6ieCD+3m6hllgrInAwKcdndrI8nGwJ1ojjZU3GEJ+7atG+pA68x1IDgGdOqxdsf0cmO41Z9W/KRcyi7heWeILuZ9aPsqwA+lJuNqVmEFq7NO7t1LEKUt2YjJwiitxD3yre2ZXup6gIdDjTDH6qy+jG/8/Sxv24tVPS7IVsUdLIvnHtHXMx156PeSaKLjcryTU4up1ngUwWSeBumzroNEkHBiF/VG5k5erA
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(2906002)(108616005)(82310400003)(36860700001)(70586007)(86362001)(186003)(24736004)(83380400001)(6916009)(26005)(82740400003)(7636003)(70206006)(356005)(8936002)(426003)(478600001)(966005)(8676002)(54906003)(336012)(47076005)(34070700002)(5660300002)(4326008)(316002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 17:11:28.7312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1235e109-b4ba-4b2d-fcb7-08d942fc975e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 09 Jul 2021 15:21:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
>     Linux 5.10.49-rc1
> 
> Juergen Gross <jgross@suse.com>
>     xen/events: reset active flag for lateeoi events later
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: change jumps to must-extend in futex_atomic_*
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: add target builtins to kernel
> 
> Sid Manning <sidneym@codeaurora.org>
>     Hexagon: fix build errors
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     media: uvcvideo: Support devices that report an OT as an entity source
> 
> Fabiano Rosas <farosas@linux.ibm.com>
>     KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                 |  4 +-
>  arch/hexagon/Makefile                    |  6 +--
>  arch/hexagon/include/asm/futex.h         |  4 +-
>  arch/hexagon/include/asm/timex.h         |  3 +-
>  arch/hexagon/kernel/hexagon_ksyms.c      |  8 ++--
>  arch/hexagon/kernel/ptrace.c             |  4 +-
>  arch/hexagon/lib/Makefile                |  3 +-
>  arch/hexagon/lib/divsi3.S                | 67 ++++++++++++++++++++++++++++++++
>  arch/hexagon/lib/memcpy_likely_aligned.S | 56 ++++++++++++++++++++++++++
>  arch/hexagon/lib/modsi3.S                | 46 ++++++++++++++++++++++
>  arch/hexagon/lib/udivsi3.S               | 38 ++++++++++++++++++
>  arch/hexagon/lib/umodsi3.S               | 36 +++++++++++++++++
>  arch/powerpc/kvm/book3s_hv.c             |  4 ++
>  drivers/media/usb/uvc/uvc_driver.c       | 32 +++++++++++++++
>  drivers/xen/events/events_base.c         | 23 +++++++++--
>  15 files changed, 315 insertions(+), 19 deletions(-)
> 
> 
> 

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    70 tests:	70 pass, 0 fail

Linux version:	5.10.49-rc1-g5b40bcb16853
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
