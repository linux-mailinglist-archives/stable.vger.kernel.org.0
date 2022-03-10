Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6F4D51DC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiCJTfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiCJTfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:35:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D4A153382
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:33:59 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id d62so7649534iog.13
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 11:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nXm/nE/YMI/NAjMX3gPi0lN+FNjqkd+Pu3WVT9wyz1c=;
        b=JLbdaOl9J1cQ7ir1hXzFhm5gIIzdVZ3HkGy5/69s9V0YAgUkpbtMq6+xeSls5qgVnq
         WARm6xvzO153pfbizzhr2QDkaDiMMuJlWMR9JtVpqvhuv7Bu6rtjHq4yZ4QF1ogL13v7
         WAb8PUqPlUFxi3NHPcZj4JhfsVE7gqPvAID34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nXm/nE/YMI/NAjMX3gPi0lN+FNjqkd+Pu3WVT9wyz1c=;
        b=eVv1RLlxKE6GIvhiV7F48bMAEFnvPjE+RATSSOP2EdS/b3v33xGNflUqhxCkEU1sNf
         8fpeaAtwpU9oWi6lkBK3NAAmvRWbLfb1e5/QvsPv609BC+VRXpw66F8MDND/U8cVhtpH
         J/XG9U+oMQFRWy3wV38Wii7uF/LM8beZzLKwu0zqI3E1S+LfUfEV++1Qmk70ukENUUPN
         B0maXVK1RtEFr+xUzEjqCQVEuD4gM+2mWDqZZOBsLghQ/LDxvhy2HHANgotsDRvMCW42
         Hxle/OlnC2I0+KjooJJSzVkyG9XYVpyVKMUNQ7pTMrf8kDu1zyXMhQL0zb97SC0ly5qW
         3jqQ==
X-Gm-Message-State: AOAM532XDJHObSIrAoN/weIRTRxhqlFoJCcgS+KwjIVjnIg0h0l7MbpN
        NVi+IsDbzECAZD0NhhDoFkFTvw==
X-Google-Smtp-Source: ABdhPJxBJ0IxCOx3EfWOWZvLJfD3weRVU9D+Y6Mr1oTctaLenTURO3kTlif7LpJ5+yoFMrOEZVNJUA==
X-Received: by 2002:a5e:d809:0:b0:645:eb2b:d173 with SMTP id l9-20020a5ed809000000b00645eb2bd173mr5002507iok.54.1646940838833;
        Thu, 10 Mar 2022 11:33:58 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id w10-20020a056e02190a00b002c6637e1a1asm3248778ilu.47.2022.03.10.11.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 11:33:58 -0800 (PST)
Subject: Re: [PATCH 5.4 00/33] 5.4.184-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a9fba17a-ff22-f55e-198c-d697fdbaa577@linuxfoundation.org>
Date:   Thu, 10 Mar 2022 12:33:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 7:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc2.gz
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
