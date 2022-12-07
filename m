Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCF1645F4B
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLGQxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 11:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLGQxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 11:53:50 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D88860EAC
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 08:53:49 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so16881994pgm.6
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 08:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QjQA1kPacOgH4eRJ/9nxZUj4C67EN1sFhNTSvG9bbA0=;
        b=QAEEvOQWgBK2sLsmqYILHYaXshIfoKRYWi/RFfONxLgJ6LbL6UlzzquUA3WzdVhZAe
         0gdWJ3RQ1V6hgSMU91Zc9ysDvHm5X9kLh4DGzZinpXFlheN/E37o/orV7JpjcxIkASha
         YoCobBiu67SxyVsBJah2ZVbL/Fh7VrSvu6uGvwPfjhhBzA+uLH68PVOPqZ/d8M1m/HXo
         elaJTPPy+Vcb3pYDe7R8TMxMJna/CPOFMNQz+1viZwLrbheKetKUKq+5S2/ailq18Ni0
         VSLRcaRHkb6uEByYYEUaCSeuY/+OWy6QzCfVmoc/G9HHfwIGX2ZU5Jhl+orzQzJg68h4
         WTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjQA1kPacOgH4eRJ/9nxZUj4C67EN1sFhNTSvG9bbA0=;
        b=mCzguVVjocifkw8kvjqZxLNjC9Z+RfITbNeiE4Zt7Xnp4sONPqckvdP2d+GYVooWGR
         +SRXnCZqycPa1gh2iOYqjDnbN+ANePf3ggVYQKkLWiLSdKmWkngY16xBoBSLfaHg3QzQ
         cmfKcd76CXX/xXTVsi88JSAmcSJzQTDFtmpKNYmt/TrXt/Ccx+/yucQOinBO/WTBcoNE
         weXs1KWtFDCBf0gYeKH4B26xJ9Uz6goYh2j6yLDEm0/F7sqk8Ikx13+ezWRTZO3+Cc7/
         NkD8hmhkahYUAHJYjobiV+owFwkezpwmDQBE8FtMb06wZWRmLs6liddtJkdAL9KbfPmO
         ZiqQ==
X-Gm-Message-State: ANoB5plqa5P8k2FO1eKhTMFN4/6aNJ5GGPZdhPRDr5zSBxFOp3U2PVXu
        awSwK6bGMIJqI2m0XwbRDv5s
X-Google-Smtp-Source: AA0mqf4ogBNmfdXXrBAEdihtfwso5H/VdsLLhhb0XsDPS93CJnEl1JNzDLgB51f9OVj4ZoLkFQj8DQ==
X-Received: by 2002:a65:5a88:0:b0:477:78d0:edb1 with SMTP id c8-20020a655a88000000b0047778d0edb1mr65968284pgt.587.1670432028419;
        Wed, 07 Dec 2022 08:53:48 -0800 (PST)
Received: from thinkpad ([117.202.186.122])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a67cf00b00218ec4ff0d4sm1439736pjm.6.2022.12.07.08.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:53:47 -0800 (PST)
Date:   Wed, 7 Dec 2022 22:23:39 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        bp@alien8.de, tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] dt-bindings: arm: msm: Fix register regions used
 for LLCC banks
Message-ID: <20221207165339.GB315152@thinkpad>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
 <20221207135922.314827-3-manivannan.sadhasivam@linaro.org>
 <20221207160825.nafywxehxjx42kww@builder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221207160825.nafywxehxjx42kww@builder.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 10:08:25AM -0600, Bjorn Andersson wrote:
> On Wed, Dec 07, 2022 at 07:29:11PM +0530, Manivannan Sadhasivam wrote:
> > Register regions of the LLCC banks are located at separate addresses.
> > Currently, the binding just lists the LLCC0 base address and specifies
> > the size to cover all banks. This is not the correct approach since,
> > there are holes and other registers located in between.
> > 
> > So let's specify the base address of each LLCC bank. It should be noted
> > that the bank count differs for each SoC, so that also needs to be taken
> > into account in the binding.
> > 
> > Cc: <stable@vger.kernel.org> # 4.19
> > Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  .../bindings/arm/msm/qcom,llcc.yaml           | 125 ++++++++++++++++--
> >  1 file changed, 114 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > index d1df49ffcc1b..7f694baa017c 100644
> > --- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > +++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> > @@ -33,14 +33,12 @@ properties:
> >        - qcom,sm8550-llcc
> >  
> >    reg:
> > -    items:
> > -      - description: LLCC base register region
> > -      - description: LLCC broadcast base register region
> > +    minItems: 2
> > +    maxItems: 9
> >  
> >    reg-names:
> > -    items:
> > -      - const: llcc_base
> > -      - const: llcc_broadcast_base
> > +    minItems: 2
> > +    maxItems: 9
> 
> Afaict changing llcc_base to llcc0_base would not allow the
> implementation to find the llcc_base region with an older DTB.
> 
> But if you instead modify the driver to pick up N-1 regions for base and
> the last for broadcast, by index. This should continue to work for the
> platforms where it actually worked.
> 

TBH, only platform that is supposed to work is SDM845. But on that also, some
of the registers are secured. So when the EDAC driver accesses them, it results
in reboot into EDL mode.

That's one of the reason why I didn't consider backwards compatibility here.

I may have to add a patch that removes the interrupts property from LLCC node
for this platform, as without that property EDAC driver will not be probed.

But using indexes also makes sense, so I will adapt it in next version.

> Based on that I suggest that you just remove reg-names from the binding.
> It will clean up the binding and we won't have reg-names containing
> "llcc" or "base" :)
> 

Sure.

Thanks,
Mani

> Regards,
> Bjorn
> 
> >  
> >    interrupts:
> >      maxItems: 1
> > @@ -50,15 +48,120 @@ required:
> >    - reg
> >    - reg-names
> >  
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
> > +        reg-names:
> > +          items:
> > +            - const: llcc0_base
> > +            - const: llcc_broadcast_base
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
> > +        reg-names:
> > +          items:
> > +            - const: llcc0_base
> > +            - const: llcc1_base
> > +            - const: llcc_broadcast_base
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
> > +        reg-names:
> > +          items:
> > +            - const: llcc0_base
> > +            - const: llcc1_base
> > +            - const: llcc2_base
> > +            - const: llcc3_base
> > +            - const: llcc4_base
> > +            - const: llcc5_base
> > +            - const: llcc6_base
> > +            - const: llcc7_base
> > +            - const: llcc_broadcast_base
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
> > +        reg-names:
> > +          items:
> > +            - const: llcc0_base
> > +            - const: llcc1_base
> > +            - const: llcc2_base
> > +            - const: llcc3_base
> > +            - const: llcc_broadcast_base
> > +
> >  additionalProperties: false
> >  
> >  examples:
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
> > +          reg = <0 0x01100000 0 0x50000>, <0 0x01180000 0 0x50000>,
> > +                <0 0x01200000 0 0x50000>, <0 0x01280000 0 0x50000>,
> > +                <0 0x01300000 0 0x50000>;
> > +          reg-names = "llcc0_base", "llcc1_base", "llcc2_base",
> > +                "llcc3_base", "llcc_broadcast_base";
> > +          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> > +        };
> >      };
> > -- 
> > 2.25.1
> > 

-- 
மணிவண்ணன் சதாசிவம்
