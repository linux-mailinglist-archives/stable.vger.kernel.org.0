Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D97B39106A
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 08:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhEZGMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 02:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhEZGMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 02:12:50 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE96BC061756
        for <stable@vger.kernel.org>; Tue, 25 May 2021 23:11:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x188so165454pfd.7
        for <stable@vger.kernel.org>; Tue, 25 May 2021 23:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v7Dvuk2eyN1w2xr7Yg+2LylS1T7LKLL3Gf15/McPjK0=;
        b=BbaiMC6O8FoSriRn+GZTzmR11PVKHrbpDD0UHVXL4R54le+FpjEZS24y8S7xp8yo83
         anuw1lRrQpsRQGwa75V2rnCDiyBa8pseHvJk0UnNFQIYKnZ3cBhazTlCVph+zJECGBda
         FKXPbFGZz6n+DiBf+uLohxSYtUIZjMJwBZZl3KGewuJ65yggkzJRzTSKaJwQd0enoXY/
         zi3pAeBoqrndp7yq2v7PkbxquyjpDspcOGsSuzmoEolLUwjeuENy9QnnmLriuRQl/S67
         QeaKSP8FV9ifydU5ab4aAYQDdQyUofqG8Z7EHcgdQIFXqwiPWiwq1DyHfiML75Vm6/QZ
         RKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v7Dvuk2eyN1w2xr7Yg+2LylS1T7LKLL3Gf15/McPjK0=;
        b=SoOYIlIZYisq7LYSh4KQlUK5A7CmsKw2jJGvOp+F4xnU5qjyZLaQD38QvXkq9jBe6S
         agh7t4Ki2DKad3KXp1KDqBZ9bBx2VMlg1t/hVX0htfZIgQogmNCtoWnG+Fa6kvHGUUkN
         Ek0MmvriWV6Ecex3pi/SJ2Rbkpq56TiWM2a4rNjFeInkt3tSBxdJy4bZAMBmAQjF7Cdq
         cypuhiHgxkGzO/d1A0kOafNRY62g5eccO8P7VLBQMdAvMLFQYJbMaGZq5ttkp9kjh2L+
         ZZQ+Tfb5fM0gqFGGSMVKy8f8iIObsHs2QUvJbiNYJ5w/nRKiEt4gZo0ydRhMyaJ5u2fX
         4xbg==
X-Gm-Message-State: AOAM530M64aqk88/qGbkMz4LhMII6Fq4vmuuY5+YA+ryT22eVIZhi6Ub
        03mSy6aIXhNBhFg0ed9093a7
X-Google-Smtp-Source: ABdhPJx1jM2yl97MMEZd5xN+aTgJDj7YEYjLQDNHAqxhF+Cbq6756tjiRIv5wW+5X4n56XnP1f/7Gw==
X-Received: by 2002:a62:2987:0:b029:2de:b564:648d with SMTP id p129-20020a6229870000b02902deb564648dmr34373359pfp.48.1622009479146;
        Tue, 25 May 2021 23:11:19 -0700 (PDT)
Received: from work ([120.138.12.4])
        by smtp.gmail.com with ESMTPSA id a2sm14156122pfv.156.2021.05.25.23.11.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 May 2021 23:11:18 -0700 (PDT)
Date:   Wed, 26 May 2021 11:41:14 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jeffrey Hugo <quic_jhugo@quicinc.com>, Pavel Machek <pavel@denx.de>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Message-ID: <20210526061114.GB10723@work>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org>
 <20210510205650.GA17966@amd>
 <20210511061623.GA8651@thinkpad>
 <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
 <20210524041947.GB8823@work>
 <011231f6-f6be-8bf4-f4f0-5e52764101e6@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011231f6-f6be-8bf4-f4f0-5e52764101e6@quicinc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 10:23:49AM -0600, Jeffrey Hugo wrote:
> On 5/23/2021 10:19 PM, Manivannan Sadhasivam wrote:
> > On Fri, May 21, 2021 at 10:50:33AM -0700, Bhaumik Bhatt wrote:
> > > On 2021-05-10 11:17 PM, Manivannan Sadhasivam wrote:
> > > > Hi Pavel,
> > > > 
> > > > On Mon, May 10, 2021 at 10:56:50PM +0200, Pavel Machek wrote:
> > > > > Hi!
> > > > > 
> > > > > > From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > > > > 
> > > > > > commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
> > > > > > 
> > > > > > When clearing up the channel context after client drivers are
> > > > > > done using channels, the configuration is currently not being
> > > > > > reset entirely. Ensure this is done to appropriately handle
> > > > > > issues where clients unaware of the context state end up calling
> > > > > > functions which expect a context.
> > > > > 
> > > > > > +++ b/drivers/bus/mhi/core/init.c
> > > > > > @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > > > > +	u32 tmp;
> > > > > > @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > > > ...
> > > > > > +	tmp = chan_ctxt->chcfg;
> > > > > > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> > > > > > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > > > > > +	chan_ctxt->chcfg = tmp;
> > > > > > +
> > > > > > +	/* Update to all cores */
> > > > > > +	smp_wmb();
> > > > > >   }
> > > > > 
> > > > > This is really interesting code; author was careful to make sure chcfg
> > > > > is updated atomically, but C compiler is free to undo that. Plus, this
> > > > > will make all kinds of checkers angry.
> > > > > 
> > > > > Does the file need to use READ_ONCE and WRITE_ONCE?
> > > > > 
> > > > 
> > > > Thanks for looking into this.
> > > > 
> > > > I agree that the order could be mangled between chcfg read & write and
> > > > using READ_ONCE & WRITE_ONCE seems to be a good option.
> > > > 
> > > > Bhaumik, can you please submit a patch and tag stable?
> > > > 
> > > > Thanks,
> > > > Mani
> > > > 
> > > > > Best regards,
> > > > > 								Pavel
> > > > > --
> > > > > DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> > > > > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> > > 
> > > Hi Pavel/Mani,
> > > 
> > > Hemant and I went over this patch and we noticed this particular function is
> > > already being called with the channel mutex lock held. This would take care
> > > of
> > > the atomicity and we also probably don't need the smp_wmb() barrier as the
> > > mutex
> > > unlock will implicitly take care of it.
> > > 
> > 
> > okay
> > 
> > > To the point of compiler re-ordering, we would need some help to understand
> > > the
> > > purpose of READ_ONCE()/WRITE_ONCE() for these dependent statements:
> > > 
> > > > +	tmp = chan_ctxt->chcfg;
> > > > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> > > > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > > > +	chan_ctxt->chcfg = tmp;
> > > 
> > > Since RMW operation means that the chan_ctxt->chcfg is copied to a local
> > > variable (tmp) and the _same_ is being written back to chan_ctxt->chcfg, can
> > > compiler reorder these dependent statements and cause a different result?
> > > 
> > 
> > Well, I agree that there is a minimal guarantee with modern day CPUs on
> > not breaking the order of dependent memory accesses (like here tmp
> > variable is the one which gets read and written) but we want to make
> > sure that this won't break on future CPUs as well. So IMO using
> > READ_ONCE and WRITE_ONCE adds extra level of safety.
> 
> ?
> 
> I'm sorry, but this argument is non-sense to me, and so I want to understand
> more.
> 
> I've talked to our CPU designers from time to time, but cannot speak for
> other vendors.  A modern CPU can easily reorder accesses all it wants, so
> long as it does not change the end result.  This is typically identified via
> "data dependencies", where the CPU identifies that the result of a previous
> instruction is required to be known before processing the current
> instruction (or any instructions in flight in the pipeline, the instructions
> don't need to be adjacent).  These data dependencies can be "read" or
> "write".
> 
> The typical reason barriers are needed is because the CPU cannot detect
> these dependencies when we are talking about different "memory".  For
> example, a write to a register in some hardware block to program some mode,
> and then a write to another register to activate the hardware block based on
> that mode.  In this example, there is no data dependency that the CPU can
> detect, although you and I as the software writer knows there is a specific
> order to these operations.  Thus, a barrier is required.
> 
> Your argument is that we need to protect against some hypothetical future
> CPU where these data dependencies are ignored, and so the CPU reorders
> things.  Except that means that the end result is (possibly) changed,
> meaning the contract between software and hardware is no longer valid.  It
> breaks the entire memory model for the C language.
> 

Jeff, I do understand your point here and I completely agree. I just
went with the question raised by Pavel and was trying to be on the safe
side (which might not be a valid thing as you said).

Let's hear from Pavel on what exactly his concern is! Maybe I went in
the wrong direction.

Thanks for your views.

Thanks,
Mani

> In the above code snippet, you are saying this is valid for some future CPU
> to do:
> 
> tmp = chan_ctxt->chcfg;
> chan_ctxt->chcfg = tmp; //probably optimized out because this now obviously
> has no effect
> tmp &= ~CHAN_CTX_CHSTATE_MASK;
> tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> 
> That is clearly wrong (I seriously hope you agree), and while I've seen
> hardware designers do some boneheaded things to the point where I don't
> trust them a lot of the time, I have a hard time believing they would think
> that is acceptable.
> 
> That fundamentally breaks all of software to the point where the only
> recourse is to have a literal barrier between every line of code.  That
> doubles the line count of Linux and kills all performance.  Its plainly not
> tenable.
> 
> So, seriously, please explain your view in great detail because it feels
> like we are talking past each-other and not coming to common ground.  As I
> understand it, adding an explicit barrier in a patch cannot be done "just
> because" and requires a good documented reason (in a comment next to the
> barrier) for why the barrier is required.  It seems like the same level of
> scrutiny should be applied for READ_ONCE/WRITE_ONCE, but your reason for
> adding them, "using READ_ONCE and WRITE_ONCE adds extra level of safety",
> reads like the reason to use them is "just because" to me.

