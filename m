Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE953402347
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 08:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhIGGPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 02:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhIGGPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 02:15:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745D2C06175F
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 23:14:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dm15so12323146edb.10
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 23:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ISoVzo30KTxkKbgntnjEzX9bz05YR46K02jdZNC3TaU=;
        b=UekwOaDRRZlmaWmEbdqs29sqC05/Krx7dvtV5Lgz3AXPAOBOY+Pn+WZyyLOQG9dBQI
         0Ab1HcQwG73U80O8RYPKRxc61strB6oZvuePCI5xefn3C8EKyaGojwvQXCUL3w2HYSoM
         sbTAcfG2v+8E8eXF20ElQ2rK53u/CDvFdt08GJIr9/q+CaHq+8IwVCqV8M4ZSWhSTPby
         OeeDuOGSUdi8MNtXu9zxs+nqVGXn9+xEAyHYEZNOE9jF2Iz77lJ0Y6AIMXK//1H+kEqB
         1RS+J13YcDKwL3nz2zqo3gaDlYAOrw1t3feu2xM1Fc6OvSzaKFl7T+tm3yKne+fysy5I
         5Ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ISoVzo30KTxkKbgntnjEzX9bz05YR46K02jdZNC3TaU=;
        b=ta9d7lZOOg2AVWazUPl9HGlSBpe8YDN4aRZFrB71SpAvom7tWw7ua8scylkPHKW1YP
         FFYYO/+fbdb+6cYU00+FvZjXMM5ZS98afdavPcn6yMoWD4YMk4VdGWjxzo9kMYIgtdoz
         +OWl0mMR9NoQydSlKbEzyaLEgd8bijsZLRyCsoQEGbIvj7hn9WoiMlow6ez+jLy9/4R6
         LjXVjAE/IklEhEOm+GlA6t4TnojImjFnCJW/7y1VriOQhl0IG6WZ1x2WTkXktcNgmrdC
         2FVeCYFtvPguUhoYPRJaCDQmIUAWI28Pvd21nFLBMGOTSCHo5lubATyB2oBx+auHNg5K
         /s3w==
X-Gm-Message-State: AOAM533gQHdJS42TSTwJrpVpnljqD+omG9f5+YfGVhd2F9hlXARtaKQ0
        pnZgyzP3NyX7eFSaVDUGCenpyKTq6oMbVTGk6442Dw==
X-Google-Smtp-Source: ABdhPJzWCXdiwn3EcVpM8ycUtK9/imSHblBwP8ivXDCy87PCGcZIE2F/uB02LCjxIa3NV6sOAi+1dktx9uwdxxr9/04=
X-Received: by 2002:aa7:d3c7:: with SMTP id o7mr16809295edr.288.1630995274819;
 Mon, 06 Sep 2021 23:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvMaHgSied79QBs3D=eDVETGH=3gxA8owCSRj313yEhVg@mail.gmail.com>
 <YTTbD+BKRpd0g4hq@kroah.com> <CA+G9fYs-K2f+eZW55u5uh1gQedTQpm=TGDNk7K1uOk8AeDNUQA@mail.gmail.com>
 <YTXMsxY9I6VdtVsS@kroah.com> <CA+G9fYvzqidCJYOoA9eX4ayf9HGyJ_jBjMS42NuuzFK_tFAmzg@mail.gmail.com>
In-Reply-To: <CA+G9fYvzqidCJYOoA9eX4ayf9HGyJ_jBjMS42NuuzFK_tFAmzg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Sep 2021 11:44:23 +0530
Message-ID: <CA+G9fYv_guwJLpk+8poPKsSw7NOxw9-AXuEDy=iceXimfStxfQ@mail.gmail.com>
Subject: Re: kernel/kexec_file.o: failed: Cannot find symbol for section 10: .text.unlikely.
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > > > Is this a regression?  Has this compiler ever been able to build this
> > > > arch like this?
> > >
> > > Yes. It is a regression with gcc-11.
> > >
> > > stable rc Linux 5.13.14 with gcc-11 - powerpc - FAILED
> > > stable rc Linux 5.13.14 with gcc-10 - powerpc - PASSED
> >
> > Ah, ok, and does 5.14 or newer work properly?
>
> No.
> stable rc Linux 5.14.1-rc1 with gcc-11 - powerpc - FAILED
> stable rc Linux 5.14.1-rc1 with gcc-10 - powerpc - PASS
>
>
> I will check Linux mainline and Linux next and get back to you.

Since we started building with gcc-11 last weekend and started
noticing these build failures on stable-rc, mainline and next.
and today's stable-rc review also failed with these combinations.

Linux next master with gcc-11 - powerpc-defconfig - FAILED
Linux mainline master with gcc-11 - powerpc-defconfig - FAILED
stable rc Linux 5.14.2-rc1 with gcc-11 - powerpc-defconfig - FAILED
stable rc Linux 5.13.15-rc1 with gcc-11 - powerpc-defconfig - FAILED
stable rc Linux 5.10.63-rc1 with gcc-11 - powerpc-defconfig - FAILED

FYI,
The following powerpc config build PASS with gcc-11
  - allnoconfig
  - mpc83xx_defconfig
  - tqm8xx_defconfig
  - maple_defconfig
  - cell_defconfig
  - ppc64e_defconfig
  - ppc6xx_defconfig


- Naresh
