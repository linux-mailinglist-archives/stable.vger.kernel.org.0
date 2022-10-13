Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76AC5FDE9B
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJMRBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJMRBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD64AEC521
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A536B81E92
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6BAC433D7
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:01:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ombn1+WX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665680507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECUplbpip+Yxs5mpc4Ff1gAFQXyFD0s28X14fHqTHGY=;
        b=ombn1+WXklMkPFvRc2sie1ayWM8tkGYhcrR2TUwGvE2wO0lAU6qHUFaGwB3Gnj5Mh7/a9i
        f7L3Fx2Dg9/u3w9nv08eLh/mXd51kb1UdMSWykXEuYXXSD7MDjV7EQBIjP44Kxa51R+tF2
        SnWWFCpDTXRxmOT6YUrqk4Qo8CfYn4k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 55ee6921 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Thu, 13 Oct 2022 17:01:47 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id 128so2398598vsz.12
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:01:47 -0700 (PDT)
X-Gm-Message-State: ACrzQf08UJxP1PbR71OgrQprIKhGebFhRgRJe22TWutAEr0SxzgqZM9S
        Fq6ubHMTwMC6fmI9mJqZ0A+tWQM7zhmxrhC/2yo=
X-Google-Smtp-Source: AMsMyM4UbECIm9y5ARArpIlUCNevJWdccDzE6wx4AXCj+2YoZnpusrSzE7Q1L6ePFTKn07ijqRi+1GYe5lw/l39jPkI=
X-Received: by 2002:a67:e401:0:b0:398:89f1:492f with SMTP id
 d1-20020a67e401000000b0039889f1492fmr711067vsf.21.1665680506213; Thu, 13 Oct
 2022 10:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20221013153654.1397691-1-Jason@zx2c4.com> <Y0g6bYnxyNNX5WC6@kroah.com>
 <Y0g89B5GYqYco9w2@zx2c4.com> <Y0hCrbRTA18l3+Ei@kroah.com>
In-Reply-To: <Y0hCrbRTA18l3+Ei@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Oct 2022 11:01:33 -0600
X-Gmail-Original-Message-ID: <CAHmME9pg8D2cOtoiQYJFYzfkz1RmZY7V_HxRH1WAgd_qXYtPYg@mail.gmail.com>
Message-ID: <CAHmME9pg8D2cOtoiQYJFYzfkz1RmZY7V_HxRH1WAgd_qXYtPYg@mail.gmail.com>
Subject: Re: [PATCH stable 0/3] recent failed backports for the rng
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 10:53 AM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Thu, Oct 13, 2022 at 10:29:40AM -0600, Jason A. Donenfeld wrote:
> > On Thu, Oct 13, 2022 at 06:18:53PM +0200, Greg KH wrote:
> > > On Thu, Oct 13, 2022 at 09:36:51AM -0600, Jason A. Donenfeld wrote:
> > > > Hi Greg,
> > > >
> > > > You just sent me an automated email about these failing, so here th=
ey
> > > > are backported.
> > >
> > > Backported where?  Patch 1 is already in 5.10 and newer, does this on=
e
> > > work in older?
> > >
> > > And 2 and 3 for all branches?
> >
> > For all of them they're not yet in.
> >
> > I'll have a look at the 4.9 breakage.
>
> Oops, 748bc4dd9e66 ("random: use expired timer rather than wq for mixing
> fast pool") does not work for 4.9.y or 4.14.y, it breaks the build there
> too:
>
> drivers/char/random.c:909:63: error: macro "__TIMER_INITIALIZER" requires=
 4 arguments, but only 2 given
>   909 |         .mix =3D __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
>       |                                                               ^
> In file included from ./include/linux/workqueue.h:9,
>                  from ./include/linux/rhashtable.h:26,
>                  from ./include/linux/ipc.h:7,
>                  from ./include/uapi/linux/sem.h:5,
>                  from ./include/linux/sem.h:9,
>                  from ./include/linux/sched.h:15,
>                  from ./include/linux/utsname.h:6,
>                  from drivers/char/random.c:28:
> ./include/linux/timer.h:67: note: macro "__TIMER_INITIALIZER" defined her=
e
>    67 | #define __TIMER_INITIALIZER(_function, _expires, _data, _flags) {=
 \
>       |
> drivers/char/random.c:909:16: error: =E2=80=98__TIMER_INITIALIZER=E2=80=
=99 undeclared here (not in a function); did you mean =E2=80=98TIMER_INITIA=
LIZER=E2=80=99?
>   909 |         .mix =3D __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
>       |                ^~~~~~~~~~~~~~~~~~~
>       |                TIMER_INITIALIZER
> drivers/char/random.c:951:13: warning: =E2=80=98mix_interrupt_randomness=
=E2=80=99 defined but not used [-Wunused-function]
>   951 | static void mix_interrupt_randomness(struct timer_list *work)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~
>
>

Ahh the dark old days of timers taking an unsigned long. Fixing. (And
testing...)
