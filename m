Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FA432F1C0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCERv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:51:28 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2405 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCERvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:51:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60426f8e0000>; Fri, 05 Mar 2021 09:51:10 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 17:51:09 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Mar 2021 17:51:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9f742ea97c3b411a8681de58785b98fa@HQMAIL107.nvidia.com>
Date:   Fri, 5 Mar 2021 17:51:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614966670; bh=pdMvghU4xX2oAqX8Ye9QS9qQE5HloQeXF5hu+DAg2tE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=mcXah9A2pWPTDy+jl3lY9aqT/u+v3BRWuOs0yJAcgjWgfkW8vNQ9Xu+CDrjjaJ8A8
         TieIzVywr0A+Dk6q5SIiiFdyN8dWcNVP3hozRXe3ttSgEfrzekSGbZSTsoRg9Fe34Q
         xNZR4SIxpzS1Dn9GC1g87s6rYD04Uu+z4MnO4WgEqP6SAFWqKVCTOEEYEXuuSD+jFY
         6Sbswy32ELRjyQtljH40jXpvG8Y31jVcNBZIIY2e0QipzTPjwnkZDsmzmj1AofBDgc
         du2sH5+XrvTswJdujRr2SnYfcHXJW2fxRLJOwsrQyOCbwL2Sdcjv4d71fLFYeuw5F2
         +sH65MpOAcR6A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Mar 2021 13:22:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.260 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.260-rc1.gz
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

Linux version:	4.4.260-rc1-g22ce103533f9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
