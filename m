Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF72DCFF3
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437917AbfJRUXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 16:23:41 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32935 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440308AbfJRUXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 16:23:31 -0400
Received: by mail-io1-f65.google.com with SMTP id z19so8996597ior.0
        for <stable@vger.kernel.org>; Fri, 18 Oct 2019 13:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=71+3x9bQCrseYT46kjzG9xxXfo7pyJvO5naguWDqCi8=;
        b=SthYM5HNGYBp/w+7NO4joeMxObBaZARAka0m0htzUNZgoJJy0C7DNkBgF2N98vlCro
         3mEhyZz6WJvlTYXES748pAypVeERT9nLhQop+5CKH9gAKgIt8+I0g33HYrXgpbFvcl9N
         zKWh7stvOETlzn+v7qmbNqd/UVo6m7EZHiXps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=71+3x9bQCrseYT46kjzG9xxXfo7pyJvO5naguWDqCi8=;
        b=o/HADlZYC+fk6DZM9bUT01hm2cMAbcos6mRa+esOzRYsrI5lgK9ibiL7Ixbfz0RoA8
         ROryYeNjDryAj3aPPL6fMTJNftFVHGqAHgpHfxF77dx6+KmuF9nKOhss/ml3tn4K6Vfw
         SEeLQgIUwKwf946dk5WTRMn12dAC4SWKI88k2oh5GTcBIMP6sEJFYYcbthlL1QFgwT0p
         X7kB6wB/wFZ/33z9AtQX6zrZtS3ryU9+IwmfM103IQwPDH0WCahjM2IyGxIyWlO/HwHK
         RKNQ4ZgAmvvb6GFPJYtYqqYBep8C9h0hZgBoLLnKajvGsbuFe3d9keXt5ow0k64AIKt8
         t3BQ==
X-Gm-Message-State: APjAAAX2goZQeyHHnfWn55KDQS+RSOIiL2GX3ClXZdCDi91e5d/L1k7G
        gga78kHrgCxYCH9nrFcWu0RkBUt3w0FUyy/7Ku/Iog==
X-Google-Smtp-Source: APXvYqwx47zsLQqEX/Gvrudz4A/RYJW2eI6WVN5YIR3waMzDd3cCuvvaVrFRMYyd5URs5c0cdLVZBjQN17rEYXLTCYA=
X-Received: by 2002:a02:ba0d:: with SMTP id z13mr11043674jan.75.1571430208053;
 Fri, 18 Oct 2019 13:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com> <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
 <20190927131332.GO8171@sasha-vm> <CAC=E7cVyO=j8FKBKkdOU2KOM_O=3XmXZd0OoyYCDWez_twuk-A@mail.gmail.com>
 <20191003065135.GA1813585@kroah.com>
In-Reply-To: <20191003065135.GA1813585@kroah.com>
From:   Dave Chiluk <chiluk+linux@indeed.com>
Date:   Fri, 18 Oct 2019 15:23:02 -0500
Message-ID: <CAC=E7cWYpdA1Ufds6OoAu+5eP+kTXY1OzZ8O7nLYrfb_tCBEZg@mail.gmail.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with
 high throttling by removing expiration of cpu-local slices
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

@Ben @Ingo @Peter
Can you please please ack this backport request?

Thank you,
Dave Chiluk

On Thu, Oct 3, 2019 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Oct 03, 2019 at 12:15:02AM -0500, Dave Chiluk wrote:
> > @Greg KH, Qian Cai's compiler warning fix has now been integrated into
> > Linus' tree as commit: 763a9ec06c409
> >
> > Both de53fd7aedb1 and 763a9ec06c40 are now apart of v5.4-rc1.  Can you
> > please queue up these fixes for backport to all stable kernels.
>
> I need an ack from the scheduler maintainers that this is ok to do so...
>
> thanks,
>
> greg k-h
