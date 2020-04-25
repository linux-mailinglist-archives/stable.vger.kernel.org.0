Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487EE1B8872
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 20:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDYSOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726182AbgDYSOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 14:14:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938EC09B04D
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 11:14:32 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g6so6286902pgs.9
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xO/E7rABy6SpVcAswdAVs42pkFl1VRDIWWRw5l7E3BE=;
        b=j/6U4h+YSQjcPSciXroI0w7ufm8zIQx1V/P2uEC1DCdbXX2pLZIxoPFOOjrWV6eMk0
         A+NsJYgo/hV9qWxLPSBqpshkqbU1tEPR7bKGvS/tkvhxXpZhtmbKh8AnSXMf+c4KWBif
         TVPyoqDgxcIhl5aJU83C8fwIJbQ8VG0qFazYrNiYaP4myj56pT8oCsByYQlT4mB1G4Kd
         itRhwiGM6fctPF7rKPS+PPk9oe//4W90pVDIj+hcAQF45pmArZutbOb8qbMmH+E5vUr5
         IXWeD+rbSf1ijeOscbhkMCEw5QGBpqpKDJP0mK/9FUU3AFnvPq0p9+Vst0qbRwnBp1WA
         C9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xO/E7rABy6SpVcAswdAVs42pkFl1VRDIWWRw5l7E3BE=;
        b=eRl0Qu+jCoKeYv10SFGRcZ9a/zysyAz/q6Jlw/iYC1cD8jyJ2cUZYluGSAXIXRqoPc
         0uGb81fO0uywxP+9f3DbuUG8fqEaFL3aLKQMuCnSfALgz5skTtPYwdk3U1mluJUzq7Rn
         kE313pHh1rwHxo8ZAvlidmHzBHSFar0Aulq7RhRgTMGMU/SbJUMKvlfb686/AuVx1uly
         /iNtB8eChvXRNVwxlFxwelr619Me13eWQp3APcnxCpFaPycOJ47fJ+s25S0zf7GRFL3y
         4Y02zpjYIdIcwv1J91OSTuc8ny++UFCQPVqmJs89NOYaAxZApcdCTdHVdXAWcxLbzw+q
         5Zng==
X-Gm-Message-State: AGi0PuYBrEWapJ21v/jOGnmLH1HnVMZmeLxcIr0eJqoVwcCeI99MmkMP
        ruofYQaGrTXHowg0TOIHX3xu50ROgoU=
X-Google-Smtp-Source: APiQypLrXp89owPrTx2Kw+SJhuG+RusNyoDNedBTip3wkAOeQFZ1TSbyoloCr3LxIQMta7SiypwG4Q==
X-Received: by 2002:aa7:9f5a:: with SMTP id h26mr12261214pfr.281.1587838471358;
        Sat, 25 Apr 2020 11:14:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x195sm8998320pfc.0.2020.04.25.11.14.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 11:14:30 -0700 (PDT)
Message-ID: <5ea47e06.1c69fb81.15af1.ec46@mx.google.com>
Date:   Sat, 25 Apr 2020 11:14:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.118
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 149 boots: 1 failed,
 135 passed with 7 offline, 5 untried/unknown, 1 conflict (v4.19.118)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 149 boots: 1 failed, 135 passed with 7 offline=
, 5 untried/unknown, 1 conflict (v4.19.118)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.118/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.118/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.118
Git Commit: 7edd66cf61670d2d0c31f89cb3a247016e489a8a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 22 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.19.=
117-18-gff69db5bee37 - first fail: v4.19.117-65-gb5f03cd61ab6)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.19.=
117-18-gff69db5bee37 - first fail: v4.19.117-65-gb5f03cd61ab6)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 43 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.117-65-gb=
5f03cd61ab6)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: failing since 3 days (last pass: v4.19.117 - f=
irst fail: v4.19.117-18-gff69db5bee37)

Boot Failure Detected:

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
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
