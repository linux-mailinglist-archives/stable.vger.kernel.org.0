Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA484D1941
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiCHNg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:36:26 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FD648E78;
        Tue,  8 Mar 2022 05:35:30 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o8so16487603pgf.9;
        Tue, 08 Mar 2022 05:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sf0uhRuszUIR7NMEM1bC67FUpxMzMyYy4frXlpEijq4=;
        b=gBaPDC7BOeWraVZvdBr1zoK7BQbIdHIDQvtCpohWaTkR+5X32fpE1MJ9D0h3xLiv5n
         pmGIBAvmTxH9o5Zi7SbpRJb9vPbDqhPD1OjIxXyg911DzdtDfUiUzJ62Y9CMcYg0k2FO
         ddcnMjSJzyK5YfP9rNVQaGhDsvhEslvPqzZ121GX0TM7S8DiBqHtsK83CEpfIlYYaYVR
         v9icOr4q0AIyFZFzOY8mz1JV76EyCfMI9VP+YSvL+Vuml617RUQCQpfwacUmtCkvMC+n
         dkfZvb7bVKPmvIVowHszwADpJ665z2cRwPdqEYM8uLbv7yirmYGeIQEZg6QBtERRuObq
         QBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sf0uhRuszUIR7NMEM1bC67FUpxMzMyYy4frXlpEijq4=;
        b=XV1ZDG3uUELXiZ7A/xDtz0EsIg0Y3u2/8UZHagH/JDjP1pYoaFzlV5tDU9PXtB/n1A
         51xBWlpzlmXFGu9bHVsB+zPBRuVNHD0XcybUtku7A/Iig+cDqYH9VymP/hmGycJSnrLg
         AmtkDDbz6ALNAKEMoYFQwZjizHThBZj8D4XVbJuO8+ya1SnEdZRsSsrMgC8i1uXs/uNc
         y2K6yPaLd+cEDtoF1K+ybjytPAhoDGNv/InEHNL3wT1AHq60O7YHkBDux8SBXH2rRySL
         82HEx+po2jIoBWQ5T+aH0R7/lvF6RcnTvZIBdS38tu3D4B4kSyZmXaKQNMPzed2ykAIy
         j5sw==
X-Gm-Message-State: AOAM533ULlMLpvIGQJuyI8ApJhvvJad9y0fbkr1XCJF9S3b1prV3zsim
        rns5lLL1eVNXOuzIvjrdcymmLvjwwsIB/w==
X-Google-Smtp-Source: ABdhPJzmFVk7tDb6wY79AdSk+JiGsFvzWNb4zbS4wURpdoB9CRIAKMswguFDxTQ9ZvvWT31KA6W2FQ==
X-Received: by 2002:a05:6a00:ccd:b0:4f6:f6dd:8288 with SMTP id b13-20020a056a000ccd00b004f6f6dd8288mr11395938pfv.25.1646746529991;
        Tue, 08 Mar 2022 05:35:29 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm7046527pgf.31.2022.03.08.05.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:35:29 -0800 (PST)
Message-ID: <93f1668a-543f-55d1-0bec-4311e6435be4@gmail.com>
Date:   Tue, 8 Mar 2022 20:35:23 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220307162207.188028559@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
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

On 07/03/22 23.28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
