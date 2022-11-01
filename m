Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017866153A1
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 21:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiKAUzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKAUzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 16:55:36 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7D81D66D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 13:55:33 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id 3so15157849vsh.5
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 13:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cqbLWcBIQb8XYE6Q27K1dn/Qss6FqbanMa9ZMLFawV4=;
        b=SdjNIV61+AUiZipfoF7z/c0eF1KHkns1gDf6WR18rSKtwTn3J9NycXKuLaGE/ifLBA
         Q+tkY6+S1b3wJgNBmRXFGueGN2obI2CsTD6SlcPkRQbi8GcAf+GzNGUpUFVDeIxrI7Me
         8HLnbiynOTtlwbs1mQ72Bz1x7KjFhTbHyInElQleif4JZULlD8aDhmx38LBjFwQE9OWu
         TTUEnLtg3EhTZs0biHl3diEQHkWf0XyTHwvg00sgNV/esRjeb1Ml3eDhciGpmfkcwDH6
         U5kibEKCB7ASEKxZpbFa/jvJmsmmpkEeB4lyj+Re2uhnsV6/3CrA1UEZ3HG6rn9xIfJS
         h1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cqbLWcBIQb8XYE6Q27K1dn/Qss6FqbanMa9ZMLFawV4=;
        b=sAG0mkBFn3f61wFA12KaDftYUwNeC4+gjCGhkgDKeROkYAXwn8B4TCrHDobSs1vCwC
         OXkBQNjgU52qcHWjHz28S2e8ykXdfKcmPZPeMDwC8W5nfIJZSFaTux1tQtCXjNi6Vare
         0NpUp19z1sDXveqsjgMJTYq7bt3h8zhcjrjN9b1nD7qvf6p5eSA3wk2oFd3TtqQy4kV8
         DZUGsrbwt+yB9rHpNu4PXhOBP1ltPs82wi+bawF9IstDOKSAR3JlM+L8oeOHh951QbLd
         j+A1xexGGgzko8Bf7JNOv0DyyWyjjHc5FFQ1oLEbvl5U+hKVgny0+SUmZ3gvl7gZtlby
         ej/g==
X-Gm-Message-State: ACrzQf0Yh/RT21T5Ml01wLhg3X9g7XHXKvPjQvWWE4N5cdISS19xHhFX
        BLcFym1InomSPxRdhPfsliXzOqRblWt6auCUNf5hyA==
X-Google-Smtp-Source: AMsMyM6zDilx7lfGrhrvjg9wGn6qEo4r8XjxEXwu+fZr3qoEztNU5zmGwOINFEQZphmHedm1PBqPXpqBFDEu3yFAyzg=
X-Received: by 2002:a67:c398:0:b0:3aa:b87:9326 with SMTP id
 s24-20020a67c398000000b003aa0b879326mr9028289vsj.82.1667336132443; Tue, 01
 Nov 2022 13:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221101005202.50231-1-meenashanmugam@google.com> <Y2F0ct7Dk9Npxrta@kroah.com>
In-Reply-To: <Y2F0ct7Dk9Npxrta@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Tue, 1 Nov 2022 13:55:21 -0700
Message-ID: <CAMdnWFBSu87S4v=RVu0Y8RBau_=WiPkXf35tzpwd37rNn1-ZLg@mail.gmail.com>
Subject: Re: [PATCH 5.15 0/1] Request to backport 3c52c6bb831f to 5.15.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, kuniyu@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 1, 2022 at 12:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 01, 2022 at 12:52:01AM +0000, Meena Shanmugam wrote:
> > The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
> > ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
> > to be a good candidate for the stable trees. This patch didn't apply cleanly
> > in 5.15 kernel, since release_sock() calls are changed to
> > sockopt_release_sock() in the latest kernel versions.
> >
> > Kuniyuki Iwashima (1):
> >   tcp/udp: Fix memory leak in ipv6_renew_options().
> >
> >  net/ipv6/ipv6_sockglue.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
>
> Can you provide a working version for 6.0.y first?  We can not have
> people upgrading to newer kernels and having a regression.
>
> thanks,
>
> greg k-h

I have submitted the patch for 6.0.y as well.
https://lore.kernel.org/all/20221101200505.291406-2-meenashanmugam@google.com/

Thanks,
Meena
