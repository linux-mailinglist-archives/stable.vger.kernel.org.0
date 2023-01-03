Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB1765B85D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjACA2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 19:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjACA2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 19:28:13 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDBB6264
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 16:28:12 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y4so15984803iof.0
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 16:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dK+ejME3vqtm+a4Icr6XTfv9xCasa5ncnfzEz7AmwPE=;
        b=FkkX1Y6/UmCHrrCunMDYfuWIZS5C0QbP6hVZgmx5b7aFVWi1IOhBKFwPM06CLsssUk
         qagPshS9cIp6myQentdOXs95tXEI0J/OSku2V09/tznz/kFs0oe6Rhtld8alkJibN9IT
         f66R83GFb/GE6jXyK4Tm9xPlobWmDAeCAB4yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dK+ejME3vqtm+a4Icr6XTfv9xCasa5ncnfzEz7AmwPE=;
        b=eGqQ/Mx/KdBODk/2gxtTd4FvN5UtTYNOvY+rNSEAxaRwAqQbZE3s2PFZr7qm2FlMT4
         47wVuwGj4rMOTGtdQDmisAfGOrN0lSJiQwiTNqAgV+NhIGI7QYg8FRmUMraujAdVZCap
         WtklWJJC1kvba8pXWzU4KL2MGun+GFJCHZTYpWF0yvfawnzuWEFevlb2vLog+1BgLSc6
         ncOh0QjCCP6KK9U+pSJpxjfU4IpYUY75nMXbvzrOURvI11NzSWQ/sjGwqupviMW7iUZR
         LyIJpfwvitFpXhu0RhpB5uRw0d79J/jj0MS6rE6+8Ta0vGx1sXrvvTOjZcV0uF15tO8y
         LocQ==
X-Gm-Message-State: AFqh2ko2ddwGgR4QACT9N6F7OwA6hPPrME0Mjrmy2tk20K6N/sNPPYN2
        qCvyUNgJ2q5IoSTAb5PbpSPJOA==
X-Google-Smtp-Source: AMrXdXujG8b2HX5DiV2u3D5kpWk9c3RKCpnZlEcfY0e9s071qomyzBsqHE99I1el77hcqErr2Ocxhg==
X-Received: by 2002:a5d:990e:0:b0:6df:128f:ca12 with SMTP id x14-20020a5d990e000000b006df128fca12mr5134666iol.1.1672705691687;
        Mon, 02 Jan 2023 16:28:11 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s22-20020a02b156000000b003884192cc05sm9705107jah.120.2023.01.02.16.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:28:10 -0800 (PST)
Message-ID: <b5febc3f-8796-9109-45fb-6d009e2df1a2@linuxfoundation.org>
Date:   Mon, 2 Jan 2023 17:28:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
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
References: <20230102110552.061937047@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
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
