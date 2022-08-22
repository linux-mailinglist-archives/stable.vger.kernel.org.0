Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296D859CA9B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 23:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiHVVPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 17:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbiHVVPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 17:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF5332AA8
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 14:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661202939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W99ikbboaJjO+6FHQ4eYoJSNppDNkQvI/eXvuOgjNJE=;
        b=SEHLsd4EzQ+W6SSU+barWBOc+9HjEWgdL9j0eW8WGSLMVLfGAwdAtlMqxMS4MBpAO2beVE
        gPZACCOdCpvHrGOtTh5nMzKLuNHChrOGeNvo7y5mspnqdp4tolnLm+8AutH4bZhBRzpe4n
        3QCm4mDCDEasehYDnw4WzTaVpE7/a8Q=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-343-aJY7c96XNGyuORKTNmKJVw-1; Mon, 22 Aug 2022 17:15:37 -0400
X-MC-Unique: aJY7c96XNGyuORKTNmKJVw-1
Received: by mail-qt1-f199.google.com with SMTP id bq11-20020a05622a1c0b00b003434f125b77so9325541qtb.20
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 14:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc;
        bh=W99ikbboaJjO+6FHQ4eYoJSNppDNkQvI/eXvuOgjNJE=;
        b=tEBp9l2Inbm/lV5nipRqIOr+Plc8CiBvTxKuF0uLoqLx6IeRlcDoFqYAjiLpLAJeKc
         euC36Ldzdbvo+u61bTHIs1QBhV/Re6AdBhDs9NoiUy2FEvw7KFD1hiUHI+fZi7HPtDA2
         LbpFkMWORrjSPXVl1vHzLw0v54IEfjY6c/U5ggDNfHoRIMRcRKThBq+p+Khx9fkCPkI2
         IHdDIgj2WRx4xkfShN09KgQktuzhgo7fvVJfRm/qLI2hHEzwyvouMHMlfn/TDWMSKWLH
         iYfxgXjbHhnYCuJEOLOpvdwz5e8DGMEqs8OqRPDs1/JBcM0huznUKp5m6MbACWqbImxU
         6vPg==
X-Gm-Message-State: ACgBeo1HrqQeCVCH3VQO5y7mg4MYu5DmYd0yMkJQkgo+lphVVs/p+JhB
        ZrA1yyC3OQAEYR903nK3M5u5fknXL9rtHGDEiZdQNPsf8JrascGWA6BZ7FCt8AkP4ZBocVL2a2U
        SH90vC7jiHPkufr2c
X-Received: by 2002:a05:622a:392:b0:343:738e:6f6b with SMTP id j18-20020a05622a039200b00343738e6f6bmr17200981qtx.174.1661202936870;
        Mon, 22 Aug 2022 14:15:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5EnIC47AD0HBg/p8AcS7SZGGBNwPKTx0oDmr3tOt7DoWa5vhMJb3HcnPkR2X3yyJinWb3S5A==
X-Received: by 2002:a05:622a:392:b0:343:738e:6f6b with SMTP id j18-20020a05622a039200b00343738e6f6bmr17200952qtx.174.1661202936595;
        Mon, 22 Aug 2022 14:15:36 -0700 (PDT)
Received: from [192.168.8.139] (pool-100-0-245-4.bstnma.fios.verizon.net. [100.0.245.4])
        by smtp.gmail.com with ESMTPSA id w25-20020a05620a0e9900b006b5bf5d45casm11352206qkm.27.2022.08.22.14.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:15:35 -0700 (PDT)
Message-ID: <26a6f44c4b2a24d01b23d692416bf3f73103410d.camel@redhat.com>
Subject: Re: [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
From:   Lyude Paul <lyude@redhat.com>
To:     Karol Herbst <kherbst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Date:   Mon, 22 Aug 2022 17:15:34 -0400
In-Reply-To: <20220819200928.401416-1-kherbst@redhat.com>
References: <20220819200928.401416-1-kherbst@redhat.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Fri, 2022-08-19 at 22:09 +0200, Karol Herbst wrote:
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

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

