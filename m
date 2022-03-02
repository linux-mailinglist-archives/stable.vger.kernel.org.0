Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6771D4CA60B
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 14:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbiCBNbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 08:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbiCBNbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 08:31:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07DDCC558C
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 05:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646227862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vpr93uN6MxOxe9fXO/50h3J2w847QD18h7MxHrR4EFI=;
        b=CIrglCa/5s+ESXIdci/qT3yNhB6tPlfta6tnO6MPoqhfDv54n2KpN9HuiGhrxJmzXyGSPC
        Ldu2/claDrlbzXuhmeD1TJ9O4UZqWOu68TngNZPxWwi2sOXXDhKbbgqAaem3UoQLXLyMnr
        GIGB/0mbmRX1rHzTdsESWeEAlbiURfs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-8imLaXfrN1mNe_Tualqf3w-1; Wed, 02 Mar 2022 08:31:00 -0500
X-MC-Unique: 8imLaXfrN1mNe_Tualqf3w-1
Received: by mail-wm1-f72.google.com with SMTP id f12-20020a7bcd0c000000b00384993440cfso590460wmj.3
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 05:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vpr93uN6MxOxe9fXO/50h3J2w847QD18h7MxHrR4EFI=;
        b=1YEwI9lcfsrSmoPckYPSQdUVamrRWbg4d0GRPDc2w37uwvMOmt1QzZEQkN8LD3xSlh
         yG7Ow59piLwIvIgqk6bznYMafezsnKzhHYGJ5+obCXXsGa2rQnHxUMLJu6LKzQnVr8D+
         3EBKMp7N+pRr9+YGD9PALfeJ3vguiZmRPCPYknrV1WN7i+r1J/mHDclBiy86OtY7m+Dz
         4UlNCHwb11Jm0SyW732+3yyPC9XRJT1YnyE0mQs2lov7DF2BT1NTb6QnZl7a+rdOGeGg
         oSzjfwMdYOSYgkib3mlVJBONmpAfXUbUmnq+ln6K6qEvcEo/C6azbM3oNtgoP3FB3wAq
         h1Ag==
X-Gm-Message-State: AOAM532aPbJTqD4DnCH5kymiXdfwQGc6VPVih/0Hc+XYshcgq82Rw5rw
        nfH6whCGZwuGEfZKb1Et+4RqCRSrVzy1EJ8iRgz8qSMrTAdwZc1ot4pVjH0VHfZwquYtp7etQhO
        fXgQ+KdokHAoxfW/d
X-Received: by 2002:a5d:4089:0:b0:1f0:4819:61ba with SMTP id o9-20020a5d4089000000b001f0481961bamr706806wrp.307.1646227857897;
        Wed, 02 Mar 2022 05:30:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB5w9pGnsT+Lg3Clzc3lJA6rrR//BxxGl8wdCoogL6jR5Pnb1QZrgmJ3q8QCWDn1myvFVNdQ==
X-Received: by 2002:a5d:4089:0:b0:1f0:4819:61ba with SMTP id o9-20020a5d4089000000b001f0481961bamr706789wrp.307.1646227857681;
        Wed, 02 Mar 2022 05:30:57 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05600c3d8600b00381590dbb25sm9721486wmb.3.2022.03.02.05.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 05:30:56 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:30:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302082021-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302075421.2131221-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.
> 
> Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/vhost/vhost.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..bbaff6a5e21b8 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}

So this is a mitigation plan but the bug is still there though
we don't know exactly what it is.  I would prefer adding something like
WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?



>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.574.g5d30c73bfb-goog

