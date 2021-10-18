Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A334328B3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhJRVC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhJRVC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:02:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FBAC061745;
        Mon, 18 Oct 2021 14:00:16 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f5so17352521pgc.12;
        Mon, 18 Oct 2021 14:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qjCLjNNuC+CaoBNv3qy03uO8pBqwDKTK+8JZj8umqAI=;
        b=KowFvAkJwh6YbhELo37hGXEvdb4mLCo7AkKIf7k+TO+IYJl1gH7d/2WdS5DzwEHWy8
         V7cUUvW3/B0G2453wHCzl7IuFjBHidHBGSL5GzzhgGDutodhLgg/yD3wzaj2OjOavbgO
         kmj1gQ3AZMTMDJUVnuRS3QMJu3IEO2nWIbrLMU1N8/36tIhxQv8OXd2Ema/Aid8V5pkX
         pinB95SNK2dTcryTkBoLL5RXogUrpWthbsOG1zhSoQGdZf3LfrPla2nA9wj3jG/FMzRf
         gfhFewUfGB4qudghy0E1eZnk55/EFvovnNLKeDN9L+ElIcDy5at6WHCoG3Fu4Mdx3bOc
         rMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qjCLjNNuC+CaoBNv3qy03uO8pBqwDKTK+8JZj8umqAI=;
        b=5RgmB7BhBeVy5LD+suoBr8e+G9n/pcfKKvN59icIENS4xhKXhJLenZuI4bQ7E25UiW
         b0RKL3PaGzTFiu2yuj0NRbcJOtBjPADgfhy7vEc+QDKSavuB6htR/ict1f5Yi4t8DiAo
         frqfL4xzueXStY3H3klEni7N1n/0SBXgqY26zpUy+8M1kivnU4HCpR9aP4rI7hUKX5Df
         sIBVjRrD+pJNEc2pNzlqVRAp8A0p3jlw0BEVr3ULmiW5JbxSPmgdUp1pz7hBtmy26jDn
         /JHT3HFMMrhNK48+SHrY6jRmqwjlZWakv1ZrgRJoWrlRuar10HmE2gCKlkddJ3etf6VP
         MHNQ==
X-Gm-Message-State: AOAM531ryCzZLjY1/pos96Lv1bbI6QzHRDfHZZ4+tFrvqJkC6v9KvZBh
        CxlQR1BGmctELARTbU5bUkuKPt2aESI=
X-Google-Smtp-Source: ABdhPJyDzp1s9qeHKc4YO7vdVD64vqFXlzF24RjkQlsisvM1m95u7xOUGdCGDrrltuC+1grBIbQlaw==
X-Received: by 2002:a05:6a00:992:b0:44d:8981:37f6 with SMTP id u18-20020a056a00099200b0044d898137f6mr26420205pfg.76.1634590815028;
        Mon, 18 Oct 2021 14:00:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o6sm13941598pfp.79.2021.10.18.14.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:00:14 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/68] 5.4.155-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211018143049.664480980@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <faceebb5-7f31-f935-cdc3-899a31b324c8@gmail.com>
Date:   Mon, 18 Oct 2021 14:00:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018143049.664480980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 7:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
