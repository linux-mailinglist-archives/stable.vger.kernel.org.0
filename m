Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD78647B6CB
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhLUBV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhLUBV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:21:28 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2281C061574;
        Mon, 20 Dec 2021 17:21:27 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id k37so25729405lfv.3;
        Mon, 20 Dec 2021 17:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nkRfs6Jq6Yr/a/t9OO2egmqloXCmD4IcdPxGpgHonb8=;
        b=eF1G2y2TjCAkFUrBHcdwf3AbiSiwCXaA2g7IKISK3lq1/wtP150oj9nLjun2CQ+h1R
         vot0D+gAcqRR647Zq81AI3CvVtcy3qDvnFMgCF4DHHFLLiEhLrLdpLz1gGyWi7JqjsMq
         Q5XPxpn2JAkCLZfvmuz8D1aMmD/Bp5QBWMX+MGVw72KvpunSLbk+ZeKop5LvmtvU2n97
         5CsfKyuXgPWnKXIlltWovD4O1uQy3ssLCHpROmBnMqq4e6sbAe5zm8UC2DTyXOTkglGX
         EUt8rMwVdQ90IX6gxggPtLDeknNwu3LogfS0J0irajS7bExPTNK/MTUro5ZETcIatvCq
         UFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nkRfs6Jq6Yr/a/t9OO2egmqloXCmD4IcdPxGpgHonb8=;
        b=7rcyIkUoI9NraJrNWxDJHsjbW2MNT1HlFOtD8VP1REmS7Qh6ndSLxLU+c1CS8dYYIg
         RQdnel7r0SjlCnaHqrSGrUZzsFsEi6kYpkWOa0HBbzA3JchhirukkyvP6IGkMJkG7zLS
         7FqbQKtqgip3L8SS4jRYKf8fiVoy6tEoiVwKa+kQ7ipjFZC4uxqAYmSoPrptf2p4nxJe
         179jvUk48t0i4OVJfUr55gPEbSv0VLLT/ghVTGFtnCRxD1c+dEBTBellU/JuwaW4M3P1
         wI0VrrcQqfAwlS3Ex0RN/uTdU5Ta/mMK5FtmJ6JjB7TPZQD+onhnrNacBJBOjl34xmZB
         IOhA==
X-Gm-Message-State: AOAM531tAOnar56Xr0bx2fzfbt1R027T3/J7hQdwe6NV4tA0LYk/qldo
        6bRuY1ByRdNqOq1r9BdK/yx1bjr0B6k=
X-Google-Smtp-Source: ABdhPJziuxKcVGxUkjz2c00kkrTen8rOkYs71ofy6F7odPfZ42R/oI6ztDoz6894QXV2I32c3yKg8w==
X-Received: by 2002:ac2:51bc:: with SMTP id f28mr842680lfk.222.1640049685857;
        Mon, 20 Dec 2021 17:21:25 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id h18sm2637460ljh.133.2021.12.20.17.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 17:21:25 -0800 (PST)
Subject: Re: [PATCH v2 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, mkumard@nvidia.com,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1640021408-12824-1-git-send-email-spujar@nvidia.com>
 <1640021408-12824-2-git-send-email-spujar@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <f859559c-abf1-ae37-6a0f-80329e6f747f@gmail.com>
Date:   Tue, 21 Dec 2021 04:21:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1640021408-12824-2-git-send-email-spujar@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

20.12.2021 20:30, Sameer Pujar пишет:
> HDA regression is recently reported on Tegra194 based platforms.
> This happens because "hda2codec_2x" reset does not really exist
> in Tegra194 and it causes probe failure. All the HDA based audio
> tests fail at the moment. This underlying issue is exposed by
> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
> response") which now checks return code of BPMP command response.
> Fix this issue by skipping unavailable reset on Tegra194.
> 
> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> Cc: stable@vger.kernel.org
> Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
> ---
>  sound/pci/hda/hda_tegra.c | 96 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 86 insertions(+), 10 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
> index ea700395..be010cd 100644
> --- a/sound/pci/hda/hda_tegra.c
> +++ b/sound/pci/hda/hda_tegra.c
> @@ -68,14 +68,21 @@
>   */
>  #define TEGRA194_NUM_SDO_LINES	  4
>  
> +struct hda_tegra_soc {
> +	bool has_hda2codec_2x_reset;
> +};
> +
>  struct hda_tegra {
>  	struct azx chip;
>  	struct device *dev;
> -	struct reset_control *reset;
> +	struct reset_control *reset_hda;
> +	struct reset_control *reset_hda2hdmi;
> +	struct reset_control *reset_hda2codec_2x;
>  	struct clk_bulk_data clocks[3];
>  	unsigned int nclocks;
>  	void __iomem *regs;
>  	struct work_struct probe_work;
> +	const struct hda_tegra_soc *data;
>  };
>  
>  #ifdef CONFIG_PM
> @@ -170,9 +177,26 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>  	int rc;
>  
>  	if (!chip->running) {
> -		rc = reset_control_assert(hda->reset);
> -		if (rc)
> +		rc = reset_control_assert(hda->reset_hda);
> +		if (rc) {
> +			dev_err(dev, "hda reset assert failed, err: %d\n", rc);
> +			return rc;
> +		}
> +
> +		rc = reset_control_assert(hda->reset_hda2hdmi);
> +		if (rc) {
> +			dev_err(dev, "hda2hdmi reset assert failed, err: %d\n",
> +				rc);
> +			return rc;
> +		}
> +
> +		rc = reset_control_assert(hda->reset_hda2codec_2x);
> +		if (rc) {
> +			dev_err(dev,
> +				"hda2codec_2x reset assert failed, err: %d\n",
> +				rc);
>  			return rc;
> +		}
>  	}
>  
>  	rc = clk_bulk_prepare_enable(hda->nclocks, hda->clocks);
> @@ -187,9 +211,27 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>  	} else {
>  		usleep_range(10, 100);
>  
> -		rc = reset_control_deassert(hda->reset);
> -		if (rc)
> +		rc = reset_control_deassert(hda->reset_hda);
> +		if (rc) {
> +			dev_err(dev, "hda reset deassert failed, err: %d\n",
> +				rc);
>  			return rc;
> +		}
> +
> +		rc = reset_control_deassert(hda->reset_hda2hdmi);
> +		if (rc) {
> +			dev_err(dev, "hda2hdmi reset deassert failed, err: %d\n",
> +				rc);
> +			return rc;
> +		}
> +
> +		rc = reset_control_deassert(hda->reset_hda2codec_2x);
> +		if (rc) {
> +			dev_err(dev,
> +				"hda2codec_2x reset deassert failed, err: %d\n",
> +				rc);
> +			return rc;
> +		}
>  	}
>  
>  	return 0;
> @@ -427,9 +469,17 @@ static int hda_tegra_create(struct snd_card *card,
>  	return 0;
>  }
>  
> +static const struct hda_tegra_soc tegra30_data = {
> +	.has_hda2codec_2x_reset = true,
> +};
> +
> +static const struct hda_tegra_soc tegra194_data = {
> +	.has_hda2codec_2x_reset = false,
> +};
> +
>  static const struct of_device_id hda_tegra_match[] = {
> -	{ .compatible = "nvidia,tegra30-hda" },
> -	{ .compatible = "nvidia,tegra194-hda" },
> +	{ .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
> +	{ .compatible = "nvidia,tegra194-hda", .data = &tegra194_data },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, hda_tegra_match);
> @@ -449,6 +499,10 @@ static int hda_tegra_probe(struct platform_device *pdev)
>  	hda->dev = &pdev->dev;
>  	chip = &hda->chip;
>  
> +	hda->data = of_device_get_match_data(&pdev->dev);
> +	if (!hda->data)
> +		return -EINVAL;
> +
>  	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
>  			   THIS_MODULE, 0, &card);
>  	if (err < 0) {
> @@ -456,12 +510,34 @@ static int hda_tegra_probe(struct platform_device *pdev)
>  		return err;
>  	}
>  
> -	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
> -	if (IS_ERR(hda->reset)) {
> -		err = PTR_ERR(hda->reset);
> +	hda->reset_hda = devm_reset_control_get_exclusive(&pdev->dev, "hda");
> +	if (IS_ERR(hda->reset_hda)) {
> +		err = PTR_ERR(hda->reset_hda);
>  		goto out_free;
>  	}
>  
> +	hda->reset_hda2hdmi = devm_reset_control_get_exclusive(&pdev->dev,
> +							       "hda2hdmi");
> +	if (IS_ERR(hda->reset_hda2hdmi)) {
> +		err = PTR_ERR(hda->reset_hda2hdmi);
> +		goto out_free;
> +	}
> +
> +	/*
> +	 * "hda2codec_2x" reset is not present on Tegra194. Though DT would
> +	 * be updated to reflect this, but to have backward compatibility
> +	 * below is necessary.
> +	 */
> +	if (hda->data->has_hda2codec_2x_reset) {
> +		hda->reset_hda2codec_2x =
> +			devm_reset_control_get_exclusive(&pdev->dev,
> +							 "hda2codec_2x");
> +		if (IS_ERR(hda->reset_hda2codec_2x)) {
> +			err = PTR_ERR(hda->reset_hda2codec_2x);
> +			goto out_free;
> +		}
> +	}
> +
>  	hda->clocks[hda->nclocks++].id = "hda";
>  	hda->clocks[hda->nclocks++].id = "hda2hdmi";
>  	hda->clocks[hda->nclocks++].id = "hda2codec_2x";
> 

All stable kernels affected by this problem that don't support the bulk
reset API are EOL now. Please use bulk reset API like I suggested in the
comment to v1, it will allow us to have a cleaner and nicer code.

The bulk reset code will look similar to the bulk clk API already used
by the HDA driver, you'll only need to skip adding the hda2codec_2x to
resets[3] and switch to use reset_control_bulk_reset_*() variants of the
functions.
