Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC646CF05
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbhLHIeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244853AbhLHIeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:34:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C9FC0617A2
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 00:30:45 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x131so1795731pfc.12
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 00:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RRzI4Iei17Ahggjstaqb1wov493fOuSguTH2Wc+bkwI=;
        b=ZlrqYumsXJ26Tvh0dTMnaSXivpjkDZvaj8K4es5g8PFBhjcf2pkZlVXbThCYAHMYYC
         7RLoLdhOwvUfYhlBz1G8UAR0hw2PN/hACdXrH8Nmcw9ZpvUhons9s9mA8jE3crhs75Fm
         /wcNAZ27E9xS/UXTiCeNQU7zq/5wDyZexd0kUoHpBeIy7tqdxGtuCdPzhkDTTwUnis6R
         se8Tanwa/vMQhFUrN+gpQRIM6zEWKTcyE19eNULgZb/000Y4GhCulAe9rBfskrk2pTdq
         Pp1NrDl5o6c2uCpfLk1++rDpJNB6NdRNw+D56AJbKnOx/rsxrSEE2v3J1sV/ZJHkX4gC
         69VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RRzI4Iei17Ahggjstaqb1wov493fOuSguTH2Wc+bkwI=;
        b=jOko1brwkiPcINOyUa/qh1J3W05814L2azYHu6VcVgJX5hwfpfYpUCYFWl37tzQ/UO
         NuzU9HTs7Ji91HpgUpFgrdpoP2PwAfmyMEgHUipR3RLSAAh3AuphmvmuR4ce3WF/cz3A
         LJcVxwLOiG/CEk9JhRKPSduExpf5AbTx5X69Q9I78omTDI3GfROhJwZmFz7h7tM2TDB4
         7WErWUzZkINgBQXo1jiyhu9A7rdmVYEd7yR5cW7t2e7Q0MZrXGxf1HnSMSpGFs+RUMzE
         Acs3fC0hz5M+5f1gmOM0AIWMMj0Ka9zJLdeG13MHoIgE2yP+9h73nZY5FyyPoay1yZIu
         Zo6w==
X-Gm-Message-State: AOAM533i1OP3iPdCSvdBnyYFMfJH36D/SwLD+g+CNrZMYkEReb867+JS
        0Hld/GFPISCRp5racVR3VdqT
X-Google-Smtp-Source: ABdhPJxGzy9Z2ZMkn1bf7beooiLm6AWWW1bSqP0UhkmlyfZ2EcXB2dbbvnFb/xvteJJ/lcrb/FdDHw==
X-Received: by 2002:a63:5b24:: with SMTP id p36mr15366637pgb.258.1638952244983;
        Wed, 08 Dec 2021 00:30:44 -0800 (PST)
Received: from thinkpad ([117.202.189.59])
        by smtp.gmail.com with ESMTPSA id s19sm2408544pfu.104.2021.12.08.00.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:30:44 -0800 (PST)
Date:   Wed, 8 Dec 2021 14:00:37 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     mhi@lists.linux.dev, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        stable@vger.kernel.org, Pengyu Ma <mapengyu@gmail.com>
Subject: Re: [PATCH] bus: mhi: core: Add support for forced PM resume
Message-ID: <20211208083037.GD70121@thinkpad>
References: <20211206161059.107007-1-manivannan.sadhasivam@linaro.org>
 <7eb05d7c-ddda-5ec1-73a0-e696d2b5a236@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb05d7c-ddda-5ec1-73a0-e696d2b5a236@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 03:41:42PM -0800, Hemant Kumar wrote:
> Hi Mani,
> 
> On 12/6/2021 8:10 AM, Manivannan Sadhasivam wrote:
> > From: Loic Poulain <loic.poulain@linaro.org>
> > 
> > For whatever reason, some devices like QCA6390, WCN6855 using ath11k
> > are not in M3 state during PM resume, but still functional. The
> > mhi_pm_resume should then not fail in those cases, and let the higher
> > level device specific stack continue resuming process.
> > 
> > Add a new parameter to mhi_pm_resume, to force resuming, whatever the
> > current MHI state is. This fixes a regression with non functional
> > ath11k WiFi after suspend/resume cycle on some machines.
> > 
> > Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=214179
> > 
> > Cc: stable@vger.kernel.org #5.13
> > Fixes: 020d3b26c07a ("bus: mhi: Early MHI resume failure in non M3 state")
> > Reported-by: Kalle Valo <kvalo@codeaurora.org>
> > Reported-by: Pengyu Ma <mapengyu@gmail.com>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > [mani: Added comment, bug report, added reported-by tags and CCed stable]
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >   drivers/bus/mhi/core/pm.c             | 10 +++++++---
> >   drivers/bus/mhi/pci_generic.c         |  2 +-
> >   drivers/net/wireless/ath/ath11k/mhi.c |  6 +++++-
> >   include/linux/mhi.h                   |  3 ++-
> >   4 files changed, 15 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> > index 7464f5d09973..4ddd266e042e 100644
> > --- a/drivers/bus/mhi/core/pm.c
> > +++ b/drivers/bus/mhi/core/pm.c
> > @@ -881,7 +881,7 @@ int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
> >   }
> >   EXPORT_SYMBOL_GPL(mhi_pm_suspend);
> > -int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
> > +int mhi_pm_resume(struct mhi_controller *mhi_cntrl, bool force)
> >   {
> >   	struct mhi_chan *itr, *tmp;
> >   	struct device *dev = &mhi_cntrl->mhi_dev->dev;
> > @@ -898,8 +898,12 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
> >   	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
> >   		return -EIO;
> > -	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3)
> > -		return -EINVAL;
> > +	if (mhi_get_mhi_state(mhi_cntrl) != MHI_STATE_M3) {
> 	in case if mhi_get_mhi_state(mhi_cntrl) returns SYS_ERR (assuming while
> doing this check SYS_ERR is set) do we still want to continue pm resume when
> force is true? Just want to make sure SYS_ERR handling with and without this
> change remains the same or atleast does not cause any regression with this
> change. or if we need to continue pm resume only for MHI_STATE_RESET when
> MHI_STATE_M3 is not set?

SYS_ERR state is a valid case while resuming from suspend. The "force" flag is
supposed to be used by controllers that goes to a weird state like RESET. If we
just add check for RESET, then we might get another scenario in future. That's
why the "force" flag made sense to me.

If we want to handle SYS_ERR then we need to check for that before M3 and that
can be done in a separate patch. But since we didn't hit this scenario till now,
let's handle it later if needed.

Thanks,
Mani

> > +		dev_warn(dev, "Resuming from non M3 state (%s)\n",
> > +			 TO_MHI_STATE_STR(mhi_get_mhi_state(mhi_cntrl)));
> > +		if (!force)
> > +			return -EINVAL;
> > +	}
> [..]
> 
> Thanks,
> Hemant
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a
> Linux Foundation Collaborative Project
