Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760B132BC3E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444826AbhCCNrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:47:02 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17685 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357406AbhCCKtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:49:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f56a10003>; Wed, 03 Mar 2021 01:28:01 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:28:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:28:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
In-Reply-To: <20210302192719.741064351@linuxfoundation.org>
References: <20210302192719.741064351@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <14831d5417b84db4b319d74e899c6a53@HQMAIL101.nvidia.com>
Date:   Wed, 3 Mar 2021 09:28:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763681; bh=OLecn5UVCaozy/vcWK5MrHcRWuv2P0Ykm2SdXrAFZw0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Shi8c67qbE8CIALzQb5Tw6hfzpQGI7ncRUDSWi93a9hxbpH5zN970NtLLrexui3dq
         IC3CqDwCXMFlcIki33UsyulcwSawIkYvzRaai31v+ZmT/2CYwW7kP2xnG+S9eNGPE+
         t8HDah1S6w5iYQxSFXa6caqptOZIDpP8iwIcj/2ipmYLmZ9QyjLIRTSQ5tk3JWNmaf
         cto2RzvzQUED5dOJJzWaeDzYQ6uFHYKkHVADiwTctcyxFlDWA7a5ysEOhGF+XB7UiO
         zB41Ow/avhNE3v8oH4zTqpcbkGFYHsyIIYvMWobpDXxBRXDXVfdvCO03+j/SpTgwTE
         tDcrKNnV77ZUg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:29:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.3 release.
> There are 773 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.3-rc3-g6ca52dbc58df
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
