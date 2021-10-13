Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A4442C31C
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbhJMO3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 10:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhJMO3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 10:29:54 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93D6C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 07:27:50 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id j8so4829983uak.9
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 07:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bj1qNEG+5FP9GKXBmM4kufW+uVF44PKuB8CVz9DjaKc=;
        b=gRlcFYjDdxION0Qyby/akwGm75WSXINStyTQHZZuBBF2RIGoipgwpbONDCZzUuhSr+
         1CtJI5NfddIfHkuRkTJ3QSLnJFns92TUxaOOXLQRCrS8PCV/mAopiiz1ktRZN4hiMhHL
         ONOGYv4jqBzR9hcQiavr5d1cIRmjA/7PfIKjm84KYRf8FgXSwuuGS/J/UNfs9bbDoeI1
         9c5cEUkU+uYHFms0MChAkU9AMdC8bbSkYsLM30Empx/KBSV9vdpQSDGxK9mI8n0YeSfB
         gqi7v/FIqH0F3J7NkhSw2VpGE2QAAVTPg41ty5iHRUfQbYMqFzQeM6LXfO3d/zjG7mK8
         getA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bj1qNEG+5FP9GKXBmM4kufW+uVF44PKuB8CVz9DjaKc=;
        b=3TCcV0Nm5fp3QrPpoJrhJbIFYTeNu0Ah85stO8Z+xsWUolS1+31MNWwW5oDMxekVy0
         Q73P01slz5KGC5PJoCjHCQJh2IMwYcltyxioj/J5wus+AWTW1ifLCcS0J0yeNuZ4I8Kt
         55gT2vZrUOKenqRPxPN0GiAKOiCv8PV3maGJ1Xr8vWss+AkZq9CJJt8hlUdlgWq86XRr
         zCKT89pt9GU00WuVTSPLi3haof4CJuFf8hW6YhrKDxPJKdR9QTLXWKsRFrbnFxfoyLzm
         xv3pfugDZjpel6D54OlMSXoVGWfEA6zxtXIG1E4lBbJDBJ1Jd8YpEJ1lSmR6OtbBl3gZ
         xqlQ==
X-Gm-Message-State: AOAM533NgA9HLi4wYCLk0wTOZ0Hg1bpHI0jEOa9n0R+QKaJ+6gT2KaDa
        jIVsJt0Wq9n/FjpfoJ5BFof4IdENJIEJPw==
X-Google-Smtp-Source: ABdhPJyeFIGcjygyszMEknoRPsLumSj93t/Zso1VLa1Hm6InMKEqO7C3740GLJxdppAFCA5swk/HJg==
X-Received: by 2002:ab0:7a50:: with SMTP id a16mr29932206uat.92.1634135270072;
        Wed, 13 Oct 2021 07:27:50 -0700 (PDT)
Received: from fedora ([196.32.91.248])
        by smtp.gmail.com with ESMTPSA id j11sm5825138uaa.6.2021.10.13.07.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:27:49 -0700 (PDT)
Date:   Wed, 13 Oct 2021 11:27:44 -0300
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To:     Chen-Yu Tsai <wenst@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] media: rkvdec: Support dynamic resolution changes
Message-ID: <YWbs4Ng/mDQpIoiK@fedora>
References: <20211008100423.739462-1-wenst@chromium.org>
 <20211008100423.739462-3-wenst@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008100423.739462-3-wenst@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chen-Yu,

On Fri, Oct 08, 2021 at 06:04:23PM +0800, Chen-Yu Tsai wrote:
> The mem-to-mem stateless decoder API specifies support for dynamic
> resolution changes. In particular, the decoder should accept format
> changes on the OUTPUT queue even when buffers have been allocated,
> as long as it is not streaming.
> 
> Relax restrictions for S_FMT as described in the previous paragraph,
> and as long as the codec format remains the same. This aligns it with
> the Hantro and Cedrus decoders. This change was mostly based on commit
> ae02d49493b5 ("media: hantro: Fix s_fmt for dynamic resolution changes").
> 
> Since rkvdec_s_fmt() is now just a wrapper around the output/capture
> variants without any additional shared functionality, drop the wrapper
> and call the respective functions directly.
> 
> Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>

Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Seems we forgot to port Hantro changes over here, so thanks a lot
for picking this up.

Ezequiel

> ---
>  drivers/staging/media/rkvdec/rkvdec.c | 40 +++++++++++++--------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
> index 7131156c1f2c..3f3f96488d74 100644
> --- a/drivers/staging/media/rkvdec/rkvdec.c
> +++ b/drivers/staging/media/rkvdec/rkvdec.c
> @@ -280,31 +280,20 @@ static int rkvdec_try_output_fmt(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int rkvdec_s_fmt(struct file *file, void *priv,
> -			struct v4l2_format *f,
> -			int (*try_fmt)(struct file *, void *,
> -				       struct v4l2_format *))
> +static int rkvdec_s_capture_fmt(struct file *file, void *priv,
> +				struct v4l2_format *f)
>  {
>  	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
>  	struct vb2_queue *vq;
> +	int ret;
>  
> -	if (!try_fmt)
> -		return -EINVAL;
> -
> -	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	/* Change not allowed if queue is busy */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +			     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
>  	if (vb2_is_busy(vq))
>  		return -EBUSY;
>  
> -	return try_fmt(file, priv, f);
> -}
> -
> -static int rkvdec_s_capture_fmt(struct file *file, void *priv,
> -				struct v4l2_format *f)
> -{
> -	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
> -	int ret;
> -
> -	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_capture_fmt);
> +	ret = rkvdec_try_capture_fmt(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> @@ -319,9 +308,20 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
>  	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
>  	const struct rkvdec_coded_fmt_desc *desc;
>  	struct v4l2_format *cap_fmt;
> -	struct vb2_queue *peer_vq;
> +	struct vb2_queue *peer_vq, *vq;
>  	int ret;
>  
> +	/*
> +	 * In order to support dynamic resolution change, the decoder admits
> +	 * a resolution change, as long as the pixelformat remains. Can't be
> +	 * done if streaming.
> +	 */
> +	vq = v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +	if (vb2_is_streaming(vq) ||
> +	    (vb2_is_busy(vq) &&
> +	     f->fmt.pix_mp.pixelformat != ctx->coded_fmt.fmt.pix_mp.pixelformat))
> +		return -EBUSY;
> +
>  	/*
>  	 * Since format change on the OUTPUT queue will reset the CAPTURE
>  	 * queue, we can't allow doing so when the CAPTURE queue has buffers
> @@ -331,7 +331,7 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
>  	if (vb2_is_busy(peer_vq))
>  		return -EBUSY;
>  
> -	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_output_fmt);
> +	ret = rkvdec_try_output_fmt(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
> 
