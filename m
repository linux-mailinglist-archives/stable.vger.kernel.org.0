Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFFD101FBF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 10:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKSJMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 04:12:53 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3810 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfKSJMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 04:12:53 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd3b2110000>; Tue, 19 Nov 2019 01:12:49 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 01:12:52 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 01:12:52 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 09:12:50 +0000
Subject: Re: [PATCH 4.14 000/239] 4.14.155-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20191119051255.850204959@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cc1129c8-797d-7a1d-e59b-16c826270fad@nvidia.com>
Date:   Tue, 19 Nov 2019 09:12:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574154769; bh=s336aHF0+WqEMqrUMHOwLSxFHgeFvtDdFyFoqd/Q6ME=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jTtaFx64yGUlpyQpLppU3nyXz+ABWUiOTIy4IPrEGGnMvStAQBGGVZk+aR9UFPR+D
         VHPu4XlFzAp1NogyoguJPIw6DObWpSWCScI2IvBlwnPvdHpCOXphnYXHZ61990s7az
         r7UtkR8XklXyrmdyityeV7YzLhohtY5lFdAemTMDfGO3FCSmsld+RPTFjGeV3ixYLs
         VYUfZ8UCR7lpZsAYKfvr5YioAHJclQl4WfNXw1aV/L2NzZG0+ybkb8gQl7VEhS4BHX
         VLnqUzp41a+Y4Yk6w7FfqPg0JXG8gp8O5nzCblwu9UWPlbNJtfziRViumuSVeTmN0o
         3kl7lbpb2It/A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/11/2019 05:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.155 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.155-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

...

> Heiko Stuebner <heiko@sntech.de>
>     arm64: dts: rockchip: enable display nodes on rk3328-rock64
The above commit is causing the following build error for ARM64 ...

Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:149.1-6 Label or path hdmi not found
Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:153.1-9 Label or path hdmiphy not found
Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:345.1-5 Label or path vop not found
FATAL ERROR: Syntax error parsing input tree
scripts/Makefile.lib:317: recipe for target 'arch/arm64/boot/dts/rockchip/rk3328-rock64.dtb' failed
make[2]: *** [arch/arm64/boot/dts/rockchip/rk3328-rock64.dtb] Error 1
scripts/Makefile.build:585: recipe for target 'arch/arm64/boot/dts/rockchip' failed
make[1]: *** [arch/arm64/boot/dts/rockchip] Error 2
arch/arm64/Makefile:138: recipe for target 'dtbs' failed
make: *** [dtbs] Error 2

Cheers
Jon

-- 
nvpublic
