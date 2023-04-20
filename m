Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0E6E994D
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjDTQNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 12:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjDTQNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 12:13:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F1D2D71
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 09:13:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-246bb512038so831447a91.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682007221; x=1684599221;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ErJwCiFRaebBlMm0EXBqU9oku24r0oI9ykdCPCR+n1Q=;
        b=tAeCueNA6jG9JUY+UUtwnfdqwHp8fxNB8My8AUGIrXEuyuDQOb3SDW6Sm5I3t0VLL2
         qC+gftdCy9bJmVRen7wNjCIKZ4j8hacpctMak9AXofgdWFJotpOhP/mcUNQ0kbPJ67kO
         epwiTfkL4PdjJD7Kf6x3m/WALMPNVHLKI4TPBqBOGwegBnXrNpa3LoRBnL01iFI4e624
         fTJblk3PXVB/dUgwkgdoqLkEWZIu25BvaplXtMHtyzRvXoeJ30KP7COCSaoRwGU1r7Xm
         0luYkV3do7yvOXeK+uvsThjoWEGOTkmIENbQV0ySkZVit8aKMm8uNJgttkq2SqPfynkW
         iXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682007221; x=1684599221;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ErJwCiFRaebBlMm0EXBqU9oku24r0oI9ykdCPCR+n1Q=;
        b=bODIZO+kYJGD4ixa+6GS0mVUlvXDVZk98FL2O0/oKtHdSfxR5xGUiE1+QxfTTeGSck
         EPFXVli0QKls1hoF5g7Yih4pyiJFI0YyRzJoZSkzOgdth7SUmFTtfexhAqQDifQIC3fN
         AXD+2fD6ydZ1CXzs2JkV83K3w4jIJn0E2gN5OFWBezpc5rowcxk6Ke78kzPOZjBkeTYg
         hXYUTjFYR+Kqv1tsrsFwM6rMnoCUQrJoT2GDug05mSlrcqVjIXjK8y029ScaFj3BpYMj
         nfxwVWRhi8KnX7zSIwv62Kax8OLrsFIQ3GITF2GvfcdoodJ8L/V+INZJOSWj0tNguZQ1
         sprw==
X-Gm-Message-State: AAQBX9fgmNVugC34HHpy4rnHFko6LQO7ynMTKfe6KBEPfhGfxBqlP7C8
        bp2qoXI27MKe8UhI7AwcXRnlRbalUuWX1+2uWj7vbcPY
X-Google-Smtp-Source: AKy350YlfJqMFRIrsj4CvHBnUVt0bj38tfvbIhUZvyUl2VWywYcY84M3SkxHAboZV/JXaZc4uAeT3A==
X-Received: by 2002:a17:90a:e7cf:b0:246:f710:4f01 with SMTP id kb15-20020a17090ae7cf00b00246f7104f01mr2063924pjb.35.1682007221565;
        Thu, 20 Apr 2023 09:13:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902740c00b001a6dc4f4a8csm1364582pll.73.2023.04.20.09.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:13:41 -0700 (PDT)
Message-ID: <644164b5.170a0220.ba0b3.2b96@mx.google.com>
Date:   Thu, 20 Apr 2023 09:13:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v6.1.25
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: build
Subject: stable/linux-6.1.y build: 15 builds: 0 failed, 15 passed,
 12 warnings (v6.1.25)
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

stable/linux-6.1.y build: 15 builds: 0 failed, 15 passed, 12 warnings (v6.1=
.25)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-6.1.y/ke=
rnel/v6.1.25/

Tree: stable
Branch: linux-6.1.y
Git Describe: v6.1.25
Git Commit: f17b0ab65d17988d5e6d6fe22f708ef3721080bf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 3 unique architectures

Warnings Detected:

arm64:

arm:
    cros://chromeos-6.1/armel/chromiumos-arm.flavour.config (clang-14): 6 w=
arnings
    cros://chromeos-6.1/armel/chromiumos-rockchip.flavour.config (clang-14)=
: 6 warnings

x86_64:


Warnings summary:

    12   clang: warning: argument unused during compilation: '-march=3Darmv=
7-a' [-Wunused-command-line-argument]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/arm64/chromiumos-arm64.flavour.config (arm64, clang-14)=
 =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/arm64/chromiumos-arm64.flavour.config+arm64-chromebook =
(arm64, clang-14) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/arm64/chromiumos-mediatek.flavour.config+arm64-chromebo=
ok+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 erro=
rs, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/arm64/chromiumos-qualcomm.flavour.config+arm64-chromebo=
ok+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 erro=
rs, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/arm64/chromiumos-rockchip64.flavour.config+arm64-chrome=
book+CONFIG_MODULE_COMPRESS_GZIP=3Dn (arm64, clang-14) =E2=80=94 PASS, 0 er=
rors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/armel/chromiumos-arm.flavour.config (arm, clang-14) =E2=
=80=94 PASS, 0 errors, 6 warnings, 0 section mismatches

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
cros://chromeos-6.1/armel/chromiumos-rockchip.flavour.config (arm, clang-14=
) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section mismatches

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
cros://chromeos-6.1/x86_64/chromeos-amd-stoneyridge.flavour.config+x86-chro=
mebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, 0=
 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/x86_64/chromeos-intel-denverton.flavour.config+x86-chro=
mebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, 0=
 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/x86_64/chromeos-intel-pineview.flavour.config+x86-chrom=
ebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, 0 =
errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config (x86_64, clang-=
14) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+x86-chromebook =
(x86_64, clang-14) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mismatch=
es

---------------------------------------------------------------------------=
-----
cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+x86-chromebook+=
CONFIG_MODULE_COMPRESS_GZIP=3Dn (x86_64, clang-14) =E2=80=94 PASS, 0 errors=
, 0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, clang-14) =E2=80=94 PASS, 0 errors, 0 wa=
rnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, clang-14) =E2=80=94 PASS, 0 errors=
, 0 warnings, 0 section mismatches

---
For more info write to <info@kernelci.org>
