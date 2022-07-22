Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D33F57D799
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 02:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiGVAJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 20:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiGVAJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 20:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DCEF22295
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 17:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658448558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qi/AOlqLMzC+gEWWnukQzjuSvBa7cNPEJZihOrqRY1c=;
        b=Sx08zYs43JbNDH57L7/zbfndrmqttBVTzoWtaB+F5O6252QXNdFe/4kg85pBqLby3yZhvD
        UTgVnOrSWJVHyd7IR2J++VZoRmWAfa/jKyOVYh2VoXgzPkVqaDPfTheghs+xp4zVN66Baj
        8okThGbn+QdQM691ivLjofa2GxCesrg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-E0R5i18ROsKCxmawwzelrw-1; Thu, 21 Jul 2022 20:09:11 -0400
X-MC-Unique: E0R5i18ROsKCxmawwzelrw-1
Received: by mail-qk1-f197.google.com with SMTP id l189-20020a37bbc6000000b006af2596c5e8so2539959qkf.14
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 17:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qi/AOlqLMzC+gEWWnukQzjuSvBa7cNPEJZihOrqRY1c=;
        b=GM3ZOgF6OHrpBPBSUqbaC9ARGoOTGtNZ2veKs+AjumoXGoAfWQBsbQGdZ/oEniGpra
         L0ea3IFcVQFan/4rEs9IEG37zKgv6O3qEaWgHnAJdid4WP0WBIsbG3IDXZXjJ8XzrOee
         UNCqHmDNfuI1B2U5xmevh7MAuFj6fRnT4214WHZ9WPLGa0FYukqVk1athBG0ZdijdQSl
         vx/ywiiHu/UJ9LyF09RhUOJyiNmtu6JVp25RiQFbYOP5b+utdSJJ1BvU/X+Autx7DuDd
         IRHU6HZhZ+mQNDzQPfKraN1RAkehM7LbmO+1wOKGy6mhbrjL9T3GhbA+WEvWNJ72KCdF
         /H3A==
X-Gm-Message-State: AJIora8+37pJWfo9CfXX+7d9YvSJQSJ26RpwFgBDnaIBEVjd0sfSXdES
        4noIF54I8e2MiPkZqpVqAhpQLfb70CBqkO5xHpWrRY0P7MyZIfis+Y9pW78fuC+eE0KTHEaS/q/
        FQDg8aETNzS46GQA29qyJ0r7U7OL3nVsY
X-Received: by 2002:ac8:5c05:0:b0:31f:1f1f:2ab with SMTP id i5-20020ac85c05000000b0031f1f1f02abmr962108qti.123.1658448551138;
        Thu, 21 Jul 2022 17:09:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vYuc5IVGz8o2zfDxLQi3YcHU/wQviI8I6PslByi5GnWJ54LGhaIXTZWM3siWRrNN4ylZt21xFUczdONIunxnI=
X-Received: by 2002:ac8:5c05:0:b0:31f:1f1f:2ab with SMTP id
 i5-20020ac85c05000000b0031f1f1f02abmr962094qti.123.1658448550935; Thu, 21 Jul
 2022 17:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220721215340.936838-1-aahringo@redhat.com> <20220721215340.936838-4-aahringo@redhat.com>
In-Reply-To: <20220721215340.936838-4-aahringo@redhat.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 21 Jul 2022 20:09:00 -0400
Message-ID: <CAK-6q+gq2aCN5YKiqOdG8hTdyBssYHZLFE3-HSy_PFCJYZdAfw@mail.gmail.com>
Subject: Re: [PATCH dlm/next 3/3] fs: dlm: fix refcount handling for dlm_add_cb()
To:     David Teigland <teigland@redhat.com>
Cc:     cluster-devel <cluster-devel@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jul 21, 2022 at 5:53 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Each time dlm_add_cb() queues work or adds the lkb for queuing later to
> the ls->ls_cb_delay list it increments a refcount. However if the work
> is already queued or being added to the list we need to revert the
> incrementation of the refcount. The function dlm_add_cb() can be called
> multiple times without handling the related dlm_callback_work() work
> function where it's get a put call. This patch reverts the kref_get()
> when it's necessary in cases if already queued or not.
>
> In case of dlm_callback_resume() we need to ensure that the
> LSFL_CB_DELAY bit is cleared after all ls->ls_cb_delay lkbs are queued for
> work. As the ls->ls_cb_delay list handling is there for queuing work for
> later it should not be the case that a work was already queued, if so we
> drop a warning.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  fs/dlm/ast.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
> index 0271796d36b1..68e09ed8234e 100644
> --- a/fs/dlm/ast.c
> +++ b/fs/dlm/ast.c
> @@ -177,6 +177,7 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
>  {
>         struct dlm_ls *ls = lkb->lkb_resource->res_ls;
>         uint64_t new_seq, prev_seq;
> +       bool queued = true;
>         int rv;
>
>         spin_lock(&dlm_cb_seq_spin);
> @@ -202,13 +203,19 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
>
>                 mutex_lock(&ls->ls_cb_mutex);
>                 if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
> -                       if (list_empty(&lkb->lkb_cb_list))
> +                       if (list_empty(&lkb->lkb_cb_list)) {
>                                 list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
> +                               queued = false;
> +                       }
>                 } else {
> -                       queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
> +                       queued = !queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
>                 }
>                 mutex_unlock(&ls->ls_cb_mutex);
> +
> +               if (queued)
> +                       dlm_put_lkb(lkb);
>         }

I will drop this patch and 2/3, there is nothing wrong as it does a if
(!prev_seq) before and if (!prev_seq) is true it acts like if it's
already queued for list_add() and queue_work() (I believe)... however
personally, I am not happy with this how it's currently is because
this code smells like it was forgotten to take care about if it's
already queued or not. This is only working because of some other
lkb-specific handling what dlm_add_lkb_callback() and
dlm_callback_work() does regarding lkb->lkb_callbacks[0].seq - if
dlm_add_lkb_callback() would end in an "unlikely" error it would queue
nothing anymore.

Patch 1/3 is still valid and could cause problems.

- Alex

