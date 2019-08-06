Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB28388E
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfHFS3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:29:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5114 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHFS3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 14:29:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d49c7010000>; Tue, 06 Aug 2019 11:29:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 06 Aug 2019 11:29:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 06 Aug 2019 11:29:11 -0700
Received: from [10.21.132.143] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Aug
 2019 18:29:08 +0000
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190805124924.788666484@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fbbfbe46-dd25-89d4-84ed-a8b0fb183440@nvidia.com>
Date:   Tue, 6 Aug 2019 19:29:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565116161; bh=h1oCR2Ln9FAsaXzmyBycn9dJd1UILo16a6zTZV8WWdI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=NLU6a+kEaVFOgQpLx2Rf0FfT8Zh5W8BQkpJ0WM4zDDaKdfeZflnRWXs/GIo4oJCRu
         c9JzDicnFBf+Nl6WxlMAwG0FsFIL4c8qlkuszyr0+FKZkxU29EHZZMeUTejjq9xli0
         k7NdN9pYB0YNeDBR050kWFA32r5MkLyY+pL8Eh9Ecjk6OdBwTZjxpOTLfA80inPR8y
         +zmWHD8+Pld+botTVrdIv2Mwl2s+TKkGexg3S4u5x9DMovNvrO91ucthlWj1vzTRx+
         H+/PGJLunIoASKXY/0hY6dzicacqkwJ6y/e5EqQ5fH2l/djFRRL78aSzuaUwAEMzrd
         zR5GrT6Du3snQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/08/2019 14:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.188 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.188-rc1.gz
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

Linux version:	4.9.188-rc1-g228fba508ff1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
