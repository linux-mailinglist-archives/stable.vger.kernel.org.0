Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3530E637A3B
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 14:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKXNr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 08:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiKXNrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 08:47:55 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB9E24950
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 05:47:54 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so4304574ejc.4
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 05:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=skUT3utsKPWLVdNJygEjjwBaHmNe4Tok7aRtnCgAX+c=;
        b=e3iSJl6EenwxDQL3vM4l/NttSfBRWz+80bAmlpHxlOD09NhlOAkGYs9eQry22x+P28
         s2mAjWbIbI/W9XdcTgVgPXZykf337tdyx5zvQQ4sGfKz6CCKo/PUyo7U7EU6O0GhWK76
         0Rce+qPkJe0pJG3TsWA+HRxMhg41aZIqH/5N+Sfi8mAeU/nlTMSw92IPxQUmBoXwMWsD
         7BcUsNhZcupTlJJnE3S6IornNYD96UrwHWrVLbDAr2V38luuKQnQu9FFvp1BpnRrzLuk
         0w2lNRaa/YGQazsA7O6Qu0CPIOus+Qf7RPK7tYdSUBQjWUQoJeYVs7+Vz/d3AlpVuTfJ
         i6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skUT3utsKPWLVdNJygEjjwBaHmNe4Tok7aRtnCgAX+c=;
        b=2U8HDWIZk0SAAvTkGbJ0Sngt0XgGd/0HIONe8JcWErttGm8cXnUI+DzZ51L68k18Hv
         E/3gWILwyZarsQFnbYnXNVLLoRJrPvKRO+D5wGiNr0uxZLytEXdBdvAl38aXqJYN/Cs6
         DRuVfSTuuRh5hgMbomfHGgeZJ3c9h5uOj7Uq5lFmjH58agXJV10VFYfaLav6GqtfNjoi
         nUJujQyf4iRSK7Chj9ECuunCc8Zpu/saXbjGHSVG5T7Z/LU54Ousl4BnLNbzQzDmhVzX
         STWCC8R8YU8gLMtCmVl5eyZY+C7xPQBxCe75nXlrDiy8U3WPELwdlKdQuEhU/PYF4Vj6
         NBWA==
X-Gm-Message-State: ANoB5pnqmk9aAbwsaVeJgKHP7gMZZCrXmJrGhKycJxLFZSev1bDml4/x
        DMQNGVVMEhAWeZNl3em3mzt/eY7Zj2J8Dw==
X-Google-Smtp-Source: AA0mqf5jQIt+NupQkEFckTgQCITSjNHYjr9XYScCGCO2ex6bxNZ0VedlEVBIfO3I4PuvXLLBrYQIbw==
X-Received: by 2002:a17:907:9151:b0:7ae:df97:c03d with SMTP id l17-20020a170907915100b007aedf97c03dmr12175583ejs.125.1669297672693;
        Thu, 24 Nov 2022 05:47:52 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id cd10-20020a170906b34a00b007aa239cf4d9sm442358ejb.89.2022.11.24.05.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 05:47:52 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 2FB6DBE2DE0; Thu, 24 Nov 2022 14:47:51 +0100 (CET)
Date:   Thu, 24 Nov 2022 14:47:51 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 011/149] ASoC: Intel: sof_sdw: add quirk variant for
 LAPBC710 NUC15
Message-ID: <Y392B4HibRmMU1o3@eldamar.lan>
References: <20221123084557.945845710@linuxfoundation.org>
 <20221123084558.387879056@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221123084558.387879056@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 23, 2022 at 09:49:54AM +0100, Greg Kroah-Hartman wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> 
> [ Upstream commit 41deb2db64997d01110faaf763bd911d490dfde7 ]
> 
> Some NUC15 LAPBC710 devices don't expose the same DMI information as
> the Intel reference, add additional entry in the match table.
> 
> BugLink: https://github.com/thesofproject/linux/issues/3885
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> Link: https://lore.kernel.org/r/20221017204054.207512-1-pierre-louis.bossart@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/intel/boards/sof_sdw.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> index 25548555d8d7..5e1a718a64da 100644
> --- a/sound/soc/intel/boards/sof_sdw.c
> +++ b/sound/soc/intel/boards/sof_sdw.c
> @@ -175,6 +175,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
>  					SOF_SDW_PCH_DMIC |
>  					SOF_RT711_JD_SRC_JD2),
>  	},
> +	{
> +		/* NUC15 LAPBC710 skews */
> +		.callback = sof_sdw_quirk_cb,
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
> +			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
> +		},
> +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> +					SOF_SDW_PCH_DMIC |
> +					RT711_JD1),
> +	},
>  	/* TigerLake-SDCA devices */
>  	{
>  		.callback = sof_sdw_quirk_cb,
> -- 
> 2.35.1

This one causes a build failure for 5.10.156-rc1 (not tested newer
ones possibly affected):

sound/soc/intel/boards/sof_sdw.c:187:6: error: ‘RT711_JD1’ undeclared here (not in a function)
  187 |      RT711_JD1),
      |      ^~~~~~~~~
make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1
make[6]: *** [scripts/Makefile.build:503: sound/soc/intel/boards] Error 2
make[5]: *** [scripts/Makefile.build:503: sound/soc/intel] Error 2
make[4]: *** [scripts/Makefile.build:503: sound/soc] Error 2
make[3]: *** [Makefile:1837: sound] Error 2
make[3]: *** Waiting for unfinished jobs....

If not mistaken this is because 5.10.y does not have yet 8e6c00f1fdea ("ASoC:
Intel: sof_sdw: include rt711.h for RT711 JD mode") which is present on
5.15-rc1 onwards.

Regards,
Salvatore
