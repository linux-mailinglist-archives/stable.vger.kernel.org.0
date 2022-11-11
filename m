Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F6D6253D3
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 07:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiKKGcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 01:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKKGb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 01:31:26 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB15E3E6
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 22:29:01 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 63so4954132ybq.4
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 22:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YfGpV2JA6patueMGzEYztlKL5Nu/nd16bt9DITnJUsw=;
        b=EhhSM3ubjZZaNZW6RsLRC5+FRMYk1rWzaPCdefEyP6qJ3zQelmXzARbaV4VbwNhuUU
         Z5Es/matWC2laMecuVrAfpFH43B8jkn6BuywA3Rl38VFl4g0dkFqhMMv7pVWyLLTH4Vh
         IhmS6VaIQOHK9sMSN+nIaVZ67YvF7rbs4J5b0MXjABKQiXCL1DgICa4ZfLmB68aAw7M0
         uggrcvUXW+11tHXofn0LcNQlrKdteVdAHkc7ruWcANvyDoSNB9mnrs6Z7228tVlIu77B
         8zxW2oxbAvd1G87KDie6SBwvO6O/n9muMnP4eHQsL+/wwZ2fTx+xq79Y26xQyK4pijoz
         7TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YfGpV2JA6patueMGzEYztlKL5Nu/nd16bt9DITnJUsw=;
        b=h3X04SQHAxHl7mjp7MDuM6iDWXPNXdxCLVW12ebgp0i4M3QRliKlI2W3x/YmThO66D
         C5pgbdi7kI4aEDH6hZ80Dkek/jNxzj/PXV0C1FRECZqDyamwIPWnOp8CYEwWEFPrQY3G
         VY/HM5pj5ExYovTeLY+qaAcqMXhlTavplgbTf6v4PUTiF0PlJzrVQPXpr7ptNKgDIY7F
         76d3cuS+amcgiJLDNVfGMFvJBbYMBf66/y3lPqiBbrMKMCm99YQk8Kh11fmN9/VaJuaF
         UGnIzOJeI+4diLyf6Ny5qsHz1B4Cmq7OGK9spT12e8alA2Opc+TapoXbfm1S4Bi+3pxQ
         5rsw==
X-Gm-Message-State: ANoB5plOkwtBNuc18OJkcm1EYljjtp+U8itDu9k3mTd1xRh7uwmnNn9+
        yhLfe0k2lTU9baQZLgiMn8L/Hv0z38Ft0uaO7Q/Vg9eCvyMfKg==
X-Google-Smtp-Source: AA0mqf7h9gVbHC9AIBKiyUShaRgyYmJgsc/IKxG8U0ryPQvMgEnypOPr6AWgIEdMQtAbmXCJHUnS5NDMJkuqCMSxkJQ=
X-Received: by 2002:a25:900c:0:b0:6c4:8a9:e4d2 with SMTP id
 s12-20020a25900c000000b006c408a9e4d2mr544847ybl.164.1668148140428; Thu, 10
 Nov 2022 22:29:00 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com> <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
In-Reply-To: <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Nov 2022 11:58:48 +0530
Message-ID: <CA+G9fYs_kWc1Zh=Zr4esnJYRvSMwv6k6m1eYW4PbHCYpvJPPOg@mail.gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer
 dereference at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
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

Hi Arnd,

On Thu, 10 Nov 2022 at 03:33, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Nov 9, 2022, at 13:57, Arnd Bergmann wrote:
> >
> > One thing that sticks out is the print_constraints_debug() function
> > in the regulator framework, which uses a larger-than-average stack
> > to hold a string buffer, and then calls into the low-level
> > driver to get the actual data (regulator_get_voltage_rdev,
> > _regulator_is_enabled). Splitting the device access out into a
> > different function from the string handling might reduce the
> > stack usage enough to stay just under the 8KB limit, though it's
> > probably not a complete fix. I added the regulator maintainers
> > to Cc for thoughts on this.
>
> I checked the stack usage for each of the 147 functions in the
> backtrace, and as I was guessing print_constraints_debug() is
> the largest, but it's still only 168 bytes, and everything else
> is smaller, so no point hacking this.
>
> 168     print_constraints_debug
> 96      timekeeping_advance
> 64      set_machine_constraints
> 64      of_i2c_register_device
> 56      of_platform_bus_create
> 48      schedule_timeout
>
> One more idea I had is the unwinder: since this kernel is built
> with the frame-pointer unwinder, I think the stack usage per
> function is going to be slightly larger than with the arm unwinder.
>
> Naresh, how hard is it to reproduce this bug intentionally?
> Can you try if it still happens if you change the .config to
> use these:?
>
> # CONFIG_FUNCTION_GRAPH_TRACER is not set
> # CONFIG_UNWINDER_FRAME_POINTER is not set
> CONFIG_UNWINDER_ARM=y

I have done this experiment and reported crash not reproduced
after eight rounds of testing [1].

https://lkft.validation.linaro.org/scheduler/job/5835922#L1993

>
>        Arnd

- Naresh
