Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336914F1817
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 17:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378477AbiDDPSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 11:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378492AbiDDPR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 11:17:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C4F2C137
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 08:15:59 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p17so8397818plo.9
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xie40pQLk8aPuXBi+0cILBXAp1n1HoWXmDYje7JDQb8=;
        b=F4SFpKf8bornnU96X9Bs+upLbo6m7SxdZp3XutzVS+64KxOCANGlopR7cm3e2v75GY
         jfBli0wVvjUoKaE8ygOu9mFKNxxcLadMyvQ6VkdkAG8Cj5lhJoKGmUk6PBe+6AKCm9at
         KOsKOIJWfMaKSm3Ozh8IDxJZyDJ8M2ijI6rtqObrRFq6sLd1ydCur3RbxGQXyyAQ4eb5
         mdx42iPIqC837SyJ1vCYf/Cm8FbNHJymBhFhId5rIPCPSXQSct9hyuLzHFcekSk+gyZE
         kvmQIcxegHC5ucqHrPAEAdzeUwh3jx3HQZe4dtkKUgmO6XStM0xLzkDUyL+u0bQOX/Bo
         Ex/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xie40pQLk8aPuXBi+0cILBXAp1n1HoWXmDYje7JDQb8=;
        b=Sm/JCWfWbsipoUhjTenxAAqeW/3x6tE/uJthB7AmLal5XDgz0vG2dIqyCFr5WxbWqw
         J/oGdfpLI7vxtoKdibzpiNfAXI1I76OgxUcyg6MnfKuWvUZziNuvoOwZYb0Y3MQxgZoC
         ircOD/DSPhGIgBWFvnYT2Cv4OzbaSysfFDfLNVglQdDHhshzlH0tsmNgKYuc24eM+DEL
         Hr+cRK3OfIoNGiHZR9hIsEDwDJp7sRRR+4JaNFJLcdK7QijJUGkO3AKCTcZ1oLQiQxlI
         3oPuIFGX+olGPhVcXExtwJZyD7jzNLiOa+TZJEW29gXD1cQFwjuKJQJtxnhdFVvT0eNS
         +6Eg==
X-Gm-Message-State: AOAM530TQKI8oRgXex91Z6ZLtnx1xsAgKzIOdBu1kyAsB535LO+vzyr3
        PbOslw0D259JLLAKJ+WhSIXproF9u6bkn4BqVh8=
X-Google-Smtp-Source: ABdhPJycOYPjzlzYQwdB4ZGsRgIUPfOJTZm9/yfK5egpuh6tz/C3WaiFFzwmUQpfZz0qDtQDJOVWfA==
X-Received: by 2002:a17:90a:d154:b0:1c6:64a5:a413 with SMTP id t20-20020a17090ad15400b001c664a5a413mr27275704pjw.6.1649085357053;
        Mon, 04 Apr 2022 08:15:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2-20020a63aa42000000b0038265eb2495sm10764177pgo.88.2022.04.04.08.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 08:15:56 -0700 (PDT)
Message-ID: <624b0bac.1c69fb81.80f04.b691@mx.google.com>
Date:   Mon, 04 Apr 2022 08:15:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237-257-g4e89415127311
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.19.y build: 204 builds: 20 failed, 184 passed,
 525 errors, 50 warnings (v4.19.237-257-g4e89415127311)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 204 builds: 20 failed, 184 passed, 525 errors=
, 50 warnings (v4.19.237-257-g4e89415127311)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.237-257-g4e89415127311/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.237-257-g4e89415127311
Git Commit: 4e89415127311b78dfd058c48dd87e92ab4e2c0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

arm64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

arm:
    allnoconfig: (gcc-10) FAIL
    mps2_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    xcep_defconfig: (gcc-10) FAIL

i386:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

mips:
    allnoconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

riscv:
    allnoconfig: (gcc-10) FAIL
    defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 18 errors
    tinyconfig (gcc-10): 18 errors

arm64:
    allnoconfig (gcc-10): 22 errors
    defconfig (gcc-10): 3 warnings
    defconfig+arm64-chromebook (gcc-10): 3 warnings
    tinyconfig (gcc-10): 34 errors

arm:
    allnoconfig (gcc-10): 26 errors
    mps2_defconfig (gcc-10): 40 errors
    omap1_defconfig (gcc-10): 1 warning
    rpc_defconfig (gcc-10): 2 errors
    tinyconfig (gcc-10): 40 errors
    xcep_defconfig (gcc-10): 20 errors

i386:
    allnoconfig (gcc-10): 44 errors, 3 warnings
    i386_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 43 errors, 3 warnings

mips:
    allnoconfig (gcc-10): 26 errors
    lemote2f_defconfig (gcc-10): 1 warning
    loongson3_defconfig (gcc-10): 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 warning
    mtx1_defconfig (gcc-10): 3 warnings
    nlm_xlp_defconfig (gcc-10): 1 warning
    tinyconfig (gcc-10): 26 errors

riscv:
    allnoconfig (gcc-10): 54 errors
    tinyconfig (gcc-10): 54 errors

x86_64:
    allnoconfig (gcc-10): 29 errors, 11 warnings
    tinyconfig (gcc-10): 29 errors, 11 warnings
    x86_64_defconfig (gcc-10): 3 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 3 warnings

Errors summary:

    172  include/linux/blk-mq.h:309:20: error: invalid use of undefined typ=
e =E2=80=98struct request=E2=80=99
    35   include/linux/blk-mq.h:337:5: error: invalid use of undefined type=
 =E2=80=98struct request=E2=80=99
    35   include/linux/blk-mq.h:336:8: error: invalid use of undefined type=
 =E2=80=98struct request=E2=80=99
    35   include/linux/blk-mq.h:323:12: error: invalid use of undefined typ=
e =E2=80=98struct request=E2=80=99
    35   include/linux/blk-mq.h:319:22: error: invalid application of =E2=
=80=98sizeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    35   include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=
=80=99 undeclared (first use in this function)
    35   include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=
=80=99 undeclared (first use in this function)
    35   include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98so=
ftirq_done_fn=E2=80=99
    10   include/asm-generic/atomic-instrumented.h:421:37: error: invalid t=
ype argument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    10   arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument=
 of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    10   arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument=
 of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    10   arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument=
 of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    10   arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argumen=
t of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    8    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 =
has incomplete type
    8    include/linux/blk-mq.h:309:20: error: invalid use of undefined typ=
e 'struct request'
    6    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argum=
ent of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    6    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argum=
ent of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    4    include/linux/blk-mq.h:337:5: error: invalid use of undefined type=
 'struct request'
    4    include/linux/blk-mq.h:336:8: error: invalid use of undefined type=
 'struct request'
    4    include/linux/blk-mq.h:323:12: error: invalid use of undefined typ=
e 'struct request'
    4    include/linux/blk-mq.h:319:22: error: invalid application of 'size=
of' to incomplete type 'struct request'
    4    include/linux/blk-mq.h:309:46: error: 'MQ_RQ_COMPLETE' undeclared =
(first use in this function)
    4    include/linux/blk-mq.h:309:29: error: 'MQ_RQ_IN_FLIGHT' undeclared=
 (first use in this function)
    4    include/linux/blk-mq.h:145:2: error: unknown type name 'softirq_do=
ne_fn'
    1    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    1    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    10   include/asm-generic/atomic-instrumented.h:421:20: warning: passing=
 argument 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integ=
er without a cast [-Wint-conversion]
    6    aarch64-linux-gnu-ld: warning: -z norelro ignored
    4    arch/x86/include/asm/cmpxchg.h:93:24: warning: cast to pointer fro=
m integer of different size [-Wint-to-pointer-cast]
    4    arch/x86/include/asm/cmpxchg.h:120:25: warning: cast to pointer fr=
om integer of different size [-Wint-to-pointer-cast]
    4    arch/x86/include/asm/cmpxchg.h:111:25: warning: cast to pointer fr=
om integer of different size [-Wint-to-pointer-cast]
    4    arch/x86/include/asm/cmpxchg.h:102:25: warning: cast to pointer fr=
om integer of different size [-Wint-to-pointer-cast]
    4    arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic s=
uffix given and no register operands; using default for `sysret'
    3    ld: warning: creating DT_TEXTREL in a PIE
    2    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    2    net/core/rtnetlink.c:3199:1: warning: the frame size of 1328 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in rea=
d-only section `.head.text'
    1    {standard input}:132: Warning: macro instruction expanded into mul=
tiple instructions
    1    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    net/core/rtnetlink.c:3199:1: warning: the frame size of 1344 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in rea=
d-only section `.head.text'
    1    drivers/gpio/gpio-omap.c:1233:34: warning: array =E2=80=98omap_gpi=
o_match=E2=80=99 assumed to have one element

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-10) =E2=80=94 FAIL, 26 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-10) =E2=80=94 FAIL, 54 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-10) =E2=80=94 FAIL, 22 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 FAIL, 18 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name 'softirq_done_fn'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:29: error: 'MQ_RQ_IN_FLIGHT' undeclared (fir=
st use in this function)
    include/linux/blk-mq.h:309:46: error: 'MQ_RQ_COMPLETE' undeclared (firs=
t use in this function)
    include/linux/blk-mq.h:319:22: error: invalid application of 'sizeof' t=
o incomplete type 'struct request'
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:145:2: error: unknown type name 'softirq_done_fn'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:29: error: 'MQ_RQ_IN_FLIGHT' undeclared (fir=
st use in this function)
    include/linux/blk-mq.h:309:46: error: 'MQ_RQ_COMPLETE' undeclared (firs=
t use in this function)
    include/linux/blk-mq.h:319:22: error: invalid application of 'sizeof' t=
o incomplete type 'struct request'
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type 'str=
uct request'

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 29 errors, 11 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

Warnings:
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    arch/x86/include/asm/cmpxchg.h:93:24: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:102:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:111:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:120:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    arch/x86/include/asm/cmpxchg.h:93:24: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:102:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:111:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:120:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 44 errors, 3 warnings, 0 section=
 mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

Warnings:
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section m=
ismatches

Warnings:
    aarch64-linux-gnu-ld: warning: -z norelro ignored
    aarch64-linux-gnu-ld: warning: -z norelro ignored
    aarch64-linux-gnu-ld: warning: -z norelro ignored

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 3 warn=
ings, 0 section mismatches

Warnings:
    aarch64-linux-gnu-ld: warning: -z norelro ignored
    aarch64-linux-gnu-ld: warning: -z norelro ignored
    aarch64-linux-gnu-ld: warning: -z norelro ignored

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/rtnetlink.c:3199:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/rtnetlink.c:3199:1: warning: the frame size of 1328 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    {standard input}:132: Warning: macro instruction expanded into multiple=
 instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 40 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/rtnetlink.c:3199:1: warning: the frame size of 1344 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/gpio/gpio-omap.c:1233:34: warning: array =E2=80=98omap_gpio_mat=
ch=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 43 errors, 3 warnings, 0 section =
mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

Warnings:
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 FAIL, 18 errors, 0 warnings, 0 section m=
ismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name 'softirq_done_fn'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:29: error: 'MQ_RQ_IN_FLIGHT' undeclared (fir=
st use in this function)
    include/linux/blk-mq.h:309:46: error: 'MQ_RQ_COMPLETE' undeclared (firs=
t use in this function)
    include/linux/blk-mq.h:319:22: error: invalid application of 'sizeof' t=
o incomplete type 'struct request'
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:145:2: error: unknown type name 'softirq_done_fn'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:309:29: error: 'MQ_RQ_IN_FLIGHT' undeclared (fir=
st use in this function)
    include/linux/blk-mq.h:309:46: error: 'MQ_RQ_COMPLETE' undeclared (firs=
t use in this function)
    include/linux/blk-mq.h:319:22: error: invalid application of 'sizeof' t=
o incomplete type 'struct request'
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type 'st=
ruct request'
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type 'str=
uct request'
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type 'str=
uct request'

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-10) =E2=80=94 FAIL, 40 errors, 0 warnings, 0 section m=
ismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-10) =E2=80=94 FAIL, 34 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 FAIL, 26 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 29 errors, 11 warnings, 0 secti=
on mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:62:18: error: field =E2=80=98kobj=E2=80=99 has i=
ncomplete type
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/asm-generic/atomic-instrumented.h:421:37: error: invalid type a=
rgument of unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:87:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/x86/include/asm/cmpxchg.h:88:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:89:13: error: invalid type argument of u=
nary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    arch/x86/include/asm/cmpxchg.h:149:34: error: invalid type argument of =
unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

Warnings:
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    arch/x86/include/asm/cmpxchg.h:93:24: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:102:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:111:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:120:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    include/asm-generic/atomic-instrumented.h:421:20: warning: passing argu=
ment 1 of =E2=80=98kasan_check_write=E2=80=99 makes pointer from integer wi=
thout a cast [-Wint-conversion]
    arch/x86/include/asm/cmpxchg.h:93:24: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:102:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:111:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]
    arch/x86/include/asm/cmpxchg.h:120:25: warning: cast to pointer from in=
teger of different size [-Wint-to-pointer-cast]

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-10) =E2=80=94 FAIL, 54 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    arch/riscv/include/asm/cmpxchg.h:326:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    arch/riscv/include/asm/cmpxchg.h:338:41: error: invalid type argument o=
f unary =E2=80=98*=E2=80=99 (have =E2=80=98int=E2=80=99)
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 s=
ection mismatches

Warnings:
    arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
3 warnings, 0 section mismatches

Warnings:
    arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 20 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:145:2: error: unknown type name =E2=80=98softirq=
_done_fn=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:309:29: error: =E2=80=98MQ_RQ_IN_FLIGHT=E2=80=99=
 undeclared (first use in this function)
    include/linux/blk-mq.h:309:46: error: =E2=80=98MQ_RQ_COMPLETE=E2=80=99 =
undeclared (first use in this function)
    include/linux/blk-mq.h:309:20: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:319:22: error: invalid application of =E2=80=98s=
izeof=E2=80=99 to incomplete type =E2=80=98struct request=E2=80=99
    include/linux/blk-mq.h:323:12: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:336:8: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99
    include/linux/blk-mq.h:337:5: error: invalid use of undefined type =E2=
=80=98struct request=E2=80=99

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
