Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A222C1724
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 22:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgKWUyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 15:54:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2553 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgKWUyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 15:54:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbc217d0000>; Mon, 23 Nov 2020 12:54:21 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 20:54:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 23 Nov 2020 20:54:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/60] 4.14.209-rc1 review
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8d9228368db64d4a9c9aedd328f43e2a@HQMAIL107.nvidia.com>
Date:   Mon, 23 Nov 2020 20:54:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606164861; bh=Nr42/q4zOW3LZI0pG7VCLZyNkr+KYFSQXG+bUNdX8Do=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ibbcW14hU+csL5q3OTF10xo6JrpjeXqBwAZ5bkVrTCu0w05bsIG5Lqrg3u0tV5l6S
         t7fzFK861EP2fczPJQbB9Xnt/R309HSYiNWdPgKupmxG5KDdYdcGptWXwlVCEAKbXu
         pDXdBGaOc83As8stcfpbl+lXH6JHRUcvRWAWKYXoFNyAMDkClL/myQseRUrcCLG87N
         /XFlbqToEZluAir8hWW1BZj3QYWPPJa8iMMctSINn2IQ9LObtAQCpcpVkkh8j4ocbq
         cRpvf1I6cC46bOHzqv0O/uJ8h21sQKipIr7KApLQWJKq/iRsfBiHhkEayNCOh01yMF
         TT8dDonCr8s5g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Nov 2020 13:21:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.209 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.14.209-rc1-gc3391de31d51
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
