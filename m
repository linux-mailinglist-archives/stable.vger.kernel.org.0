Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E06E6D89
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjDRUiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 16:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDRUiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 16:38:05 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49949EFB;
        Tue, 18 Apr 2023 13:38:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5465fb99so2274157b3a.1;
        Tue, 18 Apr 2023 13:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681850282; x=1684442282;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UpgEeG9DudBLo5w82HUp9k385iL3QIeQyoC6nN4dF68=;
        b=Cvhw9/3nHnO9y6c+RBWxBGqoZfv6fZ7kkf72wh+YTogZ1PiG/6815gh9iriVAxyapk
         b/RWP+vMmdkT9UxCeLyTE+TEBcKlEvdCkFVXzJTGk0fkg+hNA9oSqt9BdHTXBu5V4uNS
         wwJ8bWSvRii/CXmXAoZoRNFe9dwJ7ni4W0cd3QAS8S/tsrvu1+YRdc/DnqrKqWhQZo5Y
         vN2qHHbeteGi/EJiaRaUGN/ylJG9scgLQMHCgqZupzDCbjxzcqRIQtxDAZp8ZTY7OEA3
         Fth1bUk8Vnx2j2uuvUcbZhOZTOvVLWEGdOzHxjzgsPc3jvgTXU85J40S3yUuOizBDaW5
         ut5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681850282; x=1684442282;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpgEeG9DudBLo5w82HUp9k385iL3QIeQyoC6nN4dF68=;
        b=XskmcbcD3yA2j6IOd1S4rGhiHZ1cVjaIZmCtgmsHilJu+HOptUOAeIITTODFxnp81i
         0rwOC7HWOYQrITDnuvpDpc5xmvwVTkjYCxVaJIAVvDbr7Ymgg6nb7agB3ezkHIbyOOxK
         S6sSehvx+poDjX9320rNhz93lgFkmqQbHqY5KuntqMHJVP+BjI+JW1fOcU8hQOp/o7m7
         hj4Flfmwcrdu4EvhKtVNetrQFF8D2nLrXYMAriX5v/CZRa6SMNt/X0mPkQvfZjLTDnJK
         2D/BNYPhUmecR/ZkeVLbHuOSpCWs3rRZicqGLyi5Qhqk0LWrDUg2GPWinn9iMho3n11N
         zD8g==
X-Gm-Message-State: AAQBX9crOkFD9eWLRbMTLkrNFkpXT+5cCg1s9CzGWTA0hh6tVqXqot1Q
        gFolMy0JxYquqXuFlqRoY/QKh9ya7yRxAw==
X-Google-Smtp-Source: AKy350Z0EDO2jRyhUlCP2JxhfNbFOI+KLI3BsQruc9O+D8mmP8r4ur7NinNwbqSKYe8IZOFK/yeTKQ==
X-Received: by 2002:a05:6a00:2395:b0:63b:7ae0:fde9 with SMTP id f21-20020a056a00239500b0063b7ae0fde9mr1028652pfc.20.1681850282305;
        Tue, 18 Apr 2023 13:38:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h3-20020aa786c3000000b0063d375ca0cbsm1875019pfo.151.2023.04.18.13.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 13:38:01 -0700 (PDT)
Message-ID: <ae6f4a78-e44d-b4bb-d2b6-15ef02db9f33@gmail.com>
Date:   Tue, 18 Apr 2023 13:37:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120305.520719816@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2023 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
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

