Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2768B4BECAB
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiBUVi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:38:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiBUVi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:38:28 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6A522B33
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:38:04 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id y15-20020a4a650f000000b0031c19e9fe9dso11918385ooc.12
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 13:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rSMekkNgV07OeG1Q4zV//P+VvrW2ICKvEfaT3G2N8Og=;
        b=TVVAwqYlvY1nux/0Oz6D3GPWpsP1trEmYENm5c7O6ymXXvMRQktY8hIysEYU6XIYmO
         jGQIQL8ZRJ+nauQMjsngWoe8DaDqn3r6ZGu5mGtZR8OIsXDMwmniMUUBEV6tmKM0pO/z
         ywh1koL/MYygLzjmKVZ1Q19KlkFgVwFKqWi9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSMekkNgV07OeG1Q4zV//P+VvrW2ICKvEfaT3G2N8Og=;
        b=0wEDC4/SkJmMMQ1DVYxYBSCxm9GS6zZSD18FfrWmrfLkdVVbAv2iARfDXwder/XodU
         DyUzFpc+odRgDALZ98Ja6ceVByNmeGeMW5WnWdJCo1hzVcvajGJFj9YJ8PR4kR8hOF7Y
         hKO9MPwsp7g7ryFteVaeijyBP0NlBdfYCGYcORqkQtHOKzGyqNBQLxOoBHGZiFEfkU0H
         ICZKYn4AoM5Bwep1N+8jHpXIs4xIv0EFTv8pBh2OUp7aJ/vuJs1IxXG2sR6EfpCB89d4
         RZc5IylqKIE+NXnKWGK+Ki/XnwRumZyUG/d4CMOgRvocEyYi/UvuqD+EWGPA6eBufnp2
         sfXA==
X-Gm-Message-State: AOAM532WTphxjx8Klav8Hu5w4XTIbn7QS36KeQl61Jo+FKtkALpdO5G+
        lInukADGQatPCdowgJBBiS7qYA==
X-Google-Smtp-Source: ABdhPJwZAhN+/Ok76e+Taodwc7SO/2pwnchYRO+UDuEBTsUyD+9vsXmRTuL+PKlEF615OOD4kEQFEA==
X-Received: by 2002:a05:6870:1b06:b0:d3:d1c2:8420 with SMTP id hl6-20020a0568701b0600b000d3d1c28420mr335255oab.305.1645479483294;
        Mon, 21 Feb 2022 13:38:03 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id q9sm7343270oif.9.2022.02.21.13.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 13:38:02 -0800 (PST)
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <43ebbc71-c249-7d93-7b11-e69eaf2c5554@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 14:38:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/22 1:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.303-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
