Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62057322D23
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 16:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhBWPHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 10:07:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10571 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBWPHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 10:07:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603519fc0000>; Tue, 23 Feb 2021 07:06:36 -0800
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 15:06:33 +0000
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210222121013.583922436@linuxfoundation.org>
 <8bf31a259854471a8c448905f47ebcb1@HQMAIL105.nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <81009a52-c35c-ccd2-a430-171b9828216d@nvidia.com>
Date:   Tue, 23 Feb 2021 15:06:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8bf31a259854471a8c448905f47ebcb1@HQMAIL105.nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614092796; bh=my+tGRPriaVbCMwWorG/+eI+yWCNqMzMwkYZDKaeUyA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=TOb9kwF47foUkc/wU+2cxtabB5QtBxNcU4QzvosHR0Ap0A1AHpavL0mLDscGD7HO2
         fSIEgLRDySWH9JRt0wCSJQN0a88aiweYnEuUaa/W2lyrh5pGSSv2i6IvR6QhfahXWB
         mb0O0MMqZintramutXXEZWNOvymSnkXTSDO23MnMAg992HPwhf/VSSWes0Gwnxfhsu
         FN5apCy+Lez4TX5PEzKtXhA3FPvMAA9ee/UJzdl/tqZW1YRtS8WxA8fQg96amSQdZb
         PbJMCaMIpL3qUOKWXwzily3OdF3nHPArCqiyrtShG9QDGi2VQR7VEgzWkgeUu+Ifpp
         bEshEhhOd+Lag==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/02/2021 14:47, Jon Hunter wrote:
> On Mon, 22 Feb 2021 13:13:17 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.100 release.
>> There are 13 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.4:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     57 tests:	56 pass, 1 fail
> 
> Linux version:	5.4.100-rc1-gb467dd44a81c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra210-p2371-2180: tegra-audio-hda-playback.sh


You can ignore the above failure. This is an intermittent failure we
have been observing on this board and is not new to this -rc. This has
been fixed by the following mainline and has been tagged for stable.

commit 1e0ca5467445bc1f41a9e403d6161a22f313dae7
Author: Sameer Pujar <spujar@nvidia.com>
Date:   Thu Jan 7 10:36:10 2021 +0530

    arm64: tegra: Add power-domain for Tegra210 HDA

Usually, I try to filter out these known issues, but missed this one.
Anyway, for Tegra ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
