Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64116B57AF
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 03:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCKCEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 21:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCKCEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 21:04:24 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6833B13EBA1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:04:23 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id 4so4046655ilz.6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BAaz3T7EVMYtAYEFCO97m9rG/0Se1MKw2KAFy05ZZU8=;
        b=H3v3AJHg4K6M8J29+tkbgIvgN1+7N7xmQ//Fa2NyLVnb8AEOWWXNCRrpmptrAbMFuN
         LJ317IkjBtYk0BI/6Mg8pRbAJn/pJTIKl2POU+l2DyjlQJTseWbJS0NsGUEjN3BP2A4Y
         rz20WwyhIlWli8CUE9O/NAJSIH0TxNnijYyQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAaz3T7EVMYtAYEFCO97m9rG/0Se1MKw2KAFy05ZZU8=;
        b=y89VkSJ94v3atidB/IOXHxHT+fSC8ijURlKjDC/Y2e9wWfwancE2k8MjlDDy9pWsL+
         iNKj0qW2wo5UWmeprt0kNoU5tpq1ZGYJG/LRv4+bDaDd9vZ0vO0Hsr2mH6gCi5iV/NUg
         QiDsMfw+5ZV3d/S8HOApxKfs2yoAZ1ZpYrboIoZ/P1RQol67v+iw3+iqAGvBkXMgmcvr
         DUK9/vkFZaRgDBeL0k9+LvJr75aqvYPHBa+qKKoqgt7pDQ1V5HzlrNMM687HpNP6Y5WM
         I4UGoHPYDB6A81yc7yqwqiTd72mOXHX64kSJ6o+cCX4M8TG7swEAppLHK6jjjT5DG0cp
         WXpw==
X-Gm-Message-State: AO0yUKWjrLskK/ZQYo6HwEc4fqwbjU6W03flDz/xnDaTju1FVtYF2Z52
        SMHwWHnc1WHYctQDQ4h+nzK6vg==
X-Google-Smtp-Source: AK7set+Dai32Wj82NJWlW9hFd7xUMX2tvvddwKywlDBlWfZ4l1YlPafpHJEGcYzib1mKMCqKAUuQow==
X-Received: by 2002:a05:6e02:1c86:b0:317:16bc:dc97 with SMTP id w6-20020a056e021c8600b0031716bcdc97mr6545777ill.3.1678500262780;
        Fri, 10 Mar 2023 18:04:22 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i16-20020a056e020d9000b00315d1153ffcsm451641ilj.65.2023.03.10.18.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:04:22 -0800 (PST)
Message-ID: <9dab07e5-46fc-2aeb-65bb-5f695cad527e@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 19:04:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
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
References: <20230310133804.978589368@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/23 06:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc1.gz
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
