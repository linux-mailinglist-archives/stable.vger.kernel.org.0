Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F16A17A8
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 09:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBXIDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 03:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjBXIDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 03:03:13 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADEA27D71
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:03:11 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l25so12601475wrb.3
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CPluoQMOkdFe2Sa5U9SyXRVN40WIY8W5okzJaoRdoj4=;
        b=dU3IpnmqlGqaHKN8F6/Ar/A3HuRIAZNuZ98SOlvtHzAk/fi8+5wd+7RUX2abJT8YAx
         olWnIZ2fSrx95gfLwk7Z7w1TkNjJgSBqRn/gFxV9g4i8FGFNjx+6FTOxGNFCWQ9ONcR7
         6LokqcrF+qb4NwV+NavKTlVYnglSfEXa/GIKRN+Ax9acsorBSF0/zeic0uTyH6/R+QLs
         EM8mLiuNUkBKQUQnRQ0hxPoGhk5+ie0G9ezJmThg0PYQS18VLXSw9p2ntjqcHPUuFJG8
         Gls9YK9he5+svTbMQTxb9CylqLQAAf9LisdxoWFT9eTogFO39gH9Y0ehGAIs2H5niurm
         m+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPluoQMOkdFe2Sa5U9SyXRVN40WIY8W5okzJaoRdoj4=;
        b=0myfOPF/f4yJcO6D1apdP0fzR4h4OjcR9R2foZNdsYirl8kAhTsLakccrgw0HZupU0
         t44R8AwrU56ZlwmW01iydD4N5FMs8ySuLdv7VHFNWK68cru61nerOFP8MjQ+V/Et7E6o
         aCYPIekgxi1wn51FRV+ihK5aClTAQ6w1L++0D70PSO4LVjulLxIqhblYaXlolzJHodCh
         3vOnS84WpmyhtTyLOvtJDeZeA5/bHxxaDScU7sMxEH2/wsYEm2OYMp0qjHJmCdwKgZmO
         vwH/pXXE0m9evF81+tBBh24hq0/cCiSKrHH6YDH15Du2poKEpJTRL6X7glUF58eT4ovr
         jokQ==
X-Gm-Message-State: AO0yUKW7b4yep80ie7TO9jUcc9JxA66LyFDxglJMx3LsAZiRdLo9quJK
        9UdJMvGqqdzTs1o5UXDgPc23BJGxhgaXSGRGmlfeOw==
X-Google-Smtp-Source: AK7set/rBOumgljbhDtIArm700oTnvpDNRJ0E9MhtS9R1JCMjRfY7Jh/q6i90kPnlwa5aLYRzNCiDLSH+DAHJIYkPlM=
X-Received: by 2002:adf:d4c6:0:b0:2c7:1a97:ef91 with SMTP id
 w6-20020adfd4c6000000b002c71a97ef91mr380000wrk.1.1677225789964; Fri, 24 Feb
 2023 00:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20230224080045.6577-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20230224080045.6577-1-manivannan.sadhasivam@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Fri, 24 Feb 2023 13:32:45 +0530
Message-ID: <CAH=2NtwdosY2FaWTcBvVs_-S6=ZC5uBh6S+jS7Ck7h9+MUJzKg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sm8150: Fix the iommu mask used for
 PCIe controllers
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@linaro.org, quic_vkamble@quicinc.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Feb 2023 at 13:30, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> The iommu mask should be 0x3f as per Qualcomm internal documentation.
> Without the correct mask, the PCIe transactions from the endpoint will
> result in SMMU faults. Hence, fix it!
>
> Cc: stable@vger.kernel.org # 5.19
> Fixes: a1c86c680533 ("arm64: dts: qcom: sm8150: Add PCIe nodes")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8150.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> index fd20096cfc6e..13e0ce828606 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -1826,7 +1826,7 @@ pcie0: pci@1c00000 {
>                                       "slave_q2a",
>                                       "tbu";
>
> -                       iommus = <&apps_smmu 0x1d80 0x7f>;
> +                       iommus = <&apps_smmu 0x1d80 0x3f>;
>                         iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
>                                     <0x100 &apps_smmu 0x1d81 0x1>;
>
> @@ -1925,7 +1925,7 @@ pcie1: pci@1c08000 {
>                         assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
>                         assigned-clock-rates = <19200000>;
>
> -                       iommus = <&apps_smmu 0x1e00 0x7f>;
> +                       iommus = <&apps_smmu 0x1e00 0x3f>;
>                         iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
>                                     <0x100 &apps_smmu 0x1e01 0x1>;
>

Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Thanks.
