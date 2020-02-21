Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38930167A1F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgBUKEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 05:04:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16187 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgBUKEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 05:04:24 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4fab1a0000>; Fri, 21 Feb 2020 02:04:10 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 21 Feb 2020 02:04:23 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 21 Feb 2020 02:04:23 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Feb
 2020 10:04:21 +0000
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200221072349.335551332@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
Date:   Fri, 21 Feb 2020 10:04:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582279450; bh=IKj9oBht6F74wt8Tijrc8dxdv5/sxm8v6sVGPOHfoFA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cSZHOrHtHeVXoa5oqZ6OZ6wSuSqy1mF7avVnBbAH8N1LatXEVVK5w2zi5v8gim53n
         VAPpop6cB1EXClmG00uGOyFLZUqT7fGIl7TunNa3exWUPYXIISMGPcf1jCLvI0zmXj
         jcExcSL2CMk7ZnFtb0iA3Qu/yp6tGFTDSheaGIv9CcB/+z0y/uSAc6Mw/0MURQwl5Z
         U22bQn3JIKaAb3/zJ/9vAw35Dd4RgY+Ik4oXh9xLSav3+2c9KzANkesEuDRMbPBLGg
         Mewf11qDQN9WbecfP2yWGe9dVFfR7B21B02S3AS2py0sf19Y5i3bMCSr0Nsrn1zELy
         A+VEpmTfXV+EA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 21/02/2020 07:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Tero Kristo <t-kristo@ti.com>
>     ARM: OMAP2+: pdata-quirks: add PRM data for reset support


The above commit is generating the following build error on ARM systems ...

dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error: linux/platform_data/ti-prm.h: No such file or directory
 #include <linux/platform_data/ti-prm.h>
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cheers
Jon

-- 
nvpublic
