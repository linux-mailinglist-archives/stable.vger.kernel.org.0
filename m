Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD722139527
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 16:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgAMPsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 10:48:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9907 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 10:48:38 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1c911f0000>; Mon, 13 Jan 2020 07:47:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 13 Jan 2020 07:48:37 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 13 Jan 2020 07:48:37 -0800
Received: from [10.26.11.97] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jan
 2020 15:48:34 +0000
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200111094845.328046411@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <70cdac43-95fa-b44a-1835-2460e82a9607@nvidia.com>
Date:   Mon, 13 Jan 2020 15:48:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578930463; bh=ow4uBVVgKMkOmgJnvTuw5BaiZPrgV8aiosDRukjGXdQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=TKhlrsUYVS73ONImMYau1Da0SfRvdnQqdYBG2uADQDE2kLYrI0pHT3HOBhchCR0Nd
         BZkrHmLkoUEeC/YIduHxWARLVGJhP76AJP5rBYlxdriMwKOeMO+aURZEGaiwpoGr21
         IFvvcOwWZEH8htD96wqAWfV1caXRw9TJJF/6rk4nJmbibWlsRRPpDm9UldufX32k0l
         MvLEvKez9ROhOntqxeB9UhLe9fBjsTQrWVE2fGW3+OA02CQUgpaomrrqqWMqF2R06a
         cJRinEA6sNuwi+a+evyvb6ar7Kc5x7XnK4b8mqdx2mE89+kXLEU+hVqzaRfIQy82P/
         XYY4DNAXYEDZQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/01/2020 09:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.95 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.95-gdcd888983542
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
