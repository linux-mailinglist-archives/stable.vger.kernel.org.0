Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185416A7926
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 02:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBBqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 20:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCBBqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 20:46:43 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC318E06B
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 17:46:41 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e11so2567674ioe.3
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 17:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TeupPCDbd6R78m/pmA6v+CX/TX+yWDdkPxQs8KMcp44=;
        b=RbktTVUJDJ9SkcsicRD/l1otQyLVQk8lH7DLLk8gy7J/Vm3EVSBtzeui2mMNd+APX8
         X8yCDhTOcTjIQMnU6OyvWmL9eAudMHTSZenQfsEEC3kCsZmBzipQguS4S72mx+ZsFBZT
         hu5WaAdqQwfqu7nNB5nyrsBb5QUMWH5IZvRCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TeupPCDbd6R78m/pmA6v+CX/TX+yWDdkPxQs8KMcp44=;
        b=ok9uO0cvScpnLKj4E30yczE+Qnmp0e92D0Y4TkcOH3qcDV7FHCpCh2IXA3QVp9ManD
         6lSA2aza50y5Ih2vgdxT/ZFyXyLYZ6U5qKXaRh5kF5eL9+Ko2e1x4RDo4EYIFrq/VT70
         yqr7OCUXa73Gw+kPW1+cimZcjboNyPT+dRSAu1zajY8E37GTf/+srY86qKIEPHIz/tXT
         YmOXd8qfLXuUrGTD3uTd/pN865509zYbD2qZTibun9/xxvmEoqtOBuUhLArMCmBxAv0k
         9ocGZa1r5J2vHhGyRoy8EsMt4p45vpIIwEQEcvROJQZp/oVfb9TBFH6AGPU/JWPJ0nNW
         8qUg==
X-Gm-Message-State: AO0yUKUShgWIYxAWySrl+xpzvG90JbmxznC1r7aEgMu6IGNlJ73hFkb2
        hbogLM6Scmb1/krfFAjE+C67sw==
X-Google-Smtp-Source: AK7set/sJBwjh4I50VLZ8hqpBfE3S+l76mr1EcvexSXth+Uuexl/i3djxhktrptbBKzJil/EwQGAag==
X-Received: by 2002:a5e:a704:0:b0:74c:de17:fa3 with SMTP id b4-20020a5ea704000000b0074cde170fa3mr5038493iod.0.1677721601256;
        Wed, 01 Mar 2023 17:46:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u3-20020a6be403000000b0073d7d30fb3dsm4288376iog.54.2023.03.01.17.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:46:40 -0800 (PST)
Message-ID: <71029269-20f9-2e67-ae54-3d5ef283a194@linuxfoundation.org>
Date:   Wed, 1 Mar 2023 18:46:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
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
References: <20230301180652.658125575@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
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

On 3/1/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
