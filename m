Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3940C2665AF
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgIKRKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:10:49 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9716 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIKRKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 13:10:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5baf7a0001>; Fri, 11 Sep 2020 10:10:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:10:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 10:10:31 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:10:31 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 11 Sep 2020 17:10:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/71] 4.9.236-rc1 review
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <77207562b7ef403f8b488b1d26659667@HQMAIL105.nvidia.com>
Date:   Fri, 11 Sep 2020 17:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599844218; bh=glC0uXU0C/87bcgu2p2lovHFoEvAqhprrbIiP6HHudQ=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=e9kD1b+Pf4TPeEfQD8T9zmWPYv+5m52cMwgfgeJ4KgneG5I+DSOMj82ZiqkyO8+9l
         lWzXGG48HvXW8Yo3N9K1XNv8Ab0UScE189DWqXwQTiy2gaVs2dhF7Hh9DS91+HbCFz
         LmOopq1aIyO7P6rRpzAjTWrKLbRQRaFdqcXbRXY+hl7YYrD8Sv3ncZzWk/uY+j9Hst
         T6UdbzD4R5tQtC6rYBEyE3PRadI13GThjpIExDqCuSWYtjhNOIekrekffk0GsN8XtK
         Xsh4llUUSSwb+Q5ko056iUvmke53GWhNK8X9JkaAEM9pDX0DYm9pUWCV7to5ZGmVyA
         7BYMg7PJ/Xx9g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 14:45:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.236 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.236-rc1.gz
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

Linux version:	4.9.236-rc1-g59285d12c5e3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
