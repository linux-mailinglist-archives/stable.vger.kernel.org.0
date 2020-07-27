Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1889522EA36
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 12:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgG0Kmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 06:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgG0Kmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 06:42:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97E9C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 03:42:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so4379368wrm.6
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 03:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfnKwpFfCT3eWsghXm9EStQYxti5fK7/DgM2tXjtlVg=;
        b=dlIwVtD3XxSZnuBzqqHdDsKqcjh4mUOqktt3t3pbblrZHwfv2919SHLSQDWg4RswvQ
         z+tMm86cda/zTKTi0F/OXbTssDosb+yTqwAjP5K2Cqi968S/AxALbv0OuTOGQOIEoxGP
         6r9AwoYkIGN1ljR1c0iPmPOnI4pxrfzYUUwFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfnKwpFfCT3eWsghXm9EStQYxti5fK7/DgM2tXjtlVg=;
        b=YWRJK3nnMpaetoPocrUKCCXo8Zyr6LaY6bgz6aJjt79SLJVtLYTYHbsW5Yl/5h9oBI
         UUON32OYRf6sErImTJ2Vr+SXPEEp6tfhvy6SkTJjxiYqe3XdBAsw2ViBQPbBR/Ua//h3
         9yx9D3cLPNn3WBACECa8k1YbB9aajXUXLACGdaxaqHM2QH7UIJ6kzti00yiDdDIBQoO2
         ZxxUa616r7oU92yq0nKZCeFAIM/WTLrqyvlkIggK2024MLuBxHoxzmiEycg05ZoZwFnj
         x2udinHf5NQ5HTObWpP6oEVhLZpjOg6SCBsXecPxXblP9iNNsLy9eSJzwNaFgcRW0EeR
         aTug==
X-Gm-Message-State: AOAM53026yaEDGcxy/IqM0HsC3rBa9gs/N7BU64Yeea4cBaTiXLETcl1
        33HUJGbC4n3wwMLXWvnGsjz+9w==
X-Google-Smtp-Source: ABdhPJwJIpsv0g6kXOlNkZEILuNnvqOeq0JmGgC66zD+kmvF219s0cLX2Om8++MXIZEHUwR/nNSaaA==
X-Received: by 2002:a5d:48c8:: with SMTP id p8mr19308704wrs.84.1595846572669;
        Mon, 27 Jul 2020 03:42:52 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id h199sm17789081wme.42.2020.07.27.03.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 03:42:51 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:42:50 +0200
From:   daniel@ffwll.ch
Cc:     airlied@redhat.com, daniel@ffwll.ch, sam@ravnborg.org,
        kraxel@redhat.com, emil.l.velikov@gmail.com,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] drm/ast: Store image size in HW cursor info
Message-ID: <20200727104250.GV6419@phenom.ffwll.local>
References: <20200727073707.21097-1-tzimmermann@suse.de>
 <20200727073707.21097-3-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727073707.21097-3-tzimmermann@suse.de>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 09:37:06AM +0200, Thomas Zimmermann wrote:
> Store the image size as part of the HW cursor info, so that the
> cursor show function doesn't require the information from the
> caller. No functional changes.

Uh just pass the state structure and done? All these "store random stuff
in private structures" (they're not even atomic state structures, it's the
driver private thing even!) is very non-atomic. And I see zero reasons why
you have to do this, the cursor stays around.
-Daniel

> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/ast/ast_cursor.c | 13 +++++++++++--
>  drivers/gpu/drm/ast/ast_drv.h    |  7 +++++--
>  drivers/gpu/drm/ast/ast_mode.c   |  8 +-------
>  3 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ast/ast_cursor.c b/drivers/gpu/drm/ast/ast_cursor.c
> index acf0d23514e8..8642a0ce9da6 100644
> --- a/drivers/gpu/drm/ast/ast_cursor.c
> +++ b/drivers/gpu/drm/ast/ast_cursor.c
> @@ -87,6 +87,8 @@ int ast_cursor_init(struct ast_private *ast)
>  
>  		ast->cursor.gbo[i] = gbo;
>  		ast->cursor.vaddr[i] = vaddr;
> +		ast->cursor.size[i].width = 0;
> +		ast->cursor.size[i].height = 0;
>  	}
>  
>  	return drmm_add_action_or_reset(dev, ast_cursor_release, NULL);
> @@ -194,6 +196,9 @@ int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *fb)
>  	/* do data transfer to cursor BO */
>  	update_cursor_image(dst, src, fb->width, fb->height);
>  
> +	ast->cursor.size[ast->cursor.next_index].width = fb->width;
> +	ast->cursor.size[ast->cursor.next_index].height = fb->height;
> +
>  	drm_gem_vram_vunmap(gbo, src);
>  	drm_gem_vram_unpin(gbo);
>  
> @@ -249,14 +254,18 @@ static void ast_cursor_set_location(struct ast_private *ast, u16 x, u16 y,
>  	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xc7, y1);
>  }
>  
> -void ast_cursor_show(struct ast_private *ast, int x, int y,
> -		     unsigned int offset_x, unsigned int offset_y)
> +void ast_cursor_show(struct ast_private *ast, int x, int y)
>  {
> +	unsigned int offset_x, offset_y;
>  	u8 x_offset, y_offset;
>  	u8 __iomem *dst, __iomem *sig;
>  	u8 jreg;
>  
>  	dst = ast->cursor.vaddr[ast->cursor.next_index];
> +	offset_x = AST_MAX_HWC_WIDTH -
> +		   ast->cursor.size[ast->cursor.next_index].width;
> +	offset_y = AST_MAX_HWC_HEIGHT -
> +		   ast->cursor.size[ast->cursor.next_index].height;
>  
>  	sig = dst + AST_HWC_SIZE;
>  	writel(x, sig + AST_HWC_SIGNATURE_X);
> diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
> index e3a264ac7ee2..57414b429db3 100644
> --- a/drivers/gpu/drm/ast/ast_drv.h
> +++ b/drivers/gpu/drm/ast/ast_drv.h
> @@ -116,6 +116,10 @@ struct ast_private {
>  	struct {
>  		struct drm_gem_vram_object *gbo[AST_DEFAULT_HWC_NUM];
>  		void __iomem *vaddr[AST_DEFAULT_HWC_NUM];
> +		struct {
> +			unsigned int width;
> +			unsigned int height;
> +		} size[AST_DEFAULT_HWC_NUM];
>  		unsigned int next_index;
>  	} cursor;
>  
> @@ -311,8 +315,7 @@ void ast_release_firmware(struct drm_device *dev);
>  int ast_cursor_init(struct ast_private *ast);
>  int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *fb);
>  void ast_cursor_page_flip(struct ast_private *ast);
> -void ast_cursor_show(struct ast_private *ast, int x, int y,
> -		     unsigned int offset_x, unsigned int offset_y);
> +void ast_cursor_show(struct ast_private *ast, int x, int y);
>  void ast_cursor_hide(struct ast_private *ast);
>  
>  #endif
> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
> index 3680a000b812..5b2b39c93033 100644
> --- a/drivers/gpu/drm/ast/ast_mode.c
> +++ b/drivers/gpu/drm/ast/ast_mode.c
> @@ -671,20 +671,14 @@ ast_cursor_plane_helper_atomic_update(struct drm_plane *plane,
>  				      struct drm_plane_state *old_state)
>  {
>  	struct drm_plane_state *state = plane->state;
> -	struct drm_framebuffer *fb = state->fb;
>  	struct ast_private *ast = plane->dev->dev_private;
> -	unsigned int offset_x, offset_y;
> -
> -	offset_x = AST_MAX_HWC_WIDTH - fb->width;
> -	offset_y = AST_MAX_HWC_WIDTH - fb->height;
>  
>  	if (state->fb != old_state->fb) {
>  		/* A new cursor image was installed. */
>  		ast_cursor_page_flip(ast);
>  	}
>  
> -	ast_cursor_show(ast, state->crtc_x, state->crtc_y,
> -			offset_x, offset_y);
> +	ast_cursor_show(ast, state->crtc_x, state->crtc_y);
>  }
>  
>  static void
> -- 
> 2.27.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
