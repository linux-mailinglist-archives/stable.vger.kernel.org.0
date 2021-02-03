Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808FC30DE71
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 16:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhBCPmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 10:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbhBCPjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 10:39:18 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D38C06178A
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 07:38:36 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d6so22788849ilo.6
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 07:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2XdbfI16WJbR6LSg9tBZS+BqrfD2/1ScjFS440UM0KE=;
        b=E5KVmQN8h1Pgzo+oy/kc0MNevkV4u8gnmPcDMgtxBG/TVWs4/jMswlZoF/TuhknEMb
         yxzHe9jTE1vMt4uNuVG/KkhU6evwJSmtCO35JgO3Y4+pD2iVX8Y+scvbCHT+C52qHAnM
         zhfUTpNf4jbckd/huHzw4urQwJDH3xfRWykm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XdbfI16WJbR6LSg9tBZS+BqrfD2/1ScjFS440UM0KE=;
        b=U8tt3k3PYkuh8D79oDz6Qugbb3xgmxzthff9zXDDxawyxPksn91PUAXCC0yIzI5xor
         AlgQHwr6cM+o5hN6QYQGhgNgl8RwRPpg+91PDsgqfFaXMq6ENCNr4BvV/WX9CLtwSA1s
         da72JteKM/MBZaEVcBtjFp8S4Vxf/ILMqcr/bYVo0KBh7zgJ06A8WjsJB2WhFTyU9ExO
         CPYWvPnGf5rJlGn9DqhUq1y4Cnu/B3alEETHoHWHpRY4iXrLU0y3aV4LFvvP/WkGMPA4
         oFKlckpbvqH1Nw9r/uC+Mqn71+HbxtvL+T6hyr0Yp1KfIfvfA/Xd/sPszwdFA0Y+E96T
         FfiQ==
X-Gm-Message-State: AOAM533Q2e3y0NiwZctiyExfM3uD8ngze/DuimtvzqW0e2DRu94JsVye
        hf90UylyzpQHR8t7mx5a8z9uCSKuV2jSww==
X-Google-Smtp-Source: ABdhPJw2rUpzn/QOzVxe12w3qE3Bn1DOeh/cH98+MIzA8KN9qHhXN1iHa4ZNYIrkMKSAgI0sAPq0Rw==
X-Received: by 2002:a92:d80d:: with SMTP id y13mr2914482ilm.299.1612366715953;
        Wed, 03 Feb 2021 07:38:35 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f8sm1196834ioh.42.2021.02.03.07.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:38:35 -0800 (PST)
Subject: Re: [PATCH 5.4 00/61] 5.4.95-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e0d89c59-77b7-b5cb-eafd-f8f0af815175@linuxfoundation.org>
Date:   Wed, 3 Feb 2021 08:38:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/21 6:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.95 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

