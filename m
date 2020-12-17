Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A8B2DD890
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 19:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgLQSnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 13:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbgLQSnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 13:43:39 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A16FC0617B0
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 10:42:58 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s26so25429258lfc.8
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 10:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7NUIuWcc29XAhs44U0unGtez+GUKQ8v4NObLnMMMLsA=;
        b=mx7R8WMlj7qwCo/5oc/okBGcqQbMg1FfOFbeWqXdd0aETnkp+fb001QcUblgJOfj0G
         Nf6avRedgOYRuipQiK6FkBJy6wnWxn5HhBrERPNMJx4VpoUk46dg5AFt7tr7KDKUt4Ga
         D3TU8SIpNauyYKmq/NYUn2LNVFCOIUAui+fnplUHYMIGXJjqI/lzvoFd/yh+s1bfEYgv
         Iumf1Mv3Ex50/NRBxfWSzDL94S+z70QTMcok11LdeMMPlrcz1IZLAcG910Sm8Q1BhJiu
         1LaiZcHvlHuenrCuUqJd1bM1WV/z/lPljY+fcSIzl9FL+MGHLw5iqTXdKgwDb7keqgHA
         1Wng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7NUIuWcc29XAhs44U0unGtez+GUKQ8v4NObLnMMMLsA=;
        b=pxI8pMjeAu04c9cDT/D3chhGshAprXCLB0aL8nS4dYNHhIIngEUVi7i5T3tMr0/bIn
         50hlDX8Go9R3XM8kXOWDkZgWVoOGnTNqI+mktf5Uj4GGwRd4Q2lEvFYabae/04zLeR4B
         9JQOecJhRiVqjXu+XfTcrYzXJt3OrgrvpZH7ZD4dE6FEh8cK4ocbXMxyyXstfg3MPXSe
         QaWjYeWe6ZmwQEfLUee4j7pmcLW4L8k0W4+d1mmU8DKXl+AogUJ+vcn380yIHxTUgpv7
         eg/xx8CA2RK4Jax+DWNnmOBZ1VNCcYtXUYVNDdydiASX8977HeH0XyATUqoMIHOWSKpj
         EztA==
X-Gm-Message-State: AOAM530074r3hp+/Na/wDJbhCHgCBzfDbkiDMFTHy+eWjDvWT0mR6vzF
        hBdACZ00NJkDTUuTceyfuUOz/6ztruRS+XtjnLUNgtxC5GhLDA==
X-Google-Smtp-Source: ABdhPJxVWi5gqix+VnBa8ML8j5+gKLfpG9o5wdSxpgtfI6wubLZ3enzXSw4dbuUdjDNq58Q8604iIlfBnolwcT4y2rk=
X-Received: by 2002:a2e:2244:: with SMTP id i65mr288265lji.111.1608230576758;
 Thu, 17 Dec 2020 10:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20201205004848.2541215-1-willmcvicker@google.com>
 <X9e5vl+nw4GQNYEw@google.com> <nycvar.YFH.7.76.2012171119240.25826@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2012171119240.25826@cbobk.fhfr.pm>
From:   Will McVicker <willmcvicker@google.com>
Date:   Thu, 17 Dec 2020 10:42:40 -0800
Message-ID: <CABYd82Z-HJfn1Ts=k7RYrvWCHj=1578--9Y7A0giFn2=RRWcVA@mail.gmail.com>
Subject: Re: [PATCH v1] HID: make arrays usage and value to be the same
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        security@kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Will Coster <willcoster@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Great! Thanks for the reply.

--Will

On Thu, Dec 17, 2020 at 2:19 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Mon, 14 Dec 2020, Will McVicker wrote:
>
> > > The HID subsystem allows an "HID report field" to have a different
> > > number of "values" and "usages" when it is allocated. When a field
> > > struct is created, the size of the usage array is guaranteed to be at
> > > least as large as the values array, but it may be larger. This leads to
> > > a potential out-of-bounds write in
> > > __hidinput_change_resolution_multipliers() and an out-of-bounds read in
> > > hidinput_count_leds().
> > >
> > > To fix this, let's make sure that both the usage and value arrays are
> > > the same size.
> > >
> > > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > > ---
> > >  drivers/hid/hid-core.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 56172fe6995c..8a8b2b982f83 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
> > >   * Register a new field for this report.
> > >   */
> > >
> > > -static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
> > > +static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages)
> > >  {
> > >     struct hid_field *field;
> > >
> > > @@ -101,7 +101,7 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
> > >
> > >     field = kzalloc((sizeof(struct hid_field) +
> > >                      usages * sizeof(struct hid_usage) +
> > > -                    values * sizeof(unsigned)), GFP_KERNEL);
> > > +                    usages * sizeof(unsigned)), GFP_KERNEL);
> > >     if (!field)
> > >             return NULL;
> > >
> > > @@ -300,7 +300,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
> > >     usages = max_t(unsigned, parser->local.usage_index,
> > >                              parser->global.report_count);
> > >
> > > -   field = hid_register_field(report, usages, parser->global.report_count);
> > > +   field = hid_register_field(report, usages);
> > >     if (!field)
> > >             return 0;
> > >
> > > --
> > > 2.29.2.576.ga3fc446d84-goog
> > >
> >
> > Hi Jiri and Benjamin,
> >
> > This is a friendly reminder in case this got lost in your inbox.
>
> Hi Will,
>
> I am planning to merge it once the merge window is over.
>
> --
> Jiri Kosina
> SUSE Labs
>
