Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37A60572B
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 08:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJTGMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 02:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJTGMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 02:12:07 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FC2159A02;
        Wed, 19 Oct 2022 23:12:06 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id bj12so44859495ejb.13;
        Wed, 19 Oct 2022 23:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnzTP5XuXgaj3u613ZMp8SzsubSgEqhDulx/yf5K6/s=;
        b=YdxXKqvIZ3VgmfQ7mq/ZeGADCPQujRYrRQAnvW5iJhEYgcIifmZSk3xb4McnehJLLS
         hWql4U/fJp9y7ziGXXyRZfJSYLsfY4K52jKf+ZmJcOVyCLY5YmqXAot0kzTHS0bM0Yxx
         Jg4S2UDB11ESuHAjW7WCgn1zwDzb7X/sZKJmp4S9LusZXCEyvIGEszcqcqRxecUCcCP+
         liEKxWoA2OL/6bV0pLDzEfxnI8G/ITpQhxTkoqqIVo2RbrpuSauChDIsLqBvA1+sdVvH
         lATVseXZ8GBmrOMha0Un75DFEdqnubCAelbpeHkQfqPMem86BQkMtJtddx1I5cUCOZPf
         VrIQ==
X-Gm-Message-State: ACrzQf30GShjnIm4zBSQohSzDLyJepY75fGW+v4CzvNkIr75foGm3wwy
        Kj9lb+dZlvrHvnrxZBHRVfw=
X-Google-Smtp-Source: AMsMyM7+BFPRhnVmRWk5hbSsl2HFTnk3AasHBW3yPUCJKGaW8ZyzL1xsPzlRQ1dTu8RcVw6nm8KGLw==
X-Received: by 2002:a17:906:db05:b0:741:5730:270e with SMTP id xj5-20020a170906db0500b007415730270emr9260232ejb.609.1666246324328;
        Wed, 19 Oct 2022 23:12:04 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id dk24-20020a0564021d9800b0045b910b0542sm11502944edb.15.2022.10.19.23.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 23:12:03 -0700 (PDT)
Message-ID: <8aa4b361-027e-4cbf-9c2d-f8a86aefe5eb@kernel.org>
Date:   Thu, 20 Oct 2022 08:12:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221019083249.951566199@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19. 10. 22, 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green. x86_64 runs fine in qemu.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

