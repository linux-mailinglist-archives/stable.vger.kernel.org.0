Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9B57D68A
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiGUWJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiGUWJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 18:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C462C951DB
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 15:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658441340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yVieBIY4tlglZwilyTVRxHw1CLIjvl9/EuHCFz2oMjU=;
        b=Kiz+u+q+LVt1pygvM8zmqAQ72TXOmqagvUlMzKPwiivyv75n42eLi3mPFyb5fhALnIMW+D
        go9WwBlSPXO5sYWP71kJQzBNnOsnVTlNU/IHlFHCtsh7l5gse+yKg4mnh7uKY1Cml6x2Wz
        q/b6aPZWvUC24hMMHu5K5Z+8o5NMd2s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-2CT2geMEPzKhJXEMn-NBkA-1; Thu, 21 Jul 2022 18:08:59 -0400
X-MC-Unique: 2CT2geMEPzKhJXEMn-NBkA-1
Received: by mail-qk1-f199.google.com with SMTP id l15-20020a05620a28cf00b006b46997c070so2353617qkp.20
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 15:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVieBIY4tlglZwilyTVRxHw1CLIjvl9/EuHCFz2oMjU=;
        b=JqxxCziVcW3leDMdWXF51SRtz6WCj6cx6z+kKqtpV5CdVLvkrM4VepLWDFOzAfip0Y
         g3p+pxjI2ZdythmFKtStHbckGUZOLBG2k8TWHqanhtOumGlrJBNaBV1UrNrJZC9TEroo
         CuUqzNhU1mYQz4IiXi/GIsej7il2SCWrFjZk0jwlNgt52/WN7utMOBgKx4atf8WlBO97
         vNNdfJBRNUUusOo+5Ncbpgwsq5169pvAV1rri5omkbb6riwLH1rDOB6dT2rKyFRsfcDy
         ernaIg3kACtwQHoRTtR6FD3AXu3i2I/KHjroThyuUe8jBfsUV/szQh0i9s2tpt7REzwj
         zLzg==
X-Gm-Message-State: AJIora9IDzCw6RB3+CuspCUXlB3/InuMkcpIRy1i6Wsf+vLdJdizfmix
        6oTF/0s0nElq0yNhXLDdD60iksDHvc+vG4Mhl/V+t9rGfIxN90Oa+B94xb9X6Judq9KwSYz2CNx
        0NdhnbERyRtAXYSXzVcHS1mQTi4C//c9/
X-Received: by 2002:a05:622a:1316:b0:31e:f3b4:1c8c with SMTP id v22-20020a05622a131600b0031ef3b41c8cmr647940qtk.339.1658441338900;
        Thu, 21 Jul 2022 15:08:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sfkcVKkhADjHcjhtERK2K5twxorfbmKHwbyNtio0tAuPjfGCWzd2BVM3TDm8t5HhokYvuTFIqEPpWP8vL9NfA=
X-Received: by 2002:a05:622a:1316:b0:31e:f3b4:1c8c with SMTP id
 v22-20020a05622a131600b0031ef3b41c8cmr647919qtk.339.1658441338626; Thu, 21
 Jul 2022 15:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220721215340.936838-1-aahringo@redhat.com> <20220721215340.936838-4-aahringo@redhat.com>
In-Reply-To: <20220721215340.936838-4-aahringo@redhat.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 21 Jul 2022 18:08:47 -0400
Message-ID: <CAK-6q+hpc5sd27-C93c9gDc26q9N_+pNjeg7YGDa1ju2dcXOJQ@mail.gmail.com>
Subject: Re: [PATCH dlm/next 3/3] fs: dlm: fix refcount handling for dlm_add_cb()
To:     David Teigland <teigland@redhat.com>
Cc:     cluster-devel <cluster-devel@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
> +
>   out:
>         mutex_unlock(&lkb->lkb_cb_mutex);
>  }
> @@ -303,9 +310,7 @@ void dlm_callback_resume(struct dlm_ls *ls)
>  {
>         struct dlm_lkb *lkb, *safe;
>         int count = 0, sum = 0;
> -       bool empty;
> -
> -       clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
> +       bool empty, queued;
>
>         if (!ls->ls_callback_wq)
>                 return;
> @@ -314,12 +319,16 @@ void dlm_callback_resume(struct dlm_ls *ls)
>         mutex_lock(&ls->ls_cb_mutex);
>         list_for_each_entry_safe(lkb, safe, &ls->ls_cb_delay, lkb_cb_list) {
>                 list_del_init(&lkb->lkb_cb_list);
> -               queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
> +               queued = queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
> +               WARN_ON_ONCE(!queued);

grml, that should be "!queue_work(ls->ls_callback_wq,
&lkb->lkb_cb_work);" and then "WARN_ON_ONCE(queued);" to follow the
same as above in dlm_add_cb(). Whereas queued is true as it is already
queued for work.

- Alex

