Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB9647D6FE
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbhLVSkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 13:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhLVSkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 13:40:13 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737DFC061574;
        Wed, 22 Dec 2021 10:40:13 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id x7so7268903lfu.8;
        Wed, 22 Dec 2021 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W8sEphJb7GJVdi88wbZ9u/Spea2ot80mxoEbl6P7QDw=;
        b=EiT4zUcNW/DfVii4TuDzaHWnQ70nfKCAevP7CMfxJGqz+t7vsCUxhaQe8CeLbZM3y7
         qahj67oAXYGc6dW4yX7Dp080a2E6nGKwh15Pbmd0FyfOLoBq6Cd0DYX2kIcATs2iO5vq
         v5xkcoFRBdDgjcYR9pPknkw+yUUOuMBf9xHwXsBuKBL9ZqQkQ6S6EUaQgc2oNp0rmMDA
         2xYVjEN1k+17k8lF32OsikBJlnX968xw90ut2DZUie5+2EwiIOz5EFzBOaaBbVZkbXce
         hKLmnk7FN39IbxZKHYaa+obSah9M4VLpxMz8z0zTPbYzn7zZ22OMJU8aeICoQSZrYvtF
         gpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W8sEphJb7GJVdi88wbZ9u/Spea2ot80mxoEbl6P7QDw=;
        b=YRZOmGuBm7eimwsj6ZAyrbnx7irAFRANbHL9e4CfPcBfvF8Jl7Wy87UXsXhPsZ3gaI
         0GfG7xuDUUxilk8tRMSh7BWoReenPxSgYbRMlBfUZ79KjSCHLGetypFOTOSynFpmFAEh
         2MCZU0iV2NeDAFrK1692q3pStrANw7NL13uNgb0jhtcDBh6k9QgXaibDJZbFtC4jqPmK
         /N/bkGETuYULkfWUO/0LL0mnlI26A45XiCgCtQkbUSNEBgcezHVyGD4nFZHMHzhJdDno
         c/dPQwE2HE0Vd6qE7/+FHnaTQdHJ8hkKMOOkNl1AQ9cKLlpwSrrWYkR8fRAXlso09VF8
         w+Pw==
X-Gm-Message-State: AOAM532FoZzTZYy4SlaEu8gHM8aXPazKjTH0CIN+GcdLq9wWHTDwatfG
        4HOZhd8N3U6wBDC3tpGwHjVXR802V9E=
X-Google-Smtp-Source: ABdhPJz+IkJomMq3ZP58p2tbSEKOhNwGWfkuI2UAIWm3HwgOqehGrbJTnn1olk+RFGGoFwMLBlTRwQ==
X-Received: by 2002:a05:6512:40d:: with SMTP id u13mr3138039lfk.327.1640198411472;
        Wed, 22 Dec 2021 10:40:11 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id v27sm285104lfo.97.2021.12.22.10.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 10:40:11 -0800 (PST)
Subject: Re: [PATCH v3 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, mkumard@nvidia.com,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
 <1640147751-4777-2-git-send-email-spujar@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <fb8cf33f-41fb-79c0-3134-524c290e4fc1@gmail.com>
Date:   Wed, 22 Dec 2021 21:40:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1640147751-4777-2-git-send-email-spujar@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

22.12.2021 07:35, Sameer Pujar пишет:
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

Is "Depends-on" a valid tag? I can't find it in Documentation/.

> ---
>  sound/pci/hda/hda_tegra.c | 45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
> index ea700395..7c3df54 100644
> --- a/sound/pci/hda/hda_tegra.c
> +++ b/sound/pci/hda/hda_tegra.c
> @@ -68,14 +68,20 @@
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
> +	struct reset_control_bulk_data resets[3];
>  	struct clk_bulk_data clocks[3];
> +	unsigned int nresets;
>  	unsigned int nclocks;
>  	void __iomem *regs;
>  	struct work_struct probe_work;
> +	const struct hda_tegra_soc *data;
>  };
>  
>  #ifdef CONFIG_PM
> @@ -170,7 +176,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>  	int rc;
>  
>  	if (!chip->running) {
> -		rc = reset_control_assert(hda->reset);
> +		rc = reset_control_bulk_assert(hda->nresets, hda->resets);
>  		if (rc)
>  			return rc;
>  	}
> @@ -187,7 +193,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
>  	} else {
>  		usleep_range(10, 100);
>  
> -		rc = reset_control_deassert(hda->reset);
> +		rc = reset_control_bulk_deassert(hda->nresets, hda->resets);
>  		if (rc)
>  			return rc;
>  	}
> @@ -427,9 +433,17 @@ static int hda_tegra_create(struct snd_card *card,
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
> @@ -449,6 +463,10 @@ static int hda_tegra_probe(struct platform_device *pdev)
>  	hda->dev = &pdev->dev;
>  	chip = &hda->chip;
>  
> +	hda->data = of_device_get_match_data(&pdev->dev);
> +	if (!hda->data)
> +		return -EINVAL;

hda->data can't ever be NULL because all hda_tegra_match[] compatibles
above have .data assigned. Technically this check is redundant.

Thierry suggested previously to name it "hda->soc", like we usually do
it in other drivers.

>  	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
>  			   THIS_MODULE, 0, &card);
>  	if (err < 0) {
> @@ -456,11 +474,20 @@ static int hda_tegra_probe(struct platform_device *pdev)
>  		return err;
>  	}
>  
> -	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
> -	if (IS_ERR(hda->reset)) {
> -		err = PTR_ERR(hda->reset);
> +	hda->resets[hda->nresets++].id = "hda";
> +	hda->resets[hda->nresets++].id = "hda2hdmi";
> +	/*
> +	 * "hda2codec_2x" reset is not present on Tegra194. Though DT would
> +	 * be updated to reflect this, but to have backward compatibility
> +	 * below is necessary.
> +	 */
> +	if (hda->data->has_hda2codec_2x_reset)
> +		hda->resets[hda->nresets++].id = "hda2codec_2x";
> +
> +	err = devm_reset_control_bulk_get_exclusive(&pdev->dev, hda->nresets,
> +						    hda->resets);
> +	if (err)
>  		goto out_free;
> -	}
>  
>  	hda->clocks[hda->nclocks++].id = "hda";
>  	hda->clocks[hda->nclocks++].id = "hda2hdmi";
> 

Not sure whether the above nits worth making v4. I'll leave it up to you
and other reviewers to decide.

Overall this patch looks good to me, thank you.

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
