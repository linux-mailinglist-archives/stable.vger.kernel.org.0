Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0060A5421BA
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiFHFAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 01:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiFHE6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 00:58:55 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B2A258B53
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 18:29:27 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s23so17390371iog.13
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 18:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g/FyTJSdUmnIw8e0BMa6AuXeqzIW/H0uELplCSxIKYI=;
        b=WjwYVUwLrvT6SvyNkyxcsXhXmLjZb00LOh6ljURgUxzDG8Cn+yn9BkKr6OD6O6191X
         snwXgYG5mkDrpi2X+mhfp4ixpim4Shn5seCc2xe4eDEqQSRmuRa5Mgo2caG5/QzmReZK
         T6W9ebEu9jgkUG9AwDIQgK7Vf0H9l+xNgUBXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g/FyTJSdUmnIw8e0BMa6AuXeqzIW/H0uELplCSxIKYI=;
        b=ns46ApbdNY2GukOZ6CO9JZT2gP9kH0iUDpphqlZ/tk8DzkiEfCSHZlkuW6oLbFHzoz
         V2BQWrunTIfAISBu/P5iAWxYH8xG8r8ry83YpQIEuAQa1GNU0Iv3E6ouuDgjiZyTQtbi
         JlzEQ7nIP0mFGM1Lwrq1W6nRTyBZLgt1RkZE+MS3B0/WLf1T+VjyvfPZutpDGz4Q6v+F
         drklMvrf0rQyWqTRE54jThZ1F1xLYBHkhiIP8HeHvqXQgPSfrORT4D324IjuWygaFOka
         9w80OM6VfF3PwVblRjJM7J0kE3pRy9RWJUl2/GPWljfhPzYE/YZ9xqmgtf3No6q0QlVU
         +qcQ==
X-Gm-Message-State: AOAM532Yg8hztjbbC1jFpvMMdCKM2gknYqPWxe165lm/m/iua8BYoUUB
        8fGYwdULpVCpeW7+nmLG9sMq0w==
X-Google-Smtp-Source: ABdhPJwgHgS9a+2m4fzbod5RRpMFPyIWrF465Y0yhQ+Cc2sf+vRXsDSx9fp3Xi+hOnYE64g4wqA/Xw==
X-Received: by 2002:a5d:8348:0:b0:668:9cc6:1a52 with SMTP id q8-20020a5d8348000000b006689cc61a52mr14694337ior.101.1654651763747;
        Tue, 07 Jun 2022 18:29:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d97c2000000b006656f9eefa3sm7358056ios.18.2022.06.07.18.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 18:29:23 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/452] 5.10.121-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7f0e1a0e-a6c0-abaa-f390-4e1adc78d14c@linuxfoundation.org>
Date:   Tue, 7 Jun 2022 19:29:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
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

On 6/7/22 10:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.121 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.121-rc1.gz
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


