Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC8D6015FF
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJQSIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 14:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiJQSIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 14:08:23 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D1274B92;
        Mon, 17 Oct 2022 11:08:20 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f8so7162347qkg.3;
        Mon, 17 Oct 2022 11:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOieRG6GHMtDQYtFOeBbfhqtaxzZccgAi02Zhjn4Jb0=;
        b=pvNoyP9d+RZzD0e7Hm22f3BmWkYks5CRmMLUMRXLGBkf+ob2h3a2M+Txi5/LMKWgPY
         Vsm83urN0avfs3Pfs02CsCQbJr/jsg0hT3V83XLrJRGcpD61t16moMLL8sjTHOio67+N
         Phcg+N89iFlfLxitPRy2TUjjO4hxaymFJr5+vfym7vKIQQsgdSgDrTxLE3W+JmlxJtBw
         2Dcsjb223pTZcjAlC+A6Ow/S+muRHy/pXR0ufLN0bBEIuCAjsys++r17l1Y2+xnRU9NZ
         wdfrJTtJouaqAuvXZCOSFjrq2sGXUnq/3+ul+n0ZrKmSVwIoszG8oSpa4L+MqVvDVwMo
         H/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOieRG6GHMtDQYtFOeBbfhqtaxzZccgAi02Zhjn4Jb0=;
        b=Z5hyMAxAV51W6bNDNT+q5wMMexiKLm8ebM7bCxgIIxtrpKz1JzwqG7h5iapvvlW3Jy
         jeNkftvWQBKNb51L+x+PaS7b79EbI+t4u5n61YAJiscT+PIxuNdrz3GPJpFmQMKUKnd9
         XlU9CyStYPlvcTxn3DxCNWMvgG8NcsHeqBpdL282rSHY8akE1CfH2puccigz1saLlgkv
         wP3dDg3szpVwmdfX0proDw1nnElizIg4YNpmCBS3/Vu8O4zpwHOhIZ1Qi4lQh64w3sa5
         njV1r2p3AFpf1yJGE1Ba/lCX5UXY6d6SaVicwivcWZpH3mXPJRUnAYgFyHys6z360hV7
         iFSg==
X-Gm-Message-State: ACrzQf3P1Hzhz/wKvbf7sXGhavzbKWLFxQf4dfYtZCeXPkBWIYYsnIKx
        01lzWgtaoJcpQdjHXKu9WDwliEKm3uA=
X-Google-Smtp-Source: AMsMyM4Y5L4+0vxTR8bRxWaIBsWCI4Moxzil3Wtmb54ofX6pBcF1cIf7EhRb14Ik3rikM8dDJjscow==
X-Received: by 2002:a05:620a:530a:b0:6df:b743:9671 with SMTP id oo10-20020a05620a530a00b006dfb7439671mr8264174qkn.762.1666030099609;
        Mon, 17 Oct 2022 11:08:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y2-20020a05620a0e0200b006ee8874f5d8sm339921qkm.28.2022.10.17.11.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 11:08:19 -0700 (PDT)
Message-ID: <f5d5b851-66cd-b3bc-e613-bcb97db1a1c8@gmail.com>
Date:   Mon, 17 Oct 2022 11:08:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221016064454.382206984@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
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

On 10/15/22 23:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
