Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B30B90ED
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 15:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfITNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 09:47:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2426 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfITNrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 09:47:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d84d8870000>; Fri, 20 Sep 2019 06:47:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Sep 2019 06:47:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Sep 2019 06:47:46 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 13:47:45 +0000
Received: from [10.21.132.148] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Sep
 2019 13:47:42 +0000
Subject: Re: [PATCH 4.9 00/74] 4.9.194-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190919214800.519074117@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <382b0087-2ca2-6a9b-a07a-9d8689c3e9be@nvidia.com>
Date:   Fri, 20 Sep 2019 14:47:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568987271; bh=CUW661VQuVmx7JHM83kSp+/OKq/DOeBg8YhutOoc+e8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZYpaGjaU92sZ3uGv+2c7QGH/uBg5VuiXDSkQnbDv62UVVSm8k8xMtgE6ZeJoyQFoG
         8jmiG4sNxoOtKxQGGS3f852+WImOHh8Tzd7861ey8VsD3IHEm/apQaKW+EQMCcAQ3Y
         Tl2UxfUeutdNGwLc4g2365Jk+lCn5aXXoCgGhTI+6D+WAEmS7NH/yj1mgCPJKUQ9Yf
         el+CA4VlNhHpPn1oNcfVwOSrsQLG704eo6n87BHHd0CHbQW25ojvlVY498c3lPs6OW
         MAsPDuju2sqXXqzY7ORguMKw3oJsLGJlc/HONymn+6DBdPdWf6TMOvvj0FMuksweZR
         F35WTbNj2jfxQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/09/2019 23:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.194 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.194-rc1-gfebb363e252b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
