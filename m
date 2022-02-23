Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED7E4C079C
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbiBWCJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbiBWCJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:09:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDD563BA6F
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 18:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645582158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9LkpmwRUB9s3DzzklqywD2GBEtiMiXthflpW97NS2M=;
        b=eWyH4UyQbNgh3HGIBNzKjBIRpS9OD98j+5Q6oOwfEI1W9ycTh5D55gGaO8HQCwHVOP26PN
        YNzOTL5GyrZW7fceOiaMQvrXeLzr63uNyjGaGSFjltBdUdfIUmpSOA9QqEABVJ1ElCr9WH
        +dC3bqSJwNp0huX8hYhKTL951P8evag=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-Lt-ro3HWOR6vhakQQrbTTQ-1; Tue, 22 Feb 2022 21:09:16 -0500
X-MC-Unique: Lt-ro3HWOR6vhakQQrbTTQ-1
Received: by mail-lj1-f199.google.com with SMTP id j17-20020a2e8011000000b002463682ffd5so4794247ljg.6
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 18:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9LkpmwRUB9s3DzzklqywD2GBEtiMiXthflpW97NS2M=;
        b=Efrw7OlhR62Mm2osxpTwWxgwE+kZBPVHhc2nkEEQv7mBFCToeIYUh7r+gy/iYQNoSN
         R4KBTOg3vdGjd5xOq+h5qDgsAYsVbNgRY6uRqVXb2VjBYnzuhUHLkjnqbXoP9p3QGYFC
         S7jd6CQ1DL60lYl8wy4Ct6BdLyX+/Sd1cjH9RbwgkCaeW8cTN6TgBEiJ90lodegB+Bwl
         Mi6SB0sT4rwo5GgPE1e/uwGyy2Lez1nu8hCwGUKtGMmnNV8W+Af1hJFmO7F5Tt9NwWSs
         lOaaa0NbXXFAFtm3rZYNQduaXinP9nDQI1vpCdgZUEsaflaMcCIMrysPGMO6lMGiwHYM
         dsiA==
X-Gm-Message-State: AOAM530aW1bR0msYYM6Zel+u9nRF7/+L29uiLAj6zo4UWzo0EOc+OK3X
        K9SZoGkXKsFPCOGt2mU/YJA9voyiA+lBFOO7voo2gNzJ20vbvk+kwovjLDq8DLPm7NjCO9v2BCK
        D+C1fxuMW2o6RjAzWcOjKHOsNIeGaLHFN
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id h1-20020ac24da1000000b0043874be5a88mr17748767lfe.210.1645582155151;
        Tue, 22 Feb 2022 18:09:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWVsv8Sx14FGPZdp4dBv1csb/D6luqE37ndqXaLZ0eJ0z4lL/rN+eJyDfku6eJ6K+YiTb9ktJZ9PM21p2/UQY=
X-Received: by 2002:ac2:4da1:0:b0:438:74be:5a88 with SMTP id
 h1-20020ac24da1000000b0043874be5a88mr17748759lfe.210.1645582154950; Tue, 22
 Feb 2022 18:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20220222094742.16359-1-sgarzare@redhat.com>
In-Reply-To: <20220222094742.16359-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Feb 2022 10:09:03 +0800
Message-ID: <CACGkMEtN_YO1Avi79bMyaCqLHMMpDaPvh1oVQPEMRYky_Zbugg@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 5:47 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
>
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
>
> Let's check the owner only when vhost_vsock_stop() is called
> by an ioctl.
>
> When invoked from release we can not fail so we don't check return
> code of vhost_vsock_stop(). We need to stop vsock even if it's not
> the owner.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> v2:
> - initialized `ret` in vhost_vsock_stop [Dan]
> - added comment about vhost_vsock_stop() calling in the code and an explanation
>   in the commit message [MST]
>
> v1: https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarzare@redhat.com
> ---
>  drivers/vhost/vsock.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index d6ca1c7ad513..37f0b4274113 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>         return ret;
>  }
>
> -static int vhost_vsock_stop(struct vhost_vsock *vsock)
> +static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
>  {
>         size_t i;
> -       int ret;
> +       int ret = 0;
>
>         mutex_lock(&vsock->dev.mutex);
>
> -       ret = vhost_dev_check_owner(&vsock->dev);
> -       if (ret)
> -               goto err;
> +       if (check_owner) {
> +               ret = vhost_dev_check_owner(&vsock->dev);
> +               if (ret)
> +                       goto err;
> +       }
>
>         for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>                 struct vhost_virtqueue *vq = &vsock->vqs[i];
> @@ -753,7 +755,12 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>          * inefficient.  Room for improvement here. */
>         vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
>
> -       vhost_vsock_stop(vsock);
> +       /* Don't check the owner, because we are in the release path, so we
> +        * need to stop the vsock device in any case.
> +        * vhost_vsock_stop() can not fail in this case, so we don't need to
> +        * check the return code.
> +        */
> +       vhost_vsock_stop(vsock, false);
>         vhost_vsock_flush(vsock);
>         vhost_dev_stop(&vsock->dev);
>
> @@ -868,7 +875,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
>                 if (start)
>                         return vhost_vsock_start(vsock);
>                 else
> -                       return vhost_vsock_stop(vsock);
> +                       return vhost_vsock_stop(vsock, true);
>         case VHOST_GET_FEATURES:
>                 features = VHOST_VSOCK_FEATURES;
>                 if (copy_to_user(argp, &features, sizeof(features)))
> --
> 2.35.1
>

