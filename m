Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31D344B234
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 18:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbhKIRyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 12:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbhKIRyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 12:54:21 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53941C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 09:51:35 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id be32so31842oib.11
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 09:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbH/j7Zs+KKUZIh6/EIHYpOhvYavkv0KBf6ZqH7w8wo=;
        b=nV06dYHYG2V/+k89FCyMdaz2pFZM8n2VALpJFg0pqPyNxY7YovqwFJMWbIzD58EOX0
         8VItk28OhtoWxhrYQjcmWuem0zVPMLK4pGxR/AdqJPa3AsxMub0WhsxJ74kjLA7UKJ3x
         GGgXg9w65el1/16GHTKHeIca3e6PrG+acKKBkYUkgeprHM+WEkCRagTK8NQ3gm+rrT6h
         y+fIBkPCwpXiXwsH6p3EpG4sziKBhqmKWjTGUESk99XOnNiY/o+yUv5f2tZcLbkPhirK
         D8LmrBUR5Mdvm9xo07PKxaDNX1fSvBlKuQ/lAbQ2H3LMx/MSmT7Gn3n3v30fUu3Bhm6y
         2B5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbH/j7Zs+KKUZIh6/EIHYpOhvYavkv0KBf6ZqH7w8wo=;
        b=N+TU06PrUAFmDTPFyke0Z37CuVe2IPIYW29mmPSDEsEFYGXK91DF5hlsZGwg3kd2nL
         Dk/buTjeF4ZAeFbQdqsIHrqVdFkYDs+4XBQXta1FnR4CGe7ot5g8V6VXFO3inEuaSu72
         AcXXqpvYTdT8bP/D5gwsUjeylKhyBIPZSY8KAvHarPYeqh2795JbIiF18N2OPo483rFB
         CcCK3tUHnAHSy9CJ/YKZ5XZjFA3s6bHCL9YDbxacmGdvrNL9LGkTtHKV6DD0mDYQA5Gz
         YYJPPPV3Lmdjcq7DODv3wjn3qvT7y3XoADPfB3/J9ecVTSFUMiyFxPpZOrqVkfZCEzng
         5ayA==
X-Gm-Message-State: AOAM533Lct7xumqLurB8dVWPuOsaVeZGqp7KQZR0+aa2OHAkmE2nmjmP
        cGk212pO0Gi3NhSQo9o4MPV60LvPrThrBeh9GEoT4Q==
X-Google-Smtp-Source: ABdhPJym0mnlo1uXcHZ+VO65UWm/SqlOxjKNnP2dXbi+4oWS8zENJt8dhae8rIHoEi3bShRzUpP8D74h/+gBueaW1u4=
X-Received: by 2002:a05:6808:179d:: with SMTP id bg29mr7124704oib.138.1636480294465;
 Tue, 09 Nov 2021 09:51:34 -0800 (PST)
MIME-Version: 1.0
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com>
 <YYQsw+GBLr1WXidM@kroah.com> <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
 <YYjZIxabCA95Lvbw@kroah.com> <CA+DW03X8mAPq7-z6ts0zYqvPeOZpFyqVyC8pEyaAyUdPfcGorQ@mail.gmail.com>
 <YYoU19O/NNb9uZ5x@kroah.com> <YYqTt27ZGutMJyZc@alley>
In-Reply-To: <YYqTt27ZGutMJyZc@alley>
From:   Yi Fan <yfa@google.com>
Date:   Tue, 9 Nov 2021 09:51:23 -0800
Message-ID: <CA+DW03WhrHH-DZHyiqe0CfC3274amySqiSydNDs-_V5w9HQpwA@mail.gmail.com>
Subject: Re: null console related kerne performance issue
To:     Petr Mladek <pmladek@suse.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks a lot, Petr and Greg.

I saw the patches and just started to prepare the test on devices
using the 4.14.y tree. will update the test result later.

@Greg Kroah-Hartman Sorry for not providing the details in the public
thread. I can sync w/ you offline.

Thanks,
Yi Fan

On Tue, Nov 9, 2021 at 7:28 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Tue 2021-11-09 07:27:35, Greg KH wrote:
> > On Mon, Nov 08, 2021 at 11:17:07AM -0800, Yi Fan wrote:
> > > On Mon, Nov 8, 2021 at 12:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Nov 04, 2021 at 12:40:32PM -0700, Yi Fan wrote:
> > > > > Reply inline.
> > > > >
> > > > > On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > > > > > > Resend the email using plain text.
> > > > > > >
> > > > > > > I found some kernel performance regression issues that might be
> > > > > > > related w/ 4.14.y LTS commit.
> > > > > > >
> > > > > > > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> > > > > > >
> > > > > > > The issue is observed when "console=" is used as a kernel parameter to
> > > > > > > disable the kernel console.
>
> I think that I see the problem. linux-4.14.y stable branch currently
> ignores "console=" parameter. As a result, a console (ttyX) is enabled
> by default.
>
> > > > > > What exact "performance issue" are you seeing?
> > > > > >
> > > > > [YF] one kernel thread was randomly blocked for more than ~40
> > > > > milliseconds, causing a certain task to fail to process in time.
> > > > > [YF] the issue is highly random on a single device. But it might
> > > > > happen a few times per 24 hours on a certain percentage of devices.
> > > > > The overall percentage of devices that show the issue seems quite
> > > > > stable over a long period of time (somehow the magic number is ~40%.).
> > > > > [YF] local test on a pool of devices does not show any correlation w/
> > > > > any particular devices.
>
> This might happen when there is a flood of messages to be printed to
> the console. It does not happen when there is no console.
>
> It has been fixed by the upstream commit 3cffa06aeef7ece30f6b5ac0
> ("printk/console: Allow to disable console output by using  console=""
> or console=null")
>
> The fix needs some tweaking for the stable branches because
> __add_preferred_console() has gained more parameters over time.
>
> It seems that all longterm stable branches are affected. I am going
> to prepare the backports.
>
> Best Regards,
> Petr
