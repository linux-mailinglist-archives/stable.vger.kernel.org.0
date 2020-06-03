Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8761ECAC5
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgFCHo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:44:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17116 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgFCHo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 03:44:57 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed754980003>; Wed, 03 Jun 2020 00:43:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 03 Jun 2020 00:44:57 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 03 Jun 2020 00:44:57 -0700
Received: from [10.26.72.154] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Jun
 2020 07:44:55 +0000
Subject: Re: [PATCH 5.6 000/174] 5.6.16-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20200602101934.141130356@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4c120c44-1ddc-da80-0700-ed22ca165f62@nvidia.com>
Date:   Wed, 3 Jun 2020 08:44:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602101934.141130356@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591170200; bh=Q/ovEomueayU2Nz4J2JbM8RtkKbGWe8+Hh2m9x/cpNY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bZwPXZPZWHauYmrBU0Db+vqyywS+aUovcMClunXypZHSh+xdq+i4MgPEQZth5SHrd
         sYvOZfoZqq8OCd8/0u9obD5vDcwke1XC4lADtpZDqcW2sb9vHeSJJvpOlm2EIffIXG
         HxVYNf4/urIX6BXxQWeP+qoGTbJo8kn5kADgjKbnQtG7LNLPOMP7gXFatqhSIi/zfH
         AxMUg+dE2BbT1FuIu+j6JJ8k/58YfgDRS4Ui4jW23o0xG5h+hkOacZSdRJdqndJl5Z
         /PYKGjpUtY2n+vCcBWr0v6G87p/IyzGe+NeUuaZZGR+79XiRI6qoYZWs+R33YY4nQT
         NT5FBs9REEYCw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/06/2020 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.16 release.
> There are 174 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.6:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    42 tests:	42 pass, 0 fail

Linux version:	5.6.16-rc2-g7bff8a0b4fd4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Sorry for the delay, I was having all changes of problems with our
testers, email, yesterday!

Cheers
Jon
-- 
nvpublic
