Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135191C1935
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgEAPQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 11:16:28 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4404 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgEAPQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 11:16:27 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eac3d3f0000>; Fri, 01 May 2020 08:16:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 01 May 2020 08:16:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 01 May 2020 08:16:27 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May
 2020 15:16:27 +0000
Received: from [10.26.73.180] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May 2020
 15:16:24 +0000
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200501131544.291247695@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <17a11450-3b7b-6965-b2e1-3ae3e52ce231@nvidia.com>
Date:   Fri, 1 May 2020 16:16:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588346175; bh=rSmOEFsDmGyc4fCfFs01i+VrNdSdYl2KKyHRbs/o9a8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hWmKoPys61fvhjOT53Vc8Hj57t0CbYuNVIpYH/UX+t1K7Iy9epJHrrXf/2/FhH9eI
         fz5DAx3ZZLwa/yRYWStkqK7nvixd1Yn2OBbeVCLEgRy1HL+IJ46JvqeL0Cmiy8j0gL
         KxpOS6VT/1beguBaBjcY36zGHJN4QEVbrQRKQFpsbFrJuRSjkbMnS2UxW1V/ncgfTF
         sA091hRvNiX/2V81VHcJfKv1njZX+5G1GGCgdJJVjY0N681C0+TIr3FOTtQjAtbP8m
         iwWY0OyogsP0NMpW9lW1ojXrvAddPGYnFbIJx/UxT5X4nKdS+NWfH7Mf4T5BflgeO8
         TewjibGFi5NLQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/05/2020 14:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.178-rc1-gb24d32661fe1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
