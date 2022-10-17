Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA46015CB
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJQRyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 13:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJQRyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 13:54:50 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7619018E09;
        Mon, 17 Oct 2022 10:54:49 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id f22so8196860qto.3;
        Mon, 17 Oct 2022 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khdrUfHq/xmZ6RyuSQ5wPhkDHMm3nElEt82S0XQAwb0=;
        b=KkDC/GQA4JWYpIw8gHPJe7pS5XLkn1cqP8MfcjmzfNHzxpygXF39ghLksuugDC25hS
         FfgsQZzzZACxV327qpNDd+TAAauSZaLlUj7uyPAaRrvik8OsZWIBtrpSNt9juaYtjW0G
         rvqnH1H1TjrCE56VAn81PC0GJnDTQE0duTp+/ms8WH+B6i6IRGScqB9uaSa5xGRm5pDK
         dcVE09Ak7PcKa3Mk2UQ39Bo8RARZtH3uqtFaEJ8beswWkqpKaPeMEds4GwMwOg2MPNey
         DRo7To9wEno0Y1t1CXvk/Zqq1VhyygAozTx9O4zGdPSGMcod77wBuJ/TvHOnAi/4FY93
         PBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=khdrUfHq/xmZ6RyuSQ5wPhkDHMm3nElEt82S0XQAwb0=;
        b=6bCfGSQtQie52nZ40ISzaNpBlBiHyRhebfnin2L52yxpZ9UYxAcErwEdK/OI3NyP9F
         4kxghhlQ9lahN/r3V4OtdMNjHuiTdvshHZSAcTEdr/wC/NBzcvbD0V0l53lcDIzYVraZ
         JlrvV3apNeKWT8qdHrSF/bK0gnccNUGGURxoIVrRq9CAdrLYXrO6J3cD6gVSFsGJmSdG
         JkthHlDjfmtgKdJ5j5leOhS+2CWmQgzuy3r+2mod99VVFJSJNXxhxrxgHeDobm0FaE4Y
         0cRsD260XUxUWQfmJOosf/0V89QuW8laecEaHAIyvGswi+fLEVThFRfIF/RsHapmaCyD
         8hAQ==
X-Gm-Message-State: ACrzQf0usjvk0wBXKzTXtRYU0upyrKygJ/KVWn11tUEGX3j3eOeJyBm7
        As31nNVs3DsYXJeEU9xuR6U=
X-Google-Smtp-Source: AMsMyM7kDh8XVMNqSddNDBMxzHGMa/kidI52B7qHZIMFfYxRhqTxQ/oFPX+OoU/pC2tCcTr00/cUlg==
X-Received: by 2002:ac8:594b:0:b0:35c:d0b7:e2f9 with SMTP id 11-20020ac8594b000000b0035cd0b7e2f9mr9756489qtz.483.1666029288440;
        Mon, 17 Oct 2022 10:54:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d12-20020a05622a15cc00b003995f6513b9sm264012qty.95.2022.10.17.10.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 10:54:47 -0700 (PDT)
Message-ID: <e895edcd-d419-07cf-1d05-30d1b8d43b66@gmail.com>
Date:   Mon, 17 Oct 2022 10:54:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 0/4] 5.4.219-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221016064454.327821011@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/22 23:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.219 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.219-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
