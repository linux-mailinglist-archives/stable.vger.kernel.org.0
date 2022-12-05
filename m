Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18B16438E1
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 00:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiLEXBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 18:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiLEXBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 18:01:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA441EC7B;
        Mon,  5 Dec 2022 15:01:12 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 136so11816136pga.1;
        Mon, 05 Dec 2022 15:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRfbi/7mK0992Ud9pUnMAZNOCs3Qjj5lk/O/IQ8DmTg=;
        b=OJFopkK4vdpDj5kA1KrDG8LWycERHKy0KH9cz8AbsCOtyGKt81ko1B/LZJYHhY7mRa
         F2bgA61LK3+SPChVepJmGUPDRr1H9o1IfF8LfbFwuy4ozZi9mb9Aud8YWrepRgvrX+YE
         LZCiZupBHjcNdlPfGhY6qKAPUcttkzeJ7AbKHyAisUhd3VdzW5MxdYo1bGCsF1A6kErx
         5QFKpVjI5JmgJ5po8yeUQNYSrPyLbjw4ecjhzcUpKj/Eha6LY3IH7C1/EYwDVTUPOW9v
         1gBYZfgUuh7RGc2TJgdENDkJ2nA+KEyQALiN510CnO7PCjhwWKkSNq1HY3r7YDZsNclx
         vAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRfbi/7mK0992Ud9pUnMAZNOCs3Qjj5lk/O/IQ8DmTg=;
        b=B9maUuN8xkKf887OlKm5zywYp9JvPFJBS1bXSE1/kLmdQzWnd0C3PjtZ9Zq41kmSTS
         zV4uNJVDxfGHmn8H2Ie71ZKY/GBDvJLA8744+v9PLVcVDFWOlMQk8pY6kMPS7tFZZUjR
         dHFmAHnYBnVYFUTIkvgX0wIl5hZtZ4+H/9NLtieYQizyyu6dv9oKU94ZzkUym3u4D+NG
         pPwSt7NmOatHmzH6oxJ0n1UV9B/W9HFWwsyl8REPHf3JFSDPaK/+aiJoaGW8/ZBz03F3
         IK+TZNcjCWbaYvCgdzJsOWLsL77lCuCwNmd6k47ZiDrhjvbIwGLGh6CKzBG1Oh+vWL1o
         5lFQ==
X-Gm-Message-State: ANoB5pneWpOLKshWdF6LCFGqvEYkAdnJf0XY0XrlKiyqRsOFHp9KS1/W
        z0fjNCf6SZdzBZPdmBIFjRA=
X-Google-Smtp-Source: AA0mqf6an23h6z5qDBR5RyQpqy8s40D5A5vlI1NjTnQaCsuOpdGbRYVMdr4Pwmjnm8LCVVUm4XZMTg==
X-Received: by 2002:a62:820b:0:b0:576:a748:8fa3 with SMTP id w11-20020a62820b000000b00576a7488fa3mr11629502pfd.37.1670281271795;
        Mon, 05 Dec 2022 15:01:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q15-20020a170902a3cf00b00188ea79fae0sm11211276plb.48.2022.12.05.15.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:01:11 -0800 (PST)
Message-ID: <f849932f-0a9e-9a41-1663-d3e8e47ea5d2@gmail.com>
Date:   Mon, 5 Dec 2022 15:01:09 -0800
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
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190808.733996403@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

