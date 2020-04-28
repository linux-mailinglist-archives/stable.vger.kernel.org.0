Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0900D1BBADE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 12:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgD1KNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726932AbgD1KNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 06:13:07 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90745C03C1A9
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 03:13:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k18so8183522pll.6
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 03:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8tWDrGXIsCww2PZURngaCT1hsFLsEWA6PYgE89Nve30=;
        b=kejx4ArI7YU4B7hE4Ug0OIMhqROaO1qnxocRfKm+4/vNh6+iEp7PZOKvujzGoX7wOJ
         djXqzcoSOQ3nPTQzz+YLo12VHgR0TKyWA0TSjU4MV/2WQ3brrkCTMrDUqAWt7ekWxvLj
         4n1KKNKsOM0WiiHURHPBKLttkFvK/QVxKKUqnco1klB1iS6UFrzhXcGcJ1BH+OH/vWeg
         VR5r35WZlG4eZPOnFGy6+Ehh/H734xt4ThO57SKlScoMUYX6dfdb03IOUePbf7wLYR1D
         W212SsJTwNqvMgJURh+8ir7/C4VH76RU2LfgRpgzunYNiPfcjVeKLThT+MiGbCckd0bZ
         TwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8tWDrGXIsCww2PZURngaCT1hsFLsEWA6PYgE89Nve30=;
        b=IXXFUgqGUKkWfm8pjYLDkKNYChkKGJ/gTnNOSjajyHEx8dIY1vCH44Y5widFNK/+oQ
         F9kV9nC+tNtJov75UJileukItTXmpFfvD7FSwXAFP5DDEPicO6qFYfSydqf+aVyKCuDJ
         6pUeXgGuFziv/XgqzAg8i4MMLpZEPTburUoocWdSt8pgnFpi0NLMf1fIc7mzL1ZCsIZL
         3lyBZSGtL0IaCCnQHr5IYg9OWfjSJCIJx6dOO3w1/pkuwdkChjbQN5SF2HLDfeQmvxNQ
         t/PuUxxZNL7VaT9khEKqsgaYf0nkjcgJ6E7i5NZ8rmWWLEfjRQy3UpKyf4/erQUY2Nuw
         ruGg==
X-Gm-Message-State: AGi0PuZHnrPl4+JT5smJtdliyW3ScZKHGHLKXi0yAv9xs6I1hbKfi1lB
        pQUEQoeA+V9HiuNovolmlZDz2sD1MJI=
X-Google-Smtp-Source: APiQypJ7CSrlnzcdJevryHqtvJHiyTuj0WHzM9afcRmz5x066hvS2jqgsEJs+o6oH9Y5AECbnutpkw==
X-Received: by 2002:a17:902:6ac7:: with SMTP id i7mr26215364plt.116.1588068786412;
        Tue, 28 Apr 2020 03:13:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w125sm12960313pgw.22.2020.04.28.03.13.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 03:13:05 -0700 (PDT)
Message-ID: <5ea801b1.1c69fb81.89e67.ff58@mx.google.com>
Date:   Tue, 28 Apr 2020 03:13:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.35-165-g8be8ad50e576
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 172 boots: 2 failed,
 159 passed with 4 offline, 6 untried/unknown,
 1 conflict (v5.4.35-165-g8be8ad50e576)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 172 boots: 2 failed, 159 passed with 4 offline,=
 6 untried/unknown, 1 conflict (v5.4.35-165-g8be8ad50e576)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.35-165-g8be8ad50e576/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.35-165-g8be8ad50e576/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.35-165-g8be8ad50e576
Git Commit: 8be8ad50e576c949741cd73259fe62b126488920
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 26 SoC families, 22 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.35)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 79 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 20 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.4.35)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.35)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.35)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.4.35)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
