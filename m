Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC65681C58
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjA3VIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 16:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjA3VII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 16:08:08 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586CC13D6D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:08:04 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w13so1621132ilv.3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DH4ZzMW8awqQxuBAQxxLlZXqR2ybYNBM+XjFbeeh7o0=;
        b=h8iXKK5fHOl+WByaijuCU0fFUiC4hSVkSil+oGdbQPlfFFJf8Z8u9uut/lzF+RDtai
         3rXgswpAJQYlf23//HSASL4VzGp2Q07IYk0nZQ/bjEaoCkfNBcZQ0SSk4T1GAknOiVPK
         NOvUcHExGE/iT9tTrHtmFNeVgY5lVJsNrcq4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH4ZzMW8awqQxuBAQxxLlZXqR2ybYNBM+XjFbeeh7o0=;
        b=nJAYA0664Hsb5LlMMzokE0NJTHASJmMvkHDq9bji7UjaekQ4HYQJ5UtrexyS85l0EO
         dTjbMIQi/uetJ4AfPX32eiMNa3r5z240k6LISqkmFKFznfU3dtLiEE9kb4aypI+G7ezC
         yzg8ePqqO3yHxNU4hw21SUFXbm0gttj5yXjuWC3dli/xAZjzYs3McZq+czEmJH3k7iuN
         7/gwlguJ1TNv1GCOMIuXApCLyIBFfNrP3UgsQUKNeQztcR5iMwFRR717IeTScxcu8vQu
         L8oU6WjGDL381hH0opTHGYBrAhuu7ysG4aUSPNIXSpyQa0EkCKW1hX+p+bvcSXnvAEUo
         NmZA==
X-Gm-Message-State: AO0yUKXZMYSPVSFDzl9z9HfnOnYX44NZ74xx+T1ioEeKmfRagaUvoH2v
        ig4Zx/pNpCQhujfaWmKRvuFIig==
X-Google-Smtp-Source: AK7set/rSsu6jHZOW6SgU6bIYY7f72sHEmMQEZQrznjqoePVyzMyRFQ6MMSUFsMF0MWow+79XF9nJQ==
X-Received: by 2002:a05:6e02:12e1:b0:310:ff8c:6844 with SMTP id l1-20020a056e0212e100b00310ff8c6844mr464923iln.2.1675112884136;
        Mon, 30 Jan 2023 13:08:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f21-20020a056638169500b0038a06a14b37sm4494841jat.103.2023.01.30.13.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:08:03 -0800 (PST)
Message-ID: <90e9f21a-5d6e-94fb-8996-46e269cc7525@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 14:08:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
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
References: <20230130134316.327556078@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
