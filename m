Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F62AAD4C
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 20:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgKHT5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 14:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHT5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 14:57:09 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FACC0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 11:57:08 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id t13so7558063ljk.12
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 11:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bx6hgEtnYGonIQTh2WOk0OcFJqmTYPzg8n1mGDSx5yw=;
        b=XSroJpXI8ESbtND8txjocEdSeTnJF9EZKgjopod2UVjpMl1Z2k2kFOzSwPF1qlbkz1
         J6xM2jJGGvgDpPt4YjK8Rhf4/zbsXU8F0H1UTXFjkRzpFs+/Gywj1IlCUVtpVLlZx+Ip
         4ErDAfePA6tFXHB1E58HHbIxDlBhC6LbBPFQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bx6hgEtnYGonIQTh2WOk0OcFJqmTYPzg8n1mGDSx5yw=;
        b=qAtCMPuSe8IIHGpi6ThKVR/7Qzr3pQl5s0vpqCpkQwPVo/hBsUVWvSZa+CK6EUWk/y
         eVlaIQ2ZmLMl+yPse1dV5GnIlQxamVu1vw71YOgNls3r26TGHcnOoxvR8tbScZEIc5ZM
         TV6XWeLct0MmDf23g1wrBnxWeeygdvnedPm0LGMrna8yMyTzI69vcwknZFHZc+vlRpK1
         AijIcPI4frrMF7Ob0toSkS9IrPnp7KkBoJpmBpuKFwK2m6mLFA1nZIiiZIT53JPswCq2
         QtX9HN6X9TY2QiFePyt8jk46oS82NCP4jZRcmlbiwp+XB17Xcdq80cx4BDG0ymx7koRC
         RxOg==
X-Gm-Message-State: AOAM532dYhYXUkfWvpNW3BFjl0aCuaCX8KKj1wq0Y/vT//S3aIBkBkOv
        DOnUlR3z9DhkcxBQRTupSdvGvjmkcLiMbA==
X-Google-Smtp-Source: ABdhPJxjTn2jyfE7DDu00ZyXGqc2tNFOpvJcTBJHhYZ4rEBVVyIMyIDcazTsvmAzb1Q7u/5o+Su2Kw==
X-Received: by 2002:a05:651c:506:: with SMTP id o6mr4407395ljp.249.1604865425562;
        Sun, 08 Nov 2020 11:57:05 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id t20sm232759lff.153.2020.11.08.11.57.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 11:57:04 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id 74so9296153lfo.5
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 11:57:04 -0800 (PST)
X-Received: by 2002:ac2:52ad:: with SMTP id r13mr4067227lfm.534.1604865424332;
 Sun, 08 Nov 2020 11:57:04 -0800 (PST)
MIME-Version: 1.0
References: <20201107064722.GA139215@arch-e3.localdomain> <CAHk-=whjyOuO-xwov7UWidBOkWyZv84TVA18hBb01V-hiML+yg@mail.gmail.com>
In-Reply-To: <CAHk-=whjyOuO-xwov7UWidBOkWyZv84TVA18hBb01V-hiML+yg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Nov 2020 11:56:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
Message-ID: <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
Subject: Re: [PATCH] fork: fix copy_process(CLONE_PARENT) race with the
 exiting ->real_parent
To:     stable <stable@vger.kernel.org>
Cc:     Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

.. oh, and I suspect it should have been marked for stable.

I added Oleg's ack (implicit in an earlier thread), but didn't add a stable tag.

It's commit b4e00444cab4 ("fork: fix copy_process(CLONE_PARENT) race
with the exiting ->real_parent") in my tree.

I'm not sure how serious it is. Yeah, the race can cause the wrong
exit signal in theory, but I think you almost have to do it with
cooperating processes, at which point you could have just done it
intentionally in the first place.

But it does look like a real data race, and the fix looks small and
obvious enough that I think it's stable material.

Oleg?

             Linus

On Sun, Nov 8, 2020 at 11:19 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Nov 6, 2020 at 10:47 PM Eddy Wu <itseddy0402@gmail.com> wrote:
> >
> > current->group_leader->exit_signal may change during copy_process() if
> > current->real_parent exits, move the assignment inside tasklist_lock to avoid
> > the race.
>
> Applied. Thanks,
>
>            Linus
