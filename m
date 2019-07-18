Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397F26CBB7
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbfGRJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:20:14 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10336 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfGRJUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 05:20:13 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3039cd0000>; Thu, 18 Jul 2019 02:20:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 18 Jul 2019 02:20:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 18 Jul 2019 02:20:12 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 18 Jul
 2019 09:20:10 +0000
Subject: Re: [PATCH 4.9 00/54] 4.9.186-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190718030048.392549994@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3cab490d-bcd3-cff1-4404-ae419543880d@nvidia.com>
Date:   Thu, 18 Jul 2019 10:20:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563441613; bh=N2HOOC0z4qPAL3OarwDzU7tpXS7OX5GP4nKIXs7cO8E=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hqdaMLubvZcxgqws6RKD6DezaF9Zd72W15rYv1kpn933/aeldzCruHCSOFeLyQm2y
         gnoPy/avEnVxhkRLUWisHWurjN3xAt4QWEkoxJXwbfjAbktsuDnYRGJd03FrT1qEl8
         RjTiJ0eWFssVV0CFQk9EsVjCkfqZsdNSZmBSnSpi264/lTLmMU6U+PvjYd5oGz72eT
         2lzY1LlQ+wW2+QVn6M4SJ6Bo4BDqfCI8Cm5P2Cjt9EqHtSIdNllShzinc+7cpzNSiK
         RNxZ7yLIS3TdJpxdh1qH6HXOhU1fX4c7Y1WHHrkR4fWBclzAZNEpLhC2nUXLWk+8eQ
         GUeeVXZrF09Mg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/07/2019 04:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.186 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.186-rc1.gz
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

Linux version:	4.9.186-rc1-g0bfad9234a3a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
