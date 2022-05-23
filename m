Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794B053169F
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbiEWSpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 14:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244147AbiEWSnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 14:43:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45401A29DD;
        Mon, 23 May 2022 11:25:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h186so14372508pgc.3;
        Mon, 23 May 2022 11:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P47JAwPQpYZWJx3NuocPik+FecZ6O5gWjmmUCHKFYOw=;
        b=Z4yQan/GQw/nRnKNwImMglfRAZ553d4P+FJ7bGqHCm+D/Ubt+4fPjmQGXS63ECFjH1
         sjm6mMlXB8jHhhrUXTDgBKIQ+/GXkgtE2PJsH/mqTzMiiyu8oo96Kz4+GoIFmUo8/KVG
         wFwNiX2YBbUrn1JYw4/zWZm62HZ6Gyo1Nb1D9NH5YoXaVYVGhwWdbHEZFENF9R0F/EQL
         DEBiBApt7UZzB/Mdk9urry57bC7+Tu/tw8oqyc2+06P72hNcs1dCVq7zmnCUr8UX8Tni
         gJeEYM//Kp8SrmdgoJmwYL9vbtvU5ZuIBY13D/Xuxno7u2bXMQfZMlle2WBl6qxvoGsh
         v1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P47JAwPQpYZWJx3NuocPik+FecZ6O5gWjmmUCHKFYOw=;
        b=dfAn28oE9x4FBhk0UAvTaf7Az637Bxx8PPaDooEX2a8iB1g36Vk6UaDrLbWPsXRXgw
         6fASRoMZvdbjmSzoJj1nZpPehK9r1m2FLlKxwuwyoJKarLpYiwcJw9bw5jq86nqAUZNa
         fgZ71N3tibHshfl9pvkptf6jYDDu85SJe53ApBzjT0Nt9H3Tf+5YZrDUZV/Fd+YsVWit
         ZGUi7Bsidkwt2Wwgx8Q1uKSpsmA1Jpi8zfkXyJ8xo/+7jCLaWSrWGNfUp05McC25btc2
         38UiraF4NpcbRCrhgP5aKtJk0eFxBGI31Q5wc5VWBt3XIhmSEx3VbXFiyUH1QuuViwAI
         vTsg==
X-Gm-Message-State: AOAM533y6muqnkee+uzlpKtcGoEb1+ZxIr4UYV+pnr9Y17N6Jtq0V3bF
        JWF0a67qWSpFa91UUTiXq0k=
X-Google-Smtp-Source: ABdhPJywkV4NBFZtSXwlopIItBNekeVzcF+EtxiS5RrLN25OH5BBNGp0YnhAXBJFEnsZE4r/BlSsrA==
X-Received: by 2002:a63:2406:0:b0:3f6:2513:5c63 with SMTP id k6-20020a632406000000b003f625135c63mr21006392pgk.550.1653330311924;
        Mon, 23 May 2022 11:25:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ki18-20020a17090ae91200b001dcf8960a13sm743pjb.40.2022.05.23.11.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:25:11 -0700 (PDT)
Message-ID: <f8ea5c75-5cb6-6dfe-bf3c-45ec01ccaf38@gmail.com>
Date:   Mon, 23 May 2022 11:25:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220523165812.244140613@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 10:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
