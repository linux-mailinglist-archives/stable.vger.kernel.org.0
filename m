Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F551E8D78
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 05:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgE3DMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 23:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgE3DMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 23:12:51 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A01C03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 20:12:51 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a7so4080352oic.6
        for <stable@vger.kernel.org>; Fri, 29 May 2020 20:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ipLthOZhlWCjfCgGqhHP9akhLGhL02oIECUSzKnhdsU=;
        b=S7XKQE9xLZyiTF+iYALazRiAg3tGbCm+5mZ9ye0MeN6WC26b8SXR+M3KR+12ONAvcE
         lMlmU2IEAl6Lur03HqTrf9XB9SNHsSWe4ZBu/sa3BrscBjk4QHGbKf23aGkYJMaYEnYs
         OnxK2VKEaLKuV7wrlxEqb+QTTOSqcf/qXFYuv/shYfDeNIc3+r2+p9Ms8wLz2Hs80Q0U
         3anlOzsqg3th5Oy15g8WHurexv+as/wWOLhW59nXBpOXsuQjjxESoFdbGciE2KsVFUd7
         Qf/5eU+4wXNNx8qb8+WwM5P79t7yhWuSUPlgLM6IsrPRITcZv7MBBeZX2srelGp6xxC6
         Jebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ipLthOZhlWCjfCgGqhHP9akhLGhL02oIECUSzKnhdsU=;
        b=hQmZVy9PbcCQ/BzsT+McQXzg/TwERQbB3/ves/HIC/08H6g7uXxpvZoqllr4Vut72W
         A+5GCOtLLGDaerIzIHynJEg5RVufI2wxd9PPPP++HS5A9SH+1rvh2Ea1CC8rOIQsrVTV
         QwmddF+RmjkZQBR1DvCQd6YrhqhA4zuD2gZYb2mBWTIVMuLyvngVWSSOfCCHqSkN27Sw
         g/EfYwBMyA1Ik3lA5I7CUgYq/FkJ26Fn28Ll744ZtCTEBfoBW3bRPI8TezAZvctFCa8V
         ZC2hNkAYP/IlKuUh0GM+9owHhbDuhb9AhG6X8BJ4vbUZnb+bGq5CNlY3KdZfvffACHiY
         05rg==
X-Gm-Message-State: AOAM533e8CXTUWsIcNCfwCno0gC8TOI59EHDyu/lrcXuMWzprec+ZQQ+
        jXKev7pdHyaLAc+ml3h51yFKNz5XqxOpRx+XIL0a1A==
X-Google-Smtp-Source: ABdhPJz+SEJ00DPsklbDuxrHtV/FnMK/YdJI+mB9trUlT4uu6rKRjddU446cJxURSUV9qCm3L5BonRiIupQuA6wJtP0=
X-Received: by 2002:a05:6808:5d5:: with SMTP id d21mr8436249oij.30.1590808370499;
 Fri, 29 May 2020 20:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <159065032912689@kroah.com>
In-Reply-To: <159065032912689@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 29 May 2020 20:12:14 -0700
Message-ID: <CAGETcx8ZSBYznasT7MYgMCmmr5qTcvt2OjS_B8fiicONVXQDgw@mail.gmail.com>
Subject: Re: patch "driver core: Update device link status correctly for
 SYNC_STATE_ONLY" added to driver-core-next
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     Michael Walle <michael@walle.cc>, rrafael.j.wysocki@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 12:19 AM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     driver core: Update device link status correctly for SYNC_STATE_ONLY
>
> to my driver-core git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
> in the driver-core-next branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will also be merged in the next major kernel release
> during the merge window.
>
> If you have any questions about this process, please let me know.

Not sure if this is already/automatically queued, but this needs to go
to stable@ too. Cc-ing the list to make sure it's picked up.

-Saravana

>
>
> From 8c3e315d4296421cd26b3300ee0ac117f0877f20 Mon Sep 17 00:00:00 2001
> From: Saravana Kannan <saravanak@google.com>
> Date: Tue, 26 May 2020 15:09:27 -0700
> Subject: driver core: Update device link status correctly for SYNC_STATE_ONLY
>  links
>
> When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> core: Add device link support for SYNC_STATE_ONLY flag"),
> SYNC_STATE_ONLY links were treated similar to STATELESS links in terms
> of not blocking consumer probe if the supplier hasn't probed yet.
>
> That caused a SYNC_STATE_ONLY device link's status to not get updated.
> Since SYNC_STATE_ONLY device link is no longer useful once the
> consumer probes, commit 21c27f06587d ("driver core: Fix
> SYNC_STATE_ONLY device link implementation") addresses the status
> update issue by deleting the SYNC_STATE_ONLY device link instead of
> complicating the status update code.
>
> However, there are still some cases where we need to update the status
> of a SYNC_STATE_ONLY device link. This is because a SYNC_STATE_ONLY
> device link can later get converted into a normal MANAGED device link
> when a normal MANAGED device link is created between a supplier and
> consumer that already have a SYNC_STATE_ONLY device link between them.
>
> If a SYNC_STATE_ONLY device link's status isn't maintained correctly
> till it's converted to a normal MANAGED device link, then the normal
> MANAGED device link will end up with a wrong link status. This can cause
> a warning stack trace[1] when the consumer device probes successfully.
>
> This commit fixes the SYNC_STATE_ONLY device link status update issue
> where it wouldn't transition correctly from DL_STATE_DORMANT or
> DL_STATE_AVAILABLE to DL_STATE_CONSUMER_PROBE. It also resets the status
> back to DL_STATE_DORMANT or DL_STATE_AVAILABLE if the consumer probe
> fails.
>
> [1] - https://lore.kernel.org/lkml/20200522204120.3b3c9ed6@apollo/
> Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> Fixes: 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link implementation")
> Reported-by: Michael Walle <michael@walle.cc>
> Tested-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Reviewed-by: Rafael J. Wysocki <rrafael.j.wysocki@intel.com>
> Link: https://lore.kernel.org/r/20200526220928.49939-1-saravanak@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/core.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 791b7530599f..9a76dd44cb37 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -646,9 +646,17 @@ static void device_links_missing_supplier(struct device *dev)
>  {
>         struct device_link *link;
>
> -       list_for_each_entry(link, &dev->links.suppliers, c_node)
> -               if (link->status == DL_STATE_CONSUMER_PROBE)
> +       list_for_each_entry(link, &dev->links.suppliers, c_node) {
> +               if (link->status != DL_STATE_CONSUMER_PROBE)
> +                       continue;
> +
> +               if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
>                         WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
> +               } else {
> +                       WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
> +                       WRITE_ONCE(link->status, DL_STATE_DORMANT);
> +               }
> +       }
>  }
>
>  /**
> @@ -687,11 +695,11 @@ int device_links_check_suppliers(struct device *dev)
>         device_links_write_lock();
>
>         list_for_each_entry(link, &dev->links.suppliers, c_node) {
> -               if (!(link->flags & DL_FLAG_MANAGED) ||
> -                   link->flags & DL_FLAG_SYNC_STATE_ONLY)
> +               if (!(link->flags & DL_FLAG_MANAGED))
>                         continue;
>
> -               if (link->status != DL_STATE_AVAILABLE) {
> +               if (link->status != DL_STATE_AVAILABLE &&
> +                   !(link->flags & DL_FLAG_SYNC_STATE_ONLY)) {
>                         device_links_missing_supplier(dev);
>                         ret = -EPROBE_DEFER;
>                         break;
> @@ -952,11 +960,21 @@ static void __device_links_no_driver(struct device *dev)
>                 if (!(link->flags & DL_FLAG_MANAGED))
>                         continue;
>
> -               if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER)
> +               if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER) {
>                         device_link_drop_managed(link);
> -               else if (link->status == DL_STATE_CONSUMER_PROBE ||
> -                        link->status == DL_STATE_ACTIVE)
> +                       continue;
> +               }
> +
> +               if (link->status != DL_STATE_CONSUMER_PROBE &&
> +                   link->status != DL_STATE_ACTIVE)
> +                       continue;
> +
> +               if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
>                         WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
> +               } else {
> +                       WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
> +                       WRITE_ONCE(link->status, DL_STATE_DORMANT);
> +               }
>         }
>
>         dev->links.status = DL_DEV_NO_DRIVER;
> --
> 2.26.2
>
>
