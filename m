Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1269B3C3A20
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 06:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhGKE0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 00:26:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhGKE0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 00:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625977447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02U4tJtEiOM0qkKaodpq8DMAnRGvc/YpIqhPzDDp4BM=;
        b=E0NS3TAz2jsVyC4t2qS8v5+XeGBCaHxTqCOQvjhLKzgIY/VbbTwrew02DpGQTqD+S0Jksf
        2vxvtHuvvqKVRr+YN0ejlXUgfGwgs1JmG3cFxhY5mtzZNuzXDfLuIOjP0SkI6j08lZTVy8
        TSscC23hnzlpV6uGe8/Bt+QJIuRWm24=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-e4D6pAsBNLW6a_tJLK61gQ-1; Sun, 11 Jul 2021 00:24:05 -0400
X-MC-Unique: e4D6pAsBNLW6a_tJLK61gQ-1
Received: by mail-ed1-f70.google.com with SMTP id n6-20020aa7c4460000b02903a12bbba1ebso4358060edr.6
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 21:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=02U4tJtEiOM0qkKaodpq8DMAnRGvc/YpIqhPzDDp4BM=;
        b=RxYt87uXRlClprqmYe3N+uXGMqoRXvoibKxQa5+RfE1MvgTTTWh5wZv5+7pGXOFIZ/
         2QH39wK4q5uYGaNZHVS/5d7ZKTNrg6iXCOAtDX5TMBSQsPXYamnL2/yrQBAgSIFV800b
         oI971hCjqfRkWO2FboxlarfWfAyLLuAw3F8Aw/Cs6mC5CqekekrWbPlYLLGBz9xgmw+c
         5NHw4BnpoQwd0kamPVSgrKsqVTyvivqUehdrqg3x+DKHl7Q0dtYMsu1ciW3HapQ4uLG6
         n33M4MNmCt+KEk1Bvf1Ax6ZCBa6G7liA7rbICDpEWs4tvlAuGnV+q54ilFbmmwz1QIE1
         Ikdg==
X-Gm-Message-State: AOAM532sY5v9QLnRKdYfiPp3b3aprh9ayFxtjCHaGTwU5REeVFrVq91f
        TyOEPZ7tLSLnQsFWJPNKEPMKWlmTqE4CZTUt8m8bAKW1lEK5GXlbk5kDyB8QbuTLx6LYQAWmiJP
        Vkt6/3vtDUSHDvCIM
X-Received: by 2002:a17:907:2067:: with SMTP id qp7mr10660519ejb.225.1625977444402;
        Sat, 10 Jul 2021 21:24:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws63KcGvr+pdP3lOGZXLaXHF/jMHxo99OfYK1sKTi6JsWEKwIv7VTilCS2Xif47SisBKLkUQ==
X-Received: by 2002:a17:907:2067:: with SMTP id qp7mr10660506ejb.225.1625977444236;
        Sat, 10 Jul 2021 21:24:04 -0700 (PDT)
Received: from redhat.com ([2.55.136.76])
        by smtp.gmail.com with ESMTPSA id i11sm5521539edu.97.2021.07.10.21.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 21:24:03 -0700 (PDT)
Date:   Sun, 11 Jul 2021 00:23:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 5.12 42/43] virtio: fix up virtio_disable_cb
Message-ID: <20210711002242-mutt-send-email-mst@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
 <20210710234915.3220342-42-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710234915.3220342-42-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 07:49:14PM -0400, Sasha Levin wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> 
> [ Upstream commit 8d622d21d24803408b256d96463eac4574dcf067 ]
> 
> virtio_disable_cb is currently a nop for split ring with event index.
> This is because it used to be always called from a callback when we know
> device won't trigger more events until we update the index.  However,
> now that we run with interrupts enabled a lot we also poll without a
> callback so that is different: disabling callbacks will help reduce the
> number of spurious interrupts.
> Further, if using event index with a packed ring, and if being called
> from a callback, we actually do disable interrupts which is unnecessary.
> 
> Fix both issues by tracking whenever we get a callback. If that is
> the case disabling interrupts with event index can be a nop.
> If not the case disable interrupts. Note: with a split ring
> there's no explicit "no interrupts" value. For now we write
> a fixed value so our chance of triggering an interupt
> is 1/ring size. It's probably better to write something
> related to the last used index there to reduce the chance
> even further. For now I'm keeping it simple.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I am not sure we want this in stable yet. It should in theory
fix the reported interrupt storms but the reporter is on vacation.

> ---
>  drivers/virtio/virtio_ring.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..88f0b16b11b8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -113,6 +113,9 @@ struct vring_virtqueue {
>  	/* Last used index we've seen. */
>  	u16 last_used_idx;
>  
> +	/* Hint for event idx: already triggered no need to disable. */
> +	bool event_triggered;
> +
>  	union {
>  		/* Available for split ring */
>  		struct {
> @@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
>  
>  	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
>  		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> -		if (!vq->event)
> +		if (vq->event)
> +			/* TODO: this is a hack. Figure out a cleaner value to write. */
> +			vring_used_event(&vq->split.vring) = 0x0;
> +		else
>  			vq->split.vring.avail->flags =
>  				cpu_to_virtio16(_vq->vdev,
>  						vq->split.avail_flags_shadow);
> @@ -1605,6 +1611,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  	vq->weak_barriers = weak_barriers;
>  	vq->broken = false;
>  	vq->last_used_idx = 0;
> +	vq->event_triggered = false;
>  	vq->num_added = 0;
>  	vq->packed_ring = true;
>  	vq->use_dma_api = vring_use_dma_api(vdev);
> @@ -1919,6 +1926,12 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> +	/* If device triggered an event already it won't trigger one again:
> +	 * no need to disable.
> +	 */
> +	if (vq->event_triggered)
> +		return;
> +
>  	if (vq->packed_ring)
>  		virtqueue_disable_cb_packed(_vq);
>  	else
> @@ -1942,6 +1955,9 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> +	if (vq->event_triggered)
> +		vq->event_triggered = false;
> +
>  	return vq->packed_ring ? virtqueue_enable_cb_prepare_packed(_vq) :
>  				 virtqueue_enable_cb_prepare_split(_vq);
>  }
> @@ -2005,6 +2021,9 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> +	if (vq->event_triggered)
> +		vq->event_triggered = false;
> +
>  	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
>  				 virtqueue_enable_cb_delayed_split(_vq);
>  }
> @@ -2044,6 +2063,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>  	if (unlikely(vq->broken))
>  		return IRQ_HANDLED;
>  
> +	/* Just a hint for performance: so it's ok that this can be racy! */
> +	if (vq->event)
> +		vq->event_triggered = true;
> +
>  	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
>  	if (vq->vq.callback)
>  		vq->vq.callback(&vq->vq);
> @@ -2083,6 +2106,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->weak_barriers = weak_barriers;
>  	vq->broken = false;
>  	vq->last_used_idx = 0;
> +	vq->event_triggered = false;
>  	vq->num_added = 0;
>  	vq->use_dma_api = vring_use_dma_api(vdev);
>  #ifdef DEBUG
> -- 
> 2.30.2

