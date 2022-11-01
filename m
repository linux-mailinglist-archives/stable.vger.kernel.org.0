Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85541614BFC
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKANoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 09:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKANon (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 09:44:43 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E9F62DA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 06:44:41 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 128so4841535vse.6
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 06:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wmlDbxR43p/AVKjp9OWEiUiPO2sb+nmDFWo89vNMtlg=;
        b=xtRaXtRJufi5E55u5VPH6L1vPkaVY/Jjx2qHNusVQQxg4p3/fIJSs4FCm1Elk3Ebwe
         X3m+I2TMPqgEaBf8SHtwhHDhM4/F6H7SoDJ5SQyAp8J1YJm72JF34sTCclU83H8TQlBL
         W6RqZ6Z6IYSgld0lt7BrTTR+BssWEJptn5pkoTmMHGXOOaNTtsMNrKPSswLxIhp7GNKS
         /+TyRssm0BbWHqn9pg8qFets9zKXOVDADiWK7SlU9jYAMJX7sBaaloKZ4s8FEJYDSTNI
         tCdb1Q22k4qBc72CTZ1A7D4kMUEKNjZWOk1PFX6QaJnZ8HqZtBUzL9HxHmosAqosnjaO
         fhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wmlDbxR43p/AVKjp9OWEiUiPO2sb+nmDFWo89vNMtlg=;
        b=DHjLVWMYMOaY8tZtFQECnashv7LoNF8JPztYTOAEIMVredfshHB2FjRkqdUtt2WYu3
         DmY3PUmMRKE6Htf6dwLnH5effxtDMwT0zKcu3VInY3j52M1r6Zp+jYxiADNQ0+Tiij0E
         5FVjztX7xd/e7tWWWXFxUe5vwEYaJPok9kOQNZ4FoKCsKcvLwoxiI2AdBr5XYsVEAvMA
         wfZHvFMpcjmCGG7VXj7jNS+miewbPuf81Au8Qp6EBT5Uu3v8G3XA8+DujhASJUdI7bC8
         7P5HpyE1SQk9sPCRGDwvu9AoUtQ88Fgv9FHM5bQtKwBPKnRmbc80ttgC5bVBos9r7o9k
         FJvg==
X-Gm-Message-State: ACrzQf0y8wZVXm1zqfiLoD0+nJ5qcdTvnp876DTkOcl6v5An8tycgkTm
        5nI0UDC0E9LrkMRaTiF9Zvz57SndVufdnCxaquPmYw==
X-Google-Smtp-Source: AMsMyM6dWSMgu33OOYMi6pqhJtdD0hvHbgxTBidAxbGSJKrSQUJ+/zQvT4C+WxuQjurTuoXPI7dmuwFGM+oJm9yuWgo=
X-Received: by 2002:a05:6102:534c:b0:3a7:c31a:a661 with SMTP id
 bq12-20020a056102534c00b003a7c31aa661mr7280950vsb.7.1667310280708; Tue, 01
 Nov 2022 06:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112959.085534368@linuxfoundation.org> <20221024113002.025977656@linuxfoundation.org>
 <CAMSo37XApZ_F5nSQYWFsSqKdMv_gBpfdKG3KN1TDB+QNXqSh0A@mail.gmail.com>
 <Y2C74nuMI3RBroTg@kroah.com> <CAMSo37Vt4BMkY1AJTR5yaWPDaJSQQhbj7xhqnVqDo0Q_Sy6ycg@mail.gmail.com>
 <Y2Egh1LFMvOv6I7m@kroah.com>
In-Reply-To: <Y2Egh1LFMvOv6I7m@kroah.com>
From:   Yongqin Liu <yongqin.liu@linaro.org>
Date:   Tue, 1 Nov 2022 21:44:29 +0800
Message-ID: <CAMSo37XDNfptuK3=MepUUMht4+hqrg8OJMwRTYmu1utW1eJdJA@mail.gmail.com>
Subject: Re: [PATCH 4.19 092/229] once: add DO_ONCE_SLOW() for sleepable contexts
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Copeland <ben.copeland@linaro.org>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Nov 2022 at 21:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 01, 2022 at 08:00:03PM +0800, Yongqin Liu wrote:
> > Hi, Greg
> >
> > On Tue, 1 Nov 2022 at 14:26, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Nov 01, 2022 at 02:07:35PM +0800, Yongqin Liu wrote:
> > > > Hello,
> > > >
> > > > As mentioned in the thread for the 5.4 version here[1], it causes a
> > > > crash for the 4.19 kernel too.
> > > > Just paste the log here for reference:
> > >
> > > Can you try this patch please:
> > >
> > >
> > > diff --git a/include/linux/once.h b/include/linux/once.h
> > > index bb58e1c3aa03..3a6671d961b9 100644
> > > --- a/include/linux/once.h
> > > +++ b/include/linux/once.h
> > > @@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
> > >  #define DO_ONCE_SLOW(func, ...)                                                     \
> > >         ({                                                                   \
> > >                 bool ___ret = false;                                         \
> > > -               static bool __section(".data.once") ___done = false;         \
> > > +               static bool __section(.data.once) ___done = false;           \
> > >                 static DEFINE_STATIC_KEY_TRUE(___once_key);                  \
> > >                 if (static_branch_unlikely(&___once_key)) {                  \
> > >                         ___ret = __do_once_slow_start(&___done);             \
> >
> >
> > This change works, it does not cause kernel panic again after this
> > change is applied.
>
> Great, thanks!  Can I get a Tested-by: line for the changelog?

Sure, Yongqin Liu <yongqin.liu@linaro.org>

> I'll queue this up in a bit and get it fixed in the next release.

BTW, to be clear, I tested it with one 4.19-q tree based on the latest
ACK android-4.19-q branch[1],
If there is something else I could help test, please let me know.

[1]: https://android.googlesource.com/kernel/common/+/refs/heads/android-4.19-q
-- 
Best Regards,
Yongqin Liu
---------------------------------------------------------------
#mailing list
linaro-android@lists.linaro.org
http://lists.linaro.org/mailman/listinfo/linaro-android
