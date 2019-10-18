Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4218ADBF15
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 09:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbfJRH47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 03:56:59 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11166 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfJRH46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 03:56:58 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5da9704e0002>; Fri, 18 Oct 2019 00:57:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 18 Oct 2019 00:56:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 18 Oct 2019 00:56:58 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:56:57 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:56:55 +0000
Subject: Re: [PATCH 4.9 00/92] 4.9.197-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191016214759.600329427@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <bb0aec70-ae68-dc9f-7557-2cac382dcda8@nvidia.com>
Date:   Fri, 18 Oct 2019 08:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571385423; bh=9XVicHJCxzd+qIxj4wsXMcgGPVIGwCIpoawd199oAQ4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=roIf8Ursnn+NQ+K6BbeJ9rccN0U6qCKVyYQxg63DcWJ8DITCXcVtmfu3vyHgYNia5
         wFpW1oslgFi74tuwL46GNRL+k6/lpOTg7NjbRuo2WRvt8tNR+wx+9rXysy4kUUbADC
         1HTTY05tQLi+bA5Zn5FEU8vifkOZr5Yd8U0iPMaqI671NdIjBac0WOxuZcc3nn73jW
         yXNqIE399wQmNmqnAqyRcUbMAJOYqeMcIC/+Wxdwmyao7GyTLf2dgQGlZX7CS4IjIQ
         asMTxVF39aG8v/UgKnD5lXe8ssRC1nj/UXUjzVy37vuYW6mf5G5+3urf4l+/+ovVLt
         f+NZW35Y1UV+g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/10/2019 22:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.197 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.197-rc1-g5749cdc967d4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
