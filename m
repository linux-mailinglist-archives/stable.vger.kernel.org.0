Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D5B370E
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfIPJZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 05:25:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9790 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPJZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 05:25:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d7f54fc0002>; Mon, 16 Sep 2019 02:25:16 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 16 Sep 2019 02:25:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 16 Sep 2019 02:25:12 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 09:25:11 +0000
Received: from [10.21.132.148] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 09:25:09 +0000
Subject: Re: [PATCH 4.19 000/190] 4.19.73-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20190913130559.669563815@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <19825f80-ce83-48e6-95f5-2a3c0c77797e@nvidia.com>
Date:   Mon, 16 Sep 2019 10:25:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568625916; bh=xMBpE0hYz7QADX4ChDD443vDHDFuypdYoXpswQBZLho=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hPklx83UfYsy8tn8lsPh55rqyN5/uTsMBmNVcYjzDiqciG4KaLWicrqqk8V8nsh30
         Ngf+4G2CjpSEN7sC7BVvXMJWKdRaCr2uN0+lgMYirEIG4R9xZI5iAwzpQhFKoSmXl1
         GV53gwF+1pgsbTKK8q6HDH059loX67qUE1Mg0hGXz+UCF3T7K0opXkVZwarEPJZOBl
         ZcQjqf+S7C6uE1jl7TNgk7kOHe3mcyzhuWJlayppwUXZrxOILoAP5pbQMYZWYC865/
         RHTL2MPy4IBybqe/jIuW2yswReizIdxMcZdGRm6in5YdLbcjs5p2JVz7Z5YwdOATVO
         7KM0HmLXOnXqw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/09/2019 14:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.73 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.73-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.73-rc2-g2dcefb93b77d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
