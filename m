Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D74D0B41
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 23:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbiCGWiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 17:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245253AbiCGWiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 17:38:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B38FF617A
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 14:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646692644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z8UjngamxI9B+AYkCciPjNfNT+6reXZ4EgmCRb4lE+4=;
        b=VvZBppX4Wdj/1B0/uvcNJRDI6jmsjKMiJ+xt6lsw6GsxQDN0uQ23b2NftRju3K2wLWp3VQ
        ZNHSNH8ENFU69FqAohDDdQwoBAsv/Nei1erAxXDIuG5Z7Cu7D71fj0c/3yNM0eOjroGe1i
        jtPq79h5b18NV8Mw9I6SF5mDKlcJFW8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-og_FYh0-M5ueqy8wS1LPHw-1; Mon, 07 Mar 2022 17:37:23 -0500
X-MC-Unique: og_FYh0-M5ueqy8wS1LPHw-1
Received: by mail-ej1-f71.google.com with SMTP id m4-20020a170906160400b006be3f85906eso7673580ejd.23
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 14:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8UjngamxI9B+AYkCciPjNfNT+6reXZ4EgmCRb4lE+4=;
        b=k4ZeOPVVFNhN5rWQCq4Ux4NJmegW1lRyMsLPl1bgHYHU+syvwbZ5Yw/EbKYlh5G3MP
         K3x3JGTkO4Ncpnst+0gUrS3dEUIAKxJVTDS/YkGzBBr6aVYbInQbK65OF3q1bjIC67TR
         6r+9VPkOxb/csrqPk9+OyI142jnI2kPRcF+k3xadTuddOyoUeuV/JEmir65ATQPUnuCv
         z5ozg0hE7LYACbHs1t83XYiXBmQsCtxh6Roe9C4xubNURlqa13Ez6dkHHQuh3ZjJ+kl5
         gmmLO7S5jZ8GrzmQV1syMQMSl3SJvZI+xgXXTEe1rajfoQc5upwCDk2ZGPstxojAt2kT
         hX6Q==
X-Gm-Message-State: AOAM532vydwm6xFW/R6JU0Aflz663ZGl72HdFL8yRIvc48rgwPrEPmcZ
        XUiIT3toQvcibdZtYxnGw4L4nKefpT04b7cPPbRB+AkaGszOyc5whx6d/R1+1/tAQaqMOEyx/LS
        OvofO5y4W1pnz+pRH
X-Received: by 2002:a05:6402:644:b0:416:4ade:54e3 with SMTP id u4-20020a056402064400b004164ade54e3mr5993879edx.222.1646692642158;
        Mon, 07 Mar 2022 14:37:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDQfReYKCLxP7wgXRhk5w7cO+7IyYbZrZcsq5S+N9M32u3NyUw3dG6w3ZKY6BWETW8k6zHrA==
X-Received: by 2002:a05:6402:644:b0:416:4ade:54e3 with SMTP id u4-20020a056402064400b004164ade54e3mr5993869edx.222.1646692641977;
        Mon, 07 Mar 2022 14:37:21 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906d20e00b006cee22553f7sm5205644ejz.213.2022.03.07.14.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:37:21 -0800 (PST)
Date:   Mon, 7 Mar 2022 17:37:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220307173439-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307191757.3177139-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do here is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.

Pls just basically copy the code comment here. this is just confuses.

> Also WARN() as a precautionary measure.  The purpose of this is to
> capture possible future race conditions which may pop up over time.
> 
> Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00

And this is a bug we already fixed, right?

> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com

not really applicable anymore ...

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
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		/* No workers should run here by design. However, races have
> +		 * previously occurred where drivers have been unable to flush
> +		 * all work properly prior to clean-up.  Without a successful
> +		 * flush the guest will malfunction, but avoiding host memory
> +		 * corruption in those cases does seem preferable.
> +		 */
> +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> +
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}
>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.616.g0bdcbb4464-goog

