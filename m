Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE455C902
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiF0Q1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 12:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiF0Q1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 12:27:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2209514011;
        Mon, 27 Jun 2022 09:27:13 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so3719819pjj.3;
        Mon, 27 Jun 2022 09:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M/jiK65MJNBTTvDfqpZjs1o0n8V0o+GQzgJREDZBMZk=;
        b=TJWjv4imHr191sTGgJnPW/DZn9c1Mhf2zZ0pyHEZh7RZevqLdWKLzsKnqNtdAIl3Ze
         eVEJsq6jhPTImGZoVxp+wCIyAj+XiFy0jo0t7XbdJfJIGL4pTr5btxuWBWSWMVyldZ9f
         4NvDnCsjs2s1ec4FMIv0QWqWWnKvuf68hXVxDuBgig9aCpLYIrtz+N840XWBG/XLRUgu
         2QWWSngIGt7j6rugF1/h/Q8UJSW5OZMeHXJZeucwpmElVQdN1DtkASMHIs39vMWR7i4x
         UbOn/7qTqzU2qMMs1wVj/6ztdB1A454r82Dw7rluEVul9EA/xf5+X1GBDHojRCfUCMp0
         0Nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M/jiK65MJNBTTvDfqpZjs1o0n8V0o+GQzgJREDZBMZk=;
        b=y1dCIpUhnVH1/dcZHJ/o+OBICdXS0/+TMnAgT68WFARaVsN7I0YWt4rO3PNUPGDJNw
         Cuzh2+jyrPYuXc8QPTax1pEJY8E8OBHB+MamYLizacDfRMkhg1882TIIFwS30IIKCGht
         xjDsSIdW/zsuGUzDJ0OrdAyAoV060+KOVkv5QEmlLJxOBvVkijHax7M8R9aFa85OIPuk
         lpGVNM6acf92VpaSB4IAk1L+KKaassq9s91JVfGLtC+lWHYB+2K2v5lGxJxNnky99XOA
         RYmV2dCjOT3yhHv8eedaX60r0N7Nl+t6lrrF9hN8cz+1JHZ89sHtci6TrYPInrj7VmQ9
         bYkg==
X-Gm-Message-State: AJIora/cdAb5wrM5VMcQW80VGwKgFVQ/frtxZfBYbaHjyvzbr/emwLMo
        IVa51Jgn36Y/S5MS3mIQ4Lg=
X-Google-Smtp-Source: AGRyM1t3cm326tzurFtbCBA7e5oEJJFxK+30rHNSYRFaGU0C+f6oFQGVy1AOHOMrBMx9iJLi95GxyQ==
X-Received: by 2002:a17:90a:9384:b0:1ec:a506:df30 with SMTP id q4-20020a17090a938400b001eca506df30mr17132866pjo.110.1656347232582;
        Mon, 27 Jun 2022 09:27:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v11-20020a1709028d8b00b0016a4f3ca2b5sm7435155plo.277.2022.06.27.09.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 09:27:12 -0700 (PDT)
Message-ID: <f6aab617-d75a-72c5-acfb-318e83e77ddd@gmail.com>
Date:   Mon, 27 Jun 2022 09:27:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220627111927.641837068@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
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

On 6/27/22 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

There is however a section warning generated:

WARNING: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section 
mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit 
to the function .init.text:drm_fb_helper_modinit()
The symbol drm_fb_helper_modinit is exported and annotated __init
Fix this by removing the __init annotation of drm_fb_helper_modinit or 
drop the export.
-- 
Florian
