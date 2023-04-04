Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01436D6A52
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbjDDRVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 13:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbjDDRVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 13:21:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C34F9;
        Tue,  4 Apr 2023 10:21:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so34713459pjb.0;
        Tue, 04 Apr 2023 10:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680628902; x=1683220902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZiBMCUFMw1ZDjB+YrQkeZxAt4DJ2+vedDb0Fa2LgdvQ=;
        b=kGCKFdF1iNrmyIH2cBWz0Q7pkjddKmSppklppuCOY8LbV7b69uEhrel4aS+73Uy+E0
         9LB5IUGOHpJL40tPrbFJs//NQGHzk65YP6fETCejP1/st7X4HqTFMWM9q5f10ALilMuU
         NbTqoqFNC7JvmY4P+uc+O+ivIWaW1DLEyY5pOjNoaZehIgXEw46g51nYiiap7vXO1B/N
         fTmXo9/GYEoNAWhvbm/tkVafIvAY1kIXbEROuibRmmkhQtQKsyQDP8BMdk3fd40vqbYV
         wfNOPHNo0w6qejQr5c3qwFRTvyJxSeeK4XhzZx6sRmU9x25wfrO1DEJGh7Ezve1fb+ih
         9VgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680628902; x=1683220902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiBMCUFMw1ZDjB+YrQkeZxAt4DJ2+vedDb0Fa2LgdvQ=;
        b=2j0RBT+UTzAM8l42ExVcak3ZIz869YiceVn+4B0/H7rBkTwIbV7N8lfQjBgnWUB1TN
         NlR13rv/nswtaGpBBtzXtAg+08b+WlTg6DjI2ppW+yv+RAbYXrddhki9iWKYCRXQijDh
         SnVvAMcj3WMlCiay0tzLXVoID8vLbYTxI48c//XXhnupHz4MQCEN6I/oT3H3xiUUcCFl
         fniWkoLAGSQ1DenBwkz9CKGWF64SwRMTcFD67K0djGVxBzXdpBbVqq6XHp/uOlZ576wx
         26gxTvx6i41OcRHarndRMzVkMdEQo9JB2I9bULYYXQakLFfeBs/UcstUlqEuJUD4qM/s
         XITw==
X-Gm-Message-State: AAQBX9eRxtOPH8snjRdihmE+Obj8WAeMMP3ahSy+nq3Hfs2zmqm4rD1A
        PA2Mqpi9ne30aM1wGndpEmE=
X-Google-Smtp-Source: AKy350aVMal1RU9eiSmBLW0rJxH/MrWDy+/ZJBHjFSrh5IJ8d5fjaHlNLVfbMVxA5NfnCN2G7OkWZw==
X-Received: by 2002:a17:902:e353:b0:1a0:428b:d8c5 with SMTP id p19-20020a170902e35300b001a0428bd8c5mr2914493plc.45.1680628902448;
        Tue, 04 Apr 2023 10:21:42 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g14-20020a1709029f8e00b00198b01b412csm8544231plq.303.2023.04.04.10.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 10:21:41 -0700 (PDT)
Message-ID: <052a7a73-ea48-a4ff-f8cb-b30a40ac4b70@gmail.com>
Date:   Tue, 4 Apr 2023 10:21:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140403.549815164@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/3/2023 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
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
