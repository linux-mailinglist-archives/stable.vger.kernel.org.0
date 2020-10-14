Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A417328E5DE
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgJNSBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgJNSBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 14:01:18 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D9CC061755;
        Wed, 14 Oct 2020 11:01:18 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id l2so488521lfk.0;
        Wed, 14 Oct 2020 11:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SsYRx7SjigbOWh/ctoQI64jtrZPmlNvQiwgdzN2SLlw=;
        b=T0pdoX75rDmZOTBVg/mlNtt1lVndmXmmpxyjSJhiRfNXvV3f+6UqxGFZESZSa9fSv/
         rFcf/TSCtzDecMOpT78T5wlAn59Cm2mqrI9n8i2P4DCNZ4znDdiBo6iELgiwLHG3PZAK
         ey4tjL1iAW25FdPSlb7Bq8XUxFGzbY0BRrJi6VrlwtfuGnX92P5Cxs7gFrpOipHr0DDr
         PNWfgDgig8CWKtn9zKM03uba3UN6gN1ikF1MInA9/+lT2URhGHttgQF8uaGkjoZPvqLO
         AxQugC3TBkmSZliKJKIlj9UhybKJFdAUu6dxfYmoNW6fz2jzaOjfv7WSEPVV374iuWy7
         f7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SsYRx7SjigbOWh/ctoQI64jtrZPmlNvQiwgdzN2SLlw=;
        b=OQNmX7QVjh6Lymikig4S8BxsiMgkV43So0HQYP74ft594Gg1HXdxQFSoLtb75SGztr
         FfuKRl4zgAQnigG3mrNmWzfkhc1Rnqj+6iLtHmJx/NgXAHQegFyUYIC01KtFuiVuIjMp
         0AsPCN29Y95rWbFmzXpisaqhOVvHlFrZKI4JogkiPVbmXIqs829GUNsoX7a0toGW+l6S
         hnBTA25EA0++4vCt5KLOPkCq9j0abt1raklgMEf7v+94XXUdkXGEGbB036q1qipOhycJ
         KN5mKm9UDG3+X/lf10av89aZA0cTjIgNsTXGb0i9xA1ctRllRRcBwfUt7KpWAhpZDA2e
         I0EA==
X-Gm-Message-State: AOAM532f9SwMCnJF3L9kgtx4EecgWZYP3v5Nisoads+OBNqkjPHArUmO
        UBBrTlJ/Sg1B52QVqx733tkGv2+tiDM=
X-Google-Smtp-Source: ABdhPJwGgjR6U4Ui1Zw/rvZp0VNsyoZ2qXx30dR1L6a/hk3SQ8Lx7ASdCbIqRSgEC9WcEiHksmLI2A==
X-Received: by 2002:a19:384d:: with SMTP id d13mr152603lfj.102.1602698476682;
        Wed, 14 Oct 2020 11:01:16 -0700 (PDT)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id w26sm144455ljm.11.2020.10.14.11.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 11:01:16 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:01:14 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: DEC: Restore bootmem reservation for firmware
 working memory area
Message-ID: <20201014180114.fnz5ewt2tzkgxin4@mobilestation>
References: <alpine.LFD.2.21.2010141123010.866917@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.2010141123010.866917@eddie.linux-mips.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Maciej,

On Wed, Oct 14, 2020 at 12:10:09PM +0100, Maciej W. Rozycki wrote:
> Fix a crash on DEC platforms starting with:
> 

...

> @@ -146,6 +150,9 @@ void __init plat_mem_setup(void)
>  
>  	ioport_resource.start = ~0UL;
>  	ioport_resource.end = 0UL;
> +
> +	/* Stay away from the firmware working memory area for now. */

> +	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text));

Shouldn't that be:
+	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text) - PHYS_OFFSET);
instead?

-Sergey

>  }
>  
>  /*
> 
