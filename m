Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85DF7F5A3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392179AbfHBLAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 07:00:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34421 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392192AbfHBLAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 07:00:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id b29so45414274lfq.1;
        Fri, 02 Aug 2019 04:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wt7WxlfN5bbYMzTthies6t41pinYZ4q+vA57T6gnbAE=;
        b=aOmSVpS+bt+ekMUqTL+Y7tH2ieGGr7Jw/44h5Faq2JU1dAWaMKr6ii9PaA5NX+GT6T
         GtnVvKBnz6ksdtz0RiDwdZS3ZJYNzsuKxh/KNSFVTjvMe4578A2frIbLs+0TpqwRydcJ
         ds1PDJ7rwGAyvDn4tVj3r9v6pKSqkePEc5HpjQpzZAMSiWII60O2+dfjrSDvrMgNhEIj
         yrfvFPaJjbuj0zPj+0IxYMpOrp5q7So2wU1W03lhMdiFRfDtcRo+mRE6FTTEIt8yeQZF
         wO72V1ijDl/1vM29+m1InFFAfM52dLwprShMVE+SgsTvI8yIOCdfUDAH5hl7qUcpOn06
         fNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wt7WxlfN5bbYMzTthies6t41pinYZ4q+vA57T6gnbAE=;
        b=fs3lBAzIuIxBsIA1jXwHNgk6PZ0J8jNiLhoN02dvqQjy3sKyzpNAtFpIiiSid6Q2Eg
         G7WHJkKAeZet/v9wgnCzykarSwlBbQhFiP8IBg0pEVkQ7FCB7DF35s4fuiaPdV3QTNGm
         AuMQbpENufdO32t5eVmOg2rAXMD8u2jdle+gS0pWhVtNLde2KROkrOSFH2alKsRz5hYX
         PiSCvkrrFppIGabS2PjlhEdfNrQux8RAYTycMDt8vh6p2naUaT7iQUN+Vh5ZIfUWheFX
         AJ17x7WZ9QEr1mJAPvFAtAjBLhHLlF5T7H5rScIQ1j44wQPUxpsdOMipjso0aSaVHgHb
         9bwQ==
X-Gm-Message-State: APjAAAUjfRpNXyF810IN1VDsL4P+Y9GdkbiXkTGFydJ7mNhHMLfnGY4u
        OJyNOlKHA/oIZL0IKM5reERajubU4Tb5AIt3240=
X-Google-Smtp-Source: APXvYqxjOsmMp4j5kcGBFe67+JYL7mzTR5TgnpPp282kSrMxiiv8w4drdi258b3Om8fsOuoNBtaTTKdaKWsTJKZyVS0=
X-Received: by 2002:a05:6512:1d2:: with SMTP id f18mr24187779lfp.173.1564743642396;
 Fri, 02 Aug 2019 04:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <259986242.BvXPX32bHu@devpool35> <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35> <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
In-Reply-To: <20190802103346.GA14255@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 2 Aug 2019 13:00:30 +0200
Message-ID: <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Linux_4=2E9=2E180_build_fails_with_gcc_9_and_=27cleanu?=
        =?UTF-8?Q?p=5Fmodule=27_specifies_less_restrictive_attribute_than_its_targ?=
        =?UTF-8?Q?et_=E2=80=A6?=
To:     Greg KH <greg@kroah.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 12:33 PM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Aug 02, 2019 at 12:19:33PM +0200, Miguel Ojeda wrote:
> > On Fri, Aug 2, 2019 at 10:17 AM Rolf Eike Beer <eb@emlix.com> wrote:
> > >
> > > Am Samstag, 8. Juni 2019, 14:00:34 CEST schrieb Miguel Ojeda:
> > > > On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
> > > > > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > > > > idea what the end result really was :)
> > > > >
> > > > > If someone wants to send me some patches I can actually apply, that
> > > > > would be best...
> > > >
> > > > I will give it a go whenever I get some free time :)
> > >
> > > I fear this has never happened, did it?
> >
> > No. Between summer, holidays and a conference I didn't get to do it.
> >
> > Done the minimal approach here:
> >
> >   https://github.com/ojeda/linux/commits/compiler-attributes-backport
> >
> > Tested building a handful of drivers with gcc 4.6.4, 8.3.0 and 9.1.1.
> >
> > Greg, I could backport the entire compiler_attributes.h, but given
> > this is stable, we are supposed to minimize changes, right?
> >
> > I tried to imitate what you do in other stable patches, please check
> > the Cc:, Link: lines and the "commit ... upstream" just in case.
>
> If only those 2 patches are all that is needed, nice!  I'll gladly take
> them, can you send them to me (and cc: the stable list) in email so I
> can queue them up for the next round of releases after this one?

At least for that particular problem, yeah -- I haven't done a full allmod.

By the way, I just checked 4.14.y and I noticed you had already
backported it, although going for another solution:

+#if GCC_VERSION >= 90100
+#define __copy(symbol)                 __attribute__((__copy__(symbol)))
+#endif

and then:

+#ifndef __copy
+# define __copy(symbol)
+#endif

Cheers,
Miguel
