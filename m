Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27855FE15E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiJMSgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJMSfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:35:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE2192DAC;
        Thu, 13 Oct 2022 11:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2997AB8205A;
        Thu, 13 Oct 2022 17:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15DBC433D7;
        Thu, 13 Oct 2022 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683991;
        bh=YvzWFopE4vb9e3aO/bHq8nJsTi5w8TgSx11JN20VUpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WBlfHyZlbueYhQzq0+dw9zi4dRKRhjWpF39CHEXPItnIE5QbDJp8KtE1+roeiP2V9
         KcRmmmQ5UEaRq+EEdaOLjioirQkIFs8CzM6v8j+fH8o/LfekRSk8kApFah3+vJGiXL
         Wr1u+F8+Ltj/Nb9mhgOoz/smhwwjA++sz8ASJel2F/yj+268TKCQFMiYFw+eh5V2OM
         7LXtkju2vNYwvJ6rYlWeUG196YSSPtI9z8w/qtBDpQG1mECXIkZ91VTgdcQ8+GxF2f
         4nu6aqd0grVQjal4mzNAjLAt+q4Yytb1OyRCoY3Dowh7TkMXp7zo93/PkLCz22yi2u
         MAOLVv2gSpFhA==
Date:   Thu, 13 Oct 2022 13:59:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Richard Acayan <mailingradian@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, agross@kernel.org,
        andersson@kernel.org, adrian.hunter@intel.com,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 39/44] mmc: sdhci-msm: add compatible string
 check for sdm670
Message-ID: <Y0hSFl3Vqo1LCpNg@sashalap>
References: <20221009234932.1230196-1-sashal@kernel.org>
 <20221009234932.1230196-39-sashal@kernel.org>
 <20221010234353.228833-1-mailingradian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221010234353.228833-1-mailingradian@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 07:43:53PM -0400, Richard Acayan wrote:
>> From: Richard Acayan <mailingradian@gmail.com>
>>
>> [ Upstream commit 4de95950d970c71a9e82a24573bb7a44fd95baa1 ]
>>
>> The Snapdragon 670 has the same quirk as Snapdragon 845 (needing to
>> restore the dll config). Add a compatible string check to detect the need
>> for this.
>>
>> Signed-off-by: Richard Acayan <mailingradian@gmail.com>
>> Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Link: https://lore.kernel.org/r/20220923014322.33620-3-mailingradian@gmail.com
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/mmc/host/sdhci-msm.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
>> index dc2991422a87..3a091a387ecb 100644
>> --- a/drivers/mmc/host/sdhci-msm.c
>> +++ b/drivers/mmc/host/sdhci-msm.c
>> @@ -2441,6 +2441,7 @@ static const struct of_device_id sdhci_msm_dt_match[] = {
>>  	 */
>>  	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
>>  	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
>> +	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},
>
>Supporting device trees which are invalid under 6.0 schema? It's not a bug fix,
>it's a feature.

Does this not enable hardware to work properly? We take quirks/device
enablement into stable tree as well.

-- 
Thanks,
Sasha
