Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7166C2CF2
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCUItZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCUIsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:48:22 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABFC457DD;
        Tue, 21 Mar 2023 01:47:44 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id t9so16966345qtx.8;
        Tue, 21 Mar 2023 01:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KruUtqbakgoiLoS6bu/IIVfyo+6WwhLB7vUVbzmCkl8=;
        b=s1M++kDgP/dMLy3cGlNiMxfFTCKDpnZ/k2ZzjzDF+G4Van1CKOFKP8JuPLvR6xxBJ2
         xY5DvldpIhAzq5F6QbSR3tAPkmRWuyOZl0VleAubJ7Bd0dotWnI8rYcuHoN5SOsQSPc1
         ULlFx87cKWBnrBxD1eQWo/KhX+Xa7TbmnDtp+j6d8Fbu823Ve5rNV2iJZVygQi4kEp5b
         7LViXxZXDvZlvmqStNVpcuSoTPxblioV9uj/Lkoe3Rivk5Ams6C9i4O4dpMtfOwN62tA
         FBKeorSI5d8GFBPKDuiU+frLtgnk7QO0P/ag+DQeYRNB0tX34GER8/VsKYQs4vramq/a
         sMtA==
X-Gm-Message-State: AO0yUKXFGMYLwdIFAk3wcmLWRzhxeDsU7lGyamfCwG6GCftYRg9EGcdM
        WBArp3FiW5TA8qxVXx2XP4Zt0ec7jtrBNw==
X-Google-Smtp-Source: AK7set93NwBYEmkeNxNDS3LPVln0Z26q4oQFrFnOpJjF9vix0OnY8TnZ2QNbxGSRUORGduxzLJIpbg==
X-Received: by 2002:ac8:5941:0:b0:3df:6b5:d12c with SMTP id 1-20020ac85941000000b003df06b5d12cmr3364132qtz.32.1679388463081;
        Tue, 21 Mar 2023 01:47:43 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id j9-20020ac874c9000000b003dffd3d3df5sm4228421qtr.2.2023.03.21.01.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:47:42 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-536af432ee5so269277967b3.0;
        Tue, 21 Mar 2023 01:47:42 -0700 (PDT)
X-Received: by 2002:a81:b64e:0:b0:52f:184a:da09 with SMTP id
 h14-20020a81b64e000000b0052f184ada09mr1387959ywk.2.1679388462447; Tue, 21 Mar
 2023 01:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230320231310.28841-1-rdunlap@infradead.org> <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
 <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
 <CAMuHMdW-oxpoHubUJUpsjG9aXtQ3MMwAopN-hS+Mf0gN1udhig@mail.gmail.com> <fa8b4f3ca8f3d9dc0487399962bcc6ef75ebd6b0.camel@physik.fu-berlin.de>
In-Reply-To: <fa8b4f3ca8f3d9dc0487399962bcc6ef75ebd6b0.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 09:47:31 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV-hAcf+uaWvLdXef6jOUHWV04u0FS2dGHxtJArG6c_Wg@mail.gmail.com>
Message-ID: <CAMuHMdV-hAcf+uaWvLdXef6jOUHWV04u0FS2dGHxtJArG6c_Wg@mail.gmail.com>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Adrian,

On Tue, Mar 21, 2023 at 9:45 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Tue, 2023-03-21 at 09:42 +0100, Geert Uytterhoeven wrote:
> > On Tue, Mar 21, 2023 at 9:10 AM John Paul Adrian Glaubitz
> > <glaubitz@physik.fu-berlin.de> wrote:
> > > On Tue, 2023-03-21 at 08:55 +0100, Geert Uytterhoeven wrote:
> > > > On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > > > > SYS_SUPPORTS_SMP and SMP.
> > > >
> > > > Perhaps because these SoCs do not support SMP?
> > >
> > > Well, there is actually a dual-core 7786 board available, see:
> > >
> > > > https://www.apnet.co.jp/product/superh/ap-sh4ad-0a.html
> > >
> > > Quoting:
> > >
> > > »The SH7786 is equipped with a dual-core SH-4A and has interfaces such as
> > >  DDR3 SDRAM, PCI Express, USB, and display unit.«
> >
> > SH7786 is dual-core...
> >
> > > FWIW, I just realized we need this for config CPU_SUBTYPE_SH7786 as well.
> >
> > ... and CPU_SUBTYPE_SH7786 selects CPU_SHX3, which selects
> > SYS_SUPPORTS_SMP and SYS_SUPPORTS_NUMA in turn.
> > So everything is fine for SH7786.
>
> Yeah, this explains it then. Your new patch is definitely the better approach
> and I would prefer it over Randy's suggested change. Let's see what the mm
> maintainers have to say.

I'm sure the missed condition was just an oversight, so I expect no
objections.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
