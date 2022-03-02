Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5598A4CA61F
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiCBNf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 08:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbiCBNf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 08:35:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE734C12C4
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 05:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646228114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XGrF2OvOB13H8iRdKK89NaWHd3b3kdRWqVVkxfYHHl8=;
        b=ILmKtPwG4ecoKV8yjW1q7hWOQtzwGWfw3rWxYqjuTDC1TYbY8k55mddp3zMIn+yE+XMQA4
        9D3KWkYyN+a+FWG+rM07TuNohLwh6tUSU/u6hdIMWpIZLI7miZDNfSU/0dlofpnY1lycgA
        1GTNuNB8Y0qGkzIRitMZHnWVlh0Rnks=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-KPe1y2bTO-u2FVLCWlb0UQ-1; Wed, 02 Mar 2022 08:35:13 -0500
X-MC-Unique: KPe1y2bTO-u2FVLCWlb0UQ-1
Received: by mail-wm1-f70.google.com with SMTP id 187-20020a1c19c4000000b0037cc0d56524so1938531wmz.2
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 05:35:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XGrF2OvOB13H8iRdKK89NaWHd3b3kdRWqVVkxfYHHl8=;
        b=dGfXikVBpYOv8JMlEWU8QNGMUzxP8VqyM7n35ZCSS3+wciMK5TfvBhYglJ94q9uylu
         nKqEt74GWNJ4j8RiVPoBNDmnwDKckJ9Jp9qUQnmnlrwvGOx7KlQna9XJ1QenxdSPWj8m
         Hmr0KKr9AHUYvMz1rPa7TXGeSBvlKm31/R4s4ljwZXVwPSXIUlg5rFf54x24gQvRLlSZ
         iP8yiUEzE0mf4BbrGFy6EjCfIpRLqAuBFP8QSw8s9AqTUU+uIJ/3lEJbpaSVNZfwgN9e
         xF5Uz1RJL+y6RBe5s40fkfRLEu2mzGhyn3gVvcdukdjAKF1/jvyNWMO2K1pf+g/EWZ8k
         IuHw==
X-Gm-Message-State: AOAM5300AhUF51R8T+gXD4lyszTwo/lo1wDoMDxXpjTfc2Hj0mODGrJQ
        utOUF8H/ASOaxr+D+OwhUUcjYhfbfo5Y5K1OgQN/9gMIAWJhJ+5XYlBjVc5q4NDVjwZibuO+Huh
        8S5YJIf0GLyBSfVdf
X-Received: by 2002:a5d:6083:0:b0:1ef:761f:521f with SMTP id w3-20020a5d6083000000b001ef761f521fmr18980619wrt.238.1646228112085;
        Wed, 02 Mar 2022 05:35:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySCve85nsCTXlx9aNBZP55c5oLeOj2XJY2HKDkxKXgqQ95h2DjvN7W+40S5rrP1rYGTiozEA==
X-Received: by 2002:a5d:6083:0:b0:1ef:761f:521f with SMTP id w3-20020a5d6083000000b001ef761f521fmr18980603wrt.238.1646228111870;
        Wed, 02 Mar 2022 05:35:11 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id u23-20020a7bcb17000000b0037bdfa1665asm7640945wmj.18.2022.03.02.05.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 05:35:11 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:35:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302083413-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> 
> This issue is similar to [1] that should be already fixed upstream by [2].
> 
> However I think this patch would have prevented some issues, because
> vhost_vq_reset() sets vq->private to NULL, preventing the worker from
> running.
> 
> Anyway I think that when we enter in vhost_dev_cleanup() the worker should
> be already stopped, so it shouldn't be necessary to take the mutex. But in
> order to prevent future issues maybe it's better to take them, so:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [1]
> https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9


Right. I want to queue this but I would like to get a warning
so we can detect issues like [2] before they cause more issues.


> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> > drivers/vhost/vhost.c | 2 ++
> > 1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > 	int i;
> > 
> > 	for (i = 0; i < dev->nvqs; ++i) {
> > +		mutex_lock(&dev->vqs[i]->mutex);
> > 		if (dev->vqs[i]->error_ctx)
> > 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > 		if (dev->vqs[i]->kick)
> > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > 		if (dev->vqs[i]->call_ctx.ctx)
> > 			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > 		vhost_vq_reset(dev, dev->vqs[i]);
> > +		mutex_unlock(&dev->vqs[i]->mutex);
> > 	}
> > 	vhost_dev_free_iovecs(dev);
> > 	if (dev->log_ctx)
> > -- 
> > 2.35.1.574.g5d30c73bfb-goog
> > 

