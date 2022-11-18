Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DD762FAC6
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 17:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiKRQui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 11:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiKRQuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 11:50:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA173414
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 08:50:36 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso5562793pjc.5
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 08:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vDeF35wdLYG1P15QPsioTjibeocs7bxGmPk/YQhsj6s=;
        b=nEwUH22V3Px2AJ0nfhnVjJM1rBPM9FKR685a6v3VuuhfgW52O+PKMaplMTwyxfiFA8
         nKs9/aTXQQ4zPvNHj+eAYhJdYMektFDaVSFAFfKBnKtL8Coa1PcYz3r4Giub0PhK9aJ+
         xNxRIaTXBnko1GceMEjnoroVYL6UshpQX/9c4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDeF35wdLYG1P15QPsioTjibeocs7bxGmPk/YQhsj6s=;
        b=al0JEvphque1sqpRuG1wE72j0poaVeTIb27tRmHoqrKuJyN6MUVCLyPiRImRA6SKbL
         438/xxIAABhsP/hbCyIvDgTxtq5C1HriUsI8hGENqeAr7m3AQ2Y6y6Uc5d7D9IrB5fXG
         BUMFjzuEwgxiuBHqKHJatpHFNoasxpSfiaORAlHHLLn2DoLzIyCV09lajRNYzlN0tzdU
         Dy6i/HOrQY/Lm8gRxzsN27mQRquYtS3eQa9Bn+YTob9XJgw4l76x+2uuKm0e+Buxt5Rq
         2gBciwzFcZRwLzwC4DuRXz6eGLxG8yKD3WUjoDVrTtPRQu4KDGfeBzZ1xSIGetQBjJLW
         NUnQ==
X-Gm-Message-State: ANoB5pn0EJG/5IvbhPXvUgmrPEnRde//WJzRsyCnCAvank4Sgx+MH0ul
        GrEL86YdrCW/8kHLyP1mbbXMF0A+62xrzQ==
X-Google-Smtp-Source: AA0mqf5nc7sx9BVUy4AHRDyHuAxCzDSQw3UQYN4kbHosvvppGk9Ks17mBJFq8EiYAnsMiKkMdrSZ7A==
X-Received: by 2002:a17:90a:3e47:b0:213:1a9f:8d72 with SMTP id t7-20020a17090a3e4700b002131a9f8d72mr14862628pjm.155.1668790236086;
        Fri, 18 Nov 2022 08:50:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j15-20020a170902da8f00b00176dd41320dsm3992706plx.119.2022.11.18.08.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:50:35 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 18 Nov 2022 08:50:35 -0800
To:     Lyude Paul <lyude@redhat.com>
Cc:     David Airlie <airlied@gmail.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, stable@vger.kernel.org,
        #v5.6+@kernel, linux-kernel@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Roman Li <roman.li@amd.com>, amd-gfx@lists.freedesktop.org,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        dri-devel@lists.freedesktop.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: pre_compute_mst_dsc_configs_for_state(): Uninitialized
 variables
Message-ID: <202211180850.560AD5A74@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20221118 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Thu Nov 17 00:18:25 2022 -0500
    7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")

Coverity reported the following:

*** CID 1527373:  Uninitialized variables  (UNINIT)
drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c:1227 in pre_compute_mst_dsc_configs_for_state()
1221     		for (j = 0; j < dc_state->stream_count; j++) {
1222     			if (dc_state->streams[j]->link == stream->link)
1223     				computed_streams[j] = true;
1224     		}
1225     	}
1226
vvv     CID 1527373:  Uninitialized variables  (UNINIT)
vvv     Using uninitialized value "ret".
1227     	return ret;
1228     }
1229
1230     static int find_crtc_index_in_state_by_stream(struct drm_atomic_state *state,
1231     					      struct dc_stream_state *stream)
1232     {

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527373 ("Uninitialized variables")
Fixes: 7cce4cd628be ("drm/amdgpu/mst: Stop ignoring error codes and deadlocking")

If dc_state->stream_count is 0, "ret" is undefined. Perhaps initialize
it as -EINVAL?

Thanks for your attention!

-- 
Coverity-bot
