Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1589D6E6DFC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjDRVWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRVWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:22:09 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134654492
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:22:08 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-32ab7a1c27bso741175ab.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681852927; x=1684444927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=svyznddJgnVR1avwF2cVVe8eGgIgkWAaMGGDNnfRRxg=;
        b=cVBl1ruL/4j6CtSpiI+4j+X/GkOTulJT4p6lxIUvEsQLBQRf1754bALXTDwY8n+gwg
         a/ubfFEtcfbRKloMcn6kQF/7sCJ0eteH3wn8AWhmmAKIL2X4I0Wiq5nsYJjcgAKB58Gk
         ivhp74zaUhCikwjQACunyjhVP0+64Q5rW4UyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681852927; x=1684444927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svyznddJgnVR1avwF2cVVe8eGgIgkWAaMGGDNnfRRxg=;
        b=DBunxhbSerg44dWSDrX+2pi/1YkEk6XsP/w98dqGDtKxitP0uWzg/rP/jiY8Lp+JJd
         yspuxVqwmjdVKEYFVTuEYGNtketthx511foNaL+Vo7I4kDP5aXZVXnsG8ULxjCvQyiRx
         S1DP4aPX8Bd1bO3Fz2ldxXuZ3o0/59W5lRpH8Yfvmof43f2R52wGwbSGPPn6yJV/rlBj
         ghKZr1fINjZJB+VUm/6fQ6oodVheQrFxTR5fqouqRXhfItPB8TSk5E88B0CTdUGtQjfZ
         OnSWHx+pld0Za7U3MIVKkYoTF9sQKiVXVisPEw6hBoeVo40BmxNBI8Kh4mvUGIPhfX0r
         C/vA==
X-Gm-Message-State: AAQBX9cNwhSfJ5O1irdUx1PysrSkTbK5s3vasjWkhf9TTHZRZwJ+WvuN
        xP4ywKH/8lEThOqpsyB69k271Q==
X-Google-Smtp-Source: AKy350Y/VLfcWWcnBVZOnqZmAq1KczXEZC3CzyMaqmYrVkcW58kDFGdj+5ihTikYL7ZMoJmR9H3dJg==
X-Received: by 2002:a6b:c906:0:b0:760:f7e4:7941 with SMTP id z6-20020a6bc906000000b00760f7e47941mr4583295iof.0.1681852927254;
        Tue, 18 Apr 2023 14:22:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ay27-20020a056638411b00b0040fa2395ad5sm2258461jab.178.2023.04.18.14.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:22:06 -0700 (PDT)
Message-ID: <461dc6c5-7771-2b74-f563-5592391645d0@linuxfoundation.org>
Date:   Tue, 18 Apr 2023 15:22:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
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
References: <20230418120313.725598495@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
