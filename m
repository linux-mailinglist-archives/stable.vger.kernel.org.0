Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037EE45E9A9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 09:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbhKZI4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 03:56:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359388AbhKZIyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 03:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637916687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=buxrUV+g6E7RgVJ5J84jnki/Cx5fv7dc0O2MOtNji5E=;
        b=WGzQH/BzAFcveQFiX4iYUNaELgpUcqefBRVGfYWjwLQwBjDdMID5B3zGudzmagV7GwnDwG
        W6XtniruGTiG70aSHA4DEQYmfWx7noEiOgrv1oaiHa5nUzbO1/YKDTfoQDhwwHiitG97b7
        xnIaOTrjH03Yszt6Cp0m7tmkx5eEpEQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-XqaXSxNbMkCaftTGIxlj9A-1; Fri, 26 Nov 2021 03:51:26 -0500
X-MC-Unique: XqaXSxNbMkCaftTGIxlj9A-1
Received: by mail-wm1-f70.google.com with SMTP id 144-20020a1c0496000000b003305ac0e03aso6435398wme.8
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 00:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=buxrUV+g6E7RgVJ5J84jnki/Cx5fv7dc0O2MOtNji5E=;
        b=oWgAXd6yQSMSmdVohiXjVubSNpe61AGtU5yC8nLTwxjpfPJ18VhGaAeGEiCwZLSm/c
         eh6fLL931shV0NC5fk8Jj9XWRMO5m0W6Vh1egmcLiXeSJfFIRzgyJgopUlPXohV9tW1B
         2lhQtHSLYLgDbkwZAsj6Z/7dE0/pzvom4o7QbNIf2MQtZI9vENVqOwkGwJnrKIkQmyfG
         cUUacc0a5syQ84N/EYbxEGlTr93PL7pjT3MkiRvMy3H7bzLrSWjE5uK7muQfydDLgniP
         yE3+Qf8ZfvE4UL4Yt1BVezQ8Z0GeXmyO377Nah9tJmim0ZMr0+Quq5N+Vtg7X0nJTGdO
         ftGQ==
X-Gm-Message-State: AOAM530CldAeE9f6GvbvONJi0XK4PeJnP+ZuhkLFRJ4IL6t0prj+iH4x
        YnRY6m7tBFA3CqfzbBNhf0E6W9LOjFJHPDqtCYemRzuxEdVCD3dL+sIRixUdF5CBXAugMiTpZV3
        uRs0xYSceRrt1b9qQ
X-Received: by 2002:adf:9e01:: with SMTP id u1mr12555721wre.561.1637916684810;
        Fri, 26 Nov 2021 00:51:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+zRTh3M3Te7Zo+O1GLnjMROjijj+1i34zEBnuPKXwHZMOgzY2YMCX6RlCP4Doiy0fPswqhw==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr12555706wre.561.1637916684638;
        Fri, 26 Nov 2021 00:51:24 -0800 (PST)
Received: from [192.168.3.132] (p5b0c69e1.dip0.t-ipconnect.de. [91.12.105.225])
        by smtp.gmail.com with ESMTPSA id f7sm12695103wmg.6.2021.11.26.00.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 00:51:24 -0800 (PST)
Message-ID: <74c1d756-3f7c-7085-0ae9-2c082dce63b2@redhat.com>
Date:   Fri, 26 Nov 2021 09:51:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH AUTOSEL 5.15 7/7] virtio-mem: support
 VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marek Kedzierski <mkedzier@redhat.com>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
References: <20211126023006.440839-1-sashal@kernel.org>
 <20211126023006.440839-7-sashal@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211126023006.440839-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.11.21 03:30, Sasha Levin wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> [ Upstream commit 61082ad6a6e1f999eef7e7e90046486c87933b1e ]
> 
> The initial virtio-mem spec states that while unplugged memory should not
> be read, the device still has to allow for reading unplugged memory inside
> the usable region. The primary motivation for this default handling was
> to simplify bringup of virtio-mem, because there were corner cases where
> Linux might have accidentially read unplugged memory inside added Linux
> memory blocks.
> 
> In the meantime, we:
> 1. Removed /dev/kmem in commit bbcd53c96071 ("drivers/char: remove
>    /dev/kmem for good")
> 2. Disallowed access to virtio-mem device memory via /dev/mem in
>    commit 2128f4e21aa2 ("virtio-mem: disallow mapping virtio-mem memory via
>    /dev/mem")
> 3. Sanitized access to virtio-mem device memory via /proc/kcore in
>    commit 0daa322b8ff9 ("fs/proc/kcore: don't read offline sections,
>    logically offline pages and hwpoisoned pages")
> 4. Sanitized access to virtio-mem device memory via /proc/vmcore in
>    commit ce2814622e84 ("virtio-mem: kdump mode to sanitize /proc/vmcore
>    access")
> 
> "Accidential" access to unplugged memory is no longer possible; we can
> support the new VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE feature that will be
> required by some hypervisors implementing virtio-mem in the near future.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Marek Kedzierski <mkedzier@redhat.com>
> Cc: Hui Zhu <teawater@gmail.com>
> Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/virtio/virtio_mem.c     | 1 +
>  include/uapi/linux/virtio_mem.h | 9 ++++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index bef8ad6bf4661..78dfdc9c98a1c 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -2758,6 +2758,7 @@ static unsigned int virtio_mem_features[] = {
>  #if defined(CONFIG_NUMA) && defined(CONFIG_ACPI_NUMA)
>  	VIRTIO_MEM_F_ACPI_PXM,
>  #endif
> +	VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE,
>  };
>  
>  static const struct virtio_device_id virtio_mem_id_table[] = {
> diff --git a/include/uapi/linux/virtio_mem.h b/include/uapi/linux/virtio_mem.h
> index 70e01c687d5eb..e9122f1d0e0cb 100644
> --- a/include/uapi/linux/virtio_mem.h
> +++ b/include/uapi/linux/virtio_mem.h
> @@ -68,9 +68,10 @@
>   * explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
>   *
>   * There are no guarantees what will happen if unplugged memory is
> - * read/written. Such memory should, in general, not be touched. E.g.,
> - * even writing might succeed, but the values will simply be discarded at
> - * random points in time.
> + * read/written. In general, unplugged memory should not be touched, because
> + * the resulting action is undefined. There is one exception: without
> + * VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, unplugged memory inside the usable
> + * region can be read, to simplify creation of memory dumps.
>   *
>   * It can happen that the device cannot process a request, because it is
>   * busy. The device driver has to retry later.
> @@ -87,6 +88,8 @@
>  
>  /* node_id is an ACPI PXM and is valid */
>  #define VIRTIO_MEM_F_ACPI_PXM		0
> +/* unplugged memory must not be accessed */
> +#define VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE	1
>  
>  
>  /* --- virtio-mem: guest -> host requests --- */
> 

As 2. and 4. are part of v5.16-rc1 but not v5.15-stable

Nacked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

