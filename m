Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A40D5426BA
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiFHEyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 00:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiFHEyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 00:54:01 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480DA2AD5F9
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 18:26:57 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r3so15550290ilt.8
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 18:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=49YVrS45Vywbvku0fH/A6/4OrA3D+q3WmkxQvwKqyKI=;
        b=YOmdyo/XCMqNO17UML3ZdHuN9Y+eK2A0qal8mBEknGZF+cBgCJlturlYbL9ZdEHoPG
         WTrIDMx4PJIPlFLyfEAbp7JT4C67ABiKveBRMPEQCJAP81hQ/Qsh2ojr0+lAAD4Uba13
         DCjYEly/xMq0/QUKUGBt6F15z0Zlm8HzUoRBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=49YVrS45Vywbvku0fH/A6/4OrA3D+q3WmkxQvwKqyKI=;
        b=Dv0Rsvdx2Mz6Gut679ip9JGaLLykACF4/o0i0Vmkj65Zp6Bcr3iCoUbRBYRnxWBMaC
         0h+y2u0LdpsYTBLqOod8KTfoWbhPkjUIQd9x9jyP/CWfHTDUxcJw5U1YFZouSTfwfs1F
         kQuxtYfJ7HkcOK78u+LhIulT/ZBprcTR9Q/+/vfSmmvzD6on3aQEYb+g6KNQiTVcQvzI
         8r34QqVuaO3ng2rifQk3YtVVHDjcyZB+PqK5Vl1UevFjl4xMQwIEyBISAYevHWB4tBlB
         V/qfTAgeo+OzAV6o+49MhU1+wHglmcQWCv8FA+lQI/HabxmWVv9/8O53mMcmZXOAfhmF
         JMCw==
X-Gm-Message-State: AOAM533by13xJegm/JjN8rV983ayxZ/iXWvSaRQ9wSgQVbcOQaGMjaF/
        vSubtCwncx22UjWWeNYXOMuTqg==
X-Google-Smtp-Source: ABdhPJyPH9BMUHvqhr8nqs8aepqKipDR8WqhJGWgP4nJ0OJAnHfPKOMomxYffvNdfNYQpWvx1dEQCQ==
X-Received: by 2002:a92:3609:0:b0:2c6:3595:2a25 with SMTP id d9-20020a923609000000b002c635952a25mr18461417ila.233.1654651616661;
        Tue, 07 Jun 2022 18:26:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l24-20020a026a18000000b00331a82096c2sm3087401jac.98.2022.06.07.18.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 18:26:56 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cb81fd66-1455-fdf6-85a1-1215c46f0c2a@linuxfoundation.org>
Date:   Tue, 7 Jun 2022 19:26:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/22 10:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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

