Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A96CCF36
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 03:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC2BJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 21:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC2BJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 21:09:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3561FE9;
        Tue, 28 Mar 2023 18:09:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so14531137pjl.4;
        Tue, 28 Mar 2023 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680052177; x=1682644177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrHmZ9KeqMwcEfZQAmDICbY5pMTadE3RCEsUwj0C8ZA=;
        b=Ga4K5TN2AUAffev3UvwTLNSZGK9/7ioRyZBBW9AAV1hKFgfajBHEi5HXeoHsplaZTf
         /yoUJ4/R22maWQYyOFRkRQPpGBLj0P0SR9NLK94t6z3Gm2NXXyD2mfB32s8KaSCKv2JD
         jY0nLg3jNVrpSIluaI34tVrE7HuMnApxJwQF9Gt37T/traPGUqAjuz6M6QsNZpH4QmUm
         r61IjQQqNkYnbF1QVX8AnSq06tWrU7qS8hUCyR/EE2akfk/dqzl8daZd3hCKVTDDeEu2
         mT8bx+5TO1MZ2wqWfngLWK0fQFj8BKaoCwFNjd1tBwxZ7tUW1KldztcSgXCcbTniA0FQ
         vvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680052177; x=1682644177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrHmZ9KeqMwcEfZQAmDICbY5pMTadE3RCEsUwj0C8ZA=;
        b=Wv8mE0Wg/od7xhVCt+lvq0K0YAHyJq99kBH+L8+syhVqpllp2yrtvlTM9aTCc70Rfe
         GeWKCJdUiEx8EiNi57HuwsZBM7c5jcOQEs9L2TmYrC1DAkX8Gz272q1bAayqQhTx4FHq
         Dg5h9+4KpsJrAK5zQx1bM37zsmXTuxBNuLrsIoK054Ive+1xyb4gWLny+ymGHECMrf7J
         sy50xjraPogX1k5YlBAGPNOFUGJmynlMax7VLg60SlTMFFksiYls0Y2YRmVQKzBwt3cI
         /ljYZyWYHfPNz8Z1chA/M2oY6xJur26apHSUcJxNmiSdfq45knYUw7XP6dB82DjTA/5n
         svFg==
X-Gm-Message-State: AAQBX9dfVikUDz2hrwi4NrnpwBCD/pR5+rEZjPGvzu22t2xySLKP9CxY
        7geGhMpjHO/Q5Xw85hCA4oHnZgRXlCM=
X-Google-Smtp-Source: AKy350ZyapWAKd4r51e2CPtGHPVUH757kF8rYkoC9VCVAVxJc5UcTeTcotvbAo4plSqSZwSserLk5w==
X-Received: by 2002:a17:903:11d2:b0:1a1:bff4:4a06 with SMTP id q18-20020a17090311d200b001a1bff44a06mr22531010plh.24.1680052176887;
        Tue, 28 Mar 2023 18:09:36 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0019e31e5f7f9sm21762127pls.71.2023.03.28.18.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 18:09:36 -0700 (PDT)
Message-ID: <9f9c61d0-ee89-fcd7-3df5-dd0264651960@gmail.com>
Date:   Tue, 28 Mar 2023 18:09:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142602.660084725@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/28/2023 7:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
