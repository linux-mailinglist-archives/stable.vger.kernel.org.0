Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A069858C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBOU2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBOU2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:28:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D821F924;
        Wed, 15 Feb 2023 12:28:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gd1so8629534pjb.1;
        Wed, 15 Feb 2023 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCF0rShrhjTZo+vj/lM4nPombRJwd5wcu/hQkQwVY84=;
        b=c2p5Krc70fvqhISDXFNzyaE5N6FxoPIdUBrzskIjfAgdw7PFPikWZjqL1dFIR648bh
         FRvsx7cpoVo7B4ne5ApyWokvYH3K/BeQoq7a6lzlL9/BpwL02XHBrByZv8p/7YzLvD2A
         oPcX4RJN+CobB7Pf1OA9GwJRfVLfJOG28RAk2YslI+pAxHb1yfUxUFVTehJcjWBTmDsh
         48fmZbh3rRHVnUb/XRaT8/6MjtShZtrxhU2uiIK0yk17Bvr7471+icgu91/eIGH35nYO
         Wm01vrqEUEjRpoc/RqMoa69kLnzkwcfShOsP3LkpgHU+eTWKIxX+7wRoI4WwRgsgVtK1
         x6sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCF0rShrhjTZo+vj/lM4nPombRJwd5wcu/hQkQwVY84=;
        b=jFg1KxQNOdpy2S4PObhHm59/dzPBEq4qnwwF4s6ittIoq9v6AWMkKuLt9INskE83WV
         WJ09zqhEwz+ZUWQ8LitcZus1s8HbBhwC1XiHoSMTQ2WtAqouLNICQkOjG0y8yU+9ofuI
         eBUQ+1jKAMRk2w6Uxd7lIt7lkkMHzXUYwzr9ojjG3UBJw229sm7v1d6iBFhvPGTJsH5v
         knBvAS1mt+eESvZszr0cFaInuGC4ww0wU4+pkwQwEZ686kWHNvl4XL07Br7cAhQ88lnN
         oYIpZR/SzMd53llBFviPll/p6Tq8/HGUFCGt0P5kHCgcXFtX4CQhxrLzlVxEzQ7UIWyX
         xxZg==
X-Gm-Message-State: AO0yUKU31F1FN0A5S7Z7BCIN9Fw+MUdI9BzEad0hvyKVTFQJOlY8fmQ7
        MCGav/sUyowf6twzi2DiFLA=
X-Google-Smtp-Source: AK7set/5mlHCZ1a8WvZxsf5np8fWLUT0k4t+PtpGK2rLJWs1iplHzlICGCdFH6Fg2mXvhMt2AStaoA==
X-Received: by 2002:a17:902:e882:b0:199:2a4f:be84 with SMTP id w2-20020a170902e88200b001992a4fbe84mr3903580plg.58.1676492895516;
        Wed, 15 Feb 2023 12:28:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ik6-20020a170902ab0600b00192a04bc620sm8608294plb.295.2023.02.15.12.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 12:28:14 -0800 (PST)
Message-ID: <3937ce28-e15d-1d40-caf4-b35ad6d5b0fa@gmail.com>
Date:   Wed, 15 Feb 2023 12:28:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230214172549.450713187@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

