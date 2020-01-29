Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748F214CB4B
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgA2NQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:16:41 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14865 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgA2NQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 08:16:41 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3185850002>; Wed, 29 Jan 2020 05:15:49 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 29 Jan 2020 05:16:40 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 29 Jan 2020 05:16:40 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Jan
 2020 13:16:38 +0000
Subject: Re: [PATCH 4.19 00/92] 4.19.100-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200128135809.344954797@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <91c18db4-8fa9-0b2a-db16-e92603e22a24@nvidia.com>
Date:   Wed, 29 Jan 2020 13:16:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580303749; bh=dSZLLWmgWrVycGKJWyQqqW4+C169YCghPO7KV4kdWj8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dYM6t4xnQmRNw9AH+0Eeo2SFCmFmkRtBc16JWUsq4jUoONMzbQKvaK7P0EQuA39cR
         UsxcehgRDxfar58WQToZjvOfVfpbUy34opWZXQO9rRqLDVCsFORLZVlArAd4ZVa+YY
         i7hxD9Uuzur7olHThGYg4cjMPbMnw3jbrE4MZ61I+YrcgLYwOwIUA0pQoT2mDMFrih
         w2iSelX3rRvSJJijAi9OoFdLdiImtYQt8dYh4XcI/22JZR6pmEE66Qvt/Mz/lxND61
         B1DsGttz6XgaVySaib3XxzLYiLUWmXIvj0PvKISgVjMakM/ECunrAFkCaGlsD01AYB
         B67ArTZE9oQZQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/01/2020 14:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.100 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.100-rc1-g26d743063ae6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
