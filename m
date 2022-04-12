Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723974FE4EF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355548AbiDLPmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbiDLPmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:42:21 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD75C661;
        Tue, 12 Apr 2022 08:40:02 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id i23-20020a9d6117000000b005cb58c354e6so13614444otj.10;
        Tue, 12 Apr 2022 08:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=updOeMl3EWnF1pS4jf+Nm9m7E0WIYeBIm4x0SWDVuQY=;
        b=PQ1wyr2FrAehgU4XTU9Yq48fQ96SLtAlPQ1SmXWhEoqumJPpAQsYXy1tAj3/aUXef0
         mGuT0p+Fb30D00GWkZPd6bty/UWN7noW5Kbb9PsRM2XKvpBMl/1jJyOj8gRtSo5fjWQn
         XVO4MXgvOy4EvcS5m2JwvjJU1EFAmLhiIk3xzH0WB1Nwp0ijnfEcOd5X1gT3V2tw5o42
         8X7ZsuixtWfhS8w7XKBgWuhNeOrxIB8caNYeF4cv58bVBfa4YLsAwSvZ47gga1wIew+j
         OnFT/9p5yl7y6QoDuj8lTpQkqzqoV+EL1xQFV1mBqKzamEX1zjBTJMPsSN7TCm3zY7U+
         fKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=updOeMl3EWnF1pS4jf+Nm9m7E0WIYeBIm4x0SWDVuQY=;
        b=gEqa4dHYwXhuvnY4hhEcGp8BonvWd79Qn3MQMp2GgklpGahhUeQjJyTFLpVNoIJONO
         6U+xNTxCCluS+7qXM/973lcKBlcxjfv6Gof0BZ8iv9N1tgCkOiB0UliSWxu+rUnXqZDB
         Uho2+Qtr8rNHSnzx3RvcMMy/vlySMB/2DP1Slo7lEZkH3zthRcFGkOwbJVkAtwHmjM4h
         VT+xku1pLzo1i5vsMIQw53PbsTv1bgjR5N3XzPY2qOkQPeWtI74ax3hmJJjFoglT9qCJ
         touaa4ZiY5CQXfUhcRRy0zoX1EdhxK+XPR6r71TsYHz7uIHN3kN3hGhUDDLUcF7H14Hz
         mFxA==
X-Gm-Message-State: AOAM533w1h+whPg4eo7AYDAWKKRenWy+CJ8fo1PCpXQL1yDK3Og+WUlZ
        ScvHQ6lrXVxW9pe0MnXWi7XgnE8WvZ8=
X-Google-Smtp-Source: ABdhPJy/T/3w8cKGQssXTNtCqPm9zBUIk/NHOB/rjCK54RUN25uHKkBKjcc5oxStvgusk0u6YDxKxw==
X-Received: by 2002:a9d:4c14:0:b0:5e6:c6be:824d with SMTP id l20-20020a9d4c14000000b005e6c6be824dmr7488255otf.204.1649778002283;
        Tue, 12 Apr 2022 08:40:02 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q203-20020acad9d4000000b002f8ee3f69e2sm12694109oig.52.2022.04.12.08.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:40:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6d0ce49e-06e8-ce9b-ee8d-8bbabbe398f5@roeck-us.net>
Date:   Tue, 12 Apr 2022 08:39:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Michael Ellerman <mpe@ellerman.id.au>
References: <20220412062942.022903016@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/11/22 23:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 


Building powerpc:skiroot_defconfig ... failed
--------------
Error log:
arch/powerpc/lib/code-patching.c:119:19: error: conflicting types for 'unmap_patch_area'; have 'int(long unsigned int)'
   119 | static inline int unmap_patch_area(unsigned long addr)
       |                   ^~~~~~~~~~~~~~~~
arch/powerpc/lib/code-patching.c:51:13: note: previous declaration of 'unmap_patch_area' with type 'void(long unsigned int)'
    51 | static void unmap_patch_area(unsigned long addr);
       |             ^~~~~~~~~~~~~~~~
arch/powerpc/lib/code-patching.c:51:13: error: 'unmap_patch_area' used but never defined [-Werror]

Commit 520c23a20890 ("powerpc/code-patching: Pre-map patch area")
is the last patch in a series of patches applied to the file since v5.15.
It is not tagged for stable, and it does not include a Fixes: tag.
I am not sure if it makes sense to apply it on its own. Copying
Michael.

Guenter
