Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863344F635E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiDFPX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiDFPXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:23:05 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE75555A98B;
        Wed,  6 Apr 2022 05:23:17 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q19so2059359pgm.6;
        Wed, 06 Apr 2022 05:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o/1tf7CSTy8ufoMUMC4LEOxhmC81e3bpcroU2LXbRqY=;
        b=Y4sbtRGn9n/ThFevUgKvnhaPgGdHZoiS2DYIyVWedCSOTCoJaka55M/zdOHt2uqWmo
         OirpOgUpQ2njMfy4biyRy699bgYJZwMPaXwFV7E46pW1G2jNbJc9NT9jyqUEUQZUCz/O
         2x2xZssD1x390mo+fFQjqNpqjdQJWhoVGHDHS6KlqjAcHjkgIOWgUhxvj32emnkv/MEX
         /YBSIuUDiZPGomm7+FIX//T8DoBHwHwy/ker4xcYD4Eh6SXXHWiUhkHgUoZ9eM6bpWJ2
         9CUW0PT1aPI4aBflO0OCC/eAT9VIouIu4BD++w/dI27NVl1HfYti7qqiOVIo9sYR0J8M
         NEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o/1tf7CSTy8ufoMUMC4LEOxhmC81e3bpcroU2LXbRqY=;
        b=Se+f/e8P5W7hA/CYta8vDJmpQCnPtV75kRWsNKCZeZrL4wU5kfCH4Vj26YPpCQsm/V
         2+A/LLHZq0/0t2dujFDRuYlqeTUwdZ35FNTCRb+yRcSGjmV533jmIH5ttqvHYiVog/Hb
         DieGRb2GsN5RkXcVxbAWiVBv/ajDjfOE8GuEWAZCoOEifY8kjXYZ5EnngONaI8PkDvXC
         F9iShLHvE8YcXKyM9y2BBqTnIgSbOlngoTYKLIr+R/N5OXTPLOFcudvFGA/zGlCrDgT3
         iyrAqq7P8ECJV496uYT0XvzfZ2swzmTdy8ymuAes2AMUOUxaIMhdgFdvZFn6mmwNr8NE
         UPFA==
X-Gm-Message-State: AOAM533NJTYUsE6NOR9Em4R9cNr5HCSEgU3B2RQAcRjbUZqjHt3fQmcu
        /8EdWuu2ifyD+ZstRnwq5pk=
X-Google-Smtp-Source: ABdhPJyKqOOrcnvdvVqPJ208iyxOrKPfapQmsnYcWPNjdOM8+a30ox5kvg9Y/1j6OA8ypkjIlTvERQ==
X-Received: by 2002:a63:680a:0:b0:383:dd15:fe68 with SMTP id d10-20020a63680a000000b00383dd15fe68mr6932574pgc.467.1649247797141;
        Wed, 06 Apr 2022 05:23:17 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id f15-20020a056a0022cf00b004fb32b9e000sm19636121pfj.1.2022.04.06.05.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:23:16 -0700 (PDT)
Message-ID: <85d5ba98-a90f-eef1-7d0e-834b607991a8@gmail.com>
Date:   Wed, 6 Apr 2022 19:23:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220405070354.155796697@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/04/22 14.15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.19 release.
> There are 1017 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
