Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C11558A21
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 22:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiFWUdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 16:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiFWUdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 16:33:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6488756C2E;
        Thu, 23 Jun 2022 13:33:15 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h192so503007pgc.4;
        Thu, 23 Jun 2022 13:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w23RnL0MG69XH39swGxFcKbyh7umLn9nbhUM7KLjBk0=;
        b=n4LhguLYJE2+f9i478TcS/a1x8SyDXUVWazNsjNKFq0z1HnnmWFvUXOiu2f5Q0E3+f
         wnu+Fw6nPzBrizADiZ3psacVfwkmrFGyp1B39f8XC5b/9+wYJB4fwoW4mtpDtXQmhqDP
         R+YyQesqeMEML3NNsaupXj9M6RHlXblmKkaYdUPGf7yXeAEJ/lwbFoXqtfCeN8sm4vwf
         bXyBqFPMycQWUMFe2soi9jyQEL5Qf8X8q6oE47Eav2P8oR+D+OyRtxNIKOVndG25quTE
         xJKKe06/3abG5MbsMTeJVfjSHb7Buzmz1u5FNTe7WpLi+gWiaJhG5q0Ou6QWiMIdgat4
         FZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w23RnL0MG69XH39swGxFcKbyh7umLn9nbhUM7KLjBk0=;
        b=yS+U23n81n7SB9h7lMUS0EqyHug5iwqiW2uFcDfq2wYnX6o5zmegjdKXC0POyIdJqZ
         lRim7EF7CVKcumARIs+jFI2YFsGN3XfbOl/Jqwuyt78Alfwt9kP5nSRD2AVW9YOkiObr
         /1VDKMVMAD6bwRw5E0cHTBZYKOoB3PMlJc3rBgitqN0lUBm+aP+twEqrjfEbwujV7dOy
         dDO5lvz4prz/afbHr1dlEXmcSg65/zyceJx+0gYaB/BOYqXbQW6dChH4pWlXNaiNzDRw
         pw/RDMAxEKzzoIrK/Oc0900wH7+qOd5a6dh8IbXmtI1J6TM62emBRA/0RhBq/WTy12Hq
         Kf7Q==
X-Gm-Message-State: AJIora/uaYkDRQCjdLb9nTwAjbqn412gwfFqeCr8nY7eLck6ukxDIMjy
        VW1kwEJwUW82D6mf7rWdYSc=
X-Google-Smtp-Source: AGRyM1ty+75b1RoOvfJkdQlEsZBsgaqREtIDcbyEw3HqTKOg8gnxuTRqGmxU+k87MMCGpqduL3oJmA==
X-Received: by 2002:a65:42cc:0:b0:3a9:f71f:33f9 with SMTP id l12-20020a6542cc000000b003a9f71f33f9mr8843708pgp.391.1656016394500;
        Thu, 23 Jun 2022 13:33:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q26-20020aa7983a000000b0051b95c76752sm54966pfl.153.2022.06.23.13.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 13:33:14 -0700 (PDT)
Message-ID: <ba78d475-085a-5a00-ae1d-33f066ebb002@gmail.com>
Date:   Thu, 23 Jun 2022 13:33:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220623164322.315085512@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
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

On 6/23/22 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
