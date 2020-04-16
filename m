Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0D1AB6E9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 06:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbgDPEiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 00:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390974AbgDPEiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 00:38:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ED7C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 21:38:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 7so592198pjo.0
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 21:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qJ44lMhEgFgR3b+cSDJa3Zv7+9sgojULpTQl6osYjy0=;
        b=NgneGvup1T7a6PRrssZKIjzDN0Z3ZjYzk8bsPYLAOKVDknHAx6WJF+8v4iuVvy2Ao2
         s0LNseYyMSEaMNkhpKFMGSMvPXYq30eZoLe2ueMteTiJeymvMSrOWmvAipzE2BDTEHV+
         fgXiWXy/HYYDFNJyModhx14WWijeDL1OkP+uUkHWEpm6moswTwLzs6ZP2+TMVs0dNDwW
         HME+44NYB28QVpDkDqazkBGpU6l/x6s86NAr061tmmqVGrRilFMY4AEvoZdf/Yx3uJwS
         6i3IMQxY8j7i3EKt3Z6OxmrNqWD1G77DKqsCf/qPSBUNYc44GyZ84VsgSo1PJjSrZ2B4
         utzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qJ44lMhEgFgR3b+cSDJa3Zv7+9sgojULpTQl6osYjy0=;
        b=TP3pat3iTwsDfSjcJkRD0Go3H7Htqip6v7L4Xd+P03YhT9ZK5oJ/kxkCWInfnB54ud
         u2kMQWrFY8FcIOpFx2jsJYHPUn88B7RWVihZSqEQLG6grPLHgN9VWr34DlXUfcO8Ssz9
         KfX8jo2DjnG2AMaZxf+oW2fRsbLxxqiB5J0K1+sSEJxuyXWTAAOyyqFa0t5yCgOWVymd
         NjpdQe6dC8G8hwUgue5SZ74zaT9ejHvjjTQ6Fd3eNw69pB7yFqKu0+fFCsEOn2DXeIEF
         /pa6/PgQStCFzavE8nVKaxDmuC+iUB053TPEfQM+bZNAFQ4RkLvH530S5OIxZYvNHshL
         NuwA==
X-Gm-Message-State: AGi0PuY3Syrd0LTLHo9bAM/hPDoNC3Jf3u3Xr03wrv0JYA1bfDZhUEVg
        KN1nNIpoCLZ/+c3+6ZXdKnc=
X-Google-Smtp-Source: APiQypJ70+NEWDePq7XVfiuPpT4Sd1/3i4hTyOE92jcVPbIQKCBr3nZL005SbEmeCjWH6Xzf4nn1og==
X-Received: by 2002:a17:90b:4d07:: with SMTP id mw7mr2907551pjb.94.1587011899500;
        Wed, 15 Apr 2020 21:38:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 6sm14549327pgz.0.2020.04.15.21.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 21:38:18 -0700 (PDT)
Subject: Re: Stable RC build failures (v4.19.y, v5.4.y, v5.5.y)
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200415183655.GA66707@roeck-us.net>
 <20200416034133.GI1068@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <8303033c-4961-7790-4ba6-bd70d492c5eb@roeck-us.net>
Date:   Wed, 15 Apr 2020 21:38:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416034133.GI1068@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/20 8:41 PM, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 11:36:55AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> The folloewing build failures currently observed with stable release
>> candidates.
>>
>> Thanks,
>> Guenter
>>
>> ---
>> v4.19.y:
>>
>> drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:392:14: error: 'chipFeatures_PIPE_3D' undeclared here
>> drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:397:14: error: 'chipFeatures_PIPE_2D'
>> drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:402:14: error: 'chipFeatures_PIPE_VG' undeclared here
>>
>> Culprit is 'drm/etnaviv: rework perfmon query infrastructure'. Applying
>> commit 15ff4a7b5841 ("etnaviv: perfmon: fix total and idle HI cyleces
>> readout") as well fixes the problem.
> 
> Done.
> 
>> v5.4.y, v5.5.y:
>>
>> drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
>> drivers/mmc/host/sdhci-tegra.c:1256:2: error:
>>     implicit declaration of function '__sdhci_set_timeout'
>>
>> Culprit is "sdhci: tegra: Implement Tegra specific set_timeout callback".
>> __sdhci_set_timeout() was introduced with commit 7d76ed77cfbd3 ("mmc:
>> sdhci: Refactor sdhci_set_timeout()"). Unfortunately, applying that patch
>> results in a conflict.
> 
> But that patch can be resolved by grabbing 7907ebe741a7 ("mmc: sdhci:
> Convert sdhci_set_timeout_irq() to non-static") which just makes
> __sdhci_set_timeout() non-static.
> 

7907ebe741a7 doesn't apply to v5.4.y / v5.5.y either (because
sdhci_switch_external_dma is missing). If you resolve that conflict,
you might as well resolve the conflict when applying 7d76ed77cfbd3
instead. After all, 7907ebe741a7 isn't really needed, at least
as far as I can see.

Thanks,
Guenter
