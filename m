Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB25BE394
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiITKmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiITKmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:42:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A44D25C5;
        Tue, 20 Sep 2022 03:42:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a26so5125526ejc.4;
        Tue, 20 Sep 2022 03:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=uuydgXOSSksfr9Wyq7NKGaPAiF6c3Reu1UAxFxmEiTQ=;
        b=X4DfW+U+f0cZYYYqTcRT72yreLfwGmRHWSB++4/8buUAuPgoP6yq/yT+uUKlHoIzsM
         en3a/qzodvYR4u+LZX3AThvtnHGZAEpRaQrdZyi5FzVCetBjBSQ/hlxABmLmdqZlMhut
         SQxYbg6dsrUiObFIOZnurBBxD0eksZBXWy2r+HnH3/fiVmK2zbwA0Xd1wztBrhuqJ+1R
         yvk+jKdz9BnCEha10h7Gac34Z+I2bc+NhWhe15WTDM7YpDmaeQeDYuPI4SLl2dcFHA2q
         PUCyyg1ZZPmgwP//6LTBjJsOSVVzp9cXBDeedh3KCFipRMpjIdlANC9YElnuskkHyvHV
         XM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uuydgXOSSksfr9Wyq7NKGaPAiF6c3Reu1UAxFxmEiTQ=;
        b=Ji8kVmGQv4KFxLvsTWqkhb/RQW6T/SinwYi9ty+tPwyC4gjdhgrQ6pJYOCYQS+DoxN
         l4m+pOQZkSJfQD6LZBydD5qess1kBQlNahRDH2Y9mjSlmUBs080SrIkXaw0ZWO38UVPT
         5rQZdZqqTeUOn4Z8elXwWawqKF3EGAOQBamYmGiRJw0vBqrkPV+87/KK3O+mwH47ZrMo
         VjJFW7r4fGGmdcUD72MF0riPKVnzBFFESbsXLPIusqlZESNhMcyxrMpkYBcjKbYP1O2y
         HYextUWbxqWXIbMGc5c7pLbWyxTwdUW/Dp7XQEoT/IeampdId9HvB89HyW1qlLhhsP6I
         aqZQ==
X-Gm-Message-State: ACrzQf0rGj0EPaWna8k+D87OOSM6h2vD5eywX2e0kLdj8s4YZ6Fm08kT
        yWWc1iFUV8ZuecAw1lWMPesfcgSk3qZzyA==
X-Google-Smtp-Source: AMsMyM5M+QXEiRZTgdDrT2fyRm961CHm+K4bmMwaUe7vgkqriTlvJfhJvJG0blTD66q8ok8QlE3KKA==
X-Received: by 2002:a17:907:2d2a:b0:77e:def7:65e9 with SMTP id gs42-20020a1709072d2a00b0077edef765e9mr16196840ejc.85.1663670524165;
        Tue, 20 Sep 2022 03:42:04 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id q16-20020a1709060f9000b0077f15e98256sm606055ejj.203.2022.09.20.03.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 03:42:03 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 0B006BE356D; Tue, 20 Sep 2022 12:42:03 +0200 (CEST)
Date:   Tue, 20 Sep 2022 12:42:03 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Karol Herbst <kherbst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org,
        Computer Enthusiastic <computer.enthusiastic@gmail.com>
Subject: Re: [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
Message-ID: <YymY+3+C2aI7T3GU@eldamar.lan>
References: <20220819200928.401416-1-kherbst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819200928.401416-1-kherbst@redhat.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Aug 19, 2022 at 10:09:28PM +0200, Karol Herbst wrote:
> It is a bit unlcear to us why that's helping, but it does and unbreaks
> suspend/resume on a lot of GPUs without any known drawbacks.
> 
> Cc: stable@vger.kernel.org # v5.15+
> Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/156
> Signed-off-by: Karol Herbst <kherbst@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 35bb0bb3fe61..126b3c6e12f9 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -822,6 +822,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
>  		if (ret == 0) {
>  			ret = nouveau_fence_new(chan, false, &fence);
>  			if (ret == 0) {
> +				/* TODO: figure out a better solution here
> +				 *
> +				 * wait on the fence here explicitly as going through
> +				 * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
> +				 *
> +				 * Without this the operation can timeout and we'll fallback to a
> +				 * software copy, which might take several minutes to finish.
> +				 */
> +				nouveau_fence_wait(fence, false, false);
>  				ret = ttm_bo_move_accel_cleanup(bo,
>  								&fence->base,
>  								evict, false,
> -- 
> 2.37.1
> 
> 

While this is marked for 5.15+ only, a user in Debian was seeing the
suspend issue as well on 5.10.y and did confirm the commit fixes the
issue as well in the 5.10.y series:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=989705#69

Karol, Lyude, should that as well be picked for 5.10.y?

Regards,
Salvatore
