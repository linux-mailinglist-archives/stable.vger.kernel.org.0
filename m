Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D084A304BDC
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbhAZV4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbhAZR1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:27:08 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F952C06174A;
        Tue, 26 Jan 2021 09:26:28 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o16so2245776pgg.5;
        Tue, 26 Jan 2021 09:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NFL45fwPnym4P8gBeK+sVnLYS/SfydJYChXAFqHXORo=;
        b=kjjlWxsXlqd1lzmoRn0GcqAIOo0gojl7huQ9EZjRcE9ZIaQD9+ikoVxTlHBlFMbhMG
         77G5TwHhpymY7YZxa8AR7kWAZuMiQEjaUx7+gAcP9feUemAgD8I+4FrupLdm82TVfYUO
         VSfIyfJGpx7mZql0MrgMOvyn1u3tZcUe+iQcdvGaFVJ/LGXRGVA+oDQ6eVmQ2fb28J28
         RjyNJBuGg8gtu6ygm/x3WN0dI/75+KCOcky1GXYXwN3BYVAQoT7udhrWyy74sfx+NI3q
         sows4tbki0HptwrZMS+TppeZUi2HNXaKZhzXw5Ujte4eiEwxkQjuAyQzzGhKiHJaqkGV
         SSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NFL45fwPnym4P8gBeK+sVnLYS/SfydJYChXAFqHXORo=;
        b=KhX2wKCfL+m7zfSNS/JaVisTgk/8yUyk3AgjLGoVEBL98bzpAc3bcyKgzjRefI75ga
         PxLLtfzS3xxFapT3kBnkimXPWC+RCRRcqfcjQ6oY/CgSa9tfFPonGcn8NdEUbYS55jui
         z/bMp3qRSxMG9DzK2HL9FXHe4CKZtcLJy27HBBR+LbsHNYU/howaUUR0k3c7drWb45l+
         KIBHAlxGjnW9ZiLYv85sjlskqaPmSqUNNSJ3k6DHuOMft+rGziS/DkLcCz7nAk8YjbEB
         QCz8rinjlUbT9S0dn2JW+lMeyMkeqxnguN2oWlYYkgLKrPPdi+U++IHDxCP9ArfTHQZK
         tJFQ==
X-Gm-Message-State: AOAM532cVXToluSKLbMtOEbBLVy1djzRHt4t0/cMoAh2Ed4g4dORpKPY
        +YS8Ri5yFXjh6Ueahn6flL1SlseQBWA=
X-Google-Smtp-Source: ABdhPJydqrgZH44fhQxrH7tJk1unX2195GrUjbPn6K+69PA1jppQ3rb5l1H63kXajO8mkLpS4GvenA==
X-Received: by 2002:a63:c46:: with SMTP id 6mr4901346pgm.337.1611681987543;
        Tue, 26 Jan 2021 09:26:27 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 145sm19798078pge.88.2021.01.26.09.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:26:26 -0800 (PST)
Subject: Re: [PATCH] mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb
To:     Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Al Cooper <alcooperx@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nicolas Schichan <nschichan@freebox.fr>, stable@vger.kernel.org
References: <20210126095230.26580-1-ulf.hansson@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f2ef35b7-4943-d74a-29c0-4c96036e3607@gmail.com>
Date:   Tue, 26 Jan 2021 09:26:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126095230.26580-1-ulf.hansson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Al,

On 1/26/2021 1:52 AM, Ulf Hansson wrote:
> The implementation of sdhci_pltfm_suspend() is only available when
> CONFIG_PM_SLEEP is set, which triggers a linking error:
> 
> "undefined symbol: sdhci_pltfm_suspend" when building sdhci-brcmstb.c.
> 
> Fix this by implementing the missing stubs when CONFIG_PM_SLEEP is unset.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Nicolas Schichan <nschichan@freebox.fr>
> Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
