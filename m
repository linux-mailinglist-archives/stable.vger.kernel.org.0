Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7201A63E1B5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 21:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiK3UR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 15:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiK3URQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 15:17:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE84934E0;
        Wed, 30 Nov 2022 12:13:24 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so3457830pjb.0;
        Wed, 30 Nov 2022 12:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKOpOs+nm7ZzH9JjlfBkovi5sBxujs0tny+wQJDoQrg=;
        b=p05GXhfJD1Dz4nT+H9iQPs6s28q4PBydoI0JM6DXF2VvA9h10HLcCM5+kJ80Ksij0C
         8omDXH7ZIzEgQwP4BThhIHpDeNe2GdHuJAuyErQ6pGtpsrf9FXp3zD02gMIFzKCPHNXm
         FI2QXOmx9Or2SMHPufLnrE57RkPYjPfetzQvyxvSKXURywO58EyfGEzezvx8ZzB4EgrZ
         7DYEvHUVjXCzGGhclaKVBpndVnbZltwtBbR4OVGYo7MHNKLxT5/4Fk3bzNqhXrtEiIBF
         blB9vnP990lxbMJLNNtSBfR57HV+TtU7SjmxAI0Mx3z4kXvbnb0xNzQsZ3othOb/cU8k
         ghJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKOpOs+nm7ZzH9JjlfBkovi5sBxujs0tny+wQJDoQrg=;
        b=V2kH/0U0neBDxv+tamuNmTofJckcX2vM/DQOWjmu6pgoSSSFyzWqR3/aFp0y7mcRqI
         VcZ2UJLesL4zkUCaUgAW9L1SowW2drM0nWWFGs+sBUHO9TFeos9ON59weOTRwNpoW54C
         HRHdhig++cseKHKUN55MRADXzNFX1LNNQ5Bi5S030ZZEDVbQkUxGvfBx5hWSoRkg7JWj
         +2lXSfx8xqBi+xV+qVP4XvThOharmwKvTg4Bta039yLYDmsIEDo1WM0V7uFM54/nJ51D
         iZnqZ3EvGaZZzGBWPiSIvORLjOL/NV/73+m2JgaSh3TXw6MbqIGP6F9R5lCgT6xDG1j2
         PS8Q==
X-Gm-Message-State: ANoB5pkN2wVHoNSaU8lODclmsh+Tab/z7fblvYPrCYHphUZOBmtOwUWQ
        Zz/iKXCC6Oxs/dfno1LBJ2Q=
X-Google-Smtp-Source: AA0mqf7ZcYjKFLIMP2LqvtdUyjalnj4NmE4TYogKrlRqJyYddNSDk3DauBBh5BDD9Jd5kKqnEAUmOA==
X-Received: by 2002:a17:902:a9c6:b0:188:52df:769e with SMTP id b6-20020a170902a9c600b0018852df769emr43061154plr.30.1669839203509;
        Wed, 30 Nov 2022 12:13:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nn7-20020a17090b38c700b001df264610c4sm3050895pjb.0.2022.11.30.12.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:13:22 -0800 (PST)
Message-ID: <607a25cb-a121-1bb5-4203-e9e526f49fc8@gmail.com>
Date:   Wed, 30 Nov 2022 12:13:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180528.466039523@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/22 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.157-rc1.gz
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

