Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39457309594
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhA3Nvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:51:43 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4109 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhA3Nvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:51:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6015643d0000>; Sat, 30 Jan 2021 05:50:53 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:50:50 +0000
Subject: Re: [PATCH 4.14 00/50] 4.14.218-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>
References: <20210129105913.476540890@linuxfoundation.org>
 <20210129182147.GB146143@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6e5abee6-8275-2b15-4ae2-f28c6508f55a@nvidia.com>
Date:   Sat, 30 Jan 2021 13:50:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210129182147.GB146143@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014653; bh=BepjA+e4LhxoC8yJfrDt+Jr6930wV09gqXTU7Axms4g=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=FLUA2frRTSVCoGA+v2QFX+vkw9kg+QS47UeCyvmp9jQ7+oXXwGH+jKF0E+weYwjer
         uywyBmLnzxQTSWlk++XyPb+ZN8nE10ECwGYCrkpAYqpRcM+2zGVTrWr0Jewts5Va6b
         gM8Dfklj55KHtLaxLyQVeEvtZ4N8Si2ND2aevmzfLelY5GkXS2bPy5gJkRa5287yBv
         TBDf4IQ+yty983e/OH0UjkY6M37/qEjYdypZh3sqRqH8QqxwnMz9KOx5fegpvoZuqO
         90iKiiJVx/lxgZbUqqEQks+nodf6r9zj8AfRwxFX4xFdj4IP84V+YeWwfjdg6FxjpL
         IMJHFKcLhNa7A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 18:21, Guenter Roeck wrote:
> On Fri, Jan 29, 2021 at 12:06:25PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.14.218 release.
>> There are 50 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.


Replying here because I don't have the original.

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.218-rc1-g672a9e33037f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
