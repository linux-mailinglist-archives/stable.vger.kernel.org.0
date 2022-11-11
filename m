Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E96255D0
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiKKIz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbiKKIzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:55:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3DADFD4;
        Fri, 11 Nov 2022 00:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB34B82473;
        Fri, 11 Nov 2022 08:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DD5C433B5;
        Fri, 11 Nov 2022 08:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668156951;
        bh=UwnQcW+DIbVM73qHx8GWpyYkzIMHZcKiFWqIze2hyRY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Pp8507HrWf8Jk/myn9ejt1xfHquBLgI59QDipZgTtByCB/o28TTut85Pagtx3u60V
         JOhfsDu6b94aCjSsfi1sJePKXyQ+ud8Sw8HaGwi7yIdBnUc/t8AB5AmwLDcXqyBieN
         8tudYmIWSvpEoXKy9AmGvadVsi1h8Kf9rMNGzpG+O8qPHKlUOMpDWMawYQRLbHY4Tw
         zHttHHSU0WgPicCgn8rGaPLFi7cqXrKy5QQFFd30wFikAL7aESo33dfkd8STTqzi6Q
         aaNpVp040u4v57UmfvkxkXyryVFd+mUPaGdKrhj704NgKv9sxZX8oIlo+QpUBQxbYe
         ybzpFJeKvXNIQ==
Received: by mail-lf1-f53.google.com with SMTP id r12so7424847lfp.1;
        Fri, 11 Nov 2022 00:55:51 -0800 (PST)
X-Gm-Message-State: ANoB5pkiL3EZ9Wa2lxgCXqnMCkCrDsLra8X9U46Pvr4qFlhJXhwxnXdK
        3iFV14MLFcYlPkBl03o6ONjO6wvIlxiDTZNIjk4=
X-Google-Smtp-Source: AA0mqf71xb+rTQ+RGjWOJjElNP/NJKbcHQEHO8Ea095YIB/Wp9FjUpaCoK/GGsmuVGM90XxvuvECKhKDmA5HUhyn68o=
X-Received: by 2002:a05:6512:3ca8:b0:4a2:bfd2:b218 with SMTP id
 h40-20020a0565123ca800b004a2bfd2b218mr433243lfv.228.1668156949779; Fri, 11
 Nov 2022 00:55:49 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com> <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
 <CA+G9fYs_kWc1Zh=Zr4esnJYRvSMwv6k6m1eYW4PbHCYpvJPPOg@mail.gmail.com> <89a8e93c-f667-4de1-972f-3d2d051bd789@app.fastmail.com>
In-Reply-To: <89a8e93c-f667-4de1-972f-3d2d051bd789@app.fastmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 11 Nov 2022 09:55:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH994YRCZ9mYfjfN2JdJ_-6_too66bLYGYres5zfXvRCw@mail.gmail.com>
Message-ID: <CAMj1kXH994YRCZ9mYfjfN2JdJ_-6_too66bLYGYres5zfXvRCw@mail.gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer
 dereference at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Nov 2022 at 09:45, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Nov 11, 2022, at 07:28, Naresh Kamboju wrote:
> > On Thu, 10 Nov 2022 at 03:33, Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> One more idea I had is the unwinder: since this kernel is built
> >> with the frame-pointer unwinder, I think the stack usage per
> >> function is going to be slightly larger than with the arm unwinder.
> >>
> >> Naresh, how hard is it to reproduce this bug intentionally?
> >> Can you try if it still happens if you change the .config to
> >> use these:?
> >>
> >> # CONFIG_FUNCTION_GRAPH_TRACER is not set
> >> # CONFIG_UNWINDER_FRAME_POINTER is not set
> >> CONFIG_UNWINDER_ARM=y
> >
> > I have done this experiment and reported crash not reproduced
> > after eight rounds of testing [1].
> >
> > https://lkft.validation.linaro.org/scheduler/job/5835922#L1993
>
> Ok, good to hear. In this case, I see three possible ways forward
> to prevent this from coming back on your system:
>
> a) use asynchronous probing for one or more of the drivers as
>    Dmitry suggested. This means fixing it upstream first and then
>    backporting the fix to all stable kernels. We should probably
>    do this anyway, but this will need more testing on your side.
>
> b) Change your kernel config permanently with the options above,
>    if LKFT does not actually rely on CONFIG_FUNCTION_GRAPH_TRACER.
>    I don't know if it does.
>
> c) backport commit 41918ec82eb6 ("ARM: ftrace: enable the graph
>    tracer with the EABI unwinder") from 5.17. This was part of
>    a longer series from Ard, and while the patch itself looks
>    simple enough to be backported, I suspect we'd have to
>    backport the entire series, which is probably not going to
>    be realistic. Ard, any comments on this?
>

It at least needs the preceding patch, which tracks the location of LR
on the stack when using CONFIG_UNWINDER_ARM.

But I'd take the whole series for good measure.
