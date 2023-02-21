Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6869EB79
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBUXxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjBUXwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:52:55 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0B34EEC
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:52:53 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e9so2676763ile.8
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtxbGmpRXGP5UT9vivOAauqxrXOfSxdlO9oNFYJkrvU=;
        b=VeYVI3vOli00dAdnbyDsGIOz0PzOTmTxOr2wosdBOkL7d2QGbVl58hxpQbIPw5FDMj
         Z2pldzCxEIgxcV4w3eDwJ2Hzu65PujM3TMWtLoBhxBjcAlsTQuLBUD0FOBYwerCSk+rB
         md38G5IX3EOD8cue9hcTWywwz2p8ePJYMIgJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtxbGmpRXGP5UT9vivOAauqxrXOfSxdlO9oNFYJkrvU=;
        b=7ZgXqeSmUal65Hr43/+BH7n+xFbEtpxlDEYAXUCD6Ua5dMlCd+z33QzEB7VryvdeAx
         CrNfT7H8NFHU9bKO53Av0s+l97TWwmRA70b6zSliFujImq8hECthFKbnpzHuu29bQu6t
         +lCRYtNoZNZ1ljOyQsiPl7zhFcXzSGlYQy5a6RsOsYOQ2jX0361x2553ioIo3HaVQ/G+
         yv7v9S5ABDIqwkj/JtmFaGvLU3gmZFd0nZ9csUB9VHB+xdaGdBJBp9nVKH+w6ZkXTKok
         4RF4WChif8TC9kVAFBlQAaavEp3/pQJol0czetgNajkplFa13qqMrxGl5/UUqqWK8eva
         G8dA==
X-Gm-Message-State: AO0yUKUK9r4SKq3IocFR296nIU9GAGQiZDtwmSAJ8nQ3ImBRXqoyQeky
        aRQcJUQoQN7wameCEXPVzwZ8KA==
X-Google-Smtp-Source: AK7set/JE+8ksW+C5Uh7uxrvoQ8I21RBYceGnUP6xDBNQzjMl8gph078tMFbjEeysOHvvBFnTxJR/g==
X-Received: by 2002:a05:6e02:174f:b0:315:e673:e7d6 with SMTP id y15-20020a056e02174f00b00315e673e7d6mr4135976ill.0.1677023573217;
        Tue, 21 Feb 2023 15:52:53 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r5-20020a02c845000000b003c4f7c419dasm1678549jao.128.2023.02.21.15.52.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:52:52 -0800 (PST)
Message-ID: <4e0583d2-d7d1-9e35-37c7-34c9a64b3707@linuxfoundation.org>
Date:   Tue, 21 Feb 2023 16:52:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
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
References: <20230220133602.515342638@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
