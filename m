Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16A45EB4C1
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 00:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIZWqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 18:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiIZWqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 18:46:09 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732C6C110
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 15:46:06 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e205so6484546iof.1
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 15:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/fv6awnLKXGVWS9kL+kVxKz/ZUV3ghwKIl1PTS0HyM0=;
        b=e8CqpnKWzIfY651/xGXB2b61ZHtOAFGd6F3UXzO6/gyeXgHjGvCh9EsuLkgp1VzzSf
         ThNV37MtDyqeb5LuKVYXx1JPb9Jojddtf8dC6MJzPde43zttoT9elTb/84Ofhp4N1uQr
         fR2coW1SwwwrgmoVN1PfjSEpPp2JtQ/alBtEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/fv6awnLKXGVWS9kL+kVxKz/ZUV3ghwKIl1PTS0HyM0=;
        b=QtsqGLLg8LZKOT53hSmmG1oTgzRJnYsib8Dy3NeDet4aWproHh7dIa5dyX2bq60vHi
         5Uj5Z60bQMeO2urqJYNJcO3xjsjGl7CHYjyogZ8qYgEUWvCOGXKe6+4xi1XvICR9/tQe
         eYhQx2eWHMP7pNG44wQn5AZyKZKCHq2XTqAoB6F9Bt0+S+lLZL3vAUnVYEJ/b0F2Cm8f
         M/FemGdKXTRYumgqucaG1QuhxKlx0IGyr6GSSJq7DBHzOqB4/69jbluOb6fKQc3d49px
         Chu/D6JlkfpHJoHFwEaaxIdG57ThAbilfUABw5BTzZ1lMVQvHm7OdHz3lIgL4lNTwNdp
         x22A==
X-Gm-Message-State: ACrzQf3thnueCWEru1mVUoR30rw5ZTbhqjbIaKq6ngEsN9xHARHvCi+6
        pcuiPY3NAUMq/Kiex8FjUMm23g==
X-Google-Smtp-Source: AMsMyM6PRGoxYMar4X7Rttki/icTUERAkM5O4KuqRAE4rcja8UEMPK3oTpnmS6M3VgUxqRRYpl+xRA==
X-Received: by 2002:a05:6638:1349:b0:35a:3ab8:4af2 with SMTP id u9-20020a056638134900b0035a3ab84af2mr12608868jad.49.1664232366196;
        Mon, 26 Sep 2022 15:46:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d31-20020a0285a2000000b0035b95c78815sm114851jai.33.2022.09.26.15.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 15:46:05 -0700 (PDT)
Message-ID: <1ee09962-5e2c-c25b-b627-4111f6dcb2fe@linuxfoundation.org>
Date:   Mon, 26 Sep 2022 16:46:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 04:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
