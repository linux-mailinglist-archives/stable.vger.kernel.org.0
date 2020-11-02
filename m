Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474B82A3185
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 18:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbgKBR3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 12:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbgKBR3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 12:29:35 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F99AC061A04
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 09:29:35 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w65so11710729pfd.3
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 09:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p/DEdqfzjHqREFiiQ64DzLAqMoklspJdVfF8M1QhzKo=;
        b=IlK8VBmv+2S4zFzKyOyhA5i2aI+QNJOQiCtjAsPuDj0QKs+j/LCVO+nUPRyqryqFFB
         6zvVk9hjXuOWgnyNlZEHbdKQcNnoW4WKNdocORFPgcUNSU8n0BH9Kdn7j3IRrGrBo4IM
         Xa8h1LFCHeiovv41XVGiHSRZL9yNkA0OVcys5Fz3396NLUTgMeejL+9/DoKi/7j9Sn47
         w6lBu7XMlIatXT8139sFwH3yLJ9pCSPvIqn7YnzuXPezAh5x40vm1HB310nhZu/7VqLW
         QN/fwVqwiyfiSENWEgFaWXOPUKty5KVis5vhxeV2l7AdkcGNTp4IPovC4+L6ahyAnYHE
         4dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p/DEdqfzjHqREFiiQ64DzLAqMoklspJdVfF8M1QhzKo=;
        b=t+MB6sgjbUCiriOXrMskd+btVGdBwNyI5/bTv0H1JhO0+OFfESqVlRuuribo6NZTYG
         UGI0sFt+vCoBusDoreSAUcfkm4qELeIjuQttCjdYilvqMVeE4Mz9XR693TzhkupEZX1F
         33N0eC/m4BXctYleoZr1Cm1KK26V31qkZbLJt5TKNm+JtA+aLOd/zH+YhzrB37x7SNqI
         811V7zAjF/mhIxhtQ4Dbi/DvoQOSCa3IXtYbCq3PQDbe4jE0fzI1rOedwQgWmV6hrMOK
         GSYnx26YYIIo52Sifv8Q8Mk2z1qdOCg3CbSXj8GZ+NvFlgAzpUa9W61RLaRqVzlLrys9
         JUXA==
X-Gm-Message-State: AOAM530XHsKU7h2tGA3mi6kCT6HFKf60v5xY/4h8izM32rwAjSusXCBH
        Q4llUJu32p/R6NObx73DnTLFVQ==
X-Google-Smtp-Source: ABdhPJx532e13/KUkQ+mVSrMvCQCWuokkeyADaha7+OUrMcyX0L0pOI5gUSS0AQrUNzkwrsRubANdg==
X-Received: by 2002:a65:4b84:: with SMTP id t4mr13900931pgq.138.1604338174656;
        Mon, 02 Nov 2020 09:29:34 -0800 (PST)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u14sm2904349pfc.87.2020.11.02.09.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:29:33 -0800 (PST)
Date:   Mon, 2 Nov 2020 10:29:31 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Linu Cherian <linuc.decode@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Coresight ML <coresight@lists.linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linu Cherian <lcherian@marvell.com>
Subject: Re: [PATCH AUTOSEL 5.9 075/147] coresight: Make sysfs functional on
 topologies with per core sink
Message-ID: <20201102172931.GC2749502@xps15>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-75-sashal@kernel.org>
 <CAAHhmWjcP-3oAdhr2Nh_+QGbOi59PVDg763_avKgxFqjiYqMzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHhmWjcP-3oAdhr2Nh_+QGbOi59PVDg763_avKgxFqjiYqMzQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 12:29:34PM +0530, Linu Cherian wrote:
> Hi,
> 
> Upstream commit,
> 
> commit bb1860efc817c18fce4112f25f51043e44346d1b
> Author: Linu Cherian <lcherian@marvell.com>
> Date:   Wed Sep 16 13:17:34 2020 -0600
> 
> 
> 
> 
> coresight: etm: perf: Sink selection using sysfs is deprecated
> 
> 
> need to go along with this, else there will be build breakage.
> This applies for 5.4, 5.8 and 5.9
> 
> Mathieu, could you please ACK ?

Top posting makes it very difficult to follow what is going on.

Based on your above comment Sasha has probably dropped this patch.  The best way
to proceed is likely to send a patchset to stable with all the required
patches.

Thanks,
Mathieu

> 
> Please let me know if i need to send the patch to
> stable@vger.kernel.org separately.
> Thanks.
> 
> 
> 
> 
> On Tue, Oct 27, 2020 at 5:20 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Linu Cherian <lcherian@marvell.com>
> >
> > [ Upstream commit 6d578258b955fc8888e1bbd9a8fefe7b10065a84 ]
> >
> > Coresight driver assumes sink is common across all the ETMs,
> > and tries to build a path between ETM and the first enabled
> > sink found using bus based search. This breaks sysFS usage
> > on implementations that has multiple per core sinks in
> > enabled state.
> >
> > To fix this, coresight_get_enabled_sink API is updated to
> > do a connection based search starting from the given source,
> > instead of bus based search.
> > With sink selection using sysfs depecrated for perf interface,
> > provision for reset is removed as well in this API.
> >
> > Signed-off-by: Linu Cherian <lcherian@marvell.com>
> > [Fixed indentation problem and removed obsolete comment]
> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > Link: https://lore.kernel.org/r/20200916191737.4001561-15-mathieu.poirier@linaro.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/hwtracing/coresight/coresight-priv.h |  3 +-
> >  drivers/hwtracing/coresight/coresight.c      | 62 +++++++++-----------
> >  2 files changed, 29 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
> > index f2dc625ea5856..5fe773c4d6cc5 100644
> > --- a/drivers/hwtracing/coresight/coresight-priv.h
> > +++ b/drivers/hwtracing/coresight/coresight-priv.h
> > @@ -148,7 +148,8 @@ static inline void coresight_write_reg_pair(void __iomem *addr, u64 val,
> >  void coresight_disable_path(struct list_head *path);
> >  int coresight_enable_path(struct list_head *path, u32 mode, void *sink_data);
> >  struct coresight_device *coresight_get_sink(struct list_head *path);
> > -struct coresight_device *coresight_get_enabled_sink(bool reset);
> > +struct coresight_device *
> > +coresight_get_enabled_sink(struct coresight_device *source);
> >  struct coresight_device *coresight_get_sink_by_id(u32 id);
> >  struct coresight_device *
> >  coresight_find_default_sink(struct coresight_device *csdev);
> > diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
> > index e9c90f2de34ac..bb4f9e0a5438d 100644
> > --- a/drivers/hwtracing/coresight/coresight.c
> > +++ b/drivers/hwtracing/coresight/coresight.c
> > @@ -540,50 +540,46 @@ struct coresight_device *coresight_get_sink(struct list_head *path)
> >         return csdev;
> >  }
> >
> > -static int coresight_enabled_sink(struct device *dev, const void *data)
> > +static struct coresight_device *
> > +coresight_find_enabled_sink(struct coresight_device *csdev)
> >  {
> > -       const bool *reset = data;
> > -       struct coresight_device *csdev = to_coresight_device(dev);
> > +       int i;
> > +       struct coresight_device *sink;
> >
> >         if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
> >              csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
> > -            csdev->activated) {
> > -               /*
> > -                * Now that we have a handle on the sink for this session,
> > -                * disable the sysFS "enable_sink" flag so that possible
> > -                * concurrent perf session that wish to use another sink don't
> > -                * trip on it.  Doing so has no ramification for the current
> > -                * session.
> > -                */
> > -               if (*reset)
> > -                       csdev->activated = false;
> > +            csdev->activated)
> > +               return csdev;
> >
> > -               return 1;
> > +       /*
> > +        * Recursively explore each port found on this element.
> > +        */
> > +       for (i = 0; i < csdev->pdata->nr_outport; i++) {
> > +               struct coresight_device *child_dev;
> > +
> > +               child_dev = csdev->pdata->conns[i].child_dev;
> > +               if (child_dev)
> > +                       sink = coresight_find_enabled_sink(child_dev);
> > +               if (sink)
> > +                       return sink;
> >         }
> >
> > -       return 0;
> > +       return NULL;
> >  }
> >
> >  /**
> > - * coresight_get_enabled_sink - returns the first enabled sink found on the bus
> > - * @deactivate:        Whether the 'enable_sink' flag should be reset
> > - *
> > - * When operated from perf the deactivate parameter should be set to 'true'.
> > - * That way the "enabled_sink" flag of the sink that was selected can be reset,
> > - * allowing for other concurrent perf sessions to choose a different sink.
> > + * coresight_get_enabled_sink - returns the first enabled sink using
> > + * connection based search starting from the source reference
> >   *
> > - * When operated from sysFS users have full control and as such the deactivate
> > - * parameter should be set to 'false', hence mandating users to explicitly
> > - * clear the flag.
> > + * @source: Coresight source device reference
> >   */
> > -struct coresight_device *coresight_get_enabled_sink(bool deactivate)
> > +struct coresight_device *
> > +coresight_get_enabled_sink(struct coresight_device *source)
> >  {
> > -       struct device *dev = NULL;
> > -
> > -       dev = bus_find_device(&coresight_bustype, NULL, &deactivate,
> > -                             coresight_enabled_sink);
> > +       if (!source)
> > +               return NULL;
> >
> > -       return dev ? to_coresight_device(dev) : NULL;
> > +       return coresight_find_enabled_sink(source);
> >  }
> >
> >  static int coresight_sink_by_id(struct device *dev, const void *data)
> > @@ -988,11 +984,7 @@ int coresight_enable(struct coresight_device *csdev)
> >                 goto out;
> >         }
> >
> > -       /*
> > -        * Search for a valid sink for this session but don't reset the
> > -        * "enable_sink" flag in sysFS.  Users get to do that explicitly.
> > -        */
> > -       sink = coresight_get_enabled_sink(false);
> > +       sink = coresight_get_enabled_sink(csdev);
> >         if (!sink) {
> >                 ret = -EINVAL;
> >                 goto out;
> > --
> > 2.25.1
> >
> > _______________________________________________
> > CoreSight mailing list
> > CoreSight@lists.linaro.org
> > https://lists.linaro.org/mailman/listinfo/coresight
