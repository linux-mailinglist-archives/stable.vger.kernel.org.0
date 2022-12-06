Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331BB643B63
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLFCkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 21:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLFCki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 21:40:38 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B01B498
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:40:36 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e189so8926982iof.1
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 18:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C11bscbOmfUbhUvDY9IHufEbXEW6Jlvs+hg8vJ4XBWQ=;
        b=f59DNAZDv+rfnYq/BEXcLH/B/MQhjC0omavNBDw+annfUJyQJAWvnSu3+WdD7NbAw8
         tAfq8Fi8S/PUUaEfUc3hXJ20OkZcfFsGgKwNhqHDNrj9uDU8K/Qo6oPreqvdCrtJBy1h
         9FFZfq9H2BaFX7onn5O1jYE8S6iLWzSjwHi+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C11bscbOmfUbhUvDY9IHufEbXEW6Jlvs+hg8vJ4XBWQ=;
        b=2OgNjx68M+7jwDEpXpr7HzDPlsX+oU7ZySvhEnx4eDbVTGLFtzwff+ov4W78TyKzLV
         VG96x1dp/lkJ7EpXbUJcbJ5LD1EP/G2EaO7wcdIQoYJxQ7LAFC5EY3zZbJK/NnSI2BmO
         Hqjm6HiPYNd6rvCimgPvao6yx6Bs+EImxe9RrhUtXmVNgq7D/qioyysRCzKBSHcxiGet
         ED/eysbJ+cdMH+1pJG4AUrOCIcBh8xjLoZOIaYWKKeVOlMyrECujlFEW52lLaKcdnGpu
         3lGrDDkNiJKk0DKBb8mUKfskCCRrlYmLVPa7aImNyCJpU2mdqrNIU14dUoj1kV64oTHT
         HunA==
X-Gm-Message-State: ANoB5pmWnYL/J6v2WKGJdLRt9tAikx48lMb9LAaS3n0z9KfXqrqv4vAK
        FGk/1aoF5AluwoTC3JSloHX33A==
X-Google-Smtp-Source: AA0mqf4YJZkgLRAm/eqUjaca7IMExUKaYAKkSir++EWeQ1/+b3ePm4WZrqEU/RxxN00PMn6NhEQ+yA==
X-Received: by 2002:a05:6638:440b:b0:374:fbbe:2da6 with SMTP id bp11-20020a056638440b00b00374fbbe2da6mr19160646jab.163.1670294436002;
        Mon, 05 Dec 2022 18:40:36 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p18-20020a056638217200b00363da904602sm1549786jak.13.2022.12.05.18.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:40:35 -0800 (PST)
Message-ID: <91eadab1-92bb-6361-7c43-193a8e348045@linuxfoundation.org>
Date:   Mon, 5 Dec 2022 19:40:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/153] 5.4.226-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc1.gz
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
