Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9579C26
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 00:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfG2WEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 18:04:06 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39091 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfG2WEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 18:04:06 -0400
Received: by mail-oi1-f196.google.com with SMTP id m202so46448086oig.6
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 15:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hWkU2/nir7ZQfvW4i66MunEPrc2ksPHZ+kI417Vwor0=;
        b=YSpTPlMeCYYov7BuvMIOVP4Mbjnyr+tyM3byOHdUesUddEkSMTdk3VN0J5EVFcO5AA
         60elu2KlvLQ7lbDIJNkKFyLm/z9m97CbYD/J723A4PhsO4MTQiDYTKtSefUUNGurPUOQ
         Ol+MGNxjX5/jPtRV8JWa3rmBQ9b9icxpWWGsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hWkU2/nir7ZQfvW4i66MunEPrc2ksPHZ+kI417Vwor0=;
        b=srDcLar3nv0xsNHbaiq2ZX6PjDpE94bAuTuTwan1YgdtmLbh3qKpvfPmK/a61fxgdv
         TQ8alVQyUDCLAjncaCBHhlYzHx/IuSpC2CVAr4O8rgwfKucueBUciuK3fWlUw97JTKwT
         qKwJBNzpYNbnZ2RzqnmBw82X0pzviHdMC7yKvVzXaN26IuuFkoNt7rkNTqCT5RSNhbB6
         S488jelj6R27RQcaSRceKg+Sj9pGOD0GRJyAq1tzKNf6eZL9/CCq/UarVQdC9UA90iKd
         6jnp1VlVN8nOEYuuU0R5/+Wxvz4PfhIxJJkxzzBk5dKE4hDSDHXkr2yCBsk/KRZ5s5uc
         W2DA==
X-Gm-Message-State: APjAAAW+ehi4Acs47p3hWKpDJAe1gfN2JiTBcCWgezzBeIBy+WsKZHgt
        kebu2H66tovXXrvGmvt8vEA5CtA1HlRSt16NOHjCun9f
X-Google-Smtp-Source: APXvYqzxoYmsrKa+/w4iZlFyZ+r721up9sOSNNUO05B9bQZK5PB1hT9YRKjmerl1KT4H08nbG3IA1hv+pMyhSISgMfg=
X-Received: by 2002:a05:6808:118:: with SMTP id b24mr56856483oie.128.1564437844733;
 Mon, 29 Jul 2019 15:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
 <20190725113237.d2dwxzientte4j3n@flea> <CAGgjyvEA54kR3U8Lyz-1-vPS74raT6SpoM0e8YYcm12T=0r50A@mail.gmail.com>
In-Reply-To: <CAGgjyvEA54kR3U8Lyz-1-vPS74raT6SpoM0e8YYcm12T=0r50A@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 30 Jul 2019 00:03:53 +0200
Message-ID: <CAKMK7uHNyP0XAkPZ4dSfdAzcrvzNSHc8J02rwh0nLCSnPu_d2Q@mail.gmail.com>
Subject: Re: [PATCH 0/1] This patch fixes connection detection for monitors
 w/o DDC.
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Suvorov Alexander <cryosay@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 12:58 PM Oleksandr Suvorov
<oleksandr.suvorov@toradex.com> wrote:
>
> On Thu, Jul 25, 2019 at 5:41 PM maxime.ripard@free-electrons.com
> <maxime.ripard@free-electrons.com> wrote:
> >
> > On Thu, Jul 25, 2019 at 11:05:23AM +0000, Oleksandr Suvorov wrote:
> > >
> > > Even in source code of this driver there is an author's description:
> > >     /*
> > >      * Even if we have an I2C bus, we can't assume that the cable
> > >      * is disconnected if drm_probe_ddc fails. Some cables don't
> > >      * wire the DDC pins, or the I2C bus might not be working at
> > >      * all.
> > >      */
> > >
> > > That's true. DDC and VGA channels are independent, and therefore
> > > we cannot decide whether the monitor is connected or not,
> > > depending on the information from the DDC.
> > >
> > > So the monitor should always be considered connected.
> >
> > Well, no. Like you said, we cannot decided whether is connected or
> > not.
>
> Maxime, thanks, I agree that's a bad solution.
> But I still think we should be able to define the DT node of a device for
> this driver to claim the connector is always connected.
> Please see my following thoughts.
>
> > > Thus there is no reason to use connector detect callback for this
> > > driver: DRM sub-system considers monitor always connected if there
> > > is no detect() callback registered with drm_connector_init().
> > >
> > > How to reproduce the bug:
> > > * setup: i.MX8QXP, LCDIF video module + gpu/drm/mxsfb driver,
> > >   adv712x VGA DAC + dumb-vga-dac driver, VGA-connector w/o DDC;
> > > * try to use drivers chain mxsfb-drm + dumb-vga-dac;
> > > * any DRM applications consider the monitor is not connected:
> > >   ===========
> > >   $ weston-start
> > >   $ cat /var/log/weston.log
> > >       ...
> > >       DRM: head 'VGA-1' found, connector 32 is disconnected.
> > >       ...
> > >   $ cat /sys/devices/platform/5a180000.lcdif/drm/card0/card0-VGA-1/status
> > >   unknown
> >
> > And that's exactly what's being reported here: we cannot decide if it
> > is connected or not, so it's unknown.
> >
> > If weston chooses to ignore connectors that are in an unknown state,
> > I'd say it's weston's problem, since it's much broader than this
> > particular device.
>
> If we look at the code of drm_probe_helper.c, we can see, the
> drm_helper_probe_detect_ctx() assume the cable is connected if there is no
> detect() callback registered.
> ...
>                 if (funcs->detect_ctx)
>                          ret = funcs->detect_ctx(connector, &ctx, force);
>                  else if (connector->funcs->detect)
>                          ret = connector->funcs->detect(connector, force);
>                  else
>                          ret = connector_status_connected;
> ...
>
> The driver dumb-vga-dac supports both DT configurations:
> - with DDC channel, that allows us to detect if the cable is connected;
> - without DDC channel. In this case, IMHO, the driver should behave
> the same way as a
>   connector driver without registered detect() callback.
>
> So what about the patch like?

Still no. The "always connected" case is for outputs which are
physically always connected and typing a dummy function which would
unconditionally return connected would be silly. Like built-in panels.
This is _not_ for external screens.
-Daniel

>
> @@ -81,6 +81,13 @@ dumb_vga_connector_detect(struct drm_connector
> *connector, bool force)
>  {
>         struct dumb_vga *vga = drm_connector_to_dumb_vga(connector);
>
> +       /*
> +        * If I2C bus for DDC is not defined, asume that the cable
> +        * is always connected.
> +        */
> +       if (PTR_ERR(vga->ddc) == -ENODEV)
> +               return connector_status_connected;
> +
>         /*
>          * Even if we have an I2C bus, we can't assume that the cable
>          * is disconnected if drm_probe_ddc fails. Some cables don't
>
> --
> Best regards
> Oleksandr Suvorov
>
> Toradex AG
> Altsagenstrasse 5 | 6048 Horw/Luzern | Switzerland | T: +41 41 500
> 4800 (main line)



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
