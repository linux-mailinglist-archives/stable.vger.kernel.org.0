Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A753F5AB824
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 20:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiIBS2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIBS2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 14:28:45 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AC8110DBB;
        Fri,  2 Sep 2022 11:28:44 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id f14so2442312qkm.0;
        Fri, 02 Sep 2022 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=C7n7jfdbJFI5Vm0yNWU5Z8SS+ha0I414B1SOkH7t1Zw=;
        b=JgIx0TtrujVvuv6Ybn/45+xAsZwIV9ZysjvT8jcrSQkH02pGwLdYHthruF3dDZnVq2
         ZzCIIvVU/PJ7u4QE0gu3Iolaf24pTeV9pVjI0WzfLgstgYdS/OWkXxv/R9afpQBRE0t5
         G8zipqCZwmMKqakVawwIjBqFbfmTNy1lJTg7fRK9B6oO/HcoOu9ocGwnRvH1qHZi3UjR
         KXtUvPjd3o7yxn4oZELMk7/a5fUxtuvujbu/1rPUCZI6Qwfe+Z2WJPDZR+2pY5AfVnkW
         yQuwVuT/5Pi9CDCZxHtaghZ2NWimqSAU1wo3j1Te6cJ6k/uWeXmABmAPESXNRa/6oVIl
         TQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=C7n7jfdbJFI5Vm0yNWU5Z8SS+ha0I414B1SOkH7t1Zw=;
        b=ATXszTrYCp7fFaXBk3QYZcq0BnKyL/wkISEtKvp18Am0lT0JyxJDZUHoBVSK4TFLHY
         JF4Eq1qAk9VPlILy+3Al4/VmCjFuHMD7tCFo5onqQYK5YLHzB7BRR7M6sxufwdidc4jw
         H18aSfY/aHmQHqphyDAltTTjyTs67FiVUHcc1i0gW04Fiu7u+Xm6PXJe7cTA4L8+cxwy
         qT3VWgJR3tExuhb1ZMmxWyIWmwyyUJX/FUhxd7e6cMU0KLD3VCOwP7BjinTpK2hsl76h
         4TbL+DmhouLv3Q1oXa5rFOQ1lwjAhPMAVajmRXMTDxcp1FAndjb+lqISX0DQm67nIfKB
         JJXQ==
X-Gm-Message-State: ACgBeo0fdW3ahmC25SeIDrUPRIiUnLQWXiteyqCVETOZUUuIUteC8I32
        3uVj7FKhA3CUiZX7OzYK/t4=
X-Google-Smtp-Source: AA6agR4TOSEeBjzFmpb7Pq+0rou1pako/N5GECa6GzR6sl52ULOJWWa5WNvZH2d9YFthKimG75eCTw==
X-Received: by 2002:a37:2d07:0:b0:6bc:1512:9868 with SMTP id t7-20020a372d07000000b006bc15129868mr24670155qkh.433.1662143323398;
        Fri, 02 Sep 2022 11:28:43 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fp5-20020a05622a508500b0031e9ab4e4cesm1411048qtb.26.2022.09.02.11.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 11:28:42 -0700 (PDT)
Message-ID: <db7fa466-00cf-f0f3-7427-7f213c3e4594@gmail.com>
Date:   Fri, 2 Sep 2022 11:28:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220902121404.772492078@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
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



On 9/2/2022 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
