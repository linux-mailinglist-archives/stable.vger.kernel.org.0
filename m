Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB91554BFC7
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345522AbiFOCr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345406AbiFOCrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:47:23 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988584EA25
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:47:22 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v4so3297155oiv.1
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jff6ZH02jJBQwtYlY7RoO8ETnlixa0XGME+E3MjWg7o=;
        b=dO1InnttTBAsuSQbUR9QVlsiHpSEoN4CF5EeaPJxSTdCKYT5bhMitswmnt3DAWLsFA
         z19RJS9fGMsJCJbKMUniqV3VjA79E3gjjOiu6YKyVpvDTiP1VeUt8UIfQ3oIMN7VGGui
         THs+fnedNeyRQzyU4sa9wpc3fTxlxyZcXCuXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jff6ZH02jJBQwtYlY7RoO8ETnlixa0XGME+E3MjWg7o=;
        b=cQQOpUnLhKWoXwJEdovO06h8alv5Uyq9khzIWwor0XKaNhke+2uOAZc6zfGsSag7Ay
         eCTXKcPrZeajU8eLD5WW4DTJjl83uxlStunTae5pQs55hrjRFPAx391IGS6C1lM0tKSl
         o30Fuds0rCFhJ3dSRHLveiEjNHuri7a4RPXuugcdwXwK0w97U/9iiyOSbjWrwAT6uXyE
         roKTMNhLvG692T8DHM3GIwCTyNV045MG37kubDCZxAAdvGQ17dMaBuobV6JI3P1Rrkzg
         lbiA8xLhvdg1jV6bpydcoqz/jXuPpOZZmIZMDL6XK4KKeQdbdMoWS+AMUchXQEVJefYx
         SAQw==
X-Gm-Message-State: AOAM533v+PIs68JmDEbfbw9c4WWjiVnNuD2GCjEdZy/ZV5YPmoVenB9X
        Choxl2IttL3pLyYRsPEVMNLW5Q==
X-Google-Smtp-Source: ABdhPJzRH2zVZV9on7Skus/karfp+jjOVaVkOdhx//TyMMkjoiJenLIGIB2K0xsdcVRLpLhgovbc5g==
X-Received: by 2002:a05:6808:e87:b0:32e:4789:d2c with SMTP id k7-20020a0568080e8700b0032e47890d2cmr3613464oil.193.1655261241753;
        Tue, 14 Jun 2022 19:47:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id go13-20020a056870da0d00b000f324b1e645sm6388540oab.22.2022.06.14.19.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:47:21 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183720.512073672@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <02ce9b69-45eb-2561-56ad-d80189f5efa3@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:47:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
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
