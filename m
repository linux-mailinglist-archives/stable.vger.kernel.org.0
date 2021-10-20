Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D24434A35
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 13:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhJTLk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 07:40:26 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:35598
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhJTLkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 07:40:25 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 90CBC3FFF4
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634729889;
        bh=1bxWxV6xahA2c9N9IIfRQwFpQ4gEUEegrCc5ZiAPUwg=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=NVWl9BTpCHq2QHQ20Dv01XymvPqXZ/cVcb6/41FC8s8eaz0tyyTB+sOs8jvGouc3i
         4n7042tQr9ogd3hJTGn91bFyrUdSS6xRxdRNAhzC6dgXPuJZjxaejA0SudxUVWmr47
         IrJVIc+LevmV4B5UgX8RuhDZ5eLDbMN9jUt7NadinjkPxZnwvd/h8/PajoZ/zJmHrR
         jNulg0Q7CwehqkFp/RjwBthIhc2Buzjy9s1PBbNa7/bBpAMvPMYQdgPNVxAw5pjUkd
         a8vdDt9i3Is+0Yy8LVk0OUcPZ81+ZCcRrNCsCXkKICIMDWaOYVEg5Pc9o1W0rbqIAV
         u+D2RLf4hrZSg==
Received: by mail-lf1-f70.google.com with SMTP id f6-20020a056512228600b003fdc9741438so2936748lfu.18
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 04:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1bxWxV6xahA2c9N9IIfRQwFpQ4gEUEegrCc5ZiAPUwg=;
        b=5fdGiWya+cjD0klrbLsL+NYfdlPeH4jSWhWEIq3fmVn8/5lskwz5HJ/wrLJRtSrCGq
         DEudr5FpNyyeZIUyDR2gQd8qyBpL9bUBSyee1X45S6S7DW6lkcaLZqZcrLP380luQ2AE
         O6zQY62bvtfAVzT2eAsIQafuVfTso/okEFxFOJuclCQmIPazanLdg13V4/yzFEe/BPlM
         4yQlLPDFGxMNn23EmWCqyR0TTL/KPbt33QYH+JzQARQkKvOOrNxeI2X2vayZ1BIY0IkX
         yxThU6KwlDnXMOGRuXiMLuWce5q0umtA43rFQknr6wvJ757uXYBPl4N5lplLXVfMUv7r
         VyHg==
X-Gm-Message-State: AOAM532vwsk0kDOGY76kx3k7JYfurOt1gzLUcufqZPS5AmrZxwMB0uHI
        hSsVDju5oTY7u4BG/UgsrsI585yxHWbEBDwHYzpoDZs58RHBg7QEKY0SVafQoaLLaqGITYhYLjy
        S+hNFzdKdVNpOiZ9PTGOhukuBG3ffa0YHmg==
X-Received: by 2002:a05:6512:2117:: with SMTP id q23mr11447293lfr.657.1634729888638;
        Wed, 20 Oct 2021 04:38:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN5uO9eigZSlgvdW58qAxX9R47x6QiEM9Oi0qiFSPAgUh8dkl1qA3pzN/lXMiIs5LhqKNZHw==
X-Received: by 2002:a05:6512:2117:: with SMTP id q23mr11447272lfr.657.1634729888424;
        Wed, 20 Oct 2021 04:38:08 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id p8sm194267ljo.41.2021.10.20.04.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 04:38:07 -0700 (PDT)
Subject: Re: [PATCH v2] crypto: s5p-sss - Add error handling in
 s5p_aes_probe()
To:     Tang Bin <tangbin@cmss.chinamobile.com>, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <ff261b7b-47a2-0cd8-8dcd-91f18998a482@canonical.com>
Date:   Wed, 20 Oct 2021 13:38:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/10/2021 13:06, Tang Bin wrote:
> The function s5p_aes_probe() does not perform sufficient error
> checking after executing platform_get_resource(), thus fix it.
> 
> Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
> Changes from v1
>  - add fixed title
> ---
>  drivers/crypto/s5p-sss.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

You still missed the cc-stable tag. I pasted it last time.
Cc: <stable@vger.kernel.org>

Best regards,
Krzysztof
