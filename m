Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7456C591
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 03:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGIBDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 21:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGIBDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 21:03:41 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388B120F75;
        Fri,  8 Jul 2022 18:03:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e15so400634edj.2;
        Fri, 08 Jul 2022 18:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=mUN/AOWTdinxudZCNC3LAuGpWaBiaOwsLd0WYWLYigw=;
        b=NgcwiNmAXycR9jGgZPdhGax6Q8BCPG3jSnKRA3+wIgrc2GIvrXTuaEp2Ub0NeLgToZ
         XoUGxGO2jI/bcrgshBLNvnjz+N3HbkdTh3OgPvRuRzfUHMU7Dmr8d6+9Cd8gAngYnC+I
         RhgaizPyGSa0enmZgHPctZNxEofio8740lmsya/eO84/DV2Nei5yRVk17GIlGzLjbdf0
         nm1DvbavbGSXqXZXLdvTEzfcbW3qr7Cg0R9X4SCmiMOSZpzqIH+gH54UA/qZbUKHRfo7
         TVcjU+QAGVXHP1yXroQrEMiQNUWm3Are0ZL2hA3MiXTLWugc2UeawibowIs/hmuqSoCb
         o0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=mUN/AOWTdinxudZCNC3LAuGpWaBiaOwsLd0WYWLYigw=;
        b=w74Nm273JNM04J7Gna1lXWOl9mxEt+aSse+wsrKl1uoBzsZUwSkxx0C4VIgFLN7W4k
         HKFJgyoICDrKpNWkqJyR454yW5/5N23kQ7mtxIB5ZLJO2cVgs2LWv/6co1ydZrnQkrGl
         ngWFDLRHex8KsVT0aBYOFaXC0c7Y9suLTCqBEzAVkZXxZoqoxjbal8PbzMN74l2p3Ceg
         kc4Skde3Jbq/CSZfoLlNrHUWXXiXvLNbHAmXQBp2qHkGh4nEfrouWHquK5f7hsV9EmgO
         p29BAfkUbO53N6hAuiIngJ3q/VojUihBg+nuJsSoLDCn4MO3kFhVnRwaZk/4oUdbg5WT
         0teQ==
X-Gm-Message-State: AJIora+q4KSfr8Tmvwuxl6ZVWgmYSP2wb42km89jBPlPyybgqj+I2s8w
        kxJZ/HmRR2zuoBsNCYcPXNY=
X-Google-Smtp-Source: AGRyM1vBCnkjvlgiNu4SLPkjWfdzRKeS6cENoppZYLiCeVl8iwXVL9Z1+wq7zRGSoPNUsrB7ee1uVQ==
X-Received: by 2002:a05:6402:4518:b0:43a:3b90:7457 with SMTP id ez24-20020a056402451800b0043a3b907457mr8383451edb.422.1657328616641;
        Fri, 08 Jul 2022 18:03:36 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id w20-20020a056402071400b0043a87e6196esm129683edx.6.2022.07.08.18.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 18:03:36 -0700 (PDT)
Message-ID: <62c8d3e8.1c69fb81.26eee.0249@mx.google.com>
X-Google-Original-Message-ID: <YsjT5spmATKculEL@Ansuel-xps.>
Date:   Sat, 9 Jul 2022 03:03:34 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Enable clocks only after PARF_PHY setup for
 rev 2.1.0
References: <20220708222743.27019-1-ansuelsmth@gmail.com>
 <20220708230155.GA388993@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708230155.GA388993@bhelgaas>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 08, 2022 at 06:01:55PM -0500, Bjorn Helgaas wrote:
> On Sat, Jul 09, 2022 at 12:27:43AM +0200, Christian Marangi wrote:
> > We currently enable clocks BEFORE we write to PARF_PHY_CTRL reg to
> > enable clocks and resets. This case the driver to never set to a ready
> > state with the error 'Phy link never came up'.
> > 
> > This in fact is caused by the phy clock getting enabled before setting
> > the required bits in the PARF regs.
> > 
> > A workaround for this was set but with this new discovery we can drop
> > the workaround and use a proper solution to the problem by just enabling
> > the clock only AFTER the PARF_PHY_CTRL bit is set.
> > 
> > This correctly setup the pcie line and makes it usable even when a
> > bootloader leave the pcie line to a underfined state.
> 
> Is "pcie" here a signal name?  Maybe this refers to the "PCIe link"?
>

Hi,
no i was referring to PCIe link. Fell free to fix it if it's not a
problem (or if you want i can just resend)

> > Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> > Cc: stable@vger.kernel.org # v5.4+
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> Thanks, I put this on
> https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git,
> pci/ctrl/qcom-pending branch (head 47b4ec9d2e60).
> 
> Can you take a look and make sure I didn't mess up the conflict
> resolution with the rest of the series?

Think something went wrong in the rebase as the patch fixup is reverted.

11946f8b6e77a6794c111aafef7772e9967d9a54 is still wrong.

clk_bulk_prepare_enable must be after 
writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
so in the post init.

> 
> > ---
> >  drivers/pci/controller/dwc/pcie-qcom.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> > index 2ea13750b492..da13a66ced14 100644
> > --- a/drivers/pci/controller/dwc/pcie-qcom.c
> > +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> > @@ -337,8 +337,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
> >  	reset_control_assert(res->ext_reset);
> >  	reset_control_assert(res->phy_reset);
> >  
> > -	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
> > -
> >  	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
> >  	if (ret < 0) {
> >  		dev_err(dev, "cannot enable regulators\n");
> > @@ -381,15 +379,15 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
> >  		goto err_deassert_axi;
> >  	}
> >  
> > -	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
> > -	if (ret)
> > -		goto err_clks;
> > -
> >  	/* enable PCIe clocks and resets */
> >  	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
> >  	val &= ~BIT(0);
> >  	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
> >  
> > +	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
> > +	if (ret)
> > +		goto err_clks;
> > +
> >  	if (of_device_is_compatible(node, "qcom,pcie-ipq8064") ||
> >  	    of_device_is_compatible(node, "qcom,pcie-ipq8064-v2")) {
> >  		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
> > -- 
> > 2.36.1
> > 

-- 
	Ansuel
