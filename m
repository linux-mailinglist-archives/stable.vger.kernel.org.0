Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3235D00B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbhDLSKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbhDLSKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:10:49 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C27AC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:10:31 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v3so12825314ybi.1
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mn3OCywDRZkP1D53sggo9Cti3rBzA923j4XafMX45Lk=;
        b=G79x43s5GSxjpLh78MalK7jRQUDbDKzdM9eK1xy2mjrTmnNckvuSdIMyg9MpBGkRki
         rcMQZ0vWqPw4ro33zRxIxEL4FLkdEnlCcWCuwFq7SALjygFp0yHULArTuBYuA35D9Av9
         Fk1OaMzLg64tc+ykhSjHbdjF7utDuDtHBw6o6p7UCZ1Rse3g+ghBsVu+J/Xe9jSbsU+d
         K29RpE0jzTxQhO/ywSOuQSS04lOXRf6onZRutvX5HHjRX43ltXx/utb6aWXtOcPFYa0o
         Vw250XqJuxwuY+VXYZnCmRI63rGaMX12E6QQ7gVZ7Wuqtza+taFQ5XWdhdRIhU5E+VHm
         sOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mn3OCywDRZkP1D53sggo9Cti3rBzA923j4XafMX45Lk=;
        b=oaLYntunEQLfECUWMuCDohGxkJzn5LAPLRNLcSpTf8DgzA0HcH2WW6IgLp/rHsbV3i
         EoTASv8d5SCFDfp/3UcC8pbZxTBY0b/NLOnMvueIjjsdak7DDKY8Nf7mbkKJ65EVf3XQ
         PkJcf1CAB8X6ypo5A0eGxEIXOw/shFshF80vHzUC128j4a+rhcv9b4KOYUSp/MOY4MC5
         xBsHG+6Zezmx3XzWUf9sOINVWFk9DTpnuT8/B5R/Ew+babd2T/2OREhHdG7M9tqnjCNN
         zQe0POBeR48k5FosPGx0L0GKXD3Xfi0Mt8X7snjmVxvhVmNaNkPt/zQNvBsLXEJ9l4nZ
         wFQg==
X-Gm-Message-State: AOAM531f3SpfrNPdNZsnF6FQMQJEt7nLIfiyI0ytRBmnHnhcS5G06UJN
        2hC9Y1ZXhYuZin+DKBvLRwWGNaL3fnrfHFBdOkzw3g==
X-Google-Smtp-Source: ABdhPJw5ZXnh0jFx+CgXkBBtFHtphcPRkHZ7y4SYY//cqnLLomEbmmlsRyESzfpw9IJ/Q3QqBWK9Ci1HAprLGgPWHFk=
X-Received: by 2002:a25:58d5:: with SMTP id m204mr40720301ybb.32.1618251030307;
 Mon, 12 Apr 2021 11:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <1618125776191186@kroah.com>
In-Reply-To: <1618125776191186@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 12 Apr 2021 11:09:54 -0700
Message-ID: <CAGETcx-Xr6ePxeDr4HyH3oX5g+=e0ShqYqO1tHmArFmWzaMbFA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] driver core: Fix locking bug in" failed to
 apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 11, 2021 at 12:23 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I sent a patch that should resolve the conflict for 4.19 and 5.4.
https://lore.kernel.org/lkml/20210412180907.1980874-1-saravanak@google.com/T/#u

-Saravana

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From eed6e41813deb9ee622cd9242341f21430d7789f Mon Sep 17 00:00:00 2001
> From: Saravana Kannan <saravanak@google.com>
> Date: Thu, 1 Apr 2021 21:03:40 -0700
> Subject: [PATCH] driver core: Fix locking bug in
>  deferred_probe_timeout_work_func()
>
> list_for_each_entry_safe() is only useful if we are deleting nodes in a
> linked list within the loop. It doesn't protect against other threads
> adding/deleting nodes to the list in parallel. We need to grab
> deferred_probe_mutex when traversing the deferred_probe_pending_list.
>
> Cc: stable@vger.kernel.org
> Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index e2cf3b29123e..37a5e5f8b221 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -292,14 +292,16 @@ int driver_deferred_probe_check_state(struct device *dev)
>
>  static void deferred_probe_timeout_work_func(struct work_struct *work)
>  {
> -       struct device_private *private, *p;
> +       struct device_private *p;
>
>         driver_deferred_probe_timeout = 0;
>         driver_deferred_probe_trigger();
>         flush_work(&deferred_probe_work);
>
> -       list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
> -               dev_info(private->device, "deferred probe pending\n");
> +       mutex_lock(&deferred_probe_mutex);
> +       list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
> +               dev_info(p->device, "deferred probe pending\n");
> +       mutex_unlock(&deferred_probe_mutex);
>         wake_up_all(&probe_timeout_waitqueue);
>  }
>  static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
>
