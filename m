Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEDC6BC1DF
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 00:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjCOXzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 19:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbjCOXzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 19:55:32 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EBD5DC83
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:55:23 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id y12so102742ilq.4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924522; x=1681516522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJmb45xduCOTtiQomI20pSAQLMuMo+/lMZmF0lsBs1o=;
        b=KWnHapDjovKMGnS8P5pL7xeopb1wv/Fa0NavOmofiMDoOBXOqneZ9bohNYgthYrTza
         zqOcDj1SHw6YHC6pF+G8yK0gLt98rR53dv9PGhlgVB0Jqvd0na/6Jcq7LJmRL7005UXt
         oRaBjm5b6+7DpmWjwLLUcBEP1sngGJ47XUDcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924522; x=1681516522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJmb45xduCOTtiQomI20pSAQLMuMo+/lMZmF0lsBs1o=;
        b=1VBbigM2xA3v5HUOx1PsnzC4NTUyrJpT9xFG42MZujxSGDNJS+GDv+IN6FUAl+LgFo
         7LjLn5+aovgaQKHmRBebI/uW8jaOctlGnUrIXHZmZ2OYJxhPO1Gs2Tokg2mz78Dc/1bA
         VzNGKe9ZyyoszlyqizPOBUFPPgo1GSeEPsNz/DFt9cqUqaGqTKK83GOZ7ov5UzJncXLB
         fxj7P3QARTS91eUE3cQc33lTe+eG+tV5A/NOL/xxhZI1yUWy9o7V/vxSLDRSAPkMqNK1
         8tRqWIuhhdYE64X0rZhcoXqRnDxqglfSgxEJe1cLUubMUYurVwiVgpMxjC4SEAXZAm5P
         qmCQ==
X-Gm-Message-State: AO0yUKV2cm2+kBUbtPLLjSM/oSohGBv7N89cFuMJR0xP1HXJgmd+UhnM
        ZimNl1VclRYUIuRlL1SuE0/+lA==
X-Google-Smtp-Source: AK7set8Lke23ypiPd9J8rwJOVhaTU9GcNKrdeRaFGQdJaYmF+wMwU1ptFuGdQSvcSVroJ/MZyWjgBw==
X-Received: by 2002:a92:c5d0:0:b0:319:5431:5d5b with SMTP id s16-20020a92c5d0000000b0031954315d5bmr558832ilt.1.1678924522458;
        Wed, 15 Mar 2023 16:55:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s28-20020a02cf3c000000b003c4f5f9f577sm2111326jar.25.2023.03.15.16.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:55:22 -0700 (PDT)
Message-ID: <4c7745f3-fe4d-7e76-ec64-6ba5df24610b@linuxfoundation.org>
Date:   Wed, 15 Mar 2023 17:55:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
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
References: <20230315115740.429574234@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
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

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
