Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29302571D07
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiGLOmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGLOmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:42:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425DEBAA9C;
        Tue, 12 Jul 2022 07:42:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a5so11477219wrx.12;
        Tue, 12 Jul 2022 07:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2H9DivqJLvrQc/Vixo10g3xXaIE/JPWgO6BlsyYn8Bc=;
        b=FAfmUpYnEv5NjejHbuirte4lcA7WJcDWeHwF5wCQjXGs88kOODNEAuAPWTOZQ8id6h
         W2hDu5HJk0KugrXO8B/rY1VYW7cUw5QpWQihWCJIQFiN5bIDgiDTMC6c/ep5G4131BZ2
         BwpcdUsPdNA63VOclHu+MVzwlYZLnzuFySKC26ADfUbA0xdJ8qOsl7p95OyqFvv5xuTQ
         tjo2T9nvYalLm17HvA0kgY7Grn7G5lSZY0G8g+dkbFyS19qo4xfAMH0S7tI/5oz2RndP
         DIh6Y1MyHrGQpdWGscb8iWJ9j3o8xY1RL0EbaX0GgzMVUfVJbGs918baElQWM+AIscuH
         Mnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2H9DivqJLvrQc/Vixo10g3xXaIE/JPWgO6BlsyYn8Bc=;
        b=zzlcuO8XwjQ5b0yv+NmhuR/ZWzfrsSlDDPUfK0vsysgqYmcFFqunMYdk5zJRLI0vH3
         GQa+44WjToqrDO5hUOq41mUvqBvBmL+lCRTh9ITej7gIKPnN5n4o7xjMusw0lk5GQnG2
         yBuaFocj989wAt8ewdvIDVP7FKIM55j/uTyY1RTZ0GmWgsjsWiKV0A78Xe9uskV2yy/1
         Vb5/PY6edBLzRo764M6w2I9zdnb/h9WUBQI3QUir3fNR/qAIc2CEg4KDg329Trsqm9zC
         fsWCnRWzTyKuFlL3M5gli1yLcjptKlrxq+/6xL67ZVLqjVu2mcVlds+XiNcsRQuz4JMe
         834w==
X-Gm-Message-State: AJIora8tSoVuQja6uXpuj7UgHRu7+3ModQTefV/iL8Lt06OHycSAvA97
        gKoho65jxxdWWD9yBIhi6Bw=
X-Google-Smtp-Source: AGRyM1vi1a/FwoBoyr6FuOFKgN3jAFYLVzWA00DUX4+9YLqsZDx2D6yj8oHehlwwYFMWUd+pFrc/uQ==
X-Received: by 2002:adf:d1ef:0:b0:21d:983f:4b8e with SMTP id g15-20020adfd1ef000000b0021d983f4b8emr16950352wrd.334.1657636971819;
        Tue, 12 Jul 2022 07:42:51 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id b17-20020adff911000000b0021d819c8f6dsm8381899wrr.39.2022.07.12.07.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:42:51 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:42:49 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
Message-ID: <Ys2Iacik+57Vgysx@debian>
References: <20220712071513.420542604@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712071513.420542604@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jul 12, 2022 at 09:16:20AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 07:13:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1494
[2]. https://openqa.qa.codethink.co.uk/tests/1497
[3]. https://openqa.qa.codethink.co.uk/tests/1500

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
