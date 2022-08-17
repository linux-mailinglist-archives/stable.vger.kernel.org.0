Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4038596CAF
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiHQKRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 06:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHQKRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 06:17:33 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704B76A488;
        Wed, 17 Aug 2022 03:17:30 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id qn6so23649114ejc.11;
        Wed, 17 Aug 2022 03:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ssQgdDhF1q5rjKeY//uDCMUmoWT6U8MA0IRHqYAnOq8=;
        b=Bt+4r7hEc3CZiyd0TBAI/SkMVFgMTGzn5sfH0SjAs76BTRJncsIb79llDYk7wdmrrw
         KpDTANsuFLGFrPSWyCLE15yR8d7UiPlDc9Mz9OtNDGtkxwYjYN+SA8djdZuaAuERQBVo
         QTAyRwwOpUVam839mnEVMQ/Ggw8jHYwsSw3ATwf6XtyY9qkofX1JXiTb1Bu+CGfjQMpl
         ZqJflZweDqOEhSSDWMat8p2jluxngIqItnGCfNm+SVoGZetZRcSYlXw3XPgFGTF3sAZu
         icLOCEMDdALZ2RrHc+MkowwKJLleAOAwO5Su3z4X4x7TsFgEZduF+rkY0W4Ktew9WkUh
         Xd/w==
X-Gm-Message-State: ACgBeo0L5xtf50xmRnyU5W+MQYZ4DJmF/KXAWsH2YwFfLyM1JK/+wg8a
        VkWHLHgbQjKgMSWX1MxiQytdtHIiIkhL6A==
X-Google-Smtp-Source: AA6agR7E2d204lohSuCMUbn5kesNKA2zKIK8FFjuN/WwYz6axq8n7kuPae25ja1zQeQeH5lzXKENjg==
X-Received: by 2002:a17:906:dc8d:b0:739:df2d:3400 with SMTP id cs13-20020a170906dc8d00b00739df2d3400mr2184030ejc.561.1660731449021;
        Wed, 17 Aug 2022 03:17:29 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id e11-20020aa7d7cb000000b0043cd06bef33sm10366433eds.97.2022.08.17.03.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:17:28 -0700 (PDT)
Message-ID: <6af4ab1e-14a1-4128-e9a0-1fffa2a3715b@kernel.org>
Date:   Wed, 17 Aug 2022 12:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220816124610.393032991@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220816124610.393032991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16. 08. 22, 14:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Aug 2022 12:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

