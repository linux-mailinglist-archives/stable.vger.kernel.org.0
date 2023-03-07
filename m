Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474366AFA0C
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 00:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjCGXG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 18:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCGXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 18:06:27 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1815650D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 15:06:25 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-176e43eb199so6802263fac.7
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 15:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678230385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i4NnWmVrfipQoeKXWkdNzmEKC40JzLC7LeWlUBU0CRQ=;
        b=VnifkjUvxJV3d4n82jTit8gSkclzz5I7Et4zjBwcehfib/+6KB+8dzIHYfRRj6Akgv
         v1WkxSp6lmmC+dwXz5yKAIUpz+8aNUh5c1UIy2qbbduuYfXuUkIm/3FiJcauJ2hLzNg5
         1jtCqbRACTbd5ZlBzy0saJXDIlDvDvnZ7vqFQNj5RtqBWnHWkBU1/K9gXP8hQkMgsPFa
         CS3vgcN0X9AWxSjKkHLGfL8u7Kn6C/Tc3Dr5djiIA1vCkMoFyCjMk2V3XNmm5WLRmtVS
         iRFIpAa2exC9dPUvQpJrzYzJxxO37q7oEHAsVQ8SSWhU05B8AnATN0AaVY3WDDZqk15x
         6gAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678230385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i4NnWmVrfipQoeKXWkdNzmEKC40JzLC7LeWlUBU0CRQ=;
        b=h61XjJq1wkmJL4T5QSt+iz5FfiCTluEpVY+s7ew9ceMmwBAF/myoDMz6e94ArXgrh8
         3dEEAAubDz3/dAyjTx3eHTMn9njnLpEpC4nPRz69Hc2L9FY1U6aaurOiXIrk69XgHLby
         dBuK0J/UA4+cJqCR1J4sUWjgqLFkq77g8LvK2loIjEshg9ytlybhGOhcD4om+BjoTmh7
         jdU2zeokzYbmzQHXlUbgToS8jNmhoNpQ0syS2JxGO5UBawmC1CU5WXwdm84NOLPmov5J
         h/42qKLvbGXZZlgAN5fxX1r0MhxhyJF6U/reda4Yd0jWWC/c0B0ppQoX2AoAk1DeVh5V
         e/nQ==
X-Gm-Message-State: AO0yUKWbQURnM2foZT/0KFQwf69Y3Bp2aUL4CLyhZ33N5Q3/fOX5bBtD
        EvqsK+GMFXvjXp8cxQLmAg513g==
X-Google-Smtp-Source: AK7set+aO4+g18qWuChV6ZR6WBv6Bi9+GAkzIIOEQeQMh5eeRdeq1qv4OJjhpO9Y7aPNO8nKhDkwvQ==
X-Received: by 2002:a05:6870:524b:b0:176:438b:a8e2 with SMTP id o11-20020a056870524b00b00176438ba8e2mr11514872oai.33.1678230385189;
        Tue, 07 Mar 2023 15:06:25 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id v3-20020a4aad83000000b00524faf3d2d7sm5429603oom.41.2023.03.07.15.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 15:06:24 -0800 (PST)
Message-ID: <c1bc24d9-0977-4d7e-bee8-aa897b1cb435@linaro.org>
Date:   Tue, 7 Mar 2023 17:06:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230307165905.838066027@linuxfoundation.org>
Content-Language: en-US
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 07/03/23 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see Perf failing to compile on: arm, arm64, i386, x86_64, under OpenEmbedded (GCC 11.3) when building for the following machines:
* Dragonboard 410c (arm64)
* Dragonboard 845c (arm64)
* Juno (arm64)
* X15 (arm)
* intel-core2-32 (i386)
* intel-corei7-64 (x86_64)

Error:
-----8<-----
util/intel-pt-decoder/intel-pt-decoder.c: In function 'intel_pt_eptw_lookahead_cb':
util/intel-pt-decoder/intel-pt-decoder.c:1445:7: error: 'INTEL_PT_CFE' undeclared (first use in this function); did you mean 'INTEL_PT_CBR'?
  1445 |  case INTEL_PT_CFE:
       |       ^~~~~~~~~~~~
       |       INTEL_PT_CBR
util/intel-pt-decoder/intel-pt-decoder.c:1445:7: note: each undeclared identifier is reported only once for each function it appears in
util/intel-pt-decoder/intel-pt-decoder.c:1446:7: error: 'INTEL_PT_CFE_IP' undeclared (first use in this function); did you mean 'INTEL_PT_BEP_IP'?
  1446 |  case INTEL_PT_CFE_IP:
       |       ^~~~~~~~~~~~~~~
       |       INTEL_PT_BEP_IP
util/intel-pt-decoder/intel-pt-decoder.c:1447:7: error: 'INTEL_PT_EVD' undeclared (first use in this function); did you mean 'INTEL_PT_OVF'?
  1447 |  case INTEL_PT_EVD:
       |       ^~~~~~~~~~~~
       |       INTEL_PT_OVF
----->8-----

Additionally, we see this same problem outside of OpenEmbedded but only on arm (32-bits), because in all other cases it fails to build at an earlier point with the already reported problem of init_disassemble_info() [1][2], so it's very likely to be there too on all architectures.

[1] https://lore.kernel.org/all/CAEUSe7-vBpHrbEy+eQrNZ_LTeqHpn2eQEr3C7cmfNYjK1YL4Ww@mail.gmail.com/
[2] https://lore.kernel.org/all/e6e2df31-6327-f2ad-3049-0cbfa214ae5c@hauke-m.de/

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

