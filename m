Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECC942712F
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbhJHTJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbhJHTJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:09:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5126C061570;
        Fri,  8 Oct 2021 12:07:18 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s75so3988303pgs.5;
        Fri, 08 Oct 2021 12:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eb0VmP8uBk0htYY3QkgDPPUn6vRuKHOLfbwBh76+ghw=;
        b=S0SplhS7x6ANzlRfG3bkUKrUWajKc68cNGzPe/cZwix7XjkItXxAnuyF7oIoShGu2l
         O4ZjwQIr0RD4L5rLbug5DUsxV7QUXxdQTh845e1GdeRdAx0+H/2xLvGn+WG10KqyrD7Z
         5L/NyevIN3khH/6fQXMsxvus7Q9enk0jNSbvebFcIvlt6na3dvNF7JwrmgZEy8G9Uhc6
         qGqmYKo/RWinxgULPi/TEMyTNgkEinRk1e6WkuGBS9eGmxMBZjwv+ZAI4A3CUyWZJ0gD
         rJb0c+GDYpFtrAtJh1ZXcpytrO7mtMhqniN2NdH5pPlaf2H/bE5SCxhuaOvIlpxTx0WC
         SN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eb0VmP8uBk0htYY3QkgDPPUn6vRuKHOLfbwBh76+ghw=;
        b=46pZv2TGJQ0S5GyozUZIxfEeWCrtSHnx4QIWbESgflM5d0GA+K3r5hETk4qVFUOqGa
         pyP8vYfbG/JDvaFXcqm+e9G4haadAxnkK5iIO7wy4QUsBjkI6uXItcfmsw+ZidEPChYU
         19tWyQVIhLm9Uf5gkCjx40Njq847iCwq5P+31dmNtnnqNTdiHfc8EZIkeWa2iVQ9wUQ6
         wa66JkqF4DcSg/C6IXyM2c5PbeHIN8r4zkLXQ1Y3b324DlQlmPlrkEJS8QqMx/UvXnKa
         YfYpDTMHEJpYywgr6DBdA2Pg+Lpi9jJQtDMst+yCbIQGPCUjAbS7mkpM+Dl2eMeLAip7
         MMKw==
X-Gm-Message-State: AOAM533dFSsZYwyYi6QaomLpCeYKK+x3KFyk1YFBUN62mg7iFmAg3Ove
        0PY31qQrc2CUcv51TjuEmngqRf1QB/A=
X-Google-Smtp-Source: ABdhPJxdMWsEV6/++L31MEB6pk1+UNVLPdk5oCipc/XR8HlKoyMosS4ejzDSUhlr9JX0Cavxsc3vFw==
X-Received: by 2002:a62:148f:0:b0:44c:dfb5:4b82 with SMTP id 137-20020a62148f000000b0044cdfb54b82mr4817981pfu.55.1633720037655;
        Fri, 08 Oct 2021 12:07:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t28sm102642pfq.158.2021.10.08.12.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 12:07:16 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/8] 4.9.286-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211008112713.941269121@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7c2be482-5cb8-4864-5e92-d90a5d1cc83b@gmail.com>
Date:   Fri, 8 Oct 2021 12:07:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.286 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.286-rc1.gz
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
