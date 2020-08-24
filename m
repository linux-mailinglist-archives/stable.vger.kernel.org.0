Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EE324FB28
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgHXKQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:16:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9131 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHXKQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 06:16:48 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4393190001>; Mon, 24 Aug 2020 03:14:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 03:16:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 03:16:48 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 10:16:47 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 10:16:47 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/39] 4.9.234-rc1 review
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <d7a01ae24c22434fbc078f247822eb62@HQMAIL101.nvidia.com>
Date:   Mon, 24 Aug 2020 10:16:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598264089; bh=zCOMRXf7r4TjWjRDyZTp6px6T7iE2QwmzkwLgQxRwXU=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=klOZwYYP8K88mJTrxEZ7hCvN0y4DpfGLfztmdHFJ7YEksx9+15Xg9d1pVYXcspZ3O
         Q9nrVLWUuGnMwAg4S1PB5OixvC4rMvfEY84sBkE1iS8R1dl3cDdBg2c/oOyCQQosk9
         KWIiRsFPhkAyTaEr9pS0ZdnfLABKMgIWQTyVRDytJ8l+7TKbDwfm0yoQO3GzcImfNG
         VN2/9D5v1P3VYjHho9wGFGLvFlSfHYHxCDHSwe4MsiwaIu1ULKricKaHDEnU4tsSy1
         OWhivNjKqR0+7JXvJlicP2ZThr+heVzBK3DRvDdz9O0mnaYqM1+6aesX8AZnG7XC+q
         5GeVTxjAhLwMg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 10:30:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.234 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.234-rc1-g8d1fe1cced13
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
