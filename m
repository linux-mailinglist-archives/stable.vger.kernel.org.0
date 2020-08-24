Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506CB2506F0
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgHXRxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHXRxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 13:53:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C99C061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 10:53:04 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i10so4920097pgk.1
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 10:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bp8FFja/OEjE8fqcU1aTntWbHLvKHP3wmYT4R3MpC8I=;
        b=AO3Doz/dCJUb25/wJC5UMu+21TLk29lc/sewUsMRWSA4Tw4DcfidFuHFDoQ2DRPCG9
         jflgTcllFSaU6DRciDdw1myKBLOz49TkbW83pTRbRggjHK0NZRGeVh3ooN7H0XuPcd1z
         XrmpNBM12SuObXYqsyv3NLb9uA7imEI+nPYRld1iyFMI9tDFNZT+RdsTpXGGes3OCEJb
         rcuB6WGPKJNIb3huusFZdFus5woE5zniP99/xngX26VQ/rw0GpBfuTcCjCLwpOyaCAxr
         tAcdmaN3HLRjMvcSd2YJkMCZG187e6u5g/Flq8FSD/PGRXVhJ5bRS66maG+HqgDaoXl2
         6Wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bp8FFja/OEjE8fqcU1aTntWbHLvKHP3wmYT4R3MpC8I=;
        b=ulwHJ35ZO+C6BANrIXibHpfrWHSt6hfaEbDZUMctmQbHSlH+9t5V9f0DFbW6BUNnN+
         uuepQvgcwpCuG+pbE7OwSY+m00ZuJQ/w1UPZJWr5FVMvpIASHWdv9kbrTc27cqKDy9r/
         DBZZgiBONZbBuLYFO1gqWrQoFyElz805aM29I27eExYVeb+hBv0tjRoebMEjfj6T/KpF
         n34CjN9IR1LFviv3pMBn/30iyseDT/9Ce9ENR9qB4s5AJbm5viHRefBIsI9piMXb3KGQ
         lh2OAm7j/DYrYlEIcALUBdm7Z8SktxG1noRN0C/X0zZchv6F8JIJCRiG0Tvte4yVV9vC
         JvFQ==
X-Gm-Message-State: AOAM533lyFoVae6dZj0kHGlYxCLG9NAP8b+wbNiJJegctL3oMmThNtfT
        PPXubw+9LkH51UYq+pW88p6fcWLq4rrAZctIQuKSVA==
X-Google-Smtp-Source: ABdhPJyRHW6aAkIzOSpe9xJMCTpL1lp70v/ECRJnC6PuDP4xrYsxjSCGAtm7ghhWolg+LLCdRK7lfJAAAIXnf6w2tmQ=
X-Received: by 2002:a62:ddd1:: with SMTP id w200mr3335633pff.13.1598291582788;
 Mon, 24 Aug 2020 10:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200727175720.4022402-2-willmcvicker@google.com>
 <20200727190731.4035744-1-willmcvicker@google.com> <20200727190731.4035744-2-willmcvicker@google.com>
 <20200820082357.GI4049659@kroah.com>
In-Reply-To: <20200820082357.GI4049659@kroah.com>
From:   William Mcvicker <willmcvicker@google.com>
Date:   Mon, 24 Aug 2020 10:52:47 -0700
Message-ID: <CABYd82Z_jpwEkcvJ7ajh9h5-_UewJ-794wA5z0TTSKZ253iYXA@mail.gmail.com>
Subject: Re: [PATCH 0/1] Netfilter OOB memory access security patch
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I have a follow up fix for this patch that is a lot cleaner and will
hopefully apply cleanly to all the LTS branches. Let me upload the new
patch and get the final ACK from the netfilter devs.

Thanks,
Will

On Thu, Aug 20, 2020 at 1:23 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 27, 2020 at 07:07:30PM +0000, Will McVicker wrote:
> > Hi,
> > The attached patch fixes an OOB memory access security bug. The bug is
> > already fixed in the upstream kernel due to the vulnerable code being
> > refactored in commit fe2d0020994c ("netfilter: nat: remove
> > l4proto->in_range") and commit d6c4c8ffb5e5 ("netfilter: nat: remove
> > l3proto struct"), but the 4.19 and below LTS branches remain vulnerable.
> > I have verifed the OOB kernel panic is fixed with this patch on both the
> > 4.19 and 4.14 kernels using the approariate hardware.
> >
> > Please review the fix and apply to branches 4.19.y, 4.14.y, 4.9.y and
> > 4.4.y.
>
> This patch only applied to the 4.19.y tree, it failed to apply to all of
> the other branches:
>
> Applying patch netfilter-nat-add-range-checks-for-access-to-nf_nat_lprotos.patch
> patching file net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> patching file net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> patching file net/netfilter/nf_nat_core.c
> Hunk #1 succeeded at 45 (offset -19 lines).
> Hunk #2 succeeded at 298 with fuzz 1 (offset -23 lines).
> Hunk #3 succeeded at 309 (offset -23 lines).
> Hunk #4 succeeded at 376 (offset -24 lines).
> Hunk #5 succeeded at 399 (offset -24 lines).
> Hunk #6 succeeded at 419 (offset -24 lines).
> Hunk #7 FAILED at 526.
> Hunk #8 succeeded at 733 (offset -100 lines).
> 1 out of 8 hunks FAILED -- rejects in file net/netfilter/nf_nat_core.c
> patching file net/netfilter/nf_nat_helper.c
>
> And you didn't cc: the netfilter developers for this, are they ok with
> this?  I need an ack from them to be able to take this.
>
> Can you fix this up, resend working versions for all branches, and get
> their acks?
>
> thanks,
>
> greg k-h
