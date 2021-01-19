Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665E82FB926
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395408AbhASOSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8562 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbhASLwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 06:52:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006c7ae0000>; Tue, 19 Jan 2021 03:51:10 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 11:51:10 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 19 Jan 2021 11:51:10 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/75] 5.4.91-rc2 review
In-Reply-To: <20210118152457.528300594@linuxfoundation.org>
References: <20210118152457.528300594@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ce101a783f274d02ac2b66e9437e78bb@HQMAIL111.nvidia.com>
Date:   Tue, 19 Jan 2021 11:51:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611057070; bh=P4iy5g0TABd9zEkYT/jDfvon1QI26sPzLvz1mzcGm4U=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=qwO9MbQi6XdknZMenxvSy7pocdSMyrTWsIWFzAT1J7+Wwwf98RdM+e5jiWjRR3WKc
         vPWHORy2EJwEAl4NpzcGTju2+xnuE4VZOzwkhnBu+vgt098rd58ma96uu5+aeomfOh
         a2eLLpObJaWvJYkSzvSndzulO4CEonZxCekTudh+t7j3vN8qy0GsbXYM8uEYA/htAg
         /SOW+pGxLCuuneBmGI1/4ceDl+w1PaOrdHxOFPz0/tP5Wvgl3gqxZyy1JXU/Y65UyZ
         O8nn4wcDjFG5WHHO6fmP7pf5HcDvOKMThxhINnjjtbYvmtFCcIzG6fppg4fOv3EkBw
         ffqMZr6iMvZ1Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021 16:25:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.91 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Jan 2021 15:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.91-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.91-rc2-gf07bbbcbb287
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
