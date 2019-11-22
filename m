Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E539D10790C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfKVTzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:55:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36552 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfKVTzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 14:55:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so3978898pfd.3;
        Fri, 22 Nov 2019 11:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+KAr/Xowf3i8pr8EPJk1gltx6EMW0QxKeOvIBPu6+rc=;
        b=o6OrX4195DPB62OgCWIxrp/crv6S+mPssF+6KFRAKIK3FzUZ92RaCmwElycCewNvMs
         SjwQbcGj73Rmxtjrqa/NohiSE+NUTaG+FYg6Xx8TsHjE7PbqBBEnRK+Cv3upbm8lDCo9
         nI8CM+ALPaFZX5Lj1sr09IbAvl6tPC5faCoakL4MKsNSHFmv1x7j932famFFWMJUdIz5
         h3Zfoe1sano4+DFroa6CAjG46rZnrNXlOPssmP8zoznYTqIqCP77HhFA+ayTKkRjrrLD
         RbZZ5JCRxjRWl+WEXXwokcigMyv1UEhyn6DFPBzraHjVST1NXcOo+YFjKy50EWVb71PZ
         vluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+KAr/Xowf3i8pr8EPJk1gltx6EMW0QxKeOvIBPu6+rc=;
        b=Zena3V1EB9OCiYga5zSOFgD41c2TyXAasJMPyscEKxl3H+yN2mDB/7EQ5zrj/9jfji
         uWhoUBidSWaYIDLWQzPrpuIIvAr8PtOgNnmkchzKzAjO8d+Wf6/tA2stshiEbaO/WZMU
         CEMXLfe6+mXMfDDKEgw04gkP5BY+fYi/CpzU7m9CKzwIcoNi/kZkT0Ap+HnaiZM9Ht77
         eqvT1zmogfS0AjmBJsr+83hzfqn5azcd7QNhicxokpAraspVo1I9Uzs4/d1Q+3rtAyDF
         WR2iY0CUiUtomXJ/KH/q0tJHSGnPPn3pOlJPtq6xFZYYW3zPnVThUQulMvR1DyAfTC7o
         wW7g==
X-Gm-Message-State: APjAAAUAuKt6fL6PkANM7h2s84WF/q3JWcH1XIffdb6TPNxA4WxHN9rw
        6dAXFpHVI5+UJTlu4F8S2jY=
X-Google-Smtp-Source: APXvYqxxriw7hLwKt6j9owi/q/reR4XwlxChZc3XU54nlr0I96qcCgWK60BwuCtm+tYfUUZtsmnTeA==
X-Received: by 2002:a63:4f64:: with SMTP id p36mr18426689pgl.271.1574452535020;
        Fri, 22 Nov 2019 11:55:35 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id t1sm8552138pfq.156.2019.11.22.11.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 11:55:34 -0800 (PST)
Date:   Fri, 22 Nov 2019 11:55:32 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lyude Paul <lyude@redhat.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 24/25] Input: synaptics - enable RMI mode
 for X1 Extreme 2nd Generation
Message-ID: <20191122195532.GB248138@dtor-ws>
References: <20191122194859.24508-1-sashal@kernel.org>
 <20191122194859.24508-24-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122194859.24508-24-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Fri, Nov 22, 2019 at 02:48:57PM -0500, Sasha Levin wrote:
> From: Lyude Paul <lyude@redhat.com>
> 
> [ Upstream commit 768ea88bcb235ac3a92754bf82afcd3f12200bcc ]
> 
> Just got one of these for debugging some unrelated issues, and noticed
> that Lenovo seems to have gone back to using RMI4 over smbus with
> Synaptics touchpads on some of their new systems, particularly this one.
> So, let's enable RMI mode for the X1 Extreme 2nd Generation.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Link: https://lore.kernel.org/r/20191115221814.31903-1-lyude@redhat.com
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This will be reverted, do not pick up for stable.

> ---
>  drivers/input/mouse/synaptics.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 06cebde2422ea..afdb9947d8af9 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -180,6 +180,7 @@ static const char * const smbus_pnp_ids[] = {
>  	"LEN0096", /* X280 */
>  	"LEN0097", /* X280 -> ALPS trackpoint */
>  	"LEN009b", /* T580 */
> +	"LEN0402", /* X1 Extreme 2nd Generation */
>  	"LEN200f", /* T450s */
>  	"LEN2054", /* E480 */
>  	"LEN2055", /* E580 */
> -- 
> 2.20.1
> 

Thanks.

-- 
Dmitry
