Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FE667233D
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 17:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjARQaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 11:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjARQ3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 11:29:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4514754113
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 08:27:05 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id z13so9595982plg.6
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 08:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PnIT1ZOLzxJX6WD//TaGrhIYfVz9ufKdiV7vsF/iRQM=;
        b=oyNLlxOA4h9fIFeFYgsQYpQBXl331UIiaWIGE+I8+2VKXi/tAvWIFIGMY/+R+RitkD
         ZLgs6rwtFHI0fdK1yebai2/rpR2R7ohI4Hou1mSzpXW274rGY143NsnzU47AAB//rnqY
         Wv9envguaPCsvQSGp9M5BmODhROqcKUOLqcHLhxMJwvu2nkHFMkgksHHfp2z1i1f1oPG
         NzmTwEnqP0/D92dYyv+UoXLqlR63a8yYs0QmAEaxl6tKn/mXVOSDWY/AbHsSnRGOn9es
         CaPipCYwHvdeYNt7JmOqIQKrWTDL0G0kXU8fmyQlrSsle1J6stnovg7FHLRI4akneThf
         k4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnIT1ZOLzxJX6WD//TaGrhIYfVz9ufKdiV7vsF/iRQM=;
        b=tIuka1u2hHQo9X+WHzIXhj4pCK48DnrPl3mkH/ZePDuBC/UOzbcjiusIhOnEQAtJOP
         Kb0u+CsSYBK1TATDrP9WB4bGRJ5Q7a30saaPZx9SCOLVhY5PV0OMwreV6s5ApsJ2YdLp
         /FRkiOzBBaavYkJEkFoKO4p7HteNUZk0l+CzSju5BpRAH+e7i0woUQzHkyxT9s4Z5G1c
         OKBvTjEAPO+QLqxeE54h5DQpGyh2PN+XQoJ1lxsvDlcqAPuWULcaYYC0gKsF+6vZqAbC
         xE/X/sxwg6xtvfvehm0FGL1RHF1Benjv+bzqcwsLJjQLJVVZkV1qcJRI78zY89krYUxS
         AFfQ==
X-Gm-Message-State: AFqh2krEuI7Uc+EAPwo5DiJo/sNhQWCIt7jUYOpxtojCqwvcUgDbFpNH
        q4H9WhREp69MYFJbNASrcvKC
X-Google-Smtp-Source: AMrXdXvvDlhhZoU7y/wT2VNk0daUJAuDCDa1GEO7xu7ndvUK9lrvpG0UpYaPKFREDviZj/98AsTgiQ==
X-Received: by 2002:a05:6a20:3ca7:b0:9d:efbf:48e3 with SMTP id b39-20020a056a203ca700b0009defbf48e3mr9897658pzj.39.1674059224894;
        Wed, 18 Jan 2023 08:27:04 -0800 (PST)
Received: from thinkpad ([220.158.158.171])
        by smtp.gmail.com with ESMTPSA id x15-20020aa78f0f000000b00587fda4a260sm6021014pfr.9.2023.01.18.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:27:03 -0800 (PST)
Date:   Wed, 18 Jan 2023 21:56:57 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        ahalaney@redhat.com, steev@kali.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 17/17] soc: qcom: llcc: Do not create EDAC platform
 device on SDM845
Message-ID: <20230118162657.GE4690@thinkpad>
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-18-manivannan.sadhasivam@linaro.org>
 <d3cd9b7a-6286-a140-d205-6d4b6ca8092d@linaro.org>
 <20230118155919.GD4690@thinkpad>
 <3ca41414-df2e-4ba0-9dc7-cacea2413fe6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ca41414-df2e-4ba0-9dc7-cacea2413fe6@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 05:05:28PM +0100, Krzysztof Kozlowski wrote:
> On 18/01/2023 16:59, Manivannan Sadhasivam wrote:
> > On Wed, Jan 18, 2023 at 04:37:29PM +0100, Krzysztof Kozlowski wrote:
> >> On 18/01/2023 16:09, Manivannan Sadhasivam wrote:
> >>> The platforms based on SDM845 SoC locks the access to EDAC registers in the
> >>> bootloader. So probing the EDAC driver will result in a crash. Hence,
> >>> disable the creation of EDAC platform device on all SDM845 devices.
> >>>
> >>> The issue has been observed on Lenovo Yoga C630 and DB845c.
> >>>
> >>> Cc: <stable@vger.kernel.org> # 5.10
> >>> Reported-by: Steev Klimaszewski <steev@kali.org>
> >>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> >>> ---
> >>>  drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
> >>>  1 file changed, 12 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> >>> index 7b7c5a38bac6..8d840702df50 100644
> >>> --- a/drivers/soc/qcom/llcc-qcom.c
> >>> +++ b/drivers/soc/qcom/llcc-qcom.c
> >>> @@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
> >>>  
> >>>  	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
> >>>  
> >>> -	llcc_edac = platform_device_register_data(&pdev->dev,
> >>> -					"qcom_llcc_edac", -1, drv_data,
> >>> -					sizeof(*drv_data));
> >>> -	if (IS_ERR(llcc_edac))
> >>> -		dev_err(dev, "Failed to register llcc edac driver\n");
> >>> +	/*
> >>> +	 * The platforms based on SDM845 SoC locks the access to EDAC registers
> >>> +	 * in bootloader. So probing the EDAC driver will result in a crash.
> >>> +	 * Hence, disable the creation of EDAC platform device on SDM845.
> >>> +	 */
> >>> +	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {
> >>
> >> Don't spread of_device_is_compatible() in driver code. You have driver
> >> data for this.
> >>
> > 
> > Yeah, but there is no ID to in the driver data to identify an SoC. 
> 
> What do you mean there is no? You use exactly the same compatible as the
> one in driver data.
> 

Right, but I was saying that there is no unique field to identify an SoC.

> 
> > I could add
> > one but is that really worth doing so? Is using of_device_is_compatible() in
> > drivers discouraged nowadays?
> 
> Because it spreads variant matching all over. It does not scale. drv
> data fields are the way or better quirks/flags.
> 

The driver quirk/flags are usually beneficial if it applies to multiple
platforms, otherwise they are a bit overkill IMO just like in this case.

One can argue that this matching could spread to other SoCs in the future, but
I don't think that could happen for this case.

Thanks,
Mani

> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்
