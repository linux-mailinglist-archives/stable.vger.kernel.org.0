Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD3D4A77
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 00:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfJKWs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 18:48:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56887 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbfJKWs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 18:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570834136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7RgpO7SkaYhR0wNjaRJqhAx6MtC43nqgY8XsTUlipHM=;
        b=afAbI0SoKPtHKqm3EeJMjp/mwwoy2tEVFANnhUavaK3gVzSM++2bbBNHJ2MXuiPRMSkHAe
        woFGQ/ND6LtT44f8MxK1wWQ7wIVjbnPL3OrhalgWChe9KjJMq8Vhow9BdbyoYJkTR0fdVR
        zpvP197YydJZ6IJeJN6HciLnxyEdkl8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-LdIk47asN0ab1lEDZqfL_g-1; Fri, 11 Oct 2019 18:48:54 -0400
Received: by mail-qk1-f197.google.com with SMTP id h4so10429669qkd.18
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 15:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sldpp1aOhl8UuH/6Wbt+hAC3+th/BbJ+jr5E9+Cj7TI=;
        b=MZLKEbJoXMXUCRIUANkmXdnno0VAM3cra5fUDufxp6C1/ZHlTNQXZTl6affhwIelmY
         IimyLWrSk2JZWHohpLOU+pgcEIxlhEJivk+tEVnAT0nRv2lF3PdU7IEr0vOUWOqD5vU2
         7Q3s9C63L/G9ZstbVZiAcCEph7qaA5uVgDAS2Ux/C2ozOkUe6IMUfB2yknu4Ak77Q46p
         t7ckJ9k1Ik9IY+nEgEJnYrewdQKby1VmXtAj6W7H/2Q93wYuafRa6fMAstw+sl4mKWkz
         fhMWWOB0EJJgBJ8viodAwPDfnXSLjk2Sk9SSw3a0dsLydOdt8kA2wl6KuHZZbojAVucE
         qnhQ==
X-Gm-Message-State: APjAAAU5kJUTzj4WgvGXPM7gEZGocXXqxR/57G6RDPXmD5o1MsQe4BKz
        Mi8veHWgBn4mPR4Q9d58r6O8H2YulrFKna9Auq32UzFxsPkROG4UOQbVUOYxBUj7uLawcykFVtT
        KeGyHCFjK4+QWiCiJpWUFzTXhUSncPJPd
X-Received: by 2002:a05:620a:13d9:: with SMTP id g25mr18415093qkl.230.1570834134403;
        Fri, 11 Oct 2019 15:48:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYCJuWwjQ9jUl8ON7adae0YZppASmE9AJmk/LEgyO+Pp7I4eJH4Vr9z/bEQRoh5e10ZPsVeVRLSO7fu9mBthA=
X-Received: by 2002:a05:620a:13d9:: with SMTP id g25mr18415070qkl.230.1570834134123;
 Fri, 11 Oct 2019 15:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws> <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws> <20191011203509.GG229325@dtor-ws> <20191011213349.GJ229325@dtor-ws>
In-Reply-To: <20191011213349.GJ229325@dtor-ws>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 12 Oct 2019 00:48:42 +0200
Message-ID: <CAO-hwJ+mMco-gw4Wt=cCAb5v1XymTiS2HNtzQqtmqMoRCiuueQ@mail.gmail.com>
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
X-MC-Unique: LdIk47asN0ab1lEDZqfL_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 11:34 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Fri, Oct 11, 2019 at 01:35:09PM -0700, Dmitry Torokhov wrote:
> > On Fri, Oct 11, 2019 at 01:33:03PM -0700, Dmitry Torokhov wrote:
> > > On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrote:
> > > > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrot=
e:
> > > > > > Hi Andrey,
> > > > > >
> > > > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@g=
mail.com> wrote:
> > > > > > >
> > > > > > > To simplify resource management in commit that follows as wel=
l as to
> > > > > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit(=
) switch
> > > > > > > driver code to use devres to manage the life-cycle of FF priv=
ate data.
> > > > > > >
> > > > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > > > Cc: linux-input@vger.kernel.org
> > > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > > Cc: stable@vger.kernel.org
> > > > > >
> > > > > > This patch doesn't seem to fix any error, is there a reason to =
send it
> > > > > > to stable? (besides as a dependency of the rest of the series).
> > > > > >
> > > > > > > ---
> > > > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++-----=
----------
> > > > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/h=
id-logitech-hidpp.c
> > > > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff=
_device *ff)
> > > > > > >         struct hidpp_ff_private_data *data =3D ff->private;
> > > > > > >
> > > > > > >         kfree(data->effect_ids);
> > > > > >
> > > > > > Is there any reasons we can not also devm alloc data->effect_id=
s?
> > > > > >
> > > > > > > +       /*
> > > > > > > +        * Set private to NULL to prevent input_ff_destroy() =
from
> > > > > > > +        * freeing our devres allocated memory
> > > > > >
> > > > > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > > > > kfree(ff->private), when the data has not been allocated by
> > > > > > input_ff_create(). This seems to lack a little bit of symmetry.
> > > > >
> > > > > Yeah, ff and ff-memless essentially take over the private data as=
signed
> > > > > to them. They were done before devm and the lifetime of the "priv=
ate"
> > > > > data pieces was tied to the lifetime of the input device to simpl=
ify
> > > > > error handling and teardown.
> > > >
> > > > Yeah, that stealing of the pointer is not good :)
> > > > But OTOH, it helps
> > > >
> > > > >
> > > > > Maybe we should clean it up a bit... I'm open to suggestions.
> > > >
> > > > The problem I had when doing the review was that there is no easy w=
ay
> > > > to have a "devm_input_ff_create_()", because the way it's built is
> > > > already "devres-compatible": the destroy gets called by input core.
> > >
> > > I do not think we want devm_input_ff_create() explicitly, I think the
> > > fact that you can "build up" an input device by allocating it, then
> > > adding slots, poller, ff support, etc, and input core cleans it up is
> > > all good. It is just the ownership if the driver-private data block i=
s
> > > not very obvious and is not compatible with allocating via devm.
> > >
> > > >
> > > > So I don't have a good answer to simplify in a transparent manner
> > > > without breaking the API.
> > > >
> > > > >
> > > > > In this case maybe best way is to get rid of hidpp_ff_destroy() a=
nd not
> > > > > set ff->private and rely on devm to free the buffers. One can get=
 to
> > > > > device private data from ff methods via input_get_drvdata() since=
 they
> > > > > all (except destroy) are passed input device pointer.
> > > >
> > > > Sounds like a good idea. However, it seems there might be a race wh=
en
> > > > removing the workqueue:
> > > > the workqueue gets deleted in hidpp_remove, when the input node wil=
l
> > > > be freed by devres, so after the call of hidpp_remove.
> > >
> > > Yeah, well, that is a common issue with mixing devm and normal resour=
ces
> > > (and workqueue here is that "normal" resource), and we should either:
> > >
> > > - not use devm
> > > - use devm_add_action_or_reset() to work in custom actions that work
> > >   freeing of non-managed resources into devm flow.
> >
> > Actually, there is a door #3: use system workqueue. After all the work
> > that Tejun done on workqueues it is very rare that one actually needs
> > a dedicated workqueue (as works usually execute on one if the system
> > worker threads that are shared with other workqueues anyway).
>
> And additional note about devm:
>
> I think all HID input drivers that are using devm in probe, but do not
> have proper remove() function (and maybe even some with remove) are
> broken: hid_device_remove() calls hid_hw_stop() which potentially will
> shut off the transport. This happens before devm starts unwinding, so
> we still can be trying to communicate with the device in question, but
> the transport is gone.

Well, that is by design. A driver is supposed to call hid_hw_start()
at the very end of its .probe(). And the supposed rule is that in the
specific .remove(), you are to call first hid_hw_stop() to stop the
transport layer underneath. That also means that in the HID subsystem,
at least, you are not supposed to talk to the device during the devm
teardown of the allocated data.

If you really need to communicate with the device during tear down,
then you are supposed to write your own .remove, in which you control
where the hid_hw_stop() happens.

We might have overlooked one or two, but I think we are on a good basis for=
 now.

>
> io_started/driver_input_lock is broken on removal as well as we release
> the lock when driver may very well be still talking to the device in
> devm teardown actions.

Again, this is not supposed to happen. Once hid_hw_stop() is called,
we do not have access to the transport, so drivers can't talk to the
device. So releasing/clearing the locks is supposed to be safe now.

>
> I think we have similar kind of issues in other buses as well (i2c, spi,
> etc). For example, in i2c we remove the device from power domain before
> we actually complete devm unwinding.
>

I agree that this looks bad.

I would need to have a better look at it on Monday. Time to go on week
end (this jet lag doesn't help me to go to sleep...)

Cheers,
Benjamin

