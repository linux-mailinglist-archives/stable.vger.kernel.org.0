Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3647B587182
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiHATjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiHATjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:39:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF972B617;
        Mon,  1 Aug 2022 12:39:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x23so2758617pll.7;
        Mon, 01 Aug 2022 12:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=IZb879XeksP1R3G1jKbUg31zvG/Ww202m73oH0KFQ6U=;
        b=Ae6HW2w3+lN1mHo3tOSSpANXgNZaQODs50bu1cIu2P63+bqU63RqfLGWpyrvuRISE6
         0VCgLq8So/yBmRLu/eIiEY15mVfHXGDab/z66vxkBqaW/H0vwvbAoCZbnytfaT2A93aS
         3uLrfese0X0jxKCRt/tiUV19VY5yymX8Kou8GuckZMfitKjbTIwW7f+59eMENpPAYV+m
         w8ZtE5ZkYop4RhFYiJbck70O2wsXbGbCbagKFxlJLKkH9BwuX+J0/kPXe4B9R3nUT2c9
         eyv/2TdVhzQuClD7Jr4t3tIZVKynazQ988MdAHQw7YrxoQdsmamGyLs+Ua4v8WLr67Dc
         iRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=IZb879XeksP1R3G1jKbUg31zvG/Ww202m73oH0KFQ6U=;
        b=GHZ2ZFJeg9U8A/Ocj9u51j8i+gD+9tHzWQZtuHyi/IZ/xMPVYy7XHHazEXGbAFR7ok
         31o95rqHf07rr7hlP+XZhbX/WL+kCEIxkC+DEs93uAxFGlmgmfsreRu5zrYwhHFqXqdp
         TMzBboDftkYAaITgTVza/DJz8JxYUaghPVm/+T9KArwvt51Q9yAWlLARFFHdvikFbYnB
         XhvYmV0EB/tQwBT04iFk3tveqj9zSTNe546zTlXZoMf+gR8UBfsIP+pW0WByr9ReOThF
         N/0lfAMACI6n19TRh1Xk/1KnqHWwfKTUPf+coxOtJw+sfi6zv95VyT3j9PZ23P4Yj8/b
         3RGw==
X-Gm-Message-State: ACgBeo2RMqKN8irZJl7DDWauFlpXecyKCDVOBwtxtNjtEXKp9iukiEBd
        0XAHGgnyUEnc+gzKuSuzmtA=
X-Google-Smtp-Source: AA6agR4fGeSxaWbM8ekZadJiifW4e5ehXELgT8lydTcOECILGt/Cqw5o7vhv3ZddGX88eQ4kD50ydw==
X-Received: by 2002:a17:90b:224e:b0:1f4:ebed:16f6 with SMTP id hk14-20020a17090b224e00b001f4ebed16f6mr10380619pjb.17.1659382779032;
        Mon, 01 Aug 2022 12:39:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z6-20020aa79e46000000b0052dce4edceesm307155pfq.169.2022.08.01.12.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 12:39:38 -0700 (PDT)
Message-ID: <d2bde01f-ac95-341c-ebf5-be5484b51169@gmail.com>
Date:   Mon, 1 Aug 2022 12:39:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220801114128.025615151@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/22 04:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
