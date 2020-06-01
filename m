Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA011EA74C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 17:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgFAPsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgFAPst (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 11:48:49 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19845C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 08:48:49 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q2so8687489ljm.10
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 08:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JIM+ze6UHeFG73cHEmOqN2LyuGsU5Np8xVHZh05eXvM=;
        b=WCcLfFAiID7qGjcS6sCz+DAgXoQB2IVI64EBqzssoSTLTpjQHxlQ69L0yIN142lcRd
         +rjQQ97iyHbUkGZortfcQRcw/gj+sBzEuCYKfQOE2So9GImchnaR1SoMli59YSp6RgqN
         7oeDkvGh3oELzk7mvGXI8lluYn/2YjE16XUmBhnw5uCYwTjhxbVyAuaFbvcvfX24LwZr
         gRbuhno5EIKEDkDVX7X4VMvFqM/qmlFLE8+Qqt1ixk9O2YNHL9n5ybxFRKOXlIcrp3Ab
         nOdYkPpGpiwj6w2I7VDTQzY0/AoNlbTzjDqLO169PdZznwtUhStFziELpHX9AXyRlhKS
         6rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JIM+ze6UHeFG73cHEmOqN2LyuGsU5Np8xVHZh05eXvM=;
        b=D4mBy1Leu1LWwpBihDkZ1J6hsxIWeKeeSLKWeFB7h5V70qGgv/0XvzeVh+Fj827cBB
         aVj/4quhWzaqnrUiQxWjb3eG+6KeOmBmJc/XixU1ncY/z/yq0tasRMWTm7Rn7mNMQE98
         yJWYnTp9zr2Ae9rygORrDY6CV754hE1rdrarLxygpktqWBE30TO31nqBYsovDxq0B4B0
         d/IzD9Si9mDcT9MCgovFE0h7R6YIKawM/T1iPYk0pmrejO0C/2xQAzWF/a5bLfUtKtYc
         wKRNqdFwIvkARDuepdHxzIzyRKFc+NrzT8jTLqik7ffrneFvdyQUWu1cSZR+paVZo5R6
         K7Kg==
X-Gm-Message-State: AOAM5331ws/oDBJNera0j/xbh+zlYiXTeY1J0uui/b92hePqrYkTT5JF
        TUuRs/PAS8665YKWA6x909PmCIjMYl0BslsDs1L7tg==
X-Google-Smtp-Source: ABdhPJybr1LwQQs3PkFjTj3IJwDae7QTH2dBrwwrumDJe4CTyw2yoKGblLOmF0XbYFMRE2y7oPcNxbDrv15AplUggOY=
X-Received: by 2002:a2e:9684:: with SMTP id q4mr11144139lji.431.1591026527353;
 Mon, 01 Jun 2020 08:48:47 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Jun 2020 21:18:34 +0530
Message-ID: <CA+G9fYuwMbm2NUmSLohbUs+KzKcyY9rC0dc4kh9AD9hJi6+ePw@mail.gmail.com>
Subject: stable-rc 4.9: arm: arch/arm/vfp/vfphw.S:158: Error: bad instruction
 `ldcleq p11,cr0,[r10],#32*4'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org, rmk+kernel@armlinux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 4.9 arm architecture build failed due to
following errors,

# make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
arm-linux-gnueabihf-gcc" O=build zImage
#
../arch/arm/vfp/vfphw.S: Assembler messages:
../arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],#32*4'
../arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#32*4'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/vfp/vfphw.o] Error 1
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1040: arch/arm/vfp] Error 2
../arch/arm/lib/changebit.S: Assembler messages:
../arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/changebit.o] Error 1
../arch/arm/lib/clear_user.S: Assembler messages:
../arch/arm/lib/clear_user.S:33: Error: bad instruction `strbal r2,[r0],#1'
../arch/arm/lib/clear_user.S:34: Error: bad instruction `strble r2,[r0],#1'
../arch/arm/lib/clear_user.S:35: Error: bad instruction `strblt r2,[r0],#1'
../arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'
../arch/arm/lib/clear_user.S:44: Error: bad instruction `strbne r2,[r0],#1'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/clear_user.o] Error 1
../arch/arm/lib/clearbit.S: Assembler messages:
../arch/arm/lib/clearbit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/clearbit.o] Error 1
../arch/arm/lib/copy_from_user.S: Assembler messages:
../arch/arm/lib/copy_from_user.S:96: Error: bad instruction `subshs ip,ip,r2'
../arch/arm/lib/copy_template.S:168: Error: bad instruction `ldrbne r3,[r1],#1'
../arch/arm/lib/copy_template.S:169: Error: bad instruction `ldrbcs r4,[r1],#1'
../arch/arm/lib/copy_template.S:170: Error: bad instruction `ldrbcs ip,[r1],#1'
../arch/arm/lib/copy_template.S:179: Error: bad instruction `ldrbgt r3,[r1],#1'
../arch/arm/lib/copy_template.S:180: Error: bad instruction `ldrbge r4,[r1],#1'
../arch/arm/lib/copy_template.S:181: Error: bad instruction `ldrbal lr,[r1],#1'
make[2]: *** [../scripts/Makefile.build:404:
arch/arm/lib/copy_from_user.o] Error 1
../arch/arm/lib/copy_to_user.S: Assembler messages:
../arch/arm/lib/copy_to_user.S:100: Error: bad instruction `subshs ip,ip,r2'
../arch/arm/lib/copy_template.S:171: Error: bad instruction `strbne r3,[r0],#1'
../arch/arm/lib/copy_template.S:172: Error: bad instruction `strbcs r4,[r0],#1'
../arch/arm/lib/copy_template.S:173: Error: bad instruction `strbcs ip,[r0],#1'
../arch/arm/lib/copy_template.S:182: Error: bad instruction `strbgt r3,[r0],#1'
../arch/arm/lib/copy_template.S:183: Error: bad instruction `strbge r4,[r0],#1'
../arch/arm/lib/copy_template.S:185: Error: bad instruction `strbal lr,[r0],#1'
make[2]: *** [../scripts/Makefile.build:404:
arch/arm/lib/copy_to_user.o] Error 1
../arch/arm/lib/csumpartialcopygeneric.S: Assembler messages:
../arch/arm/lib/csumpartialcopygeneric.S:39: Error: bad instruction
`ldrbal ip,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:46: Error: bad instruction
`ldrbal r8,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:46: Error: bad instruction
`ldrbal ip,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:66: Error: bad instruction
`ldrbal ip,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:73: Error: bad instruction
`ldrbal r8,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:73: Error: bad instruction
`ldrbal ip,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:85: Error: bad instruction
`ldrbal r8,[r0],#1'
../arch/arm/lib/csumpartialcopygeneric.S:277: Error: bad instruction
`ldrbal r5,[r0],#1'
make[2]: *** [../scripts/Makefile.build:404:
arch/arm/lib/csumpartialcopyuser.o] Error 1
../arch/arm/lib/getuser.S: Assembler messages:
../arch/arm/lib/getuser.S:36: Error: bad instruction `sbcscc r2,r2,r1'
../arch/arm/lib/getuser.S:44: Error: bad instruction `sbcscc r2,r2,r1'
../arch/arm/lib/getuser.S:74: Error: bad instruction `sbcscc r2,r2,r1'
../arch/arm/lib/getuser.S:82: Error: bad instruction `sbcscc r2,r2,r1'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/getuser.o] Error 1
../arch/arm/lib/putuser.S: Assembler messages:
../arch/arm/lib/putuser.S:36: Error: bad instruction `sbcscc ip,ip,r1'
../arch/arm/lib/putuser.S:43: Error: bad instruction `sbcscc ip,ip,r1'
../arch/arm/lib/putuser.S:65: Error: bad instruction `sbcscc ip,ip,r1'
../arch/arm/lib/putuser.S:72: Error: bad instruction `sbcscc ip,ip,r1'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/putuser.o] Error 1
../arch/arm/lib/setbit.S: Assembler messages:
../arch/arm/lib/setbit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/setbit.o] Error 1
../arch/arm/lib/testchangebit.S: Assembler messages:
../arch/arm/lib/testchangebit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404:
arch/arm/lib/testchangebit.o] Error 1
../arch/arm/lib/testclearbit.S: Assembler messages:
../arch/arm/lib/testclearbit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404:
arch/arm/lib/testclearbit.o] Error 1
../arch/arm/lib/testsetbit.S: Assembler messages:
../arch/arm/lib/testsetbit.S:15: Error: bad instruction `strbne r1,[ip]'
make[2]: *** [../scripts/Makefile.build:404: arch/arm/lib/testsetbit.o] Error 1
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1040: arch/arm/lib] Error 2
make[1]: Target 'zImage' not remade because of errors.
make: *** [Makefile:152: sub-make] Error 2
make: Target 'zImage' not remade because of errors.

-- 
Linaro LKFT
https://lkft.linaro.org
