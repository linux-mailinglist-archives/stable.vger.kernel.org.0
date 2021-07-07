Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2572D3BE7F9
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhGGMcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhGGMcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E27C861A11;
        Wed,  7 Jul 2021 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660970;
        bh=z/tt5nA+1FFY7M4nvWwx9xv3m6x9cE67LB9/uweQDVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g/lh3oCLzoGoWXIZ4FjLIQlgfBGocQsoqXoCZGaXGzVH2uCiTq0SUb6qWWBWQZcer
         JYbuyB8gbJqF2JXnh1OGgdjPWb3FC03I2TQrsEY57aTHmBxqb+cNf3fL56/c2XkPX1
         xSVYSKx5quMDv8KJE2PsXGLkfRECwhtXvfQCc0fcvUYeTddxMQqbCEGkONb7EHE+zC
         puQGfG1gw8Y+yiPgM5EMyBZoKqzZ+P0Q/rtbJb2604tjE1UWxmgDEOc0tESATJwfF6
         jl2RnWIM1dFY3TpaqBMKoIX6DOd4+2KqsHda+67MpOYmqk8j73gTkOrcPH+vD666Rk
         IxW0T3TNZxfVQ==
Date:   Wed, 7 Jul 2021 08:29:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <YOWeKcooIn/aZCbs@sashalap>
References: <20210705105957.1513284-1-sashal@kernel.org>
 <YORzTK+qJrbMo8IM@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YORzTK+qJrbMo8IM@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 04:14:20PM +0100, Sudip Mukherjee wrote:
>Hi Sasha,
>
>On Mon, Jul 05, 2021 at 06:59:50AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.10.48 release.
>> There are 7 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
>> Anything received after that time might be too late.
>
>Build test:
>mips (gcc version 11.1.1 20210702): 63 configs -> no failure
>arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
>arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
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
