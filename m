Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4964BAB5
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiLMROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiLMROJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:14:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580E7D11E
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:14:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so4238979pje.5
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dwsi4XK3nypjad6xn89/3e9RdwQ2gxMpiVm425namZk=;
        b=bhNjhbviV/wfSfKS13Fws26P5KRs9qbgQCtrwQChwkOQvxooc002D2czyQGQbytYPB
         LolVht+FJ7xstmMWPAX23Y30qyN6mMHEu77143uOi/4hLsMmFp5OXUg0ESXfOjUErwXj
         nxg00ndEFcEHo6vb9RSYhGRSbfP6XH4XylFuRNt0IuFe2nV+VNJX/DGRUG6NRI37YEYQ
         D6q+Q89r6OPau3zhY7M9BeFWVRYepxS6imVF9kXC/F2uUG0PeYgXBMJJ2zc+kBQJmDCN
         0kFn9g0sYgJFVysA0v3GhPfSDHhwRcd/i0fi4UevAnohPDe80Sd807YgfgzsKANJ/sPT
         x4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dwsi4XK3nypjad6xn89/3e9RdwQ2gxMpiVm425namZk=;
        b=S/phypj8EzmQMKSWTjCXS1Ue7W4rFaNr20LYomIygPymEdLDRUjCLogK2B7NRzBrHl
         zWeLE7Cp7WhpKu8fK1QvWQuqJwNVWb4z2PEEFdrqsDwua4ege8mXVHI/KAr1OlxWaADt
         09y3MnjUo1sBokbvbfZ7fYfpjbOHsJcasIaGOrmvdeAaUEoNfCDM6D7odXe0LXQ9xIQr
         5iv/y+7UP6YwwMI08R4GaYMgNZWsAUyYpmbIl7GSjIwvSO/0eSGmcccRUCVtrxW3ZhdN
         myfRROkAkauUHoO/8/3eSgwY34rnwbP5KeBSuYdg/BVXz2ee496DASWmcC+3t3eGLDEd
         i5mQ==
X-Gm-Message-State: ANoB5plChytpvO5OWBkVi+wmTZeqFFBpJ/9+IXJ5+/tP2it9CrV9co/W
        x+SFQN2vQhLj+e160TqIGOLX
X-Google-Smtp-Source: AA0mqf4VEGrh9kRZw/kVcazlPNbSmzR1tCkBU8kk1z9hAaDmC9KFy+HjK81iS3KAvR1FjSKvFYoKDA==
X-Received: by 2002:a17:902:d4d1:b0:189:e7e:784c with SMTP id o17-20020a170902d4d100b001890e7e784cmr31284779plg.21.1670951646763;
        Tue, 13 Dec 2022 09:14:06 -0800 (PST)
Received: from thinkpad ([27.111.75.5])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090332ce00b001869394a372sm123384plr.201.2022.12.13.09.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:14:05 -0800 (PST)
Date:   Tue, 13 Dec 2022 22:43:56 +0530
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
Subject: Re: [PATCH v2 03/13] arm64: dts: qcom: sdm845: Fix the base
 addresses of LLCC banks
Message-ID: <20221213171356.GD4862@thinkpad>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-4-manivannan.sadhasivam@linaro.org>
 <038e6569-9f8f-3b59-0243-af6dcf0c2d80@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <038e6569-9f8f-3b59-0243-af6dcf0c2d80@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 05:27:45PM +0100, Krzysztof Kozlowski wrote:
> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> > The LLCC block has several banks each with a different base address
> > and holes in between. So it is not a correct approach to cover these
> > banks with a single offset/size. Instead, the individual bank's base
> > address needs to be specified in devicetree with the exact size.
> > 
> > Also, let's get rid of reg-names property as it is not needed anymore.
> > The driver is expected to parse the reg field based on index to get the
> > addresses of each LLCC banks.
> > 
> > Cc: <stable@vger.kernel.org> # 5.4
> 
> No, you cannot backport it. You will break users.
> 

If the driver change gets backported, it will break users, isn't it?

> > Fixes: ba0411ddd133 ("arm64: dts: sdm845: Add device node for Last level cache controller")
> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sdm845.dtsi | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > index 65032b94b46d..683b861e060d 100644
> > --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > @@ -2132,8 +2132,9 @@ uart15: serial@a9c000 {
> >  
> >  		llcc: system-cache-controller@1100000 {
> >  			compatible = "qcom,sdm845-llcc";
> > -			reg = <0 0x01100000 0 0x31000>, <0 0x01300000 0 0x50000>;
> > -			reg-names = "llcc_base", "llcc_broadcast_base";
> 
> Once property was made required, you cannot remove it. What if other
> bindings user depends on it?
> 
> Please instead keep/update the reg-names and/or mark it as deprecated.
> It must stay in DTS for some time.
> 

Fair enough. I will mark it as deprecated in binding and will keep it in dts.

Thanks,
Mani

> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்
