Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDCF64BB0C
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiLMRbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbiLMRal (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:30:41 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524E42314D
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:30:31 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k79so2681472pfd.7
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0WZ8TzLeB/rXEyvbeXV/qGpfj1Y7zlME5zl3wBjcFAc=;
        b=bktt6gT2sTs0BE6pOcUBqBlAW366m7cOGpI7lNvmKJ2gQvmVP5YetN8VGcER95at7k
         yCTVz5xUUPJQPRaLHTIjodfpAJBVnFrUuo0RkoNjE2GNcMvk4Vrsb/h5NlwGQv/eFbKc
         nM5/nSIaHkuptZEWZgj1RT0MHxZmOISbsZwzvo3xTO9s4HcDII/Fa/NIzkq+0PFn7P3s
         e6KRs3cGb9ddIjT+R2CvenJZc9x4GyuFk8wfb9ROyfVWhnnOJRxxy6aBnEdk1BWuVBiy
         bzVQYiLqEcJHWuASXvXV8xfxTTKYsq19yQpeMsoxkpVeE9W4ZgWwutWmprmFcHOzJ/JY
         DX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WZ8TzLeB/rXEyvbeXV/qGpfj1Y7zlME5zl3wBjcFAc=;
        b=fbD0bzuD39bt911a5gSfybYWenjrGthFWMHtxIPGFSJoHuGgavWtU/ppvytdBJBKo4
         nEKOAaO/Yf8pygWtguc8OH1E/UH9ei+2CnXEHlr5Efwk8jTogHM1towPVtTU57dv/S18
         uhL/QYPqhHdqBpfwbKfnJaPRWVSsJepwmqf/lOwRlxeZhToc+nsczIdDTrNPnzn49tqz
         5pG3RMoSnccceFIbs2yBmgG3kY1oyBZEzSg10+Papc/KVXkwuNqt6Z2DAZYW7XFvDuGA
         bHCljJhyizktV7OqFrN8+lpAoucm61clcJxy0F8aynn3SJ92jiV/LsrOGl8jGGfT0Fh6
         5b1A==
X-Gm-Message-State: ANoB5pmNjoeKisUutME9vomV/TSpijcZjy0vNOEHaGPsJjzuWis2U3Bw
        RNPRHTaONGI3emgwga4eiyrp
X-Google-Smtp-Source: AA0mqf5hOA2kJpq7spRZKe/QPabg82P2ViwApCpt/T8KEC2ikfNo0EJ8y0+3viN8q36+EET3TjfGQg==
X-Received: by 2002:a05:6a00:1696:b0:56e:dca8:ba71 with SMTP id k22-20020a056a00169600b0056edca8ba71mr26551604pfc.32.1670952630686;
        Tue, 13 Dec 2022 09:30:30 -0800 (PST)
Received: from thinkpad ([27.111.75.5])
        by smtp.gmail.com with ESMTPSA id b133-20020a621b8b000000b005776867a97dsm7931860pfb.29.2022.12.13.09.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:30:29 -0800 (PST)
Date:   Tue, 13 Dec 2022 23:00:23 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/13] dt-bindings: arm: msm: Fix register regions
 used for LLCC banks
Message-ID: <20221213173023.GG4862@thinkpad>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-3-manivannan.sadhasivam@linaro.org>
 <aa692a69-fc8d-472e-e5ae-276c3d6d7d78@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa692a69-fc8d-472e-e5ae-276c3d6d7d78@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 05:24:45PM +0100, Krzysztof Kozlowski wrote:
> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> > Register regions of the LLCC banks are located at separate addresses.
> > Currently, the binding just lists the LLCC0 base address and specifies
> > the size to cover all banks. This is not the correct approach since,
> > there are holes and other registers located in between.
> > 
> > So let's specify the base address of each LLCC bank and get rid of
> > reg-names property as it is not needed anymore. It should be noted that
> > the bank count differs for each SoC, so that also needs to be taken into
> > account in the binding.
> > 
> > Cc: <stable@vger.kernel.org> # 4.19
> > Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  .../bindings/arm/msm/qcom,llcc.yaml           | 97 ++++++++++++++++---
> >  1 file changed, 83 insertions(+), 14 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > index d1df49ffcc1b..260bc87629a7 100644
> > --- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > +++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > @@ -33,14 +33,8 @@ properties:
> >        - qcom,sm8550-llcc
> >  
> >    reg:
> > -    items:
> > -      - description: LLCC base register region
> > -      - description: LLCC broadcast base register region
> > -
> > -  reg-names:
> > -    items:
> > -      - const: llcc_base
> > -      - const: llcc_broadcast_base
> > +    minItems: 2
> > +    maxItems: 9
> >  
> >    interrupts:
> >      maxItems: 1
> > @@ -48,7 +42,76 @@ properties:
> >  required:
> >    - compatible
> >    - reg
> > -  - reg-names
> > +
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - qcom,sc7180-llcc
> > +              - qcom,sm6350-llcc
> > +    then:
> > +      properties:
> > +        reg:
> > +          items:
> > +            - description: LLCC0 base register region
> > +            - description: LLCC broadcast base register region
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - qcom,sc7280-llcc
> > +    then:
> > +      properties:
> > +        reg:
> > +          items:
> > +            - description: LLCC0 base register region
> > +            - description: LLCC1 base register region
> > +            - description: LLCC broadcast base register region
> 
> This will break all existing users (all systems, bootloaders/firmwares),
> so you need to explain that in commit msg - why breaking is allowed, who
> is or is not going to be affected etc. Otherwise judging purely by
> bindings this is an ABI break.
> 
> Reason "This is not the correct approach since, there are holes and
> other registers located in between." is not enough, because this
> suggests previous approach was just not the best and you have something
> better. Better is not a reason for ABI break.
> 

Maybe I need to reword the commit message a bit. But clearly the binding was
wrong for rest of the SoCs other than SDM845 as the total size of the LLCC
region includes registers of other peripherals like memory controller.

In that case, will you let the binding to be wrong or fix it?

Thanks,
Mani

> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - qcom,sc8180x-llcc
> > +              - qcom,sc8280xp-llcc
> > +    then:
> > +      properties:
> > +        reg:
> > +          items:
> > +            - description: LLCC0 base register region
> > +            - description: LLCC1 base register region
> > +            - description: LLCC2 base register region
> > +            - description: LLCC3 base register region
> > +            - description: LLCC4 base register region
> > +            - description: LLCC5 base register region
> > +            - description: LLCC6 base register region
> > +            - description: LLCC7 base register region
> > +            - description: LLCC broadcast base register region
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - qcom,sdm845-llcc
> > +              - qcom,sm8150-llcc
> > +              - qcom,sm8250-llcc
> > +              - qcom,sm8350-llcc
> > +              - qcom,sm8450-llcc
> > +    then:
> > +      properties:
> > +        reg:
> > +          items:
> > +            - description: LLCC0 base register region
> > +            - description: LLCC1 base register region
> > +            - description: LLCC2 base register region
> > +            - description: LLCC3 base register region
> > +            - description: LLCC broadcast base register region
> >  
> >  additionalProperties: false
> >  
> > @@ -56,9 +119,15 @@ examples:
> >    - |
> >      #include <dt-bindings/interrupt-controller/arm-gic.h>
> >  
> > -    system-cache-controller@1100000 {
> > -      compatible = "qcom,sdm845-llcc";
> > -      reg = <0x1100000 0x200000>, <0x1300000 0x50000> ;
> > -      reg-names = "llcc_base", "llcc_broadcast_base";
> > -      interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> > +    soc {
> > +        #address-cells = <2>;
> > +        #size-cells = <2>;
> > +
> > +        system-cache-controller@1100000 {
> > +          compatible = "qcom,sdm845-llcc";
> 
> Inconsistent indentation for DTS example. Use 4 spaces for it.
> 
> > +          reg = <0 0x01100000 0 0x50000>, <0 0x01180000 0 0x50000>,
> > +                <0 0x01200000 0 0x50000>, <0 0x01280000 0 0x50000>,
> > +                <0 0x01300000 0 0x50000>;
> > +          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> > +        };
> >      };
> 
> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்
