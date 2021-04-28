Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70D36D415
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhD1Ill (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 04:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhD1Ill (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 04:41:41 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88779C061574;
        Wed, 28 Apr 2021 01:40:56 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2so5173677lft.4;
        Wed, 28 Apr 2021 01:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVYoHb0j5VFpSmctH5aR8XGJ4ktZiFaaq0zVF+LId6M=;
        b=VmsGeVNhBij6WOHJ1eY4hSlEkPPsps8a7tFi36TLwEKoHl8nZdwE1/LgTd1Zscl3lS
         l5JyzVZKh4Uoiawv1bs2Qwho0siLbLViBIhfa147ATHN8KIECJHBlDS5zM5F2efuzjg+
         4yXj3IYXKVfY4P61gl5P7cdnbFfqGpd7nYy9bLtBPi8VPYqRLmP+xRT6TaynchVkqVHc
         +zFjKDvG4BFm+y0hOAmutAKije5e8uslKiP64BJvnaYvHFe+iI9rMxVNzIUvWiY0JpWx
         EvUJ+7BYCtxK9Aw/+xyZOgqc/u98NqF3QnVE37EQPbWtUY+2ilLhnpQHnDN4zHfAvA4K
         ke0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oVYoHb0j5VFpSmctH5aR8XGJ4ktZiFaaq0zVF+LId6M=;
        b=WAf6VL/uuDWlLH/j7SPApNObmMhT0EXfUwri7QXJ7/E23HwxN6LrEMKNEE3tiRFuhp
         GySKlguqXvmLq9BWrvfOAAdijcRPdt6i4u7cVFEH0Y/+qZcScckpxgedECKurnfjCUgi
         UfW5YX9gjIvpbezvIkYYrEeDiiiF995L3WPYDtIGN1DeaAklHFsgW5PCzEKnE05qf0+F
         7N6bVRZAEDogi9hBCVVm+3fxYYCg5bp6IoK30ZIR/H0VhQhBnarNsjap7ff8T9cKqZNE
         rZCexsrpd7kbKXEtetvMwJ8qsBqHSA0nT8L2ztCk88lWv0Ism/rvJc9mk2b37VyCSj2n
         qTPw==
X-Gm-Message-State: AOAM530f92RG+qSGUaB8VQAEbgfEmOjDcXhf0E5jQT2n9GjK4MeJ1X49
        DBxH4OJfJFnAzCPipeolh2xXPkaF4ME=
X-Google-Smtp-Source: ABdhPJyoXlMRwGItruwsciGuyz3DA7HhF4EfUhAvxkd5DHvXOkbFQAE5LlaG+9S92qRtX/BA+PDpFQ==
X-Received: by 2002:a05:6512:3c8c:: with SMTP id h12mr19976447lfv.388.1619599254899;
        Wed, 28 Apr 2021 01:40:54 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.87.27])
        by smtp.gmail.com with ESMTPSA id a20sm1005787ljd.105.2021.04.28.01.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 01:40:54 -0700 (PDT)
Subject: Re: [PATCH] ata: ahci_sunxi: Disable DIPM
To:     Timo Sigurdsson <public_timo.s@silentcreek.de>, axboe@kernel.dk,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     oliver@schinagl.nl, stable@vger.kernel.org
References: <20210427230537.21423-1-public_timo.s@silentcreek.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <24eb672c-9772-4e3f-e3de-0fe3390c659f@gmail.com>
Date:   Wed, 28 Apr 2021 11:40:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427230537.21423-1-public_timo.s@silentcreek.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 28.04.2021 2:05, Timo Sigurdsson wrote:

> DIPM is unsupported or broken on sunxi. Trying to enable the power
> management policy med_power_with_dipm on an Allwinner A20 SoC based board
> leads to immediate I/O errors and the attached SATA disk disappears from
> the /dev filesystem. A reset (power cycle) is required to make the SATA
> controller or disk work again. The A10 and A20 SoC data sheets and manuals
> don't mention DIPM at all [1], so it's fair to assume that it's simply not
> supported. But even if it were, it should be considered broken and best be
                             ^ was

> disabled in the ahci_sunxi driver.
> 
> Fixes: c5754b5220f0 ("ARM: sunxi: Add support for Allwinner SUNXi SoCs sata to ahci_platform")

    The "Fixes:" tag should immediately precede the signoff tag...

> [1] https://github.com/allwinner-zh/documents/tree/master/

    And this line should be immediately after the patch description.

> Signed-off-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
> Tested-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
[...]

MBR, Sergei
