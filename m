Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770E62EB048
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbhAEQiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729490AbhAEQiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:38:54 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97359C061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 08:38:13 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id y23so151995wmi.1
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 08:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=irzzoxh3kSKuihinApZxXyfw2zEu9XBXOpRK9V6qciM=;
        b=JG6scUWUepdKRKpdQy8YcrbE0/McyZ0Ukl+4+Bs9MW8USQtYSLrxrmHGhbrtBDfB0p
         tKG2c8LJwmcfso266Waoi2UF8qh6TZ6MixxoZqWjCvagvq+BmVLslxtDMGkn+W0egXJO
         GJnlrxlZ/pY3VviQ+jDv+KuDT5aVn4gq18lpRCNolbo88ioDNHmU9Qstz1bDHdyfZsD6
         +nzxhdhIjtpImpW+4nez5wmhSrSEzOJ0jUE8iTVcU5s2Kxe748QuiRuwEQh1laIGVjOo
         C0GSln2bBDvK2IsCoK5Y8AkevZ8oZIWfvGUlaKi2RNhRU5g5WcPR1WnQIlhYwHSYeZ9y
         89Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irzzoxh3kSKuihinApZxXyfw2zEu9XBXOpRK9V6qciM=;
        b=PlBrdLyOLVqOODd0i3rP9hL+SudiAlzkUxJHp6+Gj6cQ24fdqvvmlFQbDWFIUyrBaZ
         VaMC5dRd9qQdFdqaN3h8i756ocrR36PKR4w5RGsXLZH/iRb6D6z9sCqjW6EHSnj07lwH
         KDGQ3XpWBeyeQPSN/vVocCwq43De4eH3xVzvftUmHV8lUgQh1zattdhHvygYXXJTuFTH
         42AWXcv4286IngQrt3+s9XlUwmFAKzdxMYA8HxP32qapOfCceX6YOne1lXziNr8xqrOm
         I76lz1HCeF+bJE4pBH5xxCmiKjW4aWqDuCwTCyrXjdSKpreY3bN8c1Ur928YZ63X8Zrw
         WdHQ==
X-Gm-Message-State: AOAM531RmFfcIgi7D53c3P63KR1gN/Z00qYh8GeYTqmYpslh06pncYyY
        II5yycLY3uhViLoCJMuwFa2kPwWUfBQOVZeh1r/Rfg==
X-Google-Smtp-Source: ABdhPJz1PJ378azSpxGCNl4VfTbo9j8YqUtpYCqMqCKfkMIaHAFkSUslNeJH38bvyDVhu3boGmRUtzyBCoTh7rnRlIE=
X-Received: by 2002:a1c:bc57:: with SMTP id m84mr4208725wmf.163.1609864692179;
 Tue, 05 Jan 2021 08:38:12 -0800 (PST)
MIME-Version: 1.0
References: <20201230193323.2133009-1-surenb@google.com> <X+2XQ1JRPSeKLtkK@kroah.com>
In-Reply-To: <X+2XQ1JRPSeKLtkK@kroah.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 5 Jan 2021 08:38:01 -0800
Message-ID: <CAJuCfpFJuC9DAEPmaXO+Cx508k1h4=ZJhKh3gw6YAE+aXZCjwA@mail.gmail.com>
Subject: Re: [PATCH 0/2] backports for slab-out-of-bounds issue in ip6_xmit()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 31, 2020 at 1:16 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 30, 2020 at 11:33:21AM -0800, Suren Baghdasaryan wrote:
> > We received a slab-out-of-bounds report in ip6_xmit() for KASAN build on 4.9
> > kernel. The patches that fix this issue have been backported to to stable 4.14
> > and one of them even to 3.16 but 4.9 stable branch does not include them.
> > Backport to linux-4.9.y required trivial merge conflict resolution. They
> > cleanly apply to linux-stable linux-4.9.y branch tagged v4.9.249.
> >
> > Paolo Abeni (2):
> >   net: ipv6: keep sk status consistent after datagram connect failure
> >   l2tp: fix races with ipv4-mapped ipv6 addresses
> >
> >  net/ipv6/datagram.c  | 21 +++++++++++++++++----
> >  net/l2tp/l2tp_core.c | 38 ++++++++++++++++++--------------------
> >  net/l2tp/l2tp_core.h |  3 ---
> >  3 files changed, 35 insertions(+), 27 deletions(-)
>
> Nit, you forgot to sign-off on these patches that you forwarded on.
> Next time remember to do that as you did "touch" them :)
>
> I'll go queue them up now.

Oops, sorry. Will keep in mind for the next time. Thanks for accepting
the patches.
Suren.

>
> thanks,
>
> greg k-h
