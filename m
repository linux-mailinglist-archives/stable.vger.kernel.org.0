Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E930328F72
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbhCATvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240659AbhCATmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 14:42:18 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B2FC061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 11:41:33 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id x10so4244453oor.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 11:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZYZn+FUWltS9zTl+K4owPbaqfv5oCTWAPseCcQe+mHg=;
        b=EljJ3P7fHH0z70B+fUjJ/Nd5Iu3lc80v5Ih0A1fnWCjibhAlv7tQ+hHzaENIn18CfQ
         iOs5br+9jCO8g2KZT6vL017JtXHysqW1FRY+qnDFFKez68tCZqmWCVCi/SYJyceaHDjC
         vXwSo+QJ8JmMiKXEqt0jSJpJDrN6RFfWay6k5PBDBY4KJUwXpXnqmp/LI/KAj2zSQIx9
         1sVnoQbrRWgTIcXDNmeoBEHlvhISKZ0cGuC+8Fwql61u7fO/ALYlA88YlDyQcaVuaQuG
         cOvHdKPnCidZrlfDYhSQPnmaK5rW4l5UHiMNoAB+7Rm24pFip3LKHGwqcn6cXRDGe1RD
         cRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZYZn+FUWltS9zTl+K4owPbaqfv5oCTWAPseCcQe+mHg=;
        b=lweSvxKxu+wd/QXh0bKKo//9Z4/bi+5MSxqwIbFp12Fb9GKeq6UDxu0VgtI1VzZgAN
         XQpPcq+7zVAUghdmNsV/L6Zobk/VCMRP41029T3wzSIozQgS9uKC1QiYHxqBSl6j9wMe
         OK+rz6xY4M5B3pT4mqUZRHgx6tk+WHCewQ/rodb2+8fdGapqtSSWZjBs/o60qhe28Vi5
         Joiq6H4ANOYeE1aa6FkULLnwEMvx+sqLWBV1aaV0Dsjjp9a2Tjk0ZyiVOFVPave1J69r
         7PpmNxr7EbZJN28005JAbZ/6mKY/yAR17x7GOrgr3xqJpGOcOCaIDCdLy5vDIVV/1rEs
         LAbA==
X-Gm-Message-State: AOAM533xExkM0vdhMpMMmH8AP4fW1It7dRZN864tMrRg/LO3wZqQr2qJ
        cxeLQETPc11umGLlHMFDgGktoh/mMSh3u0siwAPBcw==
X-Google-Smtp-Source: ABdhPJzqf5Ke2vqHYSy6NCckbGkxagr9ar3SIGQ9cne/wH40GCGHHuq2Zr3aBR5DocfC5uifouhGWaWdw6zwIPP6uX0=
X-Received: by 2002:a4a:1883:: with SMTP id 125mr13920681ooo.6.1614627692863;
 Mon, 01 Mar 2021 11:41:32 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
 <YD06+unUAIh8ufOl@kroah.com>
In-Reply-To: <YD06+unUAIh8ufOl@kroah.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 1 Mar 2021 13:41:20 -0600
Message-ID: <CAEUSe780_-ynip=3z=CtMai+ZSL7Hjt8kuHs0AGPX5XUSbUxZA@mail.gmail.com>
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'? [-Werror=implicit-function-declaration]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>,
        Sahaj Sarup <sahaj.sarup@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

)Hello!

On Mon, 1 Mar 2021 at 13:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 01, 2021 at 10:42:34PM +0530, Naresh Kamboju wrote:
> > On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
> > gcc-9 and gcc-10.
> >
> > make --silent --keep-going --jobs=3D8
> > O=3D/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=3Dsparc
> > CROSS_COMPILE=3Dsparc64-linux-gnu- 'CC=3Dsccache sparc64-linux-gnu-gcc'
> > 'HOSTCC=3Dsccache gcc'
> > <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> > In file included from include/net/ndisc.h:50,
> >                  from include/net/ipv6.h:21,
> >                  from include/linux/sunrpc/clnt.h:28,
> >                  from include/linux/nfs_fs.h:32,
> >                  from init/do_mounts.c:22:
> > include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> > include/linux/icmpv6.h:70:2: error: implicit declaration of function
> > '__icmpv6_send'; did you mean 'icmpv6_send'?
> > [-Werror=3Dimplicit-function-declaration]
> >    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
> >       |  ^~~~~~~~~~~~~
> >       |  icmpv6_send
> > cc1: some warnings being treated as errors
> > make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> What is the odds that Linus's tree also fails with this configuration
> and arch right now?

We don't see this kind of failure (or any failure whatsoever) on
mainline (Linux 5.12-rc1) at the moment.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
