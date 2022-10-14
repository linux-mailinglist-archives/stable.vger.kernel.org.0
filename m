Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3665FEDD3
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJNMKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 08:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJNMKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 08:10:44 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DC2105350;
        Fri, 14 Oct 2022 05:10:40 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a3so7340712wrt.0;
        Fri, 14 Oct 2022 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+S1S6iQTadV8AVL5mXLga0jDn7GPEoPiIMlt93AwKPo=;
        b=QHStRav4UiEhQot01O4anYo2z4HVcTniq0O+/YfRAu9OavF68YHWWCcUjuTLHsN6j2
         NGe+csUj34npiWyoaGmREO9G8C/ux40aKX5qljZFAe/PxKZwefTMeK5jDoO8W3Z/IE9x
         DpQQPipHmGdxt+BnLzCztvgc90Cz45YH8/ywZZdgMpkVuAqmgTIxJcy86hYaLWYUMp+E
         3LlM35jtKliddWNzWScRTPakOPNszHy/byMpmmjocFFLkQHrZ8NGuQB8YN8NAS611D1a
         XNX83d0IPDJvXwK6bOwIealSTysOqQTj/WVefJSi7aSHum+DEov4W1jayH3DczteuUi5
         gWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+S1S6iQTadV8AVL5mXLga0jDn7GPEoPiIMlt93AwKPo=;
        b=udXAqtTeTT5V7FbkCPiCXjIGQanfUJ6zPN8M5kCe3jbCTpGt+AEPz5cfD+3CA4ztmm
         Nrnz1XpMBU5neiHO4e6qCE988NZAoWfSY6Q0jE8c6Dl8sdWfETFkW9kd60oekV5VX48r
         1COGxTVSwnlIcZTYKJfIYwbEvzFgqz7YwPXQgpRxUYgDzMe27a4cIFhwtyxYdQ5A6l0B
         Pd90o9HYivrwmKHk4yHVSjB9XvIq51gH9yrcbWfTAnXKPQGltupZVdJSrR2c1DbzCPzn
         qN8UbOiXMDZE5frv2N068I75lyL5UbvcVQKu4utMlILwn1+AzG+EizMtoMhDc4KeqO4K
         GPfA==
X-Gm-Message-State: ACrzQf2KQNf0SyUQwXzFmR63hKFq7bfDFvFUn3FCgvqTJKd5YMFRdYN/
        5qeIpX8LGGhvZaO1bnYDEzo=
X-Google-Smtp-Source: AMsMyM6qbweti8MfwZV1RQjT/MY8evDlRwtMX35HkZt88gZadAZTfta+lXLtN/m+PGWwf37RlYO1uA==
X-Received: by 2002:adf:ba8f:0:b0:22c:def3:1179 with SMTP id p15-20020adfba8f000000b0022cdef31179mr3192011wrg.571.1665749439507;
        Fri, 14 Oct 2022 05:10:39 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i9-20020a5d6309000000b0022afcc11f65sm1782970wru.47.2022.10.14.05.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:10:39 -0700 (PDT)
Date:   Fri, 14 Oct 2022 13:10:37 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
Message-ID: <Y0lRvTp/JhW6P/RM@debian>
References: <20221014082515.704103805@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Oct 14, 2022 at 10:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2002
[2]. https://openqa.qa.codethink.co.uk/tests/1994

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
