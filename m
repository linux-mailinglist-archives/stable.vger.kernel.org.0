Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1186B5FF9
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 20:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCKTEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 14:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjCKTEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 14:04:38 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C7961AA0;
        Sat, 11 Mar 2023 11:04:36 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id r16so9346138qtx.9;
        Sat, 11 Mar 2023 11:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678561476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fnvGap3bZNSv+sB+kLpIELEU6ix0YkzCIcb65Gg4LUc=;
        b=CyNQ3xGcn2or2jno/8rbuV8XXVK8RbZAnnUdTtSR7FjCl3V5szrjhI377Pz4Wtew4K
         4S0Ij+MX45gWCiJvErBSLZ/X/+W4VWm2x+pSBfwsE1K2fnRp/6xdHzJitGpMtgkw1Rk0
         N35zZ/sADLGn1/9PBLVxA66Sij5zKidQvBvXpKHciJqA7VPC8rgoQMk9BwXEpxNSRmXm
         dsNZgum/2DdMQRAVS3SBF+Toi5MFDY21KBi+dFzkGlWcRtHrs2yOZONNk7d9mTka3JsD
         QfhWWGzUOjsVY8hzQ++7nSc+uShJ9onbCaLRIk8pd/npscPZEZcQ0FY24KgnfacRBh3T
         ao6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678561476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnvGap3bZNSv+sB+kLpIELEU6ix0YkzCIcb65Gg4LUc=;
        b=JvGTxFYmO/mMkYbMts+iTqEAl2nKur/8INTqKOOivdbIXPUFPNVjc03h3crS3Endvh
         TMJKYR2cGhI3a7MxQIxXjMAU6lj4rcQIgyt6OW+fA9YzgaqN6tF8wSig8rKI2b+JlCu4
         QhIp6rhTsYkpc+K9svdij1FpQH/98PznffWDWCGIZXAqHxchGr0rBo79PerQBuT4ZEWk
         6HLp8HJS6Zs2DJ3RhiY5ZkPb4JtVWLKtWiDCCrb/6U3/8jnAWWDdG5nwLMXDFeWrLuXu
         ap2V/jqqdct5o4xT+gVnpdIYIyT0pQdlzxLCalQ+lIitA8rA07FIcOPnXA+m9hJHIT+m
         CXUA==
X-Gm-Message-State: AO0yUKW9k2dx7stgSnG4Y6n4B4W9lGSMhqq4s0H6G91F79dOGYDcBZ9H
        ywyeVbhXYb8VIESKn+p8bvoJASgBXfY=
X-Google-Smtp-Source: AK7set8my+8yHmODiFJavWlaRUMaP4V/y7Lvl5C5GdCXGtsBwwK8FifsiEJyI3bfRd8vps8E8+zVsA==
X-Received: by 2002:a05:622a:281:b0:3b9:bc8c:c215 with SMTP id z1-20020a05622a028100b003b9bc8cc215mr9101123qtw.32.1678561476017;
        Sat, 11 Mar 2023 11:04:36 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e21-20020ac85995000000b003bfc2d5ddb7sm2340297qte.73.2023.03.11.11.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 11:04:35 -0800 (PST)
Message-ID: <fc5a38a8-60b3-62d5-95cd-6b1500f3f122@gmail.com>
Date:   Sat, 11 Mar 2023 11:04:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230311091908.975813595@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/11/2023 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
