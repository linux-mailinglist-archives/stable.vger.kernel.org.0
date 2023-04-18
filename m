Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF7F6E6E32
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjDRV3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjDRV3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:29:09 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDC7D30C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:28:43 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-760dff4b701so9763339f.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681853320; x=1684445320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AF+TKDSwlJxEFvef+zLB3pMaYgBVJqNgkRygFdxNlT4=;
        b=CPg4nV1fbFsHAryFxUq33eiQukeLnfEN2+T6suHcy8BLOSsHvyB88Ad0wrH3eIlsms
         d3i4pw6V8UogxgGWZ8SjdWyqpwBaah5C9D/S0Txmr/FFB+lA2PxhcQFA7Do2P0hwraUV
         +XuqF7dyqNsRBFGoeJjX5/tJEDiNUlwZQMpJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681853320; x=1684445320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AF+TKDSwlJxEFvef+zLB3pMaYgBVJqNgkRygFdxNlT4=;
        b=Y5wPb7FNfH86rwTRVklY4b4eCB4f4j8DiFTOiG6QRU6kID6LUiqbsh0iQuB7uR59vn
         S4pnwSrWPFqus2LVeavembSjWBK7kop/i2Oyo3DlGEcxPIOazHqhyk+W6skgYyuh9ZgN
         m8ZYl6W1QhMVnXFGwNwYLjkgAGlgJYKZvHRROhLtY49OkiHfLZJE6O8Cn4bLZpnvmwqv
         ZMCnIyc1ad4usXmk3yBdiCcyT/hMMV7bP4/HjlV6avm8/HYq8st9qCTXoTxsWD8MZotb
         1dHcX1RL7VamSD3TyrHMGdB+ayJGM93XXTUpu3X4c7PJ9vMKnIHqHyNDzA0VnZLzCINr
         hHTQ==
X-Gm-Message-State: AAQBX9fKLjMJv4h50XgRBrSUqqNa0OLqaqGWC9kVrID6pcBKC2ctUSFJ
        Go85k+YzIaXNyoxyzp/a4J2zSA==
X-Google-Smtp-Source: AKy350YiS5R2Iq9yAjKo6pDkiNMNYsvpJyUtu0o416AIUIjVw5bg2sAXzqIda+xaA9Ecpg8BKrTcyQ==
X-Received: by 2002:a05:6602:340e:b0:760:ede8:5371 with SMTP id n14-20020a056602340e00b00760ede85371mr6811092ioz.0.1681853320248;
        Tue, 18 Apr 2023 14:28:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r16-20020a056638131000b0040bc5460051sm3531116jad.98.2023.04.18.14.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:28:39 -0700 (PDT)
Message-ID: <a94f6d9b-d2d3-1c56-e6dd-964e15763eb3@linuxfoundation.org>
Date:   Tue, 18 Apr 2023 15:28:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
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
References: <20230418120304.658273364@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/23 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
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
