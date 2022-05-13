Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B11526906
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 20:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383244AbiEMSLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383266AbiEMSLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 14:11:01 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD6855201
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:11:00 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b11so2324542ilr.4
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7SDwbJugi9Qfbn4daJj+diikXnvNofEBDHPc9CZadFk=;
        b=jypKQrZRkiIiFOhNux6npwp6EN7GbEprJ2qK28XnpeqWBreY12uRwhmRJMGY3XkWib
         L+tRjC2PzClSJ3FAqIsE1HlsbpkfG58PiClf7dyv60iw8drw1TeErjSeOSQBKZvSg6/r
         vlQmU904xiCboTuH+a6pHVHRFxI6MTMKmxI8v50+OjTi+GMa7cYud9q1XPL1Xrzv95FP
         QHhOS5xQp/VphP3UfQ6LcZxYJ4qjPRME3GVgsMepyBt6ru/CiUvVt3P3eNZLXN54FJpq
         BnmjDgUJpYy4aDEUXauO9qjyedZXIKKXdlCS8AoAyyz+hU2cFvtWf46ewiTjJE9DjgM/
         ONkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7SDwbJugi9Qfbn4daJj+diikXnvNofEBDHPc9CZadFk=;
        b=lAzXCwgsaI834UWgtrjA3pK4cT/Z4KFvYG8xfI3chyatZNJHt9WzOGzpQnRXBLX1a6
         odcIwjH3dEw3c9QoVhxO440w/m+u6uI2GN6mubITeoG46PLwt6LWQjtdbH/qPoWJttOR
         1+yovpDEtcevPUwFoT6yuyKPBpjdQqYoiMa1iPAJK811FpcD0gMhBUJ3c01nH7qpuEYG
         xUU1rIAnZKnd2cWTgSm9ei1kCneLHyDCceXgohU+kS4KV8AuF95cS4tdop3g8J0jdHe1
         DX3VncEfqbvk/CPVDh72WloCwjvT2OihIgLfKpWLQpoGmzVTUyLZyU3FojPv7l0b2en3
         zU5w==
X-Gm-Message-State: AOAM530jeOeHDteST4WfcgSvPOCHAuHNW+C3DZT7/7xoCBD3O1o9KxP9
        v6PddrwCq5SCiguJRiTPv7TvPJU/iz+9CNBdwiTN6FVFSpovcQ==
X-Google-Smtp-Source: ABdhPJw8WCPE31UhB0lOQ1CIYC4UhriWltJ7VbIhJneGzKpi4PerrIEYEkRD5Hg6b5Y0T9ALAWIXOvm+vNELG9PuRjc=
X-Received: by 2002:a05:6e02:188a:b0:2d0:f58e:fe1a with SMTP id
 o10-20020a056e02188a00b002d0f58efe1amr2662810ilu.303.1652465459632; Fri, 13
 May 2022 11:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
 <Yn00jd+uX8PVZv/9@kroah.com> <CAMdnWFBCyiU-p1ww5NQnvMxVUnVyCkzoS6D+6Hg=7aJR4Bwn5Q@mail.gmail.com>
 <Yn4V4HdJFyHARf1b@kroah.com>
In-Reply-To: <Yn4V4HdJFyHARf1b@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Fri, 13 May 2022 11:10:48 -0700
Message-ID: <CAMdnWFAeViOvwOkkzZ2vdz3TpdE_1JbkanmHhsg1WxP2M79uDQ@mail.gmail.com>
Subject: Re: Request to cherry-pick f00432063db1 to 5.10
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I tested my original patch(which was corrupted by email client).
When the patch is manually backported to fix white space, the patch
was fixed wrongly :(
I sent my original patch again for 5.10.y without any corruption.
Sorry for the inconvenience caused.

For 5.15.y, this is the cherry-pick order:

3be232f11a3cc9b0ef0795e39fa11bdb8e422a06(SUNRPC: Prevent immediate
close+reconnect)
f00432063db1a0db484e85193eccc6845435b80e(SUNRPC: Ensure we flush any
closed sockets before xs_xprt_free())

Thanks,
Meena

On Fri, May 13, 2022 at 1:25 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, May 12, 2022 at 10:38:04AM -0700, Meena Shanmugam wrote:
> > On Thu, May 12, 2022 at 9:23 AM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Tue, May 10, 2022 at 07:33:23PM -0700, Meena Shanmugam wrote:
> > > > Hi all,
> > > >
> > > > The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRP=
C:
> > > > Ensure we flush any closed sockets before xs_xprt_free()) fixes
> > > > CVE-2022-28893, hence good candidate for stable trees.
> > > > The above commit depends on 3be232f(SUNRPC: Prevent immediate
> > > > close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more th=
an
> > > > once on a TCP socket). Commit 3be232f depends on commit
> > > > e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> > > >
> > > > Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> > > > kernel. commit 89f4249 didn't apply cleanly. I have patch for 89f42=
49
> > > > below.
> > >
> > > We also need this for 5.15.y first, before we can apply it to 5.10.y.
> > > Can you provide a working backport for that tree as well?
> > >
> > > And as others pointed out, your patch is totally corrupted and can no=
t
> > > be used, please fix your email client.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > For 5.15.y commit f00432063db1a0db484e85193eccc6845435b80e((SUNRPC:
> > Ensure we flush any closed sockets before xs_xprt_free())) applies
> > cleanly. The depend patch
> > 3be232f(SUNRPC: Prevent immediate close+reconnect) also applies
> > cleanly. Patch  89f4249
> > (SUNRPC: Don't call connect() more than once on a TCP socket) is
> > already present in 5.15.34 onwards.
> >
> > Sorry about the patch corruption, I will fix it.
>
> Sorry, but this did not work out at all, I get build errors when
> attempting it for 5.10.y:
>
>   CC [M]  net/sunrpc/xprtsock.o
> net/sunrpc/xprtsock.c: In function =E2=80=98xs_tcp_setup_socket=E2=80=99:
> net/sunrpc/xprtsock.c:2276:13: error: too few arguments to function =E2=
=80=98test_and_clear_bit=E2=80=99
>  2276 |         if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT),
>       |             ^~~~~~~~~~~~~~~~~~
> In file included from ./arch/x86/include/asm/bitops.h:391,
>                  from ./include/linux/bitops.h:29,
>                  from ./include/linux/kernel.h:12,
>                  from ./include/asm-generic/bug.h:20,
>                  from ./arch/x86/include/asm/bug.h:93,
>                  from ./include/linux/bug.h:5,
>                  from ./include/linux/mmdebug.h:5,
>                  from ./include/linux/gfp.h:5,
>                  from ./include/linux/slab.h:15,
>                  from net/sunrpc/xprtsock.c:24:
> ./include/asm-generic/bitops/instrumented-atomic.h:81:20: note: declared =
here
>    81 | static inline bool test_and_clear_bit(long nr, volatile unsigned =
long *addr)
>       |                    ^~~~~~~~~~~~~~~~~~
> net/sunrpc/xprtsock.c:2276:55: warning: left-hand operand of comma expres=
sion has no effect [-Wunused-value]
>  2276 |         if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT),
>       |                                                       ^
> net/sunrpc/xprtsock.c:2312:17: warning: this statement may fall through [=
-Wimplicit-fallthrough=3D]
>  2312 |                 set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_=
state);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~
> net/sunrpc/xprtsock.c:2313:9: note: here
>  2313 |         case -EALREADY:
>       |         ^~~~
> make[2]: *** [scripts/Makefile.build:280: net/sunrpc/xprtsock.o] Error 1
> make[1]: *** [scripts/Makefile.build:497: net/sunrpc] Error 2
>
>
> And I am not quite sure what order you want me to apply things for 5.15.y=
.
>
> So please, send me a properly backported series of patches for this for 5=
.15.y
> and 5.10.y and I will be glad to pick them up.  Right now I'm just confus=
ed as
> this was obviously not tested at all :(
>
> thanks,
>
> greg k-h
