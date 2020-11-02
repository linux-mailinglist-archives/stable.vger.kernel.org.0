Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4352A277E
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgKBJxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:53:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9369 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgKBJxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 04:53:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9fd7320002>; Mon, 02 Nov 2020 01:53:54 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 09:53:53 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 2 Nov 2020 09:53:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/48] 5.4.74-rc2 review
In-Reply-To: <20201031114242.348422479@linuxfoundation.org>
References: <20201031114242.348422479@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d51554c67f17476198038de0eda9bc7c@HQMAIL105.nvidia.com>
Date:   Mon, 2 Nov 2020 09:53:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604310834; bh=xVFgsKy7LLtsUoh3tRpSdwj8ppeYTQOv7oMN3FYbM1Y=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=iXwBvHRfHjoEGVtYTVmzpz0cgWbX5B2NQIulFlEJQzlwGcgxi4F48qkUGIXGrd1Ia
         dtTUy4etaK3HDpBnQ4gltaivjINt8T4gKIDiRTAi6lwdpGbe9Q9i5Gfix57xiiWd3I
         jpZmW0ddHXvuJ0Y2wqSHMNlUw+a/m4ptAr0KsD0xZV5Uj/wNqCn7tE1scPVPFcc8lN
         xf50qmcU0bEQrovHMVLptOnLnTTp7RxrBw8G85X9+1OOJEiC+g7yn/7OIejqHW4bkW
         L/YPivoJI8ts3TwWlBbRMgo45rBD7jaCXacGDw9Bte8iygSM9csPSlFi/rf406WQpj
         4nUZi7cixN3Bg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Oct 2020 12:51:00 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.74 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.74-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.74-rc2-gbf5ca41e70cb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
