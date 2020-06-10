Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C9F1F5323
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgFJL2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:28:13 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14116 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgFJL2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 07:28:13 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee0c3710000>; Wed, 10 Jun 2020 04:26:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 10 Jun 2020 04:28:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 10 Jun 2020 04:28:12 -0700
Received: from [10.26.72.59] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jun
 2020 11:28:09 +0000
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200609190211.793882726@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <36f2ca95-cdbf-14c9-87dc-d6746ff696ce@nvidia.com>
Date:   Wed, 10 Jun 2020 12:28:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609190211.793882726@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591788401; bh=6daNWnj3djyNP2X6nMQ+uudIPivF6fz5MO5w51QjKkY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bvvdjAg8jSvOpHjWV4eZ1ZgGLYk+pzQ844ULWVrSZfhYGuEXGIHAyKjUtd4YgPqrn
         /hBqDUAzYvEotligb3NY68WGC8zgXE/2o9rTsQKugOKgfpY1bUzHTaqHg7j/AVXtm/
         oGu5COLjawBYk0vsLE2bzFdjvU7es5NyJXgG1hFp13vlrY/8nPXnN1g5Pe758B4jXo
         HEgO9Xz2Vj3HgF9QV+kVUfW8xr6ZHIAkzB+8Ct0i5CZRHrc6gNMJPhR94s4UoI+m9y
         frLRN+Cc4PLv4mkW6d3Mkbteyy6zdAthrUBfeh6vffQrLvbfFvRSW4i/2IhPFjQZ1K
         Eu8D9Q5UzNNAQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2020 20:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.227 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.227-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    23 tests:	23 pass, 0 fail

Linux version:	4.4.227-rc2-g61ef7e7aaf1d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
