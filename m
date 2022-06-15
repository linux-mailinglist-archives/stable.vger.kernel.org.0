Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05C54BFBC
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiFOCm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFOCm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:42:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC6B1FCCF
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:42:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s1so7938128ilj.0
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P2NeFHtbbsnumxwBG2lthn8TdVaidiO8VVvB7Innzf0=;
        b=BdtqOOSzvZD+p7SioxYwvx9u9/LS4fQW5A+4ZRAZ3INjbZ6IkAADl04bMDd4De1QOK
         oR6Ufw9YYtGyXcfrVa3Q/uoFzQaWZr5VYYluu5peJ8Lt719wIO8ynyx9sQmMKJpOHDBF
         s8xpQNsQAZLLttOtsbefwfAO7YZMdCKQwLs04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P2NeFHtbbsnumxwBG2lthn8TdVaidiO8VVvB7Innzf0=;
        b=3mHS4PXWZ4/oi4dhzTTmXBEzosZ8tW+cAvevfaffQB1Orzkp2NtgAkCKH8X3U4ATmo
         /7F78YmUdj7HwrouHzXt8CGY5Zi+WuxHdrsIY9HAnZ2LA+tVIrYKEe/WFpGTElNqTVQc
         aAlNXNif6y+YEc4LdIqMe/QEHxdL0gFJSR4f/XaiYiPCvG1YbFwC5WfV4R8EXyEJebWO
         IqoRTlkrJiaAakPfJ0dCwJ81LfWF56CEJCdTPU2s2/dMjv9Vfs87qio1KJzoaV8MCFPV
         hbuR6CJ7smuZP0TtsODZB9OYa0+UGmFo1GabCbDhuSP8rQaxXvvCG4MgJCCMISy+f3MH
         F1dQ==
X-Gm-Message-State: AJIora/ZPgmTGO89Ph2kU6ddXhpnb5/akWf9gEUce0GEToAqLQlK5YkG
        hwaAWMov4DH7J+icWrDALTmVBw==
X-Google-Smtp-Source: AGRyM1vpJY/mWB2iiNmbEbScRLXhjztibIEoIYkHl0RVmtfBQyfuW9tI16sT/YrzrgCmJAh5w8emyw==
X-Received: by 2002:a05:6e02:1ba6:b0:2d1:b582:a9db with SMTP id n6-20020a056e021ba600b002d1b582a9dbmr4826016ili.90.1655260976804;
        Tue, 14 Jun 2022 19:42:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id cp16-20020a056638481000b00331f63a3dfasm5626135jab.122.2022.06.14.19.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:42:56 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/20] 4.9.319-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <45355854-af64-b5bb-cbb7-d980d52555e7@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.319 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.319-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
