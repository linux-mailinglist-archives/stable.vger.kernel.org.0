Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F461981E2
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgC3RGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 13:06:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46870 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgC3RGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 13:06:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id k191so8931097pgc.13
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 10:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EXIunz4+ppMl4siej9Q10IJWsOTU2zUJlW2Q47BFGIU=;
        b=0HWLzIOH4U7WCgXXv2//e5W4d+ckWJliILbBGYi7bNg6Z1zpYPngcZKp5s71lSAKJw
         FjTjiVaVsvmeYRmXyt4/nHsQAws6m5AreztfKD5wPvHSV4QI973iATXP4m6RmdP6tfjB
         MPoSxBp1ptRC12lMeMr66pTGT3fhXSphz8B2eQo2Meb4KHleUsC6kOxUM/UwWofnr9TS
         JlFOt3xysvuSK2pZw6cJ+3n+DlC9N+rjPV9nAOuRDFgKtbLcTkKOC6M+A61embrMxwuH
         G9iwY2nR5SO/i0sE1HSuCcLM8BWI8l5KdvwHSfGFUsQDCsHOt3xs6OsAv6iX1gpmV7LE
         sW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EXIunz4+ppMl4siej9Q10IJWsOTU2zUJlW2Q47BFGIU=;
        b=m4wok7Enu7Zj75QSPoEp/ExqnuF+Tvl9NCMc9lZn5VJOhRlCii83Vdlw4r2x1+pF0+
         tK+zUoaU2dNzulyq37e+jXNec4UbQPQt6Xe+AWt2Y+F/f9UwgDnIA6Xsgy18L05hS6KM
         HuhbWB0nffPWHK4EluSp5pamSgCAU0J1oHPwwtzAgwnAg388NQlpwm8/JqY7bbIxggVm
         mMwn8SLiqaQz8lbFJRxdHJCWgvOhswNQV8ssQ1XXlNi30e9+NFO78Y96kuzF2j/xVDtT
         DCGyI4sPMW/spobJCJrJOrO+YURLkx8GmnyMu2UB2x2590E5IuZ1Et8GOKVKsObKnUsW
         4O5A==
X-Gm-Message-State: AGi0Pubdp5tHsJ8KFWPMx4+NKUGeAzJAg8jxJbozQmMzeaJa22p1paOr
        r+7O9cpVgBgqLFZO36FWp428WfEKfjM=
X-Google-Smtp-Source: APiQypJ1b0FH8BksVe8DhRlSlIJFSCbI2yn9hO7oFxSMaO9K94ymIXMNqQmpvxvBrWL/HCCEerEeWQ==
X-Received: by 2002:aa7:9a1c:: with SMTP id w28mr248988pfj.16.1585588010898;
        Mon, 30 Mar 2020 10:06:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm10270003pgt.27.2020.03.30.10.06.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 10:06:50 -0700 (PDT)
Message-ID: <5e82272a.1c69fb81.418ea.cd09@mx.google.com>
Date:   Mon, 30 Mar 2020 10:06:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217-66-gd657a74689fc
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed,
 2 errors, 13 warnings (v4.4.217-66-gd657a74689fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 1 failed, 189 passed, 2 errors, 13=
 warnings (v4.4.217-66-gd657a74689fc)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217-66-gd657a74689fc/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217-66-gd657a74689fc
Git Commit: d657a74689fc59d183702334e90a7ff228df531e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failure Detected:

mips:
    sead3micro_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 4 warnings

arm64:

arm:
    clps711x_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning

i386:

mips:
    ip22_defconfig (gcc-8): 1 warning
    ip28_defconfig (gcc-8): 1 warning
    sead3micro_defconfig (gcc-8): 2 errors

x86_64:

Errors summary:

    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode

Warnings summary:

    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    2    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argum=
ent 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer withou=
t a cast [-Wint-conversion]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98c=
onst=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---
For more info write to <info@kernelci.org>
