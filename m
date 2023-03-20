Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CADC6C23AF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 22:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCTVaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 17:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCTVao (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 17:30:44 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675243A4D0;
        Mon, 20 Mar 2023 14:30:07 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id i24so14939197qtm.6;
        Mon, 20 Mar 2023 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679347746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X93KBQButTn/UqXt/hbJcsk9R9gKpKY/fTpIsiX1hTM=;
        b=HwbAEz6acm8IVBY/IESRBoXatSQDEglMeeYGw+dzBihhMkJMu39LQJDbk2Y4EBL8d/
         rycDDMvisOpn1DgKOmmgzSaC0Gi8U2B7BQ0qT9g8AOcJMzyR1c0Q3bBcicmt00d9UT1s
         o6Vjf361XY+YdsVUhBnjQ+YJF6OI5QPo4dXrFjgcoLfdw1jzTJ37yCluGS6Fk4t8tw8X
         MMnY32m7Z5IhqOo9ndhuHsFvnLnYKCE+MhoXVWgk+AIDMiLOhq7yD1aYQOydEuse72vt
         QZvzBBb8IhCI3nUqGNLs7680oKI1R6g/wWM/Q+vxuD9F8NWEm4FEajLTmKfBm9Ebz6nm
         SwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679347746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X93KBQButTn/UqXt/hbJcsk9R9gKpKY/fTpIsiX1hTM=;
        b=XCn+voDACxntP08s50u/F0qC7pbKyu5cvaahyD6pb/EYHT1LX2Nc3zxGzxdVrhLDeH
         e4YmIs91cvOGIvAXM/1fPTEWSI/BLeDXrydlEcL/+n50hmZ2TyeO2cGLhBRJP67UHXfK
         h+7VqwXaDrYnKZE7zHNAXFJX0TOsp0ekcI5gAAALmJEYE5DAR3KMeEPJaMCs0qWBpgXt
         xEG7D5OSlrRNwLZKv4nVH1pFx1iKqpRPJSy15L+JIDqCtjFIHv+5S9qo1r+ASwg1daFX
         b+k9lGDMyLUwFgYuan0p90prhZs3w22QUGRCJRwLvVx+cpt97WqJ7WiQLptCVGY9YWnN
         diCw==
X-Gm-Message-State: AO0yUKVOZ7dYXEcAAH8Ls9+FtB8ZO9weLTTg7/xzGhYCHGNe4U6cF0nN
        3WA/PdsbMf2+X0tA6vqw6Zs=
X-Google-Smtp-Source: AK7set8rJ9Onu3EI1D6eakF/aDbRe3xLFMDE+q7Gy7ZuIhHQ/R+8MqaVQGxn39OUHHZiVMX5vwzvOQ==
X-Received: by 2002:a05:622a:86:b0:3bd:140c:91f7 with SMTP id o6-20020a05622a008600b003bd140c91f7mr944095qtw.40.1679347746060;
        Mon, 20 Mar 2023 14:29:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b6-20020ac87546000000b003d29e23e214sm7074186qtr.82.2023.03.20.14.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 14:29:05 -0700 (PDT)
Message-ID: <1946b64b-23a6-7357-0125-2986abd6f84b@gmail.com>
Date:   Mon, 20 Mar 2023 14:28:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145513.305686421@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
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

On 3/20/23 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

