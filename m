Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0AC526915
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382923AbiEMSPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 14:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378108AbiEMSPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 14:15:04 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4501D3D5F
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:15:03 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a10so9518606ioe.9
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5GD0SLw1AH27oEs9JwNKbrHm3qIoU7ZUK/a/xM1pva0=;
        b=h/elexL4H0vB0MqR4Oer7J6jtxqc8truN9ftrRiVsyZLKYcto2+0gEeWaEOUrAHbxN
         Em4+B7JAa8TsVxUUg6XaY3tJXHu2GicKFh/2Re7GLYVHuXby8n3FH8kAQ00XleRsJS2L
         nqRKcZeAPOMn+IC/dhAfT2yNvh9B3knymD5v0KtK6PdPAk12h1I0ySfFd6eeLN3r5fBL
         MamMRcTzU0OraFE1ONnDlniALlNP46/PN5MB5F+0YnLmFpIN7uzc2ysJTQSSLGzpfoVe
         F+hh134Eg8etNDMxVdFIqqf1/fd1hBBQk+Rs9kkvV3MB5SexheWMwHlxK05ypxx3J4Mj
         byLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5GD0SLw1AH27oEs9JwNKbrHm3qIoU7ZUK/a/xM1pva0=;
        b=OIxop2XjpFIyc9bwmXMYbFPwxPa0hczveducRciIP35/b4aDgwKNkvGAzbeBIgWuyy
         IdOBP7QWOXQUs+r1gVmpeT0ROUF20V9hpMiblhQq/se5PmQE9vCXWlm154HXC/3pR4qo
         bseZmYUbWnZYMqQlP4o3K/Ej2rFUxEid6qgVCC68oUKHzIY+36djYvDszIgyylQGMmuX
         pmDpvzFfvT5sF1sYN+lZBdkcO44luJFlc6s6f0Kwk/qN01CPkR/eZEQxW6s5BOfyyH7E
         nWd6PSn2sVRIm/fL8SlKqve2Q1pMAQ4qjpwDmx0bhN1rSqexWsYyIy4XHP9XCtaC7s7t
         E2IA==
X-Gm-Message-State: AOAM530o/08qHXEm6rOOrPS0lyK7hHimyajFDSaDIkv39ovUM9GnVpM0
        AN487ZN5/WoACMfzcSneFuy8zCHm6dDhGIzXbIrcTL4gXXpqZg==
X-Google-Smtp-Source: ABdhPJyPhLnPEcFD+zPIX8+PP7UEw7CY6HE1Qejb7cOFVwiMAQnqHdylAA36IzpaOJC4ZKhUoXy9FE70pkf2B2mFduE=
X-Received: by 2002:a05:6638:3723:b0:32b:6683:ac20 with SMTP id
 k35-20020a056638372300b0032b6683ac20mr3256698jav.299.1652465702406; Fri, 13
 May 2022 11:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
 <Yn00jd+uX8PVZv/9@kroah.com> <CAMdnWFBCyiU-p1ww5NQnvMxVUnVyCkzoS6D+6Hg=7aJR4Bwn5Q@mail.gmail.com>
 <Yn4V4HdJFyHARf1b@kroah.com>
In-Reply-To: <Yn4V4HdJFyHARf1b@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Fri, 13 May 2022 11:14:51 -0700
Message-ID: <CAMdnWFDwYr-NYTqK3nJvFX7hox0wD0XrUauChGxD+5ZJUVTBew@mail.gmail.com>
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
