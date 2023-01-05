Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5A665F149
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 17:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbjAEQhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 11:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbjAEQhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 11:37:03 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45795C931
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 08:37:00 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id bp26so6589097ilb.3
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/kxRv6fDXpaPXcp/0ocKs2qh6YQ87UzMYUDDy7haK0=;
        b=P/ReJo2wNBxBTrUvbATD2VYqnybUbmSQkMNCwYbq6tWw0ZpaAzN028TO6fxbH3uT4p
         kur/SrzvKiAHIRzJTvJVUZlYb0/p5yCeY+3Gsq18ulNrxpc5nEokk24OzLMUJC9jYgjP
         xA1KCyrZd8ywvsgKpPXeN3GmTgrxh4kkoYVPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/kxRv6fDXpaPXcp/0ocKs2qh6YQ87UzMYUDDy7haK0=;
        b=cQKjSqW3/iqCz+D//hA3Nn+TI23EE3obfYEO36IWftvV002XTr+w4FZFg4CLWaqw+6
         YTPUP5urXir3KENSB6J22pwZ4GXT8YxbFB4qQGxn1jIwSGYqo0f0W6eCsYwHeIKv5ZnZ
         u1DOmL69w3iwAipuT1tKdhDrQw8zSVj1ncntOv+pgknEFzRn/sNXqXSONbXMYlnNrAmj
         KKZ2eLSR8VeFJI4D9edUWLU7mNnWlnRhwmXvWMQUdb+L8vvKlWF/ZoIVF+tAmOFgp6Vo
         2Eb5GF2HCLswLpo1cCHPDS66+yhJ6tDjQMXLWKzpiXlXmqxG8AaaxSlS46c7Pks/mIkb
         AAdA==
X-Gm-Message-State: AFqh2kpqSZtC2DvFTteW1PghDKeJrfBEnj+1anvTF2OFzIO/4buo2zxe
        EnQTxyxLyGIXNV/bnheLTtg52w==
X-Google-Smtp-Source: AMrXdXu1OcNEMegWeMxBM8DfgQFOIdcUp7iZ2c0I4lCdhAQPGLaAYkGDxFbcnpE3v+nFuo9yTF85kw==
X-Received: by 2002:a92:c151:0:b0:303:9c30:7eff with SMTP id b17-20020a92c151000000b003039c307effmr7706859ilh.2.1672936620210;
        Thu, 05 Jan 2023 08:37:00 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f16-20020a02a810000000b0038a8f0b4919sm11973940jaj.140.2023.01.05.08.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 08:36:59 -0800 (PST)
Message-ID: <a5148d63-a4cd-cb49-58b9-6421bb8aab97@linuxfoundation.org>
Date:   Thu, 5 Jan 2023 09:36:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
Content-Language: en-US
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/23 05:52, Greg Kroah-Hartman wrote:
> -------------------------------------------
> NOTE:
> 
> This is going to be the LAST 4.9.y release to be made by the stable/LTS
> kernel maintainers.  After this release, it will be end-of-life and you
> should not use it at all.  You should have moved to a newer kernel
> branch by now (as seen on the https://kernel.org/category/releases.html
> page), but if NOT, and this is going to be a real hardship, please
> contact me directly.
> -------------------------------------------
> 
> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Jan 2023 12:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.337-rc1.gz
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
