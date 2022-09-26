Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6315EB1A5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiIZTwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiIZTwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:52:17 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6C21E712;
        Mon, 26 Sep 2022 12:52:14 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c19so4814109qkm.7;
        Mon, 26 Sep 2022 12:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=R38P8eP5UIItO6LW6v5vYMPVeWKU0b6TSYKF1qq6IIg=;
        b=d6XvObJsgqVasI/tLzxisO2rBxiH4DzUJwf8Q70t4Bf6ybL1esB9cpeOWq8xSXBRz9
         6gePLe2xBxwniodxDAA16qWFCoV4/rp+y5hKSuc0u329rwsgT7ZrrdzTkKyfvsh/DM85
         vNvpIcMODkpsS9rHko9UZB5HCtkv1hO5n46IDqJzIBXG/mPxlx3IiseV/zBwJg7zOSAh
         mWdqGVJGHttnInagzoaIAEfmR1LuWPgpo3mZ1YbEYQ++tWU5rkW2K/cp1jzXOS8gecda
         ZE3spIIF19uvRX4M0gt2x/FrynXHavvvzUYPcYICHI1ZjtVix7lgYKfMgV9bNgltNCUG
         jO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=R38P8eP5UIItO6LW6v5vYMPVeWKU0b6TSYKF1qq6IIg=;
        b=20iGxIu2wJ0Q1i4MBDwGcVcCfMPPLZIFEA5hKh8CB5VaiPayHfO7GG0THOdajx5uH2
         PMzveRKfb3q0X4g+Q46PFi/SN4KAKokgbH588KZCNW4QpI7ZbWe87y4eTzMEZieaQ1pr
         iSAwvVEFWOSI8jJxmFlPW7PZRIkM96fUxXDt7V9EoR3Ku7REiVrxpyUVMQDt/KXMfuna
         guzXheaMDntXIsSlojLAOxZx0vz082IkyJcvlDUUJphAztmrRPV4DyV5Hbs3cTQvFb8j
         oz2EXqnj1HbLXBL1Nzynfet/dUZPCiJUAREmeqYx30SGcSA6ufGdeOe+9ASOcVCe9SUg
         0fbQ==
X-Gm-Message-State: ACrzQf1SvuNDBLCF+erhotGZ01S3M7gRjOxktsEYGp6Je4vHLvUwu/Il
        Fn8xy7649LoxK5ei9Rab8dA=
X-Google-Smtp-Source: AMsMyM5VOS0xaIBFzYq7CunoDLBSEgWHgq+D9qUvHAi4zhzy4EDr7PrBwunb6h1Vh94PFbffarqeRw==
X-Received: by 2002:a05:620a:2627:b0:6b9:1b05:7b9 with SMTP id z39-20020a05620a262700b006b91b0507b9mr15945805qko.776.1664221933081;
        Mon, 26 Sep 2022 12:52:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n2-20020a05620a294200b006cfaee39ccesm956005qkp.114.2022.09.26.12.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 12:52:12 -0700 (PDT)
Message-ID: <c8254c17-5017-58c8-7d01-37d76d9bc6fc@gmail.com>
Date:   Mon, 26 Sep 2022 12:52:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926163546.791705298@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220926163546.791705298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
