Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD138E01F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 06:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhEXEVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 00:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhEXEVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 00:21:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3FEC061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 21:19:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v14so16434122pgi.6
        for <stable@vger.kernel.org>; Sun, 23 May 2021 21:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VhoBjgCWhQplTyNf0S4uLwlUehIGjiGoUzRkPKtR/6Q=;
        b=MAoo5fAyF/GrLJ5OKTCFEVM43K37jtORBRosU/DhG4BD97JnhvllLnBbcmCGM8GD2Z
         BYlBD+I3A0NxV9yjiKVNB99kXIJ30QPH+oth1+uqP83cSNZoKCODBmJpyy9vXCHdY/ZZ
         7PnrxHgWr2z6nOmgfy1L6OaFgGqt0j+te4tVLQGwVtB8tWaJIZn5H3QSXVMRP4A4nAS2
         J7Mfd6YcCeg/Vuu36jihfSk8VrKUZ6+Per+bZiV58ZV39sRYaI3f4aJj4RZACTMH/zRk
         Z9z2TuhNh3KqjRMjyfmXenQSS+BPWfLiDtXxNyr5whc433OnF4/Vh/W+YU0yFECekZZI
         UiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VhoBjgCWhQplTyNf0S4uLwlUehIGjiGoUzRkPKtR/6Q=;
        b=Cz4S3x8aGf4BZxi7kceW//Am3lh0s1mml4tuVE6dSgxw8K6mv6DTL/yk8M8RDt3jgk
         TU7Hue4pKfHzkQjmdHTZVlP1LYTUW2qCpa41So5zzvq2yBc52kDSx/4DTBTeH9wgGz/7
         2V3701flaHhfvyql0WBFb1v1fLJoveJdMSqLl1EUUTQ/hLMcvv2xZBkS4uL/susoIQR9
         adiCOY3RRPVyL3gJUARrgrLax0pYgL3GfgJRHqy9cRJu9Gf9Wd68OfKLkFXOgv6+UF1/
         rtWaYKZlMGSPoLv3rapIqZa2g/RwmLWFx9CjnI0tbpdmrRBun13dk3Aaiq9yZKeNPWeP
         HC8g==
X-Gm-Message-State: AOAM533pQzxTMzNzm9sGxpm1N4sGj7R1g6M7n9+ZLaoe4TzVsPrW26YX
        6exh+mHjROh8hUNvw2Z1t0hg
X-Google-Smtp-Source: ABdhPJwILTR2X17ap7/axh/auKRgCdNmMBO732sxdK5mi7SP44BhLlZ3cI+YJESNg1aqdkG73cCtww==
X-Received: by 2002:a63:585:: with SMTP id 127mr11381216pgf.322.1621829992100;
        Sun, 23 May 2021 21:19:52 -0700 (PDT)
Received: from work ([120.138.12.48])
        by smtp.gmail.com with ESMTPSA id v12sm10164574pgi.44.2021.05.23.21.19.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 May 2021 21:19:51 -0700 (PDT)
Date:   Mon, 24 May 2021 09:49:47 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bhaumik Bhatt <bbhatt@codeaurora.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, quic_jhugo@quicinc.com
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Message-ID: <20210524041947.GB8823@work>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org>
 <20210510205650.GA17966@amd>
 <20210511061623.GA8651@thinkpad>
 <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 10:50:33AM -0700, Bhaumik Bhatt wrote:
> On 2021-05-10 11:17 PM, Manivannan Sadhasivam wrote:
> > Hi Pavel,
> > 
> > On Mon, May 10, 2021 at 10:56:50PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > >
> > > > commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
> > > >
> > > > When clearing up the channel context after client drivers are
> > > > done using channels, the configuration is currently not being
> > > > reset entirely. Ensure this is done to appropriately handle
> > > > issues where clients unaware of the context state end up calling
> > > > functions which expect a context.
> > > 
> > > > +++ b/drivers/bus/mhi/core/init.c
> > > > @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > > +	u32 tmp;
> > > > @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > ...
> > > > +	tmp = chan_ctxt->chcfg;
> > > > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> > > > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > > > +	chan_ctxt->chcfg = tmp;
> > > > +
> > > > +	/* Update to all cores */
> > > > +	smp_wmb();
> > > >  }
> > > 
> > > This is really interesting code; author was careful to make sure chcfg
> > > is updated atomically, but C compiler is free to undo that. Plus, this
> > > will make all kinds of checkers angry.
> > > 
> > > Does the file need to use READ_ONCE and WRITE_ONCE?
> > > 
> > 
> > Thanks for looking into this.
> > 
> > I agree that the order could be mangled between chcfg read & write and
> > using READ_ONCE & WRITE_ONCE seems to be a good option.
> > 
> > Bhaumik, can you please submit a patch and tag stable?
> > 
> > Thanks,
> > Mani
> > 
> > > Best regards,
> > > 								Pavel
> > > --
> > > DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> > > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> 
> Hi Pavel/Mani,
> 
> Hemant and I went over this patch and we noticed this particular function is
> already being called with the channel mutex lock held. This would take care
> of
> the atomicity and we also probably don't need the smp_wmb() barrier as the
> mutex
> unlock will implicitly take care of it.
> 

okay

> To the point of compiler re-ordering, we would need some help to understand
> the
> purpose of READ_ONCE()/WRITE_ONCE() for these dependent statements:
> 
> > +	tmp = chan_ctxt->chcfg;
> > +	tmp &= ~CHAN_CTX_CHSTATE_MASK;
> > +	tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > +	chan_ctxt->chcfg = tmp;
> 
> Since RMW operation means that the chan_ctxt->chcfg is copied to a local
> variable (tmp) and the _same_ is being written back to chan_ctxt->chcfg, can
> compiler reorder these dependent statements and cause a different result?
> 

Well, I agree that there is a minimal guarantee with modern day CPUs on
not breaking the order of dependent memory accesses (like here tmp
variable is the one which gets read and written) but we want to make
sure that this won't break on future CPUs as well. So IMO using
READ_ONCE and WRITE_ONCE adds extra level of safety.

Thanks,
Mani

> Thanks,
> Bhaumik
> ---
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
