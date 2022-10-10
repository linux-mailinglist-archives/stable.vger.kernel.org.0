Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4A5FA6F6
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJJV0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJJV0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:26:47 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCCA79EF6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:26:46 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id u2so6256431ilv.6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kj9reFj5aI50/lHWSijSywvPGIlf31oEQtSJms9AQ/M=;
        b=QaqnSslSeoTiw/dBolEmvcXAOXiOyLZ/DcxQKHqaxHEt9btYkDdtNFBk5RE6KFUVHj
         35a2B8D0IfvqUFRLa3mf804b8csiNdntl4f0Vv++PG7pQ5SrH/b55FIBCd45PwD2b5Qi
         mm0vB16qHRQyAVluPfb3tUypIAUOaTQkR6hrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kj9reFj5aI50/lHWSijSywvPGIlf31oEQtSJms9AQ/M=;
        b=CTbmgi1w7FpA3Q5cjlP14P3hOzVeDkVt8jwtLUEIc7Kh9pITraDsGgxrzZ6sZefxT9
         lcrvaa9fbVo6MxT56paq4zWdgZ9VAWhkEcqc8a0t6Rs0uxqNGhDKMe+SaaSupd2hcszl
         iOEOak5DBypg3EphbgUO/l9n7gzKI0F1nZeN4avE5ReKfzigSx6rKws2S8QOYC/EJ+2L
         DCuXZnQVDdQM3ZIrmNy+rb6YuCr7ZG4J7s9Ss4DIV3/d+Whlt3CLEuhiUwMNGyhrO6A6
         uaSvPe1MtpbTcYuk7LDjC9rcCjKbvLqn+2DL7/OuEZCFKRLcMz525dQL7LbKBYCARiTK
         dzCA==
X-Gm-Message-State: ACrzQf33WI7C6z96SsjVCew275Pce/PVUGVQkbNkJ78k7RDAJTfzzXtt
        o0FHhNhMhKYMvfaiTxJcGPPGKg==
X-Google-Smtp-Source: AMsMyM5mJ5Vq5x0kRgjsD3rT5YVr5ORr5L+2oZJ/RHZgwkfccKw5x8TLYm2XoB6dSnBPb1fwl4kVfg==
X-Received: by 2002:a05:6e02:1be7:b0:2f9:b795:e298 with SMTP id y7-20020a056e021be700b002f9b795e298mr10891294ilv.117.1665437205629;
        Mon, 10 Oct 2022 14:26:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i132-20020a6bb88a000000b006bbf0466587sm3035148iof.49.2022.10.10.14.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 14:26:44 -0700 (PDT)
Message-ID: <f991162e-7839-7878-dc2a-78fc5810eb5a@linuxfoundation.org>
Date:   Mon, 10 Oct 2022 15:26:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 01:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
