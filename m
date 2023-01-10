Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EAE664CA8
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjAJTiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjAJTiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:38:25 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AB65C936;
        Tue, 10 Jan 2023 11:38:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id s3so7146015pfd.12;
        Tue, 10 Jan 2023 11:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoXD1OgyDYyTbjMw5dZ27r0qsE54dNiVyR8gm0rBom4=;
        b=SqXTCPwXJaDBdJJ2vWjcG1x9BYAe16IKAL5ViJ81Hybj9qnfN5eyxVIp94ZbY4Yate
         pxYV9wvMU2GXxVLuMbpeHnRMQ5XPlzDLJUn0A3P6S5PzqQ19QICJudVwvepJYtfI1EOO
         D4YU1k6nyVwOUuWpU4uR48xQyUBmmtGriodRzhc3mJMaOpEn1sMxlP/XVaIBxBukNW8V
         9vOVkbvAz0yMN4dq+1b9I7ayu0M4ppvs3CTuztJHs6My3NBb9U0iWQqaJCnzqbep+AHD
         ecB2I7Q60gKxpBP0Oc56I3t9InrtRgnjOw0qDg5mOVCSaocftLY5MSbcw26p2hwLzFEx
         wbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoXD1OgyDYyTbjMw5dZ27r0qsE54dNiVyR8gm0rBom4=;
        b=Tw32PDVKHaFsBvGeYgXsCd7FBQitZgZucw/T0rKfTB+F37ETt7oJQDTO63SKqOmGZW
         8KoukELlM/4yyrAI0HUDJDW2IlJss+ME1L+ok09zlucMJHJCYS+59yJ9Yh3v0rAf//Ww
         7xlBkO+ywVnj+KJqTK/b4NqkwLQhNIXrNlQOT/P8Fxdu6vLt18Xp0C3R5h9pAuc38E8j
         xtKbdWuzx5TgT4kpYr9gIYiB7tdZOSfU15KJIzp6zmo+d8Nwzzs8NbIbPE8Hkt1z+09/
         VJviHhHzewlBArFQ5BsqaabWS3wZMchAJEozBG9dfoocRCYxd3SxArfldc35qGAp+Ix2
         4TkA==
X-Gm-Message-State: AFqh2kquHJ4NvVF3vAFOvdq/KDJDbZLZu+j1fwKAPFYiZEPL+LQmSXrl
        Z/JFfgCc/sAkKstIBJNm2cc=
X-Google-Smtp-Source: AMrXdXsvKpBkQP/Od7HHJU5VOgqPMYAGSeav3H7/IcIUTcgNPcmJ1eVdqHWnXNYBwQ2/NNTsIHoV4A==
X-Received: by 2002:aa7:8a42:0:b0:582:34f2:20f1 with SMTP id n2-20020aa78a42000000b0058234f220f1mr36105975pfa.11.1673379500566;
        Tue, 10 Jan 2023 11:38:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b6-20020a62cf06000000b005624e2e0508sm8417588pfg.207.2023.01.10.11.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 11:38:19 -0800 (PST)
Message-ID: <1db853f8-cd98-2814-a643-8cff16886d07@gmail.com>
Date:   Tue, 10 Jan 2023 11:38:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180018.288460217@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
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

On 1/10/23 10:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

