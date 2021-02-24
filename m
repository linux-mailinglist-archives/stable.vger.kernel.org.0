Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE668323BFE
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 13:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhBXMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhBXMlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 07:41:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3378C061574
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 04:40:44 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u14so1761017wri.3
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 04:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRhPlj1aHRVOi3gs8JuQx5ujbUeXgIsk53nwDPobfIc=;
        b=d0H+6s84LfrmhCxlKqm9iuAtf7AbWv9MNiz05h0L717TsS98FBZv0zG8WyGXGe1v3O
         pWUzo4LTRiNWdGOdO8E8SW8zqdunCe9JWRAxLh7Y5m+2ha7iEA5LXIJcwNF7ULANohTO
         cE74c57Zp1mn6ekgF0B2h66H9BPNknjcmelT1JLfot7gkdnkgBcDveQFQIyhv/YMpMt8
         dXSEGx+W/gWdeJgh1/Jme6hH+RGH8Z1NpMlDqBg8iNVs34a9CjPsby3qLhiNfbIS5P7B
         UADTB9ERyTOGXJoVPld+NTQnhcoHmKxufgh6JkK9uYT57OJZoHazMOXFa9+HF//SdJ5I
         oMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRhPlj1aHRVOi3gs8JuQx5ujbUeXgIsk53nwDPobfIc=;
        b=AQGvIroMD8RGRg4brf39lPd/S0i+hqpJC1REvQpeNqqeyruJx6p1i8UEGbbW73PJfa
         1GEhmNLDEFyH5h9WWqSVJ0p7IyAaa7DADShFq/8dtVCVElY1mPD/ZR49xUKQDrORKUOx
         Ia15zmNasDxqFJanC9ozugT1OVshbjpTqQUz1yKGhprmEt2z0ab+XkLRPN/R8QshkmqD
         RZsCfjVh/vUJCKoeQMhTTdHik3seosNXMSIwmw1hKouZweh2/r0RE7yM9EUiY/vLogmB
         oO4avJYe03h14ilPGBHiSdHdnuZgiX4sb0W6fqYcVGi+UFjUUgh541TnFFs2BSTOxO1v
         pAQQ==
X-Gm-Message-State: AOAM531unGep//kfgmEtVw3AgkAiXtYDAt/VXFdiANO9SBnRkXtMID80
        j0y3ELea3gd6XA6Ex+NMfbm2509J6kuO75+FB1P6CQ==
X-Google-Smtp-Source: ABdhPJzAf/QssqSJWTXQC9OJJ/N4aJn/AEnU3jtc2sPlav4EU3paeRaAIdayhaZXt+dVFhqKzgGMUV5f3CNGZjZh6ZY=
X-Received: by 2002:a5d:4521:: with SMTP id j1mr4780729wra.354.1614170443428;
 Wed, 24 Feb 2021 04:40:43 -0800 (PST)
MIME-Version: 1.0
References: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com> <161411675671.3338515.9688232276427844069.b4-ty@sntech.de>
In-Reply-To: <161411675671.3338515.9688232276427844069.b4-ty@sntech.de>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Wed, 24 Feb 2021 12:40:32 +0000
Message-ID: <CAPj87rPpw8wjCW8d51KKJvbZt3MOERnt-=hh66qCBXYuOMVk+A@mail.gmail.com>
Subject: Re: [PATCH] drm/rockchip: Require the YTR modifier for AFBC
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniels@collabora.com>,
        Sandy Huang <hjc@rock-chips.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-rockchip <linux-rockchip@lists.infradead.org>,
        David Airlie <airlied@linux.ie>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Feb 2021 at 21:49, Heiko Stuebner <heiko@sntech.de> wrote:
> On Tue, 11 Aug 2020 16:26:31 -0400, Alyssa Rosenzweig wrote:
> > The AFBC decoder used in the Rockchip VOP assumes the use of the
> > YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
> > buffers, which covers the RGBA8 and RGB565 formats supported in
> > vop_convert_afbc_format. Use of YTR is signaled with the
> > AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
> > such, a producer would have to generate buffers that do not use YTR,
> > which the VOP would erroneously decode as YTR, leading to severe visual
> > corruption.
>
> Applied, thanks!
>
> [1/1] drm/rockchip: Require the YTR modifier for AFBC
>       commit: 0de764474e6e0a74bd75715fed227d82dcda054c

Thanks Heiko!
