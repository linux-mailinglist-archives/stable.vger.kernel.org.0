Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3FD63C901
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 21:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiK2UNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 15:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbiK2UNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 15:13:16 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4F82A40D;
        Tue, 29 Nov 2022 12:13:15 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id l127so16503394oia.8;
        Tue, 29 Nov 2022 12:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qAZcMqSiLOnrB/y0CJ76qNXOhphHB04hIWWkiOOhBWo=;
        b=TECpmFPT9bH8khmU5jnle3NB2u05TK83SU5wluwX8C52w+okSX4vleudKyxwU2jZFl
         SLQM981YdXg6f4z+kzwE9RlJZuvF2nF1EqufaAx7j0UjRB21LFA2iTJb+a1uI2qU5umo
         3CmPmYfJHdgR2ChJeToSTelJXeQhEsynPWd3f9/P6chEXjcHW9bfRQh0KKGd0CL4YwpC
         w0D93FxdMPTYwHgrDxWWj+4qmiiDdJY2vvaXYwDSK3uhpomhuu2ayZPDkKD3QgPyccbv
         tXDQsGX4sT2VUfgu28A/WGYNhKVWvONvb5wDcZrFVp3zapQ83RoTPI7wabV6JJh70Lib
         mjhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAZcMqSiLOnrB/y0CJ76qNXOhphHB04hIWWkiOOhBWo=;
        b=fJlMiHE5fr/+WELRl92r9WNV58o/hVbKkgDd/drhCOgPX71H7OXjTQ+8BliJ8T4kv+
         DMEzHhqmmn+7kcG20XJOZRxcTcUatxg/dOlaGQJY+Cd6LSmnUzd4Mm1l5RxjAxMFrB8Y
         jsQNeFORSClfEts61Gcb6dfZjffLcC85jJrsZkAC2q2cGZsQVlMTHj3ILI3eKmmJ/NDt
         GxiDQ5zQLJYeezPy7wxL0wvS8E7ypHYfl74EKMM06Kd4kk8hsdwluUY7ePQaUmr6EHr6
         M3KgvCJ/4fvMHQgVf9nT87+iS3NSmHdBh1hjTPJ7YpcXtlm3IDvK8gV2kvcGrS4qrgyt
         jDZw==
X-Gm-Message-State: ANoB5pkDPpd3ATqbWyq7kPpyaDiRPQ/hasLp9ivJznJ0JgNlyibQQ9OF
        88WECQ8FE5/sIN/7hi2kMQBFEG1ZYuA=
X-Google-Smtp-Source: AA0mqf5Ck3QosPD7Tun8zUZgP6quzOUAsBrrpm59KVtcNgqflrTIwbEToothH20Ysb5tXovhdb0RgA==
X-Received: by 2002:a05:6808:243:b0:359:f5bc:cb05 with SMTP id m3-20020a056808024300b00359f5bccb05mr17741503oie.230.1669752794983;
        Tue, 29 Nov 2022 12:13:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y66-20020a4a4545000000b0049f0671a23asm5865650ooa.9.2022.11.29.12.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:13:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Nov 2022 12:13:13 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Clark <robdclark@gmail.com>
Cc:     dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [1/2] drm/shmem-helper: Remove errant put in error path
Message-ID: <20221129201149.GA2131686@roeck-us.net>
References: <20221129200242.298120-2-robdclark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129200242.298120-2-robdclark@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 12:02:41PM -0800, Rob Clark wrote:
> From: Rob Clark <robdclark@chromium.org>
> 
> drm_gem_shmem_mmap() doesn't own this reference!
> 

I think the impact should be explained further.

> Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 35138f8a375c..110a9eac2af8 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -623,7 +623,6 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>  
>  	ret = drm_gem_shmem_get_pages(shmem);
>  	if (ret) {
> -		drm_gem_vm_close(vma);
>  		return ret;
>  	}

Drop the now unnecessary { }

Also, consider adding Reported-by: and possibly Suggested-by:.

Thanks,
Guenter
