Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE1283DCB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgJERyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:54:04 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1188 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJERyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 13:54:01 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7b5d4e0002>; Mon, 05 Oct 2020 10:52:14 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Oct
 2020 17:50:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 5 Oct 2020 17:50:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6d5c5d01ce7c4108b8610141d8c8648d@HQMAIL109.nvidia.com>
Date:   Mon, 5 Oct 2020 17:50:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601920334; bh=Ovf5MnDnwIK/EmznYAtXVU1RC1xpPEPAPLtYKNMLua8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=H9EMtRSUt6LaD4NP72UEaudMHDD5/Rdjqr3cTavhaEd+YpggnF8rLyTbXFQoyVeRW
         bjk3eqb4b4NZ9J0YQSrpgh+nuDs//j3quDlgElk7UsCTMItsU0QWD4loHgTFIPjo/k
         V4rdJc7x2Zj/XXOEU27pr8MMGAqeKpx8NyC0M87TYlBgxTs8xQJZW1q7Umd7y3peXq
         KcPlgzL1JzFY4IKyJJk1FJPXg5TxpEvPbBRicfbK+vQqptGILTYlDbdqXcv7Vj8uSO
         dhpx3QuU90L7TOB2KOz5cw340GCnvdf6rXbFsyQOORM4l0SN4X0u+sGCFMzWLuBTK1
         DU4oJPxculV2A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Oct 2020 17:25:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.14 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.14-rc1-g8bb413de12d0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
