Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3904AD7C1
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355719AbiBHLq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356096AbiBHLqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 06:46:39 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307BAC07D6C5;
        Tue,  8 Feb 2022 03:34:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i30so18352230pfk.8;
        Tue, 08 Feb 2022 03:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yDBZiG+Y+FfC9XvTDeOHp+ccsZWR8lWNBSroy9RZxiY=;
        b=HVurCuvwm8kePUh9ZgizNHMBzyvivYu2+BFM5Nd01fk+j63x52RolG3z8HEMehUsD0
         eL11XdFDze4DHJYR4gO6taWPsl4EBdsSVMErrwsMO6ZvG740iTGhNLjZLMQa0IDikrAa
         O6fIgrL5G2cCwiNaBQziEiaXNKjXTksvJm6AOoEHwjkFttEWEN9p/7ZNHsVeVjL8vamy
         qoP8wAn4SOxTpML1Y1qQ6Ms+xF0gFIkvHL+JsqX7qIPCT+yJ17lQn+losi2MTVCnCL6U
         sCMGBFmtGfDFGD6Ld+/YRjXjJjfo/sDHA0PwVe1pRakMHIwDZnS/h6LLzv5csR4h2sLe
         glhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yDBZiG+Y+FfC9XvTDeOHp+ccsZWR8lWNBSroy9RZxiY=;
        b=FjXWcp9BDMBovTafVosakMkZoihWkaCs1uf5E71EeKzuhx0jMPiAc4KoZsH1+Evcs3
         hvC+0NWOz+7vyIW0siiw7ZlBaC/9QwgVcAV/BeyfuW4I7Gjpl6qF9R834W0ghYuhfSqs
         sCMBundWya2jqi9u5gDh0oOC7ebGm8vod/mHn6YREV39dMOQSsQV6FHuHhByXOwDSQlb
         qffxk8rGEv+4pIW0xEDws5WL3MM2OYG7wEk13G/qTqPnfnc3OSt92zKxhX4ATkywetlv
         kVGbfq4hglfwGSdzS4twdEkuGHec4XOu/P+wEFs2wtInF6ZbtTlFcF5Z8uOVv1RPYRaH
         HDoQ==
X-Gm-Message-State: AOAM530Crk/BdLXhtczhr2KdG+aDSvCnlOAGvW6u0nd95lvDO+umemwh
        ckQy3TiGFqUtrA5KxUs/FIU=
X-Google-Smtp-Source: ABdhPJz0q3uOBeaikFB/3hEe8oh6F/U8I1ZgZGlYosc6tr6GdkDKOxe/2tlTm/MhqIpWVo9xoWTFnA==
X-Received: by 2002:a63:87c6:: with SMTP id i189mr3057798pge.411.1644320055555;
        Tue, 08 Feb 2022 03:34:15 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id ms8sm2477145pjb.33.2022.02.08.03.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 03:34:14 -0800 (PST)
Message-ID: <47510a58-111b-d4b9-0ff2-e93319e15be3@gmail.com>
Date:   Tue, 8 Feb 2022 03:34:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220207133856.644483064@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 06:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build, dmesg, desktop use and s0ix suspend all look good on x86_64/Cezanne (ASUS GA503QR.)

Tested-by: Scott Bruce <smbruce@gmail.com>

