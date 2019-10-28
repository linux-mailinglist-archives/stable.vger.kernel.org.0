Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733D9E7B7A
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfJ1Vjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 17:39:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13767 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfJ1Vjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 17:39:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db760270000>; Mon, 28 Oct 2019 14:39:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 28 Oct 2019 14:39:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 28 Oct 2019 14:39:45 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:39:45 +0000
Received: from [10.26.11.236] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:39:43 +0000
Subject: Re: [PATCH 4.14 000/119] 4.14.151-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191027203259.948006506@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b72b3182-05ae-05ca-097d-9455004dd0a0@nvidia.com>
Date:   Mon, 28 Oct 2019 21:39:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572298791; bh=fhMyqk6THznxJRTcXV2DAlL0WYnOqXH/64mpv/8CGq8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=DGMb6z2ry/ChBM6ViscMkcfl7VK+4tmWYivW/H+khieSSTptw0AGRUkz8u705FNIP
         UkxeiusanFREx9yBui4pmlm8TZceAuj1//yLBNvyY8UboqvRAK0D5Gr+EVrGrgB8VL
         TCa+YuvDLOr0NfU6SUjrlbsItgmhMy/tilA9sT5tJIMS90OQvc7xjbHNQmq3p/1nq/
         QOwZcnZ/JjVougdqRTYXTbRXASzseX7senxje068ejbd+Cgkr5qPKJDS1GAgkWZMrh
         tELT9E8IFj4CTnzuDAT+zxMAKbvYHvgD5v0sluV56S/CF5gWuM0vaGpSS4VOzbBSCt
         vQyEOn2KydsNw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/10/2019 20:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.151 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.151-rc1.gz
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

Linux version:	4.14.151-rc1-g22148a87efce
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
