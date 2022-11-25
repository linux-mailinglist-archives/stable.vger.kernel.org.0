Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042B8639087
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKYUJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 15:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKYUJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 15:09:09 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8505220EB
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 12:09:05 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a16so4587933pfg.4
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 12:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WdmetdPnND7hrmpWLxo46BI5KB1JtLg1kDLd07opCwQ=;
        b=GQ3t6pUcHmFKrmUqsW1zkwUBcOJ1DVKMhOxTsKBA6cmmKZZDvxAVrJWilzuYhElkb4
         MelxhHUVaM/hDTgiaSOBJddIGLs9z3ojzQo85BblIuu+qBgQqBTu7Fq+X1bKY2naSXd/
         Y5cTMlWVeiP7byi5tlWSINcc4yNtIDOx4MjYSf0XzAl64wVyKLDTByLZL11UytP6XmtG
         TZNyPgnbLUKzZske9GkpVWLl8ytF/MvY2ikDhI+ItGSv140ywlX+OOgV1x08mR3WMg1g
         Mbw+TUOg+gr7O/HY67IBkYXwEvJApToy69oE8rbHxYk0mtehPtpEZk5ld/ukWh00nJrB
         bfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdmetdPnND7hrmpWLxo46BI5KB1JtLg1kDLd07opCwQ=;
        b=cYSwmYuHk++lR0Y1obbT9D1Cbd1gwShuYgi/J4GS6btKYf10zdqFHqGCJH1vmjp/sQ
         At2TEby9ffPt0r/NlWIm9UYdeyiBjQAdGPepL9obFPfAxrhukXmGlhpQ9jlnmicYrGJ5
         7/QNfv0k28ffn2r+sKf6u5dmR6SB5j+rL7D5Qo4O/2wv0gtOTBvu3VPYMGZH6ErZIGmr
         ci4QJ9Nzwqs1FVFsDKhT3zyBy55G5UMHbbzfuMfub34kTFNsQFK0tXwsgCTO0S6q7YPM
         tst6q9M6NZnX/Bz3ZP2nXTR22FlX+pgVCRbtgKECN7xK6F5rCsZlFhp8q3W9OJx75JJz
         84+g==
X-Gm-Message-State: ANoB5pkbxECapYT6ZCR2y/OL/EypsRGRXk6nd232LLl57uRUrnLUEPPR
        cVEz7czPeqjqxxCgI2vGLPORiYbjMJWjE73oUT4=
X-Google-Smtp-Source: AA0mqf6SyoSE4lJSFn5LgC/ZlZwQ9OVN/B71zPf8oVDqdM7cyrWDw9KQd9u8rSXGmif9vZX8pO2zrw==
X-Received: by 2002:a63:180a:0:b0:470:63e5:5c59 with SMTP id y10-20020a63180a000000b0047063e55c59mr17045300pgl.172.1669406943717;
        Fri, 25 Nov 2022 12:09:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020aa7940c000000b00550724f8ea0sm3446903pfo.128.2022.11.25.12.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 12:09:02 -0800 (PST)
Message-ID: <638120de.a70a0220.1f1a3.49c4@mx.google.com>
Date:   Fri, 25 Nov 2022 12:09:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.155-182-g2b702941bf8a
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 build: 185 builds: 6 failed, 179 passed,
 367 errors, 12 warnings (v5.10.155-182-g2b702941bf8a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 185 builds: 6 failed, 179 passed, 367 errors, 1=
2 warnings (v5.10.155-182-g2b702941bf8a)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.155-182-g2b702941bf8a/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.155-182-g2b702941bf8a
Git Commit: 2b702941bf8a64bc89b778e203dc5c462018b8de
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL

arm:
    multi_v7_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:
    defconfig (gcc-10): 121 errors, 1 warning
    defconfig+arm64-chromebook (gcc-10): 121 errors, 1 warning

arm:
    multi_v7_defconfig (gcc-10): 121 errors, 1 warning
    rpc_defconfig (gcc-10): 4 errors

i386:

mips:
    32r2el_defconfig (gcc-10): 1 warning
    decstation_64_defconfig (gcc-10): 1 warning
    decstation_defconfig (gcc-10): 1 warning
    decstation_r4k_defconfig (gcc-10): 1 warning
    rm200_defconfig (gcc-10): 1 warning

riscv:
    rv32_defconfig (gcc-10): 4 warnings

x86_64:

Errors summary:

    3    drivers/pinctrl/pinctrl-rockchip.c:959:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:958:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:957:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:956:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:955:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:951:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:950:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:949:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:948:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:947:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:946:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:945:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:944:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:943:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:942:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:941:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:940:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:936:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:935:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:934:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:933:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:932:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:931:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:930:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:929:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:928:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:927:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:926:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:925:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:924:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:923:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:922:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:921:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:920:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:919:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:918:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:917:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:916:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:915:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:914:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:913:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:912:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:911:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:907:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:906:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:902:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:901:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:900:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:899:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:898:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:897:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:896:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:895:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:894:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:893:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:892:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:891:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:890:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:889:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:888:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:887:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:886:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:885:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:881:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:880:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:876:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:875:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:874:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:873:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:872:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:871:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:870:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:866:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:865:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:864:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:863:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:862:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:861:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:860:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:859:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:858:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:857:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:856:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:855:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:854:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:853:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:852:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:851:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:850:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:849:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:848:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:847:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:846:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:845:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:844:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:843:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:842:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:841:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:840:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:839:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:838:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:837:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:836:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:835:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:834:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:833:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:832:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:831:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:830:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:829:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:828:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:827:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:826:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:825:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:824:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:823:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:822:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:821:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:820:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: initializer eleme=
nt is not constant
    3    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: implicit declarat=
ion of function =E2=80=98RK_MUXROUTE_SAME=E2=80=99 [-Werror=3Dimplicit-func=
tion-declaration]
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    3    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    3    cc1: some warnings being treated as errors
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): S=
ection mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to=
 the function .init.text:ixp4xx_irq_init()
    1    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0):=
 Section mismatch in reference from the variable __ksymtab_prom_init_numa_m=
emory to the function .init.text:prom_init_numa_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

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
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 121 errors, 1 warning, 0 section =
mismatches

Errors:
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: implicit declaration o=
f function =E2=80=98RK_MUXROUTE_SAME=E2=80=99 [-Werror=3Dimplicit-function-=
declaration]
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:820:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:821:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:822:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:823:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:824:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:825:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:826:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:827:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:828:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:829:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:830:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:831:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:832:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:833:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:834:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:835:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:836:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:837:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:838:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:839:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:840:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:841:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:842:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:843:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:844:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:845:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:846:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:847:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:848:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:849:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:850:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:851:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:852:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:853:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:854:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:855:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:856:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:857:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:858:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:859:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:860:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:861:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:862:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:863:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:864:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:865:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:866:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:870:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:871:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:872:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:873:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:874:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:875:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:876:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:880:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:881:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:885:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:886:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:887:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:888:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:889:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:890:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:891:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:892:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:893:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:894:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:895:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:896:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:897:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:898:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:899:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:900:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:901:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:902:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:906:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:907:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:911:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:912:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:913:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:914:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:915:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:916:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:917:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:918:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:919:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:920:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:921:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:922:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:923:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:924:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:925:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:926:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:927:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:928:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:929:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:930:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:931:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:932:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:933:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:934:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:935:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:936:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:940:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:941:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:942:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:943:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:944:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:945:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:946:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:947:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:948:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:949:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:950:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:951:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:955:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:956:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:957:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:958:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:959:2: error: initializer element is=
 not constant

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 121 errors, 1 wa=
rning, 0 section mismatches

Errors:
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: implicit declaration o=
f function =E2=80=98RK_MUXROUTE_SAME=E2=80=99 [-Werror=3Dimplicit-function-=
declaration]
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:820:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:821:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:822:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:823:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:824:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:825:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:826:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:827:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:828:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:829:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:830:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:831:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:832:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:833:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:834:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:835:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:836:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:837:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:838:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:839:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:840:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:841:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:842:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:843:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:844:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:845:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:846:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:847:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:848:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:849:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:850:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:851:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:852:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:853:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:854:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:855:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:856:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:857:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:858:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:859:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:860:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:861:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:862:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:863:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:864:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:865:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:866:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:870:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:871:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:872:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:873:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:874:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:875:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:876:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:880:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:881:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:885:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:886:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:887:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:888:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:889:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:890:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:891:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:892:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:893:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:894:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:895:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:896:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:897:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:898:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:899:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:900:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:901:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:902:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:906:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:907:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:911:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:912:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:913:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:914:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:915:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:916:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:917:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:918:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:919:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:920:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:921:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:922:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:923:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:924:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:925:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:926:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:927:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:928:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:929:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:930:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:931:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:932:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:933:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:934:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:935:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:936:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:940:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:941:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:942:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:943:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:944:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:945:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:946:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:947:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:948:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:949:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:950:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:951:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:955:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:956:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:957:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:958:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:959:2: error: initializer element is=
 not constant

Warnings:
    cc1: some warnings being treated as errors

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
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

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

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
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

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
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

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
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 121 errors, 1 warning, 0 s=
ection mismatches

Errors:
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: implicit declaration o=
f function =E2=80=98RK_MUXROUTE_SAME=E2=80=99 [-Werror=3Dimplicit-function-=
declaration]
    drivers/pinctrl/pinctrl-rockchip.c:819:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:820:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:821:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:822:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:823:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:824:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:825:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:826:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:827:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:828:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:829:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:830:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:831:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:832:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:833:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:834:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:835:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:836:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:837:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:838:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:839:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:840:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:841:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:842:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:843:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:844:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:845:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:846:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:847:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:848:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:849:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:850:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:851:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:852:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:853:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:854:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:855:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:856:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:857:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:858:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:859:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:860:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:861:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:862:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:863:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:864:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:865:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:866:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:870:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:871:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:872:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:873:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:874:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:875:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:876:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:880:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:881:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:885:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:886:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:887:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:888:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:889:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:890:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:891:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:892:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:893:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:894:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:895:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:896:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:897:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:898:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:899:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:900:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:901:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:902:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:906:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:907:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:911:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:912:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:913:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:914:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:915:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:916:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:917:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:918:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:919:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:920:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:921:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:922:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:923:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:924:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:925:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:926:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:927:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:928:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:929:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:930:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:931:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:932:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:933:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:934:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:935:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:936:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:940:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:941:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:942:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:943:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:944:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:945:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:946:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:947:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:948:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:949:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:950:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:951:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:955:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:956:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:957:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:958:2: error: initializer element is=
 not constant
    drivers/pinctrl/pinctrl-rockchip.c:959:2: error: initializer element is=
 not constant

Warnings:
    cc1: some warnings being treated as errors

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
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

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
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

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
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
