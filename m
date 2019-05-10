Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D2919B50
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 12:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfEJKQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 06:16:11 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1130 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfEJKQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 06:16:10 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cd54f710000>; Fri, 10 May 2019 03:16:17 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 10 May 2019 03:16:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 10 May 2019 03:16:09 -0700
Received: from [10.26.11.182] (172.20.13.39) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 10 May
 2019 10:16:05 +0000
Subject: Re: [PATCH 4.9 00/28] 4.9.175-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190509181247.647767531@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <878d3a58-2d4d-ccd8-3446-e1ac3e94880e@nvidia.com>
Date:   Fri, 10 May 2019 11:16:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1557483377; bh=Lp9wSm9yPH2cc54i/KjT52SzZ/jFVRpvHRMgT0HFcPE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=CbDZxMyBhAzy8lzVn6lupsX7Egc4sCqcnwl+1I07Vaim8m7u/GiTj9rtZp1YSijQb
         +ceDm0fEiLcB9vV8DpYEKIf3tJkSlEe2bXPIsoypn24XVmyKwnnOT6Gsl+zTlVwvE4
         R+U2NlEdTqskuQIi0LQQA5TTb7g2CjrUsFflc6CH1wVGTFQ5Eh1qUT9Y/J+CMco8k1
         D4gXCDbnBeOOlbDnaQVTpew1vhh2Z/0H+hDDll37c4Ny+2vZe9go5ZA26UQ+mU1mbo
         hWV5dgB1VfKEWw1kxPStqi51lHdaGpeBxr7iXocN2wbDmwYWE2r3jxPVyMLgWxdmyd
         3DxT/eF6iQksA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/05/2019 19:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.175 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:12 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.175-rc1-g50bbfeb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
