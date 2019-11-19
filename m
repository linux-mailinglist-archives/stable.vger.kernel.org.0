Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57CF101FF0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 10:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfKSJSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 04:18:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17019 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfKSJSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 04:18:08 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd3b3500000>; Tue, 19 Nov 2019 01:18:08 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 01:18:08 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 19 Nov 2019 01:18:08 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 09:18:05 +0000
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20191119051400.261610025@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <20468dbc-5b88-f86e-9d5d-5edca4e4be2b@nvidia.com>
Date:   Tue, 19 Nov 2019 09:18:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574155089; bh=B2oh7CpIxYXzXY4yXTBlbxGyub/RFMoUpcmOgC/aAcM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=r7iAEJzHEqVhYa/vjnQZKd4H6LTibxXonT+iMRlqCr3RE6cRv9Hv/UYLt6xeYMrSC
         8//YfQAIKfDzDxeTPMJS2QkwwzZRJP+IfgZ3xF8ahIQVIvpLZ8FdBh+sgYB2qaItVF
         SknvXKyFymdoL/ngN0vxEi6ZvZAbrIOxy5qcsq6FUWr8vGSDsrR0wS9PdQypgIjk9U
         W88uu3D72yAXIjV0Z42KexqIjVo8YzAChDRY5DJiEQeKLBP9aglzaKVtMI9NkkGVyZ
         yJbkSqj4DjvRGxP7rC3LNORQNOvLiMa0P9aAQ+PJKrEfqfhbl315WRwBG3xcuNeGe3
         pcfvPDfulGrMA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/11/2019 05:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.85 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

...

> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>     ARM: dts: meson8b: odroidc1: enable the SAR ADC

This commit is generating the following compilation error for ARM ...

arch/arm/boot/dts/meson8b-odroidc1.dtb: ERROR (phandle_references): /soc/cbus@c1100000/adc@8680: Reference to non-existent node or label "vcc_1v8"

ERROR: Input tree has errors, aborting (use -f to force output)
scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/meson8b-odroidc1.dtb' failed
make[1]: *** [arch/arm/boot/dts/meson8b-odroidc1.dtb] Error 2
arch/arm/Makefile:348: recipe for target 'dtbs' failed
make: *** [dtbs] Error 2

Cheers
Jon

-- 
nvpublic
