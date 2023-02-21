Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6969E8E6
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 21:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjBUUKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 15:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjBUUKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 15:10:37 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9402D15A;
        Tue, 21 Feb 2023 12:10:24 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h19so2858686qtk.7;
        Tue, 21 Feb 2023 12:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVNMp/uOSdgm3aiZQpiwOdbJXNSKmy2btwUw+ZwEUns=;
        b=n2rBr0dr2k+vbUeHlb52FLHaxupPq+nfLIDleIBQcCYsezWrsbl87kpa2d4bhHwy3g
         WjcfbiABvUYySCkYnV9X19SH9+L3Ep5a2NDfeBErpfDqZ/oc7CGl4MLm/JdUgbLBX1tD
         Lwk8Uzk5hDzX0CUGrmC/hEjOTQc8xppTEL/8ivfMZ3wPY6elhJWfhc3oBd5U2zcyKZmV
         4pwJ777AhONrQ0UIcTbVSHpH+sLDNfAeVZdpasaqJoB43WOeGiqZ/9MCmTZjakh/WA/H
         dyiRpWOvg+p8bIqkxjGQ9QYk26JVUupWjEFZp6WN9g/ozXQR3Riq3rzsZ88HUIRScmMO
         uKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVNMp/uOSdgm3aiZQpiwOdbJXNSKmy2btwUw+ZwEUns=;
        b=mUpmVMBfyv3xHJYzFyHxV6PsUGtspI8tWonyCLTlUveqcf4c1wJ92rgQaRIOLS4HyF
         COd/uHWq5OdX+barlczI9V0cItnz2sMQM8c+JJyXPj4RA8wj0e14ad/u1/so/L7jg2At
         kwpikWjf/42bljhrB1lK0RCfPS34rNB/7w37SXCccQc/irWb+eU4GaOmimZCmcXv45Hj
         /1QQeaD1hO8LLNU2tZbE99Na0Q1WyOLlo/6C//yKtPAiBQQbkVcZY4qkn4rlcERztVVQ
         NwWy20f9hTShIDyTcS8fC7ACJeQPi9RM/YF/Ld2TcihzS5hsLH+T19slyPXbiYC6EP8Z
         +xSw==
X-Gm-Message-State: AO0yUKUv7O/DmUqYztPv4j7XL0vEF2eIC+sfunSkkEvwwz6LRY2VIDZR
        H7tWldV3ZY3NBbqQo5p/1po=
X-Google-Smtp-Source: AK7set+J50IPVaJ5yju0iO32/mGE6EcOt40t3k9qF6lUmEXOQ25ZiGXGO2yKwFdvHWFeLTrOIRdrTw==
X-Received: by 2002:a05:622a:1a86:b0:3bb:7702:97f5 with SMTP id s6-20020a05622a1a8600b003bb770297f5mr11745606qtc.15.1677010223102;
        Tue, 21 Feb 2023 12:10:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fw13-20020a05622a4a8d00b003b86b962030sm9273726qtb.72.2023.02.21.12.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:10:22 -0800 (PST)
Message-ID: <10d63bb2-6d49-d7a2-a5e8-d9114efb72d9@gmail.com>
Date:   Tue, 21 Feb 2023 12:10:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133553.669025851@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

