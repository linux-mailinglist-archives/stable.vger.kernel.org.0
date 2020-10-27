Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C6A29AB5B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 13:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750452AbgJ0MBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 08:01:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36827 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750376AbgJ0MBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 08:01:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id x7so1602993wrl.3
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 05:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kbxs+J5sPfu6cPuS3bXcQQmO/u3bwvvK/wU+a8aqxLo=;
        b=mls1NZW71oioqb2nuOh2F/GFo3uEwBxjMt7ybKLTnhGYCRk867h6Vi1sueXbwnZ8XK
         Xx52OPkrLIMWzTT/zWUO5sM6xmW8Ho/ZFaxmE4K+hob+1Wk3DuaQE1ECnJAU2wYkc1J1
         X3dJ1keYQpjri19sucvQwOz82/bNiAft2DFrec8JMnyvRyy4Qgc7qJfrv82Wn41lVW7F
         2Cf7lRBowjgqjejzvreQtbiwR4ah2MfD4rvCaH6doOKN6OtFX2w5lF6v8qTH76CEa+d2
         haBXHCdTCnY8x0JXBCx6Fe9e+Su2BVhBndpogdL/uRxtTfOZ/aSA4dzdRbejv3rzmLjc
         NPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kbxs+J5sPfu6cPuS3bXcQQmO/u3bwvvK/wU+a8aqxLo=;
        b=cvhztLy0/UHODAVbeBZqx6kVOstEEzkvo1xRwWmchgMiUSww1BjzbfIVvcjsIA1Mik
         AM4pZ7H+kW+WuV62W99HUllIdtdIm2PakpA/b5J2d4K5A3p6zgMQP8KD0SrUz+DT58EO
         cNC2B34odxx5HCNGf+kZvjJd7f8N1MtmirsrTLANO9RvfMbtXtp+XlH5VA8bJRpngrqB
         B55rZllTp7GizG6l7T9UlkuQMYuUhs1XfqjIIySmJv31tTFhUDMcQPybOW/3eos5iSSf
         SeNMWLhBuOZjFaoWFD4hF1CyGka9+vE0CAHOBgEx46tXDN/W32BZJS9X7uSWrOpQHs5N
         Hifg==
X-Gm-Message-State: AOAM530W2XxH9Hvo1AcmwZJVBHF+9WIvOH7V3fowdFDz1qq6y437aWjf
        r/ZHAj1w4RDcXNJO0HDgp+Z68vwZSknTVQ==
X-Google-Smtp-Source: ABdhPJwQKqwdc9xILOo6w72PaDVewOm5U5rvFiS5jqZ7niiRh5OCGOr29/crlnX7Tea/DzdXL8SuBg==
X-Received: by 2002:a05:6000:1005:: with SMTP id a5mr2593352wrx.360.1603800099305;
        Tue, 27 Oct 2020 05:01:39 -0700 (PDT)
Received: from holly.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id n5sm1703378wrm.2.2020.10.27.05.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:01:37 -0700 (PDT)
Date:   Tue, 27 Oct 2020 12:01:34 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH AUTOSEL 5.4 31/80] kgdb: Make "kgdbcon" work properly
 with "kgdb_earlycon"
Message-ID: <20201027120134.iq44uw6bftumkivh@holly.lan>
References: <20201026235516.1025100-1-sashal@kernel.org>
 <20201026235516.1025100-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026235516.1025100-31-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 07:54:27PM -0400, Sasha Levin wrote:
> From: Douglas Anderson <dianders@chromium.org>
> 
> [ Upstream commit b18b099e04f450cdc77bec72acefcde7042bd1f3 ]
> 
> On my system the kernel processes the "kgdb_earlycon" parameter before
> the "kgdbcon" parameter.  When we setup "kgdb_earlycon" we'll end up
> in kgdb_register_callbacks() and "kgdb_use_con" won't have been set
> yet so we'll never get around to starting "kgdbcon".  Let's remedy
> this by detecting that the IO module was already registered when
> setting "kgdb_use_con" and registering the console then.
> 
> As part of this, to avoid pre-declaring things, move the handling of
> the "kgdbcon" further down in the file.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Link: https://lore.kernel.org/r/20200630151422.1.I4aa062751ff5e281f5116655c976dff545c09a46@changeid
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

kgdb[oc]_earlycon was a new feature introduced in v5.8 so, based on the
summary above, this fix does not obviously apply to older kernels.

However after looking closely...

I think the issue described above would also occur if kgdbdbgp (an
incomprehensible sequence consonants that translates to "present
debugger via USB EHCI debug") were used in conjunction with kgdbcon
meaning backporting does make sense.


Daniel.


> ---
>  kernel/debug/debug_core.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index 2222f3225e53d..097ab02989f92 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -96,14 +96,6 @@ int dbg_switch_cpu;
>  /* Use kdb or gdbserver mode */
>  int dbg_kdb_mode = 1;
>  
> -static int __init opt_kgdb_con(char *str)
> -{
> -	kgdb_use_con = 1;
> -	return 0;
> -}
> -
> -early_param("kgdbcon", opt_kgdb_con);
> -
>  module_param(kgdb_use_con, int, 0644);
>  module_param(kgdbreboot, int, 0644);
>  
> @@ -876,6 +868,20 @@ static struct console kgdbcons = {
>  	.index		= -1,
>  };
>  
> +static int __init opt_kgdb_con(char *str)
> +{
> +	kgdb_use_con = 1;
> +
> +	if (kgdb_io_module_registered && !kgdb_con_registered) {
> +		register_console(&kgdbcons);
> +		kgdb_con_registered = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +early_param("kgdbcon", opt_kgdb_con);
> +
>  #ifdef CONFIG_MAGIC_SYSRQ
>  static void sysrq_handle_dbg(int key)
>  {
> -- 
> 2.25.1
> 
