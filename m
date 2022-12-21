Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E737F652BC2
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 04:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiLUDYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 22:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiLUDYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 22:24:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A81B7A3
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 19:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671593003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CFnvNj9hg0uk4ty9l25TpJtyYdolUCT1QyYJMfBzM80=;
        b=EdtjlbBxP3iSyXr8TDxeGQcpQRNhDjLdaPiWdVe0oj3yvHimK9h6ZtJObPWMGc9pmeCM0n
        +rpLjGYm6o2oONQabtZP2HgBDAUloyCawIWQUNnw9rmb5GLmfhcEDfeUbE2aIMWf67Al2n
        l85Fu4ot7BeV0AWEg9OiLRxJfRTHh60=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-136-k3JlW2EUMVqHlltl5AdGjg-1; Tue, 20 Dec 2022 22:23:21 -0500
X-MC-Unique: k3JlW2EUMVqHlltl5AdGjg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-144ea535efbso6330644fac.16
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 19:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFnvNj9hg0uk4ty9l25TpJtyYdolUCT1QyYJMfBzM80=;
        b=T/2BjdIsZKNj/jMCpyQ75Zdlb67y3it8r4biN2KTrfWtmhLEP9ZP5k2BJE9G9v8zYR
         kTfnD/QNlNw8hQhDGeEOJmRN2ORCgRM7y++7PhMwbcjbv7i31wmCFEYsbH3vCoEX2d+e
         oHmBf8FXT9LR0AzRW2TNm0vokNTFpAMFowvw1UrhvEE6YHZemFAV7q6Fx+NzWLk5/FwH
         /iu9/XSStwrFaX95J6nYgR02HTOmPB5oC0sMki+MEvZhT5dgHa4HZuRkchyEm4WtJPfu
         HWjC3xbmA8Q0misQGYFXs7bp2ZJhEGdv9ZmgjC5g6Y7OWxGvRbCDNnoetNh+s1G8pM0g
         Dx/A==
X-Gm-Message-State: AFqh2kozJGCKjSEcT52HtRVjk0OKHAnnWIusfF0EUCd1jvotxj5OIl3Z
        sB3h5nejuHLAWAcGV3mVBGIMg2FFgeBTGo/GtZj7sNhCVRxuW+UdCGmHEt25LtgBukOCXY7KP4D
        8fioBkMsQ/PV9fmYPfvdu9CyueYEboygG
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr5745oah.35.1671593000983;
        Tue, 20 Dec 2022 19:23:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvCqHucOMNWaOuq5hOMU7pwt2QCc0KdTdowmUytqZw+Vtlqfi8EU47R4djYK+989+3MChf2+uVMV3LQ50Op9xs=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr5744oah.35.1671593000701; Tue, 20 Dec
 2022 19:23:20 -0800 (PST)
MIME-Version: 1.0
References: <20221220140205.795115-1-lulu@redhat.com>
In-Reply-To: <20221220140205.795115-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Dec 2022 11:23:09 +0800
Message-ID: <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 10:02 PM Cindy Lu <lulu@redhat.com> wrote:
>
> The input of  vhost_vdpa_iotlb_unmap() was changed in 881ac7d2314f,
> But some function was not changed while calling this function.
> Add this change
>
> Cc: stable@vger.kernel.org
> Fixes: 881ac7d2314f ("vhost_vdpa: fix the crash in unmap a large memory")

Is this commit merged into Linus tree?

Btw, Michael, I'd expect there's a respin of the patch so maybe Cindy
can squash the fix into the new version?

Thanks

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 46ce35bea705..ec32f785dfde 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
>  static dev_t vhost_vdpa_major;
>
>  static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> -                                  struct vhost_iotlb *iotlb,
> -                                  u64 start, u64 last);
> +                                  struct vhost_iotlb *iotlb, u64 start,
> +                                  u64 last, u32 asid);
>
>  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
>  {
> @@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
>                 return -EINVAL;
>
>         hlist_del(&as->hash_link);
> -       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> +       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
>         kfree(as);
>
>         return 0;
> --
> 2.34.3
>

