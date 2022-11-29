Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14B163C95E
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 21:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiK2UcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 15:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiK2UcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 15:32:09 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA5C65E65;
        Tue, 29 Nov 2022 12:32:07 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id a7-20020a056830008700b0066c82848060so9916051oto.4;
        Tue, 29 Nov 2022 12:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=McAbw14BiQ73DSa9o6GveEvs17QUGuqrPm+2f4xSly4=;
        b=UBjBy16uV9RiPbZQyiCELDEPsxG5Zo1kOgVwnSnI6igYU1k0KjOPWZYBAWB+CO7aAF
         RyW0RVOsXElViko5+xhAg99DFDwH0+cdALaCoAcntAL72ZHCP4d1HHhZv4oOavAg5lEB
         VlbDIrE5OEsae5M3UrQQxQX93a+NcE038z6cAiu+pg0nEbZLPvWw65aBPLtdzRZGLJ1u
         g4jI6PYxh70bv/XFMs8yRTBqjlRAJYJmK4LpabZmXjj+3Qn8xPztJrIremPCj5xH0MlA
         8VSyaViPlfnh3XjBMxdFluLjBJVXzFBvkDpgaNO+nlkUVbjVYd7mv70+QtMUQRETWGDH
         OVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McAbw14BiQ73DSa9o6GveEvs17QUGuqrPm+2f4xSly4=;
        b=YnDJ8ichM9dhFk5PyuiP5zIZbBCXSzVuAAVXEeTyMHR41KFkCRKv03EEIKDJzxph/K
         OTFJyXfyXJ/FBO4u+iSD2QHCm1IvrgWkTWTTcfnO0GGoMyiqReSuchx/R6CEH7M0tARP
         HJxPzXFDiH2wh+msbDFGpQ63oqrDUlKOF6e2qjnbFoVbru0qC4thTtykAqFKw8veAZxf
         PObLuRWmkdG3ZQ3FI5EFH3V2yuPzzJdY2jeC8yD+2qL41QLllGhbOY4pBw1LHF23/4NS
         NpVg8dfD9reZa7Dx8xJI0qSLzxkNtqJwqPwHTHj37uwjHWWbZ5XPEp9tIj4AVqHJKkBT
         sdxA==
X-Gm-Message-State: ANoB5pn1jg7cTGQlSXTIu1+g7JtLS/8xPRndFi/11vNVX33CweMqqK2Y
        yj88DVlstkyyfUNSSk2qY2s=
X-Google-Smtp-Source: AA0mqf7VCPZSSpJi7hgkNdQgruwvWxZl04yrxcxWzOvD186kxgp3Uio9keKwY5UyGdEgcXLaR8HZFw==
X-Received: by 2002:a05:6830:6314:b0:663:bd3a:2e4b with SMTP id cg20-20020a056830631400b00663bd3a2e4bmr22087491otb.157.1669753927051;
        Tue, 29 Nov 2022 12:32:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g31-20020a056830309f00b0066cf6a14d1asm6522711ots.23.2022.11.29.12.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:32:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Nov 2022 12:32:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Clark <robdclark@gmail.com>
Cc:     dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [2/2] drm/shmem-helper: Avoid vm_open error paths
Message-ID: <20221129203205.GA2132357@roeck-us.net>
References: <20221129200242.298120-3-robdclark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129200242.298120-3-robdclark@gmail.com>
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

On Tue, Nov 29, 2022 at 12:02:42PM -0800, Rob Clark wrote:
> From: Rob Clark <robdclark@chromium.org>
> 
> vm_open() is not allowed to fail.  Fortunately we are guaranteed that
> the pages are already pinned, and only need to increment the refcnt.  So
> just increment it directly.

I don't know anything about drm or gem, but I am wondering _how_
this would be guaranteed. Would it be through the pin function ?
Just wondering, because that function does not seem to be mandatory.

> 
> Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 110a9eac2af8..9885ba64127f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
>  {
>  	struct drm_gem_object *obj = vma->vm_private_data;
>  	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> -	int ret;
>  
>  	WARN_ON(shmem->base.import_attach);
>  
> -	ret = drm_gem_shmem_get_pages(shmem);
> -	WARN_ON_ONCE(ret != 0);
> +	mutex_lock(&shmem->pages_lock);
> +
> +	/*
> +	 * We should have already pinned the pages, vm_open() just grabs

should or guaranteed ? This sounds a bit weaker than the commit
description.

> +	 * an additional reference for the new mm the vma is getting
> +	 * copied into.
> +	 */
> +	WARN_ON_ONCE(!shmem->pages_use_count);
> +
> +	shmem->pages_use_count++;
> +	mutex_unlock(&shmem->pages_lock);

The previous code, in that situation, would not increment pages_use_count,
and it would not set not set shmem->pages. Hopefully, it would not try to
do anything with the pages it was unable to get. The new code assumes that
shmem->pages is valid even if pages_use_count is 0, while at the same time
taking into account that this can possibly happen (or the WARN_ON_ONCE
would not be needed).

Again, I don't know anything about gem and drm, but it seems to me that
there might now be a severe problem later on if the WARN_ON_ONCE()
ever triggers.

Thanks,
Guenter

>  
>  	drm_gem_vm_open(vma);
>  }
