Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BEA31B30B
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 23:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBNWdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 17:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhBNWdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Feb 2021 17:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E78FD64E29;
        Sun, 14 Feb 2021 22:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613341979;
        bh=IQr5Zi4JcZ0zY+DGjxnDqEW3QO4XRZ6h92GpBYhGKk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWyU9U5euuHNkxkgv2Yj87Q0OVrT3gyxOPrYWLccOLWYGGj4yAmG4Mw7n3jVURwJT
         7FY/jHyuyvUuw/PbsA6cbpvcg9q+uYMOLj9A8Q9tJ51Ytoch8Ijsa9t9Zd7ZMji8B3
         qToxJZzZIVSJ3ssF90rljP4Jvbz5WnjWbk0WByxptGMT65HV6q9eOUf062xZ3TfyOu
         9+d3pgsPmt687m2jpFuIyO607m53U7wFrk0jaFn4RojkgP2uze0ni68/xqfrC41i2R
         W3fp01Y87MPmz/LSCTpcW9qQAE7MWtLLtnY9AjKC+DqfT7v+gX6aQQHXJtH18JYRxA
         tvBtr9T+ps2lA==
Date:   Sun, 14 Feb 2021 17:32:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
Message-ID: <20210214223257.GA2858@sasha-vm>
References: <20201207170533.10738-1-mark.rutland@arm.com>
 <202012081319.D5827CF@keescook>
 <X9DkdTGAiAEfUvm5@kroah.com>
 <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com>
 <YCU9zoiw8EZktw5U@kroah.com>
 <161306959090.1254594.16358795480052823449@swboyd.mtv.corp.google.com>
 <YCla7cNQxBoG2KCr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YCla7cNQxBoG2KCr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 14, 2021 at 06:16:29PM +0100, Greg Kroah-Hartman wrote:
>On Thu, Feb 11, 2021 at 10:53:10AM -0800, Stephen Boyd wrote:
>> Sorry for the confusion. Can commit 655389666643 ("vmlinux.lds.h: Create
>> section for protection against instrumentation") and commit 3f618ab33234
>> ("lkdtm: don't move ctors to .rodata") be backported to 5.4.y and only
>> commit 3f618ab3323407ee4c6a6734a37eb6e9663ebfb9 be backported to 5.10.y?
>
>655389666643 ("vmlinux.lds.h: Create section for protection against
>instrumentation") does not apply cleanly to 5.4.y, so can you provide a
>working backport for both of those patches to 5.4.y that you have
>tested?

It was due to a backport of eff8728fe698 ("vmlinux.lds.h: Add PGO and
AutoFDO input sections"). Taking 655389666643 and 3f618ab33234 converged
us back with Linus's tree as eff8728fe698 worked around not having those
in 5.4.

I've fixed it up and queued both of those patches.

-- 
Thanks,
Sasha
