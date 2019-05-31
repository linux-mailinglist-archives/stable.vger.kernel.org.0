Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED23430E6C
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfEaMzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 08:55:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44396 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaMzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 08:55:07 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so700826iob.11
        for <stable@vger.kernel.org>; Fri, 31 May 2019 05:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tomeuvizoso-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RRUe8zQwyuAuKGZtxLK3YIRDz14pyhb0pZiftXDRPlU=;
        b=cTkTyaXWwnB6q1lhhnK+dEPVS0ql6hvJxhqWFJa65ajuoMexH/KFwN/9JkjS53Nr5b
         uuX4lv9Y4pPu/m0qxsPMjUW3d3+unGrI8vIVtimdPqlPEV6KvDNBAdZWsQtZlaGMZ2T6
         o1mh+pYD1AppJzI8MEKcaWu0nTPnWStC7tWjg6yusf7TX/KxqHVCtKZCsoPKq0pE6UZg
         djQfN4nhCa55hbwWeGIWIEGrYZOBNKkmD7ACjVBlkVs+wV6oa1+IwkL/RrudAdzPKqv0
         u23SbWK1xRqWK4qaUq71aWUYcfj+16LUpAYDyJwnVB7iyqj13ghwEB11kCFX9u8qepYZ
         B/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRUe8zQwyuAuKGZtxLK3YIRDz14pyhb0pZiftXDRPlU=;
        b=eR/qjB2iqyoaH0NxgSlrLN5y79eolDK81jABsaR3GVjXcY+hBG1dRnqxIdmw3rYZ4C
         OEmUQRNXHPNFy7GyQv+5EvEVC+u2osq5+WhIlrsd292aIxci2L6V6jm5Xq83UTr7ZDEj
         1/alc66joiEWZkJoQrb2yaPbwB53sKLDrLgJb9VmZ09jNGqS1NLMnqmyHbYRT9SQ3inQ
         22F12VLu4UnQRyWoz5s6i8IKtwvxPOK+nN+wVLS6+JBr27eXmyUKPuSUxg6q6CHt+9CD
         +MM1J7rK9iLAlKGqQcSdEz2y2XGB+c/gBCO0iizDD6LsZcYvfy6uFIBRYGncAmibQf98
         aWVA==
X-Gm-Message-State: APjAAAVqCTn6HblK5PkvCIHK0pcw7XnrPNwV9rkzCFg2ZJ7usRZ3rZPH
        FbqA7hmSmst5a/8bI/R6I+vxoPk8mpI=
X-Google-Smtp-Source: APXvYqyPQOj0SCm9EQYHG2Esee3XtqSEiMVCsMaKFRmrYxMnI3r/gfwE4dY7ZPH4oEYFSC0xZxC55A==
X-Received: by 2002:a6b:ac01:: with SMTP id v1mr6943115ioe.162.1559307306833;
        Fri, 31 May 2019 05:55:06 -0700 (PDT)
Received: from mail-it1-f169.google.com (mail-it1-f169.google.com. [209.85.166.169])
        by smtp.gmail.com with ESMTPSA id i7sm1871352iop.79.2019.05.31.05.55.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 05:55:06 -0700 (PDT)
Received: by mail-it1-f169.google.com with SMTP id h9so872485itk.3
        for <stable@vger.kernel.org>; Fri, 31 May 2019 05:55:06 -0700 (PDT)
X-Received: by 2002:a02:7b2d:: with SMTP id q45mr1964953jac.127.1559307306025;
 Fri, 31 May 2019 05:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190529091836.22060-1-boris.brezillon@collabora.com>
In-Reply-To: <20190529091836.22060-1-boris.brezillon@collabora.com>
From:   Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date:   Fri, 31 May 2019 14:54:54 +0200
X-Gmail-Original-Message-ID: <CAAObsKBYvVKVTJf6ZwSarAVr6FSCz-NDYNhEqrDhBWUM3q57Nw@mail.gmail.com>
Message-ID: <CAAObsKBYvVKVTJf6ZwSarAVr6FSCz-NDYNhEqrDhBWUM3q57Nw@mail.gmail.com>
Subject: Re: [PATCH] drm/panfrost: Make sure a BO is only unmapped when appropriate
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 May 2019 at 11:18, Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> mmu_ops->unmap() will fail when called on a BO that has not been
> previously mapped, and the error path in panfrost_ioctl_create_bo()
> can call drm_gem_object_put_unlocked() (which in turn calls
> panfrost_mmu_unmap()) on a BO that has not been mapped yet.
>
> Keep track of the mapped/unmapped state to avoid such issues.
>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_gem.h | 1 +
>  drivers/gpu/drm/panfrost/panfrost_mmu.c | 8 ++++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
> index 045000eb5fcf..6dbcaba020fc 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> @@ -11,6 +11,7 @@ struct panfrost_gem_object {
>         struct drm_gem_shmem_object base;
>
>         struct drm_mm_node node;
> +       bool is_mapped;
>  };
>
>  static inline
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 762b1bd2a8c2..fb556aa89203 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -156,6 +156,9 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
>         struct sg_table *sgt;
>         int ret;
>
> +       if (bo->is_mapped)
> +               return 0;

In what circumstances we want to silently go on? I would expect that
for this function to be called when the BO has been mapped already
would mean that we have a bug in the kernel, so why not a WARN?

> +
>         sgt = drm_gem_shmem_get_pages_sgt(obj);
>         if (WARN_ON(IS_ERR(sgt)))
>                 return PTR_ERR(sgt);
> @@ -189,6 +192,7 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
>
>         pm_runtime_mark_last_busy(pfdev->dev);
>         pm_runtime_put_autosuspend(pfdev->dev);
> +       bo->is_mapped = true;
>
>         return 0;
>  }
> @@ -203,6 +207,9 @@ void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
>         size_t unmapped_len = 0;
>         int ret;
>
> +       if (!bo->is_mapped)
> +               return;

Similarly, I think that what we should do is not to call
panfrost_mmu_unmap when a BO is freed if we know it isn't mapped. And
probably add a WARN here if it still gets called when the BO isn't
mapped.

> +
>         dev_dbg(pfdev->dev, "unmap: iova=%llx, len=%zx", iova, len);
>
>         ret = pm_runtime_get_sync(pfdev->dev);
> @@ -230,6 +237,7 @@ void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
>
>         pm_runtime_mark_last_busy(pfdev->dev);
>         pm_runtime_put_autosuspend(pfdev->dev);
> +       bo->is_mapped = false;
>  }
>
>  static void mmu_tlb_inv_context_s1(void *cookie)
> --
> 2.20.1
>

Thanks for taking care of this!

Tomeu
