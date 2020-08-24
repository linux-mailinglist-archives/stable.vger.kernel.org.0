Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098A3250102
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgHXPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgHXPZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 11:25:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D362074D;
        Mon, 24 Aug 2020 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598282745;
        bh=h/eWFUJbDecOwUmYbRcUg7wCcODJSkDc2uqwxuWoDs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VsVitkJ8X5Xrono7pwVoh15fECApnoBcFBaYf3C/OH/MxDLBu++oCa+yImiA1FtuD
         ov4x9wqCghljgiQhGl9jB7081vQT+uOkE0o9LgwRVwFtTXLiNi7a0c5ou0A2pU/rY9
         Dv/5mZHWZhWHur5/VcTTQyN9LpaoC3luLH0RhHUc=
Date:   Mon, 24 Aug 2020 11:25:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/148] 5.8.4-rc1 review
Message-ID: <20200824152544.GG8670@sasha-vm>
References: <20200824082413.900489417@linuxfoundation.org>
 <20200824134027.GA86241@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200824134027.GA86241@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:40:27AM -0700, Guenter Roeck wrote:
>On Mon, Aug 24, 2020 at 10:28:18AM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.8.4 release.
>> There are 148 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
>> Anything received after that time might be too late.
>>
>
>Building powerpc:defconfig ... failed
>--------------
>Error log:
>powerpc64-linux-ld: arch/powerpc/kernel/cputable.o:(.init.data+0xd78): undefined reference to `__machine_check_early_realmode_p10'
>make[1]: *** [vmlinux] Error 1
>make: *** [__sub-make] Error 2
>
>The problem affects several builds.

I think that I've fixed it, thanks!

-- 
Thanks,
Sasha
