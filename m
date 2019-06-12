Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA642D9B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 19:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfFLRen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 13:34:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32898 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbfFLRek (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 13:34:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so639233plo.0
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hf77Z7okHs6KAWJMSKNVF4d5KTz/UD7D/pDjyEK/gYs=;
        b=aTi7+AmNi+MLs9q+r2+2Oe6atamFZY7EWfGeRNfBIg2NjakNPPZ43cfHjCccLr2OOo
         p46JPMzb+PauyVyL6JqaMeTK2J4XfqUrUQGeI+ZLHAWeD5McQUhUrEi7KFrbFPxHjM9f
         T/zymGxAKPZhoIx85qzNUx4yFkEv7qeiQsUtvXO9atO6NBEitjcS66KPloQrjvsm8o+e
         xORntiGIiFJr8wKUMDQPOFVyovoRDTmkBBa5A/evBxZ0ps867zg0iIrVyNf97dx6Zm/n
         IdjLIJN0UQ/eRwW/b5FC16lkaAqBnNzXWi1pAfuNzRNRi9LVDsSclZMmT4lSvJwIh4xP
         E5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hf77Z7okHs6KAWJMSKNVF4d5KTz/UD7D/pDjyEK/gYs=;
        b=XfvVe6orE+3dS0KW0zXlNJsaTb13PzvDNKavbuGaEDPRdMLsQAfqlAKuHyN/SYzdz2
         /aXo/X4VVSaBv/Z5wJ0YZyD8pU5rhjLXYMVGOJku2xPn34ho3pSAhsRS94NV90+HRSrJ
         tGrcJamzr5Gw8TfNach9Q+CWcxaNXZbNjM+42flegYAGaY3EKZ6Ie1jHPGHlTyEw2LMI
         xKmSAgC1GTBuCw3Q8O3o88vY6R3zKCX3WI9RcpXK+xdTD6+rupI3aFqHGsCiV5aI1Sfj
         EAsxFKzvNfUq8UUu0PuFSQ5nmrcezP+MNEB9KF1eTnXi1BErVSHu6V/Ep1Xephj4q8sb
         7RYA==
X-Gm-Message-State: APjAAAWak+e5fL19snqtkQoLMFCJGbUZYGQpcyfOzmcvqxUhBvPX1zuB
        0gDaT0bm1xcq4ujYtZSSy1g5AA==
X-Google-Smtp-Source: APXvYqy4DZ49qp2EU0kGEhJdBUUq/lv7cA/TCZctxhPe/YZuPI9ZnWTiGzXXhAkf7DiepbF2F9ehCg==
X-Received: by 2002:a17:902:8d92:: with SMTP id v18mr59822777plo.211.1560360878876;
        Wed, 12 Jun 2019 10:34:38 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id z3sm75832pjn.16.2019.06.12.10.34.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 10:34:38 -0700 (PDT)
Date:   Wed, 12 Jun 2019 10:34:36 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH] phy: qcom-qmp: Correct READY_STATUS poll break condition
Message-ID: <20190612173436.GZ4814@minitux>
References: <20190604232443.3417-1-bjorn.andersson@linaro.org>
 <20190612130858.GA11167@centauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612130858.GA11167@centauri>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 12 Jun 06:08 PDT 2019, Niklas Cassel wrote:

> On Tue, Jun 04, 2019 at 04:24:43PM -0700, Bjorn Andersson wrote:
> > After issuing a PHY_START request to the QMP, the hardware documentation
> > states that the software should wait for the PCS_READY_STATUS to become
> > 1.
> > 
> > With the introduction of c9b589791fc1 ("phy: qcom: Utilize UFS reset
> > controller") an additional 1ms delay was introduced between the start
> > request and the check of the status bit. This greatly increases the
> > chances for the hardware to actually becoming ready before the status
> > bit is read.
> > 
> > The result can be seen in that UFS PHY enabling is now reported as a
> > failure in 10% of the boots on SDM845, which is a clear regression from
> > the previous rare/occasional failure.
> > 
> > This patch fixes the "break condition" of the poll to check for the
> > correct state of the status bit.
> > 
> > Unfortunately PCIe on 8996 and 8998 does not specify the mask_pcs_ready
> > register, which means that the code checks a bit that's always 0. So the
> > patch also fixes these, in order to not regress these targets.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Evan Green <evgreen@chromium.org>
> > Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
> > Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
> > Fixes: 73d7ec899bd8 ("phy: qcom-qmp: Add msm8998 PCIe QMP PHY support")
> > Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > 
> > @Kishon, this is a regression spotted in v5.2-rc1, so please consider applying
> > this towards v5.2.
> > 
> >  drivers/phy/qualcomm/phy-qcom-qmp.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > index cd91b4179b10..43abdfd0deed 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > @@ -1074,6 +1074,7 @@ static const struct qmp_phy_cfg msm8996_pciephy_cfg = {
> >  
> >  	.start_ctrl		= PCS_START | PLL_READY_GATE_EN,
> >  	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
> > +	.mask_pcs_ready		= PHYSTATUS,
> >  	.mask_com_pcs_ready	= PCS_READY,
> >  
> >  	.has_phy_com_ctrl	= true,
> > @@ -1253,6 +1254,7 @@ static const struct qmp_phy_cfg msm8998_pciephy_cfg = {
> >  
> >  	.start_ctrl             = SERDES_START | PCS_START,
> >  	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
> > +	.mask_pcs_ready		= PHYSTATUS,
> >  	.mask_com_pcs_ready	= PCS_READY,
> >  };
> >  
> > @@ -1547,7 +1549,7 @@ static int qcom_qmp_phy_enable(struct phy *phy)
> >  	status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
> >  	mask = cfg->mask_pcs_ready;
> >  
> > -	ret = readl_poll_timeout(status, val, !(val & mask), 1,
> > +	ret = readl_poll_timeout(status, val, val & mask, 1,
> >  				 PHY_INIT_COMPLETE_TIMEOUT);
> >  	if (ret) {
> >  		dev_err(qmp->dev, "phy initialization timed-out\n");
> > -- 
> > 2.18.0
> > 
> 
> msm8996_pciephy_cfg and msm8998_pciephy_cfg not having a bit mask defined
> for PCS ready is really a separate bug, so personally I would have created
> two patches, one that adds the missing masks, and one patch that fixes the
> broken break condition.
> 

We can't add mask_pcs_ready in a separate commit after the poll change,
because this would introduce a regression in the history and we can't
add the mask_pcs_ready before because when I tested this on db820c I saw
occasional initialization failures.

I was not able to verify 8998, but I presume that the same dependency
exists there.

> Either way:
> 
> Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>

Thanks,
Bjorn
