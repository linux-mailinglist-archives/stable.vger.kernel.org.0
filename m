Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1355654A010
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbiFMUr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351032AbiFMUrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:47:06 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DAA37BCD;
        Mon, 13 Jun 2022 13:01:11 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id i25so4723083qtq.0;
        Mon, 13 Jun 2022 13:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eU3DLuUn9fCOPEhfzrbg7JSzV8OW8CVvXW+e7KmEHk0=;
        b=DSxrLsSpuUfF9kM5thQWDoAgIzl5K2oZb3HltNBhhmEA6jYylOhyuTlrOtC8I/E3DE
         HpEX9WexZW9gyKUV/E5ty7TviUbFWcUYxsAHs0uWzTGv0rMmH0Z6SRex82Xf+kmaAmfV
         SFh8N32a0HO0La2vduHNvGTQ84k62IiiSA7NvvK5rbQPEr13D0qyedsAO+72Rn5xGmI7
         WgrWnnfqHeLw9e5LrNz3dHGhj/TZ5ARERtbNbfA6fZgmHc7vd/L3zo8lbUzx/no3/NwQ
         9pxdHtQU6ToQ4+JNSUOZnWl5bQUfXNeZKTMamRoxouzyooX6nQ+kNGOfiVLTmZugLhVG
         t/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eU3DLuUn9fCOPEhfzrbg7JSzV8OW8CVvXW+e7KmEHk0=;
        b=3VkjDrKE6Po4vgXbwkGwzPEQCF3Pea5QWXmtHX3JVjzcPAlTq5hF2QPCNFskfK+l51
         xp3SaXqc7cSefksKyk5nWjx6esstQJtVwbGKUhJc1HPOUzj2+NXm6RQeLmODneCBcM7z
         jvHma5gVdizv9KVnkVfhMjO9mUACpiDkJbw+jmIoNdu8ebPGbydgSnbLnDj3kfMUM1fw
         PRh8DdGmACGpA2dFVGzFseps0YVe3j39ZQMSFx8rv3KRMov7NwgPbmmpydDFkuBhmQcA
         BgH9B+W9j6A+zVsJTrnFFuzZQn9rmt3G0x4kmlC8ECcw2lbK680Vh5Aa+xUrhuVVvXhE
         b3mg==
X-Gm-Message-State: AOAM533zTZYDwqFhxNnvLUQELzVTTdNPh+W8lMkpvksskLyeQ+AI5007
        LddMHk5qqFanLSzgMBDorq0nfjKOq8Q=
X-Google-Smtp-Source: ABdhPJxA8LjkglFi0lI/OcvxwAVgmNVVtpC89YokY919Nl9Qm9M0JH904UxKIkzKBLobFiaztRpX0w==
X-Received: by 2002:ac8:5d86:0:b0:305:2b38:af7c with SMTP id d6-20020ac85d86000000b003052b38af7cmr1290499qtx.497.1655150470303;
        Mon, 13 Jun 2022 13:01:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l188-20020a37bbc5000000b006a6bbc2725esm7097561qkf.118.2022.06.13.13.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 13:01:09 -0700 (PDT)
Message-ID: <2741d09d-679f-7c10-e6ad-4f0e6692ad0c@gmail.com>
Date:   Mon, 13 Jun 2022 13:01:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 000/173] 5.10.122-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613181850.655683495@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 11:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.122-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
