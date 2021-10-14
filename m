Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4690042E3EE
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhJNWGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 18:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhJNWGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 18:06:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B760C061570;
        Thu, 14 Oct 2021 15:04:34 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so5853709pjb.0;
        Thu, 14 Oct 2021 15:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ft7xPvpxPjNvqJfnfhY1c+tEoWmIqcozroJaIuX7xCY=;
        b=pt4b1lxzA6K4bCXlDkarQiKlqDy6sWfp2L9WI/f16TWFVybrSlkheqQdgM70awG0Yx
         WNR3yxZX2IAZLE33ZyQwRbJ39MvI3cHPyKdfkJq82o6sfrs46VsyMwm9kB576/l8nauX
         qfYmmcx6H3bSvOA8CM5+TcHYTHk9k9TMEY3p/yXrsRV61h4RwAR0LHXxCJ3/eHOfunA0
         TWgXh0iOr2uvYKiNWyMfVae0Aegqt12tqMKxwWzO9pzHpatvzr1KINeV1Abju4QBnjfD
         0w1p/yKErfOYYNTl5YZYwdbmQ98NI+LlrzRqW7P0UZg1Hw14EywzAymuakoidhj2wjMl
         19+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ft7xPvpxPjNvqJfnfhY1c+tEoWmIqcozroJaIuX7xCY=;
        b=6loc1LpQg0+Z9xKfjYZQ/X7qTqbuXXMLAxp2CgNPbSNvAVmQngUDkfbtcjbV5prjR1
         rOzLGSugl5u+4cZ48LrafIUtxdRbk5/TqDqFgYoEhUzrL9IK0o9riiVPpSGICbYRfv/A
         MKn3CFWvexcyztE5tM23fK2vV8LwdcYI/P//Sau2T2WCc9KBgeHvVvnbQq0hZbYLDYzJ
         +h5KFa1I1Fqme5N2f7xGsJ8htl8OQSMCdlQq/sOgTWRz3KkOQC6m+wBlSDlAb9fBw1SN
         Ez/wGn6QbHqz6HY9wT86QjTbrujg09EH9RkDxojBE8eLx+KdmT7GeOKyXINkKdPhhZjc
         ngBA==
X-Gm-Message-State: AOAM532RsykhfNEOu/zdc7gsGilIFAMLc7NgAMFuihVABKtZpFGDy0gT
        v93z/Egiu4g+buCBcauqDyU7OIjTVG8=
X-Google-Smtp-Source: ABdhPJyDPsOpZd9UYqIYR7ARk2Dgzi6Bqtjaahmrq9g8OnR3Di6yYvSxjJm+bIHEkHiaT929re3W7Q==
X-Received: by 2002:a17:903:32c3:b0:13f:60e1:3f51 with SMTP id i3-20020a17090332c300b0013f60e13f51mr7537979plr.41.1634249073063;
        Thu, 14 Oct 2021 15:04:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 139sm3340389pfz.35.2021.10.14.15.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 15:04:32 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/22] 5.10.74-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211014145207.979449962@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21b33293-31e9-cf38-e27c-ed8495562d05@gmail.com>
Date:   Thu, 14 Oct 2021 15:04:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/21 7:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.74-rc1.gz
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
