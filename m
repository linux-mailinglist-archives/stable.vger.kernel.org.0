Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834743F881C
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242551AbhHZMyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241694AbhHZMyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE2060F5C;
        Thu, 26 Aug 2021 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982430;
        bh=keNBX7SFSqfF3N6JO24xfIsjMkrDbqSgkct7nC29eFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P+yh6jtZLGOimyc4DflP96vq7mJ3Me1O0tbhoR9zUnJV5m0p2wZ1jLEpl6eTLJbAV
         N8Gq/lCdqT6im4l2UqNkns0ZVtmzV7zwBvTfEubH/0HD1axOs4VXLgmhc7736dNomN
         b2VVeEWE41yAU3+KOOujLjaqvgktCtgHO9O8QtzkSp5tZP7sil6tETJjQfQc+OW71i
         bpG4ZisRGHIiOD/9vEz19lSP/qzAd4BzfKbrjPOEV7PW3HIYXok8wIdkW808lfDXci
         KT1Mls8Wws4jpfw6bu04Fm68H0Q/au9ablqZVqEoj/BaK71LD/K+tZTSmskaJnBY6M
         3UCCwpX9pdfVg==
Date:   Thu, 26 Aug 2021 08:53:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <YSeO3bNOstcpo9P0@sashalap>
References: <20210824165908.709932-1-sashal@kernel.org>
 <YSZB0FB9YNd82bei@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YSZB0FB9YNd82bei@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 02:12:48PM +0100, Sudip Mukherjee wrote:
>Hi Sasha,
>
>On Tue, Aug 24, 2021 at 12:57:30PM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.10.61 release.
>> There are 98 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu 26 Aug 2021 04:58:25 PM UTC.
>> Anything received after that time might be too late.
>
>Build test:
>mips (gcc version 11.1.1 20210816): 63 configs -> no new failure
>arm (gcc version 11.1.1 20210816): 105 configs -> no new failure
>arm64 (gcc version 11.1.1 20210816): 3 configs -> no failure
>x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure
>
>Boot test:
>x86_64: Booted on my test laptop. No regression.
>x86_64: Booted on qemu. No regression. [1]
>arm64: Booted on rpi4b (4GB model). No regression. [2]
>
>[1]. https://openqa.qa.codethink.co.uk/tests/56
>[2]. https://openqa.qa.codethink.co.uk/tests/57
>
>
>Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Thanks for testing, Sudip!

-- 
Thanks,
Sasha
