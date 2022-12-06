Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22761644EAE
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLFWqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 17:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLFWqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 17:46:07 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9513A4A054;
        Tue,  6 Dec 2022 14:45:59 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id h24so14947362qta.9;
        Tue, 06 Dec 2022 14:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhusZo0UZpLkHp2hkG0XwlRQvwly+H9BUTlbjfbvJMw=;
        b=G5rwXV86DqYOuntYVKt2rBWXbW2Ib7WhMzic6olCKjyrb+r1rlO2bXg08RZwDsNL0m
         9x/7PEQU0Q2V0HZFhg8BZNehre+jQJEGt2RkP6HRON3qoiqygxpkf6opKVa8ZKqfTRhW
         DaWm/aO7hFeI5EEDlpCkNeeFdWz6UgMOO2QJ2d+wOSjzStCtIM+8FZpXKOSESoqIqkQD
         +/RJIDgQ6zEw7Z24ILqf8Q3vDqb53uVoAT0RhuCajJrbRn/mYL4Sj4t0CnOy7PiEvKoK
         0Gx0T5BO2CE0RSG9vPvFDIQ94UqhbDNBFhkcap6YE3SqPHc7wZXMueh4+8ZEpIe7SxJC
         mznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhusZo0UZpLkHp2hkG0XwlRQvwly+H9BUTlbjfbvJMw=;
        b=N3jGAZmqZBU6N3IlxGDVV82lfooG2zZe7EiYS7hzfo9DdjuSbkO/97X4Mub8vEm5Vf
         U4sY3jyUksXs+fe99qN9AM5Cqiu8SITkWijJ2LvYEhFjWVm4DGTCdXxwlEShHM4kN2Wb
         V6NRscHUzG8I1AFGvAb3V0INvmPFL9QFKinS9p1RAD0LirOX6b1AxDM/Lh04xYzXH8I+
         eUUvJg+Wvh0dE33pG+dBJh1nKNmyZCyuRCBm+RstyQOKKwt2EOS8Wm6N9N7s5w4nX5By
         nhXh88rckgNOyKJhv9+w+ARr+VA6dApT9uhR1eKl2z93gB842N5gyIaNd0JVu1hxfptL
         f7JA==
X-Gm-Message-State: ANoB5pn+A8mAujESb6cQ+W5YhYr6DSIKNJ7eLHKgUGF7MjkIZb7DMw6N
        /qzb2TcgSY4guYhCzlC7UrM=
X-Google-Smtp-Source: AA0mqf66qzaR2dpf2TG54CKjE86fDCbs73ZBLCAKWxnqMoOxPGuqmYPJL58epYiAfV58VAJviR1ihA==
X-Received: by 2002:a05:622a:1e94:b0:3a5:1ab8:4250 with SMTP id bz20-20020a05622a1e9400b003a51ab84250mr68202211qtb.182.1670366758538;
        Tue, 06 Dec 2022 14:45:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m15-20020a05620a290f00b006fc6529abaesm16076691qkp.101.2022.12.06.14.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:45:58 -0800 (PST)
Message-ID: <139be316-d52c-126b-d5e4-24e846ef88f4@gmail.com>
Date:   Tue, 6 Dec 2022 14:45:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124048.850573317@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
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

On 12/6/22 04:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

