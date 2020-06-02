Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B51EC40D
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 22:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBUyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 16:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBUyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 16:54:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D530C08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 13:54:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n23so78189pgb.12
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 13:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vJAS0nViCTt2rzX9xvgCV5a/jaIDeTMLOFGV74IYG1c=;
        b=rCvk7mpI9nXC14/i+k+uYvVBOuBJXhyZENoIoTwwCaWJ1Xu0JdQi1FyhXhtFAcV+bp
         jRdZ9m58zwS8twOv/GrEaztTTs9lzfq5kyaIG3YDw1froTjEpAoaFI7D4lPWFWTJoT8/
         Whixkmj6Hn8524ebpCKkDox7B86iWpURf73tiOOXlGvuYIG+RleLAOOCOAujgaUYbq3O
         kVvHXsX28URE85bG0yVp7QD/dzVFKege3xvJm7GjZdHP/Y/Zl4vE7HLIR2+23rEc3TBf
         evTJVsGj+0ZMJEIZGwh6DENAuodMzpCa4wa/0a49HvcA/CAGbnzwCoJiGaSHuPJlcNuY
         9v7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vJAS0nViCTt2rzX9xvgCV5a/jaIDeTMLOFGV74IYG1c=;
        b=gGVJrMkSMuF+7GONy2u22wlm7GwwqnU3g+6yrrcPXw8AiAIKodw3bqGX8SPelagfYi
         j32cENk3ABlbzzBAQ6j16BWae1idnBSlp9Sx1qcAquk3gMUHz9ypcae2ym1MqWPKC0W4
         KE9wHXeDOoucSg+UxBFhuf/G9quMNWQ2uREGZSGoothI1eKKNGmGTgO1gYH31h3MIZfg
         fUAAYqKqigp2xZihF3YWotupJVQO+FLIxF9csxyARUOGkwBq9scs3w9pD9JTvSf5mlc+
         0tyF7JQTp75G2ANc4SZ4Q6Zlf4WO9zDga4WuNbrVj4r4Fyu6/moVcLtwSNgcikispMKr
         CsNA==
X-Gm-Message-State: AOAM533AxAgAYVVUlqwzV4QOUzNLOReaTyj2Q9s/3pAV8QFYVtgmHI2Z
        JRI2Az5v8l5YAsFmCKTaaxfpKlKMkio=
X-Google-Smtp-Source: ABdhPJyOuF3CK7utXYSTpuuwgrxPTW+VSVHRNK0dHXqOwO78go/yttduvZOTzbiZbFsCALnRAySSXQ==
X-Received: by 2002:a17:90b:796:: with SMTP id l22mr1068586pjz.45.1591131253695;
        Tue, 02 Jun 2020 13:54:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24sm45332pfk.29.2020.06.02.13.54.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:54:13 -0700 (PDT)
Message-ID: <5ed6bc75.1c69fb81.ee4bb.03eb@mx.google.com>
Date:   Tue, 02 Jun 2020 13:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.182-77-ge64996742439
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 112 boots: 2 failed,
 101 passed with 3 offline, 5 untried/unknown,
 1 conflict (v4.14.182-77-ge64996742439)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
2-77-ge64996742439/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 112 boots: 2 failed, 101 passed with 3 offline=
, 5 untried/unknown, 1 conflict (v4.14.182-77-ge64996742439)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.182-77-ge64996742439/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.182-77-ge64996742439/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.182-77-ge64996742439
Git Commit: e64996742439b0bbe4cbccf2acc0574f1691faa4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 19 SoC families, 14 builds out of 157

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.14.182-78-g9093a431=
5f91)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
