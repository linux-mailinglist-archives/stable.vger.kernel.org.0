Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC3F5FA8B4
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 01:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJJXoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 19:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJJXoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 19:44:07 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6084872FFB;
        Mon, 10 Oct 2022 16:44:06 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p16so3933428iod.6;
        Mon, 10 Oct 2022 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JGXQpUDqxnEwTxBqXBwQEZ5KNzj6zmyw1kyNu9kYUSE=;
        b=VEqaRrfWhyyGqYHS++GaZocRuEd3nh0xif6n9uJX+T6U+vm5O5SYeR3Q5jj0rgO8Cq
         qNhwRbrLdCgQi3m2/KHn7279Jemt+zTliw9noBALte9wqzL/Ihf6Nk/4qaFZKJQBhmAt
         0eTIGMIb7FjnpANS8pvcZ1tT+z6itQRm+UykSM1lsSqJInCeQY5tuZH4QrRedBP3ZLnN
         eAbTCQSD1QHEvRK4dyYwfuinkYnfOtMIlb3WhFA+hr2GNl8MmgWwN1iFNK5RAKOPVyME
         STjgnTzMfa442rkhHzfN3jUtpZyJuXQVrlD3Q30TAuluvtTv1LTvusK06PQyi0NWBgX7
         RoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JGXQpUDqxnEwTxBqXBwQEZ5KNzj6zmyw1kyNu9kYUSE=;
        b=2yOlC+zbWy/SHtI95F7HWwXSgmeMHjL19FzB0frQ0+QBfIpnYaZry+LRlQt1BjWX65
         szjT+DICElNkC8Iw7tpZ/m4REXsLIZ7KbFALV/huvdYwlBqSff9KH4msO+z+xOckTyZd
         lU1c0z4NWKxxqVwn5DezwALJKhGL/iUntFQ32J1IVWlLHSV4gphpF15fpZ5abqGDW3gv
         KWAZbjWA1TFxWctkan73T7znfLGjyqbAnhRt6p5yTImLj2vO0rOGtc1jSavB/IYs45v9
         kQWhsqtH0OqiMKRn6UFwOlhWAevOUyzf9VVvDscj0rjHTFSaz1hp0/VFpwssnG2p71LC
         DoBQ==
X-Gm-Message-State: ACrzQf3RKi/pu5d80c0Po8KyPzIfTi7uFlV1Tms1n5tAsYaaTY/aF29l
        XGhy9Pe3NRJE0fIcL2xzdSw=
X-Google-Smtp-Source: AMsMyM7uy9ysKxSzfhAJ3o38ZApkJ4J4EA0HNO9tCKB/mY40u6SxiLwggHcVon//bqOfvE8sh32r5Q==
X-Received: by 2002:a05:6638:1411:b0:363:c9fa:a6c1 with SMTP id k17-20020a056638141100b00363c9faa6c1mr1644106jad.306.1665445445649;
        Mon, 10 Oct 2022 16:44:05 -0700 (PDT)
Received: from localhost ([2607:fea8:a2e2:2d00::deb2])
        by smtp.gmail.com with UTF8SMTPSA id a8-20020a056e02120800b002f5447b47f8sm4328028ilq.33.2022.10.10.16.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 16:44:05 -0700 (PDT)
From:   Richard Acayan <mailingradian@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Acayan <mailingradian@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, agross@kernel.org,
        andersson@kernel.org, adrian.hunter@intel.com,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 39/44] mmc: sdhci-msm: add compatible string check for sdm670
Date:   Mon, 10 Oct 2022 19:43:53 -0400
Message-Id: <20221010234353.228833-1-mailingradian@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221009234932.1230196-39-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org> <20221009234932.1230196-39-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Richard Acayan <mailingradian@gmail.com>
> 
> [ Upstream commit 4de95950d970c71a9e82a24573bb7a44fd95baa1 ]
> 
> The Snapdragon 670 has the same quirk as Snapdragon 845 (needing to
> restore the dll config). Add a compatible string check to detect the need
> for this.
> 
> Signed-off-by: Richard Acayan <mailingradian@gmail.com>
> Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Link: https://lore.kernel.org/r/20220923014322.33620-3-mailingradian@gmail.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/mmc/host/sdhci-msm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index dc2991422a87..3a091a387ecb 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -2441,6 +2441,7 @@ static const struct of_device_id sdhci_msm_dt_match[] = {
>  	 */
>  	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
>  	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
> +	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},

Supporting device trees which are invalid under 6.0 schema? It's not a bug fix,
it's a feature.

Documentation/devicetree/bindings/mmc/sdhci-msm.yaml:17-49, at tag v6.0:

    properties:
      compatible:
        oneOf:
          - enum:
              - qcom,sdhci-msm-v4
            deprecated: true
          - items:
              - enum:
                  - qcom,apq8084-sdhci
                  - qcom,msm8226-sdhci
                  - qcom,msm8953-sdhci
                  - qcom,msm8974-sdhci
                  - qcom,msm8916-sdhci
                  - qcom,msm8992-sdhci
                  - qcom,msm8994-sdhci
                  - qcom,msm8996-sdhci
                  - qcom,msm8998-sdhci
              - const: qcom,sdhci-msm-v4 # for sdcc versions less than 5.0
          - items:
              - enum:
                  - qcom,qcs404-sdhci
                  - qcom,sc7180-sdhci
                  - qcom,sc7280-sdhci
                  - qcom,sdm630-sdhci
                  - qcom,sdm845-sdhci
                  - qcom,sdx55-sdhci
                  - qcom,sdx65-sdhci
                  - qcom,sm6125-sdhci
                  - qcom,sm6350-sdhci
                  - qcom,sm8150-sdhci
                  - qcom,sm8250-sdhci
                  - qcom,sm8450-sdhci
              - const: qcom,sdhci-msm-v5 # for sdcc version 5.0

I'm new to this, so I apologize if I don't understand stable kernel development.

>  	{.compatible = "qcom,sdm845-sdhci", .data = &sdm845_sdhci_var},
>  	{.compatible = "qcom,sc7180-sdhci", .data = &sdm845_sdhci_var},
>  	{},
> -- 
> 2.35.1
