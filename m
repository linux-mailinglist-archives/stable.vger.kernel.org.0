Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0952E83893
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbfHFS3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:29:49 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14413 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733009AbfHFS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 14:29:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d49c71d0001>; Tue, 06 Aug 2019 11:29:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 06 Aug 2019 11:29:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 06 Aug 2019 11:29:48 -0700
Received: from [10.21.132.143] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Aug
 2019 18:29:45 +0000
Subject: Re: [PATCH 4.14 00/53] 4.14.137-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190805124927.973499541@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <32290e98-5071-f6ba-b8d3-0944f18735c2@nvidia.com>
Date:   Tue, 6 Aug 2019 19:29:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565116190; bh=8x7vANfnbTbpY1F5shN8Pe0gtUHbFuZRTxMyBNxxwyo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=H1ZdEBxrAdl499SAypQXaFFGYoB3V3s9Dox2NNg6mqL/m0eFpa8IopnoJytxbKTvV
         krFSCX+MR6CQfm4gvdyXQA5ivFdYYjVC8qIwgz6+7q+lxDjqZRjLLswi8EMofeG04v
         xKYxLcwnGwLGWLgGtZvW1X7iV3dhS/4VM44hArhZbbf8jlEMd9Oot8OH97ig3VKuiI
         +9qgVYlS846DShiwIdyzlrGcwKxhvZSONGYnkPXvxzxCz6nF1xkL60bkx6w9bJ26Ro
         qtpr+pbUVuDMIPDivArlrL/jofrl41ubtIMYHsMH5PR+3iHRKU03Ti06mOKSDTn5ve
         8Lb8yG6YNXzHg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/08/2019 14:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.137 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.137-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.137-rc1-g20d3ec30650b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
