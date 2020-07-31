Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3802345F9
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 14:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbgGaMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 08:42:00 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1836 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733101AbgGaMmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 08:42:00 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f24113a0000>; Fri, 31 Jul 2020 05:40:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 31 Jul 2020 05:42:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 31 Jul 2020 05:42:00 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jul
 2020 12:42:00 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 31 Jul 2020 12:41:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/61] 4.9.232-rc1 review
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <4d541d2438544d0ba6dea1fabee1d977@HQMAIL105.nvidia.com>
Date:   Fri, 31 Jul 2020 12:41:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596199226; bh=Um3Kq03p61eWJI12TwH7wjgE22ySdW3NxwPV7OCB2Ds=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=RxtdMJMVxj6WIcEM3i7whLPnhhnTrXhRyHvcgsS8dHqCVjputmyM36kwCOMaeZQyB
         spAdKoDlzDk+LV6WaoLjt/0HpSLDqYDaU+muIlzScGi3+o6wFZ+kBw5YP8Tt8P5069
         outnvIndhv69QY9aJs928mIvo5Ryj8DVEDg/WzOx/uAajt/SJM43ChijNS5dbx+kjy
         F4zoHSF11ecmI+S2bZ8YK8wVv1P6eNRRDHeEX80MRKo/bM6DqRUNZs8dcQ81RluWEw
         /+sDdnaaFgbuV32JkIMcUQe0t0OigBcby8JzO2bdpqkr0Umf6zhFSXsBtLe2H+jNyS
         wbyrkXOeJ7Ulg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Jul 2020 10:04:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.232 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.232-rc1-g3c1be84608a0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
