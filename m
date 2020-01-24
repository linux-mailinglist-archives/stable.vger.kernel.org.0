Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E02148A85
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgAXOuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:50:11 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2900 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbgAXOuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 09:50:10 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2b04130000>; Fri, 24 Jan 2020 06:49:55 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Jan 2020 06:50:10 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Jan 2020 06:50:10 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Jan
 2020 14:50:07 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
Date:   Fri, 24 Jan 2020 14:50:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579877395; bh=hCuB1ZJ6geaZdxF/8Kexf28/XzK5S0Mgvp2ME0yIk+8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Mw0QYO3ZF4Zu51FfLu93VZEe8OnilzdAvJ3/UETGjie9b/W6fIJPFowEGhWeW8cAp
         8tWIO4YikTuRU35YheFZbNE9WqnCvcHEcMBafVWGg6Zp3Mh/XaArD/OCsZYSUGlTpU
         ozo1D33QNu27Aqcl4zn+AoMv3aMEyAKJJpEV5A6fWmaSMIxNS5vHRJpnyBc5gLVdOi
         OvM9DyJJ06ys2AWGPv5Oepg2/XkRnui4OVJ+H5GNEN2j+7jodkDPhxIGD8beBQ3q6u
         bp++pSth1LVzm5KPlIim3wQe4D7G9yVuDpNZreyydH6pnKlQ/wlvB+Xm6g/QidrW+L
         ozR9fUETwLTbg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.99 release.
> There are 639 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     PCI: PM: Skip devices in D0 for suspend-to-idle

The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
Reverting this on top of v4.19.99-rc1 fixes the issue.

Cheers
Jon

-- 
nvpublic
