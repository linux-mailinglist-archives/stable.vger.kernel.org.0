Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3056C4F6E0E
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiDFWw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiDFWw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:52:56 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD61200364
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 15:50:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k25so4787521iok.8
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 15:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3qjN15LildAkA1UcTUK0Pb+T2oa5XZIOoRf6nmgevRk=;
        b=hSkS4doEGHqz4km3BOFtuZF5E82VjRRSbLKkI3q/kdUjojOc8WZPJxjGNVWwoEJlJN
         sJ84kxuKZmJRCxJyVAXGv35p+dlAKCiHjO41rauBicQH+2ZpKUA1dynaPUkLzG6bFnhb
         kNy/2t6UCVA9CC/0howpicuRxdwOi6FcA397g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3qjN15LildAkA1UcTUK0Pb+T2oa5XZIOoRf6nmgevRk=;
        b=ozTDqKcjQ6AvbE0ikn+MgrHiYOD23jkpkqYn9gRb+5H+XhpRvAPuETjYsw7kYj1Q8p
         oVYTllMulws0rbyTK4YC+tXao1bP6V1mulG08PDMUvxOF5pQ9p3qwm4l4JeyApJTSrR6
         Ez+9+7wV+wd6CWDXAl9/Rp5so2Fc3uEOmzbgCbqSTWVfuvv4CMo2yNX1X2MrGZtZiVZ1
         /UriG4ZFy0nHLLoxwRnyntSYhgEMewhuqo+JdV0iWPRnZLhdgpRbf6bxrbwvqv/pwfQB
         bKO+Y5TD7D8QU+y3X1qt6a5l6dwZTjZUyA6OVYzSb7Vmrdxr2dmIctgM383qXkTcdch4
         qbYw==
X-Gm-Message-State: AOAM531k7MbjgW1gkJqLnRly0qrW9rxsO5BnoWVYrlsJM+Jhcga5jyYY
        R2MQgjLmaI6Wyw1vXWCVz4b4UQ==
X-Google-Smtp-Source: ABdhPJzXH6rNGUKQlqhPfN5d+8YuFyoy0E9/BL1l2eDxtbtzbimDP0lRRdXCkrNHV7yHMAv43N2IJA==
X-Received: by 2002:a05:6638:1352:b0:321:547b:daa2 with SMTP id u18-20020a056638135200b00321547bdaa2mr5372535jad.128.1649285455605;
        Wed, 06 Apr 2022 15:50:55 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id m8-20020a92d708000000b002c6381d9144sm10383514iln.59.2022.04.06.15.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 15:50:55 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220406133013.264188813@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <028a0284-f939-4d62-3d42-06a2835942c7@linuxfoundation.org>
Date:   Wed, 6 Apr 2022 16:50:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 7:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc2.gz
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

