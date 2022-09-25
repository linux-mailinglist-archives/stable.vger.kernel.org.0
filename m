Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EBE5E939F
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 16:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiIYOcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 10:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIYOcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 10:32:45 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91512CCB2;
        Sun, 25 Sep 2022 07:32:42 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3450990b0aeso44932097b3.12;
        Sun, 25 Sep 2022 07:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=jqCM4Tw0SjP4ntDGVVw2bf91oVLVAILXblqbgeaqRzM=;
        b=TI86nt62XRAYj79RHwfVVQVu60YM/wN/P/4QSUVJ+2qamFklY3tcm8lwM8nvDHdpil
         yD/NiLmNMHJ9ALq4iuQc+IIg3s9ELaIvOKLQwfamYYxUT9ma4Qx4csupnakAF1orRCC9
         jWZ4ZeCO1s2JZjDMdtvSXraI1auuTrsLnfQHU9SLsjWwkmKIxoR0+PG1HcdFlyKTCA+H
         GBT5bQp6xT/nQKqMgNd/jMq1naX/z8QWS1cslEjrUMnoz9ZTAwzj4A51PnmLxfYEQ4MM
         u0xpPk/k0I0vTMnSvObFIII72Ugobo8gjYeH6IwK2FLeVhEp3SYYy/f2ftiW/RcIzWYu
         NY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jqCM4Tw0SjP4ntDGVVw2bf91oVLVAILXblqbgeaqRzM=;
        b=lDErUPP93DwkrKNswtnL9nGECwsBLkbYVpFEdgovvrZ3UlLZVX6oTUPy7SPbo4cvDS
         UxvsQe/t5Cbd7kGBFZyQg5uoE6gDzt4eGTQR28mUl/z+jb8eDM1FJHsTdNr5DiEu0Coy
         Eyh3Si20wGJnFsAwbR/zy6wVfjilIEiLQnxIFJVRjc1hHYwMN8n2VC51LX9f0M6tNky7
         fStEIQ4eJn/Yqri/43j1s3kbjUDw6UmXIBbtidA1xDshg62dwdzBh8ozh255XIA9nZGk
         aah6WqUued2Hvb2c5ktUgPvXdvKk4klCPlLP4wOOyUfj6MJRBu5o1SDphmf5xqBGX/vk
         Aq+g==
X-Gm-Message-State: ACrzQf0ImluHFkmCktR96HgapxLMKr+EvMR9UThTdtgsIpi2Rbgqy1h/
        nax7vmomLjBUWbWcF9E0+mWYPOvv0laHPJOwv0w=
X-Google-Smtp-Source: AMsMyM70uMdZ0VWvbez6Ui6wEkFi/l+VSeGshTDFEOp3/J5oA+Tu44P5kaYFGr9wp1CwboIqdjgBJsDezhRprYZ+7wA=
X-Received: by 2002:a81:99d7:0:b0:350:931f:99e with SMTP id
 q206-20020a8199d7000000b00350931f099emr5268129ywg.325.1664116361883; Sun, 25
 Sep 2022 07:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <Yyn7MoSmV43Gxog4@kroah.com> <20220925103529.13716-1-yongw.pur@gmail.com>
 <20220925103529.13716-2-yongw.pur@gmail.com> <YzA04ZZI/1OH8oRT@kroah.com>
In-Reply-To: <YzA04ZZI/1OH8oRT@kroah.com>
From:   yong w <yongw.pur@gmail.com>
Date:   Sun, 25 Sep 2022 22:32:32 +0800
Message-ID: <CAOH5QeBiSEe03KNge9voJ-HjKbNLDoeY2PfKC7HE7F6z-92d7A@mail.gmail.com>
Subject: Re: [PATCH v2 stable-4.19 1/3] mm/page_alloc: use ac->high_zoneidx
 for classzone_idx
To:     Greg KH <gregkh@linuxfoundation.org>, jaewon31.kim@samsung.com
Cc:     linux-kernel@vger.kernel.org, mhocko@kernel.org,
        stable@vger.kernel.org, wang.yong12@zte.com.cn,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B49=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 19:00=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Sep 25, 2022 at 03:35:27AM -0700, wangyong wrote:
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > [ backport of commit 3334a45eb9e2bb040c880ef65e1d72357a0a008b ]
>
> This is from 5.8.  What about the 5.4.y kernel?  Why would someone
> upgrading from 4.19.y to 5.4.y suffer a regression here?
>
I encountered this problem on 4.19, but I haven't encountered it on 5.4.
However, this should be a common problem, so 5.4 may also need to be
merged.

Hello, Joonsoo, what do you think?

> And why wouldn't someone who has this issue just not use 5.10.y instead?
> What prevents someone from moving off of 4.19.y at this point in time?
>
This is a solution, but upgrading the kernel version requires time and over=
head,
so use the patch is the most effective way, if there is.

Thanks.
> thanks,
>
> greg k-h
