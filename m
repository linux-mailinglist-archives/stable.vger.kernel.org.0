Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE72665C1
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgIKRMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:12:41 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9850 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgIKRKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 13:10:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5baf5b0001>; Fri, 11 Sep 2020 10:09:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:10:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 11 Sep 2020 10:10:32 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:10:32 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 11 Sep 2020 17:10:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/12] 4.14.198-rc1 review
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <a20e5821a4d2420c9dfd75459af0e5d4@HQMAIL101.nvidia.com>
Date:   Fri, 11 Sep 2020 17:10:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599844187; bh=VLYTvYzATYd+MOBchZiaiu984wTavBdFb5DTxjTrLP8=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=sDYvikXHJlYONANcicbfhlIZu7iAuH2hbWHHHyC/wazb7UIqU52myp//2mRBTW76j
         kP1pUGhr1iu/1U90PA9DwqgnjWzUUr+sMNg+bDWe9fgE0SwSCFSXfRdrFty4mp72fE
         g3bWTiuHTKt8jJubyrzbJqBFiUJhZIjKEvhWDoetFgUU/jv6dWdMzfSav7lcXdUleW
         RAxcyOr8/uyHJ6/1SsubcJ6uhnjSZlMuJ7T6Dn3fYf87gUaVO+xeDX2s2Hkn2R0Y5Y
         fCfx/S/Dv3RhnTkrrijSx2/guxCCHqsJ6DX1Zi35lKduO5gb0HQwfoQdXLjR5sJ5vn
         Qdur1JUZYFLZA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 14:46:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.198 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.198-rc1-g69fa365ca674
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
