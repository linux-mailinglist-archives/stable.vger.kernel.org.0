Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B131E3C05
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387733AbgE0IdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:33:02 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18488 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgE0IdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:33:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ece25640005>; Wed, 27 May 2020 01:31:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 27 May 2020 01:33:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 27 May 2020 01:33:02 -0700
Received: from [10.26.74.131] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 May
 2020 08:32:59 +0000
Subject: Re: [PATCH 4.14 00/59] 4.14.182-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200526183907.123822792@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <2e0ff9f0-8556-7de5-2ac6-6e881db7cb4a@nvidia.com>
Date:   Wed, 27 May 2020 09:32:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590568293; bh=pdvRI4pvMFAVNn0FPCUCoVivuqnjyinC9bEU7o93iaA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=X7r27ni7NIOml7m+h7yOh3U39mimdHD5dfH4z3r1dYq5lrzZ1zXyVxv78xDiFaKhU
         RGBJOZUNe8C7jDKwb3Mzw+mHpBZZJXvfOjfgwz3P2ZvN+8hFmFUQDJghT/T5u5hpIx
         SGJPOQfIkjYXzyV8JAO1JGu76gNexWK+t2+JlJSkwZgeRhJu9u30DlLqfcWstgQkB6
         HlGxv6MTe4Ew5RUJ0qYYD8GvNIi80VZnm9ZF2wO6CHs6HwDXUOpspsyTPczXCglcQB
         q6J6vG6SqbCAhrbQRdjUKwbfhSruck2OH8XkU/xsWSvJXOBBAPlm36w3/8fmTqZQ5o
         DkHSx1dImAmBg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/05/2020 19:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.182 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.182-rc1.gz
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

Linux version:	4.14.182-rc1-g2c9e54b6ad6a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
