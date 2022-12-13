Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1726964BAD6
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiLMRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiLMRSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:18:02 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6288C20F4E
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:18:01 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g10so444611plo.11
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bb5I9Y8wwJqoJVL/Ou+j3ICDvpki0+hAanc50qTXXeA=;
        b=FioCRD8KRxJEX/297VGm/pFweea/2Q0CHf9n5gl6IjwwdBBrd95Px1yVQ4QXFak46k
         IZ/xlVDdjWsnG9R4IZXmIKPA63HifxDo1bDOCITZI39mk2DHV2UX5jSSDb0QVHXHWeW0
         7k7lytWio3RT5sVKQaZPn0F0Sv0K4/pwdI+DCr3Q7VGSOc4L83pwvPUl+GvKl+SQuJwO
         UHZF2AHS5J+DIr/qbSSZ3owaPQ7cI1lVZRgaZMPJXxTc1hqDOxdozkkUa1ykpFGAdKP3
         KyuiME2kdWriG8Vj0I/Veln6mhGZLtlnU7v+ByHGD8zGh8tKyshaVxbMuWbdKeNGO5hW
         k2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb5I9Y8wwJqoJVL/Ou+j3ICDvpki0+hAanc50qTXXeA=;
        b=DpJlCzENxJqk/IHolYezgEqX1Lj0jyxYvRvkc+cvvimtJOgI7WyAsCzZhhCM0qlo8B
         uI3yPZ0F8YElFcnjJ58VNrUM4sZmfKwPTcVBXdHaJ60PwsSOCSQFympd9hQP4CIzEW7y
         MdFx9UU5/m01jf1UJ0NussqTY+tukV0hPq/MriNv1AIIHTPiProbHA3zbHqXIEUS/pgS
         6qHqCE7gbuRk2gBV6T7xukA2wfBns95GqtJbssRmgX+NgnQ2G9XHqVoPeat1HG3IW1h+
         og2qWgefQlQddXd6EswbKb1eSF+rFxJrsqd2Rt66013zayQc4ZfK9McsiXh9difdNZNe
         mPWA==
X-Gm-Message-State: ANoB5pnzQWsSmVVGwnME/IXodWvS7Uk//ITmSHiwepgDr4I7TLwF5Zz8
        nrPVrktl2DrQYcbex1kKeWjK
X-Google-Smtp-Source: AA0mqf4CmmkS1sGFDo6pbGxgzxTrOf+YmmXgILC1t4Aoupn3XzFTGMzrcOcJYqzwt0dxh9/FYFD04g==
X-Received: by 2002:a17:903:507:b0:189:57ec:f697 with SMTP id jn7-20020a170903050700b0018957ecf697mr20190735plb.48.1670951880807;
        Tue, 13 Dec 2022 09:18:00 -0800 (PST)
Received: from thinkpad ([27.111.75.5])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902d05100b00186f608c543sm99995pll.304.2022.12.13.09.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:17:59 -0800 (PST)
Date:   Tue, 13 Dec 2022 22:47:54 +0530
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
Subject: Re: [PATCH v2 11/13] arm64: dts: qcom: sm6350: Remove reg-names
 property from LLCC node
Message-ID: <20221213171754.GF4862@thinkpad>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-12-manivannan.sadhasivam@linaro.org>
 <e87ac9f3-e0ce-bd4c-6e2c-d57adb0c9169@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e87ac9f3-e0ce-bd4c-6e2c-d57adb0c9169@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 05:31:40PM +0100, Krzysztof Kozlowski wrote:
> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> > The LLCC block has several banks each with a different base address
> > and holes in between. So it is not a correct approach to cover these
> > banks with a single offset/size. Instead, the individual bank's base
> > address needs to be specified in devicetree with the exact size.
> > 
> > On SM6350, there is only one LLCC bank available. So only change needed is
> > to remove the reg-names property from LLCC node to conform to the binding.
> > 
> > The driver is expected to parse the reg field based on index to get the
> > addresses of each LLCC banks.
> > 
> > Cc: <stable@vger.kernel.org> # 5.16
> > Fixes: ced2f0d75e13 ("arm64: dts: qcom: sm6350: Add LLCC node")
> 
> This is a definitive no go. There is no bug here and such change cannot
> be backported.
> 
> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> 
> What is the bug here which deserves a credit? reg-names in v5.16 were
> perfectly correct.
> 

If the driver gets backported to v5.16, it won't. But anyway, this property
will stay in dts.

Thanks,
Mani

> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sm6350.dtsi | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
> > index 43324bf291c3..1f39627cd7c6 100644
> > --- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
> > @@ -1174,7 +1174,6 @@ dc_noc: interconnect@9160000 {
> >  		system-cache-controller@9200000 {
> >  			compatible = "qcom,sm6350-llcc";
> >  			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
> > -			reg-names = "llcc_base", "llcc_broadcast_base";
> >  		};
> >  
> >  		gem_noc: interconnect@9680000 {
> 
> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்
