Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785506A791D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 02:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBBme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 20:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCBBmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 20:42:33 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D83B854
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 17:42:11 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i12so9575643ila.5
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 17:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wHgJd2c1+EDM3fHoog+7zpbx7+QkK+zQV9gtvUQdxhc=;
        b=WqpMGlw8tI3RBq0liEC9WqQpwXo/q1lUUD3X1jP+OpuGuJTLb4bkOz8YxxQ1f0LV3m
         +ctyX+H30xdWALHH2kRq0ARd96uvjcTozDN1XeBsf3PC++n+hpFEVTPuCR0wpnHcNWd8
         nhtkalQRzoQBjcWvM5XA1KyL89kdtQdlVv2hA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wHgJd2c1+EDM3fHoog+7zpbx7+QkK+zQV9gtvUQdxhc=;
        b=KMjpVTHzCPX8qemtaLjhQLxo1UnLx3a698hEjHcMBvQdLLYaygm876xowGZrrnzcIw
         SamR5dqTD/TOgvbtvSAG0fVjYf9EmiRYXzWhqAeVJkQWiU5ZtqB/oRCnOgd+cebXkzcM
         adSXNER4HKHVFeVSzGUIg1JJc9UxUuUBzzdZG8C05jaUQJwZClHXZvGYh9BA8DnnI1tD
         bFeR6Qwlv7MsY/qlAh8FWGRldQlwSk0wpq8FJIWZLYfSrxeraOzRsXCVdCXjXDbUxUpD
         pu3oRg99VFhIfS615fYEP8YKV76pigy8bZVdBEPchHoqNEHAD9toawLbciFQZRsa/Uw+
         EoNw==
X-Gm-Message-State: AO0yUKVktFtoE+/x31k84u3F4PL7Gz/qFuyKQrQ5sPwmXc/Ieeic69FE
        rAiaXsPv9hIDLWtGbfgXA+dxYA==
X-Google-Smtp-Source: AK7set9xHkiu9dXiF/tr/Vw5b7l40+kd9CZCRhOLGAZoeecy4rPwbi8IkZd/kSC9JD2cHqY2yTQmrg==
X-Received: by 2002:a92:6c0e:0:b0:317:16bc:dc97 with SMTP id h14-20020a926c0e000000b0031716bcdc97mr5581633ilc.3.1677721325167;
        Wed, 01 Mar 2023 17:42:05 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t5-20020a02ab85000000b003ab21c8fa84sm4322772jan.121.2023.03.01.17.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:42:04 -0800 (PST)
Message-ID: <1b98398f-0608-2ebd-3739-515645cd1cfd@linuxfoundation.org>
Date:   Wed, 1 Mar 2023 18:42:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 11:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
