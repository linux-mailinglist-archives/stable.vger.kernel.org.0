Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC0614EFC5
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgAaPjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:39:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40284 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaPjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:39:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18so7523827ljo.7;
        Fri, 31 Jan 2020 07:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9NPQscGNoa4QIXz4hQhsZPNEmWteEQEWE2lnF9zwH24=;
        b=HY2h8qXHR+65tHbLBV9R4c9tHZBR6GbAHVfWKrQFLM/T5OcNZzujzh4h7wyxaLOZSw
         DtPJLapCShNv4r6pa6VPaHjq51f/tLFeFcRtJ7NcTLclpzwfOBa94vMHQl6Y5HO/NLp+
         Oq9rxnOfqpbInouIdupaA9abu/BKodBdajs8+MsBsiJX6/Xy2p9io6kvVneyr7jDueG0
         NB4JE12KytkZznQWOAresZeeo5efZmvuSvEBZRaTTEL6tVJEFat8x8y5kTMwsTAw1Qh3
         JNAXjXVQdajYbUuRbidVUTXYzt1Lmf/EGuut289IrEL/xvNuCBOaUcneJTBJ65yFVeR/
         1Z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9NPQscGNoa4QIXz4hQhsZPNEmWteEQEWE2lnF9zwH24=;
        b=gGoqJ+9M8iWv4qEn6IU5vWXRmMXe8cLtOHh4OjdWIb9mtAopfjUGXv92a3S1DKQ3FJ
         V/Ss7qMkrVzPyZ+6GL2pmFWTzVuSDBhtxvO/AJ0qtMxpxMroj4OiuO+75KiyDz4OOpmp
         D52ecka/7pf6cZHNrEpHHOlZtMdBFoVSqjS74d1oue6WZxZ8/t62her7hrT8nAeNqAaL
         K746zzdIvwN4/dI+sIv0eKNwmuQX8RxQKXkS22ZRj0e+MkeStO5xc824I9x+4dwX0DWO
         00t8rGLra4iC3n8p5YKKjyUPobc5KmYOpdLBm92jhxnIhFVnOUyYO/mzb46oJYrekD6U
         hmug==
X-Gm-Message-State: APjAAAWSM/AptSmonwucVbEWpLXHL7x67xIXdkAJ5jEAlce6ZOIerdGg
        fD6pcVQP9RkR7xwBf8YXZYgE/spW
X-Google-Smtp-Source: APXvYqxQpZSCnRWgO07QQjTkLnxT1f+sOw6/HeSxPP+VGu4ipK/vezwcHwADfcg1x2dJ2mXLXhKwOA==
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr6362924ljk.201.1580485137587;
        Fri, 31 Jan 2020 07:38:57 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id a10sm4761180lfr.94.2020.01.31.07.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:38:57 -0800 (PST)
Subject: Re: [PATCH] Revert "ASoC: tegra: Allow 24bit and 32bit samples"
To:     Jon Hunter <jonathanh@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200131091901.13014-1-jonathanh@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <2bb53d7d-2d36-e16e-5858-24360b19f936@gmail.com>
Date:   Fri, 31 Jan 2020 18:38:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200131091901.13014-1-jonathanh@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

31.01.2020 12:19, Jon Hunter пишет:
> Commit f3ee99087c8ca0ecfdd549ef5a94f557c42d5428 ("ASoC: tegra: Allow
> 24bit and 32bit samples") added 24-bit and 32-bit support for to the
> Tegra30 I2S driver. However, there are two additional commits that are
> also needed to get 24-bit and 32-bit support to work correctly. These
> commits are not yet applied because there are still some review comments
> that need to be addressed. With only this change applied, 24-bit and
> 32-bit support is advertised by the I2S driver, but it does not work and
> the audio is distorted. Therefore, revert this patch for now until the
> other changes are also ready.
> 
> Furthermore, a clock issue with 24-bit support has been identified with
> this change and so if we revert this now, we can also fix that in the
> updated version.
> 
> Cc: stable@vger.kernel.org
> 
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---

Thanks, Jon!

Tested-by: Dmitry Osipenko <digetx@gmail.com>

Ben, looking forward to have 24bit working in 5.7 :)
