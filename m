Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615574B45A
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbfFSItF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 04:49:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11144 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbfFSItF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 04:49:05 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d09f6ff0001>; Wed, 19 Jun 2019 01:49:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 19 Jun 2019 01:49:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 19 Jun 2019 01:49:04 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Jun
 2019 08:49:01 +0000
Subject: Re: [PATCH 4.14 00/53] 4.14.128-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190617210745.104187490@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c4c6c3f5-2117-2db2-58a8-1a84143dc034@nvidia.com>
Date:   Wed, 19 Jun 2019 09:49:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560934143; bh=/hqGATOT8SsZioJs/Xm1JvzpFqqC73xcdKMgy8UNLw4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=AoR8MaaESzze/gzOuAPxTMHwmpqJPFYAcOFAWy6qbmwMgmscm/yTStoutjslOj0Sw
         VSpolnOh0+cC1BhLQ6D/aWY1lDJSDgSBt7uPsz4LcaDHyEzr9VXwysiqx9KaHJMz7p
         SqHnTXF1SV31uttCQ3VhBmnoRP9iviq7bufDgAiZK6j/hLooKxn7C92UQGA5BjSeJx
         An6zk54bsfRRfKNzyjRuk2ICcux52SxdMVgcMlSJDmBcyJMMMEim8/g766ziuPc8N2
         4VuTQQo/SpiLbZkiauaDHwBW6BSfAtJlgHNwWf+0ZstTRHe+k3cUpLlZwh4D/0j9J/
         HwsrwDtvkqTeg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 17/06/2019 22:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.128 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I am still waiting on the test results for 4.14-128-rc1. The builds are
all passing, but waiting for the tests to complete. We have been having
some issues with our test farm this week and so the results are delayed,
but should be available later today, I hope.

Cheers
Jon

-- 
nvpublic
