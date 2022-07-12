Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0975571D32
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiGLOpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiGLOpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:45:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CF325C7F;
        Tue, 12 Jul 2022 07:45:02 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so11497840wra.5;
        Tue, 12 Jul 2022 07:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sa6iY3pzwir6onyo2+3SEdO5IslImquHb/B2ephjWNA=;
        b=LEESkbTjEcOU7bUoY8h448YndDqAvOl5l7XJabm8Ky5wETpujsDs2To2eLk/OT56a8
         bhuKg+K4NgHXhY8ZEf3EDlkZ1WWgwMle85E6unzgzKAyqYOwB3v+FD5w9CMywRY2PZv7
         PW5YkKBbuMNMSHpdc/SztIQHLluvga2JuHXZFyrFD3+gZ8jnC9wZjxnF1PGukc2KJodo
         1HgZFMSgqjgBqrDdYAD1Nc6t3Pyb8mmCm8db40asy3ZlnWWz673zGAhBoWThCZjf0afl
         NsXvdoq+uK91mgSGYizB5Yb5ZXoVhN0BiJshuK3jdcN0P0TRHRhODGTnGwJupXNDuNoi
         xZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sa6iY3pzwir6onyo2+3SEdO5IslImquHb/B2ephjWNA=;
        b=v0MNUL/On6JuX0pOTQYN+ef/0h02lzYKPug2Ppkd3Y59Si3udWdYI8XdY8M0/jMohI
         tqlezLz9xTI2gTfacnsfzznUSkir93o9Z3vmu23mTSLHiUjZl3wiDC/8u3JL/wsD/vfF
         t+ig/2va3zRAs4CP68P7OLwG8EP4G7dHNLgHj73lIDWQLndKw5xibU+yq9RmUP6R7ltA
         QEmCnCrpg6QzCCVnkpoGUUOcKK1KQ/BkN955LiUdqsEhsUmnhzYzs4cIRM3hZHNEZpHN
         n086ZW3wpOLFzuQNlEBzc4f7p7AtCd5xzBJX9UWa78GWa9yUY2PLBzMhXSdyNWmtv/9S
         yDbw==
X-Gm-Message-State: AJIora9+KIh0vX50b5jWChVXgBosBLDOQc6mmL2e3+Kyhm9Vpu2QYp99
        mPbMWLfX8LznUh35sU1OyRw=
X-Google-Smtp-Source: AGRyM1u9IqTISr1wyRgga0Wj5eYmfortujWr+8ZL/NhFS8z4Uf+MK9ThLDEiwzSF6wcgo4Oq15bSmw==
X-Received: by 2002:a5d:58cc:0:b0:21d:6919:7daf with SMTP id o12-20020a5d58cc000000b0021d69197dafmr22544454wrf.434.1657637101303;
        Tue, 12 Jul 2022 07:45:01 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d6244000000b0021d6e917442sm10180708wrv.72.2022.07.12.07.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:45:00 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:44:59 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/55] 5.10.130-rc1 review
Message-ID: <Ys2I6x4PlN6APY54@debian>
References: <20220711090541.764895984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.130 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1486
[2]. https://openqa.qa.codethink.co.uk/tests/1496


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
