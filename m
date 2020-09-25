Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48968279003
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 20:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgIYSBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 14:01:47 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5358 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYSBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 14:01:47 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6e30290000>; Fri, 25 Sep 2020 11:00:09 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 25 Sep
 2020 18:01:46 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 25 Sep 2020 18:01:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/43] 5.4.68-rc1 review
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e16bd187f7974eaeb814112f0ec03371@HQMAIL101.nvidia.com>
Date:   Fri, 25 Sep 2020 18:01:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601056809; bh=GiSNxeE1KfHkES2lvNIAbrUvLq0NVzTBDHFiis5uuBw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=bJMEp5iKtDHVezfdFDr8COGSWdksLf7cx0f6tmdUphM81FoTp5Xq5dWJugYoTZ9aI
         cKUQQqdFWx0r2HQ9Ftmc/S5CcBc8f1spi3zGD+JzjlYvEc0XMx8zco0j082rPK+szO
         AMXGIXiClKuCAkQqw68tYXaurl+kBR0DpZ9K2mPN5jp6+Ds7k3JXTwiuGWehJAYACp
         nFgPJrj4Iceij+ZKxwAzVdEC9h7qLNlas9syIEzFE8/J2HeuQXQuzyoz0TtcnO8keM
         n5Taf1klawbFDZlwbNXHZMJvHZZx+6WMh7AYjBJVsev3DDU7oZkp0mJ6HNrS/DuuV9
         ejLrJO0wApeiQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 14:48:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.68 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.68-rc1-ga6d2801f4120
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
