Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05A2545E38
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 10:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346487AbiFJIKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 04:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347160AbiFJIKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 04:10:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5419B21E0DA
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 01:10:14 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o17so22220535pla.6
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 01:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Op5/ggJsSrehbqC+BruYT1bRk3fdI6WFMobiv3gO5v0=;
        b=RcY98n5KQc482rXcaauvp937vKRvX/vDwRqjGwBX/Jrwcsg1fHS5RjFTzOxongzTLH
         0oGyclp8Ee+tiKF0oPgVKmZCv8jmbRGrwx0xG82FKZO7Pg/pdghUfb6PwfgfpBk32cPJ
         mu4PW0g8+wYkT8cEJet0xQoYn+xAxVsMX/QjNySb3eGCLB2iaPMxqLJfY4T4JmmBkNq0
         AMjZ4Arx+fobRYTwfBlm536x0AWj1VkoFKvky8ywtgc6kmjjrz8e0O11hn7mmL3+kdWC
         YaT1MoTLWFS1MQhiiejWzfhrhkTghLFvkwCiKTTHmaCpWjYDyNEiFTQj/KYGpmmfwVBg
         GJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Op5/ggJsSrehbqC+BruYT1bRk3fdI6WFMobiv3gO5v0=;
        b=sXDzPJFKpVtdGAQNm1scPgAagZBo1bTcYCfGaAx/8KYKSIkL9H3R0tdDeQz1TXjr0i
         GNDRN1wqxAuDVLZUhmYJHA+66qqutppNiCN9JsUyCLWu4C5M9NkrNshbMF4EW0kZwMll
         sLfvYd4/jiXvBZtBP4aUUlCyKbYVzl0SSNsgIfC9Cu3G2zhI7ENwfZ45xCeTf2zbc6gJ
         NKIBNburUWccSj7sUVhzJir9AAuujxE9zH/tlXrqVdfD/KZ1zcyCr8YHywCEjat9V9ou
         CXRgjGi5n1dnqPLMPimINJ+7UUavJ99z2/eow4ZRbGij7ebScQ0DaVaQ1GgdGp0AdkFA
         QBwQ==
X-Gm-Message-State: AOAM531tmdrvaoMkGAalCpuu19SEL/nk6atI5/4V8FztKTxTgS054UYw
        Vgb+osdNsYHyeXGMMh44s7Vi5FkhpdgRb0ILMUs0Dw==
X-Google-Smtp-Source: ABdhPJymOlOvJSE5HVkqUR2T9KWyNTOX8xKRRAHJzsu0KP3rM98JNbOFUaF4ejUZIVOuwohMpUILxJqAVsEr+cnXFpE=
X-Received: by 2002:a17:902:ba88:b0:168:8dc5:75a1 with SMTP id
 k8-20020a170902ba8800b001688dc575a1mr15522760pls.27.1654848613487; Fri, 10
 Jun 2022 01:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220603173816.944766454@linuxfoundation.org> <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
In-Reply-To: <YqLTV+5Q72/jBeOG@kroah.com>
From:   Oleksandr Tymoshenko <ovt@google.com>
Date:   Fri, 10 Jun 2022 01:10:02 -0700
Message-ID: <CACGj0Ciq3G5dfZSmMgfzcaWUjr5c0XAzb-Fc743VnJM3y2Di+Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     keescook@chromium.org, sarthakkukreti@google.com,
        snitzer@kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 9, 2022 at 10:15 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > I believe this commit introduced a regression in dm verity on systems
> > where data device is an NVME one. Loading table fails with the
> > following diagnostics:
> >
> > device-mapper: table: table load rejected: including non-request-stackable devices
> >
> > The same kernel works with the same data drive on the SCSI interface.
> > NVME-backed dm verity works with just this commit reverted.
> >
> > I believe the presence of the immutable partition is used as an indicator
> > of special case NVME configuration and if the data device's name starts
> > with "nvme" the code tries to switch the target type to
> > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> >
> > The special NVME optimization case was removed in
> > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > affected.
> >
>
> Why wouldn't 4.9, 4.14, and 4.19 also be affected here?

Just a bad choice of words on my side: we use only 5.x branches and
it slipped my mind to verify all actively supported branches. 4.19 is likely
to be affected, it has the same code for the NVME optimization as 5.4.
4.9 and 4.14 doesn't  this code so probably not affected.

> Should I also
> just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> immutable singleton target on NVMe") to those older kernels?  If so,
> have you tested this and verified that it worked?

I don't have enough expertise in this domain to recommend a solution, that's
why I reported the problem instead of sending a patch. I did take a quick look
though: it doesn't apply cleanly and it seems that the 9c37de297f65 was removed
as a result of some other refactoring, so I think it's more complex
than backporting
a single commit.

>
> thanks,
>
> greg k-h
