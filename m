Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601FC64DED3
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiLOQl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 11:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLOQlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 11:41:50 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DB036D54
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:41:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so3213517pjj.4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 08:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6WR73H3DboOQWsCmp2uXsNCFePMlk3W+789Gx+ySoEg=;
        b=0uG7qDYNus9oCkylMv+vGto0k90bhdxjp1+k3nyvy/FayLqSubEsN1bfR3lXAsy/M2
         dhNofJs1L0sAxn5k7LCW9OTz5lxeGRK57xyeH4+hoQZXN+QMNm0kqw3Wiyf8lklNsPTQ
         x0RzvLUU7RmZOxI9J9TA0TBH5ttAP38+oBrTBt8xVz4P2mHwE8G3PFsw4Y/FPaqCGKpW
         o2aCUyG3goBslHqH75mQSjNEpnk5WXqtYOlsbY3PHfEKB5uZIbHZSyuvVrScrtWBktdS
         14Dpc+4j8hW9gz1y5yXAIo2iBPc1emuAYdj5LmhN+Pwj+1ZtvUr/S7yyVfEi2apPiBe9
         9Zqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6WR73H3DboOQWsCmp2uXsNCFePMlk3W+789Gx+ySoEg=;
        b=nzWErd3d5TBT9rb5J33GsEx16a/oqQY405lp8ZcT5mqvJsyTJZZVj49LGMP1acDfQz
         xajeDVJnMMNPfoXF6kjI6hawZEde5ptKnO3YmvAifB8EFh8UibCoQSMKXUsQqg8R44aE
         mv76eT9SMnaDaYom7diTOxXFSUOP1EhH2ZHlPaLoOgGdYea5JFvjaz3m5oNYHHEJvXzg
         cAmUWWfXKBQu1c2g+JSxD0AW3o5XGFtb1iWhmkEINJdV1mrovlBQMn/6a3Bf41O4QwKp
         Wvhez1EZYh0AjQao7tq6RWz+bcr6RDRwDCl51XZKijVz1DyuCsqWc8YGsHANSw2dAHzA
         UREg==
X-Gm-Message-State: ANoB5pl/IU1zS/YpxX5TsRfPBXsxfBgdjEqnJODZUvS851f2qExWSsWT
        uVNb0sULt8q3tAKHPXG6PYgTlJSj6eVg+Pg28r68Cg==
X-Google-Smtp-Source: AA0mqf564zRakqj3xo610A1hW+V5yHsAd6xM+jscbfGvJyM7laj5B9ihQs+40yFJ6qTjGiJyAJ+I6w==
X-Received: by 2002:a05:6a21:328d:b0:a9:d06b:440b with SMTP id yt13-20020a056a21328d00b000a9d06b440bmr43819855pzb.30.1671122509416;
        Thu, 15 Dec 2022 08:41:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a2a8200b0020dc318a43esm3415158pjd.25.2022.12.15.08.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 08:41:48 -0800 (PST)
Message-ID: <639b4e4c.170a0220.b6eb0.733c@mx.google.com>
Date:   Thu, 15 Dec 2022 08:41:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.302-6-gf0647acdf9ed
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 build: 12 builds: 1 failed, 11 passed,
 3 warnings (v4.14.302-6-gf0647acdf9ed)
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

stable-rc/queue/4.14 build: 12 builds: 1 failed, 11 passed, 3 warnings (v4.=
14.302-6-gf0647acdf9ed)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.302-6-gf0647acdf9ed/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.302-6-gf0647acdf9ed
Git Commit: f0647acdf9ede4ca1bfbc976a0a72a4e7d6b0fe4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Build Failure Detected:

mips:
    ip27_defconfig: (gcc-10) FAIL

Warnings Detected:

arc:

arm:

mips:
    mtx1_defconfig (gcc-10): 3 warnings


Warnings summary:

    2    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---
For more info write to <info@kernelci.org>
