Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809D4553E22
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353230AbiFUVtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355950AbiFUVtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:49:25 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0879240A0
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:49:23 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id bd16so18774077oib.6
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AciGOMHSo91l/zULa32RoyGu1yMCXURr99BEX1ZS+sM=;
        b=dPXrT3ZKojAszoujc7NafFBfBOa/VjzbPoKS5UvHzsEYh00FMQK0QVuef3SWC8Rhk4
         jzdJesbno2GqYu3shYIRVuzo7LCfV2IRXCEtYiKPFueNSKGi/WLbhBAegiFis3yDPUsG
         z9jpS/OnOzzlzMJ3o+2lXe7AcoJQg7rVpGAAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AciGOMHSo91l/zULa32RoyGu1yMCXURr99BEX1ZS+sM=;
        b=PvqDd33Xi/6dQtnh+IWWfkAYTSWXXgw/f9h8ZdAKO18tJjhpW/rsessXPRI8J9+vA0
         EUyIQl3t+CHmeuKjOkPz+BT9eSPW0NrHdG65U16zN2iw46M8/4DXzudm13f8B886bwOD
         xnLCuL1gnFT+aGRJyFhRShFwzj7It0uKpcamrlB8QHzaj67YUhQFVXUNCWBJ04yCz0km
         sX7nBgvlkN5C6/coFhfXJHMSLL2YwRP0HuaSYbe+WY8Hyf4PjJfg9oURD498sKF3uaG3
         ComZENSAxIueIUKbPhECmMGibaj7iU4GsBj3nOXj7SErPU886axMmqEQ3YyRmEIqbip0
         TYJg==
X-Gm-Message-State: AOAM5306/tnqWXaJYml9VWXHpbtQhOKpgQB1q7A/15VB/x2PiGeXlRhC
        6+b52j8sAbvi3nQCN0zXATrpAg==
X-Google-Smtp-Source: ABdhPJwF5cOKO8iIZcA/os0vQYnZRwVFwxFG35Y9JZtOCbBHHdgd6Zmx7EdD256fFH4z9TQ2Z1+3TA==
X-Received: by 2002:a05:6808:2d6:b0:32f:7da:60b9 with SMTP id a22-20020a05680802d600b0032f07da60b9mr20789175oid.249.1655848162762;
        Tue, 21 Jun 2022 14:49:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q9-20020a0568080ec900b0032f7605d1a3sm10181915oiv.31.2022.06.21.14.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 14:49:22 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <63d8620d-04f2-82a5-622c-57f007902319@linuxfoundation.org>
Date:   Tue, 21 Jun 2022 15:49:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/22 6:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
