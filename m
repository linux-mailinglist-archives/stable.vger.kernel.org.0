Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32ABB680E
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 18:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfIRQ2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 12:28:09 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16291 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfIRQ2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 12:28:09 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d825b1d0000>; Wed, 18 Sep 2019 09:28:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 18 Sep 2019 09:28:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 18 Sep 2019 09:28:08 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Sep
 2019 16:28:08 +0000
Received: from [10.21.132.148] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Sep
 2019 16:28:05 +0000
Subject: Re: [PATCH 4.14 00/45] 4.14.145-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190918061222.854132812@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <73963cb8-9f9e-bbfe-66f0-ff953b97d517@nvidia.com>
Date:   Wed, 18 Sep 2019 17:28:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568824093; bh=8TYh9nFHKq8w4ULF85TZCT7/37fysZj1zIi1rtwGJM8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=byX9LQXhX8bCxNNsooYc2mdY+FuAC3UUcqp+vHWG4jo60EWxjXP/NM3410IEgc9LF
         r+R2//8pj1zyFK7dC0dQ79w/jIt0c4DNej/gM0DlKTzGU/YoXIbjaxf/mzfrDVXOq0
         Tiys3A4mRZRt29Kx/Xl9FInf6zLUavduYvH2fXgkdFwdnYdyggn9x3XdUBJvGp2K5y
         u9ZyI5fAlWjdx8Mvl7HVMBd0eLLzjoq82yiNJwnHzhxmTgIM30x8Be0eQhP+jhsoeg
         A+dbacIm4ME6FlZQ+OUL0fLxmlAjNWVGy5+qnMmeTyzoebpQbDqjSKccTmM3gDbhvB
         gry8dhyM8pbjQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/09/2019 07:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.145 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.145-rc1.gz
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

Linux version:	4.14.145-rc1-g187d767985cf
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
