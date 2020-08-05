Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4723D13F
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHET6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbgHET6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 15:58:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C36F2076E;
        Wed,  5 Aug 2020 19:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596657495;
        bh=Mb0FZRim8GhTCnbX7/4RSKFXT3391ibre0UsZHmRjmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=blZrHICk1dFHosNJNqpICzlSs1XXznZcq4EX121MIuFY/ReycObvhk7qD9bbUwNP5
         GPo570l4o2Vg+6zrcBTOK8QGPVs7gK6MmEk2m4sEbwvz7melhsgdpJHsyc8sqN5XgL
         b6pSzxvHqea7MyVhFLUsJLtSlbNzL/cG9PEnaIcI=
Date:   Wed, 5 Aug 2020 21:58:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
Message-ID: <20200805195831.GA2453841@kroah.com>
References: <20200805153506.978105994@linuxfoundation.org>
 <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
 <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
 <7e1c9df5-d334-461d-56fc-53625c6ca163@roeck-us.net>
 <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 12:45:25PM -0700, Linus Torvalds wrote:
> On Wed, Aug 5, 2020 at 12:24 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 8/5/20 11:37 AM, Linus Torvalds wrote:
> > >
> > > Because the trivial fix would be something like the appended, which is
> > > the right thing to do anyway.
> >
> > Correct.
> 
> I'll take that as an Ack, and also remove the crazy reverse include
> from archrandom.h that most definitely shouldn't be there.
> 
> It's now commit 585524081ecd ("random: random.h should include
> archrandom.h, not the other way around") in my tree, because a grep
> for "archrandom.h" shows that now the only place it exists is
> <linux/random.h> and a few files that cannot possibly affect arm64
> (because they are on x86 and powerpc, neither of which has that insane
> reverse include).

Thanks, I've queued this up for 5.7.y now.  Doesn't look relevant for
older kernels, but I haven't gotten reports of them not building just
yet :)

thanks,

greg k-h
