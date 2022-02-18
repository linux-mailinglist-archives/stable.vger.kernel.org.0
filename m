Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C414BB9DE
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiBRNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:11:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiBRNL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:11:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1326115A
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:11:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u12so7110227plf.13
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wo/7v9jYM4ocIRifY0MeIVv01VpZbWGud5FrKmGExyo=;
        b=jw1b9P+uQvdA7zVHp2y9IPS6rauQBxH84UAHzFJ1FugjXmEYP6HcebsbDUtjiVOfbQ
         ZX2bZ85hQ+jW3KFYwDrqpWb2cvqh+5/J3aSJqzpgrnbdDodCpF1pSpgIppKMKY41ezA8
         T+bVhR7/vCIH+7kRvnIUE7TDySmP0oxwE4P0lqdRCUknLZ5JgVemUmdpHcUQyFC+31Jh
         tW6RS+TZRDw5G8C/cTDrgki1ZEdSQJK5x9Ktg6Q/WS64fTvr6OZheKeaWsgW68E7II3I
         KXLi0Ie8b0u9vDtnIJkoA+EbvdLyzP0ynCjEprD+tK2hZj0zTD820adPNvS4PicdJcVE
         Erpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wo/7v9jYM4ocIRifY0MeIVv01VpZbWGud5FrKmGExyo=;
        b=CW/u9isQKFLZIHtGL9XtZK+IYml0KVd3trNRBCbY4PA8011PcPQa5tQcuSbg5bF69W
         1geGQviD6EwoMwwkKqTdRtAEMlyRznE3VFn3M3tPWBZ3j99RCL3Xe44/lM73dsxip8lQ
         iEr6qUIOHMWiHDf6QnfHpQDUpfJoJKq5RKzFUc/TvqLUblINvRf+urf8Ih1QAA4/i6fx
         bSmRc48b3tSzfFbTM0q2BLQC7KXFWxDBYCOMjp8tngFwZv2eMG9SzRjM+tmBj2xou73J
         Z1be0bpYqFkE1LDGq0aZwadheZQEW8i7MJCefAJy4TLZaeDtlxQWWcS/YPuWULD52Oea
         Yrjw==
X-Gm-Message-State: AOAM532wsgP3WHe9SCi9Ny3SDOe7YUs/VQUpfRdmSBQf97/cmO/Wgr/y
        Pc1RvFiYk1gpo61tglbszWiPRi4MRZlMN3BGu6arLA==
X-Google-Smtp-Source: ABdhPJxDEBPGMkac5tL2zrxZboqw22AgXSC0pjrE/1B/cp0toro1ps4DZBQxy6DuWDrzfd0ahMqlUadXYLWIJTHznGM=
X-Received: by 2002:a17:902:7485:b0:14f:3b6:1847 with SMTP id
 h5-20020a170902748500b0014f03b61847mr7393989pll.70.1645189897875; Fri, 18 Feb
 2022 05:11:37 -0800 (PST)
MIME-Version: 1.0
References: <20220218104529.436040-1-jens.wiklander@linaro.org> <Yg+ZJeviMupQrGo4@kroah.com>
In-Reply-To: <Yg+ZJeviMupQrGo4@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Fri, 18 Feb 2022 14:11:27 +0100
Message-ID: <CAHUa44FXN9A+Md0h3i66wiUQ8gQGQXedi=P80Hs_BeVLcOadNg@mail.gmail.com>
Subject: Re: [PATCH backportt 5.16] optee: use driver internal tee_context for
 some rpc
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Lars Persson <larper@axis.com>
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

On Fri, Feb 18, 2022 at 2:03 PM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Feb 18, 2022 at 11:45:29AM +0100, Jens Wiklander wrote:
> > commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream
> >
> > Adds a driver private tee_context to struct optee.
> >
> > The new driver internal tee_context is used when allocating driver
> > private shared memory. This decouples the shared memory object from its
> > original tee_context. This is needed when the life time of such a memory
> > allocation outlives the client tee_context.
> >
> > This patch fixes the problem described below:
> >
> > The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
> > of memory failure seen during kexec reboot") introduced a kernel shutdown
> > regression that can be triggered after running the OP-TEE xtest suites.
> >
> > Once the shutdown hook is called it is not possible to communicate any more
> > with the supplicant process because the system is not scheduling task any
> > longer. Thus if the optee driver shutdown path receives a supplicant RPC
> > request from the OP-TEE we will deadlock the kernel's shutdown.
> >
> > Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
> > Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> > Reported-by: Lars Persson <larper@axis.com>
> > Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> > [JW: backport to 5.16-stable + update commit message]
>
> This and 5.15 backport now queued up.
>
> This needs to go farther back as well, right?

Correct, I'm backporting and testing for the different stable branches.

Cheers,
Jens

>
> thanks
>
> greg k-h
