Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B3D5E61
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbfJNJNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 05:13:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48421 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730656AbfJNJNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 05:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571044425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34II/on4waWLD+AT6/fHfeUHDpP5c8H+QWQEVyMZsQg=;
        b=OOUv8RSsdKS0w6QsbRl9OYfDh4vaC3Lc71rvj1LSNsn6zue162QEq/dfisEf365iPyL+nR
        fPENwgmPVsHIIFDWRLlrTCxjhZGYjL+q6F7n0YLrI0i0BKlyEIq2d+6P/uxQLfyub41wMH
        U+KrZvDX5J/XO6eiTGcJfeZt063TF8A=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-iTnrJ9pFNI2lR6NySvVbDQ-1; Mon, 14 Oct 2019 05:13:44 -0400
Received: by mail-qt1-f199.google.com with SMTP id k53so17348048qtk.0
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 02:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kkqamdzMGjTC8Hhxob4h4wgXhNnIZdao0EdTy0NL9nA=;
        b=Zoueo7RU48lhg/AQ5WAlzmpuMa/78aVIu+Dc6Ng/6JPh/ePQdrkz3QkwSnIHClYaMx
         r37+3gyXj3XPJj0C75DHJRcTz3K3rvX8KBljP6yXUCaYpGIaImm93805eRsQ6g0NCknV
         JXmYpIPHBtZR7pQZMAdSIdeiHqYlDRJVEKDkCMcty97nxvgx9H7EKhg83fHy03IBjmkR
         fm5PciDnwR1ba2/RM55pXBl4PQr1OoNDKP3v2zWrmJpIuy4//MToWwD/t1bipPhXES6z
         sRubmMzSaDA1gIrH0TXBtfQXSCLmUZzAtVEn++U9dom3Djh4MQMINKssVraeoGc9DCwR
         tnKQ==
X-Gm-Message-State: APjAAAXqR6t+vfZb+OZHCOdE4vQdMvry+CiEF4wuTSYBMHMTL55cqcjW
        Rotgn89kLN9hbowgJ/NWd6gXaRSoR870l1/mi6nQ2YbjSbiLd+hiP0NNVkmlRH+BPNvmdsM4bj5
        X8IjFOsJsEsuFVS9iQOpJZFQokRhk2ULd
X-Received: by 2002:a0c:abcc:: with SMTP id k12mr30518443qvb.101.1571044423977;
        Mon, 14 Oct 2019 02:13:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEvE/lalSm0r+wnMFwJlARJrtv9KhQRdQyG3r2+1sU2VEF5jndY+oC4t9v5CAWIkdk0XxwI4rHTsTS2S3sDIA=
X-Received: by 2002:a0c:abcc:: with SMTP id k12mr30518406qvb.101.1571044423645;
 Mon, 14 Oct 2019 02:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws> <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws> <20191011203509.GG229325@dtor-ws>
 <20191011213349.GJ229325@dtor-ws> <CAO-hwJ+mMco-gw4Wt=cCAb5v1XymTiS2HNtzQqtmqMoRCiuueQ@mail.gmail.com>
 <20191011232354.GK229325@dtor-ws>
In-Reply-To: <20191011232354.GK229325@dtor-ws>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 14 Oct 2019 11:13:32 +0200
Message-ID: <CAO-hwJJPDcTF_zWy4-MFm7_PLjx2BaUWh8pmoYq42zrqtQcbsg@mail.gmail.com>
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
X-MC-Unique: iTnrJ9pFNI2lR6NySvVbDQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 1:24 AM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Sat, Oct 12, 2019 at 12:48:42AM +0200, Benjamin Tissoires wrote:
> > On Fri, Oct 11, 2019 at 11:34 PM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 01:35:09PM -0700, Dmitry Torokhov wrote:
> > > > On Fri, Oct 11, 2019 at 01:33:03PM -0700, Dmitry Torokhov wrote:
> > > > > On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrot=
e:
> > > > > > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > > > > > <dmitry.torokhov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires =
wrote:
> > > > > > > > Hi Andrey,
> > > > > > > >
> > > > > > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirn=
ov@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > To simplify resource management in commit that follows as=
 well as to
> > > > > > > > > save a couple of extra kfree()s and simplify hidpp_ff_dei=
nit() switch
> > > > > > > > > driver code to use devres to manage the life-cycle of FF =
private data.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > > > > > Cc: linux-input@vger.kernel.org
> > > > > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > >
> > > > > > > > This patch doesn't seem to fix any error, is there a reason=
 to send it
> > > > > > > > to stable? (besides as a dependency of the rest of the seri=
es).
> > > > > > > >
> > > > > > > > > ---
> > > > > > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++-=
--------------
> > > > > > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/h=
id/hid-logitech-hidpp.c
> > > > > > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struc=
t ff_device *ff)
> > > > > > > > >         struct hidpp_ff_private_data *data =3D ff->privat=
e;
> > > > > > > > >
> > > > > > > > >         kfree(data->effect_ids);
> > > > > > > >
> > > > > > > > Is there any reasons we can not also devm alloc data->effec=
t_ids?
> > > > > > > >
> > > > > > > > > +       /*
> > > > > > > > > +        * Set private to NULL to prevent input_ff_destro=
y() from
> > > > > > > > > +        * freeing our devres allocated memory
> > > > > > > >
> > > > > > > > Ouch. There is something wrong here: input_ff_destroy() cal=
ls
> > > > > > > > kfree(ff->private), when the data has not been allocated by
> > > > > > > > input_ff_create(). This seems to lack a little bit of symme=
try.
> > > > > > >
> > > > > > > Yeah, ff and ff-memless essentially take over the private dat=
a assigned
> > > > > > > to them. They were done before devm and the lifetime of the "=
private"
> > > > > > > data pieces was tied to the lifetime of the input device to s=
implify
> > > > > > > error handling and teardown.
> > > > > >
> > > > > > Yeah, that stealing of the pointer is not good :)
> > > > > > But OTOH, it helps
> > > > > >
> > > > > > >
> > > > > > > Maybe we should clean it up a bit... I'm open to suggestions.
> > > > > >
> > > > > > The problem I had when doing the review was that there is no ea=
sy way
> > > > > > to have a "devm_input_ff_create_()", because the way it's built=
 is
> > > > > > already "devres-compatible": the destroy gets called by input c=
ore.
> > > > >
> > > > > I do not think we want devm_input_ff_create() explicitly, I think=
 the
> > > > > fact that you can "build up" an input device by allocating it, th=
en
> > > > > adding slots, poller, ff support, etc, and input core cleans it u=
p is
> > > > > all good. It is just the ownership if the driver-private data blo=
ck is
> > > > > not very obvious and is not compatible with allocating via devm.
> > > > >
> > > > > >
> > > > > > So I don't have a good answer to simplify in a transparent mann=
er
> > > > > > without breaking the API.
> > > > > >
> > > > > > >
> > > > > > > In this case maybe best way is to get rid of hidpp_ff_destroy=
() and not
> > > > > > > set ff->private and rely on devm to free the buffers. One can=
 get to
> > > > > > > device private data from ff methods via input_get_drvdata() s=
ince they
> > > > > > > all (except destroy) are passed input device pointer.
> > > > > >
> > > > > > Sounds like a good idea. However, it seems there might be a rac=
e when
> > > > > > removing the workqueue:
> > > > > > the workqueue gets deleted in hidpp_remove, when the input node=
 will
> > > > > > be freed by devres, so after the call of hidpp_remove.
> > > > >
> > > > > Yeah, well, that is a common issue with mixing devm and normal re=
sources
> > > > > (and workqueue here is that "normal" resource), and we should eit=
her:
> > > > >
> > > > > - not use devm
> > > > > - use devm_add_action_or_reset() to work in custom actions that w=
ork
> > > > >   freeing of non-managed resources into devm flow.
> > > >
> > > > Actually, there is a door #3: use system workqueue. After all the w=
ork
> > > > that Tejun done on workqueues it is very rare that one actually nee=
ds
> > > > a dedicated workqueue (as works usually execute on one if the syste=
m
> > > > worker threads that are shared with other workqueues anyway).
> > >
> > > And additional note about devm:
> > >
> > > I think all HID input drivers that are using devm in probe, but do no=
t
> > > have proper remove() function (and maybe even some with remove) are
> > > broken: hid_device_remove() calls hid_hw_stop() which potentially wil=
l
> > > shut off the transport. This happens before devm starts unwinding, so
> > > we still can be trying to communicate with the device in question, bu=
t
> > > the transport is gone.
> >
> > Well, that is by design. A driver is supposed to call hid_hw_start()
> > at the very end of its .probe(). And the supposed rule is that in the
> > specific .remove(), you are to call first hid_hw_stop() to stop the
> > transport layer underneath. That also means that in the HID subsystem,
> > at least, you are not supposed to talk to the device during the devm
> > teardown of the allocated data.
> >
> > If you really need to communicate with the device during tear down,
> > then you are supposed to write your own .remove, in which you control
> > where the hid_hw_stop() happens.
> >
> > We might have overlooked one or two, but I think we are on a good basis=
 for now.
>
> You have to be _very_ careful there. For example, we can take a look at
> hid-elan.c. If you notice, it uses devm_led_classdev_register() to
> create "mute" led and it needs to talk over HID to control it;s
> brightness/state. So the driver has custom remove() and calls
> hid_hw_stop() from it. But the LED will be unregistered much later (in
> the depth of the driver core) so users of LED subsystem are free to send
> requests through and the driver will try to talk to the device even
> after hid_hw_stop() is called and the io_started/driver_input_lock is
> reset/released.
>
> I am sure there are more such examples.

Yep, this is problematic. There is no guard in
elan_mute_led_set_brigtness() which tells us that the bus has been
stopped, so we likely have an issue here.

Note that a .remove() that just calls hid_hw_stop() should be removed,
as hid core can do it for us.

>
> >
> > >
> > > io_started/driver_input_lock is broken on removal as well as we relea=
se
> > > the lock when driver may very well be still talking to the device in
> > > devm teardown actions.
> >
> > Again, this is not supposed to happen. Once hid_hw_stop() is called,
> > we do not have access to the transport, so drivers can't talk to the
> > device. So releasing/clearing the locks is supposed to be safe now.
>
> Except that it is hard to enforce once you throw in devm.
>
> >
> > >
> > > I think we have similar kind of issues in other buses as well (i2c, s=
pi,
> > > etc). For example, in i2c we remove the device from power domain befo=
re
> > > we actually complete devm unwinding.
> > >
> >
> > I agree that this looks bad.
> >
> > I would need to have a better look at it on Monday. Time to go on week
> > end (this jet lag doesn't help me to go to sleep...)
>
> I wonder if every bus should open a new devm group for device and
> manually release it after calling ->remove(). That would ensure that all
> devm resouces allocated by drivers will be freed before we start
> executing bus-specific code.
>

That would be indeed useful. There is no reasons I can think of for a
resource to be created during the .probe() of a device that should
stick around after its .remove().

In the Elan case above, it won't solve all of the issues, as there
will still be a tiny window where the resource will get access to the
bus when it has been stopped.
Maybe adding an other group when we call hid_hw_start() that will be
freed by hid_hw_stop() before the actual stop to the bus could come to
the rescue....

Cheers,
Benjamin

