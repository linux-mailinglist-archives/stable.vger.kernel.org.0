Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8898D64C938
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 13:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbiLNMrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 07:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbiLNMrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 07:47:01 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291A810EB
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 04:45:11 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 65so4342378pfx.9
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 04:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mqYnQZpaV3lr0oDOGKRzspo4XEpIJg4yeRzWQLRMMKc=;
        b=ez43T/4QBFPa8ZNhNOM8RPq7ouLgck23/Ks3iEzLonooKu4tURJ55AZTwu3+4TzwS6
         C/2MAuVvhaDGijJPLxMGjrT4hYD370oxS9lK8p7BM9ejtd3ik5GNYYpv3qLFWuPiYEG5
         DZ0aTRajiKwBhe9FSsxehjhVoyfnHX0zKVc5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqYnQZpaV3lr0oDOGKRzspo4XEpIJg4yeRzWQLRMMKc=;
        b=qbNuKQozateg3gqnUErBuM4MT6dMjBQNrXl8xAlpCtFhAN9MxdycS0HIxW8qfVjWkU
         EcRGFF0a8z2vjyueJK6PLuevH+GFawvvHxgiFVbOvLUhLTEREBPLnYaAI4YPVDxLNEmd
         w+5+yLS+fUUs6RH7gqdd3jwueIYXkUNgFSp0fURh2a0Kk4LrKZF5rYtW4myX6jIiUTbG
         2DNXfp7md6A2EltUYK7P4HauDiLGi9dvY/WShN21QFV7NT3T5t5LvGOZI1WWe7C0uTM8
         CGsWHtnL/3/NBS35xdjtA/OuYn9VPRBkOLUuyY8kVNNHBBZDdsyOqT9eIREOj6wRzQ8z
         422w==
X-Gm-Message-State: ANoB5plrVBNcvLblEp8IjU4LSv+q9jRWVLKoDeh8GOBBILg2o38bFqsx
        NbQ1/4vSqZjUkelNSztMgldm/EvQDXPL9k9BXoU=
X-Google-Smtp-Source: AA0mqf61RFUWKLW7xZTqXrUtXs/KQeK0RRdhR2gUsfiD/lgt5MFr+aG8/We/vY7xAlwxbq535O9wpg==
X-Received: by 2002:a62:7983:0:b0:577:8d87:d8f4 with SMTP id u125-20020a627983000000b005778d87d8f4mr25255429pfc.34.1671021910277;
        Wed, 14 Dec 2022 04:45:10 -0800 (PST)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com. [209.85.214.180])
        by smtp.gmail.com with ESMTPSA id o76-20020a62cd4f000000b005751f455e0esm9411516pfg.120.2022.12.14.04.45.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 04:45:09 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id s7so3208154plk.5
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 04:45:08 -0800 (PST)
X-Received: by 2002:a17:90a:17ef:b0:219:8132:70db with SMTP id
 q102-20020a17090a17ef00b00219813270dbmr337241pja.183.1671021908188; Wed, 14
 Dec 2022 04:45:08 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v3-0-954efc752c9a@chromium.org> <Y5nEgDOXFNDPf8/Y@pendragon.ideasonboard.com>
In-Reply-To: <Y5nEgDOXFNDPf8/Y@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 14 Dec 2022 13:44:56 +0100
X-Gmail-Original-Message-ID: <CANiDSCvLjr6NK3pL9NpLap44Zcc22OEbyRANXq90dtG+udro4Q@mail.gmail.com>
Message-ID: <CANiDSCvLjr6NK3pL9NpLap44Zcc22OEbyRANXq90dtG+udro4Q@mail.gmail.com>
Subject: Re: [PATCH v3] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent

On Wed, 14 Dec 2022 at 13:41, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> Thank you for the patch.
>
> On Wed, Dec 14, 2022 at 12:18:52PM +0100, Ricardo Ribalda wrote:
> > usb_kill_urb warranties that all the handlers are finished when it
> > returns, but does not protect against threads that might be handling
> > asynchronously the urb.
> >
> > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > control changes asynchronously.
> >
> >  If the code is executed in the following order:
> >
> > CPU 0                                 CPU 1
> > =====                                         =====
> > uvc_status_complete()
> >                                       uvc_status_stop()
> > uvc_ctrl_status_event_work()
> >                                       uvc_status_start() -> FAIL
>
>
>
> > Then uvc_status_start will keep failing and this error will be shown:
> >
> > <4>[    5.540139] URB 0000000000000000 submitted while active
> > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> >
> > Let's improve the current situation, by not re-submiting the urb if
> > we are stopping the status event. Also process the queued work
> > (if any) during stop.
> >
> > CPU 0                                 CPU 1
> > =====                                         =====
> > uvc_status_complete()
> >                                       uvc_status_stop()
> >                                       uvc_status_start()
> > uvc_ctrl_status_event_work() -> FAIL
> >
> > Hopefully, with the usb layer protection this should be enough to cover
> > all the cases.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> > uvc: Fix race condition on uvc
> >
> > Make sure that all the async work is finished when we stop the status urb.
> >
> > To: Yunke Cao <yunkec@chromium.org>
> > To: Sergey Senozhatsky <senozhatsky@chromium.org>
> > To: Max Staudt <mstaudt@google.com>
> > To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > To: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> > Changes in v3:
> > - Remove the patch for dev->status, makes more sense in another series, and makes
> >   the zero day less nervous.
> > - Update reviewed-by (thanks Yunke!).
> > - Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org
> >
> > Changes in v2:
> > - Add a patch for not kalloc dev->status
> > - Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
> > - Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
> >  drivers/media/usb/uvc/uvc_status.c | 6 ++++++
> >  drivers/media/usb/uvc/uvcvideo.h   | 1 +
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> > index c95a2229f4fa..5160facc8e20 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
> >
> >       uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> >
> > +     if (dev->flush_status)
> > +             return;
> > +
> >       /* Resubmit the URB. */
> >       w->urb->interval = dev->int_ep->desc.bInterval;
> >       ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> > index 7518ffce22ed..09a5802dc974 100644
> > --- a/drivers/media/usb/uvc/uvc_status.c
> > +++ b/drivers/media/usb/uvc/uvc_status.c
> > @@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> >       if (dev->int_urb == NULL)
> >               return 0;
> >
> > +     dev->flush_status = false;
> >       return usb_submit_urb(dev->int_urb, flags);
> >  }
> >
> >  void uvc_status_stop(struct uvc_device *dev)
> >  {
> > +     struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +
> > +     dev->flush_status = true;
> >       usb_kill_urb(dev->int_urb);
>
> Isn't this still racy ?

Indeed...

I could add a mutex just for flush_status

what do you think?

>
> CPU0                                    CPU1
> ====                                    ====
>
> uvc_status_stop()                       uvc_ctrl_status_event_work()
> {                                       {
>                                                 if (dev->flush_status)
>                                                         return;
>
>         dev->flush_status = true;
>         usb_kill_urb(dev->int_urb);
>
>                                                 /* Resubmit the URB. */
>                                                 w->urb->interval = dev->int_ep->desc.bInterval;
>                                                 ret = usb_submit_urb(w->urb, GFP_KERNEL);
>                                         }
>
>         if (cancel_work_sync(&w->work))
>                 uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> }
>
> uvc_status_start() will then return an error, right ?
>
> > +     if (cancel_work_sync(&w->work))
> > +             uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
> >  }
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index df93db259312..6a9b72d6789e 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -560,6 +560,7 @@ struct uvc_device {
> >       struct usb_host_endpoint *int_ep;
> >       struct urb *int_urb;
> >       u8 *status;
> > +     bool flush_status;
> >       struct input_dev *input;
> >       char input_phys[64];
> >
> >
> > ---
> > base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
> > change-id: 20221212-uvc-race-09276ea68bf8
>
> --
> Regards,
>
> Laurent Pinchart



-- 
Ricardo Ribalda
