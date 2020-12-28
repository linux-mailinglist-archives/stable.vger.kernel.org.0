Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5AD2E6C2B
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgL1Wzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19932 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729397AbgL1UTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:19:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fea3d920000>; Mon, 28 Dec 2020 12:18:26 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Dec
 2020 20:18:26 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 28 Dec 2020 20:18:26 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/717] 5.10.4-rc1 review
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c6bdcd15599d4661b139dc80654fa7d7@HQMAIL109.nvidia.com>
Date:   Mon, 28 Dec 2020 20:18:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609186706; bh=D4ZFRtRAVRE0yhFLKK12mdRifb3RT3jFUjUUBjapwTc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Zppac/4gSUwsMdV2WnUdQrBuV2BneZqEpuai+IzIHvGEPxQXelWAO/BEfQP0j8U2k
         073ySEc9qWWrYXUQh5gjCxNx1Fjw2502rSWYGt4l/cOMai+2PdCt5Y22XyZy5NCd0w
         VEg1E5zfWIE9iKwOvTPAjlJkB9++kT2ALQA2XafHo8NEtLbrRftSnoBdPM8V2wIGsj
         Y8TA7Hu5Ew+AWqYMyNhFFtc5xCOtLd5psZt+eiqhkb472zptWGgYBjoqeUrVaf/SFb
         XCNwj0pANVCaJAVtYz3dhmhFLN3BqNluVA7vZoG++nyEseSwVJ5KTPKm9bra++KeCE
         fMsJs32lw5vpg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 13:39:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.4 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.10.4-rc1-g404b2e8f23fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
