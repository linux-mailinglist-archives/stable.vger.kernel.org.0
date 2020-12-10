Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A692D53DB
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 07:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgLJGjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 01:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbgLJGjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 01:39:39 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE060C0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 22:38:58 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id n1so573527pge.8
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 22:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i+dpSw3FBRqLmFGbFqmWpXEM8Y3T5sBUqPayoWbt+b4=;
        b=OZyhlwaceWOtSH2g1qyQUQ4TeEosAZqsQhNeLaN9FQkyDRyVkUwfDHyTuFvlC6sjGx
         EMndb9RIw+az8ooy3JLvKLXvZeHv2UtlFJ/wqptlO5i/I03FadmjmzysmW1MzvpIRgks
         +IVDLbn++zYSj1kt/uFBjbStYYLQB+n5hd/9eh1ODKD1rCX9ueiOjeE/nhLo6TV+g/gV
         bTksz07+5JNKnAOSv1gPks79hbNZFeAK/inpjYRViIplgIVTY76cjRVJlGoEZOfTdlQc
         GUhc1c8csAv/hKW0q2bZlgjiGwv5xn4jVdKt/94RGEXH+GgQO3GKCSRkoLqG+vLSfGfL
         OD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i+dpSw3FBRqLmFGbFqmWpXEM8Y3T5sBUqPayoWbt+b4=;
        b=G+2pqkwnIyImvP4tM+f5NO4CsXfJ52ShXT6S1Y4/T2dFmpt1t16GJ4LU8r1OGp8X7e
         hQl1DDUComjSemcp7mKQbACaQA616+9Yspqyd12p/Yp2m4ySPDQKh6pV0n2k98g5Me3G
         +NvHt6KwbwZUe0Mk9X16FA8RGjeFPuaZrH0KOEQ5ZaKYmZy8lh1rVdNC2RccI+oHEC/0
         72qWJxpGXxotrapbN2Jcl0UepL6Cvv5A2HmfYpBWUEWmr+DdG3eNemF8qiy1rR0JzTpv
         g+2GAg4aAi1+5V0BhVC8Q1JAGhubJOpXP5Kj0LjGZEL6DQUMJT44rRXcEb4zw+2gDz1M
         UNHw==
X-Gm-Message-State: AOAM533oOzNEiOYi6n6h7oQYm85jGRz8ukOK+Cig0oppgRK9rexvrEZE
        Tse2py0bifKXuAY+rofJbI8=
X-Google-Smtp-Source: ABdhPJwehw2EfT8pDJ7pIHs2pZiRZ83dLkZ3PJinqVa+tkob4KTIadfa4WtdcLZ5sRlt4iUC+pjlWA==
X-Received: by 2002:a62:84ca:0:b029:19e:6f95:11b1 with SMTP id k193-20020a6284ca0000b029019e6f9511b1mr5548885pfd.68.1607582338266;
        Wed, 09 Dec 2020 22:38:58 -0800 (PST)
Received: from google.com ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id kb12sm4364034pjb.2.2020.12.09.22.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 22:38:56 -0800 (PST)
Date:   Wed, 9 Dec 2020 22:38:54 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     kernel-team@lists.ubuntu.com, stable@vger.kernel.org
Subject: Re: [X/B/F/G/H/Unstable][SRU][PATCH 1/1] Input: i8042 - add
 ByteSpeed touchpad to noloop table
Message-ID: <X9HCfmaRyU3DBTCM@google.com>
References: <20201210061415.35591-1-po-hsu.lin@canonical.com>
 <20201210061415.35591-2-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210061415.35591-2-po-hsu.lin@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Po-Hsu,

On Thu, Dec 10, 2020 at 02:14:15PM +0800, Po-Hsu Lin wrote:
> BugLink: https://bugs.launchpad.net/bugs/1906128
> 
> It looks like the C15B laptop got another vendor: ByteSpeed LLC.
> 
> Avoid AUX loopback on this touchpad as well, thus input subsystem will
> be able to recognize a Synaptics touchpad in the AUX port.
> 
> BugLink: https://bugs.launchpad.net/bugs/1906128
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Link: https://lore.kernel.org/r/20201201054723.5939-1-po-hsu.lin@canonical.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> (cherry picked from commit a48491c65b513e5cdc3e7a886a4db915f848a5f5)
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Why are you forwarding this again?

> ---
>  drivers/input/serio/i8042-x86ia64io.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 82ff446..1f45010 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -223,6 +223,10 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
>  		},
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
> +		},
>  	},
>  	{ }
>  };
> -- 
> 2.7.4
> 

Thanks.

-- 
Dmitry
