Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89A35FE65B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 02:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJNAhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 20:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJNAhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 20:37:51 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8611905E4;
        Thu, 13 Oct 2022 17:37:50 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h203so2776351iof.1;
        Thu, 13 Oct 2022 17:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgPEys1VCx1K7kqM8PPoq2y4bBaRnFBAQZvggl7CXEo=;
        b=BZ8antzv7XPgQvBEuJhXDhAUOetSSnd51IVdfCMStcWebn/oe6F6z0ba5Z4s3Um9/x
         tV1f9T2A+0eXFLkTItk+SSpUaQOsmeh816pPGkLdIrWzTwt+Z717g2LY3rQjHYnBCJfx
         4xis8UQpAiyo3u/UGMl6kMCgGwrq9eQNtl2K2FajBETiRaQJQ0x0r6UWkiXkN48gS4Ds
         iSkHoCn96U+Ybs12C3v6yxbnnsTheUCbvwiBh2zVa70fAMj42XKC2K+cgO1ZGluqnrm0
         +izmWKS96+FujbSctc8XzwJV/Gf9B9AAnctcPAcjjpqcdMyCXQf10x+Lpn41WhA2h1Y5
         MHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DgPEys1VCx1K7kqM8PPoq2y4bBaRnFBAQZvggl7CXEo=;
        b=yHT6G4WUf/pVfP6aCrdq90vFl9lHyWIISjqMr7CA+xKZ6PPaHzCUhYaFsKLt86qgHP
         9ipfZWV4zCXaDZ+xFbShrwxL31gVpqV2afvjMnrP3iq5Yp/afkV2RRfmdtIU447elZim
         bCjEYTzmpcLprqJak+JVPH/Sw0Jxt+ldZIIdFQoSxRRIYg3CxLj1YKQplzW88T9B27r+
         6q8jNPQq1Pkd9U4iw3HKW9mzp7PLWK9laYXTtr2BNiA/+rJHm5J9nvb1yZWxYe68y8qj
         1lq2NuP3OUGBCmcFSUXJ4fox2lGW+SCZ9dsSxhOI/nWv+MPRCtNmGJlJePpQSOT15jBb
         JpvQ==
X-Gm-Message-State: ACrzQf11opt3pMZeEUB5iWglfb1UGg9Xu80iwjs8qQa9KkesvH90qDig
        TOQ7ccaJL9h5pGsFuoUv6t8=
X-Google-Smtp-Source: AMsMyM6+zjQjHrJM7xb4doRmBa/MhhGmNjI8G+UJVi0TCsRNUDWYbQ7dT6OEvJ4oh9MiyCT6kVF01w==
X-Received: by 2002:a05:6638:438a:b0:363:abe5:9c8 with SMTP id bo10-20020a056638438a00b00363abe509c8mr1422099jab.301.1665707870309;
        Thu, 13 Oct 2022 17:37:50 -0700 (PDT)
Received: from localhost ([2607:fea8:a2e2:2d00::3fc2])
        by smtp.gmail.com with UTF8SMTPSA id d13-20020a92680d000000b002eb3b43cd63sm404160ilc.18.2022.10.13.17.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 17:37:49 -0700 (PDT)
From:   Richard Acayan <mailingradian@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, agross@kernel.org,
        andersson@kernel.org, adrian.hunter@intel.com,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 39/44] mmc: sdhci-msm: add compatible string check for sdm670
Date:   Thu, 13 Oct 2022 20:37:44 -0400
Message-Id: <20221014003744.6437-1-mailingradian@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <Y0hSFl3Vqo1LCpNg@sashalap>
References: <20221009234932.1230196-1-sashal@kernel.org> <20221009234932.1230196-39-sashal@kernel.org> <20221010234353.228833-1-mailingradian@gmail.com> <Y0hSFl3Vqo1LCpNg@sashalap>
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

> On Mon, Oct 10, 2022 at 07:43:53PM -0400, Richard Acayan wrote:
>>> From: Richard Acayan <mailingradian@gmail.com>
>>>
>>> [ Upstream commit 4de95950d970c71a9e82a24573bb7a44fd95baa1 ]
>>>
>>> The Snapdragon 670 has the same quirk as Snapdragon 845 (needing to
>>> restore the dll config). Add a compatible string check to detect the need
>>> for this.
>>>
>>> Signed-off-by: Richard Acayan <mailingradian@gmail.com>
>>> Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> Link: https://lore.kernel.org/r/20220923014322.33620-3-mailingradian@gmail.com
>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  drivers/mmc/host/sdhci-msm.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
>>> index dc2991422a87..3a091a387ecb 100644
>>> --- a/drivers/mmc/host/sdhci-msm.c
>>> +++ b/drivers/mmc/host/sdhci-msm.c
>>> @@ -2441,6 +2441,7 @@ static const struct of_device_id sdhci_msm_dt_match[] = {
>>>  	 */
>>>  	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
>>>  	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
>>> +	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},
>>
>>Supporting device trees which are invalid under 6.0 schema? It's not a bug fix,
>>it's a feature.
> 
> Does this not enable hardware to work properly? We take quirks/device
> enablement into stable tree as well.

It does, given that there are no device tree dependency issues. Thanks for the
clarification.
