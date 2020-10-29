Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB929E6F2
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 10:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgJ2JH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 05:07:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4672 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgJ2JH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 05:07:57 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9a86730000>; Thu, 29 Oct 2020 02:08:03 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 09:07:56 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 29 Oct 2020 09:07:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/408] 5.4.73-rc1 review
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f4e59a627a2d477ea557b9c46829a0e2@HQMAIL111.nvidia.com>
Date:   Thu, 29 Oct 2020 09:07:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603962483; bh=nvZZAqzJ2UlqbtQ1LI81LBmw1HTWRV29bOiu/VUPkLk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=hhxjVrvY/Z5GFYz6qPs/si9JWcEkeRSxa62/S8E5uq+RAt8UY1izyGhE4XDEBJuyg
         wut/zSqOih8n8BgAtps6SyI7D0iBMWXPP5KJ8KE5xH2IHJGpCSQ2QSF3NZn0e1cSIx
         pQ7WvnaQT0co6fQQOz3DLG8vEf3EAFsxQGSd9bBZbR2dJpTGP1DxwW0SD09w5Yjd5C
         LTZxGl36BTI6A5eEMXrBeYQPjeTJwdN+TT6sWQPSOwKR7U7zrSWMdMfBsTg2jie3+O
         21sDhJ1q0SU06sRi0n1Q/lxyL0YyypYjPNAsRyuEt/wDM69+xwMatG3izRTj7FV1jO
         x6sU1dfl2Ro6A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 14:48:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.73 release.
> There are 408 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:53:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.73-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.73-rc1-gab6643bad070
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
