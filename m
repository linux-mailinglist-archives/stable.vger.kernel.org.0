Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39E408C11
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbhIMNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:09:23 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33234
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240112AbhIMNHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 09:07:38 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CB3094026B
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631538381;
        bh=snqO+zpJPkBw6zZQNVMY27Q3942wUhbd/kP+elYWU54=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=hQTpWxCeeh5J29mXlTU3P8KIYs/Hl90OezAM8s30s93yiVe0+i7uVXmrV0haJHKIz
         niPM2FuT7LZSrdhJMo6v0DdQgB9Ml1Prs9kYI5OUzfZDSLRSDBDGMuEORHr8lv6N2O
         3R9gPnvH1GfUienuOA2ruqI5cl2MHmB55roRg9EQbgl3+tIhbu2lXoeJMXILmTGu12
         P57LI5/Y4uXmHNn/mOIuzZ11zyE7RdESRXlhHbH1yyctQ808PYDt2D/ZlP0zafJCst
         aHQEWex8YA1KxxgmJJCYfNDRNSydTmmcdPPbIR8okYFwHMIu2sJ2ObJvRnE1YjgTmq
         70umV3SuuPwKg==
Received: by mail-wm1-f72.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so4893377wmc.9
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 06:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=snqO+zpJPkBw6zZQNVMY27Q3942wUhbd/kP+elYWU54=;
        b=ifl0Bry7+kdY/7An0ykMmNKc8F/PJyWeDKgLNkto7r6Kfqljeh0R49zbnoo4n7yPAr
         N3TKRnXZ+sVv+bvpoG3Tj9lG8xwT/Xi85vMPVsf6ZYowrW9fzaFvykid7bw7S4dq4jDH
         6m/0yW24W7n3tjHeuJKwvl4O5B2T5wKB/ycscbSLnXuCYZcFehLckEcn9YHqdkm6Pr0a
         MsVVh+BFGunTJyTlbAWduH2GH9iOyt4+CYA1EniTU5P+6v/XTrLTIgWoCu0z7ESOq7N6
         iW01nzkHtL17TmkJSCZcqlwEdUfGSeyn3DqCsul18cEk5ENT7qAt2EVIe96jQCuFb4+Y
         +S6Q==
X-Gm-Message-State: AOAM532TGEvwbEcHKmznsncWu7dayiry7oY3i0knwhk/l2LuedBB88k0
        EC9bbzz9CTIDIBxf0gcQ9As2e8TkOcUT+ixdo15x18ee+FICVee/4d4zxySlfXKP1A+b26jZgJL
        1EBxC3LMoDiIkams0SX4oy5PoE10u699LVw==
X-Received: by 2002:adf:e684:: with SMTP id r4mr5333341wrm.229.1631538381349;
        Mon, 13 Sep 2021 06:06:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZCAKv3LrA50Rb+by2GgKgOyXFwxTRdJSEvJrd5FXZ6CkqcBwZDGtn7VCCfAd3pQp2D81heQ==
X-Received: by 2002:adf:e684:: with SMTP id r4mr5333323wrm.229.1631538381171;
        Mon, 13 Sep 2021 06:06:21 -0700 (PDT)
Received: from [192.168.3.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id q19sm2279358wmq.29.2021.09.13.06.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:06:00 -0700 (PDT)
Subject: Re: [PATCH 2/2] power: supply: max17042_battery: Prevent int
 underflow in set_soc_threshold
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        stable@vger.kernel.org
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm>
 <20210912205402.160939-2-sebastian.krzyszkowiak@puri.sm>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <82021f13-f535-1535-4af9-80bef81fbde5@canonical.com>
Date:   Mon, 13 Sep 2021 15:05:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912205402.160939-2-sebastian.krzyszkowiak@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2021 22:54, Sebastian Krzyszkowiak wrote:
> Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")

You need commit and bug description.

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
>  drivers/power/supply/max17042_battery.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
> index c53980c8432a..caf83b4d622f 100644
> --- a/drivers/power/supply/max17042_battery.c
> +++ b/drivers/power/supply/max17042_battery.c
> @@ -857,7 +857,8 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
>  	regmap_read(map, MAX17042_RepSOC, &soc);
>  	soc >>= 8;
>  	soc_tr = (soc + off) << 8;
> -	soc_tr |= (soc - off);
> +	if (off < soc)
> +		soc_tr |= soc - off;
>  	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
>  }
>  
> 


Best regards,
Krzysztof
