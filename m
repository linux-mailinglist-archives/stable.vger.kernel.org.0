Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3294379F9C
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhEKGSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 02:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhEKGSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 02:18:40 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE9C06175F
        for <stable@vger.kernel.org>; Mon, 10 May 2021 23:17:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s22so15019743pgk.6
        for <stable@vger.kernel.org>; Mon, 10 May 2021 23:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOOECJmoTbTt+X+zG3enL4M4MkOVVAHjD7IsOUOhMHw=;
        b=SVxhIJVYyPsi0WU477NLuHvTkRc2820o9pPtL1XxAeaNeVGTp7MpuXxj3wEUSwrbai
         M0QP2D32BezQok8Wh2Y3jyj1r7++arYeYd0HSSlPluD7UUixDyARN7WwDNBvOjnIKHyg
         LS5zKannPRJ9tR4Rjsdn/niwTOEbJl+/lQWsknadGb8lTVPjK4Ohjn0+cXXEnsk4JjHU
         kRdkWytM7tQcstfoo/CxO4PVsQpGECKKiYgdWrjipxdRiUc0SbTKUUAKUvHvGEcTbmeE
         a+5K2qykZtgGaR4HeNY/80TA+xIFl7hm48VRF/moIJZdtLhz6BpLCOEr1CkMu5nmSOvm
         Fhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOOECJmoTbTt+X+zG3enL4M4MkOVVAHjD7IsOUOhMHw=;
        b=UqOK2TbE7g6dEv3zm9JhmI53Sc99og3s8AU5Ud81lxwj4AatjGcb67/gp4WdGbgXtz
         U5zPv7uYWT94mJk9QRp4R+/rKCm1PWkO+Myr6/+byMgCGBZUKuNovb0VjnrWqLmtPTqP
         AdpZY3VCP6LTnivp20gEVjFhuzIXLEp9B4emmxfNZNu27QimftT9CF58mAr1kGwS902w
         bzrLVWsxF58MRsWbscbxxwlGZX5b5QSJeP+f+kXC2gR5NdiTwYonYBHcR37WDZNPwZSU
         Qu9fNmK5uv9mavsxvMBMvyM4sP8MoskbESNeQl9RK8fce0Bq2mhDasKo696e11jXB6OM
         aftg==
X-Gm-Message-State: AOAM533kAlziGAKwYNRv5OTkU9bCu1su5vwxupXhzEX5MpvuU/K31St1
        EPSl8gpJZN6EQ1IFHIRp7a/Q
X-Google-Smtp-Source: ABdhPJzt8ycvexQ4T785y94gGLJhJRVCmx1vV+uaIyAW/gudp8rofaxMrPx1rthg/Ri1wzCgZFebXA==
X-Received: by 2002:a63:4f50:: with SMTP id p16mr28879873pgl.40.1620713854429;
        Mon, 10 May 2021 23:17:34 -0700 (PDT)
Received: from thinkpad ([2409:4072:719:5450:3d7b:2d59:40f7:9f7a])
        by smtp.gmail.com with ESMTPSA id u1sm12770129pgh.80.2021.05.10.23.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 23:17:33 -0700 (PDT)
Date:   Tue, 11 May 2021 11:47:28 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Pavel Machek <pavel@denx.de>, bbhatt@codeaurora.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Message-ID: <20210511061623.GA8651@thinkpad>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org>
 <20210510205650.GA17966@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510205650.GA17966@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Mon, May 10, 2021 at 10:56:50PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > 
> > commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
> > 
> > When clearing up the channel context after client drivers are
> > done using channels, the configuration is currently not being
> > reset entirely. Ensure this is done to appropriately handle
> > issues where clients unaware of the context state end up calling
> > functions which expect a context.
> 
> > +++ b/drivers/bus/mhi/core/init.c
> > @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > +	u32 tmp;
> > @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> ...
> > +	tmp = chan_ctxt->chcfg;
> > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > +	chan_ctxt->chcfg = tmp;
> > +
> > +	/* Update to all cores */
> > +	smp_wmb();
> >  }
> 
> This is really interesting code; author was careful to make sure chcfg
> is updated atomically, but C compiler is free to undo that. Plus, this
> will make all kinds of checkers angry.
> 
> Does the file need to use READ_ONCE and WRITE_ONCE?
> 

Thanks for looking into this.

I agree that the order could be mangled between chcfg read & write and
using READ_ONCE & WRITE_ONCE seems to be a good option.

Bhaumik, can you please submit a patch and tag stable?

Thanks,
Mani

> Best regards,
> 								Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


