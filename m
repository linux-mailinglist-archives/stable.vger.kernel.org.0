Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCF3520051
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiEIOxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiEIOxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:53:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E5C24DC09
        for <stable@vger.kernel.org>; Mon,  9 May 2022 07:49:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 129so8525528wmz.0
        for <stable@vger.kernel.org>; Mon, 09 May 2022 07:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gHnu2ZpFdEZeGgsV6LJ9J3EQsFicj2yfJJz6IRs36rs=;
        b=pkQRNedKDexjZJy42ca9CtWRqZXInBcSREOe0KFnptHiO8/ZCGlHWLuHNQ+V8hThMX
         LwMsqcFmZFjKC/3VRY0oEZbrjzyxkZdkEVXreHkdbk0Y5bJRKzZXFTyyPhIPovvPQ+Wp
         mfFuBWZaEPlm9OiWJ+uqtqyxJbbdtPgCOHOubxP+B5N4z/gVz2SwGsgI7e3o3aWgoqJJ
         OORb/QjwcNC5ozYOQBJLAUCj9d15FJJywFXD9oHCtIAYxYlctvSuHCb6iEK+GbMRNUIz
         0BcL0eTQ8DLWG+jf8RAHTYzm9fGOBYD+8v6B5Xwd20T6rGCPosDVAkFO4cMJeTVMQ6Ky
         Ww9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gHnu2ZpFdEZeGgsV6LJ9J3EQsFicj2yfJJz6IRs36rs=;
        b=fkzy/f3odiRYKLcQhW7jQ0sLtRlMlUQFNPvLh0mV/jd89Oa2f9B0BgT1TO+qzUQ9yD
         WR/w0O3frrJ1RhJV5oQrqMfoVDaoIVqSlyT4CQvWcSZ8VJr4akvDVPTGQZCqIEDO1Zfl
         EhBc9TerWsSUSO1nC/1mkhLsM9BjAJkvBmSPUCurlPCuD7FWMsUK7o7EEhi2z8toYT82
         a5c6DuQc19RfC1o56ge18nKqfbqBrvetqlMP0rRjRXy/BgSiYJAsFYM6tW7R28rZsjlW
         xH9CvODpPDH7cbor2HPBYtzQXbBlxxTOwu8L3y2E9KEGPvceXpwG5nzcn5obqZUrClqw
         UPLQ==
X-Gm-Message-State: AOAM530ql/DnPrysqXyN0GqDoHM7/3Hip/HBXAqXzkvohGU4iFBgdV7n
        mBawbHpHKHpLKea6IuM6dCveGw==
X-Google-Smtp-Source: ABdhPJyjK6WAR/VZSkjZz9iYJrdF14G2v8OVGBT53jxFu2JrVWFt4FQUhcXmeHENem73T6w1xU41Pg==
X-Received: by 2002:a1c:3b54:0:b0:394:3910:3cb9 with SMTP id i81-20020a1c3b54000000b0039439103cb9mr22649799wma.50.1652107745868;
        Mon, 09 May 2022 07:49:05 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id n13-20020a056000170d00b0020c5253d911sm11724160wrc.93.2022.05.09.07.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 07:49:05 -0700 (PDT)
Date:   Mon, 9 May 2022 15:49:03 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5.10 1/1] drm/amdgpu: Ensure the AMDGPU file descriptor
 is legitimate
Message-ID: <Ynkp3+eBhhilI8vK@google.com>
References: <20220412152057.1170235-1-lee.jones@linaro.org>
 <Ylf5zmP88Lw0md47@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ylf5zmP88Lw0md47@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022, Greg KH wrote:

> On Tue, Apr 12, 2022 at 04:20:57PM +0100, Lee Jones wrote:
> > [ Upstream commit b40a6ab2cf9213923bf8e821ce7fa7f6a0a26990 ]
> > 
> > This is a partial cherry-pick of the above upstream commit.
> > 
> > It ensures the file descriptor passed in by userspace is a valid one.
> > 
> > Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > Cc: "Christian König" <christian.koenig@amd.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: amd-gfx@lists.freedesktop.org
> > Cc: dri-devel@lists.freedesktop.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Now queued up, thanks.

Could you also back-port this into v5.4 please?

FYI, in the v5.10.y tree, it's now called:

  f0c31f192f38c drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
