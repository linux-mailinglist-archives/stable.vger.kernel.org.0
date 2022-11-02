Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED66B616B32
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiKBRuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 13:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiKBRuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 13:50:39 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1462D77C;
        Wed,  2 Nov 2022 10:50:38 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id l2so7118073qtq.11;
        Wed, 02 Nov 2022 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CRZEan3NfgrT4VK7068yRQxbI/GUnjcqKXl3lAB0/ok=;
        b=mlGALt0BHtpUKDMrYFh2gtKO+blRh5meqUilXOBvg8laYEGDab4y87YHGZO5JD8MpJ
         SjHmn8gJ26KYJ2Ri9NtYaTwag3QkYZ2ZfymLTUApepX2dTMoQK2ALlOGYg1jsTe0aQjf
         GIQv4wPH+HCAOVmoNPfHEh9GVoLC7Wei1fH0wEumyfU+30osWUXCFQ3lvyczkABsgxpp
         6JsPg36Pm9CLp0Bskv9qeHQ6JsS1g3jblsc6kTE7ctujhRfE0dENIyMCjuwS0jAf2aOE
         A5WFDEilUzRGSJGNq02E4JsRKvRWt5tKwJ9XZGl/ZvpHGc0SEfo3GI35NZbjFvONNg3V
         gGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRZEan3NfgrT4VK7068yRQxbI/GUnjcqKXl3lAB0/ok=;
        b=23AMAmMB/DX/ufBwxn/rfF28sk+7Gp756JTm+H3dW0w33CxSLN7qwhuXsEbik5ErdO
         RF3biCIDIr2uJMsx94/7wgI7iDdTR4Fb0WV4pT3L8OkbxZYQq5FLHiehWaJlWameyvtT
         a19d0gF9/I218dXyzWFBlOzBgU2T9KmkzcrNaqepHbPlx2CR+6WFVowAT4uS9muGOHtt
         DDWY93Yeh1GO2HbY4NdPBGVwpcLdVa961uQFtKqdhGp2CsNvspkXV02wnqg6IRluoYWx
         7UEsrGVFZ1zInhzvGcrPL8uwjiWpuKtvXMUBKObgwEQTWQYoGzgWTZeld+K8fIUC7Q9y
         5BUQ==
X-Gm-Message-State: ACrzQf0YV/sc+XiAaK3+qbT7AXZIr35sQUNVLMvmnzaUsT38UnDddWOI
        HznMjb744i3yEVVmecMyJZm17XT+gVi1ew==
X-Google-Smtp-Source: AMsMyM6XEL91aH2CWjdS98WCCWDzMHmTULvcNfPORFbx5ZuPrvgFRDsfOlPMYIPzEHTQW5jf2npRKg==
X-Received: by 2002:a05:622a:1793:b0:39c:f3cd:e725 with SMTP id s19-20020a05622a179300b0039cf3cde725mr21314518qtk.333.1667411437861;
        Wed, 02 Nov 2022 10:50:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l1-20020a05620a28c100b006bbc09af9f5sm9011239qkp.101.2022.11.02.10.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:50:37 -0700 (PDT)
Message-ID: <b5eeb462-f5c9-37a7-f2f3-f90a7c89a632@gmail.com>
Date:   Wed, 2 Nov 2022 10:50:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022051.821538553@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
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

On 11/1/22 19:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.223-rc1.gz
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

