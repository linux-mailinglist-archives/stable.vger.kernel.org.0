Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8127EAB348
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 09:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390862AbfIFHgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 03:36:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8919 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390847AbfIFHgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 03:36:48 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d720c920000>; Fri, 06 Sep 2019 00:36:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 06 Sep 2019 00:36:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 06 Sep 2019 00:36:47 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Sep
 2019 07:36:45 +0000
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190904175301.777414715@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <67c08e93-121d-1082-4fad-0179806b9ea6@nvidia.com>
Date:   Fri, 6 Sep 2019 08:36:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1567755410; bh=Rp9rvl8ULqCqsxcrvUZsdsBA1dBwVPqsijpor2gH0Eo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nP9wSw68FTUv8QqAvNexSO2/BUpuy8CkmJoy6T4Sh1lNNNgZDUDyBaS58jUdpXQ31
         yBW6ZywsV51QA7eEyvFCNpA4w1v6nHs230MbZE8fjA7R//0HKzjDDYLXkisBchqXN0
         FIef6aoQsWJN+evPM91LYKDzpq6VmGmPMRPBDvff5erBD6bgR3IUxz/JfZ9ovkzFUD
         ph0oBukf+b7qhqOZGBPNMH1vBW6NVinZuyvArw70v5pEzzuNzVgUEi7a5oDI502TUD
         hur5tW/JMUZuKriG98fZsok3Fn4UXcH3Qw60JuYjYFPrFFoAkrCifpkL/Y6ExnZSR8
         FrFvxwqs2EmfA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/09/2019 18:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.142 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.142-rc1.gz
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

Linux version:	4.14.142-rc1-g39a17ab1edd4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
