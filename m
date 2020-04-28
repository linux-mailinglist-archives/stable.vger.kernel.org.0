Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E4B1BCFE1
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 00:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgD1WZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1WZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 18:25:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010EC03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 15:25:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x77so88690pfc.0
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 15:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ujpk/Kig0ER4C20iiSto+SA0cGB41zzeQU8YspwWIlI=;
        b=uPyyXcasMmyszmK3tD050yrTgeM9oI+3MT7hYDQ++Wrbml9yq4onpsLku1FHYzh813
         xBz5B4R66C7gBBErRK0VUG3SkAeyvIpXWJPSgjxPTp5m+xTPyQ96BNI3iqK+Gann0CY1
         BFEUtwQR0ulNj1S8qIo1ZSFYCyH1gTpKzOmJRD/IIjVhIs5mg2cu249oeTQk7VSdV7uD
         8bbTHW5BOk6BYeBA0Uh/3Jh7R0Xa95qSwr3dawNhPyLtIr/IskUKfnalBBqdMxz0v2IC
         Ht7j6DaDqcWMCS4ZOkzSU+3nrY9R/iFhXjXtIZTrEJv+g3os56z2A87Y0Q0G8YwCvhE3
         4YRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ujpk/Kig0ER4C20iiSto+SA0cGB41zzeQU8YspwWIlI=;
        b=lJK6/B2q/lN/GH6v/TlIiD3UeqXttKLt4k5IleUSnxHgOdtzP8/d6fRqoKc2LJzYc9
         NzVKaOBR0QKr04m/YY01Yoo0G51YBBj0nk9Nt1KvD49l3Et3Bv8MOYNrRblbe++CyKqP
         b1SEq9MTvroo4EQo8bHvMZIj2xCgO1Jaw97niebHRn7jQpXbDpomJRjr38oRJ/kp3vXS
         LlKHTkNcEkroOxupbrSkoeuKFzetFf8OhTlSirbjRd+ePPFSmmrPgOZXMJcacoIMGqfv
         95ODBxDOdG+WdDxDs1trHgUAUer0NoZa8UOU0mLnveP7ihJuSDYsrD4NlGCQEhsb6Ylv
         tdsA==
X-Gm-Message-State: AGi0PuadF6+Hek5p3Mf+eyORka/RMroutbKdUw+WfgUW/8MtYaObQv29
        V+j59hE+SvB7LTVG4rYpWGiBkal7qh4=
X-Google-Smtp-Source: APiQypIQdR+2ce9t3NJsMkkavZi3DPu59cpoZ8yCR7LtczYyZtMr749mAMQrt3gaMYK5Hbi/KwQt2Q==
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr31643489pgo.120.1588112713303;
        Tue, 28 Apr 2020 15:25:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x66sm15943318pfb.173.2020.04.28.15.25.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 15:25:12 -0700 (PDT)
Message-ID: <5ea8ad48.1c69fb81.694e1.f26e@mx.google.com>
Date:   Tue, 28 Apr 2020 15:25:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.35-168-g0e134cd8e42d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 173 boots: 2 failed,
 155 passed with 8 offline, 6 untried/unknown,
 2 conflicts (v5.4.35-168-g0e134cd8e42d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 173 boots: 2 failed, 155 passed with 8 offline,=
 6 untried/unknown, 2 conflicts (v5.4.35-168-g0e134cd8e42d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.35-168-g0e134cd8e42d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.35-168-g0e134cd8e42d/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.35-168-g0e134cd8e42d
Git Commit: 0e134cd8e42d65edf9623b361846c1d72a58fb24
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 106 unique boards, 27 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.35-165-g8b=
e8ad50e576)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.35-165-g8b=
e8ad50e576)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.35-165-g8be8ad50e5=
76)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 80 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 20 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.35-165-g8be8ad50e=
576)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.35-165-g8b=
e8ad50e576)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v5.4.35-165-g8be8ad50e=
576)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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
            stih410-b2120: 1 offline lab

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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
