Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57C4D0FFB
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 07:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344430AbiCHGRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 01:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344427AbiCHGRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 01:17:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3760533A35
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 22:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646720174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c5ugwLO4/RAIk+A33RH1Nda04XboyFL8Xk9nspKrv+Q=;
        b=I0tlPlUfkF0dTaXxCRgbc5ibb1tzNewSuDkSZpdkfFp9KmP88hrg4z5jQ+zLE94WOnUSdH
        zbMLGL+opulFvB+ecgjcIRzcLMU5q7XCq+QaeJUd7lmX6kgk4wEW6fDmkyW7cn4X0XyhAG
        7qSv9BfneTyFC7l714+1Uq8Qz8vC0bw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-NiyWCAENP_aceWDQh3qgdA-1; Tue, 08 Mar 2022 01:16:10 -0500
X-MC-Unique: NiyWCAENP_aceWDQh3qgdA-1
Received: by mail-lf1-f70.google.com with SMTP id cf41-20020a056512282900b00445c0a8069bso3717331lfb.8
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 22:16:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c5ugwLO4/RAIk+A33RH1Nda04XboyFL8Xk9nspKrv+Q=;
        b=yo76Vnfz5sOC7bU78MikjURo5YVnjl1ckRUYYY/CMIBq7nhBXaPFgzkijXIcmZ7sF/
         Sd4k7jjLY/9jhivBcWGfpVbPTy+5nNP3v+HqlccX/XUND9bAs7sJ5AOqbJ0YiESmswju
         UqkN6/5ZsxYq4kQxCjUZ+QUkdh3/T/JOEl6Nn8htUtbJ063Ok13qIv/5IV/jcncyNtMU
         RreZWh7oyk2fSD4QdKpRjiBwh/PlkLF6//Ji8jb5P07SwMoOq6OTJgNTjbSJEYdVpncA
         RvPK7YaJzgqhVfE/pXANd3y6bDGPOkIZ/9moBGV+AZZFzrGA7iGrlCsuJhNJyHb/98FB
         67cw==
X-Gm-Message-State: AOAM530MOXFu2/KtQ3KSw/JlCAsJMkOtweShwBsAgPkhpLt83mq4HPAC
        5IpmjBVfZlQouPhhqHSXZ1ZVeQHthXCQHUE+5cfxmDOVB+9YmmLIgAwVkjCsPjE6O1iOCBAKgGL
        nA961T6RzuUfW11p6h79h29MdET9/IoO1
X-Received: by 2002:a2e:9045:0:b0:247:da7d:a460 with SMTP id n5-20020a2e9045000000b00247da7da460mr9533967ljg.300.1646720168281;
        Mon, 07 Mar 2022 22:16:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxait3lv+dLzC+BdDFV83vSleLNh5HIk4y197ubAHp3aPkfzkCIzF+1Ixw1dsakTX8Qi9vOeSnOuGXbcvWoGxY=
X-Received: by 2002:a2e:9045:0:b0:247:da7d:a460 with SMTP id
 n5-20020a2e9045000000b00247da7da460mr9533952ljg.300.1646720167963; Mon, 07
 Mar 2022 22:16:07 -0800 (PST)
MIME-Version: 1.0
References: <20220307191757.3177139-1-lee.jones@linaro.org>
In-Reply-To: <20220307191757.3177139-1-lee.jones@linaro.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 8 Mar 2022 14:15:56 +0800
Message-ID: <CACGkMEsjmCNQPjxPjXL0WUfbMg8ARnumEp4yjUxqznMKR1nKSQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
To:     Lee Jones <lee.jones@linaro.org>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 8, 2022 at 3:18 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do here is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.
>
> Also WARN() as a precautionary measure.  The purpose of this is to
> capture possible future race conditions which may pop up over time.
>
> Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
>
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/vhost/vhost.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..ef7e371e3e649 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>         int i;
>
>         for (i = 0; i < dev->nvqs; ++i) {
> +               /* No workers should run here by design. However, races have
> +                * previously occurred where drivers have been unable to flush
> +                * all work properly prior to clean-up.  Without a successful
> +                * flush the guest will malfunction, but avoiding host memory
> +                * corruption in those cases does seem preferable.
> +                */
> +               WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> +

I don't get how this can help, the mutex could be grabbed in the
middle of the above and below line.

> +               mutex_lock(&dev->vqs[i]->mutex);
>                 if (dev->vqs[i]->error_ctx)
>                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
>                 if (dev->vqs[i]->kick)
> @@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>                 if (dev->vqs[i]->call_ctx.ctx)
>                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>                 vhost_vq_reset(dev, dev->vqs[i]);
> +               mutex_unlock(&dev->vqs[i]->mutex);
>         }

I'm not sure it's correct to assume some behaviour of a buggy device.
For the device mutex, we use that to protect more than just err/call
and vq.

Thanks

>         vhost_dev_free_iovecs(dev);
>         if (dev->log_ctx)
> --
> 2.35.1.616.g0bdcbb4464-goog
>

