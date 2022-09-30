Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040705F14E6
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiI3Vbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 17:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiI3Vbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 17:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B216B197F32
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 14:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664573505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7MZyE4q4pUK9exbRcIZDL/JbobrwIaDD99sfovICQ4I=;
        b=LKzzmLBErt7BkoGaHkW0gQomHA/me0p9gbqprzV9CrJnd14RwlEYJnptfy61b1eVTujv5U
        BVPMVoPqo4TVFdmpo8giCDurECLjZ0fTJ41EWKCuQ2zTHgy91bhVpPEbvmYy1bTSh4NTzG
        iXZA7BQuU99nwY+uVvNtc0pONgULhzg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-rFuO_YkCO_aFDlSxc1sfyA-1; Fri, 30 Sep 2022 17:31:44 -0400
X-MC-Unique: rFuO_YkCO_aFDlSxc1sfyA-1
Received: by mail-il1-f199.google.com with SMTP id h10-20020a92c26a000000b002f57c5ac7dbso4360526ild.15
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 14:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=7MZyE4q4pUK9exbRcIZDL/JbobrwIaDD99sfovICQ4I=;
        b=XoccLwpV0hGJDPybRh3xOiSxmqJ/gWafs1YD7z1sWrXtASvk91Nd5KDiRQp5sAGI1n
         4Yhs9z+HBkEFO/Q1Kvu1C5FDGCQfaAKM6bk9Iammois2gQn67ovyWVGoZZni3wQwfaMe
         Sq2qUWU+o2VguEFScLf3jezzSYIAGFvWWrFY1Tuco7FDGvmyXVI/jUIkuPZRQFpx5j28
         pSf16shBcRVWPLOgHUJg380k40AJyA4xlxW+S7wJvKzuT9NPnRFiZJ8gbSVwEkHIIGzZ
         9/Jqq+4wLkPgU1wCt4ZFoli+qZ3sn4nSvmAZ0kAisLO/e6gs9hUGQP2CuuPrAshZ8vkT
         MsWA==
X-Gm-Message-State: ACrzQf3YugxkSvL+kN+LaSLF7GH8H4l5M6DsFEKOox0ehPmu4ipH69ap
        bkxSUFXdOPFd0CebNT1h5yxErcxzrWKDpFbFKy8YHSll0duESPRvl4TOsjg00PUKa3KUyCfJ6ol
        LCy4wlEjBftA7CF1a
X-Received: by 2002:a05:6638:4416:b0:35a:3cca:4db3 with SMTP id bp22-20020a056638441600b0035a3cca4db3mr5665322jab.0.1664573503688;
        Fri, 30 Sep 2022 14:31:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5cqLb3noeJWS0YhPhgS37XjFCTWP2XxFR9rFh11+Uu4oQtCWPM3VbBWg5g6mGXkpdAVP6H6g==
X-Received: by 2002:a05:6638:4416:b0:35a:3cca:4db3 with SMTP id bp22-20020a056638441600b0035a3cca4db3mr5665306jab.0.1664573503392;
        Fri, 30 Sep 2022 14:31:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l15-20020a02cd8f000000b0034c107ac9bbsm1343303jap.8.2022.09.30.14.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 14:31:42 -0700 (PDT)
Date:   Fri, 30 Sep 2022 15:31:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Message-ID: <20220930153139.0d60652b.alex.williamson@redhat.com>
In-Reply-To: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Sep 2022 14:48:35 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> When converting to directly create the vfio_device the mdev driver has to
> put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> vfio_unregister_group_dev() in the remove.
> 
> This was missed for gvt, add it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> Should go through Alex's tree.

Applied to vfio next branch for v6.1.  Thanks for the quick fix!

Alex
 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 41bba40feef8f4..9003145adb5a93 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
>  
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
>  	vfio_put_device(&vgpu->vfio_device);
>  }
>  
> 
> base-commit: c72e0034e6d4c36322d958b997d11d2627c6056c

