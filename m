Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7FC526E70
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiENCzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 22:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiENCzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 22:55:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFBF345F4A;
        Fri, 13 May 2022 19:44:52 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so9609831plk.8;
        Fri, 13 May 2022 19:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=KvaDEYHJWZZpt0F47qaWw2UxwdyMVXlmAUO1Or3ZMmE=;
        b=Ri2DXlHM6mpgkntMSZ8mMwsAEqag8QMapdH556i84ZTlBtTdf2NjnlAYKJwF8y7C43
         y9RfOKmQS1sF4r2H5m/h6yKYTVyT8F/FHH44vmtEEIbgBCbYXXc2HZh6UMTKMiidC1gd
         iqRE2mZqHPEZf0Rqj+PCRGG2JthK3A2hmPieS4bIk7xtLPgBHouCBQo3BNizqFK46hKQ
         CHg69DZGgDw7BcVOqxdV/MWDwqQQu7ugVmEgFaeSB6U+AJGNWup3bKmQKeGXtrgqFuDS
         JKQgDR6x+aHBCCUMXoi5Ka2USmqiw6ZpczRMxI/LdZQKPb/RiihexF741JoEBl2ku6Z7
         V9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=KvaDEYHJWZZpt0F47qaWw2UxwdyMVXlmAUO1Or3ZMmE=;
        b=FObWznsRZjKoK1MhRCS9AL8oO+pce6MQATtMkM9QU41LOtDBz1zJgdXDeXulGqxiYd
         Kbd7QQeMfUTUD32NIu2fuT9Lh7htEFO9detuEWjot9Bg6s/Pu7UoO47r+SN7BMMreFiY
         ojrjHhhfSl+XMY3VUO4fA/FE9nB095f0b62T+V7sxo0W22HGkJhCz+lHOhmN05hRqsdQ
         wAfZIq/r8ikG3n/FvE9mtEa6EDg2Aa0X6/NhBtGrmvMwvPe9usX/tOEb/q1zgKqjhcbG
         VU3IlZ9Xvm43NyI/n7IYGvI43vZDOVmW5TJGzQz4Isw/kx+mUyEk/NCq81CtF9szegSb
         Z69w==
X-Gm-Message-State: AOAM531B00gLS79aMZrYN7+YgOuQjIYEx1r2nb/raKU4sF8vC9PSimVv
        vb7rG8nygkqU90HSIENYh0xWZz3MfUc=
X-Google-Smtp-Source: ABdhPJyGdRjA7vygb9d0ikRAtsRHw6x4mLPzhuJG3T3fGLU/E/pctEZCi2IWK0yyhn+JKB/m4vYyQA==
X-Received: by 2002:a17:90b:1c08:b0:1dc:eeb2:5a5a with SMTP id oc8-20020a17090b1c0800b001dceeb25a5amr7800974pjb.31.1652496292125;
        Fri, 13 May 2022 19:44:52 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902714300b001613dfdbf19sm1013475plm.275.2022.05.13.19.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 19:44:51 -0700 (PDT)
Message-ID: <d72243bd-ecc4-a2be-b7cc-057204516c12@gmail.com>
Date:   Fri, 13 May 2022 19:44:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/18] 5.4.194-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220513142229.153291230@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
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

On 5/13/22 07:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.194 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.194-rc1.gz
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
