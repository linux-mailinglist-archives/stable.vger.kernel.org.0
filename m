Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E2E6BBCF0
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCOTHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCOTHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:07:40 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B66725B80;
        Wed, 15 Mar 2023 12:07:39 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id y10so17412262qtj.2;
        Wed, 15 Mar 2023 12:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678907258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wZ0/zvOMdFiNo5uPOMOj+D7ZIX4bpE2IJFKlYivIZk0=;
        b=Ct7Q0t12NaUwy+6LgJEcxRSgnz0UJT51Vbym5LRMAXXrj0ByrUwbZPBpGQitY4Lmmr
         noLg/gXxspqX42LQM39zoZh9R/lzLps2cKcu8gK055aQe7vGo3fDC+q1BOdw3xHcTtj/
         d+5kLqqqTpVopV9Alv62scMm3WjUdw9XLG/Sv8M1ZNufyHtvUM+xHi6DDp/g7GibddPg
         ZbJMRl2Jnl6zZKcaKerZdD0TywJjIhWeZod+/M962ycZnB3fhNTdV4CgEHO7FyrZzRHj
         xtH8VHv1ZVLzTpJzksqWhUdy/n3Jz8bPe58qz2TvzaegzG0J83aZ2/fEN7YDpZ3DTdoT
         SsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678907258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ0/zvOMdFiNo5uPOMOj+D7ZIX4bpE2IJFKlYivIZk0=;
        b=GtPdFrgaI33b/GI5NgU9/EQAx1LQFeEghOFpSP2mNdJKLbHj+kB4s6nnrJrOhArd0E
         Wmuh10bcIQf5j9QkuCkvwhcWX5OAClK5pcmVQsxeXBNDgnuhKRxkkGPnTRCyKwzJ6itI
         0ApLT5Y+uO0XOZ0zDrYNgAlV3S4FuJeZwyyN+rPvodJ+zKj4IVaJ36kg2gXYxoT2UcRt
         Enxx55nIR5nWsBX7wEViYDvaibTyM/1pFEGQ+QVQwNmUmciM3YboT2HwJqDncMWA01UN
         ytR46G8wq/0zT4dvCOB+jzt4IQrW+AHpGx0YLQ2UDAugN97mK11Hw7aXRwctbpeJ4ATd
         nPnQ==
X-Gm-Message-State: AO0yUKUX58U1yOdZzxrcXwUFHvwEo81Msyqlcm93GPDiJbjg5c9MhCKm
        9Xqx/uyiR19zNWlSsUNoSis=
X-Google-Smtp-Source: AK7set8QJkutBm83311/qDFwLT9le+gtecQs+6Z/VnXQHJ6QunJlnDoWxtDKDLfrXOb1ByrbcI4+IQ==
X-Received: by 2002:a05:622a:1:b0:3b9:bf7f:66ff with SMTP id x1-20020a05622a000100b003b9bf7f66ffmr1223839qtw.67.1678907258344;
        Wed, 15 Mar 2023 12:07:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cp4-20020a05622a420400b003bfb0ea8094sm4103899qtb.83.2023.03.15.12.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 12:07:37 -0700 (PDT)
Message-ID: <2ff0d13e-ed75-6b89-1aad-6e45f7a6a00c@gmail.com>
Date:   Wed, 15 Mar 2023 12:07:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115726.103942885@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
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

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

