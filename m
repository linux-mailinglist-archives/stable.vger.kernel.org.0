Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B556BD96C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjCPTkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjCPTkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:40:17 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6B0442CB;
        Thu, 16 Mar 2023 12:40:10 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c19so3030692qtn.13;
        Thu, 16 Mar 2023 12:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678995609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n+XnBvJUJTWnya1MYL5S2OxPlwdWv53niurueuHio0A=;
        b=iKh1rPdqlbX/xxnDzvT+UE4aKcURGs2yU+4gRJG6ggrk8Cmwyv2qfv9IFoqHuuhwdc
         0KyC9APq9eqmjaVejcn3ghNaS0ZK1MDOmM9yBZm4RaiJR4gTD4wpkAB/SBODbvR90MXX
         S1TQtjzfSEwLnNESZbo/OCHhhkqIR76eilrvYjjkvTkAl4UcZjB4qZ8wru79tI54ysSx
         xoEMkeuXoFfH65kssricsPaMuZQqBpy24rapG8g0nzDvTfUG0EegdpFOdH6CQTXbolXa
         Bd7XFdGvBRK7lDAahfr/O+xzD2S7tWVWAjBP4JSegNu5X1LBY9qbBZRXgm0EWfHp+ADg
         +dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678995609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+XnBvJUJTWnya1MYL5S2OxPlwdWv53niurueuHio0A=;
        b=aCzqN2l61yTtC6dltCQrrO8P1sA1MdquHFard9OMe1ommhLdHWL9nAH9fLCLJOVBWt
         J0Xv/X5MiNQ2s8bM7YSPBMgL1GSCmF/v6I152Gq/X87xfXUBxPH1DtH7sbfynxQsQQWH
         G8CbcKMI8LKCCkj1RxzWVyYuEdoLPINfjoMu9RvhQs7iUDqphGlyDRhjAy1GbC0OW4wV
         W/iFHsSJWlovbCKj+Ma+jO1bZV82jj6cmrAZ4t+zR8h4l0bzHHztzqugT1nH99pPh+TD
         mYJMkj2OKgtQyixDgET2eDmSzBZfntTtbLblhLRx8bK+8bFSgDgIlQMz8eWgU7Xl3QH1
         VOow==
X-Gm-Message-State: AO0yUKWoZgBb5hfWBN/SncFf0Nj3s73xElbTvexTTR67vPtnzLIisd70
        B6m5yGPmaNMviPTT8eetbsA=
X-Google-Smtp-Source: AK7set86hl32NSuisw5Js5aMqBkxp8RbQwciHk8OLlHpwgoKYJK12tcqN/ArZ0Lt4IoynMNeUBRDQQ==
X-Received: by 2002:ac8:5f53:0:b0:3d5:b00b:13e4 with SMTP id y19-20020ac85f53000000b003d5b00b13e4mr9520125qta.34.1678995609516;
        Thu, 16 Mar 2023 12:40:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s128-20020a372c86000000b0074374e2b630sm135748qkh.119.2023.03.16.12.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 12:40:08 -0700 (PDT)
Message-ID: <709c7168-7465-9a55-e2cb-d24071ef894d@gmail.com>
Date:   Thu, 16 Mar 2023 12:40:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083444.336870717@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

