Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C154D4B01DA
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiBJBUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:20:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiBJBUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:20:36 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ED31EEF3
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:20:37 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id bs32so3416806qkb.1
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6v40Xs8Ytvxt0dDH5ckr0SUmNY8MyYZKnzYuhetFRrk=;
        b=g7XhLrabfAMa31SDaONO+44MUaqxJyyQ1DXkN/0PQi2qcfrTJkNnmXWpwJEy49wtcQ
         hq8Y/ohL/W6JeQdp6ZErKzlv+hdweaMWkKZ6hU6sI90MD++DZwzselOcYApTtI4C3CzL
         h7KFLlctJD1sForQR9GGZ70Wyv/kDtlCVYejw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6v40Xs8Ytvxt0dDH5ckr0SUmNY8MyYZKnzYuhetFRrk=;
        b=V34JSB+6hjeLHradc8U3iiskZwNPLusmc5LMmEAXInwPVJawpXmAF7DmjPzV/5sU7j
         u6uHVN8A6JaD/9S5LegtGC2j29H82AcVSg8wrgJAzroELi+kxSnPSs43Y6Uy4xpbns9a
         of8N5ij4/WHMW2XbRPqa+KhMMZ29nXogUidiJ52h/Gw60qAcIqI2zOfrDkni9+kVoyap
         7tnU3cWykIkFgkg7C+9d9rm3ynpJ8649d8pr5Yan1nYhk4B5PZ5nVlSt5JGlmXxc+84e
         cjfpmKghOpf0Lag0FWzLGsmzp6narMlYwVGnI5U6bKLEwUKwJCLukcKGWljgdTMiGw21
         TmfQ==
X-Gm-Message-State: AOAM532IsnWgGXquZ+LaGY14W8jLCiV2MsVHTxwpdyAkZ4Argc3BAtGM
        qiE6WOJ1v5UApSg/HWSUPJuzUlzePfShnQ==
X-Google-Smtp-Source: ABdhPJw4saNEQbesdBoqV2W+wS0zEzTkZdojv6Jco5zy72uddagAi8o4iGvor4N5b/AKz2f0vujHCg==
X-Received: by 2002:a02:3f2f:: with SMTP id d47mr2694158jaa.228.1644454626661;
        Wed, 09 Feb 2022 16:57:06 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id u26sm10442878ior.52.2022.02.09.16.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 16:57:06 -0800 (PST)
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220209191249.887150036@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b1ca60f8-59d7-568b-8e8b-348c1e70d32e@linuxfoundation.org>
Date:   Wed, 9 Feb 2022 17:57:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 12:14 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
