Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAD229693
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbfEXLFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:05:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11512 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390743AbfEXLFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:05:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce7d0050000>; Fri, 24 May 2019 04:05:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 May 2019 04:05:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 May 2019 04:05:46 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 May
 2019 11:05:44 +0000
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190523181705.091418060@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <02faed58-61a0-b4ff-a127-533b97207c0f@nvidia.com>
Date:   Fri, 24 May 2019 12:05:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558695941; bh=RIkLUJEjdcMVR4xn8Xmw6tQ1LpPQ82uqzb2gy615118=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=B59FONo+j+yW98QvPOydj/D3pOZKyVgBfDCbhnvlDY7OzBI5oOOJpXSi1yd5n5hJf
         h2nhgFvNp3Wv5EIVuSnRQM3++cJa7rcIbI2m2KAL7pbb25++3wmlv4uBn1lr878FV9
         nUQ6tleeGjXsUmuW2Tds2IcDqZ4rf1c2ozjspKOmQFN+lv57Ncm332DK/zYBxGKhyK
         35NrclmgmXbceWAyXpuDDWzrx127z128E9pHM9dKT7WfceSb2zWD0tVujCYWLkkI0v
         hiinTwSE6fIje4rVkeppy3waTXdul2Ek6hR0PynOZwY+m5vxnnnolRprUT/md4lIoR
         TmWYPhTFK8/Ww==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/05/2019 20:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.5 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.5-rc1-gad8ad5ad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
