Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AFB1C1931
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEAPQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 11:16:10 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6189 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgEAPQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 11:16:09 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eac3cbc0001>; Fri, 01 May 2020 08:14:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 01 May 2020 08:16:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 01 May 2020 08:16:09 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May
 2020 15:16:09 +0000
Received: from [10.26.73.180] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 May 2020
 15:16:06 +0000
Subject: Re: [PATCH 4.9 00/80] 4.9.221-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200501131513.810761598@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f2847c1c-7358-570e-d455-d44ed78c6a7a@nvidia.com>
Date:   Fri, 1 May 2020 16:16:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588346045; bh=yxYSBOqiLVsESzYLgaNc/c8FUS7RBD7UEwa13BpBNWo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=U83Hl2O9D8FNrRtjTb6wKwURcs4oX7e3mNtX1i6q2Fi6rHtXnLVa0k8MZOZEjkQ36
         kOI8rfZinrKadG+y0ZJCQbah5WwO+bLxv6IMB04SHVcLMeq04UfRUQWHlfJKeKYyNr
         7HjL5iDyef0opd7Z/pVbXwGtLt5r3Unj4ByIySps1s1QHidq3A44q/N4EhKVnXmej1
         0fqrppqFbkqmQ/A4yXiy+NtHZQgv4SYkx9KdT6jCSA/Z+X4jTP2HJfzXvqWOf3HWZW
         2hLZ3PdLTOI0AA/wpsb/k5jmXHDDpENWZe65NebN0s97D/bWXjDov/RTs1hQC3iA8D
         xrIoDlcET3FcA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/05/2020 14:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.221 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.221-rc1-gc0dc655ddaa6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
