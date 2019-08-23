Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9576C9A52E
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 04:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbfHWCFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 22:05:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19765 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733086AbfHWCFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 22:05:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d5f49f50004>; Thu, 22 Aug 2019 19:05:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 22 Aug 2019 19:05:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 22 Aug 2019 19:05:41 -0700
Received: from [10.2.172.208] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 23 Aug
 2019 02:05:39 +0000
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190822171832.012773482@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ea35d533-4ffb-8fe0-8639-6fc5a780748e@nvidia.com>
Date:   Fri, 23 Aug 2019 03:05:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1566525941; bh=5rur0K0yd05LKjezSakY/CmQHFKC3ehnXhZdUWW9wBM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=A398rOs2hH15k3wJ1nGzW6/ghpSq97vzGxGDWXuyNGVyNRtYNFnw6IUUmbteolcGv
         kBU7Zp6tRolzknSU4C2zIrHNnnsmML0KgrQarKO1xfeQZC4wqqT8n2CrbvBwG4Bf2f
         +dzZ+zrPiXQRj/l3I0mygpKwKBjgpRgVPTiMd/CZTkHpRh1tKWZ9jBxqsN9oP1K1mE
         GW/HWSuFGq5vMGrtmZ04ICV3K/eJPTq8G/JMNWNHqZ0vUOk7aECzfvbPb+U6hmQHYW
         DtNicwr2LnSLw8MCTxbjqyfaezJhIpzqHXGTSrd79+GMgvTfvW2CkKjC1NOvdIjviF
         +N4ek5oRmzg6A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/08/2019 18:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.190 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests for Tegra are passing ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.190-rc1-gf607b8c5ce70
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
