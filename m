Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA92449C46
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhKHTUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 14:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbhKHTUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 14:20:05 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97236C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 11:17:20 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id q33-20020a056830442100b0055abeab1e9aso27180779otv.7
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 11:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6QHiyCaiCaOPCgr4bdUzuAvKXDLBLC/73jS9nRfOPc=;
        b=SI8iQ69SdTYshHtGY/CHYeu+dZXdp9jxTlnqKYMqjN6hZd2GOHyFNmSK608tz3a63S
         WcuBlERZX557d9Rvs75IcF6mJYXOSGIMEiPCnL1FblEI6D0IKaNXs9p76Li2Pi3eaSKk
         DRsaidj8Yrt5TLg2lSJwmTtwsxEeHNeUgSZjrEsTO8FaN+d9Om2N7Kl4eB1W0vQEiQU5
         jrUN5ProW0RmZgJW+I0St6yYJ/XlQZyfCZQuGwmVVpPTRq21j2J1tCl2rHu0Bkp1FHR3
         +iQTxnfMoPUvBfT6tGVubphmt0iu8IRkyRO+7bFcnQ2XzFVh5EYh12LqHz0Y/d0kHXrr
         jdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6QHiyCaiCaOPCgr4bdUzuAvKXDLBLC/73jS9nRfOPc=;
        b=3V52mu0w2pAYkv12/eahUsiwQ/rF1ExKReCboEaqoOCZGJx5TNJ/iQqXRxUN33A40f
         sI3sIJCv1pzlqIAfSzHGinaED6twwMvD80BX957xbTO/6Q4L3Y2UXfFtUxWn0NcbZOMm
         Lit1AXDmlUL/Vdms14I3dl3z4DJgsOMb/FAZ43RDpxlM3T8FYJ+AbJ7GyTN0btlF3ZZh
         7ODf6XpmkwFRIym1Bkmbw/jt+rV/RZE3V7J51k4IHpMIghgW9rEhL/CmD2A6ta71GkCh
         zvRgIMVjE3OekvWqRf6WK9fhNBQzY3pagihg0CsT5rXxrb0fXrxedpn3q6LBrLfW+P28
         P1fA==
X-Gm-Message-State: AOAM531buJpvXMxRAHtoxFfgiysAVac3xdw6+FDVZbob4sUQkLQVBNMi
        cH7U1cGm3qIKqN8zEV5SyOaJMnDBH+bfYSDUh2fxy2drB/k=
X-Google-Smtp-Source: ABdhPJyLh9VBon0h5igq000sVDAV7X4Be/cKh5b1/CZ5vaEcDdKi837yytq0M/mTct8m17lijb2FowtT4YKI9nG4FaY=
X-Received: by 2002:a05:6830:2431:: with SMTP id k17mr1149203ots.220.1636399039735;
 Mon, 08 Nov 2021 11:17:19 -0800 (PST)
MIME-Version: 1.0
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
 <YYQsw+GBLr1WXidM@kroah.com> <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
 <YYjZIxabCA95Lvbw@kroah.com>
In-Reply-To: <YYjZIxabCA95Lvbw@kroah.com>
From:   Yi Fan <yfa@google.com>
Date:   Mon, 8 Nov 2021 11:17:07 -0800
Message-ID: <CA+DW03X8mAPq7-z6ts0zYqvPeOZpFyqVyC8pEyaAyUdPfcGorQ@mail.gmail.com>
Subject: Re: null console related kerne performance issue
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        pmladek@suse.com, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 8, 2021 at 12:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 04, 2021 at 12:40:32PM -0700, Yi Fan wrote:
> > Reply inline.
> >
> > On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > > > Resend the email using plain text.
> > > >
> > > > I found some kernel performance regression issues that might be
> > > > related w/ 4.14.y LTS commit.
> > > >
> > > > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> > > >
> > > > The issue is observed when "console=" is used as a kernel parameter to
> > > > disable the kernel console.
> > >
> > > What exact "performance issue" are you seeing?
> > >
> > [YF] one kernel thread was randomly blocked for more than ~40
> > milliseconds, causing a certain task to fail to process in time.
> > [YF] the issue is highly random on a single device. But it might
> > happen a few times per 24 hours on a certain percentage of devices.
> > The overall percentage of devices that show the issue seems quite
> > stable over a long period of time (somehow the magic number is ~40%.).
> > [YF] local test on a pool of devices does not show any correlation w/
> > any particular devices.
> > [YF] local test after reverting the above single commit passes, no
> > issue is observed.
>
> And what type of device is this?
[YF] it happens on multiple devices on the 4.14.y kernel. (sorry
cannot disclose the device type here.)

>
> If you see this thread:
>         https://lore.kernel.org/r/f19c18fd-20b3-b694-5448-7d899966a868@roeck-us.net
> it looks like chromeos devices have now disabled this change, and there
> was a long discussion about possible issues and solutions.
>
> Can you try the patch set referenced in that thread to see if that
> resolves the issue for you or not?  Given that I have not seen any
> reports of this being an issue since over a year ago, odds are it has
> been resolved already with some change that we probably also need to
> backport to 4.14.y.
>
> So any help in identifying that change would be appreciated.
>

[YF] thanks for the context. I did not find a clear patch that seems
to solve this issue yet.
[YF] for the time being, reverting the offending commit seems the
safest solution for the 4.14.y.

> > > And what kernel version are you seeing it on?
> > >
> > [YF] it was first found on some products w/ kernel version 4.14.210.
> > through bisection, we located the commit on 4.14.200.
> >
> > > > I browsed android common kernel logs and the upstream stable kernel
> > > > tree, found some related changes.
> > > >
> > > > printk: handle blank console arguments passed in. (link:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0)
> > > > Revert "init/console: Use ttynull as a fallback when there is no
> > > > console" (link:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=a91bd6223ecd46addc71ee6fcd432206d39365d2)
> > > >
> > > > It looks like upstream also noticed the regression introduced by the
> > > > commit, and the workaround is to use "ttynull" to handle "console="
> > > > case. But the "ttynull" was reverted due to some other reasons
> > > > mentioned in the commit message.
> > > >
> > > > Any insight or recommendation will be appreciated.
> > >
> > > What problem exactly are you now seeing?  And does it also happen on
> > > 5.15?
> > >
> > [YF] we do not perform any tests on 5.15 yet. so no idea about whether
> > the issue happens on 5.15.
>
> How about any other newer stable kernel version like 5.4.y or 5.10.y?
>

[YF] so far there is no easy way to replicate the issue. We have
future products that are on 5.4.y and 5.10.y. I will keep monitoring
whether similar issues are found.

> thanks,
>
> greg k-h
