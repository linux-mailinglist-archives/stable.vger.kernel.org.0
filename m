Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C518408BD1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbhIMNGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:06:16 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:56874
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238863AbhIMNDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 09:03:54 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4A20C40257
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631538157;
        bh=iu9zMq7VH8HxvbrRseM1CzfWgZBkbaUNi4Cw0YJuwM0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=DeUzJQnhw3HWhI8avkzbh9+8sgSdCEj1OPZVftEgWlPyObRmUlt/MOUnCHM+nxxXb
         AplHEKmS5phtJw4gPtZ8uzfMaF4ouTVShTcIdKNsNEi2CyWtAECwITEDgCb8W3UyOv
         O+Pq7QShzLR7hgLmWDsklwWrFiY4eiW0WIgRvcvhnRZOYoYmv+BEWjBSP3d314Z3jK
         moqIb11pUVZKKmOsu5RJ364gU8wNX+8vMuD5WQ9dYExBM7sWLC0iAxNYyvDT2zzTfS
         mGrLPyFe4aY/9KDypYTi5xpS1CF8Q4cORE8OhJtANJYbJdMvin6ZrAsS3jXj+A5vP5
         txckIRJ/6jsbQ==
Received: by mail-wm1-f72.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so4891024wma.4
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 06:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iu9zMq7VH8HxvbrRseM1CzfWgZBkbaUNi4Cw0YJuwM0=;
        b=KMXDLL4xv9rduoKco7uASN/uuhepSYNIoD72S6eKYQPMaS3r8TIgtOktmjtfkSfs7C
         wV11sG4grH4RpooLpUkGtAoJBvk7QO6myvm64O+SNqxFzYG4J4mmteJQmaUzJM4dRxF+
         nkcCNVfTlmQ5o2DCyI4mXo754PeX+3nr38fw0ZO9qcFKEBnjK9RNHE0do4fEz3OBfj8G
         kxT2ZdmGwmD2sQuEy4pi4dN3A1PLbpJPrKLGGWxr86n/+dWLzQYhCrSqiiGSRZo0jqfa
         RmQ0hTVb5VmJ6BC2C+c/mu9T2XHnNrd0CY0F0ryTqLtO+q7ltI8CJmLQGpjsmNUJVF07
         e7Hg==
X-Gm-Message-State: AOAM5315vStI7ocfp5+lJUi/tntgaFXzQy6fjXkA+JE+R5gsPVu4RTVI
        n+U6nf9ajiBBIohZ00IXhQEBrtSPZfMGUhrBh+YvYxFhgMDcoe7RVRrvL1zdtVLhqIRdGZsnNCY
        dCKA4v6NmWycNCfHDmx829OYqwRnFJjmwBw==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr12573869wrn.261.1631538156475;
        Mon, 13 Sep 2021 06:02:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyaSKSMIX4A+QSHz2WtdORfG6b/MogxIP65fow2RNuWACKEFXZ5iZ+P8QZMy4+VzDS4hEY9Q==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr12573843wrn.261.1631538156267;
        Mon, 13 Sep 2021 06:02:36 -0700 (PDT)
Received: from [192.168.3.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id o2sm7876376wrh.13.2021.09.13.06.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:02:35 -0700 (PDT)
Subject: Re: [PATCH 1/2] power: supply: max17042_battery: Clear status bits in
 interrupt handler
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        stable@vger.kernel.org
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>
Date:   Mon, 13 Sep 2021 15:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2021 22:54, Sebastian Krzyszkowiak wrote:
> The gauge requires us to clear the status bits manually for some alerts
> to be properly dismissed. Previously the IRQ was configured to react only
> on falling edge, which wasn't technically correct (the ALRT line is active
> low), but it had a happy side-effect of preventing interrupt storms
> on uncleared alerts from happening.
> 
> Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrect) interrupt trigger type")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
>  drivers/power/supply/max17042_battery.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
> index 8dffae76b6a3..c53980c8432a 100644
> --- a/drivers/power/supply/max17042_battery.c
> +++ b/drivers/power/supply/max17042_battery.c
> @@ -876,6 +876,9 @@ static irqreturn_t max17042_thread_handler(int id, void *dev)
>  		max17042_set_soc_threshold(chip, 1);
>  	}
>  
> +	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
> +			  0xFFFF & ~(STATUS_POR_BIT | STATUS_BST_BIT));
> +

Are you sure that this was the reason of interrupt storm? Not incorrect
SoC value (read from register for ModelGauge m3 while not configuring
fuel gauge model).

You should only clear bits which you are awaken for... Have in mind that
in DT-configuration the fuel gauge is most likely broken by missing
configuration. With alert enabled, several other config fields should be
cleared.

Best regards,
Krzysztof
