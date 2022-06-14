Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD654B171
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbiFNMq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiFNMq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:46:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC37A25C5;
        Tue, 14 Jun 2022 05:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57CCDCE1A61;
        Tue, 14 Jun 2022 12:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EC6C3411B;
        Tue, 14 Jun 2022 12:46:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WMWq0Q9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655210780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a24vScTvDuME+U5MDKRIsojxatkHN7usJ0fFarEAOCY=;
        b=WMWq0Q9+Kr2x7BTbvPrsKUi68ujqgjV+JGFj0tYuvAVoS+eBVw3TO4KNpzQScFppRRbBF6
        PDvHsxE8NGzv7vMCGq7zUPX2uMhIkDg6xmVVW9UK+XmHyO3UI9vBQmMwLpM32pGh7XaNng
        PeLoe4R49NxS/5MX4g5/hMS2mehnkBk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 54afb29e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 14 Jun 2022 12:46:20 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id u99so14926003ybi.11;
        Tue, 14 Jun 2022 05:46:19 -0700 (PDT)
X-Gm-Message-State: AJIora+vxzcCyCZm8PCCxcni8zvbjRtzXUA8YGR/HocGudoy6CrFnzKr
        NTiRPS4l5liGaO9tt3CYOZdJeY6Kvr3phBvLwzs=
X-Google-Smtp-Source: AGRyM1uX4casWjYd97Aut7HmBEw607jL45IC028epDHI6yKq25txGW144MeVgT50n2RxIxRCb8PW1oA/d4w/xat42Xs=
X-Received: by 2002:a5b:dcf:0:b0:64a:6923:bbba with SMTP id
 t15-20020a5b0dcf000000b0064a6923bbbamr4978842ybr.398.1655210778879; Tue, 14
 Jun 2022 05:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220614020602.1098943-1-sashal@kernel.org> <20220614020602.1098943-37-sashal@kernel.org>
 <YqhMLdFUi9ioVuam@zx2c4.com>
In-Reply-To: <YqhMLdFUi9ioVuam@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 14 Jun 2022 14:46:07 +0200
X-Gmail-Original-Message-ID: <CAHmME9ptd4eGs_=J8DYPi5Kh_MgFQeO1WoRn=kzu-=PQVdSYpg@mail.gmail.com>
Message-ID: <CAHmME9ptd4eGs_=J8DYPi5Kh_MgFQeO1WoRn=kzu-=PQVdSYpg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 37/43] random: credit cpu and bootloader
 seeds by default
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Small mistake in my comment:

On Tue, Jun 14, 2022 at 10:52 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Sasha,
>
> On Mon, Jun 13, 2022 at 10:05:56PM -0400, Sasha Levin wrote:
> > From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> >
> > [ Upstream commit 846bb97e131d7938847963cca00657c995b1fce1 ]
>
> Two things regarding this commit:
>
> 1) If you're going to AUTOSEL this for 5.18, 5.17, and 5.15, then you
>    also need to do the same for 5.10 also.

This is correct.

>
> 2) If you're going to pick this commit, please also pick its follow-up,
>    e052a478a7daeca67664f7addd308ff51dd40654, which likewise should apply
>    to all four versions.

This is incorrect.

Jason
