Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A672465B278
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 14:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjABND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjABND2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 08:03:28 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715CA2ADA
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 05:03:27 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k19so10927004pfg.11
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 05:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=31zKy5pixYa3mJGrO128QNI8d5q3L7a4Cx80FPZ2xpE=;
        b=FZvs6kYl9XJMp7uxh70zEOcMF5F+r8RMlG9mv3NVsEWKkQig26/v1sMaB4L4Z9FA7v
         ock2ncO0EXTQYktV3/3Z6WM6xnDnAi8F7xBdFWaS4HDMP3xGc8EJgehcdQpy00cJQLN6
         MBZ2EXhypSAi8zrBM2/L+fvxJJoaG0Xg+J2Us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=31zKy5pixYa3mJGrO128QNI8d5q3L7a4Cx80FPZ2xpE=;
        b=RcFY47tqn05iD0sCCTxTGzCPk5ZRSBVl2OSEpQvWdJxHW/ILrs4THuN6SafeaY+26K
         kQi46Cz8N//PcN/gbKt6V0MZ2o8mL8pn5XobUNuZqL32b2ln6vR+ePeX9CF6d0Px+hnA
         zwQKI/XqWNvtvri6h/DTDObwhghCJ8D5B7BOc8VWz2H13RUceBYIUwddskikr140gHTp
         NEoaZRkdhbt8iChD0d9b7WJZjDt/9LveSLDfrvFTQtk6VO3XhL5Uep6TVx4/jdBhgBsh
         hwXO8hv/j3JRVPyP8Kju3OzY9W/HRdf/rGR3kfaqv/OdUYUG3QV4sOoTnnwvBbvuoZ0t
         urwg==
X-Gm-Message-State: AFqh2kooVZH2BQZYadIsoFXcQRoA9BkOiQ7AdtUYOQDqgckw+ZKUBdAJ
        gFJyN5eSyrjyGpxLmXzvS+kuE2pzV1PIaAEDKjk=
X-Google-Smtp-Source: AMrXdXsRVbmQUWEdAKHLkYF8RXr7WYTQEBBsfAv09loH1lXQTDuzEMcV+zr2/ONH58wP1bkv0fOgSg==
X-Received: by 2002:a05:6a00:230d:b0:581:1c:82a3 with SMTP id h13-20020a056a00230d00b00581001c82a3mr36488786pfh.1.1672664606715;
        Mon, 02 Jan 2023 05:03:26 -0800 (PST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com. [209.85.215.171])
        by smtp.gmail.com with ESMTPSA id g25-20020aa796b9000000b0057627521e82sm6217891pfk.195.2023.01.02.05.03.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 05:03:25 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 78so18286358pgb.8
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 05:03:24 -0800 (PST)
X-Received: by 2002:aa7:99cd:0:b0:581:3f7a:8ad0 with SMTP id
 v13-20020aa799cd000000b005813f7a8ad0mr1514401pfi.21.1672664604342; Mon, 02
 Jan 2023 05:03:24 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v4-0-38d7075b03f5@chromium.org>
 <Y6sAO7URJpSIulye@pendragon.ideasonboard.com> <Y6sDKPD8L47ce35u@pendragon.ideasonboard.com>
 <CANiDSCuigeLooqRaDvzEW28pgZu1H42M+oxk_4UEZh=Jue2M8Q@mail.gmail.com> <Y7LUnNlJPpYWGLz9@pendragon.ideasonboard.com>
In-Reply-To: <Y7LUnNlJPpYWGLz9@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 2 Jan 2023 14:03:13 +0100
X-Gmail-Original-Message-ID: <CANiDSCsMcy35dCj3eaLyDwozHM+FA5aPnSKT2PTdMFONPyKT5g@mail.gmail.com>
Message-ID: <CANiDSCsMcy35dCj3eaLyDwozHM+FA5aPnSKT2PTdMFONPyKT5g@mail.gmail.com>
Subject: Re: [PATCH v4] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Jan 2023 at 13:57, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> On Mon, Jan 02, 2023 at 01:45:06PM +0100, Ricardo Ribalda wrote:
> > On Tue, 27 Dec 2022 at 15:37, Laurent Pinchart wrote:
> > > On Tue, Dec 27, 2022 at 04:25:01PM +0200, Laurent Pinchart wrote:
> > > > On Wed, Dec 14, 2022 at 05:31:55PM +0100, Ricardo Ribalda wrote:
> > > > > usb_kill_urb warranties that all the handlers are finished when it
> > > > > returns, but does not protect against threads that might be handling
> > > > > asynchronously the urb.
> > > > >
> > > > > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > > > > control changes asynchronously.
> > > > >
> > > > >  If the code is executed in the following order:
> > > > >
> > > > > CPU 0                                       CPU 1
> > > > > =====                                       =====
> > > > > uvc_status_complete()
> > > > >                                     uvc_status_stop()
> > > > > uvc_ctrl_status_event_work()
> > > > >                                     uvc_status_start() -> FAIL
> > > > >
> > > > > Then uvc_status_start will keep failing and this error will be shown:
> > > > >
> > > > > <4>[    5.540139] URB 0000000000000000 submitted while active
> > > > > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> > > > >
> > > > > Let's improve the current situation, by not re-submiting the urb if
> > > > > we are stopping the status event. Also process the queued work
> > > > > (if any) during stop.
> > > > >
> > > > > CPU 0                                       CPU 1
> > > > > =====                                       =====
> > > > > uvc_status_complete()
> > > > >                                     uvc_status_stop()
> > > > >                                     uvc_status_start()
> > > > > uvc_ctrl_status_event_work() -> FAIL
> > > > >
> > > > > Hopefully, with the usb layer protection this should be enough to cover
> > > > > all the cases.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > > > > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > > > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > > > ---
> > > > > uvc: Fix race condition on uvc
> > > > >
> > > > > Make sure that all the async work is finished when we stop the status urb.
> > > > >
> > > > > To: Yunke Cao <yunkec@chromium.org>
> > > > > To: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > > > To: Max Staudt <mstaudt@google.com>
> > > > > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > To: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > > > Cc: linux-media@vger.kernel.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > ---
> > > > > Changes in v4:
> > > > > - Replace bool with atomic_t to avoid compiler reordering
> > > > > - First complete the async work and then kill the urb to avoid race (Thanks Laurent!)
> > > > > - Link to v3: https://lore.kernel.org/r/20221212-uvc-race-v3-0-954efc752c9a@chromium.org
> > > > >
> > > > > Changes in v3:
> > > > > - Remove the patch for dev->status, makes more sense in another series, and makes
> > > > >   the zero day less nervous.
> > > > > - Update reviewed-by (thanks Yunke!).
> > > > > - Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org
> > > > >
> > > > > Changes in v2:
> > > > > - Add a patch for not kalloc dev->status
> > > > > - Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
> > > > > - Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
> > > > > ---
> > > > >  drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
> > > > >  drivers/media/usb/uvc/uvc_status.c | 6 ++++++
> > > > >  drivers/media/usb/uvc/uvcvideo.h   | 1 +
> > > > >  3 files changed, 10 insertions(+)
> > > > >
> > > > > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > > > > index c95a2229f4fa..1be6897a7d6d 100644
> > > > > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > > > > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > > > > @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
> > > > >
> > > > >     uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > > > >
> > > > > +   if (atomic_read(&dev->flush_status))
> > > > > +           return;
> > > > > +
> > > > >     /* Resubmit the URB. */
> > > > >     w->urb->interval = dev->int_ep->desc.bInterval;
> > > > >     ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > > > > diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> > > > > index 7518ffce22ed..4a95850cdc1b 100644
> > > > > --- a/drivers/media/usb/uvc/uvc_status.c
> > > > > +++ b/drivers/media/usb/uvc/uvc_status.c
> > > > > @@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> > > > >     if (dev->int_urb == NULL)
> > > > >             return 0;
> > > > >
> > > > > +   atomic_set(&dev->flush_status, 0);
> > > > >     return usb_submit_urb(dev->int_urb, flags);
> > > > >  }
> > > > >
> > > > >  void uvc_status_stop(struct uvc_device *dev)
> > > > >  {
> > > > > +   struct uvc_ctrl_work *w = &dev->async_ctrl;
> > > > > +
> > > > > +   atomic_set(&dev->flush_status, 1);
> > > >
> > > > Note that atomic_read() and atomic_set() do no imply any memory barrier
> > > > on most architectures, as far as I can tell. They essentially become
> > > > READ_ONCE() and WRITE_ONCE() calls, which guarantee that the compiler
> > > > will not merge or split loads or stores, or reorder them with respect to
> > > > load and stores to the *same* memory location, but nothing else. I think
> > > > you need to add proper barriers, and you can then probably also drop
> > > > usage of atomic_t.
> >
> > You are absolutely right! Only a subset of atomic implies memory barriers.
> >
> > Found this doc particularly good:
> > https://www.kernel.org/doc/html/v5.10/core-api/atomic_ops.html
> >
> >
> > > >
> > > > > +   if (cancel_work_sync(&w->work))
> > > > > +           uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> > > > >     usb_kill_urb(dev->int_urb);
> > > >
> > > > This should get rid of the main race (possibly save the barrier issue),
> > > > but it's not the most efficient option, and can still be problematic.
> > > > Consider the following case:
> > > >
> > > > CPU0                                                  CPU1
> > > > ----                                                  ----
> > > >
> > > > void uvc_status_stop(struct uvc_device *dev)          uvc_ctrl_status_event_async()
> > > > {                                                     {
> > > >       ...
> > > >       atomic_set(&dev->flush_status, 1);                      ...
> > > >       if (cancel_work_sync())
> > > >               ...
> > > >                                                               schedule_work();
> > > >       usb_kill_urb();                                 }
> > > > }
> > > >
> > > > The usb_kill_urb() call ensures that uvc_ctrl_status_event_async()
> > > > completes before uvc_status_stop() returns, but there will still be work
> > > > scheduled in that case. uvc_ctrl_status_event_work() will be run later,
> > > > and as flush_status is set to 1, the function will not resubmit the URB.
> > > > That fixes the main race, but leaves the asynchronous control status
> > > > event handling for after uvc_status_stop() returns, which isn't great.
> > > >
> > > > Now, if we consider that uvc_status_start() could be called shortly
> > > > after uvc_status_stop(), we may get in a situation where
> > > > uvc_status_start() will reset flush_status to 0 before
> > > > uvc_ctrl_status_event_async() runs. Both uvc_ctrl_status_event_async()
> > > > and uvc_status_start() will thus submit the same URB.
> > > >
> > > > You can't fix this by first killing the URB and then cancelling the
> > > > work, as there would then be a risk that uvc_ctrl_status_event_work()
> > > > would be running in parallel, going past the flush_status check before
> > > > flush_status gets set to 1 in uvc_status_stop(), and submitting the URB
> > > > after usb_kill_urb() is called.
> > > >
> > > > I think a good fix would be to check flush_status in
> > > > uvc_ctrl_status_event_async() and avoid the schedule_work() call in that
> > > > case.
> >
> > If we do that, then we will be losing an event. I would rather call
> > cancel_work_sync() again after usb_kill_urb().
>
> I've thought about that, but I don't think losing the event is an issue.
> We're stopping event handling in the first place, there's no
> synchronization guarantee with the camera. For all we know the camera
> could have generate the event right after we stop instead of right
> before. There's of course no reason to drop the event for the sake of
> it, but if it leads to simpler code, there's no reason to process it
> either.

Please take a look to v5, it does not look complicated, and we have
all the synchronization code in two functions:
uvc_status_stop() and uvc_ctrl_status_event_work(), instead of 3. Plus
we do not lose any received event.

Regards!

>
> > > > You could then also move the atomic_set(..., 0) call from
> > > > uvc_status_start() to the end of uvc_status_stop() (again with proper
> > > > barriers).
> >
> > Will do that, it is more "elegant".
> >
> > > Also, as all of this is tricky, comments in appropriate places in the
> > > code would be very helpful to avoid breaking things later.
> > >
> > > > Could you please check the memory barriers and test the above proposal
> > > > (after double-checking it of course, I may have missed something) ?
> > > >
> > > > >  }
> > > > > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > > > > index df93db259312..1274691f157f 100644
> > > > > --- a/drivers/media/usb/uvc/uvcvideo.h
> > > > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > > > @@ -560,6 +560,7 @@ struct uvc_device {
> > > > >     struct usb_host_endpoint *int_ep;
> > > > >     struct urb *int_urb;
> > > > >     u8 *status;
> > > > > +   atomic_t flush_status;
> > > > >     struct input_dev *input;
> > > > >     char input_phys[64];
> > > > >
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Ricardo Ribalda
