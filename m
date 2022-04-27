Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5752C511510
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiD0KuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 06:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiD0KuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 06:50:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B8A43AE09;
        Wed, 27 Apr 2022 03:20:54 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s21so1793571wrb.8;
        Wed, 27 Apr 2022 03:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YpngR4n4Vedu6z5a5k/BhmCiHm7z2H0f6uU18kyeCSk=;
        b=Ydnwfs5ZFvzstOL4mZcUIcvZik2KN8U7L6ffdUGLBg6HeGTR3AnOj3P361A4EO8w+L
         DWgIzYlRlM15DR98bPZNiTI/umszdYf8q+emO6IOw+t+yPwDg3vhokWlVucCexx56/yP
         2ujV5MkybDr6Alz1WPjU96vs7/uCGww4c+UTuhJcxm5Lhqf+ETMyO5QV7PKMqsa7ImM7
         M0f1uqtoSf7r90QXRCGkKlYuxynQNd8oS17Vsq9i7gpFh/wYKeqvfxLaS0rh/sK4nIAc
         CuF373jNykgAgIefGdtoXN6PK4qEY9W0gzAUCGnFtbZeCcmw+4mnOD8mswUiY1xeFp5j
         uRtA==
X-Gm-Message-State: AOAM533UubrxR7R17k7QmBIsqRg6RqqmII2iZpD/jZrxKOhT58v26kwv
        mQwep8EnHg/l4qHixZmaKvqAmuaRkiI=
X-Google-Smtp-Source: ABdhPJydNWOBreqCBQqJ3hGd3bZH28njhPnqbvszt/1SR/tJ1Zv9LgKUiSxIUD7zogUjzT8tsOpkeg==
X-Received: by 2002:a05:6402:128b:b0:425:d1d7:b321 with SMTP id w11-20020a056402128b00b00425d1d7b321mr22866633edv.179.1651053701125;
        Wed, 27 Apr 2022 03:01:41 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id z21-20020a05640240d500b004261a2a0ec5sm526804edb.54.2022.04.27.03.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 03:01:39 -0700 (PDT)
Message-ID: <8bd7804b-a38d-47b5-c9d3-1f5dca578260@kernel.org>
Date:   Wed, 27 Apr 2022 12:01:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220426081750.051179617@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26. 04. 22, 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
