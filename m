Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B534E3442
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiCUX2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiCUX2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:28:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C238F3C4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:24:42 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id q11so18503649iod.6
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=el7X0/I9BxVvXyltPGgPKnaWWzQR127MIa0+mKXEO7c=;
        b=RjRgYceVtreHHGPV6SDBdpbGC/2X996EYXsQrsFBgA0PF0UJsNDwk7KLbgRHIS+nKq
         WXqvm64Deh7zFofuSyCrJDvIAgIguStZnSsFOXBwfXrGAMnLsr4UMJVJMIrXkumBoY6D
         PsNrwbrYEpu5PoonmlypXek2YXUjrGChILvOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=el7X0/I9BxVvXyltPGgPKnaWWzQR127MIa0+mKXEO7c=;
        b=etvWXz6Bm5agzkqtcPFW4/czDSKjGICDKlWLxX7yPc1PBrz10D7/jzA29GaQ7zYDVG
         kVoxm7v6dkK3H1buzzhh2n3OoS4Diu11d9HhH53/MvAzydYC2TYrkOJEqz8fEDxySzEN
         04kU9AIMCURl6R2/drsSJjLR74ShBhKSxgg1M1JllpsRDqa+gvs3udcQrv5Qkq7YGmrw
         27XI9Rd0+fLOsVCCsiAJhw+CX0VMIQ6W+lk/BjaVp8QGV6+1WIb3/6QMK5DX7PBzKWDG
         itMLZTzi/zJqOB2Uuu8MgZezArsDCEd70wQh6FW0WK3aRxX3bARIpXI3gGqTsDbs+Lqp
         oFAg==
X-Gm-Message-State: AOAM531zaZbzMoV7sTmL8CYO6o8vi5gDYDveZdwyWfeW897+ib/84ByO
        be71XkpUAkR16IZwtJSMs4DxPg==
X-Google-Smtp-Source: ABdhPJxei6toAYvqk4OOJgQioUtQSoogeCjgLgdbQQoMuBuPep0JzrF+zBT7MZAKbdBcicdgsK+Qwg==
X-Received: by 2002:a05:6638:3d0d:b0:321:396b:1ad8 with SMTP id cl13-20020a0566383d0d00b00321396b1ad8mr4280824jab.198.1647905082348;
        Mon, 21 Mar 2022 16:24:42 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r9-20020a6bd909000000b00649276ea9fesm8948306ioc.7.2022.03.21.16.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:24:42 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/57] 4.19.236-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f4ed40b0-e796-f726-eac3-7dd1f36ef892@linuxfoundation.org>
Date:   Mon, 21 Mar 2022 17:24:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 7:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.236 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.236-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
