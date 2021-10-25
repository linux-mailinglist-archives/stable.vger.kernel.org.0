Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137BD43A57C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhJYVK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhJYVK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 17:10:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3435AC061767
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 14:08:04 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n12so4111659plc.2
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 14:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YER+UsEJQB2rlb2mYD8bWyv9AdQVIu6QvEjQhyaqN1c=;
        b=TttYKHsfa91uCLGTprzA0kyqWoaWhfLwimpQgDIgZe1N/IJA2kXpsgkac8ouk+BYs4
         EKnsezQQ+UsOXYL/V9lpN47tgk2Wjot9tCw44Atq+3RizDrWzPvO29vQGVXnPYSXXvKn
         peDcRZXtMGKUkk6Pd/0anNLGezp+NIGXVjuMPo8R/qyQzghV+XXu+SSXUnsgyHOZ169P
         XLaMjHuzySBJ2N5tOw3z4v3lRN4RUiu6qnB24S5ISxhb8dqKgSPydKXVK+Akjh0PkJrB
         obeb2Zj+YCJW5/XT39oSYwZUbYm32m+4jLiEI4Ylu7iHfyNJSKLsBU9G/r5c+AzQ+PN5
         oqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YER+UsEJQB2rlb2mYD8bWyv9AdQVIu6QvEjQhyaqN1c=;
        b=6xRxU2AqULs7owle76VUkUSxMRRIAxrjlrOQY4mukoOIiIwKZc/aTqtMXZMAHdfFUW
         ZfHYc8Ym6t34SmISrXn7IlzATI9HZkhs1p6ixDirLAW2TGbA3kOQ2J4re9k7LihN43fr
         aREcQfZu5rWJlAa1NqRcQF6zPYNqskxTqfzNMkYn83uzeE3zCQ8dQQw1OBwzKUYy7+7U
         I7RAVguDScKqKZzDItj78YVvb7YaSdh5ei2S+KrwH5pV6DoxvPgTnDkuVHy0eIE9xu5d
         Me+LwRyMaIygOGQSg9/yrOE3GpL+PIcAuBiNt/4q1tlitf4d577HPD+9Nkbg0/sGWqoT
         InZw==
X-Gm-Message-State: AOAM532vow6QbMw/yoJZeIL3Kr+zE6q+Ywho/zYTEd8V7/eScm7oVj+r
        IeN7/hlhC9kMcOd0kb7LFu+QoiaULi6vG0mkHQKxkg==
X-Google-Smtp-Source: ABdhPJxqShdDqAKKy1SbM3yhraSEvDAjSHV1/6TvvzeTVYwp4GmmZel+OWlDhAeabm2/QOkqPxDuALY05TfcVKfrP0w=
X-Received: by 2002:a17:90a:d311:: with SMTP id p17mr8951391pju.95.1635196083541;
 Mon, 25 Oct 2021 14:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211025190956.374447057@linuxfoundation.org> <20211025191007.069144838@linuxfoundation.org>
 <20211025205652.GA2807@duo.ucw.cz>
In-Reply-To: <20211025205652.GA2807@duo.ucw.cz>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Mon, 25 Oct 2021 14:07:52 -0700
Message-ID: <CAFd5g47z64vhphWC4Arne4AsxH9roNMuGdfT193wUtrDGAgOsg@mail.gmail.com>
Subject: Re: [PATCH 5.10 70/95] gcc-plugins/structleak: add makefile var for
 disabling structleak
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 1:56 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > [ Upstream commit 554afc3b9797511e3245864e32aebeb6abbab1e3 ]
> >
> > KUnit and structleak don't play nice, so add a makefile variable for
> > enabling structleak when it complains.
>
> AFAICT, this patch does nothing useful in 5.10. Unlike mainline,
> DISABLE_STRUCTLEAK_PLUGIN is not used elsewhere in the tree.

The related patches that Greg picked up use this makefile variable.

Cheers

> Best regards,
>                                                         Pavel
>
> > +++ b/scripts/Makefile.gcc-plugins
> > @@ -19,6 +19,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF)            \
> >               += -fplugin-arg-structleak_plugin-byref
> >  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)  \
> >               += -fplugin-arg-structleak_plugin-byref-all
> > +ifdef CONFIG_GCC_PLUGIN_STRUCTLEAK
> > +    DISABLE_STRUCTLEAK_PLUGIN += -fplugin-arg-structleak_plugin-disable
> > +endif
> > +export DISABLE_STRUCTLEAK_PLUGIN
> >  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)            \
> >               += -DSTRUCTLEAK_PLUGIN
> >
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
