Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE503109F7
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 12:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhBELJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 06:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhBELHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 06:07:54 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00DEC0613D6
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 03:07:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id my11so6520521pjb.1
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 03:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1hdMWlmk5YEdixgSMaKDeoTizB932zjL3/J7moXf5/I=;
        b=lW9AIc6WoFPb5QZaU+8P2TKZ785Clc8IAJAaJY3df4oYjktPB4EHvieFtbz8UH1Ix8
         j7DEqSE4NmjedQZuDDqy1RmqhdziIiQBEJ7LBgbrXqtD1JxrEdo6o7Jm3yg4StPr4cOC
         BxN2V6jFs1gQwrD9BrkjfJhnWmPqMxQsN74xXTWuCuG+fp6mIYqpZmEOhACPDrZRXaoN
         +mjowlZG+nOtMMaKWPXUUHFmCc+8gdBGVbfwK029E77VHfuWFlPc2ZyaF94yF4x3XMLV
         o2wxdU+NEGHX/czel/6SpaShXAScZApjuDbI71aqVmWMh/KynWCqEeDqwxW7LVQ8KfhZ
         puPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1hdMWlmk5YEdixgSMaKDeoTizB932zjL3/J7moXf5/I=;
        b=Wu4SyLuBsuDW63kcgSzg+PiHmYmKjLPQjqWJexVr2H8PDXGuD6K7jfBhrjwrf79EhV
         RLyswq1riUmc8YuqJbR30dE4meRxQSpiSMYkITiOuJcqjj4UdB5SENvf1SI3y1MDcbnn
         VuvLOiF0H/RmKMIPGnHC3GnXH19zwKlMpxm14ft9s+ektSPUa9ZQzLo38BPOo/cfLQWZ
         fkEx6lNip9RA3V+cs7cNLTihhF1p9gAuYKfXz0y5J+1uFZbj+8GMYMKsttU1fvvsSnw0
         FaJ+U6q5Ymk+VBktaKhggmvzprphChTegsGJmYUrfS8RlxRolLY9mkKrQ3YaSfeqJIyy
         MLmQ==
X-Gm-Message-State: AOAM533eP6e/SG+BTCUX+aQz97HNCOkC3qJ8c1NSJVk+pj+8rmeX/88G
        7S3gxG6G/Q1JM6aSiIsWx3DCCqYpPd6UOFD1TW8=
X-Google-Smtp-Source: ABdhPJwXwXft7K8+pvgdVwoJwJjVicach0hYEF926lAL/YPqX+HaTxHYmNcdz2Zt4YaFMyUegRuoA/DBfaJG2dNgBdY=
X-Received: by 2002:a17:90a:ee8a:: with SMTP id i10mr3649263pjz.210.1612523233479;
 Fri, 05 Feb 2021 03:07:13 -0800 (PST)
MIME-Version: 1.0
References: <161245078761138@kroah.com>
In-Reply-To: <161245078761138@kroah.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 5 Feb 2021 03:07:02 -0800
Message-ID: <CAJht_EP5oijCxg-uj9YW8KV+fQESCrTfGZAfq99O2jNGRXWd9Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] net: lapb: Add locking to the lapb module"
 failed to apply to 5.10-stable tree
To:     gregkh@linuxfoundation.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 4, 2021 at 6:59 AM <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch only fixes a theoretical race condition. I'm not sure the
race condition is really affecting users. Is it necessary to apply
this patch to stable branches?

> ------------------ original commit in Linus's tree ------------------
>
> From b491e6a7391e3ecdebdd7a097550195cc878924a Mon Sep 17 00:00:00 2001
> From: Xie He <xie.he.0141@gmail.com>
> Date: Mon, 25 Jan 2021 20:09:39 -0800
> Subject: [PATCH] net: lapb: Add locking to the lapb module
>
> In the lapb module, the timers may run concurrently with other code in
> this module, and there is currently no locking to prevent the code from
> racing on "struct lapb_cb". This patch adds locking to prevent racing.
>
> 1. Add "spinlock_t lock" to "struct lapb_cb"; Add "spin_lock_bh" and
> "spin_unlock_bh" to APIs, timer functions and notifier functions.
>
> 2. Add "bool t1timer_stop, t2timer_stop" to "struct lapb_cb" to make us
> able to ask running timers to abort; Modify "lapb_stop_t1timer" and
> "lapb_stop_t2timer" to make them able to abort running timers;
> Modify "lapb_t2timer_expiry" and "lapb_t1timer_expiry" to make them
> abort after they are stopped by "lapb_stop_t1timer", "lapb_stop_t2timer",
> and "lapb_start_t1timer", "lapb_start_t2timer".
>
> 3. Let lapb_unregister wait for other API functions and running timers
> to stop.
>
> 4. The lapb_device_event function calls lapb_disconnect_request. In
> order to avoid trying to hold the lock twice, add a new function named
> "__lapb_disconnect_request" which assumes the lock is held, and make
> it called by lapb_disconnect_request and lapb_device_event.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> Link: https://lore.kernel.org/r/20210126040939.69995-1-xie.he.0141@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> diff --git a/include/net/lapb.h b/include/net/lapb.h
> index ccc3d1f020b0..eee73442a1ba 100644
> --- a/include/net/lapb.h
> +++ b/include/net/lapb.h
> @@ -92,6 +92,7 @@ struct lapb_cb {
>         unsigned short          n2, n2count;
>         unsigned short          t1, t2;
>         struct timer_list       t1timer, t2timer;
> +       bool                    t1timer_stop, t2timer_stop;
>
>         /* Internal control information */
>         struct sk_buff_head     write_queue;
> @@ -103,6 +104,7 @@ struct lapb_cb {
>         struct lapb_frame       frmr_data;
>         unsigned char           frmr_type;
>
> +       spinlock_t              lock;
>         refcount_t              refcnt;
>  };
>
> diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
> index 40961889e9c0..0511bbe4af7b 100644
> --- a/net/lapb/lapb_iface.c
> +++ b/net/lapb/lapb_iface.c
> @@ -122,6 +122,8 @@ static struct lapb_cb *lapb_create_cb(void)
>
>         timer_setup(&lapb->t1timer, NULL, 0);
>         timer_setup(&lapb->t2timer, NULL, 0);
> +       lapb->t1timer_stop = true;
> +       lapb->t2timer_stop = true;
>
>         lapb->t1      = LAPB_DEFAULT_T1;
>         lapb->t2      = LAPB_DEFAULT_T2;
> @@ -129,6 +131,8 @@ static struct lapb_cb *lapb_create_cb(void)
>         lapb->mode    = LAPB_DEFAULT_MODE;
>         lapb->window  = LAPB_DEFAULT_WINDOW;
>         lapb->state   = LAPB_STATE_0;
> +
> +       spin_lock_init(&lapb->lock);
>         refcount_set(&lapb->refcnt, 1);
>  out:
>         return lapb;
> @@ -178,11 +182,23 @@ int lapb_unregister(struct net_device *dev)
>                 goto out;
>         lapb_put(lapb);
>
> +       /* Wait for other refs to "lapb" to drop */
> +       while (refcount_read(&lapb->refcnt) > 2)
> +               usleep_range(1, 10);
> +
> +       spin_lock_bh(&lapb->lock);
> +
>         lapb_stop_t1timer(lapb);
>         lapb_stop_t2timer(lapb);
>
>         lapb_clear_queues(lapb);
>
> +       spin_unlock_bh(&lapb->lock);
> +
> +       /* Wait for running timers to stop */
> +       del_timer_sync(&lapb->t1timer);
> +       del_timer_sync(&lapb->t2timer);
> +
>         __lapb_remove_cb(lapb);
>
>         lapb_put(lapb);
> @@ -201,6 +217,8 @@ int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
>         if (!lapb)
>                 goto out;
>
> +       spin_lock_bh(&lapb->lock);
> +
>         parms->t1      = lapb->t1 / HZ;
>         parms->t2      = lapb->t2 / HZ;
>         parms->n2      = lapb->n2;
> @@ -219,6 +237,7 @@ int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
>         else
>                 parms->t2timer = (lapb->t2timer.expires - jiffies) / HZ;
>
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>         rc = LAPB_OK;
>  out:
> @@ -234,6 +253,8 @@ int lapb_setparms(struct net_device *dev, struct lapb_parms_struct *parms)
>         if (!lapb)
>                 goto out;
>
> +       spin_lock_bh(&lapb->lock);
> +
>         rc = LAPB_INVALUE;
>         if (parms->t1 < 1 || parms->t2 < 1 || parms->n2 < 1)
>                 goto out_put;
> @@ -256,6 +277,7 @@ int lapb_setparms(struct net_device *dev, struct lapb_parms_struct *parms)
>
>         rc = LAPB_OK;
>  out_put:
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>  out:
>         return rc;
> @@ -270,6 +292,8 @@ int lapb_connect_request(struct net_device *dev)
>         if (!lapb)
>                 goto out;
>
> +       spin_lock_bh(&lapb->lock);
> +
>         rc = LAPB_OK;
>         if (lapb->state == LAPB_STATE_1)
>                 goto out_put;
> @@ -285,24 +309,18 @@ int lapb_connect_request(struct net_device *dev)
>
>         rc = LAPB_OK;
>  out_put:
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>  out:
>         return rc;
>  }
>  EXPORT_SYMBOL(lapb_connect_request);
>
> -int lapb_disconnect_request(struct net_device *dev)
> +static int __lapb_disconnect_request(struct lapb_cb *lapb)
>  {
> -       struct lapb_cb *lapb = lapb_devtostruct(dev);
> -       int rc = LAPB_BADTOKEN;
> -
> -       if (!lapb)
> -               goto out;
> -
>         switch (lapb->state) {
>         case LAPB_STATE_0:
> -               rc = LAPB_NOTCONNECTED;
> -               goto out_put;
> +               return LAPB_NOTCONNECTED;
>
>         case LAPB_STATE_1:
>                 lapb_dbg(1, "(%p) S1 TX DISC(1)\n", lapb->dev);
> @@ -310,12 +328,10 @@ int lapb_disconnect_request(struct net_device *dev)
>                 lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON, LAPB_COMMAND);
>                 lapb->state = LAPB_STATE_0;
>                 lapb_start_t1timer(lapb);
> -               rc = LAPB_NOTCONNECTED;
> -               goto out_put;
> +               return LAPB_NOTCONNECTED;
>
>         case LAPB_STATE_2:
> -               rc = LAPB_OK;
> -               goto out_put;
> +               return LAPB_OK;
>         }
>
>         lapb_clear_queues(lapb);
> @@ -328,8 +344,22 @@ int lapb_disconnect_request(struct net_device *dev)
>         lapb_dbg(1, "(%p) S3 DISC(1)\n", lapb->dev);
>         lapb_dbg(0, "(%p) S3 -> S2\n", lapb->dev);
>
> -       rc = LAPB_OK;
> -out_put:
> +       return LAPB_OK;
> +}
> +
> +int lapb_disconnect_request(struct net_device *dev)
> +{
> +       struct lapb_cb *lapb = lapb_devtostruct(dev);
> +       int rc = LAPB_BADTOKEN;
> +
> +       if (!lapb)
> +               goto out;
> +
> +       spin_lock_bh(&lapb->lock);
> +
> +       rc = __lapb_disconnect_request(lapb);
> +
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>  out:
>         return rc;
> @@ -344,6 +374,8 @@ int lapb_data_request(struct net_device *dev, struct sk_buff *skb)
>         if (!lapb)
>                 goto out;
>
> +       spin_lock_bh(&lapb->lock);
> +
>         rc = LAPB_NOTCONNECTED;
>         if (lapb->state != LAPB_STATE_3 && lapb->state != LAPB_STATE_4)
>                 goto out_put;
> @@ -352,6 +384,7 @@ int lapb_data_request(struct net_device *dev, struct sk_buff *skb)
>         lapb_kick(lapb);
>         rc = LAPB_OK;
>  out_put:
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>  out:
>         return rc;
> @@ -364,7 +397,9 @@ int lapb_data_received(struct net_device *dev, struct sk_buff *skb)
>         int rc = LAPB_BADTOKEN;
>
>         if (lapb) {
> +               spin_lock_bh(&lapb->lock);
>                 lapb_data_input(lapb, skb);
> +               spin_unlock_bh(&lapb->lock);
>                 lapb_put(lapb);
>                 rc = LAPB_OK;
>         }
> @@ -435,6 +470,8 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
>         if (!lapb)
>                 return NOTIFY_DONE;
>
> +       spin_lock_bh(&lapb->lock);
> +
>         switch (event) {
>         case NETDEV_UP:
>                 lapb_dbg(0, "(%p) Interface up: %s\n", dev, dev->name);
> @@ -454,7 +491,7 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
>                 break;
>         case NETDEV_GOING_DOWN:
>                 if (netif_carrier_ok(dev))
> -                       lapb_disconnect_request(dev);
> +                       __lapb_disconnect_request(lapb);
>                 break;
>         case NETDEV_DOWN:
>                 lapb_dbg(0, "(%p) Interface down: %s\n", dev, dev->name);
> @@ -489,6 +526,7 @@ static int lapb_device_event(struct notifier_block *this, unsigned long event,
>                 break;
>         }
>
> +       spin_unlock_bh(&lapb->lock);
>         lapb_put(lapb);
>         return NOTIFY_DONE;
>  }
> diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
> index baa247fe4ed0..0230b272b7d1 100644
> --- a/net/lapb/lapb_timer.c
> +++ b/net/lapb/lapb_timer.c
> @@ -40,6 +40,7 @@ void lapb_start_t1timer(struct lapb_cb *lapb)
>         lapb->t1timer.function = lapb_t1timer_expiry;
>         lapb->t1timer.expires  = jiffies + lapb->t1;
>
> +       lapb->t1timer_stop = false;
>         add_timer(&lapb->t1timer);
>  }
>
> @@ -50,16 +51,19 @@ void lapb_start_t2timer(struct lapb_cb *lapb)
>         lapb->t2timer.function = lapb_t2timer_expiry;
>         lapb->t2timer.expires  = jiffies + lapb->t2;
>
> +       lapb->t2timer_stop = false;
>         add_timer(&lapb->t2timer);
>  }
>
>  void lapb_stop_t1timer(struct lapb_cb *lapb)
>  {
> +       lapb->t1timer_stop = true;
>         del_timer(&lapb->t1timer);
>  }
>
>  void lapb_stop_t2timer(struct lapb_cb *lapb)
>  {
> +       lapb->t2timer_stop = true;
>         del_timer(&lapb->t2timer);
>  }
>
> @@ -72,16 +76,31 @@ static void lapb_t2timer_expiry(struct timer_list *t)
>  {
>         struct lapb_cb *lapb = from_timer(lapb, t, t2timer);
>
> +       spin_lock_bh(&lapb->lock);
> +       if (timer_pending(&lapb->t2timer)) /* A new timer has been set up */
> +               goto out;
> +       if (lapb->t2timer_stop) /* The timer has been stopped */
> +               goto out;
> +
>         if (lapb->condition & LAPB_ACK_PENDING_CONDITION) {
>                 lapb->condition &= ~LAPB_ACK_PENDING_CONDITION;
>                 lapb_timeout_response(lapb);
>         }
> +
> +out:
> +       spin_unlock_bh(&lapb->lock);
>  }
>
>  static void lapb_t1timer_expiry(struct timer_list *t)
>  {
>         struct lapb_cb *lapb = from_timer(lapb, t, t1timer);
>
> +       spin_lock_bh(&lapb->lock);
> +       if (timer_pending(&lapb->t1timer)) /* A new timer has been set up */
> +               goto out;
> +       if (lapb->t1timer_stop) /* The timer has been stopped */
> +               goto out;
> +
>         switch (lapb->state) {
>
>                 /*
> @@ -108,7 +127,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>                                 lapb->state = LAPB_STATE_0;
>                                 lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
>                                 lapb_dbg(0, "(%p) S1 -> S0\n", lapb->dev);
> -                               return;
> +                               goto out;
>                         } else {
>                                 lapb->n2count++;
>                                 if (lapb->mode & LAPB_EXTENDED) {
> @@ -132,7 +151,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>                                 lapb->state = LAPB_STATE_0;
>                                 lapb_disconnect_confirmation(lapb, LAPB_TIMEDOUT);
>                                 lapb_dbg(0, "(%p) S2 -> S0\n", lapb->dev);
> -                               return;
> +                               goto out;
>                         } else {
>                                 lapb->n2count++;
>                                 lapb_dbg(1, "(%p) S2 TX DISC(1)\n", lapb->dev);
> @@ -150,7 +169,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>                                 lapb_stop_t2timer(lapb);
>                                 lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
>                                 lapb_dbg(0, "(%p) S3 -> S0\n", lapb->dev);
> -                               return;
> +                               goto out;
>                         } else {
>                                 lapb->n2count++;
>                                 lapb_requeue_frames(lapb);
> @@ -167,7 +186,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>                                 lapb->state = LAPB_STATE_0;
>                                 lapb_disconnect_indication(lapb, LAPB_TIMEDOUT);
>                                 lapb_dbg(0, "(%p) S4 -> S0\n", lapb->dev);
> -                               return;
> +                               goto out;
>                         } else {
>                                 lapb->n2count++;
>                                 lapb_transmit_frmr(lapb);
> @@ -176,4 +195,7 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>         }
>
>         lapb_start_t1timer(lapb);
> +
> +out:
> +       spin_unlock_bh(&lapb->lock);
>  }
>
