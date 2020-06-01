Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C21E1EA86C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFARbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgFARbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 13:31:34 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04776C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 10:31:32 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z6so9091024ljm.13
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 10:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PLqv2Ml3ZEgetTbys1MUlrppSSy3mTBUPXCoTXa7n2c=;
        b=AavBT4kz6LNJTn6n1MXAIPW4xUBOThrowTma99YqbTy8H5CK3dlCG0kYKhrhNpaWIZ
         +Oycy/PDJ4ZsG490MGPEoJtoT29txM0EFpWdFLlAc/Ffapax75gWzjI4dYWwkjJCSkCT
         MqTzanIpeWYQfpzYgkcnSji8Gr/HUICuE6m3SfuwPZhdXz6kq4V6tP8WwERGtVwgyh0h
         fzfjHyTWFD2m/V4CbeIpDyjjvUxJNbiUaw3Vt4qW+vexbH2KdKV6PqrKe31Esiz4U6Kw
         y+Ga0wX4JtmPaBGP/kJ69fiI//4q1Xe7FsAYkyrtnBhJgeYX5TlHVfqbWHU5ssErFwVQ
         P6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PLqv2Ml3ZEgetTbys1MUlrppSSy3mTBUPXCoTXa7n2c=;
        b=keyslFOIihNcZ2PLE9B1FtmHnUwRRZCPVXYAy7tarrobC5YCNhMLD31rTn3SUep5mA
         LzSH06W8sqCgzpWA2kD2lBB3h5NVNj+YRUqz20OBza4WStmWGG0I0m2oMHnGGot9JQiP
         v6+aSCDr4ZkyGrLS3pj+06UU5/bodlvusvnys26L5vsi82a/DQ38sUBKO2FsONKFgIEP
         kIaYN81aFkrMsLaCRz39amaVBMKZA8i3LuG9OY/nAByorl2/4MwouK6sqFBDg/xzlsXi
         ojOPYQV0pqtS5yYLH9Ap8MwJ1j0XkF/Q/Zhp1IH0qiL8QmwtHeSXzo7aRzWwNyUpi8bf
         P0ug==
X-Gm-Message-State: AOAM532kR2d15kGVlMdLR5vTmZTJbpZFpAZlpvFIZGanQH42rcSD1+Um
        VBt5P9lXusCIyzXety3uIiR3Ne932cJPT7XuzE9HwA==
X-Google-Smtp-Source: ABdhPJzn9jtJoL0F72Md7dOTNOiWsU500L/SULQ39EUBXO6vi0lnJhxuMID014Uj/zhr54yt8VC+WnVcD5k9xEwJ6yE=
X-Received: by 2002:a2e:150f:: with SMTP id s15mr10777023ljd.102.1591032691070;
 Mon, 01 Jun 2020 10:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
 <20200601170248.GA1105493@kroah.com> <20200601170751.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20200601170751.GO1551@shell.armlinux.org.uk>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Jun 2020 23:01:19 +0530
Message-ID: <CA+G9fYsHPjXW5BWbAgURhxnrSHamGPMAGtpjikbkUd79_ojFbw@mail.gmail.com>
Subject: Re: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad
 instruction `ldcleq p11,cr0,[r10],#32*4'
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Jun 2020 at 22:37, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 01, 2020 at 07:02:48PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 01, 2020 at 09:18:34PM +0530, Naresh Kamboju wrote:
> > > stable-rc 4.9 arm architecture build failed due to
> > > following errors,
> > >
> > > # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> > > arm-linux-gnueabihf-gcc" O=build zImage
> > > #
> > > ../arch/arm/vfp/vfphw.S: Assembler messages:
> > > ../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
> > > ../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
> > > make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
> > > make[2]: Target '__build' not remade because of errors.
> > > make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
> > > ../arch/arm/lib/changebit.S: Assembler messages:
> > > ../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
>
> It looks like Naresh's toolchain doesn't like the new format
> instructions.  Which toolchain (and versions of the individual
> tools) are you (Naresh) using?

  toolchain version is gcc-9

>
> > Odd, I'll drop it from 4.9, but it's also in the 4.14 and 4.19 queues as
> > well, is it causing issues there too?

An hour back builds pass for linux-4.14.y and linux-4.19.y branches.
A new set of builds triggered a minute back.
I will check build status and get back to you.

>
> What if it turns out that Naresh is using an ancient toolchain
> that isn't supported by these kernels?  Does that still count as
> a reason to drop the patch?
>

- Naresh

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
