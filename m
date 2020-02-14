Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9018C15D57E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgBNK0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:26:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7534 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgBNK0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:26:02 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4675ab0000>; Fri, 14 Feb 2020 02:25:47 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 14 Feb 2020 02:26:01 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 14 Feb 2020 02:26:01 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Feb
 2020 10:25:59 +0000
Subject: Re: [PATCH 4.4 00/91] 4.4.214-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200213151821.384445454@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <27634e98-7fb3-77ea-1700-cbf57d839933@nvidia.com>
Date:   Fri, 14 Feb 2020 10:25:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581675948; bh=ZjW60nX0T35MqSm51TqVp40HZ0y6CsNfjT3DPbV9IaU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Cr07jEvzSEP1aifogD/jImcWQlJ0/he2HmkVLafOBEWPP5ZIFQDTMVMlOV5teWJ6g
         kbY9Q8piseTZSUdXP8EtLFl9H4L8IeS1XXNVF4VYoTKJuLQ61Pq02MmCLTpn31z9FY
         5H76lJ4iJXL3rvEpjxvG/nQHMtbD0o2DUlsAm2c8lEOOeyMFB0xq+xc8dCWrwVAHjQ
         n1CXlXafiJKMZWZBrGR7rBRJyme+010ciC2UrCm4pOdOKBwc0LF0kMuBDPU+YsgBg8
         H8jDgufUpGqE9+eQB31V80elew08N0S6ws8TQtCizvmG49HUX9miTeZYpoPvvzMeXz
         8eilAljT5v8NA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

	
On 13/02/2020 15:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.214 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.214-rc1.gz
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
    19 tests:	19 pass, 0 fail

Linux version:	4.4.214-rc1-ga4539ca32651
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
