Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CC75B8E4F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 19:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiINRqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiINRqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 13:46:52 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21A252086;
        Wed, 14 Sep 2022 10:46:51 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 3so11069980qka.5;
        Wed, 14 Sep 2022 10:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8dCJBTzDwCYDG7yGJAzsA7Ppx1VJiWA7RssQ0rmRopw=;
        b=UdH5qf8MZ2e8DzliUaez9f/wdBVh6xOrHKJ6RSuh3iuNj+30K04XKONiYHp2nvaH9w
         kB2nFljOyIOijYSnY7gfTziaNMD8wRfnZFtGFcTHtY6JryMTw4g+p2u6Sl8mmDLQMn6c
         LLJx2YcKpSPEjab6ejEM5aipT1eBi/RrHHbAzzQ9gKsqewFHQaTV26dR4iVx6wQCONx+
         46I0e0bYkcPDlL6smO2u+tzYix+XVm5tdVQ4kbfvS+heTwNvYs4JNkzien6YG8ZpqCdQ
         1wNJphsaFoHVxHsogS6Snr763o+ptofIAxwmDfpTSlpJbbzdt9V5ZNQ3/NItooCv/wOO
         YJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8dCJBTzDwCYDG7yGJAzsA7Ppx1VJiWA7RssQ0rmRopw=;
        b=GOuQbw9Nte+0O+3r6S2PWybvXLj2/6/GCMjgNe07cGpgaz9divVOJBPk8ks+W4W2Wo
         0HXc2Yj2jyG1O1KtvA/rHOjcYXtTZlnEgcsHORvliMN2xuJMQAf4XEwUc96rxeLm/FSE
         cTnjD/tDvYhsE+6oFjHVM7Rq/LYBAKNUkWUFylRV0ESHTghMgrHt6ArO8egQLJzpm+Pz
         4Q91A9OFM1kFotGu4WH7rjYAP2nVsn0vHb0Q6paI4Ax8PbOMe6kGMmUuk7QLH26t9pYf
         Osqbd+QLYCBCVovfZfhBKOJ5a8ysC/7kAPGYoBOJtjhh5BjPAgxkyUrO6XGvezUHgXBS
         h88w==
X-Gm-Message-State: ACgBeo2TZlv2pVHpLeO5KZbTInVvO0/axVWvFcCMAFGQAwRIB5iqNLAq
        PZqlxOp7Jag9Rle7YiCUZM1OY0wmkaY=
X-Google-Smtp-Source: AA6agR7x/L2mbGbY/RNHSUQU/dQgn5UQmEPcsTsBGs8qZ0AU5HVPVI+a7OliiCRlf42apGqrBDaM9Q==
X-Received: by 2002:a05:620a:25c8:b0:6ae:ba71:ea7d with SMTP id y8-20020a05620a25c800b006aeba71ea7dmr27782097qko.547.1663177610901;
        Wed, 14 Sep 2022 10:46:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h1-20020a05620a244100b006cbcdc6efedsm2313281qkn.41.2022.09.14.10.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 10:46:50 -0700 (PDT)
Message-ID: <b2e81ab3-8bf7-d0e9-d046-9aa2eacda6f5@gmail.com>
Date:   Wed, 14 Sep 2022 10:46:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/42] 4.9.328-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220913140342.228397194@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 07:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.328 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.328-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
