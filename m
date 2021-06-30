Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D063B82A0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhF3NH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhF3NH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C44061455;
        Wed, 30 Jun 2021 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625058297;
        bh=J1KD6jB3Gnvc0flHoOaCVzEh74RJwuds4YV9zsTRu0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=apLxx2HGvU80+J4J04vCkZdlHEnVDPLqzn+HN659QYI7/fhgTOtavgSybPHOfOWrL
         qgyFEJMQCeFYzdt7p1t7nPFwWb00dqa0CMX3G0w3lfhLd3BHYXrZS1YMYAOVRjls8S
         nt5vF+BG9Sp6B5rYBMBRSHOzThjg+HLxrVlvfYHh+5CnL2hUAZNrBA/UBIEU9Ewope
         LJnRjfeZy6hG7EGaw2Fh4t3RVGwMCBD6Wl2MQoXmpnw6zBJ9ZeIJXYfHiGF4DtfEvx
         LeqOG68xfTCPXvAEXEhjy4PTUFX/ZKYRivhTwBVKYgT23zYb3XXPL3KsfSptZUfqzf
         1UeF00yEVU0Qg==
Date:   Wed, 30 Jun 2021 09:04:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
Message-ID: <YNxr+JOgiKB1FVkf@sashalap>
References: <20210628142607.32218-1-sashal@kernel.org>
 <YNsNJnEsTby87llx@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YNsNJnEsTby87llx@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 01:08:06PM +0100, Sudip Mukherjee wrote:
>Hi Sasha,
>
>On Mon, Jun 28, 2021 at 10:24:26AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.10.47 release.
>> There are 101 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.46
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>
>Build test:
>mips (gcc version 11.1.1 20210615): 63 configs -> no failure
>arm (gcc version 11.1.1 20210615): 105 configs -> no new failure
>arm64 (gcc version 11.1.1 20210615): 3 configs -> no failure
>x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure
>
>Boot test:
>x86_64: Booted on my test laptop. No regression.
>x86_64: Booted on qemu. No regression.
>arm64: Booted on rpi4b (4GB model). No regression.
>
>Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Thanks for testing Sudip!

-- 
Thanks,
Sasha
