Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A67D4F6E0B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbiDFWwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiDFWwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:52:10 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B43B20034E
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 15:50:12 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id k15so3062061ils.0
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HJBCefI8myvkV7QqgDDpUVtIKJjZbX/3glh4aMBj2Io=;
        b=h+cdaWXASY9gywq29DGmcHJoZZu4w82evaLpfFDdTtk3vMKDQ0hAytSKJmhhyr17/D
         rIsI2dhxYEnZlgRjCVdf3meuSBKQCjIxQ+NFC6k2Dxc27T57i+FhgQa4OMExnd7wVtaT
         s0GqxF2qpyB27SJov6+BbRCoyBdPaTr3diL3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJBCefI8myvkV7QqgDDpUVtIKJjZbX/3glh4aMBj2Io=;
        b=6KhTejNxip6cBKlOqGY6n1Oz91cPFmlRLpydZh4XCoMjHm5Eie5LmRr7rZwHbcaRvE
         PxwgXFWV3khnHmVWY/19/GXVwbEFVnBJ5xt0rbTnz42Slj007CHMVKUioZ+u2nQgNFAP
         kb4EHJ+QsY+55eoZLCzSnwmmpzVPPSTXudsrNhsVVlz7YFBZ0k31rsmB10Mp5tKzSvy0
         Vq5aVB5wMvzOjQv3IKYxXZa+YZNMOfKlScUh4eBSKHXkxP+fTUwdKHbyoO1R/OxfIKBF
         xh5g5e53APnnAAahIX/Lpn6/AfG6GanrwYR7pNnKxQzsWm+AB4uJfCsIpfQCjyjQVuH7
         /llQ==
X-Gm-Message-State: AOAM5311oA6PpeYwHzly3j+4SUiPLr5oKC3B3zLjWT3XH1bgda0czsHB
        SbF0EQ0kEW2I7DuEQqVq7Ngt6g==
X-Google-Smtp-Source: ABdhPJyWaPH02/pqQWKtOEi+t4CkGehHvBUZ/S4uaRObcAiKb8jqO6mRoYJD54yoEn8XaGY513SM6g==
X-Received: by 2002:a05:6e02:164b:b0:2ca:255e:acf1 with SMTP id v11-20020a056e02164b00b002ca255eacf1mr5474861ilu.243.1649285411861;
        Wed, 06 Apr 2022 15:50:11 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id t6-20020a6b0906000000b0064963285af2sm11285969ioi.51.2022.04.06.15.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 15:50:11 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220406133055.820319940@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <62c6b184-8a47-cf25-b33e-63513fd6ee2f@linuxfoundation.org>
Date:   Wed, 6 Apr 2022 16:50:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 7:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
