Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8C549EF9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiFMUZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349197AbiFMUMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:12:53 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826842B24C
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 11:47:54 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l204so11317929ybf.10
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 11:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsdBov/MfW4IF8QaVyvbBe5SpJ9VLnOIPPifgKOz4eM=;
        b=OJN7ovTDyp1JSSfA1IgYlk1HUwE3PmjRkGRMcTDWzUFiENAD4G0/KIaDAarraJRXFs
         sgOSjKZbzERVm35QO4qULhh8xG9i6qhKJBuoyLWaCZ8yFkohrvWY4uEskAUhxMdgW5o1
         K1xW316v3Xb6zFCeydNbsLe1L4XcyjIGRq8keDYTAqz9cn2H5q7rQdjl7zGHtTw6DX4+
         pC6YZJ9V5n0abwbTloguEU+kyJDuZ/0gJRuINpAS13A8C74HbTlLNM2qlRtmm6EAHvWk
         ZRP7o60SpiM6pdRKFBN4c6o79bsdCABZ7DvNJ3A+ER6TVMFik3mfBHacdz9oPVKTa2X3
         HAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsdBov/MfW4IF8QaVyvbBe5SpJ9VLnOIPPifgKOz4eM=;
        b=VbLieia+XslNO7RDKBh9lNP3AKyEWhDzFEV/iQoxGs4dWTeEZeddnKyLpgyEvDsXJu
         GI4vzXwFQI5fn1erWRFxEvkcTzO9fsikalHQbrsc1xFM5oCs7viloee7aX+m1shXtaCS
         2SlueyKruwseA2a/o7JXq/5D3AyroNIO80JldxdjkitHonUvvuMBmEdDxkdeKWrfuaS0
         7/IXgn7r90tzUSJjYr0R/RM4X4eBsgz5QdDYTUdH3pLMZmAsK733HwpEdy4X5DccMBmU
         CGRR3TGpHPUFtX5ghRny3AGObpBWP1psfjtELszu6AWkyT4oqLWjvZ1/Rx8OoId5YR2X
         XPGg==
X-Gm-Message-State: AJIora9RsGULvR1MMJRZu3fEUAL0xRrEnNWo8TB8mylrp2shYVYcHY8h
        R+/JNQFL2SJZtYhP/oxv3QFFTP2yvbwiGDIEJLnfrA==
X-Google-Smtp-Source: AGRyM1tgBB8t+j8QMxsgFE0jtS3O9LJ+KEK0yflNgFwJK2UZemT5uBErO4AtFJqYH6aU7ufG0ufuTSZ9iUaT1G9yjc8=
X-Received: by 2002:a25:d649:0:b0:65c:9e37:8bb3 with SMTP id
 n70-20020a25d649000000b0065c9e378bb3mr1016555ybg.387.1655146073254; Mon, 13
 Jun 2022 11:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <165514310715077@kroah.com>
In-Reply-To: <165514310715077@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Jun 2022 11:47:41 -0700
Message-ID: <CANn89iJreCRnQaWERyKCkdG5zKYP_DnnWVi8sOMw2g-Kw8c-uQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tcp: fix tcp_mtup_probe_success vs wrong
 snd_cwnd" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Neal Cardwell <ncardwell@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Yuchung Cheng <ycheng@google.com>,
        linux-stable <stable@vger.kernel.org>
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

On Mon, Jun 13, 2022 at 10:58 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

I will take care of this backport to 5.10


> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 11825765291a93d8e7f44230da67b9f607c777bf Mon Sep 17 00:00:00 2001
> From: Eric Dumazet <edumazet@google.com>
> Date: Fri, 27 May 2022 14:28:29 -0700
> Subject: [PATCH] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
>

Thanks.
