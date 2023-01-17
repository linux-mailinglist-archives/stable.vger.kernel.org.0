Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B9366E824
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 22:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjAQVIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 16:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAQVGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 16:06:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8046C56B;
        Tue, 17 Jan 2023 11:32:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z3so85359pfb.2;
        Tue, 17 Jan 2023 11:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DlLQTdoKsOZVDNxk9NL/UbvvDxhujJxGzQgZNmNgx0U=;
        b=JXBX8KVj4Ffl+KJEJrfPsUrsxZRLXQkhl1iFB291/nmaQpGG1GOlYLFoGiRJIhDaeR
         qq8s1vRb486jdTWKcvdRaKpDZy9w1PPqEHiXITMCeNqDPpV6CLycsms2aVn4ec6E5epu
         2RTR5zNLfSikRyLyWBTv4OktwynBGLLlZhyoUoZNuV2oS7P4e7bheeAP9F7nHzqaDXfk
         nHbjiLVn08yOEn37yKdX0LkTtcUJHgBxbjca9aoFUnfrWjX4q1feq6x35Xx4pUUUXYbU
         xj7LmyCuyyKTWE9VXiAWKVCz/r5Ecc6dvpXGyP89Ts4gxj1Hndm5TMQDEz/tuFtHteO4
         rEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlLQTdoKsOZVDNxk9NL/UbvvDxhujJxGzQgZNmNgx0U=;
        b=QGc2vaNfxEaN+68mOydzKy8HsVusb82ly3YvHtke7zSdcO+OqLCEkmHScsB6bZktPX
         MRADl8fbvL2wrKVFcMjTgBMxyzURnXW4ojVK1eShuqKsFbJGNtxB96dVgc9ZawaP5/iT
         aODEN9WotfbFyqRbd6NtX5S8SveXScCqeEBjawtiVa444s8ICLsaQ/DkG5+eUPHqXXWx
         oDWf1EDHLM0dXagv7ygZa8HHpMiGX+9hRuzzlwbnmVvt7Q3L3ZJaOagb7HqxBY+Tcvsb
         FMA3PI3HPKojALUlCapbPlkSyyTpJwPtg3MQy0E57TBlspHX8Bma3bUqyb1slpxvNiSK
         fUnQ==
X-Gm-Message-State: AFqh2kqsHEPxirFnKMVBgrrwPLJQTD53LjRTiXCcRKorFtWVlMFx7YAk
        OMSgnzHSvCbs5lSr2resJ7o=
X-Google-Smtp-Source: AMrXdXtNKpWN7uz3qBQ+i7AEsePVao3aNrWvFpHQCQ0As59xfpRQeXFe0p6yqjitcWqnqXzVGe45hQ==
X-Received: by 2002:a62:7b11:0:b0:586:e399:9cd4 with SMTP id w17-20020a627b11000000b00586e3999cd4mr25691538pfc.25.1673983935820;
        Tue, 17 Jan 2023 11:32:15 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h18-20020aa796d2000000b0058dbb5c5038sm3124010pfq.182.2023.01.17.11.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 11:32:15 -0800 (PST)
Message-ID: <b19210c0-bfc7-f601-c8b3-4b4e263c9cd0@gmail.com>
Date:   Tue, 17 Jan 2023 11:32:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124648.308618956@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.229-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
