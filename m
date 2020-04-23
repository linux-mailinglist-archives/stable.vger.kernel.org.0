Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C426F1B5AEA
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgDWL6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727014AbgDWL6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 07:58:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DECC035494
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 04:58:09 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so6502245wrb.8
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 04:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qjt4lo1DyF/P3dbcHFRCmlaHRF4N1/QykJyZuwXQbVU=;
        b=n3kqh/VBYEX9PHGPjGiahw4Q968NuGzOmRsTXirIlgmNhNKAVHaBEZbCcIcg7i33mj
         NzEHr9Vxg6Pyoh2FG/ggdlUmVbyIsX1pPcIUsBmbrcPkrcRoHYvOtDcnOCOI0CsnqAxR
         hBgcBzRzc9n9Ls0udxxBtrW5SJcE/a6wOMz2Ljjrfzz1Y7ZUCgxpl4P4uBpQ5A2GcIxb
         Nvl6edqmUs6ViJZUArf6za1Zho6k9BqGgW+NN7edlnxeFX7xd4ByVbxOIkTlYbYNf5Ux
         CGa+vwge0YhUHqfqJR7t4Q9V0Ays5hKAJ4db0uLtHRHvw9bftGM41dJW5Xu3WZOAm6KS
         cVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qjt4lo1DyF/P3dbcHFRCmlaHRF4N1/QykJyZuwXQbVU=;
        b=ViRltxIhf2Z8183gQpRh8K0c+Vm2hp5+FyvS5opgrXH8HSVIt8b31gt1jxdBRSPr8l
         XTSfO3+vc5HrfRwsmQa2Z/ShmhR5LO6SQnzJdgQymLiGu+YEpO0BTW7Ri192YnchknV1
         DA0qc+meAyUyAO1vnx6kayd9oLm+bj5n1oBHBBZw211h4V/xgy8K8wDc9Rr7qn4GlKaW
         zm8QO7+vVYRhA2JeF8KxedrY5TGBIFMMnyfUTggmzKZqcuyzHzgIOAVyVJ9/McAvMcp7
         085jyw6Shuqc0VGCFJcQJ2ULwr7R0kPxSPWRaBNQOmSyAtmiuc4tkVW2njUjT1RarB5+
         qRcw==
X-Gm-Message-State: AGi0PuZ2R9J2OHtjyvp42l2eXiqHZC2xPqGkJem/flS3QvX7zz8hfA8u
        Pg4l9g/207osvHXJWDf7qhvHob8upcs=
X-Google-Smtp-Source: APiQypJGXZ2EiLtQGonbw2+hcJDFPXp38off0XnODExNgezARl0GaqE6K5o1LLNvnUfL83is+kJiCw==
X-Received: by 2002:adf:f444:: with SMTP id f4mr4366457wrp.376.1587643087803;
        Thu, 23 Apr 2020 04:58:07 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id m1sm3274906wro.64.2020.04.23.04.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 04:58:07 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:58:05 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Message-ID: <20200423115805.GH3612@dell>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200422111957.569589-5-lee.jones@linaro.org>
 <20200422123154.GA3144508@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200422123154.GA3144508@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Apr 2020, Greg Kroah-Hartman wrote:

> On Wed, Apr 22, 2020 at 12:19:40PM +0100, Lee Jones wrote:
> > From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> > 
> > [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> > 
> > Initially we bumped into problem with 32-bit aligned atomic64_t
> > on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> > mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> > If allocation is done by plain kmalloc() obtained buffer will be
> > ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> > devm_kmalloc() should have any other alignment?
> > 
> > This way we at least get the same behavior for both types of
> > allocation.
> > 
> > [1] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004009.html
> > [2] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004036.html
> > 
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: <stable@vger.kernel.org> # 4.8+
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/base/devres.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> 
> Sony ships this thing?  Wow...  Ok, I'll take it (for the next round),
> but supposidly it only affected ARC systems, which I'm pretty sure are
> not Sony phones :)

Seemingly:

  https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.7.1.r1/drivers/base/devres.c#L28

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
