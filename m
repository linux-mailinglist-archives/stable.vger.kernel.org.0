Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F665B3D74
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 18:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiIIQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 12:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiIIQvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 12:51:14 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4543D59A
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 09:50:51 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s10so1920842ljp.5
        for <stable@vger.kernel.org>; Fri, 09 Sep 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=O9FowbIs62g6VcoOUNjt1bKmyMiLJOoWtlkCshtX0Fg=;
        b=HxfxZkCrYWrP5oC/dAO7XCw0lY9M6rHKMudvwSVsQfpO6bWusxC2iZUY2+gi4OXpWw
         JifIGrWiP4kq1vy0hBAx8QYqpa8LqeEkqtnQj63e/E/Ncx7+QIWkfsL/xgRKpJVv5awB
         O7q1TIIYjXLqu/seLPO3qOjB7rFZog+yeHdEe88EoKtKrrKVj9kQ20IL6FBcwAGZ3zwL
         WZangDDIiz75B563jQ2ITB3lxszPM+JvDTQdWqthTOhGqPfaf/ekpTQ49GjsxKCqBy6N
         gNjZlQ1bsD7ESAacfi5s4RMwMgoWvAXSm7is8Em53Ij3SMnTRLIMt+0DUJZplHB6jHfV
         lXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=O9FowbIs62g6VcoOUNjt1bKmyMiLJOoWtlkCshtX0Fg=;
        b=gbtH3QE5zEc253urweIC5uk8MRTr8bjkRslLE2CJne0fjDi1/y60JPispHmoxcxbyT
         YOfB+yWhkx7qWyduN+64pBUxp66WFEk0jdk3IkNiKUvmkvqkPtikzKEhYEFKq5aZ7nSL
         81mlVdfuhg/+8pL5b63+368pLFZ06nkWVl/TIxrVIHu14lTfVAw0Ew+yEPTQE2hnUJBg
         4zsio85biAS6FUlGCBG2oAh99r6JlY+9TIzUe0wzSHRUkWBjeNtiVBjPPplr6hfRk5+g
         Es3QMdCmz8SE4Rg2S+2ZA22thLyAi7BAIrnI4RSSGuc0GP+aA2Ne4dTJzt+rYEos5YAj
         GI7w==
X-Gm-Message-State: ACgBeo32TgCUm86QViYJcEBu30E33A2vq1nlxvj5hIjPTafWj/jPCuk/
        Y+BnxGmNUaQWDrTWX+gqYlr/+g==
X-Google-Smtp-Source: AA6agR7nLZO3mdmBv9Mmtc1qPnXOMQHqwzHQeSIz2JK3SZX4Ex5MDsmolP63sATF1fuETKuLJilslw==
X-Received: by 2002:a05:651c:1044:b0:26b:ece0:b1f3 with SMTP id x4-20020a05651c104400b0026bece0b1f3mr100866ljm.526.1662742249694;
        Fri, 09 Sep 2022 09:50:49 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id m13-20020a056512358d00b00497ad9ae486sm151829lfr.62.2022.09.09.09.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 09:50:49 -0700 (PDT)
Message-ID: <2a5fe53e-4bc2-c2f5-44d1-3cb7bd0c71ef@linaro.org>
Date:   Fri, 9 Sep 2022 18:50:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] regulator: qcom_rpm: Fix circular deferral regression
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        linux-arm-msm@vger.kernel.org
References: <20220909112529.239143-1-linus.walleij@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220909112529.239143-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/09/2022 13:25, Linus Walleij wrote:
> On recent kernels, the PM8058 L16 (or any other PM8058 LDO-regulator)
> does not come up if they are supplied by an SMPS-regulator. This
> is not very strange since the regulators are registered in a long
> array and the L-regulators are registered before the S-regulators,
> and if an L-regulator defers, it will never get around to registering
> the S-regulator that it needs.
> 
> See arch/arm/boot/dts/qcom-apq8060-dragonboard.dts:
> 
> pm8058-regulators {
>     (...)
>     vdd_l13_l16-supply = <&pm8058_s4>;
>     (...)
> 
> Ooops.
> 
> Fix this by moving the PM8058 S-regulators first in the array.
> 
> Do the same for the PM8901 S-regulators (though this is currently
> not causing any problems with out device trees) so that the pattern
> of registration order is the same on all PMnnnn chips.
> 
> Fixes: 087a1b5cdd55 ("regulator: qcom: Rework to single platform device")
> Cc: stable@vger.kernel.org
> Cc: Andy Gross <agross@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
> Cc: linux-arm-msm@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/regulator/qcom_rpm-regulator.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
> index 7f9d66ac37ff..3c41b71a1f52 100644
> --- a/drivers/regulator/qcom_rpm-regulator.c
> +++ b/drivers/regulator/qcom_rpm-regulator.c
> @@ -802,6 +802,12 @@ static const struct rpm_regulator_data rpm_pm8018_regulators[] = {
>  };
>  
>  static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
> +	{ "s0",   QCOM_RPM_PM8058_SMPS0,  &pm8058_smps, "vdd_s0" },
> +	{ "s1",   QCOM_RPM_PM8058_SMPS1,  &pm8058_smps, "vdd_s1" },
> +	{ "s2",   QCOM_RPM_PM8058_SMPS2,  &pm8058_smps, "vdd_s2" },
> +	{ "s3",   QCOM_RPM_PM8058_SMPS3,  &pm8058_smps, "vdd_s3" },
> +	{ "s4",   QCOM_RPM_PM8058_SMPS4,  &pm8058_smps, "vdd_s4" },
> +

Would be great to have here a comment like "S-regulators (being used as
supplies) must come before the rest".

Same also in second table.

We like to re-order some things from time to time and no one would think
about checking Git history for any issues with it.

Best regards,
Krzysztof
