Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F01ECDC2
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgFCKmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 06:42:36 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15743 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFCKmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 06:42:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed77e3b0001>; Wed, 03 Jun 2020 03:40:59 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 03 Jun 2020 03:42:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 03 Jun 2020 03:42:36 -0700
Received: from [10.26.72.154] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Jun
 2020 10:42:33 +0000
Subject: Re: [PATCH 4.9 00/55] 4.9.226-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200602181325.420361863@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4eaf333a-e497-d39e-338e-a790b116dc62@nvidia.com>
Date:   Wed, 3 Jun 2020 11:42:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602181325.420361863@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591180859; bh=TE8Gwf6AAmn6VLqDVd/fvaL76PxZrwx9Q6AdZb2E0t8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=S2YISU/PTe1VzJHpuSe46DNmIdxmOu8rGPvJKPM0QF0zZcFylw6OG+qerrJHvFDVi
         TrXCDh0TDyNnqOx5wteJQoS66dH2IAb8EEufgprMJmcwc46dg/CFnkV23nYy2aU3kN
         2oDanUp+DIiVpJkS/cpFzzTdF+W09XQ4HtDJr21ACbWz6f6g6UBJC3kyAJ6tfkSqHM
         YPrTskfq5Z6Keu4G5DzR8dm9POAT67j0Z7TPtG0chYkjlBUwHvNwg9HvEtLSdFiY4c
         UwN2HLT1IJkSqRI4PqrE1HuYfdHKXF+H7KiHZ+irMtooZP86Rwx1+1dQOQ48Dvmq7F
         IV0YCJzY5gIJQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/06/2020 19:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.226 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 18:12:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.226-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra. Seems that our test gremlins are still
at large and I cannot pull the report yet. However, I can see that
everything is passing fine.

Cheers
Jon

-- 
nvpublic
