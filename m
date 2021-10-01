Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29C541F6D8
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 23:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355132AbhJAVZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354936AbhJAVZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 17:25:27 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7CEC06177E
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 14:23:43 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id s24so13046627oij.8
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 14:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rQO+lMXU6VmqpbbuMNNIj4s/iSRqxxtzgzbizBnbLmk=;
        b=iSh459FN5Z6Hqy9OYQZTytx3xm7vgeROeRrUA3KkjbSpJr6gHBeJtPg+IG1UktWtKi
         j0nWzggnhcvpJsq6Oc90kySnuaUsE8mLUC3eHw503Ya41vqpbvJSsWuEN9YKwUQQAQ2f
         ku+ZlpxCosstDPHAfe22bGGCKuGlOe0VgHbA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rQO+lMXU6VmqpbbuMNNIj4s/iSRqxxtzgzbizBnbLmk=;
        b=1cb59G/1XqUhDHt8cyqo1Ad/ClPnsfHzPz0jtq6Cm7NiDLG6XrD6i3VAWgXTAMwKd1
         tpO8YYglZUqG7B324cRM6xbIRrKpqurOCNJ4Zo++XJcZ86PQz2LMrkDMZoYSoY5CI6ed
         hlc4DBtn7ev+Q77qxChUJtAp6mJtalGG8DfAXF5PX7mMd0Uv61wC/WuM8YfT2qqhtCjz
         aprY5VvCIPSfzCjnDpmDLsnpi3xZQbpT7ifbq+K15Ahr8EoKaEYf+Y8QNX37+vTMKIvd
         ZlGynMzjUVaW2BNCb/sKWbl1pL8eJsOILLNYWF8WMjNN58XUs1kEIdWpCviZA78iHzhM
         PB+g==
X-Gm-Message-State: AOAM532SotFb+/Ol5ei76S+S8dq3ximE6it3PWJtRu8pjoOfizCqiJyW
        PsaP0tzFVitDMXSCpcmfl2OXphwAwTlyEw==
X-Google-Smtp-Source: ABdhPJyCk4AggtQf6rieCuc4G5pSi/b2FjUX0B6tijHdr2xwcwVzyTt8edJ2i4IXS7u5VnAQ+tAMGA==
X-Received: by 2002:a05:6808:1387:: with SMTP id c7mr5621156oiw.137.1633123421738;
        Fri, 01 Oct 2021 14:23:41 -0700 (PDT)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id p8sm1373912oti.15.2021.10.01.14.23.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 14:23:41 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso13129384otb.11
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 14:23:40 -0700 (PDT)
X-Received: by 2002:a05:6830:112:: with SMTP id i18mr82821otp.186.1633123420525;
 Fri, 01 Oct 2021 14:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210929144010.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <20211001203722.GZ2515@art_vandelay>
In-Reply-To: <20211001203722.GZ2515@art_vandelay>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 1 Oct 2021 14:23:29 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNqwGWLHV5sPeUebd1AzPzLJva5hWm-385A+5vgQYMvVQ@mail.gmail.com>
Message-ID: <CA+ASDXNqwGWLHV5sPeUebd1AzPzLJva5hWm-385A+5vgQYMvVQ@mail.gmail.com>
Subject: Re: [PATCH] drm/brdige: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Sean Paul <sean@poorly.run>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        stable <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 1, 2021 at 1:37 PM Sean Paul <sean@poorly.run> wrote:
> On Wed, Sep 29, 2021 at 02:41:03PM -0700, Brian Norris wrote:
> > --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > @@ -1632,8 +1632,23 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
> >                                      struct drm_dp_aux_msg *msg)
> >  {
> >       struct analogix_dp_device *dp = to_dp(aux);
> > +     int ret, ret2;
> >
> > -     return analogix_dp_transfer(dp, msg);
> > +     ret = analogix_dp_prepare_panel(dp, true, false);
> > +     if (ret) {
> > +             DRM_DEV_ERROR(dp->dev, "Failed to prepare panel (%d)\n", ret);
>
> s/DRM_DEV_ERROR/drm_err/

Sure. Now that I'm looking a second time, I see the header recommends this.

> > +             return ret;
> > +     }
> > +
> > +     pm_runtime_get_sync(dp->dev);
> > +     ret = analogix_dp_transfer(dp, msg);
> > +     pm_runtime_put(dp->dev);
> > +
> > +     ret2 = analogix_dp_prepare_panel(dp, false, false);
> > +     if (ret2)
> > +             DRM_DEV_ERROR(dp->dev, "Failed to unprepare panel (%d)\n", ret2);
>
> What's the reasoning for not propagating unprepare failures? I feel like that
> should be fair game.

I suppose the underlying reason is laziness, sorry. But a related
reason is the we probably should prefer propagating the
analogix_dp_transfer() error, if it's non-zero, rather than the
unprepare error. That's not too hard to do though, even if it's
slightly more awkward.

> > +
> > +     return ret;
> >  }
> >
> >  struct analogix_dp_device *

v2 coming.

Regards,
Brian
