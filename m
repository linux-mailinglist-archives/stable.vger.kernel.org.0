Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDD58B707
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 18:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiHFQov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 12:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiHFQor (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 12:44:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52C12AD3
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 09:44:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f192so4732001pfa.9
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 09:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EeVXZM18o949tN0qq5RHF4dl6C4L5bffGDwRqH8GiUU=;
        b=xQcDen4rmkms9d2IMbQOqk5TIScNtuNMuhz7oPH4Hl05YdCwGN0N7niRmyFza+nrNc
         uSqw+CWMwkNT5y2WEpVOrXCCwNxnVwW6y6r8ziqM8mWL9JhEzTOCY8ayweKOEWPRaiG6
         uHr+69m3di/tJbcooBQH8QIhHosVYCHaS6YgvihezHzvUTNICFZZllFeuZRFmiI3q/Rg
         O9F1V6MBG4zz4rFIlwO8s0pSsDYQd5Y7g35FL+iv6iQl0pcFMoABjC/wvF8jq6iIDPGj
         xgMmLW+9MoWPmq4s/hgk/4x3IurGNfwxV5A8Mj0BRQ15ZOUctAsiXkiZ2nzcQGGU+/ux
         +Waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EeVXZM18o949tN0qq5RHF4dl6C4L5bffGDwRqH8GiUU=;
        b=f87rW3GUVTfIiT6H8AMxHn7RuO2C5J3/DunwIH72dTZJey11JYkHMLtbSTb/EmJD4W
         /4bBcm4xdpIvDddDTXfgXtFlsMjspfPXtPkl7/kTO/8tEQ4JvyaS3TLB4nuloAK7AEKE
         sqEAmOhzSsb8ILEKHyp8A+HTsSefnnrWotqlq97arKwmSSkOIV+tscRnbZewhBksJE2R
         EkaGnwFEvgyKbY04Zq+4vcH+hmebxM3yqhBkGgRxhP/EX2+1w7Q5gt2RE/bLPqz7Bypi
         oELY+8y5NqsddBmfHrsLGxZ92ijpTDEBXzlpcXBGS7P6+mFWOQ8eqMLzbJV4/R0WtH4z
         nPNw==
X-Gm-Message-State: ACgBeo1vCMYHtdlfVu+DcsJw4AT3Q9dXfiSNyTTetNhvTmNNFW9K0ZaF
        mGqKz/sh525h1dD1GQP0tbad
X-Google-Smtp-Source: AA6agR4GjBwEjRaNT6AKyfrcOBbIQjOgmfF57fE8Ye3GD77o1OL3xoCGwCKLzYSbl8ZRr7ndVeCXWQ==
X-Received: by 2002:a63:2bcc:0:b0:40c:95b5:46a4 with SMTP id r195-20020a632bcc000000b0040c95b546a4mr9907552pgr.535.1659804284859;
        Sat, 06 Aug 2022 09:44:44 -0700 (PDT)
Received: from thinkpad ([117.202.188.20])
        by smtp.gmail.com with ESMTPSA id x26-20020aa78f1a000000b0052e2435784asm5378736pfr.8.2022.08.06.09.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 09:44:44 -0700 (PDT)
Date:   Sat, 6 Aug 2022 22:14:35 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        quic_ppratap@quicinc.com, quic_vpulyala@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 4/9] usb: dwc3: qcom: fix use-after-free on runtime-PM
 wakeup
Message-ID: <20220806164435.GL14384@thinkpad>
References: <20220804151001.23612-1-johan+linaro@kernel.org>
 <20220804151001.23612-5-johan+linaro@kernel.org>
 <20220806143311.GE14384@thinkpad>
 <Yu6SE1wKXk6/qT9Z@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yu6SE1wKXk6/qT9Z@hovoldconsulting.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 06, 2022 at 06:08:51PM +0200, Johan Hovold wrote:
> On Sat, Aug 06, 2022 at 08:03:11PM +0530, Manivannan Sadhasivam wrote:
> > On Thu, Aug 04, 2022 at 05:09:56PM +0200, Johan Hovold wrote:
> > > The Qualcomm dwc3 runtime-PM implementation checks the xhci
> > > platform-device pointer in the wakeup-interrupt handler to determine
> > > whether the controller is in host mode and if so triggers a resume.
> > > 
> > > After a role switch in OTG mode the xhci platform-device would have been
> > > freed and the next wakeup from runtime suspend would access the freed
> > > memory.
> > > 
> > > Note that role switching is executed from a freezable workqueue, which
> > > guarantees that the pointer is stable during suspend.
> > > 
> > > Also note that runtime PM has been broken since commit 2664deb09306
> > > ("usb: dwc3: qcom: Honor wakeup enabled/disabled state"), which
> > > incidentally also prevents this issue from being triggered.
> > > 
> > > Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
> > > Cc: stable@vger.kernel.org      # 4.18
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > 
> > It'd be good to mention the introduction of dwc3_qcom_is_host() function.
> > Initially I thought it is used in a single place, but going through the rest of
> > the patches reveals that it is used later on.
> 
> I think the helper is warranted on its own as it serves as documentation
> of the underlying assumptions that this code relies on.
> 

That's even better.

Thanks,
Mani

> > > +/* Only usable in contexts where the role can not change. */
> > > +static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
> > > +{
> > > +	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> > > +
> > > +	return dwc->xhci;
> > > +}
> > > +
> > >  static enum usb_device_speed dwc3_qcom_read_usb2_speed(struct dwc3_qcom *qcom)
> > >  {
> > >  	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> > > @@ -460,7 +468,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
> > >  	if (qcom->pm_suspended)
> > >  		return IRQ_HANDLED;
> > >  
> > > -	if (dwc->xhci)
> > > +	/*
> > > +	 * This is safe as role switching is done from a freezable workqueue
> > > +	 * and the wakeup interrupts are disabled as part of resume.
> > > +	 */
> > > +	if (dwc3_qcom_is_host(qcom))
> > >  		pm_runtime_resume(&dwc->xhci->dev);
> > >  
> > >  	return IRQ_HANDLED;
> > > diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> > > index f56c30cf151e..f6f13e7f1ba1 100644
> > > --- a/drivers/usb/dwc3/host.c
> > > +++ b/drivers/usb/dwc3/host.c
> > > @@ -135,4 +135,5 @@ int dwc3_host_init(struct dwc3 *dwc)
> > >  void dwc3_host_exit(struct dwc3 *dwc)
> > >  {
> > >  	platform_device_unregister(dwc->xhci);
> > > +	dwc->xhci = NULL;
> > >  }
> > > -- 
> > > 2.35.1
> 
> Johan

-- 
மணிவண்ணன் சதாசிவம்
