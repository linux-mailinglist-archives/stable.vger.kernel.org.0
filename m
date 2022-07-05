Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F158E56761F
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGESFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiGESFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:05:05 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA7E2D;
        Tue,  5 Jul 2022 11:05:03 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n10so9295656qkn.10;
        Tue, 05 Jul 2022 11:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RDGxknCK3Bu0rdr+aOilg6e0CsRw1PhYNqzuZfhAF2k=;
        b=gwomkPhqoEwqbzrhlQReIcF0q5lZu8bsQRvSxI98mydKzv5zNh0EegF4IggYNiQQyc
         Tm6A8UpQHf96Te45ywkdT/Dv0rNHI+8L7/07EuvS+bPNZVjXeRojrpKxEC6YSE6NHzt8
         M13GyZ55wlmcYLlPwTQ6H+3GtOFd50qSKmYzf+5F8gDte2kiNw9UfUQ6X+KuywCfpndY
         KntN+stdn0GGqiWfbIqa0b12uNPmcqqBXnWpRSmWsJE4D0CtKMtxKPnnHDISM/WuU0/K
         c/OxwHpM2uc3xt0ZPH9zM/UDNgHNMKrTL4feT0cR6+n+5aWGhWt+s694U8yYWqfY0w+h
         l4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RDGxknCK3Bu0rdr+aOilg6e0CsRw1PhYNqzuZfhAF2k=;
        b=x+rd/aREddKWYVdYByr+2UrewJw8UpXhzO+BUOqigJGUuTnK8EyQK6MGDXVyzaVn2O
         A5Qq+BYxYfMMYGSrmb9as3rDq9Z6C3bknjRAURWpFaNa4H0OvfCWQXodYVenTfrA+/kU
         k/jhOJTDmBYFY66f9GnHTYQ2GlQcf/RFPPM5qSAI46RsbAmm/nPxXRv4UrBvuxhVrVNT
         GrM1RlGn6OKe1hhoUzMnLobm8uteyV5nRvXPffgVqLqJuOEQoyNu9M0kLNPl95i3yOZP
         yVt+pQHoVj4TIOCHEbfR3Dvajw25SGpNa8hky35RWuCuvLZWH1Ph05j6YrFtLjFEJZUe
         bHOg==
X-Gm-Message-State: AJIora/Tra0Iu7pee482MXDaJYO/uTA6JKXDipXXt7NCRUtMSPL+90x+
        nGwfEsmOBZDdyTzmSSX0Ftk=
X-Google-Smtp-Source: AGRyM1uH10r6CbayMt5xBDE8/MzxDRuwHDQeX3MjCLxiasS+0NqngTAli0FUSW7C4AeZhrEcI6elSQ==
X-Received: by 2002:a37:a85:0:b0:6af:ab2:9d1e with SMTP id 127-20020a370a85000000b006af0ab29d1emr23801934qkk.695.1657044302643;
        Tue, 05 Jul 2022 11:05:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fy20-20020a05622a5a1400b0031ab9d1d6c1sm4956851qtb.74.2022.07.05.11.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 11:05:02 -0700 (PDT)
Message-ID: <54199447-e476-4029-5c46-a32bfb4838b2@gmail.com>
Date:   Tue, 5 Jul 2022 11:04:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220705115615.323395630@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
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

On 7/5/22 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.129-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
