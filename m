Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6051751AF8E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 22:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378318AbiEDUpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 16:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378287AbiEDUpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 16:45:07 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58684BFEE
        for <stable@vger.kernel.org>; Wed,  4 May 2022 13:41:27 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-ed9ac77cbbso2416185fac.1
        for <stable@vger.kernel.org>; Wed, 04 May 2022 13:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PD59mLgiqRcQ+Fdrqp/4fu8JOTZ22Tyt+kTZ89/+32Q=;
        b=gZTt6iVe0MqN5tAT18d3FDms6ZM3dJC+I6gu+eXbyciKPXBvew3JMiPs4nmWBj7ONp
         Zv3Tat9GZfq/7fd0hWECg+STtp/DvtMYXlxT0gtH+lrJvMJ2hHZp6rGRVfv16pvbdRs4
         /CnOV6nQ0U0dfAO+A38ReGKui1P4LqBeBHdPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PD59mLgiqRcQ+Fdrqp/4fu8JOTZ22Tyt+kTZ89/+32Q=;
        b=PRLZthWNQE2M1I+C1QDTeJWqoI+iHjRAISQSQINPMmEXTU0KCbuotiqGqEnAHXTPmB
         ZfqsnyPrGwioLnTTInx5u7l0sNTxcPM7Qsy2hYjIiCKjTIbBv4V9/nbi8xZTdNFii4fu
         y9oq1zm8BQT4nJ08Wt29hBkRyHjFLXg09QdWoopckHkOaBhHaT5cnp4q5+TEXYukUTZa
         V6oArdtkswmM1NsMSIHl7VSbk1MXMhHE38iLiy4phLuAXsHJizM0JEYMr13xKM4jYX/V
         6CNS4gxj7PDyJeTVz54Uv3ul/rAwR6yZdrMlsr71p5D+U6rqx6tlAxebr7xatGlk4AJv
         qxHQ==
X-Gm-Message-State: AOAM533lDTO62aHDCWYS03qX2eOPWQzcT8Wql0PLv17j6kU5QnDh9wFJ
        JuizYlai5rfGv/Y6ERRk11t36Q==
X-Google-Smtp-Source: ABdhPJzX2h54Mf+lB9LAOdZJfSv4ZTh9QATHRgnHg/LhXCRDP//6SMzYNM9czoritF2K6Pwn49FEkA==
X-Received: by 2002:a05:6870:7093:b0:e6:210a:d98d with SMTP id v19-20020a056870709300b000e6210ad98dmr715466oae.68.1651696887015;
        Wed, 04 May 2022 13:41:27 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id t13-20020a9d66cd000000b0060603221270sm5486404otm.64.2022.05.04.13.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:41:26 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 4 May 2022 15:41:24 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.17 162/225] ASoC: Intel: sof_es8336: Add a quirk for
 Huawei Matebook D15
Message-ID: <YnLk9DLTZcVjTdK/@fedora64.linuxtx.org>
References: <20220504153110.096069935@linuxfoundation.org>
 <20220504153124.439720094@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504153124.439720094@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 06:46:40PM +0200, Greg Kroah-Hartman wrote:
> From: Mauro Carvalho Chehab <mchehab@kernel.org>
> 
> [ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]
> 
> Based on experimental tests, Huawei Matebook D15 actually uses
> both gpio0 and gpio1: the first one controls the speaker, while
> the other one controls the headphone.
> 
> Also, the headset is mapped as MIC1, instead of MIC2.
> 
> So, add a quirk for it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/d678aef9fc9a07aced611aa7cb8c9b800c649e5a.1649357263.git.mchehab@kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

This patch is missing some dependencies and fails to build:

sound/soc/intel/boards/sof_es8336.c:261:41: error: 'SOF_ES8336_HEADPHONE_GPIO' undeclared here (not in a function)
  261 |                 .driver_data = (void *)(SOF_ES8336_HEADPHONE_GPIO |

SOF_ES8336_HEADPHONE_GPIO was defined in upstream commit:
6e1ff1459e008 ASoC: Intel: sof_es8336: support a separate gpio to control headphone
which appeared with 5.18-rc4

sound/soc/intel/boards/sof_es8336.c:262:41: error: 'SOC_ES8336_HEADSET_MIC1' undeclared here (not in a function)
  262 |                                         SOC_ES8336_HEADSET_MIC1)

SOC_ES8336_HEADSET_MIC1 was defined in upstream commit: 
7c7bb2a059b22 ASoC: Intel: sof_es8336: add a quirk for headset at mic1 port
which also appeared with 5.18-rc4

We either need to bring in these 2 commits or drop this one from the
stable queue.

Justin

>  sound/soc/intel/boards/sof_es8336.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
> index 28d7670b8f8f..b18951a8f309 100644
> --- a/sound/soc/intel/boards/sof_es8336.c
> +++ b/sound/soc/intel/boards/sof_es8336.c
> @@ -252,6 +252,15 @@ static const struct dmi_system_id sof_es8336_quirk_table[] = {
>  					SOF_ES8336_TGL_GPIO_QUIRK |
>  					SOF_ES8336_ENABLE_DMIC)
>  	},
> +	{
> +		.callback = sof_es8336_quirk_cb,
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "HUAWEI"),
> +			DMI_MATCH(DMI_BOARD_NAME, "BOHB-WAX9-PCB-B2"),
> +		},
> +		.driver_data = (void *)(SOF_ES8336_HEADPHONE_GPIO |
> +					SOC_ES8336_HEADSET_MIC1)
> +	},
>  	{}
>  };
>  
> -- 
> 2.35.1
> 
> 
> 
