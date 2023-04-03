Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429576D5516
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 01:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDCXFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 19:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjDCXFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 19:05:24 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3388C107
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 16:05:23 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id n11so3017877ilj.9
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680563122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXRkIAwOhh0DOERhIHsGnDuRshRJI4hCQwRzFdUHWdM=;
        b=HRpsXW1tkv3ps98LKNcUhkLE2CVELOFCRA+/OtzmgWal/v1xQiVRuCaL/14LZzQak/
         OpVv1PA6ELtL5o52hZ4aa+XgH5LXFllsS1/wgOXDSoFcv2MF2qlx4L9gDe9Et7bHUGot
         UYqqTJYmZdNainnjFjf9aoxihwP268RaUKMug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680563122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXRkIAwOhh0DOERhIHsGnDuRshRJI4hCQwRzFdUHWdM=;
        b=pN4F6YHrYQt/nksuIjztNvp8Oy/rHdZcKdf5fQT95Cndwo0Wf+tXMygmdjYHd7qg+I
         ZagYKzKB8Vk76U1T9IEwWqIU6J7YumiprQUT5asQ2XiMAAIROMialkgF6lks0xfJrFAK
         ItIJds//3XNFyAu/arbbOWGjeQfYGr+20GlnAs/Ubmb4PHnfc+BkxBpezSlb9E87qGpu
         umeZvExG6oNe/H3Jp/4w5xawoOFDTVON2ieBoAZ3uuWkX0n+oj6bISFRYv4uS1+iLsKK
         U9rH7hkyHgS6oOni9s4VN8uIMRKiMP9t275RvPWg1LdO/CY4Zf6Uf4yYpYHYQPzKxXbd
         C1uA==
X-Gm-Message-State: AAQBX9f/oTdiuYCkH4C0lJkk3OTLGsN+z3D3gO/73S/JZ5xeu88jR7p+
        3KiJmohXXbYQ0B6xFcpvXJ9e2g==
X-Google-Smtp-Source: AKy350anHs0avJWNmXs7CgV6UZeVLq+7pE418WRtr/9WgLNknu0x79yhjkx+G16XMpzZOC9WXpjIQA==
X-Received: by 2002:a92:7108:0:b0:323:504:cff6 with SMTP id m8-20020a927108000000b003230504cff6mr419783ilc.3.1680563122567;
        Mon, 03 Apr 2023 16:05:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ch24-20020a0566383e9800b003a958f51423sm2945082jab.167.2023.04.03.16.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 16:05:22 -0700 (PDT)
Message-ID: <646952b1-4d52-dc5b-6e8f-83ca6c99ee13@linuxfoundation.org>
Date:   Mon, 3 Apr 2023 17:05:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
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
References: <20230403140403.549815164@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
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
