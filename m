Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1176D563C
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 03:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjDDBqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 21:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDDBqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 21:46:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A918FB8;
        Mon,  3 Apr 2023 18:46:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ml21so7073388pjb.4;
        Mon, 03 Apr 2023 18:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680572768; x=1683164768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKc+EYx7SwEU6/Vyls1s2GPepAFxHA/QgAomLsWmEzI=;
        b=KVhv0/uzhPIcfjRUIbVX/qmG88E8gr8GAfn7UA5ccwrxjmTtnFNeEenhB1ynKvv9/+
         aT0RnSdTEB+pAUFqnFFiTDjXhDaJW+9I+1VX0PmkODRazjswWQpRelBWbla2ZRTEg7a5
         C4K6VB2WFem20bDLNRZEoiPNcCTaQJqwFh2pMz6nLPyyO14nyh14Y1uvr+MY7EBpZHE6
         WpY/RHiGugQ7Xp3wVRQ9eM/kI5pkmFBgqoNouDb41eJxWXtFOBXGguxdYPn+RpnYjHzd
         a6ZxR08qsfh22yTr+lNLRzY9VAWkw/JdoEmkX6pEloOREsIC5gVaEkuCPnjRs+zafa+h
         X8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680572768; x=1683164768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKc+EYx7SwEU6/Vyls1s2GPepAFxHA/QgAomLsWmEzI=;
        b=3PVIEm7WSUpH+E5trpYaXofHcQaLmcLQvaz/63jeMUtMcQLxvKM9uP4ktNx0xy0m5E
         hR0qLmDbv/P8HLv1vJG/Y97y4GvpR4kcrM+uiZvFdx6KRv5ZA0G5nWkGpHTHDiZp3lfM
         7u49dXn19wRcuNKXp/QpqA1ACgkQJIvsyrC04GE1vfiQNmqRLHMpMS+iRIk9rvAvyygG
         uMg0g6C31r2zkVUmLuMbOKQ/FQwnsimiRz7oMwufgjdp0qO6uJ9f8E8jRIii2EtQxpAX
         NVF67fBaWv07Rw4WTF5eWS/cxtQznhY0VhAMENIVrzC+Q6HmBQRYhJLIP3lHrUYWJH7N
         ItCg==
X-Gm-Message-State: AAQBX9cKtxrzjOciwO572G+BWj0HkgvoM00/3q/liLbk6XBlZUQ/lnbH
        cxJRxyL3tOsSOFyI+BDJF9M=
X-Google-Smtp-Source: AKy350YloTfDcwXsjgzsf/hxAZHDhEOEPl7uvuNDiA/ljjv3lzuY6HBD85oP6HUWQSFKkiV5u9IHCA==
X-Received: by 2002:a17:903:2803:b0:1a2:7d:17f2 with SMTP id kp3-20020a170903280300b001a2007d17f2mr788467plb.69.1680572768004;
        Mon, 03 Apr 2023 18:46:08 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902834c00b0019ac9c4f32esm7138071pln.309.2023.04.03.18.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 18:46:07 -0700 (PDT)
Message-ID: <213a416f-3182-a4a6-7640-c8a385d91d68@gmail.com>
Date:   Mon, 3 Apr 2023 18:46:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140414.174516815@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/3/2023 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
