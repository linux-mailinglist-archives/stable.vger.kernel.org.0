Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C0617281F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 19:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgB0Svk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 13:51:40 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6566 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgB0Svk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 13:51:40 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e580fae0000>; Thu, 27 Feb 2020 10:51:26 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Feb 2020 10:51:39 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Feb 2020 10:51:39 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 18:51:37 +0000
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200227132255.285644406@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <00d00c75-b0fb-ab9b-035f-892c0adf566f@nvidia.com>
Date:   Thu, 27 Feb 2020 18:51:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582829486; bh=MVLc5KAcYlDnuDuiew0ID1LiKMM4lX9lHUpdmqNhXzo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BoPmdNPahc4Ez/MzPrKP8Am+3A4WKw36H0jhi8fwPuM9AhcjT2ij6X/Lq2Q1rvWOo
         TStN9p3jkzdt0QQkvjMwCbLaeNor199D3DsH6021ld/d0hXDta92dFKAJc4vfK5zYE
         oQ7eNQW/1gRq2TFlU10Ad3EtEVuKH0BF6CFPpvQcsWK9EBLP0SuV68TSLI8+9G+d4p
         3nShmEqlFl7MjuRb5DD2xpqCTJIdz7ILkaUeU9MBzgOlNRphWuixsP/2Do9CN5J0r/
         p3mPO4le5nR48x/awjxGWrLaqGia9jHuA2T5DHc84i7Ueay1GwgIQ/nZ2o7NPqVy2m
         OvpwQzu0PJyXg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/02/2020 13:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.172 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.172-rc1-g47e811c62a4a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
