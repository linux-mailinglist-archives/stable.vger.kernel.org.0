Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D328424785C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHQUyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:54:23 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14293 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQUyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 16:54:22 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3aee440002>; Mon, 17 Aug 2020 13:53:24 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 17 Aug 2020 13:54:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 17 Aug 2020 13:54:21 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Aug
 2020 20:54:21 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 17 Aug 2020 20:54:18 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/168] 4.19.140-rc1 review
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <51721a33cb974c4fa64a38f903a733e6@HQMAIL105.nvidia.com>
Date:   Mon, 17 Aug 2020 20:54:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597697604; bh=/DFovDGlNwrb4sIMTmmy80ximO6Ugb3PFVLwbquM8wg=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=G+GWtkcxwbxyyBmRberhTBsDakk1HCioo8DV2Lu2Jxrt2HDjLSa3Z8R0ziNDg+wSj
         pyi/aBPJWAkskwAfK2Mib5vzw8ATfMb9VqnRPrRTtktwg6qSH2l4IXWdFK+If3ntvt
         zuG6XFkeFdJDvH8ZsGQp1Shc88FhOGMx0+zI/+tqsiTRgvK47NQWOTbxWMhL1TSRgC
         jn8HHQwDw+chyNGG/BUrOH91qfk3IVDiUXls9tsJd3nWovmvVngNgMTCyskwEXWtdt
         UNt4MkwQpNE7HbaIkh09bt9pbBsuU20MHOSdxaUegy7LBY0+4GBDkPrNg6hCxNHU0P
         6nbQmIoCMSN6w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Aug 2020 17:15:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.140 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.140-rc1-g9950f9b4d350
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
