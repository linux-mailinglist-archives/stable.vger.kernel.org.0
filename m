Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A470B171522
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgB0KjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:39:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60549 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728743AbgB0KjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582799958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/PM+B5NZ8mDtoj+GP1tQUBpfKiyDOBRlZTVifPZO+Y4=;
        b=FuEmeZ1PaRmviVHxXJfa/Bn+lHqaFn6cwk38Ml2vfPTNE95NkmYVKmP/nBKK5Yh5xK1cR+
        XxhUVHFnvWTq2h9sI3T013+8NwM6vvir+4hcM2vMgFoaJBQNW168nZHL4qsdAAJFwoQrRH
        S8MF/nFBhiSAUqWh+1KRxqDOlhR0+tM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-s1_KmNwzNdyUc2OZB6uo5g-1; Thu, 27 Feb 2020 05:39:16 -0500
X-MC-Unique: s1_KmNwzNdyUc2OZB6uo5g-1
Received: by mail-wr1-f69.google.com with SMTP id m13so1139006wrw.3
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 02:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/PM+B5NZ8mDtoj+GP1tQUBpfKiyDOBRlZTVifPZO+Y4=;
        b=Tg5FD4Q6BLMkr83ATO2K78sGBuDdm2kkvQ++hXY4ZDuiGrWHGxSAOVcrHsTfSthFAX
         KKarwq/SM2awqiPJpzrQA7HHdU1H+mihK686hTNa8JfFXDm9aTzQdx+7XQV/OPm0q9dq
         zuV4tx1mTsRxloqSORS45FUt2ui3CNzcN282KrgIIaw/d+JWQwCzhi5XL7aIc5NOEBE6
         sqf9DOHzNgI5WDEdBdENdFnTlF1HYs5OaY6vPCxkv94l0LhHMdi7sHqyOHv/rs4OdC9b
         Y92ePkac40eW2KTkRt30kKZJ7f7sFgOdlnPbLJ/RHHadLsJW5YlTdcmGaOSC0BPJmZ4y
         sqaA==
X-Gm-Message-State: APjAAAVdbNJbMl6mIcVEog7RVJ61lt4VtHIydZ0tyUG+DDkQGG9ImO4s
        QMGQuxXayE9zowtPnNg6KqDHO9m+6qo2yN4qMkD/gnlUxpTRfuk03Nf3RfLtX+PZrNLgwYF31nw
        mbcVcpsfo6k3Ma/Gc
X-Received: by 2002:a5d:6545:: with SMTP id z5mr4042775wrv.3.1582799954727;
        Thu, 27 Feb 2020 02:39:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqziCEE2R0rOfZLXZXtieV7Ch/Ap4GMdqHRNcmMzz3ePsIvWbK5x0JLDqlSUfINc8t3TPHv/dA==
X-Received: by 2002:a5d:6545:: with SMTP id z5mr4042752wrv.3.1582799954478;
        Thu, 27 Feb 2020 02:39:14 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id x21sm6559895wmi.30.2020.02.27.02.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 02:39:13 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:39:11 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: prevent sq_thread from spinning
 when it should stop" failed to apply to 5.4-stable tree
Message-ID: <CAGxU2F7xMBwu_5W7n_y9H9nAFnU-eMDUekb4XHR89QB3suhGHQ@mail.gmail.com>
References: <1582798350247106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582798350247106@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 11:12 AM <gregkh@linuxfoundation.org> wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Thanks, I'll send the backport for 5.4-stable tree.

Stefano

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 Mon Sep 17 00:00:00 2001
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Fri, 21 Feb 2020 16:42:16 +0100
> Subject: [PATCH] io_uring: prevent sq_thread from spinning when it should stop
>
> This patch drops 'cur_mm' before calling cond_resched(), to prevent
> the sq_thread from spinning even when the user process is finished.
>
> Before this patch, if the user process ended without closing the
> io_uring fd, the sq_thread continues to spin until the
> 'sq_thread_idle' timeout ends.
>
> In the worst case where the 'sq_thread_idle' parameter is bigger than
> INT_MAX, the sq_thread will spin forever.
>
> Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6e249aa97ba3..b43467b3a8dc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5142,6 +5142,18 @@ static int io_sq_thread(void *data)
>                  * to enter the kernel to reap and flush events.
>                  */
>                 if (!to_submit || ret == -EBUSY) {
> +                       /*
> +                        * Drop cur_mm before scheduling, we can't hold it for
> +                        * long periods (or over schedule()). Do this before
> +                        * adding ourselves to the waitqueue, as the unuse/drop
> +                        * may sleep.
> +                        */
> +                       if (cur_mm) {
> +                               unuse_mm(cur_mm);
> +                               mmput(cur_mm);
> +                               cur_mm = NULL;
> +                       }
> +
>                         /*
>                          * We're polling. If we're within the defined idle
>                          * period, then let us spin without work before going
> @@ -5156,18 +5168,6 @@ static int io_sq_thread(void *data)
>                                 continue;
>                         }
>
> -                       /*
> -                        * Drop cur_mm before scheduling, we can't hold it for
> -                        * long periods (or over schedule()). Do this before
> -                        * adding ourselves to the waitqueue, as the unuse/drop
> -                        * may sleep.
> -                        */
> -                       if (cur_mm) {
> -                               unuse_mm(cur_mm);
> -                               mmput(cur_mm);
> -                               cur_mm = NULL;
> -                       }
> -
>                         prepare_to_wait(&ctx->sqo_wait, &wait,
>                                                 TASK_INTERRUPTIBLE);
>
>


-- 
Stefano Garzarella
Software Engineer, Virt Team
Red Hat

