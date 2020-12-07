Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F112D1450
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgLGPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:04:47 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2093 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgLGPEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:04:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce44660004>; Mon, 07 Dec 2020 07:04:06 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 15:04:06 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 7 Dec 2020 15:04:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/39] 5.4.82-rc1 review
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <39d6663df8414c7dabcbe5f6eaa3364e@HQMAIL105.nvidia.com>
Date:   Mon, 7 Dec 2020 15:04:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607353446; bh=YFFsIoF5vAszxUIqEPqr1nhT/HJm5dRXICJO2WnXdCw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=COsCw4cEQyrhrprdFhcSXHV0zBOSnSjDcmaiX1DL4MtVed6atD3Wl/nVY4BfckLlV
         t0QQRhQ6sD3Zdx5mrZyAvheCteULcyNgzotDlC9WtVL8HFKtbb7YzmtvE6PjOc83YQ
         UdOF/TEboEliRnMP6iD4+9h1lzblpVy3qUM9tYoBAsrul89PGGxj5O3B97crMNJdJ/
         4XsUjOsgSV/03J5ZtoFcTzPleSQkcJywHbbQW6GmEaWs0fLbaugiU04+EjuAPqHO42
         d09CZ70ZPh7g8/1afptPNNIXYdVWZ4ZLhT7Hr7jjejephtNHGfY+bqB9fLLlgmSN4n
         uJEKUyigoxb9g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 06 Dec 2020 12:17:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.82 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.82-rc1.gz
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

Linux version:	5.4.82-rc1-g08a1fd1f5653
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
