Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCE3143D
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 19:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEaRy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 13:54:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36645 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfEaRy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 13:54:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so6876041qkl.3;
        Fri, 31 May 2019 10:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Hy/bcA8XBZvnwwAh1TXp+fqxW5RiwbsUNxb0qwOXyik=;
        b=GNTbUmFYHRAjrHuqdgCzi76DzdQ1URoyPhQw8REkikMjfBNoK+dEBHLK1SyuWO0vwl
         Gr4kD5OzWVmRZ9gejfNsLI1Ly/lSqUzj+vcF6S6YMa/YdYQxlzhYohmx7OmRhLiSIFyW
         hhmI+Jw3FUiWaCCS5Ly5HiKlI65iJoWFH1Z3Rua/VoIiHTjpZq38sl7H3u9N7EC2FFls
         76SOszhyvZlHgBu1feTbDmo3I9POyWzp69lX0FBBQdxdUkQ4jOkMWpqRJ57wdifIC3xP
         +m/OiOGWTpoCWAcrMjpQFLy42h7rT2zXFmAMwhDsN8tzY/rOlBReJXeNrNI/lAt+QG1o
         Jaow==
X-Gm-Message-State: APjAAAWib1gro7t7YCUkRXJnDdu7EDYYOfC+eNGBOYy86J9F98XEoMMn
        UXEUN4MrUFe+HYNmfLDo/A8=
X-Google-Smtp-Source: APXvYqwQjXtxXgO5ZNpyd98oMG/Ey7bq4qivWKCrWk51aesKhgJiIqQSZVPxp6pTHI3Uu5Who2kkjQ==
X-Received: by 2002:a37:e505:: with SMTP id e5mr9966343qkg.153.1559325297875;
        Fri, 31 May 2019 10:54:57 -0700 (PDT)
Received: from [172.16.0.62] ([177.103.155.130])
        by smtp.gmail.com with ESMTPSA id 19sm4357817qtq.12.2019.05.31.10.54.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:54:56 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] drm/msm: fix fb references in async update
To:     Helen Koike <helen.koike@collabora.com>,
        dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com
Cc:     andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@google.com>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        linux-arm-msm@vger.kernel.org, robdclark@gmail.com,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        freedreno@lists.freedesktop.org,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20190314002027.7833-1-helen.koike@collabora.com>
 <20190314002027.7833-4-helen.koike@collabora.com>
From:   Helen Koike <helen@koikeco.de>
Openpgp: preference=signencrypt
Autocrypt: addr=helen@koikeco.de; keydata=
 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
Message-ID: <c591d04c-a7f8-f64b-aff9-4a79b61356e7@koikeco.de>
Date:   Fri, 31 May 2019 14:54:48 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190314002027.7833-4-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On 3/13/19 9:20 PM, Helen Koike wrote:
> Async update callbacks are expected to set the old_fb in the new_state
> so prepare/cleanup framebuffers are balanced.
> 
> Cc: <stable@vger.kernel.org> # v4.14+
> Fixes: 224a4c970987 ("drm/msm: update cursors asynchronously through atomic")
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> Hello,
> 
> As mentioned in the cover letter,
> But I couldn't test on MSM because I don't have the hardware and I would
> appreciate if anyone could test it.

I got this tested on a dragonboard 410c, no regressions where found and
no extra warnings.

These two tests where already failing for other reasons:
flip-vs-cursor-crc-atomic
flip-vs-cursor-crc-legacy

If you want to see the full log:

https://people.collabora.com/~koike/drm-fixes-results.zip

Thanks
Helen

> 
> In other platforms (VC4, AMD, Rockchip), there is a hidden
> drm_framebuffer_get(new_fb)/drm_framebuffer_put(old_fb) in async_update
> that is wrong, but I couldn't identify those here, not sure if it is hidden
> somewhere else, but if tests fail this is probably the cause.
> 
> Thanks!
> Helen
> 
> Changes in v3: None
> Changes in v2:
> - update CC stable and Fixes tag
> 
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> index be13140967b4..b854f471e9e5 100644
> --- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> +++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> @@ -502,6 +502,8 @@ static int mdp5_plane_atomic_async_check(struct drm_plane *plane,
>  static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
>  					   struct drm_plane_state *new_state)
>  {
> +	struct drm_framebuffer *old_fb = plane->state->fb;
> +
>  	plane->state->src_x = new_state->src_x;
>  	plane->state->src_y = new_state->src_y;
>  	plane->state->crtc_x = new_state->crtc_x;
> @@ -524,6 +526,8 @@ static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
>  
>  	*to_mdp5_plane_state(plane->state) =
>  		*to_mdp5_plane_state(new_state);
> +
> +	new_state->fb = old_fb;
>  }
>  
>  static const struct drm_plane_helper_funcs mdp5_plane_helper_funcs = {
> 
