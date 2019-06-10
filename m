Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598AD3B144
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfFJIvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:51:40 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15221 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387753AbfFJIvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 04:51:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cfe1a190001>; Mon, 10 Jun 2019 01:51:37 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 10 Jun 2019 01:51:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 10 Jun 2019 01:51:39 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 08:51:37 +0000
Subject: Re: [PATCH 4.19 00/51] 4.19.50-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190609164127.123076536@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7aa59165-0970-a267-ff1c-beba95481afa@nvidia.com>
Date:   Mon, 10 Jun 2019 09:51:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560156697; bh=3DVJZDebu5/r4A3rqoBlZFkvLzgfTGRm6C7SegBNmX4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ElD8HBdQ/jxvnci2zRvRviGUAHxdnt4+coarzBm8PzDaLJirYBytilO7u0O1LZBUW
         74Ak3MzNQ48NFiFLLnCC9kprMYFoSI+lkUlNVuXbZu2Ys1zELMbkydvprVCwQbYQON
         Zdh7D0AcBA2dI702h9dqwEgYQYmSba8v3eOjPNEj9fgua4Kqo1pymUaVorJZCBmmVv
         m/h9xja0WIiKipFjmEZtlgInNspwGb8QWwdge3s7cGdYZQDBJv2fZXLj4AvG96j6qq
         c46v170sbmm/0mnOS2vEj5CWfs8tmKUdxRggT6mn8obe2VqUYhTdgOxWab0QsXIrv+
         9+jsAOmnZygBA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2019 17:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.50 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:08 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.50-rc1-g4954dbe53dd3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
