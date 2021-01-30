Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E5309595
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhA3Nvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:51:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6741 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhA3Nvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:51:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6015643f0001>; Sat, 30 Jan 2021 05:50:55 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:50:53 +0000
Subject: Re: [PATCH 4.19 00/26] 4.19.172-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>
References: <20210129105910.685105711@linuxfoundation.org>
 <20210129182232.GD146143@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c94f646d-93b5-4f48-4295-0e7ec4782a64@nvidia.com>
Date:   Sat, 30 Jan 2021 13:50:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210129182232.GD146143@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014655; bh=guO4X6EV3b8st5rMhMsJ5XkdKlbjrveTBt2Lu8/DWtc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=WgXdOcSc5P1BGvUyyRInhV/t7LHbVq+vTeXbImcLFf2VELGPpMoaX7DQyDcqbMkji
         H9OhU2smxT3QK1brqUGVYWiA7mNP8mbtaNQanZT+H2lBL5UXpNK/N7aXShtT8YNODj
         11zE0vZyaAinmxUoFxyHO8eL1kcMXQwyKcRYqbYB0Ebp6KLDLDiXyKicR3ffchw7yZ
         604yMILFB1a8nLHEuAtk/G6T3ITPBp4kFCvdh6yFNzYdqgA7SJufCXrARTFTK6YKJ5
         T4SWYkZV4Ed3Dh4aV3djtGhg0nKGVuBdu1HiPYgLrd0AfOLm53GJVWaz0hBJbn2zIw
         u2h1JWSsUrBYA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 18:22, Guenter Roeck wrote:
> On Fri, Jan 29, 2021 at 12:06:57PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.172 release.
>> There are 26 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.

Replying here because I don't have the original.

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.172-rc1-gd36f1541af5a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
