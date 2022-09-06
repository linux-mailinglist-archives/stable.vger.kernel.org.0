Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8BD5AF73D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiIFVsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiIFVsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:48:03 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843B9E121
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:48:02 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r7so6660272ile.11
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=il20eRyoKrTdLfZOLk+7YtsU7sNqELjGnKITudW5kc4=;
        b=WTOLRlhSWnzmFOL7Uu/JWuxzJeYfdA4UtjxJZJDtNYeJkaBGGBEBJVGc0sZGuOdL2f
         sEFj4V5kZwuJcH6AI3vGl7PRNhp0iEerUmMMbrjZpN+8FQwyFGGAyQjE0V2iGGIeZkcV
         Dt9XEs1q7uh7/b/HY6wXh1yyJKtTnVFfx0Bqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=il20eRyoKrTdLfZOLk+7YtsU7sNqELjGnKITudW5kc4=;
        b=auU+fGuATO6MDk9MDCz/PyFJf74Fo1yG5obk7pgW/GPIJvK4u81KRn6dwPlh8/fuWQ
         iwYi72EGPZCjrzWuXJoYaF5A327tBkSGigOzSTgdsLxIITzEMjlRc8FGVFgJ5eND2Ev3
         FjV5C/8JQWPakwdTlPGRat1cRQVGJw3tEamsZFYrjaL4VMkeKjMsGNQnv1x6nVvSkFHf
         jorjlYlNcoLdf5zqhxcZP+orHmWTOUUqOOeS5PUnGLr2wHxe4xBgpsyQamxqk0m3o6pd
         Wm/CRjP79B4Ijpq/lVu8B1704ozEUZYUYC3OJtxwxD88d2SoNzuzyetDo3kyLTpPSkLl
         OcoQ==
X-Gm-Message-State: ACgBeo3ReLNiIpB06rKY7IpmcsBv3RkFLJxv89YcRJmudJpoH++9zdKu
        k9nmcmivHcv82PHthv6lQWi5hQ==
X-Google-Smtp-Source: AA6agR7kw8HdSV4krsWZNqNq7S88hQl+wbwMBXw5kftWjK+LozhUZzAExYK1Xhk1zOwMiSFC3rLtXQ==
X-Received: by 2002:a92:ca48:0:b0:2f1:eab0:2039 with SMTP id q8-20020a92ca48000000b002f1eab02039mr257535ilo.305.1662500881746;
        Tue, 06 Sep 2022 14:48:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u72-20020a02234b000000b00349ccc2db88sm6150522jau.101.2022.09.06.14.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:48:01 -0700 (PDT)
Message-ID: <3b8453f4-a748-5cc5-7903-ba3a8712ef84@linuxfoundation.org>
Date:   Tue, 6 Sep 2022 15:48:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/6/22 07:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.66-rc1.gz
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
