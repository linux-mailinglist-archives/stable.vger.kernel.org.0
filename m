Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04D33D7C8E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 19:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhG0Rt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 13:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhG0Rt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 13:49:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB36C061757;
        Tue, 27 Jul 2021 10:49:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so16503787plr.13;
        Tue, 27 Jul 2021 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/90bD0CMSvquUz1/IZXhJDqyvPntbvBjimJMpEbNOaw=;
        b=GlTDNt5aNhmra8mJW5QnAHdANHHkLYUymxn8z54gn6b8nYnnI0Si90QyxitElQy7Y6
         +z9uaJtNARJ4FMWZ+occbbdny8N3m0cOW4tDCQ9124mB7eNxHoVVmZFGCk8GYyY1B9hc
         OppVwsE9RLVYN1Tc1uV9EEwOFo6+6ZvOVB5SvZJrwB4Ou2hyLVFyg9YAh+KC6/gSgtYY
         RxjBqYZrdz+KCfm1gCcc/6Zu2bVcmW7sqcNkLfuwTQzVkkocVJHPdFTlTktqKfCTOjZ3
         gPXyR6SUh66tNAPNf06O1rcQpTeNRV88pUyuK0M8Zs1rPQbDSTPnn68qQDTIFdBDgEGp
         LlUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/90bD0CMSvquUz1/IZXhJDqyvPntbvBjimJMpEbNOaw=;
        b=Wizp0X023GFFD+r+7tSn/44Z8h3lvg0D+ImRAvoXL8nTOZofuVzUUQrY8+2IBI2OWC
         J8yRTwU/5iAhBHz1vcp0HaKql9oaZJp4kd0BIIhQmkCNwwEwOTTFBdwugAukQERjPy5+
         CTMyA15DPgii2YAuNoLOoHZjBVU1D6YqE6u9FGvAx8WkeisA8jcCRPeFwD6u138jTOyd
         Sh4rThNeohyAagCNg6vx6nwk+kufAXmTbg0yWWzkVdHOGt2CaENNsIJElBYrQQmZst3D
         0o/9AWBbHpD5qx2OBbABnJUJEdZTI1j8lXVaGWwuEZfPMBi9vT64p2BpJlImFjNYu9Zc
         xm5g==
X-Gm-Message-State: AOAM531zyWS1B96NqLpj7DFM4nHbbt9tLyZh/A8AGfo6FScBNYvF1FPj
        aK9hu87ASHbd+iZZ4uSYCd7yGED+k3Q=
X-Google-Smtp-Source: ABdhPJyUbOVoiRz9nAEXYv4mhtYwmlzIYfHabpSDHpn/W1tlxmcGU5e6J06hv+ykkClOfUhIGIRdww==
X-Received: by 2002:a17:902:ed95:b029:ee:aa46:547a with SMTP id e21-20020a170902ed95b02900eeaa46547amr19712443plj.27.1627408197386;
        Tue, 27 Jul 2021 10:49:57 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p3sm4674708pgi.20.2021.07.27.10.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 10:49:56 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/59] 4.9.277-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210727061343.233942938@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d74b066c-883a-85e2-2cd1-762a010bea8a@gmail.com>
Date:   Tue, 27 Jul 2021 10:49:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727061343.233942938@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 11:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.277-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
