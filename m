Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143DE16A4C0
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBXLUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 06:20:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18171 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXLUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 06:20:03 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e53b1160000>; Mon, 24 Feb 2020 03:18:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Feb 2020 03:20:02 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Feb 2020 03:20:02 -0800
Received: from [10.26.11.229] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Feb
 2020 11:19:59 +0000
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tero Kristo <t-kristo@ti.com>
CC:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, <patches@kernelci.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <20200221072349.335551332@linuxfoundation.org>
 <529a5a4a-974e-995a-9556-c2a14d09bb5d@nvidia.com>
 <CA+G9fYv-KC0v++YsyXR-rhC2JBGUfhNGD+XYaZjN3fJSX1x_mg@mail.gmail.com>
 <f671fbf6-1cd5-ae8a-82e7-d3aba63e9840@ti.com>
 <20200223172604.GC349989@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1a6e640e-6d6f-26f8-d24d-025f32aa042e@nvidia.com>
Date:   Mon, 24 Feb 2020 11:19:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200223172604.GC349989@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582543126; bh=M12K3ln0ZRl8ICjqGSGcQ6TS1TJ9suo88Zt6Lzh4uBs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WsFM4RR2evbiGP5UvmA8WvBObaUVn/r+IfHwnWNzPk1VY1lGSlBcAzKQCWsKntGce
         cwiRxgJhGT4/S0RChgjUcwlNp3YGgi2zXaMT9Ttf5r/GyYVyqgCN3/hge9X8Yc/KAD
         jrNc6WE5GeikFkQkIH3i/YEWx0JMt0xwhKHFcAvUJSIllGm02NPNtLLH1Z3Ff5KPta
         8L03oIz0baFSxOWouyH4yAViPPFh4bhV89O81FR5DQizlQJF8cfoDaC5PrDhCpw4fB
         uZBSgJ4HYsLSpK4zWagy2dfRUOlCSofciVC1aNmIAxGSabiYTZZpzifl/ZlyCFHIIS
         DDoA3zTG4U0JA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/02/2020 17:26, Greg Kroah-Hartman wrote:

...

> I've dropped the offending patch now, sorry about that.
> 
> greg k-h


Thanks. I know that it is already out but FWIW, looks good to me ...


Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.22-gf22dcb31727e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
