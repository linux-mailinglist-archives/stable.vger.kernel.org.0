Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583794D6035
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 11:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiCKK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 05:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343750AbiCKK5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 05:57:05 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143CA1B5120;
        Fri, 11 Mar 2022 02:56:03 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id s11so7528790pfu.13;
        Fri, 11 Mar 2022 02:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6mMYXI3tVLpKUr8rwkLfSzKZwrbEoOdHBqCd++KoYUE=;
        b=jWrGoRWGamloR60nHXKPZo7Ztwps9oByzyY2J3XRJStnDsdG0TgTq8LsV619gDJxAi
         grRRW/5w1fHzmffjtqRHuKAfD/ewzFJBD9A7uXXubcSNeRIeARPqP5vwZNdCuAMuCjJM
         bddOt/CxGD+RPMT74QeiBFFRHW/9icwI8MhCnwHYQlVoJM/ErBUDc2tdQ8kU12POykmk
         SqB9LVkdQZAOOPOl5zzjfdeIhBUx5N3EfZoOugAABjHXDW2iqhzoR96UXhwzwvwgFUEb
         Iu9+v0SEhDwd8o2P/AYJpGXCnwH16thfZIpK5/18ilIQBVwZ9YmLpZZ+HEU6TDiIjqJo
         k0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6mMYXI3tVLpKUr8rwkLfSzKZwrbEoOdHBqCd++KoYUE=;
        b=5dZ7bG7UjHCVem/iENs0GDR5LhIv9z/K7syxjFX6/gdJGPByBKICg8aE9X4p76LcmI
         TRXnbdwSvMTUR5v0FsKRGEc4JA94STe1gDEb/x0zQi1j7DO6DrlNr8lOT/I4DyCFpdyj
         7AfspM68cxQ8YIZF9qPCYPRumByQKmnsVTj9DVF+KSUUeBwb2TOzeb2SZmLY5GYdwqfH
         dClf6rofv6j0neKjtkZHH3aEj3XaP0bPhbfwngF2ontf0gJg95wCIQDtMY2noIDU1D5S
         X/b3jp5vbKu3JgK9tF08WqTgO7UKP8gWEUYHhnOVWmXDWO4PfdhLiYAi9ZVM/FyFE481
         koDQ==
X-Gm-Message-State: AOAM532umbqQ2YrarC1LaRVM5+WryooSnWY9ElW+uqN2rqTtHXhQwszK
        fTOkAa15QskirQVGgNEQbW4=
X-Google-Smtp-Source: ABdhPJzu+kk6aPcsBpgOyLuU4+r31SmDeNomcx6g4SJ4ZrvL5GtLtNdU5NzYtstnVa+/MzWXl6M4VA==
X-Received: by 2002:a65:49cc:0:b0:372:a079:cb3a with SMTP id t12-20020a6549cc000000b00372a079cb3amr7778906pgs.222.1646996162573;
        Fri, 11 Mar 2022 02:56:02 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-87.three.co.id. [180.214.233.87])
        by smtp.gmail.com with ESMTPSA id mr4-20020a17090b238400b001bf80eb1baasm8744659pjb.14.2022.03.11.02.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 02:56:02 -0800 (PST)
Message-ID: <97aba7b9-d8ff-327e-933f-95ba8a976d23@gmail.com>
Date:   Fri, 11 Mar 2022 17:55:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220310140811.832630727@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/03/22 21.09, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
