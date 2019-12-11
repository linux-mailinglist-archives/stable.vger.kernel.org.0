Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDA11BF54
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLKVgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:36:13 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2061 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfLKVgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:36:12 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df161360000>; Wed, 11 Dec 2019 13:35:50 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Dec 2019 13:36:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Dec 2019 13:36:12 -0800
Received: from [10.26.11.206] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 21:36:09 +0000
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150339.185439726@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7b43a504-160f-e793-99b2-bcb79d331b6a@nvidia.com>
Date:   Wed, 11 Dec 2019 21:36:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576100150; bh=/3FQWkYa0+XD1qH/A1nkOCyAs7XrzEM0EwtOn847qTQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZxFZj/4lkaoLhsrAJHAtmxQG46riPqebeK63yT2Olp5VQkyG+s3XC1dJEFYDxdoKR
         09uuGGyno4aefJnOkgT8iK76qk3w7bUkGsw7+zzKfn+9Qk8G4xsVT/gg2M6/GQk581
         GSh6sSKth8rEMXAZGcEWbqUr/dkgaRAI2vo/EdZrCZ609N1eCATIZ6xORTbUV8F1bl
         uUSivIPoBfjh1Ok301xyyYHnwEuXr1YDCAnJIjGEEpXfMenYq2wsgmZJhBtY+GdS3Z
         ZWVuTtYJEZ6ssEPm+6bKjQBKHdcz56dXLd0qOfdKt1g5UCO7N9hbkV/SZMx32aTGxn
         Pk5wsBPIsYjtw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/12/2019 15:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.89 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Linus Walleij <linus.walleij@linaro.org>
>     gpio: OF: Parse MMC-specific CD and WP properties

The above change is causing intermittent failures on Tegra30 eMMC.
Reverting this change on top of the 4.19.89-rc1 fixes the problem.

Cheers
Jon

-- 
nvpublic
