Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A7910A0CC
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfKZOzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 09:55:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36875 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfKZOzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 09:55:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id g7so2124523wrw.4
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 06:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=E9Iw0yWrvAGuBf0vrdUF8hB1LHd9Wo63w17xqbhUTCY=;
        b=lyht2B11vwm5kHnWD04qo041Ui0Eul+0eotWEXI60gaPxztj/xAtX+AI3TnvlbR0iu
         ENypGulE045ID05II38/fAwBgx/wAc35xGn/yFICLojkFOGU7nfD6qK4RXJ5CGkiQ7KM
         g4eZhb/naADHuN0G8ldNnIBw2hJTxangeaG8ZWzbNO85MLMVwWbuvWKeoIb2slALz5Kk
         Fcpw6Bwx0WxNwARyym8R9FKv2HC/0kn8SzU5HwPzhDIDxj4AmXst5h97HSZTpjtq3P0J
         uvNer4PsaDlGta+ThpAtgBG3mO+oHfwS+TQAeZQaZEzXqJgmkA4E6rljhGCe1gvA71aE
         rMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=E9Iw0yWrvAGuBf0vrdUF8hB1LHd9Wo63w17xqbhUTCY=;
        b=QEQ0NqMBT+WgAMNb/Z/70Uxkgsbb1FJdQ0B1V0R8h3qAWjf8sOyxxmoUm29kh46RG9
         2QUcEjpXvyqsGa7+E7ym9H2UU4RGRH8FbQeYTK4XOFenmeu9SCpHVuv6gzTclKLReJYC
         jaNk1xnWNEcygGXB5KKNx9kwEmSoJCbCtfscvNMBg9CLlkMxGZkWVQMhmMykdTGqgfKd
         psIdq8te6EcV3x55dbUuCvf9ITfkx8od86AqOVQqH/c7YXljtDYlG/I2Onh12ulTaImv
         zAK9PJ081J709a6ayIiunX8U9saAP4GhJgLGXyxJcSF/U2RwSfpNT99v0mWMXRUalIfg
         H4xw==
X-Gm-Message-State: APjAAAX3xbaM3PS0Hrn0LGagfPc+CSNPaYCWSW++dZ0ev3xWYu196YCL
        BCeHusC+uvNFqn+RkdagtHpmwF3402c=
X-Google-Smtp-Source: APXvYqxt0OHayV165wpIwr9PCV5sI0PI0olZdWlPJwSN1fywvqlBf4l0M2l5HceEA1FaUEmO3Fuikg==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr17327474wre.58.1574780144725;
        Tue, 26 Nov 2019 06:55:44 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id b3sm3241993wmj.44.2019.11.26.06.55.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 06:55:44 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:55:30 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 1/5] ARM: 8904/1: skip nomap memblocks while finding
 the lowmem/highmem boundary
Message-ID: <20191126145530.GJ3296@dell>
References: <20191126134830.12747-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126134830.12747-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, guys, copy/paste error.

These 5 patches are headed for 4.14 NOT 4.19.

On Tue, 26 Nov 2019, Lee Jones wrote:

> From: Chester Lin <clin@suse.com>
> 
> [ Upstream commit 59f200ef45852141dd45847563bf8e4c11a48f3f ]
> 
> adjust_lowmem_bounds() checks every memblocks in order to find the boundary
> between lowmem and highmem. However some memblocks could be marked as NOMAP
> so they are not used by kernel, which should be skipped while calculating
> the boundary.
> 
> Signed-off-by: Chester Lin <clin@suse.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 70e560cf8ca0..d8cbe772f690 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1195,6 +1195,9 @@ void __init adjust_lowmem_bounds(void)
>  		phys_addr_t block_start = reg->base;
>  		phys_addr_t block_end = reg->base + reg->size;
>  
> +		if (memblock_is_nomap(reg))
> +			continue;
> +
>  		if (reg->base < vmalloc_limit) {
>  			if (block_end > lowmem_limit)
>  				/*

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
