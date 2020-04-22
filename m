Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB9B1B4B87
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDVRX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 13:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbgDVRXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 13:23:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECBDC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 10:23:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ms17so1289324pjb.0
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 10:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hhh025vL+uOwQznfCNq5ud3xSIawsbHSp03//kKBlgI=;
        b=IB+LLJH7APg/4yo6axC3FTBZpDLhNrjWhvqWa4IJbkJLrahfecytGGgYtsxtryqUKF
         ZpIDrs7epdc5t6/11bgl+MIRnciGr1UbyG04wPuejCFsno863cwXqHefTmNCnpqr0r4w
         F5+IG9OKpXOvCzSIw4nPN8sjvrs0/1T4ckGWehU6zMj5mSUyYhG2/ggB56Bc2xHaDrBf
         cQQFr5MRcwNyJfFCJ0NWIVgzkdELkMmwKv3PsmxRt+9ZzsakmaUfl66e4co11ZPwc4Jo
         JXuPm1Gn/lK42VVX4BMhZ1fPFD4LK9z5PTY0uE8ncA9lZOuW0OPWcY8KRscwYrQ4+t4T
         SrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hhh025vL+uOwQznfCNq5ud3xSIawsbHSp03//kKBlgI=;
        b=kCUi8R/H0OeacYFIMChJYxBSoATt5jVP61YVB0f0jXTHnJ+IJC22dOapgS+Phjp/mn
         iwQCp0tn/DijQviu99/Vmseorqo09nd75/WCNq2D924IkOP/pYU28wWkOAjrSiZ0+thc
         Fv9P0dC5g/Cqv1PpQ9P3uFBzLBYaA8WRNIhOg2rH116XHj94/lMjciBuOYDylqDv2Ibf
         nWJZUXQ0wDqN1gEGoX89eBGD2r67z48WJPS07RB8MaLNOm91LI2RpPgBXmhs6qFvQupP
         EddYRu37zsFOtgv3jvnyi+hXrjyZ+Pe51TUNsLoK/bDyhuwMZ88J4F4aZF/CiTZaTtgY
         7AqA==
X-Gm-Message-State: AGi0PuaaYGjuCyTQYklgsg9wFOu4k7CuseLouY9VhlevnaaCRcy2c951
        QAehBdukQ0/BikAf1V9ZeqIhMRRfUGk=
X-Google-Smtp-Source: APiQypJRwjXZtkYJKqBmA2MgIOOgXCgIZDU8oWUm2XqaJptLP4UrgAfIw9Qy54V8arikCay/Z04Kqw==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr2521304pjy.167.1587576233486;
        Wed, 22 Apr 2020 10:23:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ie17sm5991035pjb.19.2020.04.22.10.23.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 10:23:52 -0700 (PDT)
Message-ID: <5ea07da8.1c69fb81.7e15f.314d@mx.google.com>
Date:   Wed, 22 Apr 2020 10:23:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176-200-gcebd79de8787
Subject: stable-rc/linux-4.14.y boot: 84 boots: 1 failed,
 75 passed with 5 offline, 3 untried/unknown (v4.14.176-200-gcebd79de8787)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 84 boots: 1 failed, 75 passed with 5 offline, =
3 untried/unknown (v4.14.176-200-gcebd79de8787)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176-200-gcebd79de8787/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176-200-gcebd79de8787/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176-200-gcebd79de8787
Git Commit: cebd79de87875c1f054d7e674a496868b78e637f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 17 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-167-g=
ef12a8a0e717)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-167-g=
ef12a8a0e717)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 74 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.14.176)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
