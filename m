Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2500E2A24EB
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 07:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgKBG7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 01:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbgKBG7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 01:59:49 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6512C0617A6;
        Sun,  1 Nov 2020 22:59:47 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id d24so13792298ljg.10;
        Sun, 01 Nov 2020 22:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=680jJYtj0dinYltk97SujQf+zsOPEEe3d/I6WUB2CxU=;
        b=tR3CjwwUyLuJDBD9Fv8+rDJR1VDLKhy6gy+RkLEosXGXYnYPAYg4jqN8pdukj9UC01
         /lKvQiOa2KjxuEva4vfmOemUQQ0sAaC1WaAuLw+v7cefkMNQTDIoARjrS4eIZ9tMSQC+
         /cvCDs51anO/K+fKGSjHRkP6iWeEQVNs5WWfhyIy8YWMPxcJMLUj3GWZ7imzyOHWqwtu
         Y9XVKzOE4exUr6nHNItzcpSyl1R9qaGRn6RIPbH0/tV/1/eIkE3joda2i5d4sWcY9o2T
         asNwGDZgqbvbZEOIM5wksjzz9TiOfIYQ4IMThWcZiOzOJzEEhBnZMLiBOq3DLna5EOHw
         SVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=680jJYtj0dinYltk97SujQf+zsOPEEe3d/I6WUB2CxU=;
        b=poxiAidZBsw3G/z0IZ31G+ntRj1qaEzoH1++Y1wuV34b+KVX1K51L93v62Rhf6MTjC
         LIHXz0kxfsm3AVkvZRquMwfepRQAcGdmy9uR+okpTa/W0M5/svUxIxraItShWCqXTHbj
         vGAl7QQ/Tbvg0YyqpOefSOBs8tWqC55i+4YGCk6iDNYLXlCxd0BFvICIK4ZgEdytwfuv
         HvAEzIv2ieLt77izfcX4k/OabvAXeqr1nVjc54MGcoHBkCjoqho0JF6zxcujqIAQBoWi
         qj6wVTFVWtFGNLJOXsXbn3dNaf21BEPDhzlPKCd6xFa5sHoZRYyUMJTp15GPmjjuAwTB
         q2/g==
X-Gm-Message-State: AOAM533kNgBz84KZ18Id4l9TYSaexXhS6EaluP4S50M97nweSvWqseE9
        9H7Gq/n131j2cb5XskE+HP7cJFoa/lHt+qB942s1t6y9Mhg=
X-Google-Smtp-Source: ABdhPJxQyhrSSxeyiYlN1kushSJnVK+JFw8djKCb/40Fg6Z2aWaEMRyvAJ/xlqXclweFvCobk9k+CsifvTcCuSYRMhY=
X-Received: by 2002:a2e:7a0a:: with SMTP id v10mr6454589ljc.13.1604300386422;
 Sun, 01 Nov 2020 22:59:46 -0800 (PST)
MIME-Version: 1.0
References: <20201026234905.1022767-1-sashal@kernel.org> <20201026234905.1022767-75-sashal@kernel.org>
In-Reply-To: <20201026234905.1022767-75-sashal@kernel.org>
From:   Linu Cherian <linuc.decode@gmail.com>
Date:   Mon, 2 Nov 2020 12:29:34 +0530
Message-ID: <CAAHhmWjcP-3oAdhr2Nh_+QGbOi59PVDg763_avKgxFqjiYqMzQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.9 075/147] coresight: Make sysfs functional on
 topologies with per core sink
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Coresight ML <coresight@lists.linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linu Cherian <lcherian@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Upstream commit,

commit bb1860efc817c18fce4112f25f51043e44346d1b
Author: Linu Cherian <lcherian@marvell.com>
Date:   Wed Sep 16 13:17:34 2020 -0600




coresight: etm: perf: Sink selection using sysfs is deprecated


need to go along with this, else there will be build breakage.
This applies for 5.4, 5.8 and 5.9

Mathieu, could you please ACK ?

Please let me know if i need to send the patch to
stable@vger.kernel.org separately.
Thanks.




On Tue, Oct 27, 2020 at 5:20 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Linu Cherian <lcherian@marvell.com>
>
> [ Upstream commit 6d578258b955fc8888e1bbd9a8fefe7b10065a84 ]
>
> Coresight driver assumes sink is common across all the ETMs,
> and tries to build a path between ETM and the first enabled
> sink found using bus based search. This breaks sysFS usage
> on implementations that has multiple per core sinks in
> enabled state.
>
> To fix this, coresight_get_enabled_sink API is updated to
> do a connection based search starting from the given source,
> instead of bus based search.
> With sink selection using sysfs depecrated for perf interface,
> provision for reset is removed as well in this API.
>
> Signed-off-by: Linu Cherian <lcherian@marvell.com>
> [Fixed indentation problem and removed obsolete comment]
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20200916191737.4001561-15-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hwtracing/coresight/coresight-priv.h |  3 +-
>  drivers/hwtracing/coresight/coresight.c      | 62 +++++++++-----------
>  2 files changed, 29 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
> index f2dc625ea5856..5fe773c4d6cc5 100644
> --- a/drivers/hwtracing/coresight/coresight-priv.h
> +++ b/drivers/hwtracing/coresight/coresight-priv.h
> @@ -148,7 +148,8 @@ static inline void coresight_write_reg_pair(void __iomem *addr, u64 val,
>  void coresight_disable_path(struct list_head *path);
>  int coresight_enable_path(struct list_head *path, u32 mode, void *sink_data);
>  struct coresight_device *coresight_get_sink(struct list_head *path);
> -struct coresight_device *coresight_get_enabled_sink(bool reset);
> +struct coresight_device *
> +coresight_get_enabled_sink(struct coresight_device *source);
>  struct coresight_device *coresight_get_sink_by_id(u32 id);
>  struct coresight_device *
>  coresight_find_default_sink(struct coresight_device *csdev);
> diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
> index e9c90f2de34ac..bb4f9e0a5438d 100644
> --- a/drivers/hwtracing/coresight/coresight.c
> +++ b/drivers/hwtracing/coresight/coresight.c
> @@ -540,50 +540,46 @@ struct coresight_device *coresight_get_sink(struct list_head *path)
>         return csdev;
>  }
>
> -static int coresight_enabled_sink(struct device *dev, const void *data)
> +static struct coresight_device *
> +coresight_find_enabled_sink(struct coresight_device *csdev)
>  {
> -       const bool *reset = data;
> -       struct coresight_device *csdev = to_coresight_device(dev);
> +       int i;
> +       struct coresight_device *sink;
>
>         if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
>              csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
> -            csdev->activated) {
> -               /*
> -                * Now that we have a handle on the sink for this session,
> -                * disable the sysFS "enable_sink" flag so that possible
> -                * concurrent perf session that wish to use another sink don't
> -                * trip on it.  Doing so has no ramification for the current
> -                * session.
> -                */
> -               if (*reset)
> -                       csdev->activated = false;
> +            csdev->activated)
> +               return csdev;
>
> -               return 1;
> +       /*
> +        * Recursively explore each port found on this element.
> +        */
> +       for (i = 0; i < csdev->pdata->nr_outport; i++) {
> +               struct coresight_device *child_dev;
> +
> +               child_dev = csdev->pdata->conns[i].child_dev;
> +               if (child_dev)
> +                       sink = coresight_find_enabled_sink(child_dev);
> +               if (sink)
> +                       return sink;
>         }
>
> -       return 0;
> +       return NULL;
>  }
>
>  /**
> - * coresight_get_enabled_sink - returns the first enabled sink found on the bus
> - * @deactivate:        Whether the 'enable_sink' flag should be reset
> - *
> - * When operated from perf the deactivate parameter should be set to 'true'.
> - * That way the "enabled_sink" flag of the sink that was selected can be reset,
> - * allowing for other concurrent perf sessions to choose a different sink.
> + * coresight_get_enabled_sink - returns the first enabled sink using
> + * connection based search starting from the source reference
>   *
> - * When operated from sysFS users have full control and as such the deactivate
> - * parameter should be set to 'false', hence mandating users to explicitly
> - * clear the flag.
> + * @source: Coresight source device reference
>   */
> -struct coresight_device *coresight_get_enabled_sink(bool deactivate)
> +struct coresight_device *
> +coresight_get_enabled_sink(struct coresight_device *source)
>  {
> -       struct device *dev = NULL;
> -
> -       dev = bus_find_device(&coresight_bustype, NULL, &deactivate,
> -                             coresight_enabled_sink);
> +       if (!source)
> +               return NULL;
>
> -       return dev ? to_coresight_device(dev) : NULL;
> +       return coresight_find_enabled_sink(source);
>  }
>
>  static int coresight_sink_by_id(struct device *dev, const void *data)
> @@ -988,11 +984,7 @@ int coresight_enable(struct coresight_device *csdev)
>                 goto out;
>         }
>
> -       /*
> -        * Search for a valid sink for this session but don't reset the
> -        * "enable_sink" flag in sysFS.  Users get to do that explicitly.
> -        */
> -       sink = coresight_get_enabled_sink(false);
> +       sink = coresight_get_enabled_sink(csdev);
>         if (!sink) {
>                 ret = -EINVAL;
>                 goto out;
> --
> 2.25.1
>
> _______________________________________________
> CoreSight mailing list
> CoreSight@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/coresight
