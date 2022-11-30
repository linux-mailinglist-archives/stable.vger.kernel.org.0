Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E63563E1D5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 21:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiK3UYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 15:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK3UXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 15:23:52 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FAF1B7B7;
        Wed, 30 Nov 2022 12:23:34 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jn7so17812253plb.13;
        Wed, 30 Nov 2022 12:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7UaFta4NOMMkNLICFxV78XM9pSfzAhcmkG8cBVb/uXU=;
        b=TbFcaqIctEOqINXcO6zjYXoWgY/o5kTxAkN3J4FPM0LuEL2af5sbtdYbgMmE98tJto
         KCbyGgNVmViFo62SLc51ljH7c2itlj39bWa8L+/vRBiGcJ0A8gT1rFityTlevqLlTLIg
         VdbeEM+BCoQ12tpyqpM3mT4vupLTXmfSk4eq8XPNyQIciHKlhII3v6/z7EAwK8RCspro
         uX6SQUoy+xz+ODcrKpEVSctDpodJcESFl/NJR28XE3cEMfXupHEct+zLa0C66korbmgR
         /akoNlFnyIOJHYMrA1b7YjGDPOyM7ejSZGgnJCuNjgI2Ud3NFCjIJJTBxu4a8yPU7scu
         oxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UaFta4NOMMkNLICFxV78XM9pSfzAhcmkG8cBVb/uXU=;
        b=K8G9cDcQZW0M1vIkZPRMqtEn98H4uB+Dewd7kC5r8MWulK7sS8kd3NmGb1x/WS/kps
         Td+dQoFsRUAZSwEWmrdKmyS02pgGbcjRllj038chJyIZBzozlyphuRrE15OIdBvICBJ7
         ZI/RcNur7OPiAWisV6u3Nc3ZYlyzEK3/38BsTarMULp7aCmQBX192zCUOzy7JlGX/bqN
         Iy95n2aFq2G3tSIT3JtMlIKmfSbGiWBSxm7B1v5uucvDpIcD+mGdlquZxFhjsUE5Pgce
         ohIFaHBikewkU2PsCiaMZj5UBjsM/xmVF+R7CACfWy68YFvEtC6pQVdozpj9TsTyRZhJ
         GVOg==
X-Gm-Message-State: ANoB5plJLQgfEJvvICvoUsWiaapcaeqjvFt8hRKA3OHn7TKG7DuKyMY/
        blRiRqYLzWQ4cgA8RGVRSQ4=
X-Google-Smtp-Source: AA0mqf6HGg/z1hOIyUiikPDhAz0YF/+jDjPa0xUzKXn6XVp7dG+QsSwDXahw8mdeFcY3XdR254xomg==
X-Received: by 2002:a17:902:db09:b0:186:f36a:63b2 with SMTP id m9-20020a170902db0900b00186f36a63b2mr43060023plx.128.1669839813762;
        Wed, 30 Nov 2022 12:23:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p13-20020aa79e8d000000b005751c5bc237sm258548pfq.128.2022.11.30.12.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:23:33 -0800 (PST)
Message-ID: <a87ee919-0687-ad50-f9d9-ef4a52426e7f@gmail.com>
Date:   Wed, 30 Nov 2022 12:23:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180532.974348590@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
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

On 11/30/22 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

