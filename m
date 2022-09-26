Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01345EA9AF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiIZPIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiIZPIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:08:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F119E3EDA;
        Mon, 26 Sep 2022 06:40:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so6811004pjh.3;
        Mon, 26 Sep 2022 06:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=fk7056c7Z8ksmxLBCKT4+cAtTtFI1nGaYDJB6s4CIus=;
        b=HxaWAdBeDHsAaDN3pTRZaYBi11DiFbg7dMwPBO3WqwoMPu9WC0cBdC4ISLnTSoczrA
         06IHgS34V0Zb0HncyRZ/IzYSGZGbBu8ktCkfKGqEYONyQbUV9s+MlEuq+uKh3mcT1wV+
         2zYbbqbQ1a2IwQ4l/kACxsnehgNXU5kFx6k5/v7O1mlKDT1CZsuclHnmmxycgjaiORaI
         ZZYZol+7Z9qBBQtOmW+BOT8KZz38K6hI4QonTLjUYcqbw7YthiGfq9BLj8Tia6HNEN9n
         bW9vTHW0QAvI5qDSUePE/kF8mzJlu7nanXB7qFyvHcl9EMgzvP/PCMweQClFy5LXDGJL
         R8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=fk7056c7Z8ksmxLBCKT4+cAtTtFI1nGaYDJB6s4CIus=;
        b=wUhy8EV6xk6rueVoPSLzPmlvDQCelQ28RQfJo5CHT6cPz6PO4/hUxF715WYf1ce09V
         lyH5xLQoB8rX/cuiKuLBNFMf0AcE0vobaV1phqGRmxaMz5su+MD7bRLPE8WMBkqqTZh1
         9kQdQdJjpbhNccVg1BlIoa0KyFtiMEtrGgNksr+3Wo7VSVD6rhVkBhF865e2SrNCZBCt
         /Svni8Do88hkE4+7unPb0yvhM2OGIW1muIzg5PYpP4BFZiCiWk5muHQEAfKrNQC5RwJg
         1PZuw/KT429UmeUvXQ6bUT5p7ESWYv5HRaMnHT1nzTJrKrgtnGst+1sd6uMaz2cymEUh
         tT9w==
X-Gm-Message-State: ACrzQf2UVYX8jHDcu7CMP88sKc8zpPN+2gIGeYwCCQWZugoDtqA0WYzl
        CvzPr1Ydz8cYsc3eG8t/o1k=
X-Google-Smtp-Source: AMsMyM73UMqDQpFe9P+C3TyT3RaXsJq6XMdcPj0lKJrw4Pfx5H/T9BswBGDeG8VCmcH1CYYTZsbyLg==
X-Received: by 2002:a17:90b:1b47:b0:202:f248:e1f2 with SMTP id nv7-20020a17090b1b4700b00202f248e1f2mr25051613pjb.106.1664199629583;
        Mon, 26 Sep 2022 06:40:29 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902bb8c00b0016d9b101413sm11024825pls.200.2022.09.26.06.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:40:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <41bf6865-ed26-b1d0-f540-7c2d34a2522c@roeck-us.net>
Date:   Mon, 26 Sep 2022 06:40:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 00/58] 4.19.260-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926100741.430882406@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.


Building riscv:defconfig ... failed
--------------
Error log:
arch/riscv/kernel/signal.c: In function 'sys_rt_sigreturn':
arch/riscv/kernel/signal.c:108:15: error: 'struct pt_regs' has no member named 'cause'; did you mean 'scause'?
   108 |         regs->cause = -1UL;
       |               ^~~~~
       |               scause
make[2]: *** [scripts/Makefile.build:303: arch/riscv/kernel/signal.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:1073: arch/riscv/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:146: sub-make] Error 2
