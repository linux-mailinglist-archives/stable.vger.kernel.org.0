Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01AB522325
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 19:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343670AbiEJRyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 13:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348430AbiEJRy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 13:54:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A844A2A0A51;
        Tue, 10 May 2022 10:50:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2787407pjq.2;
        Tue, 10 May 2022 10:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SL+3kZQSymIuY6Sv2yjNu/Jrfavvd+SrTWjiXXxHp/A=;
        b=OVG6yz5tN35i8g1xtRjAJjxhTUq37pumiwJFKZBiwq8cD5nzdxA5pB7pM/IUegaAy+
         Az+6gfAiCCgWVFXIoRh2Tgpaxg+bF71cquRenT8WSQtV1TJi+IEgw0jdYsnJAIb215fM
         VqTJg98UAZZf3PfTtiYZt7J98HOAUKvezjHJ5XA4MN9d96zsfBVCxQSjEceo7PR2z5uh
         9B1Pbil2DSWaSgW25rWNw6Zpll+3KnaDEruf07bziFEjbvU12j7pb0gp344AiRSpVxwt
         vh4NmRnPvWooeCPOiLgOgD2E0gSUPA70Bte+jVYBGmL1qt2ZmdQcuxlIvb508huYbTRY
         2IDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SL+3kZQSymIuY6Sv2yjNu/Jrfavvd+SrTWjiXXxHp/A=;
        b=aI6jDahYPmejsNVW6VgXDO/aa1BdSGed7T8f61jd/n7hfqTHmFsDyHJRmNPjRRgp5v
         KCJZ8Sipc9qIZfaoo82en+aPUxNcga23nGQFGQtOWu6vqHQ5BWQwyDM2ou7oNgpWm17p
         owNSSprDAS3ZwQMcXV8WleOHUsCDGBRjjUOlbAgYXAKQl1qChqiA4gQaB6gpApGWuHq/
         V5O2d0EA+4DJW+xdAHtPNU7rFNLoAPq5qWDWRgdGaJJKwD3/zXB6ROYJ2lSzPXnNC1Gy
         JDYkaD3Gjl8bgVX6uJ8c7HrLOVhtH/3X79D8SYwP7Lu5q6aJWUgTcfNTcXRuo7WtZF3U
         mqAQ==
X-Gm-Message-State: AOAM53265IqAXOILLMiNZlYZ50OcdsKFL1vB1OoM+wqftTAmvzSifJym
        w9xnBRmURTqiXDMH2Ggzwkw=
X-Google-Smtp-Source: ABdhPJwDMwPXxGsFXuIgIiu3zRgJju2/puIYwz9rMCwDLqNERscDJYAugIv/qqREvuboooAfg1e/Kw==
X-Received: by 2002:a17:90a:2e83:b0:1da:3273:53ab with SMTP id r3-20020a17090a2e8300b001da327353abmr1084287pjd.14.1652205024722;
        Tue, 10 May 2022 10:50:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y16-20020a62f250000000b0050dc76281b4sm11380472pfl.142.2022.05.10.10.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:50:23 -0700 (PDT)
Message-ID: <811527ed-c9fc-b964-61bf-28a96ded56de@gmail.com>
Date:   Tue, 10 May 2022 10:50:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220510130740.392653815@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 06:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
