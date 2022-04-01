Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DBF4EFBAB
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 22:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbiDAUe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 16:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbiDAUez (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 16:34:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61A426E007
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 13:33:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so4273360wms.2
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 13:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=astier-eu.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Lla8R4PXg/dU464Bg728GYNjfxsjGcIx+VuygdwbQXY=;
        b=vt+4iAtzb5kaqgHwNJSBXkqCXXX8qY86z7861l3d9snz3lA6qk0BSWFXeX1pMoznj5
         NDpcKra/UyhUxCZkPF6SAQNqaMb6eN3dPmV2Q7vk/d/R/DlSo4FwP9HZFWRIKB09T7RG
         qhywYWTId1dH1WzC1LOBchmCNDimYOswJu+WAfcCGnqVI03Jw4lXSg1yOdriyD5rRAoe
         MxtgsbGhMpWCTlsJ79zJaCsRN2OL2UU9yvVxHqkIUgemSORHFGy9qIkf/r+f3snHAabg
         vSL6KMkAVAVwrWQ/4Td1RZ1x0dWsEWUJ9tqCmASLqf7zMXZRzI+bk3BXEmYhyUacaBsy
         K2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Lla8R4PXg/dU464Bg728GYNjfxsjGcIx+VuygdwbQXY=;
        b=x9l4RMOrMpc8gpg793poHdxUIJ7dXrsWE9OdQWgEXnNZCMmcGCjPuno3eoE2Emeosw
         Ne5EFCP+RpMaJh5jOzfrafxTVfGlVxFD1ucEzE7Cj++ZEXaYtsROhUb65605tWWkxmzr
         yNjM/g0zT9CtcKDSHMnaBJXimqPA4hEiXrtSpPe1Gvr5L+7NNiiBNimABYpjX4ob7R3R
         aRE8wWffUjetWz6Lld1YnTCOotFFmyAXNO3VODBrjYXuKak/7+mQCV0t7ngk3SkyzpQ6
         xfJfYY+Y9OCTB1cJVicyEbMwZgfpPh4W50HDIJO7FVA1OG12YD54t06D03qZ3CKEWINo
         aCZQ==
X-Gm-Message-State: AOAM532vzm4F0B9yeE1CaiIozzDDR00KYTuNPZqcgKacTNk3t4kSR4AQ
        CDsLQ8GXWvj4moz48B+jT08GHQ==
X-Google-Smtp-Source: ABdhPJyAU0HMUKElzMdYCjku6ZPYDX3BM2AIUFITC+RuOtWy0PB9zLwyqmupKopNv/itYzW4ZoajKA==
X-Received: by 2002:a05:600c:3547:b0:38c:92a6:5a17 with SMTP id i7-20020a05600c354700b0038c92a65a17mr10270509wmq.20.1648845184241;
        Fri, 01 Apr 2022 13:33:04 -0700 (PDT)
Received: from bilrost ([2a01:e0a:28f:75b0:dea6:32ff:fe0d:99f9])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c4f5400b0038b5162260csm3770813wmq.23.2022.04.01.13.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:33:03 -0700 (PDT)
Date:   Fri, 1 Apr 2022 22:33:02 +0200
From:   Anisse Astier <anisse@astier.eu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.17 001/149] drm: Add orientation quirk for GPD
 Win Max
Message-ID: <YkdhftH7tyPU8Gqt@bilrost>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Le Fri, Apr 01, 2022 at 10:23:08AM -0400, Sasha Levin a écrit :
> From: Anisse Astier <anisse@astier.eu>
> 
> [ Upstream commit 0b464ca3e0dd3cec65f28bc6d396d82f19080f69 ]
> 
> Panel is 800x1280, but mounted on a laptop form factor, sideways.
> 
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20211229222200.53128-3-anisse@astier.eu
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't think this patch will be very useful, because it won't fix the
device's display orientation without the previous patch it came with,
titled "drm/i915/opregion: add support for mailbox #5 EDID"
(e35d8762b04f89f9f5a188d0c440d3a2c1d010ed); while I'd like both to be
added, I'd prefer if we waited a few more weeks to make sure it does not
cause regressions.

My advice is to drop this patch from all stable kernels for now.

Regards,

Anisse


