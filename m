Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CC29F927
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 00:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJ2Xgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 19:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2Xgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 19:36:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD6B20739;
        Thu, 29 Oct 2020 23:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604014597;
        bh=tiQsCPtLsqO5ooF7IiNDNyjbGaPP8KTeVd+mnveyGcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kF1I5s4G4GwjeViHSetaQE7rxjmrJKdWT1rryocgiIzFtcjNviVVxZM5NWZZNnZIG
         53i4oiQKZTYuqN0OZCri/BKAmgSnlY9p/ObT9PkPogTZwo2eURU2YkdBsq3xqwQNku
         dlqjYN4+Eny9hd1IVqNcebSpxfunzxaqLfu+e9Wo=
Date:   Thu, 29 Oct 2020 19:36:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jian Cai <jiancai@google.com>, "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
Message-ID: <20201029233635.GF87646@sasha-vm>
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com>
 <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 11:05:01AM -0700, Nick Desaulniers wrote:
>On Thu, Oct 29, 2020 at 4:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Mon, Oct 26, 2020 at 06:17:00PM -0700, Jian Cai wrote:
>> > Hello,
>> >
>> > I am working on assembling kernel 5.4 with LLVM's integrated assembler on
>> > ChromeOS, and the following patch is required to make it work. Would you
>> > please consider backporting it to 5.4?
>> >
>> >
>> > commit 44623b2818f4a442726639572f44fd9b6d0ef68c
>> > Author: Arnd Bergmann <arnd@arndb.de>
>> > Date:   Wed May 27 16:17:40 2020 +0200
>> >
>> >     crypto: x86/crc32c - fix building with clang ias
>> >
>> > Link:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=44623b2818f4a442726639572f44fd9b6d0ef68c
>> >
>>
>> It does not apply cleanly, can you please provide a properly backported
>> and tested version?
>
>Hi Jian,
>Thanks for proactively identifying and requesting a backport of
>44623b2818.  We'll need it for Android as well soon.
>
>One thing I do when requesting backports from stable is I checkout the
>branch of the stable tree and see if the patch cherry picks cleanly.

btw, an easy way to get an idea of possible dependencies is to look at
the dependency repo :) For this commit on 5.4:

https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v5.4/44623b2818f4a442726639572f44fd9b6d0ef68c

-- 
Thanks,
Sasha
