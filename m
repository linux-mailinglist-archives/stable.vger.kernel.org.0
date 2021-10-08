Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32E942717E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJHTms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhJHTmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:42:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06AFC061570;
        Fri,  8 Oct 2021 12:40:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k8so1376650pls.3;
        Fri, 08 Oct 2021 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uKLJdoAhaCksgeO5/1rfMPgPjtVWV8ShUCkXtMKctvQ=;
        b=UyfvBAUJtVv7T6vgU5to5eZvJakmZt/oaJCwrS3a282MxiHdH2ewe+ifCixd4ezsOz
         JnehY+wiq0ofRYJO8Qpl2r/7kb88fJDQVJdw4Xv/5NPqFssZ/WzIB3b5djv/lFjKfq+5
         EVgOYLjMbhuAJrF7NI/4Ptey56gfY2BG2V+2bSnKeHwBVo/ZOx5uqRXRBwRGhWP08ZR+
         EyO1aSDdMlsGUJP8vCuQpqV/fPhNPYAu1CN3YJGxWublXgHhgwbrtZg0CA+e8lQ2AZc5
         WIBb0+ZEEX69sIUgx7uifQe5XS9YL/ZLDxz6InYEDqvoZkrKhj2v3Bfz7foBJFsMeh8n
         Kw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uKLJdoAhaCksgeO5/1rfMPgPjtVWV8ShUCkXtMKctvQ=;
        b=gJdAM576s9FLDBa8Q8+0h6HUatlHU8tE3qYSETeH2VR99dA0+7smhy2laBkGkNZLOw
         vXmLO6+4n+ToZ3TnV1XTGKZR/iil/A5BkBw1Ghq/ekBHXOD3gNcChjIZlUi+IFtb+tLZ
         FzPLfN1fh8Fk2mexliPMv0JfADFWrQ1lqL1M5mZEBg4KK2upkbRg3JUue21L7KZtKvgJ
         KCHk57w8tt3ict0E9Bgy5fyJ/g4NO2Q/55E7yW7f+l5CKtjq0R1uMpIzR4QuE3us9zkz
         0CvmneVH+fNXvzvtr3yR9iXrMNa5WTt215XGTaU0IR67rSrzQQ14Z63VMFWLY48MXuVm
         c3xA==
X-Gm-Message-State: AOAM533/T8GYuNymc2vlyA75EiIjqCDCuF/hslOThLECh/EAKJpvfgwh
        EkczStX+xdB8Xm7sDf699xgFHioJQa8=
X-Google-Smtp-Source: ABdhPJx+oEAZyGOUfkU9uhPtRrRXwGxsbK6hXNSqIktn330h6hFDcSdjrz8gW+5BW4f4nUFNMUzx9A==
X-Received: by 2002:a17:902:d718:b0:13d:e2ec:1741 with SMTP id w24-20020a170902d71800b0013de2ec1741mr11109437ply.38.1633722050778;
        Fri, 08 Oct 2021 12:40:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s3sm11315516pjr.1.2021.10.08.12.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 12:40:50 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/29] 5.10.72-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211008112716.914501436@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dabad64d-7fbf-2eb3-9baf-81c1d3b8e31c@gmail.com>
Date:   Fri, 8 Oct 2021 12:40:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.72 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
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
