Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA62BB10A
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgKTQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:56:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4074 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbgKTQ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:56:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5370000>; Fri, 20 Nov 2020 08:56:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:56:34 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:56:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/17] 5.4.79-rc1 review
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8a173959982344ccad576a6d8d316234@HQMAIL101.nvidia.com>
Date:   Fri, 20 Nov 2020 16:56:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891384; bh=rD9XeyNOMkZe0lzyTHmtdqzAt6YC70OoMkD1gAubCT8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=RShKVPwaEguhRZFd3OB2K5/eJPmAegfTTb1futKmd5NPgvZn0STRzvgzWYiG+G0X8
         cZatx1+stbYExRePDCOGS5pNAPFQjR9WgxisYnpC/ZRJAAFPkdGze8Saqu4hREffJs
         g1tMwUIPyseADreSb3bWPT+d6PpZKJnG2uXyJglhdHpfP37YtE/AdMfFBy+bAJzge6
         0h+1Wx/h0ffNL5RGmnlMMAfnyyEYx+4NNX1AcnRsOKbYQ4qSd7wF0XTZheS44ep96u
         4KRmca4rJVeI2DRH1FdfF+cZuQDpvznoEIV36p6IA1aDmq5ox9Etza6D1SOihDsvgb
         goAafPdGrcrzw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:03:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.79 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.79-rc1.gz
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

Linux version:	5.4.79-rc1-gea92920d046b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
