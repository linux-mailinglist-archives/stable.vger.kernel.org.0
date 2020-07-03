Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C14821395C
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 13:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgGCLca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 07:32:30 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32985 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCLca (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 07:32:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id j80so28475490qke.0
        for <stable@vger.kernel.org>; Fri, 03 Jul 2020 04:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAcAnn6EzFL1imCtZ9cPP9JWP36c6L1JUrFJvsFnbow=;
        b=d0m4nRkZiG6c7yNj7QFDOW2GLyazeUyrHlVaQt7UNaBcIDASjU1UX7TERBm8vVpheI
         1LbSJ4nkYPRrgyb5xVWOXqokFxiFXIUhhfniRHLrF1xf30tK5MKscwPsuvMtvr55JJ2v
         0PZw8FOzwLtHkSbUYBsStU0ZQ9J+1szAQYJu1uwV3k9rjkntFxmiAiHxrPEYt7rchSh/
         6z72LwnSgcEC8w+6prycnioHMWCbO+vuE2sj66Drm3HxUzjnWoueSQ7q9f+NsIOsPQtS
         InTflZ6k2o6OGm1JO0hDQesNrUhDXnnGTfO2QX3z3HVT/vxCq1R8zYALeJ4XO8q37U+S
         I3KA==
X-Gm-Message-State: AOAM530cEpv2VMw42xyuPi0UQmL+L7uCQRiGI0K7CP/6REQkEM3jK6zn
        gEh861hWVOVcVV6p7w7SlZK4VjYg5MtCiZGpu88=
X-Google-Smtp-Source: ABdhPJx/VC8C4N59HJROHj3HTG7nfRbvUWueIoi1zZES3ExzbOuJsDbFkUZTFPFEJ5VOnTNI7t3HO4PBhnGAUdUQtJ0=
X-Received: by 2002:a37:9f56:: with SMTP id i83mr33172677qke.134.1593775949269;
 Fri, 03 Jul 2020 04:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <1593765640253201@kroah.com> <OSAPR01MB2915705C9D066B832772457FAA6A0@OSAPR01MB2915.jpnprd01.prod.outlook.com>
 <20200703085806.GB2514858@kroah.com>
In-Reply-To: <20200703085806.GB2514858@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Jul 2020 13:32:17 +0200
Message-ID: <CAMuHMdUoNJbw0U4sQXKmrcCvJeZavJFPeAMAm_n_Y24EOJSJRg@mail.gmail.com>
Subject: Re: patch "serial: sh-sci: Initialize spinlock for uart console"
 added to tty-linus
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 3, 2020 at 10:58 AM gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 03, 2020 at 08:53:18AM +0000, Prabhakar Mahadev Lad wrote:
> > > -----Original Message-----
> > > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > > Sent: 03 July 2020 09:41
> > > To: Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>; Biju Das <biju.das.jz@bp.renesas.com>;
> > > gregkh@linuxfoundation.org; stable@vger.kernel.org
> > > Subject: patch "serial: sh-sci: Initialize spinlock for uart console" added to tty-linus
> > >
> > >
> > > This is a note to let you know that I've just added the patch titled
> > >
> > >     serial: sh-sci: Initialize spinlock for uart console
> > >
> > > to my tty git tree which can be found at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > > in the tty-linus branch.
> > >
> > > The patch will show up in the next release of the linux-next tree
> > > (usually sometime within the next 24 hours during the week.)
> > >
> > > The patch will hopefully also be merged in Linus's tree for the
> > > next -rc kernel release.
> > >
> > > If you have any questions about this process, please let me know.
> > >
> > It looks like it's a regression in serial_core.c [1] as Geert pointed out [2]. Please drop this patch until we come to a conclusion.
> >
> > [1] https://www.spinics.net/lists/linux-serial/msg37119.html
> > [2] https://patchwork.kernel.org/patch/11636731/
>
> We have had MANY patches for individual drivers to fix up the issue with
> that serial_core patch.  I think, and hope, they are all now caught.  If
> not, please let us know, but for now, this patch is needed, so I'll keep
> it.

Yeah, let's fix all the fixes when the core issue is fixed ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
