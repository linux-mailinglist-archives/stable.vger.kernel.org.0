Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AE4F9075
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiDHIOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiDHIOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:14:53 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27124D9D5;
        Fri,  8 Apr 2022 01:12:49 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f3so7784046pfe.2;
        Fri, 08 Apr 2022 01:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i81WX7FswRmN0nILDi9RrrLL61mjGBMdEL5aeO/NWhs=;
        b=U6hCdq2C2y+iUG2UPSevB61dRc2HSIIRYDKuvW+p9P4db98VcdhNUp+tEwSM3B0Xzi
         vjrH23nCwj4DPG5m/XPuaI/M3Z2ZjnKjabHyqvr/T+6+/mpvtj9Injl9jBSVe9qJ5DYI
         Ww6JHQjFzhU+UDoOe7fzyCimY7yNn68nDs9zEtHwmfEvwhwIr0EkL+JtdXuxIDMOaS3J
         Yxy1+E5ydOpzJ65JTZpkm5j7u6kiOcwMjM/ANI9HO+l56FtBZdVvfHJYdt9Ejnf+z/o/
         +qEisZGxMnaVtXKB8wjxEE+CsIQXKQRDbmFu9bFzLN9Wx8qhwxPLEefMjSKy1CFIixJY
         6/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i81WX7FswRmN0nILDi9RrrLL61mjGBMdEL5aeO/NWhs=;
        b=gVn0/vQkJMrHhVWmCHW1dBs7jfas+o3JSqqwSj0o+THRYMvQxpIXKDKOmHFkcJsm5v
         wDGYTM1jsKasAno54o399P1B86zSZZnrqlom842wLGBlut/kQXkr+8dAbpn2uRGGhAC8
         oQBXC++kKRCG+8irSinbLSiodwtomwKFdLb51gGcRINA2Vnbh5ZV2/R9ekP/Dg/uR7Zi
         zzAA1KGYaaxjYM4zjHsW5yUTy9iFcazyBXQSuurchFUonnbljHXjjTV4j4qkt5SgXkS5
         GXcTr7MYssa5cEfA3V0K7P30Z5VJDWG/nO2Qciu1bVri4VN7tNHAjjrYMIqh1luqnAli
         FLMg==
X-Gm-Message-State: AOAM533m9nF/zczQ6xSjnH4KUPIDi6eumigwD9M5LMEQQAxv2fBTc2ee
        84YcZv8CIqwE9/fwOEtleLE=
X-Google-Smtp-Source: ABdhPJwGgnAbq+6WkP5vvu10B3UmeSluhoyU+rZLwCcJ2MbKbQXukjKNioViA6bFtiBt/cZCZsv9IA==
X-Received: by 2002:a05:6a00:2392:b0:4fa:dcd2:5bc1 with SMTP id f18-20020a056a00239200b004fadcd25bc1mr18210652pfc.8.1649405569109;
        Fri, 08 Apr 2022 01:12:49 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-82.three.co.id. [180.214.233.82])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm24692846pfe.49.2022.04.08.01.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 01:12:48 -0700 (PDT)
Message-ID: <0811d6f9-1fd0-ca29-3c58-84f217b80d3d@gmail.com>
Date:   Fri, 8 Apr 2022 15:12:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220407183749.142181327@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220407183749.142181327@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/04/22 01.45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
