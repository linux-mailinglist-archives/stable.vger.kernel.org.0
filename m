Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AB76C2167
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 20:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjCTTaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 15:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjCTT35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 15:29:57 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865BF26876;
        Mon, 20 Mar 2023 12:22:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id fb38so2714790pfb.7;
        Mon, 20 Mar 2023 12:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679340139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8cZ/SgykcdtJDq1l5H8ozbgaiP6IPGwDuK89HEBuAk=;
        b=HAcPE40eOcxoCHrG43mfdwoOS2+q86L2j2Vr+h9AjRsyG50heeF4biSrz69k1wt07W
         QOFBXsskIOaqgReA4piu1x+FPZWh2I3waH+jyNFlLWJAQzNBYtAW2CJWiOJoeDqvHO8G
         BMxeLhOBHd6YjCDpKNmaZMH3v379debzozB5rUx8vvdPsZrvJCvTnfQgygowa1loCnpx
         fzEiiDHwb9xJOYkPZzzfsQ9CAZ8rMe5AB8ccgD5suy3HqtEs0kPBCJINMqhUG3UgdoW2
         ezowJByU4NU1Xn/NYFcn5n9LO6uOsiAMPn82CXxtIAn8Hf89W1td9e2ljrdefBQBZhh1
         lSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679340139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8cZ/SgykcdtJDq1l5H8ozbgaiP6IPGwDuK89HEBuAk=;
        b=rTHe01I9nVHE3cWrxTvla+a1/w0B+rD60HwTRw7jytobRGG7zVhpC/5aWKkUMQHrB8
         qhBNNqYBOOEkukt1Kv9SSKeJv6i60VkJIteIPCf5mEucneh3/2dbPhUCnbjHai77jFeX
         hqhzHY0AEKTb9MvdqdkhW1grtc5H6YXgGZKl9o4kPlCJI02bxu0yxkdXBU4/U4/Ke95d
         zZkVcNmMTSffuMB2mk1VQcDiqyVcsIFLN7OnpRhWNb1N3743Twc0msj2u8oCadEtRYZ8
         pevxghB4kRMEO9u8XSHBRKGU6wyBZX3Rk0Q2oA/9NI0/SWy7V9UHe01Y4+cLe482h86b
         7l4w==
X-Gm-Message-State: AO0yUKUSjQ6qqShyzv6oDaF5SMDEcS+p9qycxhEFyDapASZwflFfh2Gu
        xRCUMS6IX5sz6ChEZGWp7jY=
X-Google-Smtp-Source: AK7set/XVroZFVsiNRScnNn2KeEgRBnORCoFN2FALRhzbT0x+SdhdWP3ZrQNierHE7ZBHgGpMqugDA==
X-Received: by 2002:aa7:97ba:0:b0:623:cc95:e517 with SMTP id d26-20020aa797ba000000b00623cc95e517mr16252546pfq.17.1679340139327;
        Mon, 20 Mar 2023 12:22:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h4-20020a62b404000000b005a8bfe3b241sm6646418pfn.167.2023.03.20.12.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:22:18 -0700 (PDT)
Message-ID: <961d41bf-94d5-c689-e9dd-105d212bad8a@gmail.com>
Date:   Mon, 20 Mar 2023 12:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145443.333824603@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
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

On 3/20/23 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

