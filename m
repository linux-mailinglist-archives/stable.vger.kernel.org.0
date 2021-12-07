Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8A46BF6F
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbhLGPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhLGPiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:38:55 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21717C061574;
        Tue,  7 Dec 2021 07:35:25 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id m12so28122179ljj.6;
        Tue, 07 Dec 2021 07:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QJHwvAIj7j6f9tXcv3t1jDYcyJk0MG+odriPhUknmc=;
        b=gjMvzabeYrtiD2l4Ppofk0NmbF2NeHkBy3RKVQY6q5lwJxyQj6t6Hb/1Lqt667WBl7
         nBEHCeGtXXXoqIcawTvzlZrmK34PF4DDZ6durwpMs9n8YJQmsBhzLkP2kx+OKYGvJIhi
         n/c5L3ynfKirxqvexlPKBa9ie4H59UI60l9TswOhBzcFPVysh54UKdf2n01/UZmD75Nx
         2sPDu8zABxfYiKrueVw8j6NQVVkhPqvCZ6RZZ3C7BJ7QvJe3TG2D3Z98KF4c/6lRuuxx
         SOOgHpATXEFThcn433wYrvqvWjItjYepmDIrGN0l+K2T0yh1Fx139BK3veAjkcuQcFlk
         zjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QJHwvAIj7j6f9tXcv3t1jDYcyJk0MG+odriPhUknmc=;
        b=iAXV7m/EXx7Xvgcjn095chLgNTvs+kVLlWN+SHYXAc2UaaT86xq8ZcTNKV8UYgofql
         KY8iZ7FeSfVC6bvtRY/5bUtMAXdZjjWLFR5El2/OEQkAoRQXqi173kqoj1Uku+V7FmC+
         BhProlGW6IH7bnMrRqsobyTH4GfgEbNj1nGQWbrmlVJ69ChTNObmzR77T9PCmF9e48V/
         wPIMGvTTPp7of3eCTqdIx0Lniz8D+Li6V2o7nBJJVqbrArqRXK7GHAThvRWdKclJquuc
         ekPOLEiI+WFkvA2l6QbTs0UFoLDcf3eLfmoovbAcmuRUDy2gCsI0AaL6OBSGKY1rl7iP
         hV1w==
X-Gm-Message-State: AOAM531lfmwgRYo9DHuUL1LelLH7s5MksdLfTd8Jd1NTzJ5n2k5gnVRa
        /Jf8IDLDbOM8xZIcTKG3iKI=
X-Google-Smtp-Source: ABdhPJxHGZ+65r90qy522XHUaM4sCGrdC5fWeHGrHG5KsxuLtJvqNuqbIoCPKboT5L1H87xO47QUSw==
X-Received: by 2002:a2e:9702:: with SMTP id r2mr43684071lji.482.1638891323459;
        Tue, 07 Dec 2021 07:35:23 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id n15sm454740lfu.228.2021.12.07.07.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 07:35:22 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
Date:   Tue, 7 Dec 2021 18:35:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

07.12.2021 17:49, Sameer Pujar пишет:
...
>>> How the reload case would be different? Can you please specify more
>>> details if you are referring to a particular scenario?
>> You have a shared power domain. Since power domain can be turned off
>> only when nobody keeps domain turned on, you now making reset of HDA
>> controller dependent on the state of display driver.
> 
> I don't think that the state of display driver would affect. The HDA
> driver itself can issue unpowergate calls which in turn ensures h/w
> reset. If display driver is already runtime active, HDA driver runtime
> resume after this would be still fine since h/w reset is already applied
> during display runtime resume. Note that both HDA and display resets are
> connected to this power-domain and BPMP applies these resets during
> unpowergate.

HDA won't be reset while display is active on T186+.
HDA will be reset while is display is inactive on T186+.
HDA will be reset regardless of display state on pre-T186.

This is a pure inconsistency of the reset behaviour. Please don't do it.
