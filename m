Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7942D5446
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 08:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgLJG7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 01:59:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52187 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387710AbgLJG7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 01:59:31 -0500
Received: from mail-lf1-f70.google.com ([209.85.167.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1knFua-0008JW-Tc
        for stable@vger.kernel.org; Thu, 10 Dec 2020 06:58:49 +0000
Received: by mail-lf1-f70.google.com with SMTP id x186so1676838lff.7
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 22:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L3A0R6apZIlQ4MauaRQv2JjDtm7Zsbt8WUqDJ99fqIs=;
        b=dS5R84+vpeDjH0ASCWuy72D/3tfTq1J0X8MkG0bcZkMAzpvBf9CSAx6TaQroANmE6p
         xw1uTNLfYnPSiKF0/tXmALDu8GCquitC1K5XJRpmHP9gKmU/AL85/5QkStME1veLic7o
         M0sA+ADO7EaNcqKVonxSwMwZLwl1Ets+COC69AcV2kRklxqGtKXonOKwEq6j7X01nNlZ
         V6/6nEOegXI8sByUcf9Krm6bDN1mVHT17GJNf7mL+DavUXEOY5rFz3yINMgZ2hZ8KQ7C
         pQoOqH21IJiimpszJ5szegBQ8zdaXEgA8vTN/xQ3hvzeLUv/cPhEtCro0FdqGl0ttzuR
         joyg==
X-Gm-Message-State: AOAM530Tgo9l2CM3W7rw/2o7sKLkEdmb/bkaH1/oiIlmnRzw4ufewzEg
        wNKORF4LbQfnKn9O+s+9ulWim3jwkUDKY2k1EzTJ5a8DJmjfC30s5EIq251kvP/iYOgw883CKfy
        wZ+RdgbYLBGe67i0QvosboHyBXMDcB5VHZeRnemrZV80pOQjX
X-Received: by 2002:ac2:4f88:: with SMTP id z8mr2361698lfs.447.1607583528347;
        Wed, 09 Dec 2020 22:58:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5A/SlOYhsOI2nAgwQ6lA2KuEngLOcJCfAoIOQD4hakMkFb/V+mpw6qvi8YWHLyuAkJv+TagdmYkT340JypSs=
X-Received: by 2002:ac2:4f88:: with SMTP id z8mr2361691lfs.447.1607583528101;
 Wed, 09 Dec 2020 22:58:48 -0800 (PST)
MIME-Version: 1.0
References: <20201210061415.35591-1-po-hsu.lin@canonical.com>
 <20201210061415.35591-2-po-hsu.lin@canonical.com> <X9HCfmaRyU3DBTCM@google.com>
In-Reply-To: <X9HCfmaRyU3DBTCM@google.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Thu, 10 Dec 2020 14:58:37 +0800
Message-ID: <CAMy_GT88Yez9diOcfYeDE0zMPK9QydQQp_h+OjrWOS5LKKCeRQ@mail.gmail.com>
Subject: Re: [X/B/F/G/H/Unstable][SRU][PATCH 1/1] Input: i8042 - add ByteSpeed
 touchpad to noloop table
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Kernel team list <kernel-team@lists.ubuntu.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 2:39 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Hi Po-Hsu,
>
> On Thu, Dec 10, 2020 at 02:14:15PM +0800, Po-Hsu Lin wrote:
> > BugLink: https://bugs.launchpad.net/bugs/1906128
> >
> > It looks like the C15B laptop got another vendor: ByteSpeed LLC.
> >
> > Avoid AUX loopback on this touchpad as well, thus input subsystem will
> > be able to recognize a Synaptics touchpad in the AUX port.
> >
> > BugLink: https://bugs.launchpad.net/bugs/1906128
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > Link: https://lore.kernel.org/r/20201201054723.5939-1-po-hsu.lin@canonical.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > (cherry picked from commit a48491c65b513e5cdc3e7a886a4db915f848a5f5)
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>
> Why are you forwarding this again?

Oops,
I forgot to add the --suppress-cc flag when sending this out to the
Ubuntu kernel mailing list.
Sorry for the noise.

Regards

>
> > ---
> >  drivers/input/serio/i8042-x86ia64io.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> > index 82ff446..1f45010 100644
> > --- a/drivers/input/serio/i8042-x86ia64io.h
> > +++ b/drivers/input/serio/i8042-x86ia64io.h
> > @@ -223,6 +223,10 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
> >                       DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
> >                       DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
> >               },
> > +             .matches = {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
> > +                     DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
> > +             },
> >       },
> >       { }
> >  };
> > --
> > 2.7.4
> >
>
> Thanks.
>
> --
> Dmitry
