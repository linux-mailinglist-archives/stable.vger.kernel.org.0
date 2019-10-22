Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE79E06DF
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbfJVO40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 10:56:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40560 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfJVO4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 10:56:25 -0400
Received: by mail-io1-f67.google.com with SMTP id p6so12563108iod.7
        for <stable@vger.kernel.org>; Tue, 22 Oct 2019 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mo1jRgqQNtNiFnR8qHLht5Ol/Ukf8JeeMF7OaNNt3S0=;
        b=friXTMvvvHaY8OTWg+4l6A8aaPfq2HDvJ6tQYlapf8yisWn35v3IOryeBpetQh725i
         CNWQxXNM2ICTydX4R4nEeYndNWNvmyMpJ+RNEXotpQfOdN4n2UbB+MxDoIdaYI1nX3A+
         Q45wIrFDFIazfoPJx6FX+zbfnvT4rYi0rCYMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mo1jRgqQNtNiFnR8qHLht5Ol/Ukf8JeeMF7OaNNt3S0=;
        b=skP6QJTxU1A8MvE/HXgM7Ar8Z+bCRVVl/Kj3O9cO98iH8dH4b4b0tpnN6M2+axo9kj
         rkPoOuy3+9lS02ivL+u5GAMalJSM4mPoW5zrl8aAYlWTQWVArGIhJo8fYZIAompyhiH9
         7nZoaQRIcFrfmYarIG2l12tuA/dphuUJkIuuBHNocBJjlAqaeUmqEU6Xf/kD8ydR5G4c
         mvLrBCUrzuC87SU8g00KverLl8XwCEGb+YAO4UpaHFSCGT/YerNLcnG+iud1myvH5fZS
         v/cq/C9/w/piFcyHUCKxw+NI1Bxc8L4bo3Tuh7hwxehZiJNqCxmZHKvnGo5OKialFf0n
         HOTg==
X-Gm-Message-State: APjAAAU0kus8c5epie4NLbD1OTTqjxgof0BExZIC06+Fs7RVzdOeBmLh
        qu4t9oEW+V9t/Al+5T+yoZJdF5rJds/nTua8Ws0nHA==
X-Google-Smtp-Source: APXvYqzMDy1ujI22/TV/7UFrFdMfU2V5+7IpL/320RDcpnHSAAJmAnlFgR57DFHdsCKI0Z+eFQLWratztxpS2TEYiV4=
X-Received: by 2002:a6b:c8cf:: with SMTP id y198mr3794913iof.213.1571756184283;
 Tue, 22 Oct 2019 07:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com> <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm> <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
 <20191003065135.GA1813585@kroah.com> <CAC=E7cWYpdA1Ufds6OoAu+5eP+kTXY1OzZ8O7nLYrfb_tCBEZg@mail.gmail.com>
 <20191018205326.GB1817@hirez.programming.kicks-ass.net>
In-Reply-To: <20191018205326.GB1817@hirez.programming.kicks-ass.net>
From:   Dave Chiluk <chiluk+linux@indeed.com>
Date:   Tue, 22 Oct 2019 09:55:58 -0500
Message-ID: <CAC=E7cV2DzpLOz_RaFzBKCN3cEntB7BPLGL9PaGZ2LYb6dc0Jw@mail.gmail.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with
 high throttling by removing expiration of cpu-local slices
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 3:53 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Oct 18, 2019 at 03:23:02PM -0500, Dave Chiluk wrote:
> > @Ben @Ingo @Peter
> > Can you please please ack this backport request?
> >
> > Thank you,
> > Dave Chiluk
> >
> > On Thu, Oct 3, 2019 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Oct 03, 2019 at 12:15:02AM -0500, Dave Chiluk wrote:
> > > > @Greg KH, Qian Cai's compiler warning fix has now been integrated into
> > > > Linus' tree as commit: 763a9ec06c409
> > > >
> > > > Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
> > > > please queue up these fixes for backport to all stable kernels.
> > >
> > > I need an ack from the scheduler maintainers that this is ok to do so...
>
> Sure I suppose, but what makes this commit special? Don't you normally
> take just about anything?

I think this is more a matter of me being a relatively unknown in the
scheduler space, and Greg is just being responsible as this looks like
a pretty scary fix.

In reality, I probably should have just added "Cc:
stable@vger.kernel.org" to the sign-off area of the initial commit and
this conversation wouldn't have been necessary.
