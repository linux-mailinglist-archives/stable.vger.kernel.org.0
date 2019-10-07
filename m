Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6283CDECB
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfJGKJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:09:10 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18164 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJGKJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 06:09:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d9b0ece0000>; Mon, 07 Oct 2019 03:09:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 07 Oct 2019 03:09:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 07 Oct 2019 03:09:09 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct
 2019 10:09:09 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct 2019
 10:09:06 +0000
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191006171212.850660298@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b71f3543-ba23-9e23-40aa-f958c0012182@nvidia.com>
Date:   Mon, 7 Oct 2019 11:09:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570442958; bh=VozzKtlqX2N3epaOgA57RUukBHtTSD9rzkZ9uNledCA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=oS5k35WbVU9mIEJkumYodEqydmRZzImrlKUKxAjTLZZRzJCTptTiwITI5lrg+Yb6V
         c3s69l/OkNfEkvS8rVdGqokeZGF1L5HftCJ58bHPGOesAtHTypJC7DDIYEx4Uy7/0q
         8V37p+Sy5JMXNjec56ysUqiIRQp66FcBNw7HkedxH50O1gEVbyhOj+7IEujx5bJ9sN
         XaY9ll3W+UVCwQgO8a/Kg3MmJcRXXs1EYFgq0agSawRHy9svaBDxA4or3QOVb1gdQ2
         /1NGU8pmuUtWo8CiRHwebfyQt+VDgU7Q8pddC6QJq2v8jCDZ10crv2bsFYam0rX89H
         VgRWXr86LbdTw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/10/2019 18:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.5 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.3:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.5-rc1-ga2703e78c28a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
