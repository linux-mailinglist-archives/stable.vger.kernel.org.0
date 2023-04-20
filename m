Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB596E98A6
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjDTPpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjDTPpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:45:20 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AADF49E4
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:45:12 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-2468495aad8so725753a91.3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682005511; x=1684597511;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vlGkJaI+leRFOg0avJK9zy7ubKrT3yqSF7Ap4LTwxCw=;
        b=bepEeTU76KUVdetZE5iK+c08BfbQe5iKd/XuwzvGnNtxb8WYlsBUK9cxdUbCu4Yr54
         I+DwiZaztUi0nXaZqUszDC9vZIUL62aq7r9w0jZY4crOUtlz/Ckw/GN6hseDm06MZIq4
         G4tbHS1bbK5l2COs5dqAChW+R3xpdOxphBkXOF1fFdpsE4rDUPJTrBGQF9/OHiTXipVf
         UBz77sC94albUm6jEpvISRoZnP3anT+JdRE+LYKwvKy3Js5/2hSustUd1bu0XkzIasit
         moLQLtZ5R0WpwWSBQddCYyb6DuDZtmmC5GJX7mPjhjZuJ7c6zZ60weubtQqDQJ1HjfXW
         T2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682005511; x=1684597511;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlGkJaI+leRFOg0avJK9zy7ubKrT3yqSF7Ap4LTwxCw=;
        b=ENPWBOTdgRao8P14sMHHqIyP/A2+RdzKq6Qp75dlbSzmNBn9IzO7uaW4u1+S6o/FLj
         xWCfWU7xL6fx2uy2YyFIi9Z3PxWX2Ntd03mkv3JYwfcIyKa1EXfUxmUdp4XffZiKPTdu
         nxCGN4cZfULTmW1Ph0lPXYuGvqyCSsq6YFr6j1ZNxxYV7Zpu1rpkFvJ4JAWlRzc+opZn
         3iZZNOakuBEee8cY5sr3N6YcD1evMp7xzjSJNBegRQr2pV/7VicKvLcKPOJkZaffNVys
         pKp+gJwyZb3aVrTXRu4DVB+7kWnlhOL+dl7i3a4oX6jyJfBM2dJH/WOc5jImSVmQTub6
         PRCg==
X-Gm-Message-State: AAQBX9dyynvVMq5uAEK4hB35BH9T2gdxipwV8GUEMOtpAhZwRFdL0ttc
        XNCzVh1Mo/u5pLf8QgkFmPCtxwzR1GobSy+L2xzKjMGk
X-Google-Smtp-Source: AKy350YmKOiM9dw1Fsr/JARV4lKN/GLPkxE9l1393nsaZ+sLaz4Ul9sFFBA/hv55H/PbdPx7CNabEg==
X-Received: by 2002:a17:90a:f318:b0:246:b8a5:b702 with SMTP id ca24-20020a17090af31800b00246b8a5b702mr2096424pjb.29.1682005511358;
        Thu, 20 Apr 2023 08:45:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020a17090ace1500b002469a865810sm3200160pju.28.2023.04.20.08.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:45:11 -0700 (PDT)
Message-ID: <64415e07.170a0220.c9a70.7a89@mx.google.com>
Date:   Thu, 20 Apr 2023 08:45:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.108
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: build
Subject: stable/linux-5.15.y build: 14 builds: 0 failed, 14 passed,
 18 warnings (v5.15.108)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "chromeos.kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y build: 14 builds: 0 failed, 14 passed, 18 warnings (v5.=
15.108)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.15.y/k=
ernel/v5.15.108/

Tree: stable
Branch: linux-5.15.y
Git Describe: v5.15.108
Git Commit: 3299fb36854fdc288bddc2c4d265f8a2e5105944
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 3 unique architectures

Warnings Detected:

arm64:

arm:
    cros://chromeos-5.15/armel/chromiumos-arm.flavour.config (clang-14): 6 =
warnings
    cros://chromeos-5.15/armel/chromiumos-rockchip.flavour.config (clang-14=
): 6 warnings

x86_64:
    cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour.config+x86=
-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (clang-14): 1 warning
    cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour.config+x86=
-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (clang-14): 1 warning
    cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config (clang-14)=
: 1 warning
    cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config+x86-chrome=
book (clang-14): 1 warning
    cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config+x86-chrome=
book+CONFIG_MODULE_COMPRESS_GZIP=3Dn (clang-14): 1 warning
    x86_64_defconfig+x86-chromebook (clang-14): 1 warning


Warnings summary:

    12   clang: warning: argument unused during compilation: '-march=3Darmv=
7-a' [-Wunused-command-line-argument]
    6    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unr=
eachable instruction

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/arm64/chromiumos-arm64.flavour.config (arm64, clang-14=
) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/arm64/chromiumos-arm64.flavour.config+arm64-chromebook=
 (arm64, clang-14) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/arm64/chromiumos-mediatek.flavour.config+arm64-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 err=
ors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/arm64/chromiumos-qualcomm.flavour.config+arm64-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 err=
ors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/arm64/chromiumos-rockchip64.flavour.config+arm64-chrom=
ebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 e=
rrors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/armel/chromiumos-arm.flavour.config (arm, clang-14) =
=E2=80=94 PASS, 0 errors, 6 warnings, 0 section mismatches

Warnings:
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/armel/chromiumos-rockchip.flavour.config (arm, clang-1=
4) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section mismatches

Warnings:
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]
    clang: warning: argument unused during compilation: '-march=3Darmv7-a' =
[-Wunused-command-line-argument]

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, =
0 errors, 1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/x86_64/chromeos-intel-denverton.flavour.config+x86-chr=
omebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, =
0 errors, 1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config (x86_64, clang=
-14) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config+x86-chromebook=
 (x86_64, clang-14) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mismatch=
es

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
cros://chromeos-5.15/x86_64/chromiumos-x86_64.flavour.config+x86-chromebook=
+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, 0 error=
s, 1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, clang-14) =E2=80=94 PASS, 0 errors, 0 wa=
rnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, clang-14) =E2=80=94 PASS, 0 errors=
, 1 warning, 0 section mismatches

Warnings:
    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x43: unreacha=
ble instruction

---
For more info write to <info@kernelci.org>
