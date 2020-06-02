Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929261EC01B
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgFBQd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 12:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBQd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 12:33:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B4520738;
        Tue,  2 Jun 2020 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591115638;
        bh=4CjCw80BZTOzb/YKDNCLPm89dR/P4rKyDc/s6NraB/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ko2gTmOzTzIq16CanYF+spsIJTdi34469Yf/sIueI6uV4n+pm5ROy4TVwqlUTUQcl
         nGjVcOeoLs56PVQpLxv1DQmBPG6MyCs3onXRFyEUGBgOjJs3fHVHuFO2qvQPS3ffvU
         w91hewpyPhXq94L+UvzFwPF2frRlPM0hHsxKDetI=
Date:   Tue, 2 Jun 2020 12:33:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/59] 4.9.226-rc2 review
Message-ID: <20200602163346.GQ1407771@sasha-vm>
References: <20200602101841.662517961@linuxfoundation.org>
 <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 08:37:26AM -0700, Guenter Roeck wrote:
>On 6/2/20 3:23 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.226 release.
>> There are 59 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
>> Anything received after that time might be too late.
>>
>
>Many arm builds still fail as attached. Is it really only me seeing this problem ?
>
>FWIW, if we need/want to use unified assembler in v4.9.y, shouldn't all unified
>assembler patches be applied ?

We don't - I took 71f8af111010 as a dependency rather than on its own
merit.

>$ git log --oneline v4.9..c001899a5d6 arch/arm | grep unified
>c001899a5d6c ARM: 8843/1: use unified assembler in headers
>a216376add73 ARM: 8841/1: use unified assembler in macros
>eb7ff9023e4f ARM: 8829/1: spinlock: use unified assembler language syntax
>32fdb046ac43 ARM: 8828/1: uaccess: use unified assembler language syntax
>1293c2b5d790 ARM: dts: berlin2q: add "cache-unified" to l2 node
>75fea300d73a ARM: 8723/2: always assume the "unified" syntax for assembly code
>
>I am quite concerned especially about missing commit 75fea300d73a,
>which removes the ARM_ASM_UNIFIED configuration option. That means it is
>still present in v4.9.y, but the failing builds don't enable it. Given that,
>the build failures don't seem to be surprising.

I'm just going to drop this series from 4.9 for now, until we can figure
out how to do it right.

-- 
Thanks,
Sasha
