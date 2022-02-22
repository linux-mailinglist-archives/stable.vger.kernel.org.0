Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9864BF0EA
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiBVE2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 23:28:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiBVE2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 23:28:20 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60743DD4;
        Mon, 21 Feb 2022 20:16:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso1145160pjb.2;
        Mon, 21 Feb 2022 20:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jfpIxD+KaSxv34lCCZ7aGFYTW+mlXLrR33Q8/YJDPXU=;
        b=LLoj9ApbW1rK97Utau+BEqp7Gw/fM4YAbkRx+VbHphRdnVH+ImQqz/mDSqer03Cz2E
         8/W3tQ6ThiGcFlYQiArF0Wx3vy8/3RnIHu0TuSAWOPYwGHzjitnX0z/9Hc7jjLDf5Yvg
         kWJYwqqgswjs6L8yaUjWgRLhyGja1rCDYeD5rmR4jeTz1Ad/FPGhOxoZps1VxExcCjkI
         FuGIcCmbgE6Enzn5d0z16XLz/UIvBcWmdzG4ErqrVlV/JdrfJFgKknTQFGNJ4yF854aO
         I9S1zwioYKGyYhm58oYgH+MICcPwEiuoFG5G3phF14nU2M0dfoOrJZnU0jIpfOZrh89t
         sIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jfpIxD+KaSxv34lCCZ7aGFYTW+mlXLrR33Q8/YJDPXU=;
        b=uKDQtMh1bwAFq55Dx0eAU5b+z/FG/hsl8oWFlVxjouvMKSxPuEdMMYjOVjas4iZ7e8
         4w9MICHKjAeSO7datGhFHPnE129a1OoHuEh2VDssOGsHHN6/btN9BJ/1DBg2OMuDKgeG
         rHPGx53NoXEy1XSSo13SQw75KaGghs/zY4LJWJ1963oQdzWlqVQl26+enFcH48xv8uMp
         Q1FVkA3uE9/d56IK82oV0WtKDxbOg4MOOBzHYAsZAEsysedlP3I4RLx6+b6OeSt66TWB
         BMALlgLAQqCdKjDShsvLZ46CBvSxswEILpbXkNdoXS4Ux+uSFxYQVG52D0jONj2AbJas
         cZxA==
X-Gm-Message-State: AOAM5308+v6ZeFIiS+QYSfwcteOxCKJLIab5uUXfpZm3S2vrXPj+Ll+c
        umUEc8Ym2E7eHenMpdbFCsY=
X-Google-Smtp-Source: ABdhPJyixELDka3l4WzPf7E0NF+9RRLFI/QRCOwYue85b6HVL/dTKPIuRQiLjJTBr+Dmbm0ql+5D8g==
X-Received: by 2002:a17:902:7b8d:b0:14b:8884:b4ad with SMTP id w13-20020a1709027b8d00b0014b8884b4admr21405863pll.120.1645503418833;
        Mon, 21 Feb 2022 20:16:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q1sm14053775pfs.112.2022.02.21.20.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 20:16:58 -0800 (PST)
Message-ID: <c5bf7fa4-fb7a-8b20-1a78-64be2266c008@gmail.com>
Date:   Mon, 21 Feb 2022 20:16:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084934.836145070@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
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



On 2/21/2022 12:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
