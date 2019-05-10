Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5997719B59
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 12:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfEJKQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 06:16:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18549 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfEJKQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 06:16:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cd54f590000>; Fri, 10 May 2019 03:15:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 10 May 2019 03:16:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 10 May 2019 03:16:30 -0700
Received: from [10.26.11.182] (172.20.13.39) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 10 May
 2019 10:16:25 +0000
Subject: Re: [PATCH 4.14 00/42] 4.14.118-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190509181252.616018683@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <55d84e69-4ad4-e840-f716-fcb64484dd7f@nvidia.com>
Date:   Fri, 10 May 2019 11:16:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1557483354; bh=LT7N2XHoXj4UUUvKBT/M1kdRveZxhoojEy5WCu0TSNs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ik3QIGtAj4VNeokSa1a9rYMtrzqgpEvxv2lfwjUcpx1rkrDZz9tiQ6Z9J1k13Wgo7
         PcVTbs9Kg9fLlGtIKooiXBAvBNKhYFokZAPnIrgAeIpyZc7J1dBrZs57OD4IQ2MKCT
         KDi9W5AlRdleVUKj+OoJ8S2GxpgAqq5y4uZgs9TTxy/1F6ZNMT4+eg14PaAIJl/43X
         rJJcrEtt5krDQ16av1/Cg50Fsqp0kr6vpt1bsxhzW5X130Mwbot6yv+6ZOdbeMU93B
         fAW1N2Jvh6mboBH1kRgUV9U2X52xRTa3uLah1xy+o5YJ0qCw/usmjiv9/tTv6udaqq
         wOj8jx3TpoKtA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/05/2019 19:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.118 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:15 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.118-rc1.gz
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

Linux version:	4.14.118-rc1-gfd7dbc6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
