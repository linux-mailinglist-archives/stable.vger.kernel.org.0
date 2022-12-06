Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DCC6439CA
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 01:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiLFAKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 19:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLFAKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 19:10:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F61834E;
        Mon,  5 Dec 2022 16:10:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jn7so12358727plb.13;
        Mon, 05 Dec 2022 16:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWkw8USON2HrUmyH0b8pO4aOKQO0VycbPyO1Pmwem9g=;
        b=l7igjYwSI5wvqZQy8FZ9NFcMXbuebUmal+Pcgj2QYFvZyvfgav8B7jrv+vU1/eKTj7
         tIXuS8KnSuCAUfFxQSlwuxG52FD/oFV5eXOTAbSZ3rREgu1HPRGuED/I5sh+CJ8XCudm
         Ro75/VHwCI5FC1Vl3jsJ30q+htK3ruZlK5A7AEH1ULzyCpLHfJs6zdwyMpCT8K7i2jCX
         MWv7dMyQ/loo723dFK3s++PtuK43fgt33ZtARysxGO7YL/zlp+am7vNS63illY3GMRC/
         M2dBSeNcjk5HVzTUypaLfDcXbFzdV8hFEkeZCRAJbjszNCmz/kik21a/6qw6WOZZilv5
         h2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWkw8USON2HrUmyH0b8pO4aOKQO0VycbPyO1Pmwem9g=;
        b=hzYfR/RH2/+JdQBWQeVkzd6Jqo0IkVNCQI644U7JUUG/E2o4ADvCCKdSxyGai+E18J
         2VOmoZelxFdafvHAhbqqQoICH7EryjeqH0xEs4Nu9H3Dh4BJZt8lSO7ONPLNOcefZB8x
         Hu3QMJ3RGcUu2qhnUJ20YTqU4CeyZkJU+ui/a0BhVEzmVMPLXKcv9UdS8wujrksyEeCN
         yghH+6ddbiVH7UPB08NTuurrxIoVQPod0I4gEyWAaV7+z9bqR/5do31L8Sqhj0+ht/0l
         7FApLxFdsyp3lv6EERLSbblLuTUmEjF1PUSz8JMCXfN72InauG1jugPujlzYORyPpql3
         dhBQ==
X-Gm-Message-State: ANoB5plqd6yAWZxNsppUggXvLWnJDXpTvRxAcEp8PWb3deC695ZHY033
        WKuyStRCSTigghS+t9W0/WU=
X-Google-Smtp-Source: AA0mqf5y7GS7F6F0deLhC9nxIAXYbGotWppRNNY16or+szh8u9muHc0lqaYp0bdrz4UyqwBvoYLdXw==
X-Received: by 2002:a17:902:7b84:b0:189:6623:4c47 with SMTP id w4-20020a1709027b8400b0018966234c47mr16848890pll.170.1670285400914;
        Mon, 05 Dec 2022 16:10:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm104426pjb.1.2022.12.05.16.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 16:10:00 -0800 (PST)
Message-ID: <023b17aa-5fcc-1465-79b0-0ba4ba86f580@gmail.com>
Date:   Mon, 5 Dec 2022 16:09:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190808.422385173@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

