Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B45309596
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhA3Nvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:51:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4020 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhA3Nvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:51:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601564420000>; Sat, 30 Jan 2021 05:50:58 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:50:55 +0000
Subject: Re: [PATCH 5.4 00/18] 5.4.94-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>
References: <20210129105910.132680016@linuxfoundation.org>
 <20210129182253.GE146143@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b3040cf9-8103-f742-673c-1195d4818e4e@nvidia.com>
Date:   Sat, 30 Jan 2021 13:50:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210129182253.GE146143@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014658; bh=2UlI36pkWSVbpqhRp8WJVpsNsGtGv+jRfgFN79fyub8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=jJMaz8ZjSLBrZbMgEaqqSStAYtJrhAxwxh/GEuS5dHRCHlNCDcOCoB/caJ2qVaj6A
         CaEbKVifGcFVYO0ZDjavhEgfFC4+dQrshdIQ3ld99TEYNeRdh+AsJuG3OCKF1HJvou
         LgEUmV803YLQgNnrgJjklbnI04eIAC00Z8Y6JDmDqO/62Qt3nWPYSJoreAnFHyGtaK
         lWBt+ukPRq+WZX4Xt1oWo+rTNKfmrZv7wfpD0UB96tey0Re99M+7PVTuTNf0xMAcpq
         NoeTwfZEYPiYYMpT1GLd0kiQq8uEAZ26voHP7SrQRVLHKeQqbgkq2HR+if/6XTXq0R
         uFiSZxCgnNNWw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 18:22, Guenter Roeck wrote:
> On Fri, Jan 29, 2021 at 12:07:14PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.94 release.
>> There are 18 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.

Replying here because I don't have the original.

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	57 pass, 0 fail

Linux version:	5.4.94-rc1-g5a6e0182cbe9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
