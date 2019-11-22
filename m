Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18A7107918
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 20:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKVT4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 14:56:07 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45115 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVT4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 14:56:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id m71so3455777pjb.12;
        Fri, 22 Nov 2019 11:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n9AhKfMQ3HPLRIiKyptfIRvZgizFjbDOqmEqa663Z58=;
        b=BVX0TArGcPO3YDBZ1LafMwPAR15j+hrvoSxKdby/vlgGLtkjC+A7JhWvh5o9gSNiTE
         Bt4OVcSCoo5/+oRr6iuLxk8/cKicdPKysDTj5G3skdujO0R5SJxaZCsYvO55R/Bmn1AP
         A8E+xxQUAFB0grXPt84HySzbvuCCZ+6qTT77L1PpF4eMfp2G1ufIWI1A/1E/z71kUSms
         lRKlOJbrtUwWrPIE9H4rE5/aVvz7vTto6GpI7UgK50/oFXJGxuL2tgDPdZLV4fnkl+/b
         tEJrlhihcOH8vHj781v8bRX1t2vZwO7URsESYDu85covo+QFOKt1vyTj6ccEufjTpYLI
         B7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n9AhKfMQ3HPLRIiKyptfIRvZgizFjbDOqmEqa663Z58=;
        b=bzCXHziS7BzuZzMbZp7/d0VlgKsk5cjBkeS0tnOcU5oTuZ1o5Zl2LoiKWhZftsdzNb
         zktUM59FaCqvyoUqCUzdasvFZdDP+vWy0umj979IrlRVgQWYEcVM4M8ceT/MVNEBWLR4
         8j7g5GAxG90ls+qYS2sVRxkbVnWa0ehpNvXcjVJu3wQr6pL0GNg5DHUf6TcFnwcQCLy9
         xfyr1p7VQ54HMZNZ8DCQ8Vpk1U9gySWttM2yncAk/9D059QXGsUC+sdGAbNJEcd7EYbm
         d+GgqwBLpPqTyxYuuRZjOWxSogSTlEztI7Ex1dbWq3mb1cuzMF4MWf0z6pjbcdNnLCVB
         UE/w==
X-Gm-Message-State: APjAAAW1icZXNv6SLbepA+9CpqgNd02CJvOcJ6NyRfEjUlyJjnW2rwXZ
        QDPHi7kTYhDDx1EhWwdYdf0=
X-Google-Smtp-Source: APXvYqzRjYD+J/qSc85kWoXSUcfa5FtcVRfRnO8zjPR2ARo5UoSYf6mYRehLceXYgvAUaRHsU+rK9Q==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr21479330pjq.46.1574452565243;
        Fri, 22 Nov 2019 11:56:05 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id r33sm3947913pjb.5.2019.11.22.11.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 11:56:04 -0800 (PST)
Date:   Fri, 22 Nov 2019 11:56:02 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lyude Paul <lyude@redhat.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 21/21] Input: synaptics - enable RMI mode
 for X1 Extreme 2nd Generation
Message-ID: <20191122195602.GC248138@dtor-ws>
References: <20191122194931.24732-1-sashal@kernel.org>
 <20191122194931.24732-21-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122194931.24732-21-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 02:49:31PM -0500, Sasha Levin wrote:
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
> index 7db53eab70121..1962db0431dea 100644
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
