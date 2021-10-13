Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E277E42BC78
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbhJMKMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:12:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239124AbhJMKMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634119816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XIV6EWlf8IYh7mOxA5NB+uuQJyLxn6kGVxkuMI5GYog=;
        b=bsGly8ZB84YYvX2eeaAnMpAK+4QdXYnJ6Yq9s9K8I2nvyQBa5fu16RHLd4OGAEAfmEaFAF
        cVHVBEQBwijOqKjvlTd51weOsrFi8T3rBWl5JuXAjF8pMV+n3cYcQPFcnDQF96xjKow792
        B/J+A7JltqQ2C2qwxBVVxOvjYpqdrGs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-g-KlpaeSMqqkj41o6_z8Hg-1; Wed, 13 Oct 2021 06:10:15 -0400
X-MC-Unique: g-KlpaeSMqqkj41o6_z8Hg-1
Received: by mail-wr1-f72.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so1573060wrc.9
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 03:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XIV6EWlf8IYh7mOxA5NB+uuQJyLxn6kGVxkuMI5GYog=;
        b=t5R490B2anZtFHASKPQ5ncwh+jJlKV1sdOHZ5b5/tBZ6OY109/+Ye+1OPZl2xa1VOG
         EZFFtxb3KA2viX8sYSTdh89+7tpSBuujfDeF/8jRWjjgQgmkPWDND6VF2T+ThpKizS7t
         zNwlvKkIIOys1KvWP0SFLfs8FPN17ZjRRDN4OpxjVXJX9TyYfhxIZOTuS+uEz5GMXKBN
         LT2tv/EpQ8Fz1C+VPs9DizW/Ee/9AK3nPHTTmtCb+0yojNM1aZOkCXbsoNAAL3uidXYR
         RuIIwXOKaz2Tahdblv8gK5iajM6YdT9v/t9qGxEPa7XScKMiIfWJ0T8WjJAiZHWQKppz
         mOCQ==
X-Gm-Message-State: AOAM531b8N0c0AIWmksDUUVNZ+DVc0qSiw4H4nYSbHyNCtHzF+/DZZLa
        E2yxtp9ek+eovUCZz/afu6yGBeJIkZzufx/54VzLmResMYOSu47v7Ltgc/Q2kNxJZgfFBOxBKaF
        AQCCzB+Iss6q4HYqL
X-Received: by 2002:a5d:6c65:: with SMTP id r5mr38598488wrz.26.1634119814020;
        Wed, 13 Oct 2021 03:10:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdzEUsRMSd5Z6w3cXq4dmtWNY5MNbht2wMdWdZK2XnSLKoIDFYiOilvxVG3omeTmm8H874VQ==
X-Received: by 2002:a5d:6c65:: with SMTP id r5mr38598465wrz.26.1634119813789;
        Wed, 13 Oct 2021 03:10:13 -0700 (PDT)
Received: from redhat.com ([2.55.30.112])
        by smtp.gmail.com with ESMTPSA id p25sm4782688wma.2.2021.10.13.03.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:10:13 -0700 (PDT)
Date:   Wed, 13 Oct 2021 06:10:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        markver@us.ibm.com, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, stefanha@redhat.com,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-devel@nongnu.org
Subject: Re: [PATCH v3 1/1] virtio: write back F_VERSION_1 before validate
Message-ID: <20211013060923-mutt-send-email-mst@kernel.org>
References: <20211011053921.1198936-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011053921.1198936-1-pasic@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 07:39:21AM +0200, Halil Pasic wrote:
> The virtio specification virtio-v1.1-cs01 states: "Transitional devices
> MUST detect Legacy drivers by detecting that VIRTIO_F_VERSION_1 has not
> been acknowledged by the driver."  This is exactly what QEMU as of 6.1
> has done relying solely on VIRTIO_F_VERSION_1 for detecting that.
> 
> However, the specification also says: "... the driver MAY read (but MUST
> NOT write) the device-specific configuration fields to check that it can
> support the device ..." before setting FEATURES_OK.
> 
> In that case, any transitional device relying solely on
> VIRTIO_F_VERSION_1 for detecting legacy drivers will return data in
> legacy format.  In particular, this implies that it is in big endian
> format for big endian guests. This naturally confuses the driver which
> expects little endian in the modern mode.
> 
> It is probably a good idea to amend the spec to clarify that
> VIRTIO_F_VERSION_1 can only be relied on after the feature negotiation
> is complete. Before validate callback existed, config space was only
> read after FEATURES_OK. However, we already have two regressions, so
> let's address this here as well.
> 
> The regressions affect the VIRTIO_NET_F_MTU feature of virtio-net and
> the VIRTIO_BLK_F_BLK_SIZE feature of virtio-blk for BE guests when
> virtio 1.0 is used on both sides. The latter renders virtio-blk unusable
> with DASD backing, because things simply don't work with the default.
> See Fixes tags for relevant commits.
> 
> For QEMU, we can work around the issue by writing out the feature bits
> with VIRTIO_F_VERSION_1 bit set.  We (ab)use the finalize_features
> config op for this. This isn't enough to address all vhost devices since
> these do not get the features until FEATURES_OK, however it looks like
> the affected devices actually never handled the endianness for legacy
> mode correctly, so at least that's not a regression.
> 
> No devices except virtio net and virtio blk seem to be affected.
> 
> Long term the right thing to do is to fix the hypervisors.
> 
> Cc: <stable@vger.kernel.org> #v4.11
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 82e89ea077b9 ("virtio-blk: Add validation for block size in config space")
> Fixes: fe36cbe0671e ("virtio_net: clear MTU when out of range")
> Reported-by: markver@us.ibm.com
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

OK this looks good! How about a QEMU patch to make it spec compliant on
BE?

> ---
> 
> @Connie: I made some more commit message changes to accommodate Michael's
> requests. I just assumed these will work or you as well and kept your
> r-b. Please shout at me if it needs to be dropped :)
> ---
>  drivers/virtio/virtio.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..236081afe9a2 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -239,6 +239,17 @@ static int virtio_dev_probe(struct device *_d)
>  		driver_features_legacy = driver_features;
>  	}
>  
> +	/*
> +	 * Some devices detect legacy solely via F_VERSION_1. Write
> +	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> +	 * these when needed.
> +	 */
> +	if (drv->validate && !virtio_legacy_is_little_endian()
> +			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> +		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> +		dev->config->finalize_features(dev);
> +	}
> +
>  	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
>  		dev->features = driver_features & device_features;
>  	else
> 
> base-commit: 60a9483534ed0d99090a2ee1d4bb0b8179195f51
> -- 
> 2.25.1

