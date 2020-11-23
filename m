Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA062C171E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 22:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgKWUyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 15:54:19 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15049 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgKWUyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 15:54:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbc217d0000>; Mon, 23 Nov 2020 12:54:21 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 20:54:18 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 23 Nov 2020 20:54:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/158] 5.4.80-rc1 review
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b54d7504633b4ef39e076e9a5421dd7c@HQMAIL109.nvidia.com>
Date:   Mon, 23 Nov 2020 20:54:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606164861; bh=vY/Y11Z8E+lYZrJxe15lZlwWBSU4ZxJEQFqiN2xnpEY=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Y5JM7me6GS1rVNvtQujC80AORINeLXuWF9J3OmTiSvnR3BJTmVszTYG3H+x8Drc+/
         fkBhpfzAprLfaMR71oxAMrBW80Zc2hYUz/V5lLYNe46PC4hXknGPqO744FeWe/9eCY
         Yh5XeYVNSArz7f+QgL6ZAo98lYN632XMyhCjD7gTmSxH94wDvG5f34VuRvwdI93bcW
         rmSGx9LnSBwX5IyRDAsJanHnJa6KBLW6mm4/G7lNwS+OMgJhUqlOTkfwiQU5VZ/rBk
         VpjwIOdHuoH+bphEoUiOc5J99aqabzgvBhGxiLitIqNizPNoqVDSdPrtHfzWThhYBW
         sybrd4ppaxevw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Nov 2020 13:20:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.80 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.80-rc1.gz
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

Linux version:	5.4.80-rc1-g0048695749b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
