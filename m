Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B401519B4A2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgDARZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 13:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727661AbgDARZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 13:25:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D97320714;
        Wed,  1 Apr 2020 17:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585761911;
        bh=M61UwKYGOJS+Q8aadIC4fJ14XpZ5PrjuyG5oVlO6NiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W0AGl7Vu5hf7B0BitZ6vnf1Fqu7Lgf087/qYESxMn8/NEd4WVg0Ys8eOfAhcSBJ5K
         vjyDW2ovw2AauP/bW2ja9ylp8XNgOZgHMDSWakNskIjloR91qzHyM4UWIG/B/10doZ
         YIKrCi97Hw1QNw1tKdl9nz+/jsXDqJrUhnHnFAy0=
Date:   Wed, 1 Apr 2020 19:22:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/10] 5.6.2-rc1 review
Message-ID: <20200401172242.GA2582092@kroah.com>
References: <20200401161413.974936041@linuxfoundation.org>
 <CAHk-=wiVBvO1b5UzfcHm6y4KLHOp3huFfGMdW21F6g25oUePLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiVBvO1b5UzfcHm6y4KLHOp3huFfGMdW21F6g25oUePLw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 10:06:47AM -0700, Linus Torvalds wrote:
> On Wed, Apr 1, 2020 at 9:19 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.2 release.
> 
> Good. You made 5.6.1 so quickly that I didn't have time to react and
> say that it makes little sense without the 802.11 fix, but you're
> obviously making 5.6.2 quickly, so..

Yeah, 5.6.1 had to go out fast, sorry I missed this patch.  Luckily it
seems that every distro vendor heard about it (or asked me about it)
already, and have included it in their trees so the majority of users
shouldn't hit this just yet.

And, if this passes Guenter's test builds quickly (hint), I can push it
out quickly as well :)

thanks,

greg k-h
