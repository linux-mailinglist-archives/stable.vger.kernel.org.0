Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6F2A2780
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKBJxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 04:53:55 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9024 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgKBJxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 04:53:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9fd7360001>; Mon, 02 Nov 2020 01:53:58 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 09:53:54 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 2 Nov 2020 09:53:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/70] 5.8.18-rc1 review
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3835ee7dbb9b4f3486602c35b7480b05@HQMAIL111.nvidia.com>
Date:   Mon, 2 Nov 2020 09:53:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604310838; bh=TnlOWvc4KI46GDWimgo98+No2Mofs7OaIBeLRAECwAI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=kcT5RQg/IfQ5auJM+Qhp0vTp7i2OPJMvz3ysQJU91J/WeUDeV4P4fuEE2SfbTt1E/
         tN1IGbVcYXsB9SzJrPSuX9QFfDOkS+M3dOUrMlqTan4GGdYGE/ZIjQMcJOHI39JOcV
         j3RK4SEwMhE7sjLWdqlUgSBaKL1x91ZDzR1iXQu831d4URf3O1EF5PbvnoFJwQBk5F
         WS+z1yS43SSlarWwYEUAHnLP2dDMPe4rqJxxhFvU0J5zKowFQUmU3W3FC0RzAKrA1E
         giyAQe1Cx9BrSU9HJCl9/qiU9GOJgcA4oHZnDqUXVIRm3nnwYmgTDQSUc8ZNy/OepH
         HvHahRvjHctXQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Oct 2020 12:35:32 +0100, Greg Kroah-Hartman wrote:
> -------------------------
> Note, this is going to be the LAST 5.8.y kernel release.  After this
> one, this branch is now end-of-life.  Please move to the 5.9.y branch at
> this point in time.
> -------------------------
> 
> This is the start of the stable review cycle for the 5.8.18 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.18-rc1-g46e8244bb94f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
