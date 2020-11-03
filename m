Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FAE2A3F56
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgKCIx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgKCIx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 03:53:28 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F55C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 00:53:27 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id b8so17590431wrn.0
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 00:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+IjpalJWI+KVSSWMFebRdhxN51bp7Jm+rN1WjquNubM=;
        b=P2N5AVQniKvMDUMOuAomruk07hnPtWloZR5sr5cExJ48iCm3EJJBUtCePmMskFLONg
         Sz3HTTbByKNp3kAidqJX+o5RdlGTr2Is/fcPxZkDQ4486LmifmVaPlwgJ3QJMuVk2q/9
         Fz2Kq3lYptAMx3dV3DLHGqASImsYpJzi/hplMO5Zc+qpBqernKs3En1NdxRqz+bvGyIY
         pDfZq/EiB5qykwdI/prxTtdFpSzlUmSxM8LJpI6vOj3uZSFe3fsRLzekEnC25WHKj2Bi
         9w1yjTdyPwEui2T3Rv3+5GOD9LLsqQZBa+PsUhCiJ+w6J3o2AkIJhek0+YKOXdQyPkFv
         79cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+IjpalJWI+KVSSWMFebRdhxN51bp7Jm+rN1WjquNubM=;
        b=dI4IH8hTvU7cSYHJUTpE7snFfKwCRgttC9ic//HkVJo5YKXUvcc6Dlk2dnthncNNf1
         BFeK2pVpfnaQGOjru9R6+HHAqhjnkn093D/vc/uVY0xXgyDkp+rzYic+l3V8jMW9iUzb
         b06Osl2jsue0rbvBz/jwNLsl3QDWU7SO2k/kmwBtW1mw6C3fL6GuLeHOCocOE3C30irF
         mb/ckiVLr3gvSwyBRS0GD8Sggdh2P82waxU/7+IxPK3ZaO07xXHNhu6PpkI5MKwuK2dc
         B1umlOpi2cZVvdila8M2093wHH3QvZCJkz2Yh/FkkYU/5vShX6f4UhAosVk1DmlgomF5
         yIoA==
X-Gm-Message-State: AOAM530AlA5p6dkpw9jgECYq+Sso2f14Focu0cjWrQtkpAV2l6VCVbri
        kCLmXSqsO3lwDSCoUr7gO7hLuw==
X-Google-Smtp-Source: ABdhPJylM8htsHwN3G0Kx3IEDKL6WpuD00P0+11WaDP6IUEf6ShPkz6BUK26aUoHsXRTkXOwqPBduA==
X-Received: by 2002:a05:6000:107:: with SMTP id o7mr24580674wrx.354.1604393606478;
        Tue, 03 Nov 2020 00:53:26 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id y4sm25004498wrp.74.2020.11.03.00.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 00:53:25 -0800 (PST)
Date:   Tue, 3 Nov 2020 08:53:24 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201103085324.GL4488@dell>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102183242.2031659-1-yepeilin.cs@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Nov 2020, Peilin Ye wrote:

> From: Lee Jones <lee.jones@linaro.org>
> 
> Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
> fonts") introduced the following error when building rpc_defconfig (only
> this build appears to be affected):
> 
>  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
>     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
>  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
>     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
>  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
>  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
>  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> 
> The .data section is discarded at link time.  Reinstating acorndata_8x8 as
> const ensures it is still available after linking.  Do the same for the
> other 12 built-in fonts as well, for consistency purposes.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Changes in v2:
>   - Fix commit ID to 6735b4632def in commit message (Russell King
>     <linux@armlinux.org.uk>)
>   - Add `const` back for all 13 built-in fonts (Daniel Vetter
>     <daniel.vetter@ffwll.ch>)
>   - Add a Fixes: tag
> 
>  lib/fonts/font_10x18.c     | 2 +-
>  lib/fonts/font_6x10.c      | 2 +-
>  lib/fonts/font_6x11.c      | 2 +-
>  lib/fonts/font_6x8.c       | 2 +-
>  lib/fonts/font_7x14.c      | 2 +-
>  lib/fonts/font_8x16.c      | 2 +-
>  lib/fonts/font_8x8.c       | 2 +-
>  lib/fonts/font_acorn_8x8.c | 2 +-
>  lib/fonts/font_mini_4x6.c  | 2 +-
>  lib/fonts/font_pearl_8x8.c | 2 +-
>  lib/fonts/font_sun12x22.c  | 2 +-
>  lib/fonts/font_sun8x16.c   | 2 +-
>  lib/fonts/font_ter16x32.c  | 2 +-
>  13 files changed, 13 insertions(+), 13 deletions(-)

LGTM.

Thanks for keeping my authorship.  Much appreciated.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
