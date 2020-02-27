Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16217281C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 19:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgB0SvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 13:51:14 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6526 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729554AbgB0SvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 13:51:14 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e580f930003>; Thu, 27 Feb 2020 10:50:59 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Feb 2020 10:51:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Feb 2020 10:51:13 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 18:51:11 +0000
Subject: Re: [PATCH 4.9 000/165] 4.9.215-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200227132230.840899170@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ca4bee67-e45d-cb5c-deb1-15dba8e4a047@nvidia.com>
Date:   Thu, 27 Feb 2020 18:51:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582829459; bh=GGBdqeJPkRKmiqv9H2ljdvkcN3ceXix5MgOc3Fbk3lU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qYhocK4rW95HofW35cIU1he93j0yYyjkaZo7xeMVo2PvcMk+08uPl10BTtmfaL/dx
         H04GxBXEWSYX/NUEojxoUFYvVQHZtgyz6iYlEVT+sU19u3W6y1bAIAIo2YdxW7ADXM
         KDGfE+u5wGT1cFY+nZlhBFVwO8YtUOfM09OpX4v4pZD5L3mlzKFDUV1IuPD+vHvWYP
         zaDmTwyfs3S4zs0T/9+rIdQzzR+qux85qNuXcZ1gGo6uyPofU7KqedX70txqmSwomj
         sRil77Ox//popQ9M4OlC//KGUk4HfoiGqiVdFuhYiw2gs4aFD3uPiOXYNklLanUb/Y
         EYrSS94Pr0OpA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/02/2020 13:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.215 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.215-rc1.gz
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

Linux version:	4.9.215-rc1-gb8e4943d6bee
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
