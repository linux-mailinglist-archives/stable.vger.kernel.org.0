Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB9C623278
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 19:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiKISdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 13:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiKISdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 13:33:03 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E171F61E;
        Wed,  9 Nov 2022 10:33:03 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id mi9so12870041qvb.8;
        Wed, 09 Nov 2022 10:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMY7PupaY7AZJjDpU6LlRsSZwx2BK6otcOqvPzvh8zI=;
        b=HalMxlAJq4g4Sfsn6Fa0+SPtqdbL7YjWjVMQ+bOPuGWhhi/TIWdK6eD4KAHxW46Xil
         hXI0SOcPYPzlgVBVWY7VmHWm8rJ/M/eHHPWG4/ZIVtOO1yfQMp1Ljp/9LijIk9SyD8z1
         kssi1QU2S+ggTdpjvnfU+fum1viU9REywIgc7yESWLCK5yVj1cDLNtsIlOh7hPfkU9Mz
         ej9OPWvt0C6HsPwFAhuYLH2TDX+2RqUCylAO4KvWPwzMylx+jRiOFRP+vSpJQK+hOnen
         nsYfq6P5bsD7X28/26op6khhvHiC8kBGxyPA2QNzFDzHggHKahZpCA5clNH2iJjDlbuE
         6ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMY7PupaY7AZJjDpU6LlRsSZwx2BK6otcOqvPzvh8zI=;
        b=cLeFdOKXPLbL4wH2v44Yj3U10i1lkW5IRqinZSoH0D3mgD1dn36f5AvHJglGHqI3lH
         hF3iWEwyfrUSVCAP2koIeMZiaf2idrl/o3+ncMSsQi07lakvo02RVmqn7XwG3b+bBjPZ
         Qxccu1OR9iNzMuzfhBZdLAXd50ZQoYxf0K35MOeLu1WRsAlC6c3SL1nHObJaKHQu14HS
         PxefxKD1JC+K+K3IApYFYaldN++EM8wfVujdtXW48E8+ISLhxKib4QEchHgET7oy78t8
         OqxdIBME6jDdG/X4isjneOT+w1wMG7v3r9sLQxo1QiWL+SQ+oZ6eoHKD3H9csqyYG00l
         t0mw==
X-Gm-Message-State: ACrzQf1ewh/+iI3fgCHNVr0xUqK7uQ50ShHFEi+YQNA9i17G4OydPvn2
        hobxbGTVKf0in0D7+R9S8vc=
X-Google-Smtp-Source: AMsMyM7izbtZBEaCtvBqW1849eyHVHe6zFq4aajTAz/1C6e4+RnYKL5+rBgUBMwQat+Pz1t3emfvDg==
X-Received: by 2002:a05:6214:ac7:b0:4bb:61e7:18eb with SMTP id g7-20020a0562140ac700b004bb61e718ebmr55694952qvi.55.1668018782275;
        Wed, 09 Nov 2022 10:33:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bt12-20020ac8690c000000b003999d25e772sm10117236qtb.71.2022.11.09.10.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:33:01 -0800 (PST)
Message-ID: <1279d213-93bb-6faa-5697-f56d6d8aa293@gmail.com>
Date:   Wed, 9 Nov 2022 10:32:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221109082223.141145957@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
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

On 11/9/22 00:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

