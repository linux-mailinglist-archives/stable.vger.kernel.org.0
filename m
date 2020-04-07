Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8722B1A06B0
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 07:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDGFs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 01:48:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41697 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgDGFsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 01:48:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id d24so811598pll.8
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 22:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WlLOrsURRSM+h9SuQ1FzSnhs5xw/JNPc+G+rB36S9rE=;
        b=qIIvKNNgitfEnLg7XrsCHzuTtZ+W2cwHSda5vfCcShWkN9Y9rQdMi/ZZJt4Hf6ovF0
         Sf/tJEQM3CVbDiWGdCmYerJ4J80lcVpeb4lubvzTY5P9Hlroz4J8Zu4+Bk7Vpm4U/4oQ
         n2qStworRwmxZ0txcaCM0OR+h2bfie7Yf47ero3tsfBq/+Ww3QULK7cwpnpvbyYkZcYM
         F/rpRVEm8uHjJBQgWTczzRzRcKOk7NOrZrkHtL0tPjkRE2SpPSpnWpMv1lMwmqGjc5p2
         3nrjsrbYeMNhKE46WcDqqu2dwnyX9iDF1WBhiDoVtKOivXOZt3cspJG1DnrH/uGXzC+C
         VY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WlLOrsURRSM+h9SuQ1FzSnhs5xw/JNPc+G+rB36S9rE=;
        b=F6FZBp4vknVF9ISAdNSEaHe4z71PmWtVkIMSi1vkmrK7clGRrsaAbndAFhNka30HLm
         CHxJ5FJjgoh1wHIRdCSFWFxPzQu3k/C3WTHpfLgYbSacIoNuX0WpxoXgPW4zqoroIb2L
         mTdQWlBLSwOqd/KBzOQYDOr9XSgWbz/rkNQf7CkuFHj3f+eIBjK6SNkdJhauOKEEOYdM
         9CSdSIxxucfgsTkxJ4gFvwOCORHG0h3kffAnT92NDJFsuN5Gm9dwnh9fqOTgtOoFAxi+
         s9TvKKr8Sg+lT0xSpDtm77ilPtd2K8Xchu5Z6PgDhW5LCaJY9og7atoyuPQQdQjao5QY
         5Ohg==
X-Gm-Message-State: AGi0PuaAbA00HJASTdt+6sX4YYAWtlAfOJd0V0Hyl6yP+TXQv21uhSE4
        kU7JxZG4saXKZDiXD4Lw+goWH1ZEX/8=
X-Google-Smtp-Source: APiQypIAbf9ZdSP4YwnwARwt0C5EJQZglPAx/IX/5yAdcYHeX6lCJTy3Iu9SAHR1p6JwuZN4cCr/MA==
X-Received: by 2002:a17:90a:350d:: with SMTP id q13mr705497pjb.171.1586238534591;
        Mon, 06 Apr 2020 22:48:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g75sm562778pje.37.2020.04.06.22.48.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 22:48:54 -0700 (PDT)
Message-ID: <5e8c1446.1c69fb81.7d277.23d4@mx.google.com>
Date:   Mon, 06 Apr 2020 22:48:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-13-g7166081422ab
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 6 failed,
 115 passed with 4 offline, 4 untried/unknown (v4.14.175-13-g7166081422ab)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 6 failed, 115 passed with 4 offline=
, 4 untried/unknown (v4.14.175-13-g7166081422ab)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-13-g7166081422ab/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-13-g7166081422ab/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-13-g7166081422ab
Git Commit: 7166081422ab34b593f324ac24ceb3bbe3bb33e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.175-10-ge0066de56=
999)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.175-10-ge=
0066de56999)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 58 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 46 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.175-10-ge=
0066de56999)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-10-ge0066de5=
6999)

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v4.14.175-10-ge0066de5=
6999)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.14.175-10-ge0066de56=
999)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            hip07-d05: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
