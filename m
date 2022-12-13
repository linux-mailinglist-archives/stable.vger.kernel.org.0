Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F377564BACE
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLMRQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiLMRQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:16:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB02D11E
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:16:55 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id s196so293477pgs.3
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NmYDZU11nklc+tzMmUwahX1BZ8SL82PffaoR0JHcaqM=;
        b=PEO23n/pcpdK2ZCNaXgzQHxOvQrCbJU5CS++mVujrC/4KT+2y72fJ0YeYSZ47Cz6vG
         AiyoUpzARyAT3RbpeYqOZ1utkA9Iym4mmZpO9KFuaTHkV4FqVxR30vcstfBCqeRDDocD
         gtym1YmFMKsGAnHv21Z65DZPxMt+FMdPJJDWQGVZS6iUZSos6eMY03waRa42i6l12q8B
         w6K0iiyS9AYsycclK/BdSPBKw31XA/bMpNS8gx5yHUzW2vIJ+jgz9KBsg+8vBqSBpmh7
         eWNLwtQFw5fNyaOVggZXEh7CAcTfntEU0tMTkqVcFen+O60bsX2MCcl3nTA15vnALjm1
         PVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NmYDZU11nklc+tzMmUwahX1BZ8SL82PffaoR0JHcaqM=;
        b=pOjZ6spSGz7pocQjBdyedF6yjmV7VHATmM5C8tjGI6OEFOia1ZSbzomTViPNO99zJu
         lcPA3jCr71U5Ghin1G7zHXRSbqoL0n0RnIzaVDIRujNu04YFlhsdnBlzzfOFKK+XvKl4
         7i1uS8Bizf+1mbeMOhYpUhIUdlyDjTuO/u7gJ7Yy6xHTAzLXbaGM75+sfO2e9H5jgy/v
         PQ5yrfIj202DUC6H+07BqMKGUmkbfDIfFbeIFrN3skmqXFZQAgfRzskwj6vqUlM1OVga
         U+adbIlJ54BxmG4zXltS6Ih2vwjHjFuUdbWXSb9gs/tZBqF9xhf4Ai5EmCtNV21sjm66
         VWkg==
X-Gm-Message-State: ANoB5pn3yVu2O6ULTDZSf2viVReERYlkVp43S74rzx/MXQitY/MJ9jxj
        Exr9QI4GJfDjAvCOSdU1NRrV
X-Google-Smtp-Source: AA0mqf7E+4z5rJUSuBENaRVoW/8hRKN5T2vCU8OIH+2aeLMhIKU6gFugNjrJ1w8TXcrX5SAwBJnIEw==
X-Received: by 2002:a05:6a00:791:b0:577:f836:6bcb with SMTP id g17-20020a056a00079100b00577f8366bcbmr19139798pfu.29.1670951814589;
        Tue, 13 Dec 2022 09:16:54 -0800 (PST)
Received: from thinkpad ([27.111.75.5])
        by smtp.gmail.com with ESMTPSA id e27-20020aa798db000000b00576d4c45a22sm8171855pfm.147.2022.12.13.09.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:16:53 -0800 (PST)
Date:   Tue, 13 Dec 2022 22:46:47 +0530
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
Subject: Re: [PATCH v2 04/13] arm64: dts: qcom: sc7180: Remove reg-names
 property from LLCC node
Message-ID: <20221213171647.GE4862@thinkpad>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-5-manivannan.sadhasivam@linaro.org>
 <e57ffec7-6757-5cd8-7764-28f6edb95985@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e57ffec7-6757-5cd8-7764-28f6edb95985@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 05:30:09PM +0100, Krzysztof Kozlowski wrote:
> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> > The LLCC block has several banks each with a different base address
> > and holes in between. So it is not a correct approach to cover these
> > banks with a single offset/size. Instead, the individual bank's base
> > address needs to be specified in devicetree with the exact size.
> > 
> > On SC7180, there is only one LLCC bank available. So only change needed is
> > to remove the reg-names property from LLCC node to conform to the binding.
> > 
> > The driver is expected to parse the reg field based on index to get the
> > addresses of each LLCC banks.
> > 
> > Cc: <stable@vger.kernel.org> # 5.6
> 
> Oh, no, there is no single bug here. Binding from v5.6+ (which cannot be
> changed) required/defined such reg-names. This is neither a bug nor
> possible to backport.
> 
> > Fixes: c831fa299996 ("arm64: dts: qcom: sc7180: Add Last level cache controller node")
> 
> Drop.
> 
> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> > index f71cf21a8dd8..b0d524bbf051 100644
> > --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> > @@ -2759,7 +2759,6 @@ dc_noc: interconnect@9160000 {
> >  		system-cache-controller@9200000 {
> >  			compatible = "qcom,sc7180-llcc";
> >  			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
> > -			reg-names = "llcc_base", "llcc_broadcast_base";
> 
> That's an ABI break...
> 

As agreed, I will keep reg-names in dts for now.

Thanks,
Mani

> >  			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> >  		};
> >  
> 
> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்
