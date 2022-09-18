Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE335BC0A6
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 01:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIRXib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 19:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIRXi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 19:38:29 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C270211C3A;
        Sun, 18 Sep 2022 16:38:27 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id g12so19261424qts.1;
        Sun, 18 Sep 2022 16:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=f8TbH5nAzf/k0D+q+pU5RrVHjrgJSjIw5I1XX6GpPPY=;
        b=I+ytj9zX12PpGmfXDPBvFIHUrhn1OohzcZf4FiHYkW0ygsvcNGiUUnH61373L/ECpH
         m84MzCjMd2V+v9JccG3tsYpU1aTT+C5uKcpMAMLTI2/Mkrm3lHe4ZJjMMlNOzWHPyZf/
         ft/wYy6s1jQdgVtGMjJB3D7FZxgC9GB5VMw0z86MQYmNzgcDK4DWm7V9AvhVS6SUUpCR
         +X/V9wLN3nDHg2/+pUcD5JJP39C3v9hm2dV1YNJCr3ti7XkFSO2GiU+FHZaylCTTpiJh
         yjhaLi1RNPw1jrI4Bw+vEGgvCil2CAbS77wUAQgd+Xnj8hNP/uZOxsw+VS96qbAtW0Tb
         hcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=f8TbH5nAzf/k0D+q+pU5RrVHjrgJSjIw5I1XX6GpPPY=;
        b=8DWxJgCgM2sMkXtebeGg2ctIHSMbKh9IVYPN+fljyKdKnCXM2jluztUml6Tl7DFYnO
         qQixG/+tIN5f/t7NBSE3BjvmkQrXHV0itkKb1cDlBOZalMVKT9dmRJZR1e4Y9S/KWp5l
         9ROshbf+aMWhKRMhkI+AfCE1M4o6+ZLd5y8m5Iw8rIIEixYrxRYshpbJno0QQZRtkLnP
         32zEd1Q81rKcfz29hhTQKUTNNUEjjfRKY30a/RECdb9IuCQJ8xgWDZt4qp3IhyUEFk4K
         u7qkX//5y1N1qXzVTCeh/nuiHF/7pe+h406yFWc8QaUXnLHUuZaZw9RKQ6wVtkDB0Gpw
         VJfA==
X-Gm-Message-State: ACrzQf0IxJaDY3aslcBJ9sKDHxWaBUvJY0uUG/IooPG8u8CeB4zKjoV7
        S4sEL0GWNKpj4KzrU7U8/oE=
X-Google-Smtp-Source: AMsMyM7kLXk91PS6eQBEEXj5dvmotopmzAzLi/qCgCe/AlsZCtCLmgVatL9uuzeNBgvRO7Lq62eIwQ==
X-Received: by 2002:a05:622a:15c1:b0:35c:db1e:cdef with SMTP id d1-20020a05622a15c100b0035cdb1ecdefmr7388503qty.104.1663544306872;
        Sun, 18 Sep 2022 16:38:26 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g13-20020ac8774d000000b00339163a06fcsm9234567qtu.6.2022.09.18.16.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:38:26 -0700 (PDT)
Message-ID: <e9606787-00ed-2e3d-e36d-f9158c72cbd7@gmail.com>
Date:   Sun, 18 Sep 2022 16:38:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/24] 5.10.144-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100445.354452396@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/2022 3:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.144 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

