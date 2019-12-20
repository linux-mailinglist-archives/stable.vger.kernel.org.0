Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950AC127952
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 11:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfLTK3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 05:29:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17527 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTK3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 05:29:46 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfca28f0002>; Fri, 20 Dec 2019 02:29:35 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Dec 2019 02:29:45 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Dec 2019 02:29:45 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Dec
 2019 10:29:43 +0000
Subject: Re: [PATCH 4.14 00/36] 4.14.160-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191219182848.708141124@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ef5d51be-98a1-891e-546c-4503471cb8c3@nvidia.com>
Date:   Fri, 20 Dec 2019 10:29:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576837775; bh=SGdb1PAGGGEXnP8U21lkuoRioNkanEkj7oJuJdR6cCo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cMGc60tYrh70AkmcyeXuveTPpX+4zhRcjU2g9XuifP3LyxRfr8D/D0cnSOyGGCslO
         BFxR9GrSI9KvK7pnhNShXNSR3I+LYSkz4+4ainSOWuY0tLU5IuU9apZgzbZOAUSgmp
         qQmNz5M4c2Mnw13Ko7TeDq2lXh4lLzo1zF+JaM+lH03KbzLHzo3JARpYqo1RNFdw8R
         mfiOtdU3eiuts7+eabyIJlO1yAmAGwsz2Ux92vwjNLMZUILuTLggiDN5Ld1OMkJ/AG
         OLZ1G1aNcWWcBtU+XReAhI8OzoJNto0x3cN33FirC9r2/cCJSbuwF4ttAhXl8TayED
         h0udN0/qpk7nA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/12/2019 18:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.160 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.160-rc1-g838b72b47f7e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04


Cheers
Jon

-- 
nvpublic
