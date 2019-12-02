Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C510ED42
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfLBQgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:36:43 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33400 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbfLBQgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 11:36:43 -0500
Received: by mail-qk1-f195.google.com with SMTP id c124so151803qkg.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 08:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFUIXTaxHxhBf92NWy9ixW4qKlXFsdRPI/ziEawghmo=;
        b=zYz7ylXEeDcPZteFmTUBUONfDyk9NWNLdI4gcq+meztW7nWtopkAe257F4Fvvb5IbD
         wDKT7SyInwk4vDTQS0+v3hQx426cTB4cirN2n3TpPleaJWxhY+7SQwyJtFff77lJlb7n
         vlrQcrpxXW6r5RSDWs8TRRW3BURORhNwS9lZojfyqjgnGEjD7g8hOSU6DvXDojgCzcay
         WUTU20O4DCcTueeK6rSBMBcb5pFtMy7WYQetSmDcOCbpsEFBrRi2wlEuYVi69BK0zIM1
         dypK+eg/+gXn4W1vfXTWdb6PC8xa5HUVyFYpiYYLYcUON9n1c7V8fBiFtxwsG7e3dtrD
         kHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFUIXTaxHxhBf92NWy9ixW4qKlXFsdRPI/ziEawghmo=;
        b=XWz1hFd++4uKJTTBrHqnXKqcE0gguhMUi7VIjpsNqt8jla+SBGvrTmXLMCz2DheHRG
         U7D3jfr3/p2cOTKsHLuL48+N/YOMhxQrJWwwwGLtTy5uxDBzrYfA3nT5HvUfcmk9QadT
         eSA8guw8Xd1umKlD8BKCGzly8O7mvPJGjVUVyZ7ChG9sTpy8hqrsEnejSWT/2bcmJFL7
         7jEQ/g3MECB0MdPOwB+I1tnpz691+yKCkXYqXuDQTWTvc10KIDsjSPSXhhb5JvauWXDX
         ROjUGJ9X0nNTjGZzXyWIsNuqjMKY/y+MqnZbiD9K2+LMZsJ9OHyhIlPk8u3ObPTTEbqS
         h43Q==
X-Gm-Message-State: APjAAAVc8ZMAgIwa/Ml6JWixG7J7o0gztBdu59pBTHiSQ6RFSj9z4ko8
        JsGeaBEWgWRbD4thUJU+/stbWB/aufkCf9cwR30Myg==
X-Google-Smtp-Source: APXvYqxs29/a51bRsGJMtEpepGA3LsMtTGV56DyzsQxbaavrE8HpSDRUwcCJOe81Ejh4MXikosqfRt3QTzZjJYPQQso=
X-Received: by 2002:a37:6e86:: with SMTP id j128mr34628727qkc.265.1575304600825;
 Mon, 02 Dec 2019 08:36:40 -0800 (PST)
MIME-Version: 1.0
References: <20191201094246.GA3799322@kroah.com> <20191201193649.GA9163@debian>
 <20191202075848.GA3892895@kroah.com> <CAG=yYwn3nYn2CmV7BWOJdBWicYPuK2DwBgz6p=bDC9nWOt6vqA@mail.gmail.com>
 <20191202133649.GA276195@kroah.com>
In-Reply-To: <20191202133649.GA276195@kroah.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Mon, 2 Dec 2019 22:06:04 +0530
Message-ID: <CAG=yYw=hwnEXyfFjxTTNkS0yVdRZAfLEoyrh=fCVp6DsuWr27w@mail.gmail.com>
Subject: Re: Linux 5.4.1
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 2, 2019 at 7:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 02, 2019 at 06:32:30PM +0530, Jeffrin Thalakkottoor wrote:
> > On Mon, Dec 2, 2019 at 1:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > You tested the performance of what?
> > i tested the performance of  5.4.0 and 5.4.1
>
> By running what specific test(s)?

i  compiled  the following  5.4.0,  5.4.1, 5.3.11,
kselftest-5.4.0-rc1, linux kernel sources, three at a time, together.
when running together i did not start the sources at the exact same
time. may be atleast one second gap.

-- 
software engineer
rajagiri school of engineering and technology
