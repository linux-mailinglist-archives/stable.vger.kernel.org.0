Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C968764ABDE
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 00:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiLLX6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 18:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiLLX63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 18:58:29 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE2F1BEAC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 15:58:28 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p6so884088iod.13
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 15:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTfI3BBJjBlFIJ4V+DQdc6idCrnKkd0U9K4WNFsdPJA=;
        b=V+thIy0TcfG5SzUQh2o7bx4JrsI9qlf+N9DiECGYh5WckQo3HLyoV4WmI7JweYaqfh
         T48YQB/r2sQ4f+vQvYvv4mzn58/JVes9lIhvyNRWOnKpj8dWKGrBimCrlfx1daEjCOqa
         ukZIz/xL2ldNyDcwbyGK16PpDDu1KzHQ3dxeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTfI3BBJjBlFIJ4V+DQdc6idCrnKkd0U9K4WNFsdPJA=;
        b=tPnVDGPU0n/g1KKiRZhKpFEqLG+Jwna0Ra+8TygJHJPDFOuQljVIYktNn0p7V657vx
         GbwE4mxLpvriB8MLOqu0PL98EHvwkwZ+214ifUmHF0fs2W9HggbRcJNINSiNKrLFAYzG
         nMqANXWoD7XNh5S53W0dfzbFyphjx5ttwnbKSztBGq+g+WqbxCk4AXc6Gdt0cTJde6bD
         C+40u45iyyOyzykml763RNE/rrAWcCLZcx27+EHzcXgIXfg6bfF82ZuaiCrOrmBLTXTu
         +0jrGUXUfB1hPzJyGw6+cEmKW10+63pUprWQTvMemtG6OpwnIHO9BETJGVWeAECh7WDk
         AVog==
X-Gm-Message-State: ANoB5pmWGxABnmsZOzUz3oVwuYNr8H7rODWkPgqIcAw+iwi7NAlR1rkb
        kp+OoVPoc/vCgHoHXUphVqHeUA==
X-Google-Smtp-Source: AA0mqf5yocX+4ApdK7akW1QcbVUUfuW5UBAkzXR+Z0PJ47ZOALkszIx0VsRXGgpXEmMo/Lt7kgMZqA==
X-Received: by 2002:a5d:8459:0:b0:6d9:7981:2a76 with SMTP id w25-20020a5d8459000000b006d979812a76mr2002971ior.0.1670889507013;
        Mon, 12 Dec 2022 15:58:27 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x8-20020a0566380ca800b00389d6a02740sm339748jad.157.2022.12.12.15.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:58:26 -0800 (PST)
Message-ID: <14a5ebc0-1a80-cc9f-d216-0c11b7defdb3@linuxfoundation.org>
Date:   Mon, 12 Dec 2022 16:58:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
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
References: <20221212130934.337225088@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 06:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

