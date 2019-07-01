Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AEE29689
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390781AbfEXLE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:04:59 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11475 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390778AbfEXLE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:04:59 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce7cfd50001>; Fri, 24 May 2019 04:04:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 May 2019 04:04:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 May 2019 04:04:58 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 May
 2019 11:04:56 +0000
Subject: Re: [PATCH 4.19 000/114] 4.19.46-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190523181731.372074275@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <57de68bc-1fd8-c19e-3963-fbdd1e172c49@nvidia.com>
Date:   Fri, 24 May 2019 12:04:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558695893; bh=JbKy35AlJQzDfPny1Y7bs3wn3nWbGdAb+8LSVPAMOQA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=H/y/0NNJr5N0L3/mea9kFy0OH3kKGDWNF9hGLJj+h92RXyWeAqhudiQ9t51xbBUjT
         90T3miM1OrdO3F88JC+QTZfH/lhTbl7SjjCcUrXhnD7rkknFAC+JcMq0NWhpuSyVDb
         UHjBCC8wM1nZrt/t0MyKmTFXIu3CHpTJj5bI9LFA36MKrIVnuLsHGdAcJmDc53CgXv
         FMTElgryuRAh0zrd+3O/fl0rPEJXER+q1KdT+vFT8RhHbmdJ9CGICuxIUoPsMQHnpd
         VC85t65PJtCV5x6ABfDW58WGZRmYBdgRg41EyFG7Kij/QnBfEn3NFKlTNqH34xe3pH
         aHyLUV8dUOPfQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/05/2019 20:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.46 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 25 May 2019 06:15:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.46-rc1-g071ff9c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
