Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6DD3D719
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406187AbfFKTmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:42:49 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42670 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406150AbfFKTmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:42:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id z25so21811497edq.9
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 12:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=b0CipaHb6QgdqMnFO5rkJaZeOdwG16158x+y5hKGxe4=;
        b=cpKcN5pbblt721RTSYss5mgbiy40j+AaFpeQV1/k0rGoCsdNuzKannb0XMmuiyDKwX
         +hOXMt2D2wRYv7RqTkZCy8PrEQ7hwh1S15lxDKn3txtW8FS5lrDBQ8mcumiKzkLMIVQo
         MXWgp+gBFRCAuJee1OfwplnngxQG325Nb/FIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=b0CipaHb6QgdqMnFO5rkJaZeOdwG16158x+y5hKGxe4=;
        b=P3euPzJd3KrQPPYGqKhLVzHESPg2uPkc18BI4M+9GUmddQpu9NQsFeyk1JAGSDwD0w
         7yQF0c8f3f12YYsWs8cXeKZqw6zOMVcaeHFFCC5wwL7LRBUvB0w5JDaAnpUQwfczRC6U
         9y2EmtMmICay8PGFuQ7FHwXulIupaMVZ8kz9OoO1HzZcE07p27+B5iDV3pllBrH23I3X
         Nr1v1l4G6qV6mV5u85v8MBEBPiI6flYDNhGpLmEgwSIAL9Geo2D3N+5YjCEKDfd14zKh
         QKJQJd0ADyW6eC8kgFkgztdBMItIwWyuV5A1h4EwT2tyjfFqt0s19z6YWt1Tf3GH+6cU
         KRDA==
X-Gm-Message-State: APjAAAWszz/TnlpHSKF3LIpbr/Ijr3c1VnxFndG5AhKXtirGEvjKHVLg
        iN4IRKFjWXyzg+YN3rDbJoJUog==
X-Google-Smtp-Source: APXvYqzU49rrap/5pxe6DB3Um70y7TiyBoGazWajJHt3CTSFE6mD4+DgAKZMLWyESo24a7CFlIUDBw==
X-Received: by 2002:a50:a941:: with SMTP id m1mr84856398edc.157.1560282166973;
        Tue, 11 Jun 2019 12:42:46 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id l38sm608854eda.1.2019.06.11.12.42.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 12:42:46 -0700 (PDT)
Date:   Tue, 11 Jun 2019 21:42:43 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sven Joachim <svenjoac@gmx.de>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 5.1.9 build failure with
 CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
Message-ID: <20190611194243.GM2458@phenom.ffwll.local>
Mail-Followup-To: Thomas Backlund <tmb@mageia.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Joachim <svenjoac@gmx.de>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
References: <87k1dsjkdo.fsf@turtle.gmx.de>
 <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
 <20190611174006.GB31662@kroah.com>
 <11b2d815-d0c0-1f68-557d-144166c4a1a7@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11b2d815-d0c0-1f68-557d-144166c4a1a7@mageia.org>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 10:08:10PM +0300, Thomas Backlund wrote:
> Den 11-06-2019 kl. 20:40, skrev Greg Kroah-Hartman:
> > On Tue, Jun 11, 2019 at 07:33:16PM +0200, Daniel Vetter wrote:
> > > On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > > On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
> > > > > Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
> > > > > legacy contexts. (v3)") has caused a build failure for me when I
> > > > > actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
> > > > > 
> > > > > ,----
> > > > > | Kernel: arch/x86/boot/bzImage is ready  (#1)
> > > > > |   Building modules, stage 2.
> > > > > |   MODPOST 290 modules
> > > > > | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> > > > > | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> > > > > `----
> > > 
> > > Calling drm_legacy_mmap is definitely not a great idea. I think either
> > > we need a custom patch to remove that out on older kernels, or maybe
> > > even #ifdef if you want to be super paranoid about breaking stuff ...
> > > 
> > > > > Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
> > > > > Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
> > > > > drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
> > > > > apply in 5.1.9.
> > > > > 
> > > > > Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
> > > > > them yet.
> > > > 
> > > > They probably are.
> > > > 
> > > > Should I just revert this patch in the stable tree, or add some other
> > > > patch (like the one pointed out here, which seems an odd patch for
> > > > stable...)
> > > 
> > > ... or backport the above patch, that should be save to do too. Not
> > > sure what stable folks prefer?
> > 
> > The above patch does not apply to all of the stable branches, so how
> > about I just revert this?  People can live with this option not able to
> > turn off for now, and if they really want it, they can use a newer
> > kernel, right?
> > 
> 
> Or add the simple fix suggested by Daniel (if I understand correctly):
> 
> 
> From: Thomas Backlund <tmb@mageia.org>
> 
> Setting CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n (added by commit: b30a43ac7132)
> causes the build to fail with:
> 
> ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> 
> Fix that by adding check for CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT around
> the code using drm_legacy_mmap()
> 
> Fixes: b30a43ac7132 drm/nouveau: add kconfig option to turn off nouveau
> legacy contexts. (v3)
> Signed-off-by: Thomas Backlund <tmb@mageia.org>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Not-entirely-upstream-sha1-but-equivalent: bed2dd8421 ("drm/ttm:
Quick-test mmap offset in ttm_bo_mmap()")

Cheers, Daniel

> 
> ---
>  drivers/gpu/drm/nouveau/nouveau_ttm.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
> @@ -168,8 +168,10 @@ nouveau_ttm_mmap(struct file *filp, stru
>  	struct drm_file *file_priv = filp->private_data;
>  	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
> 
> +#if defined(CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT)
>  	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
>  		return drm_legacy_mmap(filp, vma);
> +#endif
> 
>  	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
>  }
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
