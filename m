Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63E5BB4CE
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 01:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiIPXuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 19:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIPXuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 19:50:02 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927EF3AE40;
        Fri, 16 Sep 2022 16:50:01 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id g2so14083705qkk.1;
        Fri, 16 Sep 2022 16:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=oFxY0jVjO378ooGpIyQ8GCyfBIthqxc2ChN2Zjbp0uE=;
        b=cyjy7CTHDm1nhfPt0CzGwroHiCK9A8DIAhJ83St8mNgvYWcnaIx+L+PtICZgBb4kF0
         F9wJwUVA8FRM4s+FuJag3ey3LW+qDn6/rdjgStvpSgh6GhgSRqx+Qygu2otMIV3QKGsp
         pcLh7F2yl3t8U8OPj8w4UvdXiSjxypd90f7lhUS44RYr9AQWcXGZMfHqJYGeUawsYkrq
         8q71+9n4pPINONB3orFLiIJuPNQah00norDTRTDT54NnJvFNmQ5UUlSmpHjvFcuBGgOv
         3b3MlRga1MzQ06MX1Gp0N8qdqbgD3cGvMPrGPYNCaSfF6IxwxmhQwdv09OFXZkdjLtG9
         5Ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oFxY0jVjO378ooGpIyQ8GCyfBIthqxc2ChN2Zjbp0uE=;
        b=o+yvKy1eqWVQMxbBQ9llVwO4Xf9oISxqWd0hxhXpRDpVn0v4WOPoUAfs8l4Mvd2xvD
         jjSachP80rYsPlCs3V7Z1xMHWEFrchZkLHNqlYInCbaocu04JuWQOv3GBu5dn3IlEOGu
         BwEDBwEPwcpMf/U3w5334/bF/WVZnYKy1Xsoc1XJahzAGin6w75cvWNxRl9elLN6VMlu
         WVzPPjI+1CiZyk7wE/xS9LnXTqWF1R9P4Z1uMtziEqnRmOOXZuRm9JK4TDG6tWVwnKS3
         lkMLv+wtcX4DUZEvfxnbB869Jcgt8K9wemzZKAWMjolXHJ8ycgGFQiTs0uxD1i4eRmna
         er7g==
X-Gm-Message-State: ACrzQf0bzDjVgT6v7ANuEmYBcRoCqAfQXHyF/dMm8/nMwbRMwAmxGWjB
        hB82GjhYt+CoYbtZtGWO5Zw=
X-Google-Smtp-Source: AMsMyM6zhuZXNWXDcdHh0KtedTjvoEI1dVxOk8SxINxuCQJ+lw3q6csBaEntgh9Ud4X+CwDYhiXWOg==
X-Received: by 2002:ae9:c118:0:b0:6ce:33f9:c5ca with SMTP id z24-20020ae9c118000000b006ce33f9c5camr5901673qki.61.1663372200642;
        Fri, 16 Sep 2022 16:50:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k13-20020a05620a414d00b006c479acd82fsm8061719qko.7.2022.09.16.16.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 16:50:00 -0700 (PDT)
Message-ID: <6fab7362-50a1-07e6-f881-9c4e5592b0e2@gmail.com>
Date:   Fri, 16 Sep 2022 16:49:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 0/7] 4.9.329-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100440.995894282@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220916100440.995894282@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/2022 3:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.329 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.329-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

