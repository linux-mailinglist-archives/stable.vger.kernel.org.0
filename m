Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD5F32157F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBVLzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhBVLzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 06:55:09 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D60C061786
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 03:54:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p3so3129014wmc.2
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 03:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=U+HxSePe4reaFx3rEe1zCpmNUspu1nuRn9RrICOTQAk=;
        b=Jhfr/kRrpqIW0E+fGvODAZvYsZJDYLFuvl+C1Wwbv1mX+TK7Xao4GbM+V8Fm9fh+7y
         U/YAXRP7XGiUyOk9tF8m1JIJF0RKqVOrwrvKcQdWFO+zrifE0bU3gjhVOTXCEOawbWx+
         UHsmhpMhNbMCcpwZrXb9iTEHX63fWF3nlpv4FnWsckQmflV47qdqbAov1yALVdrNBIsJ
         kzKsjq7MNM0C2LR7PhInJznj0addrPWW1Fyk+KN4kEOCdmJJ5RPNIFYiQOZjyhwkSaxd
         BMP64Rp2lm14jBptprlzl6bsWcWsD6T0n6+C2zVdaO/CAXbSu+3qUjjDMXHWTQ9h2oLu
         gILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=U+HxSePe4reaFx3rEe1zCpmNUspu1nuRn9RrICOTQAk=;
        b=EdRyXncdhsOXRID2U6JceANPg4nnuAJ1tD0T7TjWFa5YFZt0VRXg9+YwpxdbVgxwzP
         lU0BgIevD7g6ydVDy0OTn4OCu8nC7xFPpAOcQqNCUhe5o3H8kQL2vnnyaunTcNjE2h3G
         yRH/hXYPoY0Z7ZyZPacoE69Aay61y+qWDK5dVzb2zi0UsnlMSVCAQ/5W78N/kjZd/Acm
         ssZaigp0WrBAUtY0WtoOkpHPOFVVPY0bHRZJSmRtXGYzvHPJVq49BSGAeFw+WidKQ2zS
         Fc9OVBrEnJF+OQvT/WE/cJn3Om9Ex6Xvn2oUzIHaE0CSjIHmS3GW4on7FCnsI9WcopoA
         pHsQ==
X-Gm-Message-State: AOAM532d3vldyOI33mu9dtG5/G9M86v7RPGZFiKOGfhjTPaPg+EGTQ+m
        mqf+p33AansKzZeHuJHS08K+iopGTtB5QQ==
X-Google-Smtp-Source: ABdhPJzF+r+O0viVr9hiL7DPwCymq4lroZYNLfbGahHdKAGqoCj1tIPwVPnJYddIskibaa2EnR+EAg==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr19538984wmc.152.1613994867101;
        Mon, 22 Feb 2021 03:54:27 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id y62sm30191077wmy.9.2021.02.22.03.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:54:26 -0800 (PST)
Date:   Mon, 22 Feb 2021 11:54:24 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, tglx@linutronix.de
Subject: Re: [PATCH 4.9.257 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <20210222115424.GF376568@dell>
References: <20210222110542.3531596-1-zhengyejian1@huawei.com>
 <20210222110542.3531596-2-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210222110542.3531596-2-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021, Zheng Yejian wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> 
> Both Geert and DaveJ reported that the recent futex commit:
> 
>   c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> 
> introduced a problem with setting OWNER_DEAD. We set the bit on an
> uninitialized variable and then entirely optimize it away as a
> dead-store.
> 
> Move the setting of the bit to where it is more useful.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/futex.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
