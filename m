Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5960052270A
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbiEJWoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiEJWoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:44:01 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8B1C0F1F
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:44:00 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id n24so665613oie.12
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okZqXBGdND/7mCD8PNjRXPAn7Y3C+537RMJOCdZJrPs=;
        b=Jioh0mRWzUAkMZ/OtLncEs8h+saIAyh3Wjd3eOpMLnCKT2AwWY6xj+IAniD6VpBbx1
         FKdyoGZ+NXomjDJBLv5+xJS3co6NdC3q3n/xa8BaxfKpt2Hf8gNamIR+WQzWSaSeCoBx
         7lMGu3nQEvG5BL4DZ/WgnWEILSfGSvuJuxmrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okZqXBGdND/7mCD8PNjRXPAn7Y3C+537RMJOCdZJrPs=;
        b=wXBLLE0cYdLF4CYCjRcZ7u4SHj50Xkm8r1cjHo2du+z2kqY+Q+KRqqc+ezwq0D++m7
         qcLQ4Xqh8pK828DnAY1skDDXpjQGU+IsjyRfb4NEPnHBSbnBZeXc2Q6IhQi1saMxr2Ar
         4h+LoyTp+6ul84sxy+T765x38YwZoNwn4HDLyRXj6A49tA9yngYbMEqi7FrbhBwwX9r9
         8352VBnMTxfc0QPDCZQ2I4q+DW3t64tyYxDtoc9coSP9sep10ttv9kva7rW6sw0G0ZnC
         hjD3OLYjtYUMd7hrcPHWH8Unk6Ais9JN2FQ/H0Qqvx+tCxfOYk2/gLe99cd+03oJMjKN
         +taw==
X-Gm-Message-State: AOAM531ANxWkcPflX6fC4d5U0vq16kTrQxy8Dj/miW/ubGf5BoPpc84e
        3gegwgJ19v0rnJ2rDzGC/tSS0A==
X-Google-Smtp-Source: ABdhPJy65xq17anGKjyDkR1ipE43MLs7SLlAynvEvlIFWMAwktZRVcGnq3Fdd28F8fusZBCaLVBtvw==
X-Received: by 2002:a05:6808:1184:b0:322:4c18:2f7e with SMTP id j4-20020a056808118400b003224c182f7emr1186115oil.109.1652222639734;
        Tue, 10 May 2022 15:43:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z42-20020a056870c22a00b000e686d1387bsm103791oae.21.2022.05.10.15.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:43:59 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/66] 4.9.313-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <84f00f23-6693-743f-a47a-c9240a6dd157@linuxfoundation.org>
Date:   Tue, 10 May 2022 16:43:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.313 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.313-rc1.gz
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
