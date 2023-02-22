Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6A69F381
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBVLi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBVLi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:38:28 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E4723874
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:38:27 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-536b7ffdd34so105347897b3.6
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bOFMHxEbDuda+ha5jo8EUi5bhvzaU3kBX9JPmVfnwwU=;
        b=SCX26gQPU6K2/6G+RuZgCro2GRjt6vR2NHb6u3NPi8Gbc7qBCbTYKiMX6bXzJLt0Zz
         ufQ9/x9Q/ggrU33tC1iOhWnmtC8a1h5rOOLdmMQOwQHu7mJh/SaYHPXKDUggPJqKIkhA
         Dqm7KRARIpu8dka2GRlxdJqK7UMsh+AHeGpATW1bS/GEOopTSrHpEJZl4TTNP/tXgCzj
         nxXkmpRjrYw4fFhp3QX0g6rbPJFT2MfHE+1boKil1h3OSeJ/Tikk/i9jGC+OZo7fSWZX
         WFGohpF6KgG2mbzwoq0gcUGt3mRtC42WbF0zPnPIUI1R86ajyqwr2xQptd+mnIqIGAuP
         Qmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOFMHxEbDuda+ha5jo8EUi5bhvzaU3kBX9JPmVfnwwU=;
        b=i9FAtb4Xmiq0HUW91aLUWe/UW6iQ6M1OZ9Z5lUZmzp0FFd9PPPN6AVOAuCZURVXqMV
         uoEtAVvNuVKhC57QFNiKY4EMBp767+VO4sywOlUlI5+ia2kkBjGU61wEKzV004p0tMhR
         f3naFzglmtZQl0qBtqCjr6xt4RI8psrjULriK/CB3LBzIt/Fj6j9QbFEW4gPaJ/DeRHb
         HHsu24ZBvy/FkABmnzxunB5SHVkSwLxrdr2fqZR1Xu+0oN2FL/G74poCgmYjnXtlKnTT
         EAkXa3vliemLsUEcetsc0ukvZ4GxAg3zfKY8zWCzec/rA0KCOBvTf/fJCYiV2QcAJqtV
         bXmA==
X-Gm-Message-State: AO0yUKW+nLGZBYv7Hq7v8sVV1LiGJFSv+u61NhrCFIOdv4ShV8jRTlgO
        UN2oqAsh1fR2EuCY23OsvfmUyJeeaT/GijvOdZiONg==
X-Google-Smtp-Source: AK7set8L836O1GrK2yytC/0gupKKz7jQgjMIoD+h93kD+ScGVfc4itf6JSmOVh8pjYh8ygaA1zehiODPB1uAsKDs/Dw=
X-Received: by 2002:a0d:c2c1:0:b0:527:b779:b531 with SMTP id
 e184-20020a0dc2c1000000b00527b779b531mr3520348ywd.458.1677065906326; Wed, 22
 Feb 2023 03:38:26 -0800 (PST)
MIME-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org> <20230222112141.278066-2-maennich@google.com>
 <Y/X76CbLPwEE2BRG@kroah.com>
In-Reply-To: <Y/X76CbLPwEE2BRG@kroah.com>
From:   =?UTF-8?Q?Matthias_M=C3=A4nnich?= <maennich@google.com>
Date:   Wed, 22 Feb 2023 11:38:10 +0000
Message-ID: <CAJFNNnq2VWOSHLs=iUpJoWLpjAWMVRzQAn5S=dQGzZObHyaktQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
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

On Wed, Feb 22, 2023 at 11:26 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Feb 22, 2023 at 11:21:39AM +0000, maennich@google.com wrote:
> > From: Nathan Chancellor <nathan@kernel.org>
> >
> > Currently, scripts/pahole-flags.sh has no formal maintainer. Add it to
> > the BPF section so that patches to it can be properly reviewed and
> > picked up.
> >
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Link: https://lore.kernel.org/bpf/20220201205624.652313-2-nathan@kernel.org
> > Signed-off-by: Matthias Maennich <maennich@google.com>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 4f50a453e18a..176485e625a0 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3407,6 +3407,7 @@ F:      net/sched/act_bpf.c
> >  F:   net/sched/cls_bpf.c
> >  F:   samples/bpf/
> >  F:   scripts/bpf_doc.py
> > +F:   scripts/pahole-flags.sh
> >  F:   tools/bpf/
> >  F:   tools/lib/bpf/
> >  F:   tools/testing/selftests/bpf/
> > --
> > 2.39.2.637.g21b0678d19-goog
> >
>
> No need for MAINTAINERS updates for older kernels as no one should be
> making new patches against them, right?

This one is optional, but it makes the next one apply cleanly and I
picked the entire series.

Cheers,
Matthias

>
> thanks,
>
> greg k-h
