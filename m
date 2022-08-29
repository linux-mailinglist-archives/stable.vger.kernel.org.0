Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75335A53C5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiH2SI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 14:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiH2SI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 14:08:56 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667929A69D;
        Mon, 29 Aug 2022 11:08:54 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id f9so3251376qvw.11;
        Mon, 29 Aug 2022 11:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=gGq+deMz270tnEWl6wH8JezG1EwchVeq4/WCswdrxxQ=;
        b=nW2H68kg6NzNVJL0xmqzRV4nZRGpzI3s7v2HsmfI3FkDVeijUr722oYbhb5xEnRAiH
         xb4TWYrAnY8tAlwg+GnzIixAW3WqIR8CXRIn5F/qG1aMgDYHy3EqarKPQMYKhz7u8JCo
         T+4Bxj2pyYVHzzI2IV3PTnvm2h82aTBDoGWxlezReBqDPcc7DtoI2s5XlEKkxFf54whZ
         Femgp1bRVxQ6vmEjEqAqg5lqodlLZNSVFCEo6RVIhX8rUaK5H4Dwt5isDKm77wrN9mw/
         sfnfuMNWXbfFr4tlzS3w+9XOHkxLn9Jdipm11/npOqg6tymE2CgzUDSjJaRQGMKUm5To
         CTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=gGq+deMz270tnEWl6wH8JezG1EwchVeq4/WCswdrxxQ=;
        b=tz9Unis1dVfRtNqShU4xiCHJ62UsC4XeIQEoAONesL96Fw/GnkFz9+OTwxQVToiOmO
         dKP2Ehbbj+tPSPqtwzLm/cZUSYMOgfVftyMQS7bV8gwe/U+MJOK0aacrMFmm01anIogs
         +EEy8llkTFs4YzHMVf5kT84dNAn8ieHJMcGBvhQUGC0U2J3XbDn7s80eSgKE40HtOJvu
         egmOCawMBfOlu7lQEk7xxJoHVPZPRw5ivwImxB86LxaZKCE3ZEs4rcAK5wGJqV8xHD1U
         do9S41KdCfd3s6I/KSeKEkk2rgP3lHCYZ9YQsXaIWxQJV26DJcN60nQoW9H32dG+y7Cb
         MKNw==
X-Gm-Message-State: ACgBeo13hEKOABtakBbxUwYszyxXhCNlaqsahlFlfQqVV6eyqGYK9P8N
        hlKClUqSvNQcQ+DA1FukxRA=
X-Google-Smtp-Source: AA6agR6NFx9ldpsbzMhN89Y0I0mHvUPay/JV2bGIOkkFojDDUF1xleFlfYcS7ntlH/AeG9dZvJ0MAw==
X-Received: by 2002:ad4:5dc5:0:b0:499:d93:df65 with SMTP id m5-20020ad45dc5000000b004990d93df65mr894205qvh.109.1661796533515;
        Mon, 29 Aug 2022 11:08:53 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id az11-20020a05620a170b00b006bbd0ae9c05sm6630839qkb.130.2022.08.29.11.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 11:08:52 -0700 (PDT)
Message-ID: <d63a86a0-616c-d6b4-b85c-f4372d0a8590@gmail.com>
Date:   Mon, 29 Aug 2022 11:08:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220829105808.828227973@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/29/2022 3:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
