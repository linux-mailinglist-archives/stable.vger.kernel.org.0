Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57159EE93
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiHWWD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiHWWDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:03:55 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344C513D36
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:03:51 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id u5-20020a4a5705000000b0044b34c2c89cso611526ooa.9
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=XgjUPoYbteTJSFK5trDNYbEc67FboLDVoKN4OKyAxFY=;
        b=Ku+Fu5Ayvzh0zXpjv8bDVq7swHTjr+TJGPKsq+lEMz+7ZYeBAxqd07lU/wuRywMQ4X
         w3RgjBk+yNDGrXStDgUMS/z51pOy8xtmqKzaETzMCpYlpoYguYVCMSF4ZHe6P5pBJ51I
         dnFSyv4czrvGNEvyNQ5kkhbiNIKZkvnkZEyco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=XgjUPoYbteTJSFK5trDNYbEc67FboLDVoKN4OKyAxFY=;
        b=JAHAw90kUk7PhJ4RSFMIoSFvZsx6Iv57CjcPCNPqsDSE6FCVuSW/OZJcmXJx4uhrhO
         uvbBgI2ahBb2lIvK2HXDPzXZTrAS1S+Lsztb9/AkxwqnSRooEO6uDCblXxrTCs7M66SB
         EYnfMlfpn2zBG/kjZFeyL2sh1jBJ9/j8cX1n0GaezhNUBMI0mclBIZF3Qbz9UFf/YYu5
         iTywfhCdPbXbZOuAowPPA23OtSpZ1nsAq7oEBVs5svayu+ObDvMkKc+SUK0ZAWQchHU3
         bZDhHgSdwW0G+VO6Zv3JxGCYO9kWNJlJH8GDJud9GjtZQQ4tp3/cDhzNJm9UP+RRBsR6
         PmXA==
X-Gm-Message-State: ACgBeo2AmLbbF2N88NiPZw6tMdD0jrPB8YbZWTtW49EMdqKJcdekeU+x
        oCh6lDEK9GdHMF3OyCx+M3mt7g==
X-Google-Smtp-Source: AA6agR6iV5XjigRyxhI6uHsO6B5njoDoDy81UG2PpWj9kgaLmMQy49Ld+mYJWcKi2CYP7+uMIqmOaw==
X-Received: by 2002:a4a:abcf:0:b0:428:47bc:4bc0 with SMTP id o15-20020a4aabcf000000b0042847bc4bc0mr8700404oon.15.1661292230823;
        Tue, 23 Aug 2022 15:03:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x10-20020a4ae78a000000b00443abbc1f3csm2727169oov.24.2022.08.23.15.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 15:03:50 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/389] 5.4.211-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c99b635a-dc6d-e8f2-5255-136e4f3b0e94@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 16:03:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 2:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.211 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.211-rc1.gz
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
