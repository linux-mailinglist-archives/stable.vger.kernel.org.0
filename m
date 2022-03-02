Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3274CAABC
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbiCBQuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 11:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241049AbiCBQuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 11:50:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC639CA739
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 08:49:20 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 7-20020a05600c228700b00385fd860f49so790734wmf.0
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 08:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IecOz5iKn2Rc7yD1b1vqfvTpVOYHa2wL2PoxDv2Qr/w=;
        b=VIpMijEI/uc7QRXHd8OO4zobB3xGHjz4KThVMq514TNw8RwXRYNSQBSrVjnHjxY/O3
         l2zH6Fnc4g7cXglDba8qa97Y60BjqOi/08Td2ssOClPjgo2nZjxZ5uM6JK9LNl67aDQX
         gUSqG+T8ucekupVq7KheTANlEi90R6HHLHrmK6xVXJROxoYMuVMd51xKMMPnh2UJLPox
         cVRcZ2YIOo3Y4OzB4SDJuF87jLQ7x42oV9w3qB/s1UXjEkj6bKqen/wgYWVukInOW5g2
         NiTjge+zSAtBPJp5ddERJiqnrLi83eYLRdF2Miz0jbs/TDPeruRJXTDi23qQWPGymHYs
         D9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IecOz5iKn2Rc7yD1b1vqfvTpVOYHa2wL2PoxDv2Qr/w=;
        b=iK1dxdiHEccbzrSgq+DoiFcUkrQyxDyRR7YCMFMRHGlNiBKoS1hZu9aIe+jcE8aLzH
         5JxaU3eq3o20WrKax3rdC71NY/+j/PKzfExFvqVRiW9kJcd0YYHSMKQ9OL3Pp0ots5qy
         tk72FdtKta/HXuABRpKy9Xq9Wmu+sDNBRnLoKCnKxG9ph8DG5uAO9iom8r+NxXEJAAvR
         EIMlcq7UyPuHoZtDjdqbGPA9LjqW1nwlooUwXFfoczeI4kW6torawXwTwU+5kphmYUFz
         3KsIf38NkJOV3xpV+fcR5hcBlcBIDWKzPsJmk2LgB+nS62n6644suBNi2QeVrQRlM225
         Ds8g==
X-Gm-Message-State: AOAM530o9vJAqnHHBWOxa8N2WzpwSOoEDb1tUcaw/SuqG6TLvYqWWhTH
        tLYt5Wi/RCg1L/IMPW7a1AxrYA==
X-Google-Smtp-Source: ABdhPJyfbodKVJwvZA9sMWbjL8XK8jIc29C/7YVF8TlsJ7M4ci3plCbQeVXpYLBlRnsDqwXOYk/BBw==
X-Received: by 2002:a1c:4603:0:b0:381:19fe:280b with SMTP id t3-20020a1c4603000000b0038119fe280bmr524853wma.67.1646239759465;
        Wed, 02 Mar 2022 08:49:19 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c4f8f00b003842f011bc5sm2707823wmq.2.2022.03.02.08.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:49:18 -0800 (PST)
Date:   Wed, 2 Mar 2022 16:49:17 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yh+gDZUbgBRx/1ro@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
 <Yh+F1gkCGoYF2lMV@google.com>
 <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
 <20220302112945-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302112945-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 02, 2022 at 05:28:31PM +0100, Stefano Garzarella wrote:
> > On Wed, Mar 2, 2022 at 3:57 PM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > >
> > > > On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > > > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > > > >
> > > > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > >
> > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > >
> > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > ---
> > > > > > >  drivers/vhost/vhost.c | 2 ++
> > > > > > >  1 file changed, 2 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > > > > --- a/drivers/vhost/vhost.c
> > > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > >         int i;
> > > > > > >
> > > > > > >         for (i = 0; i < dev->nvqs; ++i) {
> > > > > > > +               mutex_lock(&dev->vqs[i]->mutex);
> > > > > > >                 if (dev->vqs[i]->error_ctx)
> > > > > > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > > > > >                 if (dev->vqs[i]->kick)
> > > > > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > >                 if (dev->vqs[i]->call_ctx.ctx)
> > > > > > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > > > > >                 vhost_vq_reset(dev, dev->vqs[i]);
> > > > > > > +               mutex_unlock(&dev->vqs[i]->mutex);
> > > > > > >         }
> > > > > >
> > > > > > So this is a mitigation plan but the bug is still there though
> > > > > > we don't know exactly what it is.  I would prefer adding something like
> > > > > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > > > >
> > > > > As a rework to this, or as a subsequent patch?
> > > >
> > > > Can be a separate patch.
> > > >
> > > > > Just before the first lock I assume?
> > > >
> > > > I guess so, yes.
> > >
> > > No problem.  Patch to follow.
> > >
> > > I'm also going to attempt to debug the root cause, but I'm new to this
> > > subsystem to it might take a while for me to get my head around.
> > 
> > IIUC the root cause should be the same as the one we solved here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> > 
> > The worker was not stopped before calling vhost_dev_cleanup(). So while 
> > the worker was still running we were going to free memory or initialize 
> > fields while it was still using virtqueue.
> 
> Right, and I agree but it's not the root though, we do attempt to stop all workers.

Exactly.  This is what happens, but the question I'm going to attempt
to answer is *why* does this happen.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
