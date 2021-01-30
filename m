Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC53630958A
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhA3NvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:51:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4073 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhA3NvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:51:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601564320003>; Sat, 30 Jan 2021 05:50:42 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:50:39 +0000
Subject: Re: [PATCH 4.4 00/24] 4.4.254-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>
References: <20210129105909.630107942@linuxfoundation.org>
 <20210129182120.GA146143@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a39d3c1f-c0b2-63b3-c131-8014a8584859@nvidia.com>
Date:   Sat, 30 Jan 2021 13:50:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210129182120.GA146143@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014642; bh=Ki6UXiW+88P8gozEBsdElVxoy7kOkvVn69JJ50Wa/Uo=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=lEF+CPnh2gcYhUrxg+l2STwEdcCis7VaCzE80yZr0GP53rYrEFn/qe4PTd4/eAdKU
         tE9g62mblWSIR7HLH0STtwzxyrTBhYdNHgiDfAYw0IzeZUunWr7L6zmHk3K43n6Gai
         uMTnSzU+nOdC7/4nLWkLrPx33FmFq+0jb6LNT1gYhX/wwfuEccBxfYAZhTN5tgu7p8
         WiPpaytfkUiy9GttwHPBiu6HsiJn1EjQgXNfuEZSp1sAs9duAlDCq3nz4m9SOwy96T
         XYbnkoMjccEvyjxLjWAu3EY+WSBKILd4uBUMPVWhWwpQnURlGtCuyHuKYBZlxnNH3b
         YEzDPLQ/ra7kA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 18:21, Guenter Roeck wrote:
> On Fri, Jan 29, 2021 at 12:06:35PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.4.254 release.
>> There are 24 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.


Replying here because I don't have the original.

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.254-rc1-ga1b3543d6297
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic
