Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7245D4A65
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 00:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfJKWer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 18:34:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbfJKWer (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 18:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570833285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xaCx4BwzuaSKoJi0tA/bbvHgniT7bfXHnSLmKvXpCng=;
        b=ReFIbOUnN6TxyRF4LyoSnv0eqZHvWOHc0/DHT/FkCtpsWv+htaf3UzcS9TSVolJFn8SOed
        XLKDLNNU+DjdlM4sJEhi2bwOxhWgWyxN+VXgbB34oeL/zhCZHo+m1+2ITECm/88Tl61pZG
        0lptM71aN84bMjVANBPrRi/8mWqUnbQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-0mI0foO1NO-iXj0vM02hHg-1; Fri, 11 Oct 2019 18:34:42 -0400
Received: by mail-qk1-f199.google.com with SMTP id 10so10475174qka.2
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 15:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fEQj8SZLHc+CmCdZ+zyTylgWZdpd8h+Hxcmb3WKQW5g=;
        b=bHsyZbZIXTSkQl1LrcIuhTL9usfu1pEOYWtZiRM2u1miW9Tu3r7c8DLaoBW8LF5US9
         zIGK60+x+KiPA/oKfXHbyRfgRUgIUXYNgkF5K+mk1HZk3FvgWlIQGCHiqIcT5gIx5hxJ
         yko+cXIi8QUAnCjrrjU4Nd3AqLEtT/Nibl6Kw/k3PRwBZiXfskx06/OksKpYSH9onuQd
         psBTV976GxhIjmE8UgvkPxWhUuYLL1wDDN0ekuYteiquIitPjx73Cq6nHgcsI8hXQYc2
         JJXD26IRFWavoMzw1jQYPpSa9+2TGlgQiZ+RrzFpgkfWcQE29dDoUkMEVWH/fGZm9gSP
         0jmA==
X-Gm-Message-State: APjAAAXv1P1Q6MeyCqYn8ncxpLxkTwqyT5WQvHCsoAQyWmSkF7e1JpGp
        tiF9mZTZQxaQfSnuENNyxrRBptp8lIWcy282WsqecnnLPghUSYdUzitxr3JLlZgGjOXbKymWdVu
        vX3tprko7qJpC4lJdO6PV3oqUxr94JwJX
X-Received: by 2002:ae9:f306:: with SMTP id p6mr18364130qkg.169.1570833281888;
        Fri, 11 Oct 2019 15:34:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwvhWhTVnY0bQbU5FLUra35SXn4osvVdIvE5sR87ye0HFij3OUzJB2adPIfKQacKwhQxrtuQXh3zR3VLNTTlIU=
X-Received: by 2002:ae9:f306:: with SMTP id p6mr18364103qkg.169.1570833281628;
 Fri, 11 Oct 2019 15:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws> <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
In-Reply-To: <20191011203303.GF229325@dtor-ws>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 12 Oct 2019 00:34:30 +0200
Message-ID: <CAO-hwJJjiMdKMGoAEyxXN0+Kc0mBPC_KZn-YoHBx8gWfD=RM3g@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: 0mI0foO1NO-iXj0vM02hHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 10:33 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrote:
> > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > > > Hi Andrey,
> > > >
> > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail=
.com> wrote:
> > > > >
> > > > > To simplify resource management in commit that follows as well as=
 to
> > > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() sw=
itch
> > > > > driver code to use devres to manage the life-cycle of FF private =
data.
> > > > >
> > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > Cc: linux-input@vger.kernel.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > This patch doesn't seem to fix any error, is there a reason to send=
 it
> > > > to stable? (besides as a dependency of the rest of the series).
> > > >
> > > > > ---
> > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------=
------
> > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > >
> > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-l=
ogitech-hidpp.c
> > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_dev=
ice *ff)
> > > > >         struct hidpp_ff_private_data *data =3D ff->private;
> > > > >
> > > > >         kfree(data->effect_ids);
> > > >
> > > > Is there any reasons we can not also devm alloc data->effect_ids?
> > > >
> > > > > +       /*
> > > > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > > > +        * freeing our devres allocated memory
> > > >
> > > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > > kfree(ff->private), when the data has not been allocated by
> > > > input_ff_create(). This seems to lack a little bit of symmetry.
> > >
> > > Yeah, ff and ff-memless essentially take over the private data assign=
ed
> > > to them. They were done before devm and the lifetime of the "private"
> > > data pieces was tied to the lifetime of the input device to simplify
> > > error handling and teardown.
> >
> > Yeah, that stealing of the pointer is not good :)
> > But OTOH, it helps
> >
> > >
> > > Maybe we should clean it up a bit... I'm open to suggestions.
> >
> > The problem I had when doing the review was that there is no easy way
> > to have a "devm_input_ff_create_()", because the way it's built is
> > already "devres-compatible": the destroy gets called by input core.
>
> I do not think we want devm_input_ff_create() explicitly, I think the
> fact that you can "build up" an input device by allocating it, then
> adding slots, poller, ff support, etc, and input core cleans it up is
> all good. It is just the ownership if the driver-private data block is
> not very obvious and is not compatible with allocating via devm.

Yep, that's what I meant: input_ff_create() already handles its
cleanup, so there is no point in devm_input_ff_create() as the input
core should clean it up for us.

Cheers,
Benjamin

>
> >
> > So I don't have a good answer to simplify in a transparent manner
> > without breaking the API.
> >
> > >
> > > In this case maybe best way is to get rid of hidpp_ff_destroy() and n=
ot
> > > set ff->private and rely on devm to free the buffers. One can get to
> > > device private data from ff methods via input_get_drvdata() since the=
y
> > > all (except destroy) are passed input device pointer.
> >
> > Sounds like a good idea. However, it seems there might be a race when
> > removing the workqueue:
> > the workqueue gets deleted in hidpp_remove, when the input node will
> > be freed by devres, so after the call of hidpp_remove.
>
> Yeah, well, that is a common issue with mixing devm and normal resources
> (and workqueue here is that "normal" resource), and we should either:
>
> - not use devm
> - use devm_add_action_or_reset() to work in custom actions that work
>   freeing of non-managed resources into devm flow.
>
> Thanks.
>
> --
> Dmitry

