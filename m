Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3312FCB52A
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfJDHix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:38:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9942 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfJDHix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:38:53 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d96f7150000>; Fri, 04 Oct 2019 00:39:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 04 Oct 2019 00:38:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 04 Oct 2019 00:38:52 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct
 2019 07:38:52 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct 2019
 07:38:50 +0000
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191003154540.062170222@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fe3f55e2-9252-786d-0541-7dd253ffc438@nvidia.com>
Date:   Fri, 4 Oct 2019 08:38:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570174741; bh=KrQw1UM3pGwoFRlhUNjup8Zg+qJin/tMYRz52K1wtGg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=R4Vx5qhXl7k0gdiDRco9c4t7m4TviI+brjjhGes7q0rbxCG3cnkJt1kfblDovao1q
         9y05ZGq23Hap3GnH5huSNFyO6gRVh4lLdM9vBjPZ5k5wqpqexFgyW6RTezJSzebPDv
         CI5BoFy2j1SKuErJIlZwemOd7vkRGJ8Z018pdUvD/uyzECXqFlBnWoToGxDIcXIx9i
         Bpv3/LM9nrgNpvt4jOAwjqN0zpdZ15rh7mNzGLhXr7b+ysbTmM/nTmtnfW/4fsM9WD
         fNFhyWyUHRrliz929RBOIAzjItIg8gQA7/LxT8m8C9v7Oojx0AySIyuFBmVTtJdBcc
         6XPJQxSgGZw7A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/10/2019 16:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.4 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.3:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.4-rc1-gc9adc631ac5f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
