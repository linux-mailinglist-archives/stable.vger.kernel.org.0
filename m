Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE819BC31
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgDBHJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:09:31 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2864 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbgDBHJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:09:30 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e858f480000>; Thu, 02 Apr 2020 00:07:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 02 Apr 2020 00:09:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 02 Apr 2020 00:09:29 -0700
Received: from [10.26.72.253] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 2 Apr
 2020 07:09:27 +0000
Subject: Re: [PATCH 4.9 000/102] 4.9.218-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200401161530.451355388@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b4b70f0c-8c07-4e1f-c0d8-e0f0d0067c8a@nvidia.com>
Date:   Thu, 2 Apr 2020 08:09:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585811272; bh=po0eBuDZyJ132Or7mR7MIEXqXyiQHtiLXrFAXTw3lPU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=raskTe02DhPDsMMxKD3BYkALxi8XuZfqUc2AT5d+VzLQysmeG7Bucd57VuZoi6iTV
         KUrreuHCzT4X7+ABE+TwUYQVfdI8T9v7FViY1g3JaWPIMkP4pGp0ytD1S7Urr47LEa
         ocNiKzrdazHVmhxqC6d2JoBU5R8tXLwxfbWu4wzjPgGZy7aJS2i58JVzfHf7pbXc/b
         hrkvdKaMaxbiuLTdsD73ZgwawjTIuvHxoP+XVCBrtXpNq2+cJaj5qAaiiXEb7xpMNY
         jYHUDkWiLCd9llKKnxaVgEAdK+phXx/c6TbdNE5rfxJaHF207Ht7pH29xwmPiFowJ3
         MwBgkibFLzfCA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/04/2020 17:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.218 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.218-rc1.gz
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

Linux version:	4.9.218-rc1-g61ccfbbfe9f6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
