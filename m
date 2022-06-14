Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F654A764
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354703AbiFNDJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353416AbiFNDH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:07:57 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1F62E9C0
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:07:41 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-10113b4c2b5so9251227fac.6
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GXOYZjgOGlYZmM3krLWrwVNX3Ic/GEe5e1RnpV2w/50=;
        b=JiyZ+3oV93mA1TC4AYkUY4XcUw6du2obnEtOFyxyjuXsp8DNZTX7J0SIUwzZN7AVkr
         dDLrb9oribLcVeHV0YVEjYBgHB/zUOBMEScsVbGhaeJfDmApkg02Gdae7JiHrG8f1VCn
         MCYraML3mp+1a3pIwrKlTO3HzhEdUR7M7XHp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GXOYZjgOGlYZmM3krLWrwVNX3Ic/GEe5e1RnpV2w/50=;
        b=u4kcS4nmAPk+MCmzk0HfsO9b6gk6SWggdR5w3XGfoH45iJ6RC+ppqqmhUUcmCgs9ou
         KQOkII6EWkm4NBeWvVyp0T+lEoJq/97PYf/zSFSfJx2hEi07lF/AZsEl7zaGH+00mqFi
         Jjax2bbRtxfpY9VlqxxqHWp0yRmzCgo01iet1LeGokfNDFSTKeG5KDH3yn9qw3NY/Now
         UMQ6Rzty6spnMMlCNsW6HCnsvZ7kpuqzkMWGCFskbK684HhPGVVG4e1fS46dhpAae4nz
         tW+YEYPSrbNlH9f50AX/8Jmh9wRVub0PCAQrZSzsS8w15BdgjtZ17wab6ujTsaLxHmeO
         kc8Q==
X-Gm-Message-State: AJIora/XajEOtqVZuvCxSJA8Emr5AjY2SRlgcf1aFv6p6d7fvCEDGKsz
        78jdN0jh9BzslTgHuMDpSxA1nQ==
X-Google-Smtp-Source: AGRyM1t+ixAriondZWmCcuJN5detabI177UOmWHP2kiAfhDwm0WBftzLGV/F5qTCaHbD33SMZupAig==
X-Received: by 2002:a05:6870:889c:b0:f2:57f0:b7ef with SMTP id m28-20020a056870889c00b000f257f0b7efmr1131063oam.243.1655176061105;
        Mon, 13 Jun 2022 20:07:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p19-20020a056830131300b0060bf2cf2a8dsm4235035otq.14.2022.06.13.20.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 20:07:40 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/173] 5.10.122-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220613181850.655683495@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <efa3f43f-aae7-7ca2-95a5-88ebc0cc818f@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 21:07:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 12:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.122-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
