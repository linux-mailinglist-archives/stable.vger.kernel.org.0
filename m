Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA80F379271
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhEJPV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhEJPUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 11:20:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3425AC06135A;
        Mon, 10 May 2021 07:50:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gx21-20020a17090b1255b02901589d39576eso3922963pjb.0;
        Mon, 10 May 2021 07:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3vrrzGUBs7FsVtL8t1nHxjfwL/EO7cscD34RQnw2Q5Q=;
        b=dG3kaX6hffxhJGGZUPgyfd5PPrfrvZcDVtDTTyYPAt4njUyIgU4pqIkIX9m4DhPpG2
         EA/gbSlJvhBQNIiy7A3ef43o3eYIc1PWmkzgxnbc6KTUwGfrk0nxPiq2mj0f9Fi8bbdD
         eOfHQrZx2oeXuTwFvi1RQq18RmioKGYw9zSAgTMJOemK7z93WVBYdRYogqRM2Yd2zniV
         jG7Xp/fB/au9+GtKykD7ZnftReNg739mtCPpbpZaLhha+aOnTg+nJfj3lbaRe6PcaXR4
         pzvIpljPB40StCHnn2YNDOrGqoOYTWSprBr/x9VZRQSuMOHCIn0qJy3ftJDnYJnpWMRZ
         l7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vrrzGUBs7FsVtL8t1nHxjfwL/EO7cscD34RQnw2Q5Q=;
        b=q/bLb44SH4NJUH/7dOoi68VY74WACK9aXQjJf0NZxKtYJzPJZ8zjZt+yrgfFiMZ80J
         x0cv6TTo0Nj2Eb7+R0MK23v9Wkj+2+qdxCeQI/LrzXEON06vZbLb4obr4hLkEi8/DN8l
         mvxuBf9bAAstglrtoehAvBFvYwA0P0ram1G4RtgV7z9ssT7Q+EP/M4ybD6zSTENoIt3l
         ZKZkWlvt+bIibUf/7LOobLbRcxGWliiVfLRDI43t9Du8rGkw8L4yX6QLUiKZ1x9RJGyU
         SrAfBjOBiM6FU9QE8y47M4mVr28TF/tUsQZu0GeNYdnLh2BG9yzXJ60YHpypIUqs06W2
         o4Cw==
X-Gm-Message-State: AOAM533vKgMRP2LQ1s7udq6o9RUbX2AtLbE5AnVau6c7DFTBzAOQdZrr
        9QKcSya1pUMSFXvZBppvOY5IHIYahD4=
X-Google-Smtp-Source: ABdhPJw9VwJtxzPVphLhlxeEy1/OsJOgRAFbhfkFWUdLXJHnK2KRxgeRtLdROOsmMK/3Qg9WLvrjMw==
X-Received: by 2002:a17:902:e543:b029:ed:4852:5493 with SMTP id n3-20020a170902e543b02900ed48525493mr25325249plf.56.1620658233392;
        Mon, 10 May 2021 07:50:33 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3sm10690389pff.132.2021.05.10.07.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 07:50:32 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210510102014.849075526@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ace53b2-f14e-76e8-2624-3525f5a530c4@gmail.com>
Date:   Mon, 10 May 2021 07:50:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 3:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
