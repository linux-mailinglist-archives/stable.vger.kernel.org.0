Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC5C4CA882
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 15:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiCBOvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 09:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiCBOvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 09:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2C3338D8D
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 06:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646232647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vyTbPbzLV6BhTjCf6yQIefb7DNZSD/rDYL7+DnSGw1A=;
        b=YZLdAd6V85Awe2c9qQHQLoXrERYxZDfGWwTNM3i5oQrNoMqghiPBn/DsnGvvVnWTz20qZM
        iYhffMhkhZ+yM7Je9hKmZEgRwhv0Ey52RvASc9SlKNGDP1+RRRd5jyxcVDTLoxHpxasHip
        wFLfl0hTxzAKP/M0UncNHd4VoUdluBo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-Q9ZEea_iMZi47O4oWblj7A-1; Wed, 02 Mar 2022 09:50:43 -0500
X-MC-Unique: Q9ZEea_iMZi47O4oWblj7A-1
Received: by mail-wr1-f70.google.com with SMTP id e6-20020a5d4e86000000b001f045d4a962so533369wru.21
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 06:50:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vyTbPbzLV6BhTjCf6yQIefb7DNZSD/rDYL7+DnSGw1A=;
        b=KcKcnqcAIGfI2A83lU9Txb5A0GFcS7Z/SGAJYXBkzCq0CHzaxbu5U5pqHHGH9KCUoO
         tZFQNnpxQ3cHK9n/UtetV1iehGa2fO2BghhCKM5HKVKxzI+YtdFo94u205U5Ngt4vxsl
         W4+Sa9bRHZQJOu3O9Je3Rzf3uHfy524Lrh0ca8hXBaSOaiE2RYTRuAQWTf3KfLXRLRbE
         kZNi16RB3fL+8skf2THjws03ymwoKDV0fYNmm0aiL6ewM9vW5KAIupsI/oCHrGLHLT4o
         O/qkRgUHmBm132qkEZM5yRcB2GluT/iT1flE4h3D+rGu6InTdMTxdhItb0zwGa9y/ALt
         I7Mg==
X-Gm-Message-State: AOAM532IYPeyHxZuzNVHqmDx314oAro/Oo+qouvAtwClMYlCO4poa7uf
        yXp12SAnZh0b8JUDyw9+EK0cbZIBHnCv4ZFCDVlWSIU7lrfUgQV+q5+n+JcFacHR5GlPQ2kIt4Z
        HaYOqcDTITmL83ciF
X-Received: by 2002:adf:f550:0:b0:1f0:2381:ac2c with SMTP id j16-20020adff550000000b001f02381ac2cmr4323641wrp.189.1646232642007;
        Wed, 02 Mar 2022 06:50:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQNu/fXS905mfblMrRA5G2rPob+EQ5Bu1JcHzO8Z63AfxXQlVwQA2iUhIru+dm9U5yRai4qA==
X-Received: by 2002:adf:f550:0:b0:1f0:2381:ac2c with SMTP id j16-20020adff550000000b001f02381ac2cmr4323627wrp.189.1646232641759;
        Wed, 02 Mar 2022 06:50:41 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id k19-20020adfd233000000b001f0358e47bdsm1971249wrh.50.2022.03.02.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:50:41 -0800 (PST)
Date:   Wed, 2 Mar 2022 09:50:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302094946-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
 <20220302083413-mutt-send-email-mst@kernel.org>
 <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
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

On Wed, Mar 02, 2022 at 03:11:21PM +0100, Stefano Garzarella wrote:
> On Wed, Mar 02, 2022 at 08:35:08AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > >
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > 
> > > This issue is similar to [1] that should be already fixed upstream by [2].
> > > 
> > > However I think this patch would have prevented some issues, because
> > > vhost_vq_reset() sets vq->private to NULL, preventing the worker from
> > > running.
> > > 
> > > Anyway I think that when we enter in vhost_dev_cleanup() the worker should
> > > be already stopped, so it shouldn't be necessary to take the mutex. But in
> > > order to prevent future issues maybe it's better to take them, so:
> > > 
> > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > > 
> > > [1]
> > > https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> > 
> > 
> > Right. I want to queue this but I would like to get a warning
> > so we can detect issues like [2] before they cause more issues.
> 
> I agree, what about moving the warning that we already have higher up, right
> at the beginning of the function?
> 
> I mean something like this:
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..1721ff3f18c0 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -692,6 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  {
>         int i;
> +       WARN_ON(!llist_empty(&dev->work_list));
> +
>         for (i = 0; i < dev->nvqs; ++i) {
>                 if (dev->vqs[i]->error_ctx)
>                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> @@ -712,7 +714,6 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>         dev->iotlb = NULL;
>         vhost_clear_msg(dev);
>         wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
> -       WARN_ON(!llist_empty(&dev->work_list));
>         if (dev->worker) {
>                 kthread_stop(dev->worker);
>                 dev->worker = NULL;
> 

Hmm I'm not sure why it matters.

> And maybe we can also check vq->private and warn in the loop, because the
> work_list may be empty if the device is doing nothing.
> 
> Thanks,
> Stefano

