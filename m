Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3232AEDC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhCCAGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381521AbhCBIEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 03:04:40 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E370DC061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 00:03:30 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w1so33469814ejf.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 00:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rU6EqHa7/OL3U2GQqdzaAltx19CIsvxLPpd+/Gf2M1g=;
        b=OLBV+dd/osXMP3YOJPdz417BBdqKRMSP28mLZgPP8RlCUjtpUx+fH4GN9nGtCyfmvE
         kHsFU/y6ET6Zjl+kaIwDZByGmuqqG+Pf9sERJQoGN0N+PYdxmunO8UdSuweqJ/gtNOIa
         aRCNRo02Su1np5/cZt1MoGShCKdr2ktJUQ4vbEheY8CNNa4hEk1wx2IpnIDfDNSSHFGL
         bP6zy/na8R6Z28m8xLEuwyaVDM6/hhxgOifPiUn1porbPHdd/RZWaUz7d3nIrL7uzTWw
         VtbHGXd5h9S93iWSDwOp+MPCRm0ivgyflPsiOJ/Re17t9kJXpInas8iPaQxTX932OtUN
         hbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rU6EqHa7/OL3U2GQqdzaAltx19CIsvxLPpd+/Gf2M1g=;
        b=HpYVJFMTUqIwrsfkUNj6Lpy9KldRLg/K2Ekr4Sf9klCXV7B8WtgHLGYA9lcznrl0Zy
         UcAHHo8r7J2JQDIlDtG0cim1ZX/VjHSWMvyF15rwknXXFoYfvpa3+JRLw5N8oyryAt39
         APZhbPRZMmUQIewAEmpfBavPPCcuQbftTKkanfNyQmRyioFkeONTW4QDcy18re1vMZiZ
         aw8sfsQw52I9lDayVtn2rnMZnjvFwtJsXRq2eXFKC18DPwGsaVMNbAAxZYEPPOzlaJZL
         /3ruzsw8rghhCV2P4e970IoFsOwzsxfjuOuaCpzHKvhNgWmm2ZwrWeHPO7Fjko7nGXx+
         sFsw==
X-Gm-Message-State: AOAM532yhsM1Hg72OUspkOfi5T9z8tMf8HJdloteqrCbvfElhX2l4ESN
        MzpM/xz1XstZDoUBJiu3m4dUGxSh0qPGy5C1c4S65Q==
X-Google-Smtp-Source: ABdhPJxn30Bbk5NTUfuO0ZzhC0X/Q/51iKNYu45f9GCIBODajVC4PJElfMLsEpuzDxZPoMtroOxHv/ZPrB/sH8d10jY=
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr19614973ejb.503.1614672209369;
 Tue, 02 Mar 2021 00:03:29 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
 <YD3wo+etw0HQaAK2@kroah.com>
In-Reply-To: <YD3wo+etw0HQaAK2@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 13:33:18 +0530
Message-ID: <CA+G9fYsguv3qBbnHtiw9NKwb9REuQRbdji3YvQh7ETxSRbheAQ@mail.gmail.com>
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'? [-Werror=implicit-function-declaration]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sahaj Sarup <sahaj.sarup@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021 at 13:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 01, 2021 at 10:42:34PM +0530, Naresh Kamboju wrote:
> > On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
> > gcc-9 and gcc-10.
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=sparc
> > CROSS_COMPILE=sparc64-linux-gnu- 'CC=sccache sparc64-linux-gnu-gcc'
> > 'HOSTCC=sccache gcc'
> > <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> > In file included from include/net/ndisc.h:50,
> >                  from include/net/ipv6.h:21,
> >                  from include/linux/sunrpc/clnt.h:28,
> >                  from include/linux/nfs_fs.h:32,
> >                  from init/do_mounts.c:22:
> > include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> > include/linux/icmpv6.h:70:2: error: implicit declaration of function
> > '__icmpv6_send'; did you mean 'icmpv6_send'?
> > [-Werror=implicit-function-declaration]
> >    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
> >       |  ^~~~~~~~~~~~~
> >       |  icmpv6_send
> > cc1: some warnings being treated as errors
> > make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >
> > Ref:
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179275#L62
>
> Ok, I can duplicate this on 4.19.y, but not 5.11.y, let me see how to
> resolve it...

My bad. The reported problem is on 5.4, 4.19, 4.14 and 4.9.

- Naresh
