Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6201C5087
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 10:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgEEIis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 04:38:48 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14715 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgEEIis (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 04:38:48 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb1260b0000>; Tue, 05 May 2020 01:38:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 01:38:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 May 2020 01:38:47 -0700
Received: from [10.26.73.45] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May
 2020 08:38:45 +0000
Subject: Re: [PATCH 5.6 00/73] 5.6.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200504165501.781878940@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f3d40fc3-1c82-5395-e96b-65e7ba9cbfc9@nvidia.com>
Date:   Tue, 5 May 2020 09:38:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588667915; bh=tMZxKaGe0Pl3+kmL3fWvWP0op4WZx/x9KIztE4nGmGM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=P7JA+siGtS9BCXu79fhkervBDQA5yfI72wf5P/MQ44pU4+ozRE0FNOInXVjjW6Y6B
         g3DoLrR1TwMOLtt4foxxH4FfmAQPoIBrkQspFjtY/J9UAPyby4+CmPi7Ze8F4oeJOF
         u277LrdmdoAT+spV7l1RHWpkHbENZwLxBXIggGSOAfy+UDRgaSABTd46x0kxYuUf0X
         jRnBQpNNYSM3mO7F2X570fOqjcEBHD/DajsrBFRJEuyUYOpxrNuVysbg79kuY9Rtul
         9uv5Gn/CBunL3JNb5+8ZLG9t9hMEExl3tYnkkF2aGjKmWA4clhU97gjEW6xoF1zVuq
         pRXK7NyHHXFUw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/05/2020 18:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.11 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.6:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.6.11-rc1-g6cd4bcd666cd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
