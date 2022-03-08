Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDDE4D15A8
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbiCHLHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346236AbiCHLHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:07:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A58944775
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 03:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=991nBlYZCZCpiOj2G+SgVUb1qCNFHvKZstldYfktIgA=;
        b=PVg1vmvsqgRH3JCTUUrCY5A+U6glNH2fX4Q0aXTJLinNJUSFlH1QJUWtiZ7W+Gaz2lme5q
        CC2OttOIaLk/mCPDiEsnQiq0FF5p7ROFsKAnArrh4J5yJ07FhhoDs6l60QgecAChIWHYnY
        yP6PgyQR7gKtrRaBoCmFm4Zp5OEoGrg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-X9dUq229Px2ZO7u9-izesA-1; Tue, 08 Mar 2022 06:06:54 -0500
X-MC-Unique: X9dUq229Px2ZO7u9-izesA-1
Received: by mail-ed1-f72.google.com with SMTP id n11-20020a50cc4b000000b00415e939bf9eso8227281edi.22
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 03:06:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=991nBlYZCZCpiOj2G+SgVUb1qCNFHvKZstldYfktIgA=;
        b=VzVz28EbtCN07VFqNpvUNf72VzWOQ7i7Ftff1zzkGIrmJag5GAtF9JfEbJW9FMVbBw
         q1jDVeb+T89QY4zWFz/0ZrT7f+ptprMK1UNC0exXLzTAne6i6ioUlpvqttntiW+D8p2C
         4OmA5/4M86LHV4AgojttuuksU/2zTp/OOmxqGgyWj9S1pACXNs7SJZwysD7y9vMmTS0G
         hB0SwmlbmJ4060+4eZfnmpi5iMh06jJ0FCvalaTob7A+HBbnX9Bl31tDK/sbQgglOPSj
         JiMt0JDMuLI0dqlabzuIm/JIoALs5071ia8//MWsjJfaCAZEDyVqQErVGpw6fFpBtsDf
         bxgw==
X-Gm-Message-State: AOAM530rQTccAu5+b6glEIQ0QaXPELPsC6+bJEEkc5uL97cDV/C+qS9p
        qdUQ8dujgrPNzXMEilKBVQsa3ILQkghVg+LWegIJJLHUZjDxqQjTii7IUx0mMInxfe90dRN6Tvr
        CPhwteqgReCYBduA+
X-Received: by 2002:a17:907:2a53:b0:6ce:e4fe:3f92 with SMTP id fe19-20020a1709072a5300b006cee4fe3f92mr12489214ejc.389.1646737611475;
        Tue, 08 Mar 2022 03:06:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6OHvhq4Auw6rP2YfKxvG4L9ELqPU+Q10SahOdgKyllWovG+m4xcSqtTWQv7yg0Tmpn5/sLA==
X-Received: by 2002:a17:907:2a53:b0:6ce:e4fe:3f92 with SMTP id fe19-20020a1709072a5300b006cee4fe3f92mr12489189ejc.389.1646737611169;
        Tue, 08 Mar 2022 03:06:51 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id y18-20020a056402271200b0041110d6b80asm7573255edd.39.2022.03.08.03.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 03:06:50 -0800 (PST)
Date:   Tue, 8 Mar 2022 06:06:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308060542-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <CACGkMEsjmCNQPjxPjXL0WUfbMg8ARnumEp4yjUxqznMKR1nKSQ@mail.gmail.com>
 <YicO+aF4VhaBYNqK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YicO+aF4VhaBYNqK@google.com>
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

On Tue, Mar 08, 2022 at 08:08:25AM +0000, Lee Jones wrote:
> On Tue, 08 Mar 2022, Jason Wang wrote:
> 
> > On Tue, Mar 8, 2022 at 3:18 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > during virtqueue clean-up and we mitigate the reported issues.
> > >
> > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > capture possible future race conditions which may pop up over time.
> > >
> > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/vhost/vhost.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >         int i;
> > >
> > >         for (i = 0; i < dev->nvqs; ++i) {
> > > +               /* No workers should run here by design. However, races have
> > > +                * previously occurred where drivers have been unable to flush
> > > +                * all work properly prior to clean-up.  Without a successful
> > > +                * flush the guest will malfunction, but avoiding host memory
> > > +                * corruption in those cases does seem preferable.
> > > +                */
> > > +               WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > +
> > 
> > I don't get how this can help, the mutex could be grabbed in the
> > middle of the above and below line.
> 
> The worst that happens in this slim scenario is we miss a warning.
> The mutexes below will still function as expected and prevent possible
> memory corruption.

maybe. or maybe corruption already happened and this is the
fallout.

> > > +               mutex_lock(&dev->vqs[i]->mutex);
> > >                 if (dev->vqs[i]->error_ctx)
> > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > >                 if (dev->vqs[i]->kick)
> > > @@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >                 if (dev->vqs[i]->call_ctx.ctx)
> > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > >                 vhost_vq_reset(dev, dev->vqs[i]);
> > > +               mutex_unlock(&dev->vqs[i]->mutex);
> > >         }
> > 
> > I'm not sure it's correct to assume some behaviour of a buggy device.
> > For the device mutex, we use that to protect more than just err/call
> > and vq.
> 
> When I authored this, I did so as *the* fix.  However, since the cause
> of today's crash has now been patched, this has become a belt and
> braces solution.  Michael's addition of the WARN() also has the
> benefit of providing us with an early warning system for future
> breakages.  Personally, I think it's kinda neat.
> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog

