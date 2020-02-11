Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85011587D2
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 02:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBKBQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 20:16:50 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38684 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbgBKBQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 20:16:50 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so4596277pfc.5
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 17:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L94wnmuPGmPtklUH/qWzd8d0kQjfVjGh7Zgzyio4HMc=;
        b=a/i9AzIFMsTZnIJp2DeLdmKOPd92z3kTLAKJiRmIsEeGS+/W49KEIPoYpMULLAtm+m
         oCzvmHNTXf1B5Pj4FZylZ1OCH0xyENwVgrCY2Fajg7kBijc7TdlELC+gVzTXxbUlw3Tu
         QytWBhTWb5ij7bRZuZY6bCTq2GD125uwgfFapFRVM1BZTVE9wj29rh4JZEAcmm4oF0Ad
         eSs6UnIoXgeY6Ne1JJ6JZ8pnnFuVtFOnkTZYTjPJaKlaI3NOhL/xv2RhzoCzGuuODdiK
         6AO8dqtMnhrecg5sUt6R6quaK8o7Sh0xXZh2ghXeBpmZN9JM3Y7+URUDtFJklSsyiKC1
         HlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L94wnmuPGmPtklUH/qWzd8d0kQjfVjGh7Zgzyio4HMc=;
        b=qoN3uBqZrBTe5VmUftbTW4ZL/uhaMGLdEBh++l78+/IGIZmHrjHqfdAudH0EbTUE1U
         JVGrEAC562lpAcDQcsMaAmdn+Fpx1lm7i/Mj1mfFXdlqlx10csBQJMIzLD8MbWpvH38p
         Ph2erUgPxAYLQ5uOwL1qpwQ6emifNYM0pHnm1aZtWa0YPSw3pSMtt8wjzcYwx+2tfWdD
         SwgHs20dI+OzjSiPnOo2W4thIKCY/sSjFYqy4n/r7wQxxBjsLnW3uDWXhPTpETQt0uup
         pRjdni/wOfbQNBkWDqS3/33Q/+8id56tByaJb1hSG38MlCjSb0l4mvhaybdknCPgsitc
         O2KA==
X-Gm-Message-State: APjAAAUN1pceGRtKXJMsLPf2bnzjqnb4ghSKC1uiR5vTHAW5+raHlYZS
        TBOOMr3fXH7/MqqeRIajlBJlBw==
X-Google-Smtp-Source: APXvYqwNHPPj+04G7TT3812Rn18q0s53KRLsMjhjKXZtlA6OKi0UVTvUtXIPosZYeLnPthh3D0BOcw==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr4038374pfi.10.1581383809472;
        Mon, 10 Feb 2020 17:16:49 -0800 (PST)
Received: from ripper (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id k29sm1618869pfh.77.2020.02.10.17.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 17:16:48 -0800 (PST)
Date:   Mon, 10 Feb 2020 17:16:01 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss
 region on shutdown
Message-ID: <20200211011601.GD3261042@ripper>
References: <20200204062641.393949-1-bjorn.andersson@linaro.org>
 <20200204062641.393949-2-bjorn.andersson@linaro.org>
 <20200210230548.GA20652@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210230548.GA20652@xps15>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 10 Feb 15:05 PST 2020, Mathieu Poirier wrote:

> Hi Bjorn,
> 
> On Mon, Feb 03, 2020 at 10:26:40PM -0800, Bjorn Andersson wrote:
> > Trying to reclaim mpss memory while the mba is not running causes the
> > system to crash on devices with security fuses blown, so leave it
> > assigned to the remote on shutdown and recover it on a subsequent boot.
> > 
> > Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > 
> > Changes since v2:
> > - The assignment of mpss memory back to Linux is rejected in the coredump case
> >   on production devices, so check the return value of q6v5_xfer_mem_ownership()
> >   before attempting to memcpy() the data.
> > 
> >  drivers/remoteproc/qcom_q6v5_mss.c | 23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> > index 471128a2e723..25c03a26bf88 100644
> > --- a/drivers/remoteproc/qcom_q6v5_mss.c
> > +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> > @@ -887,11 +887,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
> >  		writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
> >  	}
> >  
> > -	ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > -				      false, qproc->mpss_phys,
> > -				      qproc->mpss_size);
> > -	WARN_ON(ret);
> > -
> >  	q6v5_reset_assert(qproc);
> >  
> >  	q6v5_clk_disable(qproc->dev, qproc->reset_clks,
> > @@ -981,6 +976,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
> >  			max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
> >  	}
> >  
> > +	/* Try to reset ownership back to Linux */
> > +	q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> > +				qproc->mpss_phys, qproc->mpss_size);
> 
> Would you mind adding more chatter here, something like what is mentioned in the
> changelog?  That way I anyone trying to review this code doesn't have to suffer
> through the same mental gymnastic. 
> 

Sure thing, as this patch shows this dynamic wasn't clear - and this
patch is based on my observations. With it we no longer crash the entire
system by hitting a security violation during a crash, but there's still
some details that I'm uncertain about.

> > +
> >  	mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
> >  	qproc->mpss_reloc = mpss_reloc;
> >  	/* Load firmware segments */
> > @@ -1070,8 +1069,16 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
> >  	void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
> >  
> >  	/* Unlock mba before copying segments */
> > -	if (!qproc->dump_mba_loaded)
> > +	if (!qproc->dump_mba_loaded) {
> >  		ret = q6v5_mba_load(qproc);
> > +		if (!ret) {
> > +			/* Try to reset ownership back to Linux */
> > +			ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > +						      false,
> > +						      qproc->mpss_phys,
> > +						      qproc->mpss_size);
> > +		}
> 
> I'm a bit puzzled here as to why a different reclaim strategy is needed.  It is
> clear to me that if q6v5_mba_load() returns 0 then the MBA is running and we can
> safely reclaim ownership of the memory.  But is it absolutely needed when we
> know that 1) the MCU has crashed and 2) said memory will be reclaimed in
> q6v5_mpss_load()?
> 

The ownership transfer here is a jump into secure world, which somehow
together with the firmware running on the modem processor will update
the access permissions for the mpss memory region.

As we enter this function the recovery handling in the core has just
stopped the remote processor, so we know it's off. As such we must first
boot the remote processor again, in order to reclaim the access to the
mpss memory region.

New in this revision is the fact that this operation might actually be
rejected (e.g. on end-user hardware).

So we need to guard the memcpy below on either of these cases, as unless
we've successfully booted the modem processor and gotten permission to
read the mpss memory this operation will trigger a security violation
and the device will reboot.

> If so I think an explanation in the code is needed.
> 

Makes sense, I will formulate above explanation into a comment. As well
as review the other callers of q6v5_xfer_mem_ownership().

> I also assume there is no way to know if the mba is running, hence not taking
> any chance.  If that's the case it would be nice to add that to the comment in
> q6v5_mpss_load().
> 

We know that we enter q6v5_mpss_load() with the modem processor just
booted, but the memory assignment is there to handle the case where the
mpss memory region for some reason was left in the hands on the modem.
I will have to do some more digging to figure out if this is a valid
scenario or not.

Thanks for your review Mathieu!

Regards,
Bjorn

> Thanks,
> Mathieu
> 
> > +	}
> >  
> >  	if (!ptr || ret)
> >  		memset(dest, 0xff, segment->size);
> > @@ -1123,10 +1130,6 @@ static int q6v5_start(struct rproc *rproc)
> >  	return 0;
> >  
> >  reclaim_mpss:
> > -	xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> > -						false, qproc->mpss_phys,
> > -						qproc->mpss_size);
> > -	WARN_ON(xfermemop_ret);
> >  	q6v5_mba_reclaim(qproc);
> >  
> >  	return ret;
> > -- 
> > 2.23.0
> > 
