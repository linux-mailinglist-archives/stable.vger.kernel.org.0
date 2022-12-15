Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B1064E4CB
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 00:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLOXuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 18:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLOXuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 18:50:06 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9EA187
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 15:50:05 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id m15so502127ilq.2
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 15:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SfR4cKiYRNDI8PwCEga4FkweP1vMW8KeW1ae9VEFMT8=;
        b=hEtXEt5yGYSMvMmCX1sggivIAhx5xVkfPU2c5zFsR9zA0ghrFMw5IvgXdTV+45UkE4
         LLw5tK4omPuV0L+IyJ153Qs5eqnNOaXes5KjTrjFSjdaw5e+FVGS+sKsocrAvw3JrF/n
         eNEPkcicgLwphnHEg37kcmnQ+AUrhMzGIqwoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfR4cKiYRNDI8PwCEga4FkweP1vMW8KeW1ae9VEFMT8=;
        b=5CQ4fP1ordyzRziBSvHglJ6DKxpXIF9/Jam6U5tm7taJPZfQf8fV2fKwut8eOMnkDA
         BG1pPS3KBvolrnwzO17IiSzQixncj/YmJNCT30hGobmEcLH8BA9CfjME+ayf11lwoqGb
         jIZ58eewD90zQcEaxJTix/h0E6YrN0kVc48i2SiWzZhizo9uMWy7VBCWtA/vQbDGw9OX
         +YGxJSy5Hol+lX5/3CatAN7rvk596ZVvR1VUGv7ITWX7gJB2DbRJmKqIKu6xfn/sXTPs
         35fOzl1VmwujugM4ODOXaV0FSgV5JG58Jy9fVDvOe+4NeXRHWbRC3z2ccbXczqKHcG/Z
         CPIA==
X-Gm-Message-State: ANoB5pmvARGHFfXjYVRh6WUugWR8uwURjtDlhc0KcQfxWX1DJ1fdi4IY
        REbPnUE6okxglX598db2SYV9Vg==
X-Google-Smtp-Source: AA0mqf7VfyE5+D2eyauI2p/Y2zRBsWM4cCQNgOASqdZ/r6m7NmaH0xGApzD30g+nRQ7nrW5quhTrzQ==
X-Received: by 2002:a92:cbd0:0:b0:300:4c9:f52f with SMTP id s16-20020a92cbd0000000b0030004c9f52fmr3224688ilq.0.1671148204339;
        Thu, 15 Dec 2022 15:50:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r14-20020a02aa0e000000b00389b6c71347sm235679jam.60.2022.12.15.15.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:50:03 -0800 (PST)
Message-ID: <d380ea35-668d-f553-0a07-939bda7086c2@linuxfoundation.org>
Date:   Thu, 15 Dec 2022 16:50:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
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
References: <20221215172906.638553794@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
