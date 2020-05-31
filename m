Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80B21E9683
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 11:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgEaJSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 05:18:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725813AbgEaJSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 05:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590916691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nkz/H8QkReHV/NKixQ08jC7jcXjiLX3LR86b6ApO8NY=;
        b=YliCzQWufusmDaEI3MVvz9ILO/6UnrX8a2tWWL8D1aN3lUvQv719w219cXngYeVG92N9b5
        wfUInEaGFG0/ZXfwtO6JOIepxpwyiuff1p0T0WsxnoMSIBfFwY1NUA7TygMYH8bPb58X8a
        c2zaKs8GfMhf77BiMmjhG461TOIl6GA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-qSLwlpXhNGa3zj08l-mqiQ-1; Sun, 31 May 2020 05:18:10 -0400
X-MC-Unique: qSLwlpXhNGa3zj08l-mqiQ-1
Received: by mail-wr1-f72.google.com with SMTP id w4so3257378wrl.13
        for <stable@vger.kernel.org>; Sun, 31 May 2020 02:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nkz/H8QkReHV/NKixQ08jC7jcXjiLX3LR86b6ApO8NY=;
        b=Fr0DLGruMDeud6FrdrT4bTF6ddOcwiP/PoBfXNyLtT6QEF/RPriYfWu2dMcdGnoIaO
         wGAVJc8dJWzBkuMe1XBiv7zfJickZ0/ulXB0Xi/WzDobRzBgD1kxu04GP33gXVi6s4Aj
         Titm3UxFrf4hpOXESQwfoTnZ0H2tsbSk7+pKDoqtgF9gT/OWlhks/Oxe2LuyDBGlAzMg
         z4czrMdyruvlV79jm/MHnYYmVtFW+ns4FNekWPMl76tgxfeEGgfLN1LO1ipW6e/jZBco
         3r7eZY5xCpTP8o7J/kDu8O7y/euVa6Fd5toBgZy7Mbg2+1P1T5yg22c18hWraAif5s1D
         YryQ==
X-Gm-Message-State: AOAM530EnAucORODBTI1Cf6LK3RrE3wtS0uTfkYazWa3259wX1aw6W4U
        qpE96Z1pZ8inB7XUDzTebqUwzLPKP0Cz8YD0h4NA8TcKFXEWH+GPIrjDv2azsOo01CHj/xTu+hq
        FMkmAKO5yC0Mwb5BD
X-Received: by 2002:adf:e84e:: with SMTP id d14mr16226752wrn.31.1590916688960;
        Sun, 31 May 2020 02:18:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+YBmWmwV7fVSI1GlFikVLChSWuZQxLS1RSiILC/b0uV1GG9DtZH/qccLRmEC4kbjyY7U5Iw==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr16226733wrn.31.1590916688640;
        Sun, 31 May 2020 02:18:08 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id s2sm6409620wmh.11.2020.05.31.02.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 02:18:08 -0700 (PDT)
Date:   Sun, 31 May 2020 05:18:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.6 086/126] virtio-balloon: Revert "virtio-balloon:
 Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"
Message-ID: <20200531051724-mutt-send-email-mst@kernel.org>
References: <20200526183937.471379031@linuxfoundation.org>
 <20200526183945.237904570@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526183945.237904570@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:53:43PM +0200, Greg Kroah-Hartman wrote:
> From: Michael S. Tsirkin <mst@redhat.com>
> 
> [ Upstream commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 ]
> 
> This reverts commit 5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031.
> 
> It has been queued properly in the akpm tree, this version is just
> creating conflicts.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't understand. How does this make sense in stable?
stable does not merge akpm does it?

> ---
>  drivers/virtio/virtio_balloon.c | 107 +++++++++++++++++++-------------
>  1 file changed, 63 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 44375a22307b..341458fd95ca 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -14,7 +14,6 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/balloon_compaction.h>
> -#include <linux/oom.h>
>  #include <linux/wait.h>
>  #include <linux/mm.h>
>  #include <linux/mount.h>
> @@ -28,9 +27,7 @@
>   */
>  #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
>  #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
> -/* Maximum number of (4k) pages to deflate on OOM notifications. */
> -#define VIRTIO_BALLOON_OOM_NR_PAGES 256
> -#define VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY 80
> +#define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
>  
>  #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
>  					     __GFP_NOMEMALLOC)
> @@ -115,11 +112,8 @@ struct virtio_balloon {
>  	/* Memory statistics */
>  	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
>  
> -	/* Shrinker to return free pages - VIRTIO_BALLOON_F_FREE_PAGE_HINT */
> +	/* To register a shrinker to shrink memory upon memory pressure */
>  	struct shrinker shrinker;
> -
> -	/* OOM notifier to deflate on OOM - VIRTIO_BALLOON_F_DEFLATE_ON_OOM */
> -	struct notifier_block oom_nb;
>  };
>  
>  static struct virtio_device_id id_table[] = {
> @@ -794,13 +788,50 @@ static unsigned long shrink_free_pages(struct virtio_balloon *vb,
>  	return blocks_freed * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
>  }
>  
> +static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
> +                                          unsigned long pages_to_free)
> +{
> +	return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) /
> +		VIRTIO_BALLOON_PAGES_PER_PAGE;
> +}
> +
> +static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
> +					  unsigned long pages_to_free)
> +{
> +	unsigned long pages_freed = 0;
> +
> +	/*
> +	 * One invocation of leak_balloon can deflate at most
> +	 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
> +	 * multiple times to deflate pages till reaching pages_to_free.
> +	 */
> +	while (vb->num_pages && pages_freed < pages_to_free)
> +		pages_freed += leak_balloon_pages(vb,
> +						  pages_to_free - pages_freed);
> +
> +	update_balloon_size(vb);
> +
> +	return pages_freed;
> +}
> +
>  static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
>  						  struct shrink_control *sc)
>  {
> +	unsigned long pages_to_free, pages_freed = 0;
>  	struct virtio_balloon *vb = container_of(shrinker,
>  					struct virtio_balloon, shrinker);
>  
> -	return shrink_free_pages(vb, sc->nr_to_scan);
> +	pages_to_free = sc->nr_to_scan;
> +
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> +		pages_freed = shrink_free_pages(vb, pages_to_free);
> +
> +	if (pages_freed >= pages_to_free)
> +		return pages_freed;
> +
> +	pages_freed += shrink_balloon_pages(vb, pages_to_free - pages_freed);
> +
> +	return pages_freed;
>  }
>  
>  static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
> @@ -808,22 +839,26 @@ static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
>  {
>  	struct virtio_balloon *vb = container_of(shrinker,
>  					struct virtio_balloon, shrinker);
> +	unsigned long count;
> +
> +	count = vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
> +	count += vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
>  
> -	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
> +	return count;
>  }
>  
> -static int virtio_balloon_oom_notify(struct notifier_block *nb,
> -				     unsigned long dummy, void *parm)
> +static void virtio_balloon_unregister_shrinker(struct virtio_balloon *vb)
>  {
> -	struct virtio_balloon *vb = container_of(nb,
> -						 struct virtio_balloon, oom_nb);
> -	unsigned long *freed = parm;
> +	unregister_shrinker(&vb->shrinker);
> +}
>  
> -	*freed += leak_balloon(vb, VIRTIO_BALLOON_OOM_NR_PAGES) /
> -		  VIRTIO_BALLOON_PAGES_PER_PAGE;
> -	update_balloon_size(vb);
> +static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
> +{
> +	vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
> +	vb->shrinker.count_objects = virtio_balloon_shrinker_count;
> +	vb->shrinker.seeks = DEFAULT_SEEKS;
>  
> -	return NOTIFY_OK;
> +	return register_shrinker(&vb->shrinker);
>  }
>  
>  static int virtballoon_probe(struct virtio_device *vdev)
> @@ -900,35 +935,22 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
>  				      poison_val, &poison_val);
>  		}
> -
> -		/*
> -		 * We're allowed to reuse any free pages, even if they are
> -		 * still to be processed by the host.
> -		 */
> -		vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
> -		vb->shrinker.count_objects = virtio_balloon_shrinker_count;
> -		vb->shrinker.seeks = DEFAULT_SEEKS;
> -		err = register_shrinker(&vb->shrinker);
> +	}
> +	/*
> +	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
> +	 * shrinker needs to be registered to relieve memory pressure.
> +	 */
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
> +		err = virtio_balloon_register_shrinker(vb);
>  		if (err)
>  			goto out_del_balloon_wq;
>  	}
> -	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)) {
> -		vb->oom_nb.notifier_call = virtio_balloon_oom_notify;
> -		vb->oom_nb.priority = VIRTIO_BALLOON_OOM_NOTIFY_PRIORITY;
> -		err = register_oom_notifier(&vb->oom_nb);
> -		if (err < 0)
> -			goto out_unregister_shrinker;
> -	}
> -
>  	virtio_device_ready(vdev);
>  
>  	if (towards_target(vb))
>  		virtballoon_changed(vdev);
>  	return 0;
>  
> -out_unregister_shrinker:
> -	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> -		unregister_shrinker(&vb->shrinker);
>  out_del_balloon_wq:
>  	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  		destroy_workqueue(vb->balloon_wq);
> @@ -967,11 +989,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
>  {
>  	struct virtio_balloon *vb = vdev->priv;
>  
> -	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> -		unregister_oom_notifier(&vb->oom_nb);
> -	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> -		unregister_shrinker(&vb->shrinker);
> -
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> +		virtio_balloon_unregister_shrinker(vb);
>  	spin_lock_irq(&vb->stop_update_lock);
>  	vb->stop_update = true;
>  	spin_unlock_irq(&vb->stop_update_lock);
> -- 
> 2.25.1
> 
> 

