Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C5A2AC02E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgKIPpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:45:39 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15439 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729174AbgKIPpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:45:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa964290001>; Mon, 09 Nov 2020 07:45:45 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 15:45:38 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Nov 2020 15:45:39 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 000/133] 5.9.7-rc1 review
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a8580fdd8bbc4d4d8ca14c087ac32a95@HQMAIL101.nvidia.com>
Date:   Mon, 9 Nov 2020 15:45:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936745; bh=ON2MhIBgRJG55oDw9MY6byZeVwWo+MrI6Zd1DLOSVU0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=X5XUfJwdD3ssQakhWXTfhhLkSghr0awNC9K7wg5tKEcM0TlYA3fk7qzk0MUfweOKI
         XvrU/ztJqLZN5Ysjrccq417nYnJpumOn3pxJlQClwVg9kQ98J6mgU88pn6d9l/8a1e
         AsquJJDFpM9I6+p7DfD6mtGRYZGCmNO5r2dYufs8s7pCqePIZGydYDtmyMs63J+Wqh
         SEtruZcLjMh9vV8uF4EY0ENAjXH3kBW4Goan78h0+cLDoJbarm9xlKidrkF4spkEjW
         oJOAOwfscUwUSL6iA2ndv99JurCR/NMahOyUslso114oOlk9naxUT9XzPa1uhoiViw
         0W9Hl9+oiIBmw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Nov 2020 13:54:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.7 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	61 pass, 0 fail

Linux version:	5.9.7-rc1-g134494539ffc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
