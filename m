Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42FE2D24ED
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLHHus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 02:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgLHHus (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 02:50:48 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B58C061749
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 23:50:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id q16so16544842edv.10
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 23:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fOQLy+eUSJxjrr4kN6GZwIjc7QErW79tP61SaQUg2Q8=;
        b=D5EALbChqgbFo4A+nfUAfzSkkaB2AtQtou39anrW2PtrhYoGcmEt8+1c7fIUI8PzLd
         DnnpfDWd+CcpCec6WME1NSCaSVCwecLq+aHInLRzSB/mjLZEYXP+3ONnksouiQa7aZxF
         EfpScSe0W1w487f31fMGEta5QReNWP33RGo9Pi2sOchgzfJhwzJ6+6W99SZuVWdtl0/F
         Oo6SQClIGfNWy3sS4dJCSVSxz4lPnRw+p8ViBykCb5IF1wtRpqc8YWPcC0kd4y8N4YOh
         9MMDtX4hJoSc/RkGKkSguz80ne5d3lTN9QP85REMu9vrWf5cEu/be16w0fUgyebJQP8X
         3MhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fOQLy+eUSJxjrr4kN6GZwIjc7QErW79tP61SaQUg2Q8=;
        b=RCRxjrppAVR5ycPWNfPNLBaoKlqERqCOQclCx95gxZQy7rNhJLMIiXzhI+Np3K2WPP
         Folc2+G6Pp+tI0+5FAZjPbk5fNYKOuFeJFjoe7uWbyXObR5n4pdP61VzOV5z2yy43cYk
         AOriDUoYUaK4idCuA2DHROBX3bN5TcekrLmK9ezZEw6N77HVi1xSSOMXVUBYRl4fpxgH
         Ildn7HA0gDXw2nQc50WyDL7W1dthcnijcK33OdiP/WtuBxfiQmiM5FOQDQnZI7e7vpEQ
         3e0YPORAwJoEljta4bKwnm+fPDBCKoe2vXZdbjB7an6OL3yKKxExJDNXXbjO2EHnb8X1
         eclA==
X-Gm-Message-State: AOAM532oyZlIAf1o2s0eXaGasnrGtlT15Pi3nZD5z01gI6Xet7F6Ai+A
        UTT5mkO6k2Au3AQ6ODPeN6+jTjjXaH408H6HeJSktA==
X-Google-Smtp-Source: ABdhPJxoMbhHkSM7LS2dCFmI9//DZsMN09CBHiuY7vllq3z7zwRpYK3CPWd3hlZltyHyPFz8suG8pnGVwP+ANXUDkG8=
X-Received: by 2002:a05:6402:48d:: with SMTP id k13mr23280219edv.92.1607413806399;
 Mon, 07 Dec 2020 23:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20201204182846.27110-1-kamal@canonical.com> <20201207224238.GA28646@ascalon>
In-Reply-To: <20201207224238.GA28646@ascalon>
From:   David Verbeiren <david.verbeiren@tessares.net>
Date:   Tue, 8 Dec 2020 08:49:50 +0100
Message-ID: <CAHzPrnGAYe6YwObkLfvc4+FLXe2ANE9Aq+snUOm2re5NyysLzA@mail.gmail.com>
Subject: Re: [5.4.y] selftests/bpf build broken by "bpf: Zero-fill..."
To:     Kamal Mostafa <kamal@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kamal, Sasha,

On Mon, Dec 7, 2020 at 11:42 PM Kamal Mostafa <kamal@canonical.com> wrote:
>
> On Fri, Dec 04, 2020 at 10:28:46AM -0800, Kamal Mostafa wrote:
> > Hi Sasha-
> >
> > This v5.4.78 commit breaks the tools/testing/selftests/bpf build:
> >
> > [linux-5.4.y] c602ad2b52dc bpf: Zero-fill re-used per-cpu map element
> >
> > Like this:
> >
> >       prog_tests/map_init.c:5:10: fatal error: test_map_init.skel.h: No such file or directory
> >           5 | #include "test_map_init.skel.h"
> >
> > Because tools/testing/selftests/bpf/Makefile in v5.4 does not have the
> > "skeleton header generation" stuff (circa v5.6).
> >
> > Reverting c602ad2b52dc from linux-5.4.y fixes it.
>
> Another option would be to just drop the selftest from linux-5.4.y,
> but keep the beneficial change to kernel/bpf/hashtab.c.
>
> (We're leaning towards that approach for Ubuntu).
>
>  -Kamal

An alternative could be to use the initial version of the selftest I had
proposed before learning about the skeleton approach.

You can find it here:
https://lore.kernel.org/bpf/20201029111730.6881-1-david.verbeiren@tessares.net/

I also think it would be good to keep the fix of course.

-David
