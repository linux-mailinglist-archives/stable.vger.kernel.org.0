Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC614BBBE2
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 16:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiBRPJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 10:09:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbiBRPJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 10:09:51 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDE42B2C44
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 07:09:34 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso8787324pjl.4
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 07:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=36b8fUgBgkG/J7xA4TUE4cQ7mfqgavYR9WGvxGCPE1U=;
        b=Jw6ohM3ahD9WyO6QVeHmMPBUbNG1XJIzSyHMJZizLu9A9fewGqtnVs9YuUi1/vBBd8
         jYRhLqIHgdGlbL1XvkCR+zsLfQzSARb3cR0iY+pIMhoTy94xV8i7gkJ5zKYLu6asXwPF
         lt4zQ3UbgFui0b+i6FezAte2L1NQFglzYBD0BZoqYIAkpKRfUQN3GQWZ4WPAfy2koW8s
         ITo+IhZppW3Nu2w3sBQbOJtYIU9vkmao7kFK2ChxScKHkUA26tYEsKgoIQyMpDab4De8
         xZLBF92YOHoFsX7pODYDj0ExA6MdJYV+d3j0gLL2cFh5jOmBISacXCtu3rMCZhfimPRK
         eTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=36b8fUgBgkG/J7xA4TUE4cQ7mfqgavYR9WGvxGCPE1U=;
        b=zSauWJh+otHCk61ez8JPXCkYC0CjfgvdQHkwikduxDLPpNPU7ZVe/pA53SGeOpDSq0
         G/TFUfnAaDL9t1HKYPpXsOyW2ZtgXXGeRFNOZvttzyXI6nIPgbVMaKm7xNhgvD3w7XR0
         1LH42Si9IrEzEwtDmIATMBowsA6/wfFw7t3DUCNjr3H9XSiT7Efv7m0T/GWM6qyZ6WJy
         zBlZHUIapIVDQ2X4fkBYWUTe7TPuBAQLytRPUp5QCjrsUXFgmuc8PbYmYsFhAmqP3yDy
         rZ1m9JwsGBQJVDhQyvV/5yCmVa4U2GMBzRiBymPuo5YR9p3oyxU3AGHqAo8v73Qp6eBz
         t7rg==
X-Gm-Message-State: AOAM533xrrVuRFnG4eQpIt6YSdoNm7aLcpFYToI4S6t/Cdf8KOVqO3Av
        WmyOaL4Ds2QnROamf2YxGOhEXdhabHDHJL8f/hMYfw==
X-Google-Smtp-Source: ABdhPJyzSYoOYi7W80L+8H9gmsl+dhP3Wj6AmcL87PccXqW4DdMojkqYbQgHyHoQQX+1uU5aasXqz9mfn5QcDHoiCWk=
X-Received: by 2002:a17:903:228a:b0:14d:aa04:2278 with SMTP id
 b10-20020a170903228a00b0014daa042278mr7995521plh.58.1645196974125; Fri, 18
 Feb 2022 07:09:34 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuDLxwN97GdYhyQ2kz=WD1ASKE4HzDC1GKfrhPvk2xaXA@mail.gmail.com>
 <CAHUa44FAh89fRQMB7XgjDrwjv-7iye721CHi6jDe8VchLwZijg@mail.gmail.com> <Yg+zn6egFCxUZTFX@kroah.com>
In-Reply-To: <Yg+zn6egFCxUZTFX@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Fri, 18 Feb 2022 16:09:23 +0100
Message-ID: <CAHUa44H4B18U=SHLo-YwbKyWu2C68=nb634bAom6Cm-77r4BEQ@mail.gmail.com>
Subject: Re: stable-rc/queue: 5.15 5.16 arm64 builds failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <larper@axis.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 3:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 18, 2022 at 03:49:49PM +0100, Jens Wiklander wrote:
> > Hi Naresh,
> >
> > On Fri, Feb 18, 2022 at 3:36 PM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > While building stable rc queues for arch arm64 on queue/5.15 and
> > > queue/5.16 the following build errors / warnings were noticed.
> > >
> > > ## Fails
> > > * arm64, build
> > >   - gcc-11-defconfig-5e73d44a
> > >
> > > Committing details,
> > > optee: use driver internal tee_context for some rpc
> > > commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.
> > >
> > >
> > > build error / warning.
> > > drivers/tee/optee/core.c: In function 'optee_remove':
> > > drivers/tee/optee/core.c:591:9: error: implicit declaration of
> > > function 'teedev_close_context'; did you mean
> > > 'tee_client_close_context'? [-Werror=implicit-function-declaration]
> > >   591 |         teedev_close_context(optee->ctx);
> > >       |         ^~~~~~~~~~~~~~~~~~~~
> > >       |         tee_client_close_context
> > > drivers/tee/optee/core.c: In function 'optee_probe':
> > > drivers/tee/optee/core.c:724:15: error: implicit declaration of
> > > function 'teedev_open' [-Werror=implicit-function-declaration]
> > >   724 |         ctx = teedev_open(optee->teedev);
> > >       |               ^~~~~~~~~~~
> > > drivers/tee/optee/core.c:724:13: warning: assignment to 'struct
> > > tee_context *' from 'int' makes pointer from integer without a cast
> > > [-Wint-conversion]
> > >   724 |         ctx = teedev_open(optee->teedev);
> > >       |             ^
> > > drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
> > > undefined [-Wsequence-point]
> > >   726 |                 rc = rc = PTR_ERR(ctx);
> > >       |                 ~~~^~~~~~~~~~~~~~~~~~~
> > > cc1: some warnings being treated as errors
> > >
> > >
> > >
> >
> > It looks like 1e2c3ef0496e ("tee: export teedev_open() and
> > teedev_close_context()") is missing. I noted the dependency as:
> >     Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export
> > teedev_open() and teedev_close_context()
> > in the commit. Perhaps I've misunderstood how this is supposed to be done.
>
> When doing a backport like this, please be explicit as to what I need to
> do if it is different than just taking the patch you sent me.

OK, I have a couple of backports left so I'll make sure to mention it there.

>
> I'll try to fix this up later...

Thanks, sorry about the trouble.

/Jens

>
> thanks,
>
> greg k-h
