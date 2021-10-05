Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EC6422DAD
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 18:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhJEQSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 12:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhJEQSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 12:18:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747A8C061749;
        Tue,  5 Oct 2021 09:16:50 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s55so16777660pfw.4;
        Tue, 05 Oct 2021 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nh+5upXdEhtuQ1MmKMpGJdn+SFhp5tfbyBTQ8db9sCU=;
        b=RP7+4tIktOJIiwIGW7FCb0dNobsLneSd6uy85ut6w6V+85mIcZybF120xSrPPeOgRN
         aU6Iyzl55d0Bd18Hd7krvvTl79YiCzxNLyGgpfg037P2gBJX1xn0ofLYWH8oESe9iHxF
         UgmQ0la29Z5JRmAH32MW698+WYx0MQiL/hAzk7g3qnMiGMU+++Hh6aPP+RV4ylwerinX
         TLpSfNI2TcYpzHxRvyR/HA4YBTJSqW8MENrx/6SWllIwcw7D8Jp0sfcgvmIBZs9FITas
         ktkWSd7jKbCQHWhjz70l//jsaVtFCeMTL9VU2eKzgCSFgEm89n7JR11P+QOOSqoITyNX
         W9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nh+5upXdEhtuQ1MmKMpGJdn+SFhp5tfbyBTQ8db9sCU=;
        b=3L8q9ortu627XfiZ0ul6LQCoKpRcYmoqQYv7y92FUPu+Y4n49vF2Bs6XqBNNbdhjL8
         JuYvBvtVzPFJKmpFsbStSnhxAcKMOq+v2DWHe7jQ8NfA2f1oeX8YgXHB2oCWUjmbeN1h
         7ff/7X3o35abS5fouCMZ66cNRDwpn9WmYSQza0mDQsBDyrw1LxtXfWnmf2I1hQNSJwpa
         f9upQSZRh5Npwbqe9ySsrPT3WTzf3XexTf7qvtxrG5K7H5tYZp87uVPpMONfen76hb4p
         jzBtUvZUXri19g6axXgzp4Zk1kgCjinWsCYW/ELbP56usFo2H683kAipEt8XYibUJaeZ
         3JGw==
X-Gm-Message-State: AOAM531eDVDgQPf/n8MhGZ5m7eURcVyE27m/v2zeRx37wV/4sU/BOjF4
        i5N+L+DI3xQosqtavFOV8XTyH8OGxrE=
X-Google-Smtp-Source: ABdhPJxtZPs/kLdnNzd/qMFQHh2cA+i8UVD4me8WG9dglGrfskFqBBsYDZM2/CxuOkaZCB/6X0hiwA==
X-Received: by 2002:a05:6a00:22d5:b0:440:3750:f5f4 with SMTP id f21-20020a056a0022d500b004403750f5f4mr31481964pfj.64.1633450609161;
        Tue, 05 Oct 2021 09:16:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5sm2641220pjn.48.2021.10.05.09.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:16:48 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211005083311.830861640@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <98bd3c55-49c5-cfc2-6f55-77bdd623a7a3@gmail.com>
Date:   Tue, 5 Oct 2021 09:16:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005083311.830861640@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/21 1:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
