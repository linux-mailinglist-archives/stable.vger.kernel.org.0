Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE0275FA3
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIWSTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgIWSTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 14:19:38 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37938C0613D1
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 11:19:38 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id b22so888749lfs.13
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 11:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKzL90mPBVyB4BFuLjfA3vDiSe9w+bx4riMJ/2lUYsI=;
        b=SaS3fMQ4TAJGIV2uK+VYGwCnc06kLKp5cMIqKfSOXB/uM7x1omUGq53QTex0mvH2C6
         SilqOUVmahXKC+gO2rkwizwFsmYaX6aN2AKtwHlRfJvr8PahTFw9AytRPIM5cEQld1pA
         RN+Qj1FNG/topCYovowX1nCso+SP7J+0/DQBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKzL90mPBVyB4BFuLjfA3vDiSe9w+bx4riMJ/2lUYsI=;
        b=Y/tlaOEzhHIqJThC5O6oTBrsEH9Sru6ecATa0luiWi4K09LA1pnIu4GuN4xW+sim/T
         pk5j27I+iqW6bopG1+aESrlCzkRx1ikOPPGHayDPyxv5HWUO1O2P6qfUID4/s9tB1pqo
         nA3xxFjlYW3xwxnTPpV5C/jtJsL+YTa1CA/hfcm0jz7aZHDgTjv4xTGPGbz8pXfPYd/j
         zS7wDaCUCjZXc+HKJAGxa03+IvK6KeAHWZ8CPSXa/fAkoi9Fp3YfPWUJBKswLbh0ewel
         W2SAgX9KMxaJS+mnB82uZAePAOyE/UVmFweoVmR3g0FJZSDuZ0qw4tXAPWntfNYmLX4r
         H/Hw==
X-Gm-Message-State: AOAM530bt1dFiem3/bhBx2mh0QnALR2aIJ+p8bv2oNznqjK36QasW4FX
        x0V7O1hISUCQgNhsJELA1RP2TSeF14g4IA==
X-Google-Smtp-Source: ABdhPJz4ar5sFGHXy7DWu4OucC6txk6SAFoB4uDxwYoBnlromKtrhrulHXcsJ1dd3ALcFrgJ+0XhYA==
X-Received: by 2002:a19:4084:: with SMTP id n126mr334934lfa.54.1600885176091;
        Wed, 23 Sep 2020 11:19:36 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id f24sm5544945lja.104.2020.09.23.11.19.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 11:19:32 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id c2so417501ljj.12
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 11:19:31 -0700 (PDT)
X-Received: by 2002:a05:651c:32e:: with SMTP id b14mr345723ljp.314.1600885171360;
 Wed, 23 Sep 2020 11:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200915140633.552502750@linuxfoundation.org> <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz> <20200916082510.GB509119@kroah.com>
 <20200916090723.GA4151@duo.ucw.cz> <20200916091420.GF13670@1wt.eu> <20200923084427.GA32110@amd>
In-Reply-To: <20200923084427.GA32110@amd>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Sep 2020 11:19:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whe4ZdTdCebneWqC4gSQZwsVJ5-Emg0BucOGCwPhOAJpw@mail.gmail.com>
Message-ID: <CAHk-=whe4ZdTdCebneWqC4gSQZwsVJ5-Emg0BucOGCwPhOAJpw@mail.gmail.com>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
To:     Pavel Machek <pavel@denx.de>
Cc:     Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jikos@suse.cz,
        vojtech@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Yuan Ming <yuanmingbuaa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 1:44 AM Pavel Machek <pavel@denx.de> wrote:
>
> >
> >   https://www.openwall.com/lists/oss-security/2020/09/15/2
>
> Thank you for the pointer!

Note that for me to be willing to take the softscollback code back, it
really would have to be more than just a revert and a trivial fix.

It would have to be more along the lines of "this is simplified and
verified". For example, at a minimum all the VT_RESIZE etc stuff would
have to clearly and obviously reset the soft-scrollback, so that we
simply can't have those kinds of issues.

If you look at that commit 50145474f6ef ("fbcon: remove soft
scrollback code") that removes the code, most of that code really
doesn't make much sense.

I dare anybody looking at that removed fbcon_redraw_softback()
function (or the different cases in fbcon_scrolldelta(), for that
matter) to claim they understand what it is doing. It's very odd code,
and it handles a lot of odd special cases.

So I wouldn't mind re-introducing the scrollback code, but the
reintroduced version needs to be simple and fairly _obvious_.  It
would need to not have all those odd special cases, and it would need
to clearly not have any subtle issues with things like font or screen
resizing.

I'd also suggest that it not even try to handle the multiple virtual
console case.

And yes, some of it may involve also clarifying the code in the VT
code itself, so that the interactions with the cursor and VT switching
is more obvious. Maybe instead of trying to deal with a SW cursor when
scrollback is active, just hide the cursor entirely before doing
scrollback. And make change_console (and all the resizing) explicitly
reset scrollback etc.

So the reason the code got removed was that it was just very grotty
and hasn't really been maintained for over a decade.

In order to resurrect it we'd not just have to have a maintainer, the
whole "it's grotty and incomprehensible and has these nasty
interactions with random other things" would need to be addressed too.

              Linus
