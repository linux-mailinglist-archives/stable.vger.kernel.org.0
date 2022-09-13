Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542D75B7619
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiIMQHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiIMQHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:07:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5800D9A9EE
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 08:03:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dv25so28134276ejb.12
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5FUF54Y4NaAbaa34w73SJGGq0Vi7AN0bd4YpF9sz5hU=;
        b=ZycqV0+YG6Fe27KzUu1E0xIj9GHkbRprApyLK7iMFWx2HIfMc0jYxpEGRGb/GFwXMH
         KziwDCXPlXP9vwV8la9e2tTgAk+O/8wCuPl/VBfMCSXakkoZVjKk6Gr7itZtMTyw0FDi
         O1n4rG/F441XAXAGhvuz8ZZCeD++QFsu0+jb0eGzQnU7zfnPx/FF5YdOC6PZduv3eGFT
         x5L4OD12G5jTuH3ncaUHkpLDxxgWBfKn7411zYTUFr7L0MZwOTjC47coW7tJikZhj0qs
         OGOm3jdfzw7n8H+AuCRdXZaItMOc/0T5S1C8bDQOmIvSzzocqrr+T5qrO0X+ez0lv09Y
         QCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5FUF54Y4NaAbaa34w73SJGGq0Vi7AN0bd4YpF9sz5hU=;
        b=7uoj9KbG2oALwFmldY/ZYnSBWDKWZpxE8aoIm8rcu+BgQr3n0JeZ08igdXsdANqFmN
         iZeeivsqORWuxtDAMja9rsA+M6Ow7UrrP7v1D/fQHinxfRSGo+p1pG1XK+QcPbLAjx7D
         bcxK5CAD7A4ssDuj4NSu9rWH2IaJjdPb2/47S4BszoswYAUN8UDhtlTTttOEU+57OW0u
         uikzLS3UN+P9eAMBSjbFOcsOqSpkDgRrrC5SSgXj3xw/4vjK/wcLpgONuI/lIPjM+/If
         nnHONLV+kNht5r5afPkWRwVtq/d6z4AlKBwZMOshx1NeJ9yH4QU83P1ASfPjZIq5eUbR
         KoTA==
X-Gm-Message-State: ACgBeo16+Wvx30TbqR21MNf4YgumZJBnoQAE6fohLLglvfog+ZIlSH7h
        N95+rKUDGZbRJnecJ8AuGhVcGwdiZcUBnzygcFvxZpLi5vQz4w==
X-Google-Smtp-Source: AA6agR5xWCPdFVsZwEUswCX9Hazc5xjNGX0LL+5kGVbXGNn0bNlxIHJTbqQy9VV7NGjawM+qUsEmAz5M1mcCq1iOgXc=
X-Received: by 2002:a17:906:cc0d:b0:77a:c170:3019 with SMTP id
 ml13-20020a170906cc0d00b0077ac1703019mr11867361ejb.253.1663078969873; Tue, 13
 Sep 2022 07:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
 <YyCMtuuft3Uc4ka7@sashalap>
In-Reply-To: <YyCMtuuft3Uc4ka7@sashalap>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Sep 2022 19:52:38 +0530
Message-ID: <CA+G9fYvnc4q4kFGWEYHounj1a7PdQ8f4AefgjUFqNVn9d6h8kA@mail.gmail.com>
Subject: Re: stable-rc: 5.4: cgroup.c:2404:2: error: implicit declaration of
 function 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
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

On Tue, 13 Sept 2022 at 19:29, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Sep 13, 2022 at 04:48:44PM +0530, Naresh Kamboju wrote:
> >On stable-rc 5.4 arm and arm64 builds failed due to following errors / warnings.
> >
> >kernel/cgroup/cgroup.c:2404:2: error: implicit declaration of function
> >'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
> >        cpus_read_lock();
> >        ^
> >kernel/cgroup/cgroup.c:2404:2: note: did you mean 'cpuset_read_lock'?
> >include/linux/cpuset.h:58:13: note: 'cpuset_read_lock' declared here
> >extern void cpuset_read_lock(void);
> >            ^
> >kernel/cgroup/cgroup.c:2417:2: error: implicit declaration of function
> >'cpus_read_unlock' [-Werror,-Wimplicit-function-declaration]
> >        cpus_read_unlock();
> >        ^
> >kernel/cgroup/cgroup.c:2417:2: note: did you mean 'cpuset_read_unlock'?
> >include/linux/cpuset.h:59:13: note: 'cpuset_read_unlock' declared here
> >extern void cpuset_read_unlock(void);
> >            ^
> >2 errors generated.
> >
> >drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation;
> >statement is not part of the previous 'if' [-Wmisleading-indentation]
> >         */     mutex_lock(&dev->struct_mutex);
> >                ^
> >drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
> >        if (!drm_core_check_feature(dev, DRIVER_LEGACY))
> >        ^
> >1 warning generated.
> >
> >Build link:
> > - https://builds.tuxbuild.com/2EfrNYbejRQczhhqndawRkHARHZ/
> >
> >
> >Steps to reproduce:
> >-------------------
> ># To install tuxmake on your system globally:
> ># sudo pip3 install -U tuxmake
> >#
> >
> >tuxmake --runtime podman --target-arch arm64 --toolchain clang-nightly
> >--kconfig defconfig LLVM=1 LLVM_IAS=1
>
> Hm, I can't reproduce this one, (and can't install tuxmake on the work
> machine). What's the actual config that you end up using here?

The "defconfig" for arm64 with clang nightly.

- Naresh

>
> --
> Thanks,
> Sasha
