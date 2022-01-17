Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153FB4901FB
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 07:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiAQGcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 01:32:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231189AbiAQGb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 01:31:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642401118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ermpWLzpnf2+eleUkI4QP6TV2e0rXLT1tCR2h6immvo=;
        b=ew61ZF8pnd7BDQQ0k/M1DgScdHjch8czIxVFwz8gWstL1JtN3puGJRhMhsOdqS1uqUcwlO
        VqfW89cB77/pD5gROmsFm0oYnPiFaLW5udUNmH7iZrH6ldZPHbyaQinpDokWEzGZE4NUk3
        xQLs3pfHndvV553Jvrybxt3EBKYPjhU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-XeZYLVSwPJm9iE5s7luMGg-1; Mon, 17 Jan 2022 01:31:55 -0500
X-MC-Unique: XeZYLVSwPJm9iE5s7luMGg-1
Received: by mail-pg1-f199.google.com with SMTP id c75-20020a63354e000000b003408e4153d1so7083370pga.9
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 22:31:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ermpWLzpnf2+eleUkI4QP6TV2e0rXLT1tCR2h6immvo=;
        b=VyfIwCGf5hA1ubChJb2hq3tvkCg5c7XxosGS2frH1sfHrkYvafe9gCZc1yReBHHGfl
         WdwnuBDhRyUAj0cDWQmwGR1bpi9LIIzQPoTC8Nw+mT0NguPtLygLT1wsd5XQVYHDKpYK
         2igu6/zL97BCvyDTZ0hEwwPqspKKQM5DT3SYcqWwcehwbqo8TLRyAb2rIAiEJIo8WmSm
         0WZTpnpaGmoCYQs4xlTofxUrcEjlJizQGJsKOjZshAHepp1bqnNN5oFbBNUYOw/Io4u/
         lRnV9VA4PedgGoOBhMmH03JTQhJ5XX6DfF375cRmFjJ6MpWWhJwL1jo9fY+tbsvS2L6F
         f9cg==
X-Gm-Message-State: AOAM533vWpr9R/rfQsLuauhDBcIhwXb11qJsy/DFUqM+surpxzRtR9qf
        3T2h/X63AlbSkNg0XA0oPAQuTrFdOv1Y1lZxwcyRpnFYB57hBdtKH3jxHzZhOp3kfvmHqNufKvH
        Demo7DQn9sFXR0OMe
X-Received: by 2002:a17:902:7d93:b0:14a:bf7b:926d with SMTP id a19-20020a1709027d9300b0014abf7b926dmr2435712plm.22.1642401113977;
        Sun, 16 Jan 2022 22:31:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLp3KK5P487dKrJwjLXyn+WyRptyT5BInGR0/0DC3SjMnJck3fOlyrG7lDXwsfJXpGMaMLlA==
X-Received: by 2002:a17:902:7d93:b0:14a:bf7b:926d with SMTP id a19-20020a1709027d9300b0014abf7b926dmr2435694plm.22.1642401113728;
        Sun, 16 Jan 2022 22:31:53 -0800 (PST)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o184sm12743628pfb.90.2022.01.16.22.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 22:31:53 -0800 (PST)
Message-ID: <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
Date:   Mon, 17 Jan 2022 14:31:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] virtio: acknowledge all features before access
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20220114200744.150325-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220114200744.150325-1-mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2022/1/15 上午4:09, Michael S. Tsirkin 写道:
> The feature negotiation was designed in a way that
> makes it possible for devices to know which config
> fields will be accessed by drivers.
>
> This is broken since commit 404123c2db79 ("virtio: allow drivers to
> validate features") with fallout in at least block and net.
> We have a partial work-around in commit 2f9a174f918e ("virtio: write
> back F_VERSION_1 before validate") which at least lets devices
> find out which format should config space have, but this
> is a partial fix: guests should not access config space
> without acknowledging features since otherwise we'll never
> be able to change the config space format.
>
> As a side effect, this also reduces the amount of hypervisor accesses -
> we now only acknowledge features once unless we are clearing any
> features when validating.
>
> Cc: stable@vger.kernel.org
> Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> Cc: "Halil Pasic" <pasic@linux.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Halil, I thought hard about our situation with transitional and
> today I finally thought of something I am happy with.
> Pls let me know what you think. Testing on big endian would
> also be much appreciated!
>
>   drivers/virtio/virtio.c | 31 +++++++++++++++++--------------
>   1 file changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index d891b0a354b0..2ed6e2451fd8 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -168,12 +168,10 @@ EXPORT_SYMBOL_GPL(virtio_add_status);
>   
>   static int virtio_finalize_features(struct virtio_device *dev)
>   {
> -	int ret = dev->config->finalize_features(dev);
>   	unsigned status;
> +	int ret;
>   
>   	might_sleep();
> -	if (ret)
> -		return ret;
>   
>   	ret = arch_has_restricted_virtio_memory_access();
>   	if (ret) {
> @@ -244,17 +242,6 @@ static int virtio_dev_probe(struct device *_d)
>   		driver_features_legacy = driver_features;
>   	}
>   
> -	/*
> -	 * Some devices detect legacy solely via F_VERSION_1. Write
> -	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> -	 * these when needed.
> -	 */
> -	if (drv->validate && !virtio_legacy_is_little_endian()
> -			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> -		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> -		dev->config->finalize_features(dev);
> -	}
> -
>   	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
>   		dev->features = driver_features & device_features;
>   	else
> @@ -265,10 +252,22 @@ static int virtio_dev_probe(struct device *_d)
>   		if (device_features & (1ULL << i))
>   			__virtio_set_bit(dev, i);
>   
> +	err = dev->config->finalize_features(dev);
> +	if (err)
> +		goto err;
> +
>   	if (drv->validate) {
> +		u64 features = dev->features;
> +
>   		err = drv->validate(dev);
>   		if (err)
>   			goto err;
> +
> +		if (features != dev->features) {
> +			err = dev->config->finalize_features(dev);
> +			if (err)
> +				goto err;
> +		}
>   	}
>   
>   	err = virtio_finalize_features(dev);
> @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
>   	/* We have a driver! */
>   	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
>   
> +	ret = dev->config->finalize_features(dev);
> +	if (ret)
> +		goto err;


Is this part of code related?

Thanks


> +
>   	ret = virtio_finalize_features(dev);
>   	if (ret)
>   		goto err;

