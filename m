Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37312A2782
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgKBJx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:53:56 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10195 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgKBJx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 04:53:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9fd73e0004>; Mon, 02 Nov 2020 01:54:06 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 09:53:55 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 2 Nov 2020 09:53:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <76af79c684a14319b6bde0db2a358e19@HQMAIL111.nvidia.com>
Date:   Mon, 2 Nov 2020 09:53:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604310846; bh=0qMCJ8cbg/LLKzKBJPBY+58R/exwsx0pCvwMU8sYUno=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=boxEnhMoUfCo1c4iJfLPuVmKUb0J6K1FaZBCrCJjSE/D7uWPJJkHVyncPgDl+VNbd
         xJyIs7LHFniJa5O6D1QYq0BqyHSnE8+QzIHM3mJQfm32IF8hUuLVrSnMYlQ3d/Eiiy
         c865TrHNQXh4QQABAYve/VODwDvOIXX7gW8r3Qahet0l9yTcTKuo7c0gsjFKd7F5vZ
         fIOY5sKA8e22nF0AoDngY16BFZCYpvoa4DaxHwKaAxM0gJNu4y0+hK/9QuZxz9t2uW
         SmMjZ5jIphFmSNa3xT4zQ62gFoYT1reC7YPt74yoR/fyMiB/hx1notocRVVlAQKld5
         DvAybiPxk8bHA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Oct 2020 12:35:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.3 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	61 pass, 0 fail

Linux version:	5.9.3-rc1-gdae2c902d048
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
