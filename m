Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19F43A585
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 23:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhJYVLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 17:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbhJYVLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 17:11:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8B8C061745;
        Mon, 25 Oct 2021 14:09:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id l203so7427831pfd.2;
        Mon, 25 Oct 2021 14:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+T9sZO3wMX0fSxI4P/Aep0YGSBlmwjihZUi5Fu81DoM=;
        b=FcFrEM5TIaHgiY2m5YeUeBNs1wmvPwWgbzd8PXbRGgHM8ohxY3wNi5ht+F3oipugAf
         AhW/jOYkhy/VnH7GeU6QV9HLQfLVol1xdKVEYogdujYbPcYZ011D1UBedFombdl8T1MS
         qR7hxlyvhDZSbKlMe3lCZmRjR16dlJM0tU9MYSTLf3Fphz6K45iOc+wKU1WmJuNbvexW
         SSBvQOMHEqTMFyO8W5KkZx1Hb2nffUvXmfeMDgG9A5p01HSSo12E3swIj//SGBhnLlMI
         kIVaDOia1KObBHa/6/eGqP7W7nH7JHIPnPeov4pZyhhSA+hf/456sI4xQ1D2y2S43cEO
         fgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+T9sZO3wMX0fSxI4P/Aep0YGSBlmwjihZUi5Fu81DoM=;
        b=uMSQly+2MSM69OryEHTpdXiOUqUGK4V+lfAjuvCglS3ca1//geFYwvDWBE5dLDrd/V
         /8b1h/NncZ7DEQqHrJdApeHTzXgQNijMU4nQ5LLHU5xyXXe8mnSNGYbCmD+WSfZpMP7A
         Rnwe5zC5UgIfOn4fS2SPUa2gTcmNk25OAW6WwbrOntZ178q/+hdZUz9HzgQbE8xGIXaf
         Z3eGku+VJDzL4KoBgQiUJ/xx7TWum8kY4yzK/gbm+CHpWsoCeMdqlSqHbWSFOt9LfDZL
         IYbKiwt+dYlh1BAYqxlC5y8N2UxnVoUM5RbPdDxodUis7P6JtlxGLOPRUJ8IH13pt6fM
         Oqcw==
X-Gm-Message-State: AOAM532iij8eEJuMVduHVEyuqj2ix2HNaVHjYTDiLt8XlReRgdcO9p9Z
        nZxk1MCE20BWn8nT3FubhPM/tMRTops=
X-Google-Smtp-Source: ABdhPJz5jMycFT7ZMdDoFIfk3CffOoR7L0wKIZYqnwK0pm2V4u5U2Fw/9xxBAUSJe8qas2D1lP+f7w==
X-Received: by 2002:a65:6643:: with SMTP id z3mr15723044pgv.16.1635196150553;
        Mon, 25 Oct 2021 14:09:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p7sm17063026pgn.52.2021.10.25.14.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 14:09:10 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211025190956.374447057@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <75a4fc7c-bb4e-dd61-f72a-82f717a55471@gmail.com>
Date:   Mon, 25 Oct 2021 14:09:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
