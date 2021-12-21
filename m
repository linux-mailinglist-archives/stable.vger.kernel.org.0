Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012D147C2AA
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbhLUPUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 10:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhLUPUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 10:20:17 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B36C061574;
        Tue, 21 Dec 2021 07:20:17 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i31so14831283lfv.10;
        Tue, 21 Dec 2021 07:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T0/ofZQcXMKN8oGRcoOw+6rBxR+Ouo3vIEIiIJRMs0Q=;
        b=f9IEBoL6YPTDCgse/LTTD0EcTxeFS0YUBjhbUXEiw90ce+dIIX0YifeeKcBEH82ejL
         aVniFH4v7kszbUJQFUMWC305rIEgsTiuRIzcygq7JpLrQQyi52f43Y/H/IMucahYIVCz
         qfpmLnK3GjZFRK3E+cyXC/C4U0iZ8qRjP6qzKOPhh5Z4ZW9nEuTAr0jz8iP63D1v+jfz
         d6nyrV8H5nM5BZkHWy692QH8AO7ZZlhb7V9nsKSEYZPknlMNM7DtnvUZ6JKp0WF5LZv8
         PpwasYPhJBSqPUJow1zplojiUC6+lEDDAvL/vngX12y4ylC9fOHh8hlOGtgMLzQa4xgF
         OHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0/ofZQcXMKN8oGRcoOw+6rBxR+Ouo3vIEIiIJRMs0Q=;
        b=bcj1Zg41mY1iF5ZOcyW+6Ka2dTsa5p+k+C4gCAt1AEDM1w+sXhTU6yod4rz7OkBZEg
         hSkwGJP10/vR2MyOniVCuK+/9lPD0FWUpId6dIbeZ45cJtaAJFIQfzicAlH6PKHxxBW9
         Co0rK/USK9JB7QpAOL0UNzYx1Mev044+pAD/izMbxHszbXokRpSFj4fpcBUVIlIFas+U
         CR+hXirofx51U18zd9U0a09ZIxti6Ficq+zhaTMwMI9MYatI8QeYOYJVie6kyNK5lPHb
         QHUcxm/vear02BqEX2xQqeTmzDy2GFPz5lv7bB4VyaozW8BWHZwk6yafG0DBPETq2tsV
         x5rA==
X-Gm-Message-State: AOAM530QwtBTI8vTUozA7tNXmikeNz9m/1nLaO0iPZ2retk44SWRyl01
        PLMqM5jh25AhxA8ozR2Ok3eDJPXpq6o=
X-Google-Smtp-Source: ABdhPJyYwazba8NyvqSG6pdeP0ppzcRxJZtCBWlGDj7aITS6uJyAS6/6FfPvZNUUxuu60HRZMQxaaw==
X-Received: by 2002:a19:4f5e:: with SMTP id a30mr3465355lfk.228.1640100015228;
        Tue, 21 Dec 2021 07:20:15 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id b10sm1134927lfb.107.2021.12.21.07.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 07:20:14 -0800 (PST)
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
 <f859559c-abf1-ae37-6a0f-80329e6f747f@gmail.com>
 <f65ae56d-d289-9e3f-1c15-f0bedda3918c@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <46acc080-56f5-f970-a9fa-3a9ece0dd2a3@gmail.com>
Date:   Tue, 21 Dec 2021 18:20:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f65ae56d-d289-9e3f-1c15-f0bedda3918c@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

21.12.2021 09:18, Sameer Pujar пишет:
> 
> 
> On 12/21/2021 6:51 AM, Dmitry Osipenko wrote:
>>
>> All stable kernels affected by this problem that don't support the bulk
>> reset API are EOL now. Please use bulk reset API like I suggested in the
>> comment to v1, it will allow us to have a cleaner and nicer code.
> 
> Agree that it would be compact and cleaner, but any specific reset
> failure in the group won't be obvious in the logs. In this case it
> failed silently. If compactness is preferred, then may be I can keep an
> error print at group level so that we see some failure context whenever
> it happens.

The group shouldn't fail ever unless device-tree is wrong. Why do you
think we should care about the case which realistically won't ever
happen? This is a bit unpractical approach.

If we really care about those error messages, then will be much more
reasonable to add them to the reset core, like clk core does it [1],
IMO. This will be a trivial change. Will you be happy with this variant?

[1]
https://elixir.bootlin.com/linux/v5.16-rc6/source/drivers/clk/clk-bulk.c#L100

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 61e688882643..85ce0d6eeb34 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -962,6 +962,11 @@ int __reset_control_bulk_get(struct device *dev,
int num_rstcs,
 						    shared, optional, acquired);
 		if (IS_ERR(rstcs[i].rstc)) {
 			ret = PTR_ERR(rstcs[i].rstc);
+
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "Failed to get reset '%s': %d\n",
+					rstcs[i].id, ret);
+
 			goto err;
 		}
 	}
