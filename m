Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6D067030
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 15:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfGLNgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 09:36:21 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19933 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfGLNgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 09:36:20 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d288cce0000>; Fri, 12 Jul 2019 06:36:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 12 Jul 2019 06:36:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 12 Jul 2019 06:36:19 -0700
Received: from [10.26.11.231] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 12 Jul
 2019 13:36:17 +0000
Subject: Re: [PATCH 4.19 00/91] 4.19.59-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190712121621.422224300@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0c71dac3-fab5-4761-968b-ed2846aa0fbd@nvidia.com>
Date:   Fri, 12 Jul 2019 14:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562938574; bh=LR7LVePXjDKHk1YaeFa2n0w4nrEixqdKTZ1N5v/iEdw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jzBod7XeJUlP1klulNwFeUY1L3VqiXKkiLkqQG8rQk1iW0oxY0teNkBrylwJFGEm+
         c78aw8k4WdbaMkiq775i0Xz8Wlj+AEYPzREaJAqFVumKExu6L6So4a+JA22NPlI5OU
         ASTn3IyQfVsI4F1s/rDkFyziwwBbLDvZt7kf20rRDnUF3cIGL+DguSodlmvFO+UmHt
         WnOUVlmdwSS24F16J7zQ9p0gecvYa6+gyaKQQCWaV5bDdeLj0CDEKAoa5LgrC3cCl3
         S3Iy29G3JgfbHSrQucd30FoIshUne/WK2WWFrPRjK+qrj6ghgn7TdkA0Ymyb/eTP54
         AFdoMwGi1QMEQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/07/2019 13:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.59 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.59-rc1-gd66f8e7f112f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
