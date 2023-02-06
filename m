Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDEA68C623
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 19:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBFSwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 13:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFSwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 13:52:41 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82537193FB;
        Mon,  6 Feb 2023 10:52:39 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id g7so13981627qto.11;
        Mon, 06 Feb 2023 10:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C2BVvWwJDpl1vnxID9lKGhlHkyXd2wpAzBHIvBEypFI=;
        b=NU5yP0net479efL90aEMdAry1GtUGTtcnIM+V5VWpf3OnvalwRYyiB3WTq3O+2sa0L
         XAfGImxrig945/HunVQx7wMltHs65iFwGt45xht0BtLReW7lLZOozULK6AxNtabIXQJW
         tCa08cEvtGwLfzBL5KHo9FpbW8JNWeWag913WGGyvmSL3gml4uwXx0MBBv57JoT02gu2
         6jon78fvEzFm1AztyVKoljbyDXq/RGhYkcjR/Fq5YBdQTuIoNHwhX7P+6GHgkdPJZ95L
         4SuKl5Sz4J4iQy0dRNy8ZCrG80xIfTBnjI+zLfwCdpNzlW79QdmOwnaw0TiYoIGRWINp
         H3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2BVvWwJDpl1vnxID9lKGhlHkyXd2wpAzBHIvBEypFI=;
        b=IS+VhWM5R9GKfDWhkRj7wor359U4wQuS0dLJ34f9tw7+5mlUWzsMSh9HE4IOkpBxWo
         yXI8fXXzYg8ExW+b4wQv+yTby3l7yFU3tIXVHO4X0prYInpwCobgytevtgSvxKUOue+v
         tp+8t24ewNMFTt+OtzeBYiapWXZEYU2kawi1Kf8gkq3neLGebdXr0c4W4aCZp4CajUXg
         9mmauYmGi9NQ8HCuT8SNg/Jz8Ept6VcXG960+BueAw45jYcfqyWPjLTVc5fxqQbRh2t8
         k9QtHtJP5I/Mk426NU346dUzYnS30lw/DCoDgO82kcN2b+hhYAq+VQczikEN2kFk67f6
         nSyw==
X-Gm-Message-State: AO0yUKUIRyMb65R86Z0tM5YMMCRG7JGhd5J8ZDbJG82TAhcuFMwilCFl
        WsLir1CZPedwK1ZtJeS2AvM=
X-Google-Smtp-Source: AK7set+NwTyimLUxjlb0jM54xus9V5kklM8Yuwc3DdZL7VVI0c9IYWu9x8AuDMdOH4fl4MNWe0mA2A==
X-Received: by 2002:ac8:5dcf:0:b0:3b9:b1eb:ad38 with SMTP id e15-20020ac85dcf000000b003b9b1ebad38mr516760qtx.50.1675709558533;
        Mon, 06 Feb 2023 10:52:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ed4-20020a05620a490400b007195af894e7sm7841310qkb.76.2023.02.06.10.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:52:37 -0800 (PST)
Message-ID: <d79aa5f7-23d6-342c-83ec-3badaf111096@gmail.com>
Date:   Mon, 6 Feb 2023 10:52:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230204143608.813973353@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230204143608.813973353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/23 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

