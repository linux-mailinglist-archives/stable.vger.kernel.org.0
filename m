Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB432F19C1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbhAKPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:34:00 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17308 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbhAKPeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:34:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc6fc00001>; Mon, 11 Jan 2021 07:33:20 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 15:33:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:33:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/38] 4.4.251-rc1 review
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6db19bac62e54879be8e41b0b228f4c0@HQMAIL105.nvidia.com>
Date:   Mon, 11 Jan 2021 15:33:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610379200; bh=eSQugAKhUr2Pgf06ymq8pFq7UVvJeDMnwn5VhgOxkhg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=XITwRJcdgYtm92RvYdQac/Ro2Yy84/aij5VVqGnQZ/9EMIdq46GvVCF0VJfktjnlq
         +F15ozWt1OvmsMpo3rZ8hwG90Zt7OuFaW/G3MtAsZ/L6YaE8VJ4brisM34GeqHyXNM
         Gm8zkh1P8w7keFNgT4ogSMKgIXHbmDg0L0x1rsu9bdvt3mshQ51xwo5V73q5DwpVjo
         xpP+Xzn0PkIl+Q8yZtt2sIEv+e69BT3kbq0nyiatTAEIE8HqzOdMxI777ver1N2lVZ
         DpoBN97GR9XuEDFCT892gYKkzsQBt2Lg2TJrwx538DwJKXqqUNHI06lEydsPMTqYPa
         q9kFvYbXf7ASA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:00:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.251 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.251-rc1-gb73dabb6d370
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
