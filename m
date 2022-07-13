Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53E35733D4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiGMKJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiGMKJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:09:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD39D515A;
        Wed, 13 Jul 2022 03:09:35 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v14so14782712wra.5;
        Wed, 13 Jul 2022 03:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ijw1Pj9mlwCMZV0dKb2NxQ12t1IxBRC3ITFocW6Ygu8=;
        b=qfhYomL/hIUTsLfOE29RbhT7+fpojiJFR+9+FKQSJ0lKCBW0kbEXVNnXkpEsiOxcG8
         CoGGKthycMvHQhri66yG1htJTDPD3DH/nFHke6n+xOoTyY1K/nYZ3WU9U5cC/oxMacfO
         i2qKkAv0Y99DnT549erFzSUwuikQMM65TF3owJhDwdtHp3Lro3Qjs5o7R2hwMOqbq51D
         ut+wCDIklEoNqfLnKZo1tBXhys3AIXyTd7CbViL1K7JEul5ZpSx+XNWSbDgoFNi8l+E6
         TehsuW0Slvr868okRcU5RuIPL5ZDdk9fBlFL1V7NfSMJtNBVfVMRr7A/fHoFbTm0BWmZ
         yarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ijw1Pj9mlwCMZV0dKb2NxQ12t1IxBRC3ITFocW6Ygu8=;
        b=aoJgw7SadIFomlZwyyEIom6e9dTjLRDBIu2zHSkrFDUaPnykpf93jU3sfHglrAuLvw
         uI6CiLxXifenYtifoOfsjLa0PztU5pa641/8FHzcjHwxvX6Bt99Z4zQayBD/nODtnqgC
         Ov8u7NL86d39eRJcUepvfN3xufYCI9l7bxvRd8w1E9QuCkPbF5oOVyJzVhB/Oz/X2F1m
         FR67H/t4VrpjDF7xZN+TRdn1PAyUHOc0Ni5/JaT8O3Uwy/V01puKzJ7tVmCCR2SRo3FA
         Iozec0q7vw91loK9zoudtvGMmVMn2uOJr9iDbzZP8JQuJs4M0CN20OI6y7/ktNnDMbwu
         RRDg==
X-Gm-Message-State: AJIora+1V1E0nHvaWX0zLY4Nx4a2rgtbGm6gqgNbgNPOaSEOJvA73PlY
        ZaSX6xf/bBBYLKfLJhFLq0t9OtvL/xw=
X-Google-Smtp-Source: AGRyM1smG189SqCRB9E1eVnbwGIe0z3YpAy+TUsVBU/Qzaq2TX3lLMuUDfI2SSMIdTlNfKMJHQFQxA==
X-Received: by 2002:a5d:6dae:0:b0:21d:ac34:d087 with SMTP id u14-20020a5d6dae000000b0021dac34d087mr2584531wrs.336.1657706973656;
        Wed, 13 Jul 2022 03:09:33 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id q19-20020a1ce913000000b003a2cf5eb900sm1572920wmc.40.2022.07.13.03.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 03:09:33 -0700 (PDT)
Date:   Wed, 13 Jul 2022 11:09:31 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <Ys6Z2/ypEiBfeCrv@debian>
References: <20220712183238.844813653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
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

On Tue, Jul 12, 2022 at 08:38:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1508
[2]. https://openqa.qa.codethink.co.uk/tests/1511
[3]. https://openqa.qa.codethink.co.uk/tests/1514

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
