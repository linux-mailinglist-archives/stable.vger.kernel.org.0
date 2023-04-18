Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1F6E6FE4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 01:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjDRXSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 19:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDRXSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 19:18:53 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6E526E;
        Tue, 18 Apr 2023 16:18:52 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id qf26so4408770qvb.6;
        Tue, 18 Apr 2023 16:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681859932; x=1684451932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3zvg+atLra7PZe1SLabd0g82WwIT4a1nvs0QUOBbfg=;
        b=sVLt6GlYrdqqdcqzfTWR/NcVm4xx3mlkyoegItvNyGvjHXLSgvBKEvVGfboy3D7od9
         f7dZTV5UAb++eOI+fytvSoKgEKf/XVXd6YmL6UFj8nd2CHz6yWrg+VB2wsg3Tl11uiu0
         q7OYcKRpS3KbwD0k9ugOBC3wkvgQNnSY56qTR43Emm2aAyGptpcaQ5Ndv4ZDDMWNv6nq
         7oa41GR09307Q+polj8Ozmq9zmNyGuTu4+eHKBt33Y0xA+8DDmxVT1aHb06HVVhiMM1I
         dkx+iNPw1mupjMAzgmjKbSQo+1AuAuo5w6Y82ncgauCOs6wVU6WdO+tDOcvNb4lxr2sf
         jOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681859932; x=1684451932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3zvg+atLra7PZe1SLabd0g82WwIT4a1nvs0QUOBbfg=;
        b=iluCVC2MfWXshZjg37fyXJ+/A2XzbKU+8gLzqvldcjCls7zPhg/aqcwao/xw5Anis5
         80bO4ytwyA+iMhGm7D7z6gyWwR4KMswJfO8XAmeYv4876WuFG3E7iiDux10X2xRX73FR
         t7xCtWrLgsL3FT3WRujLXsh8lm9ariGYDEEaXDJnAKC8ueckWW46/pl/uIPNQDIiKhhV
         cyerRm+6NUoKYYyNcpD6MZCUFPJAvCkZLrYVGxNje7V8xzdZGsXF3ZSeNvStKDnj7Txr
         QqBLjUhpZN1cw5kJu76Zn+AoOV8VbxxvGa8qS/osNqik/rZoVTSuNGaLX7EwPKe1Oxmh
         YprA==
X-Gm-Message-State: AAQBX9dZDylEfV6waTg5igOOOhomN9DnguJRI8VaoHhIRyKlTo1HUALn
        KvWBd+VzPkeFbQKSlv+UW1w=
X-Google-Smtp-Source: AKy350Yhw0Os57cUu2nkFOrZkPW9+WJGjA5D8gIYm+Bk0FRhUJUvZDtAGbbtXXlT754Bjg4yp1g43Q==
X-Received: by 2002:a05:6214:e8a:b0:5ea:654e:4d3f with SMTP id hf10-20020a0562140e8a00b005ea654e4d3fmr24396109qvb.5.1681859931856;
        Tue, 18 Apr 2023 16:18:51 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ny15-20020a056214398f00b005ef8ade339fsm1072902qvb.125.2023.04.18.16.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 16:18:51 -0700 (PDT)
Message-ID: <bca3097b-f200-c7d8-28ac-575cc60a6f6c@gmail.com>
Date:   Tue, 18 Apr 2023 16:18:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120313.725598495@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2023 5:21 AM, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
