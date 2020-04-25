Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D51B8812
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 19:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgDYRXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 13:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 13:23:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A7BC09B04D
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 10:23:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fu13so4648942pjb.5
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 10:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9DOfm72qSP19d39f3q9pWJVu5ClreudU3XXU7S/TeWI=;
        b=F5ioAyrlvPIvBwGF3g0D9T20l3pRpJeQX4JBgGp/edLh9yECn7MKf3mCO88n4YqhoV
         KXhDHyHBfWxML7Kpm4FIKGxmvHN8VGOeUMDqcxyYzs98zEBvXxeU8nLYVRer6gOAWark
         YeDd97k6Yw4tBwJoiwCHWtqQ8thehR3HFRI2XdURLVSBurjB9kMPI6FWwWdGHKnFJGfu
         hs447kxRvRQLG4qo1nwgiZ5VoKQ6PFE2Sd5Et/Tow2WnPzVaUeFZ/eNZVAPbSHT0C6Gf
         IXM9IFPfhiXkdD6iJcEhKG/vUdktmkROOUa79X4LjFp2NcZKuAWN5idUPp348+7jWf+P
         TheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9DOfm72qSP19d39f3q9pWJVu5ClreudU3XXU7S/TeWI=;
        b=odYkpaK8W/2RGcHPNMvNaFyt3wEFSlvPaz55o+TG50ncMbWtDSoiDHbLlqIMQUvTRc
         XscE0EyMaNo2tfwm11z2bxVSM66WFXkFt2knJF5Bt9CWs3Y/rRBGCY0eonIhHeWW5mUa
         gszOAu8MkTEtioFcZkat+mJJ5JOcNJugk+WLkT26rQp500G/9eOLwwfrIWklu+2vo7UH
         NVHVgdvRz199THEc4kCuTOIsQUupifW8xxBvhQ6C7h2n8aXgXGt7rsrAgtz+cFsOgVGC
         v0HPx5hL2FY4Py0rQb4Pz3VSt72w4aTH2Ps2tFJzVuBljj3/RWvrHQV9ukKRfKdkgqkT
         5TFQ==
X-Gm-Message-State: AGi0PuagtTFXZJBYm4iVLSpBiWiqKgZt7N4TIdgGKSh34zIV0cWNv73x
        ++nTqM+U59XqKTtaYNO10yQsEO4bH20=
X-Google-Smtp-Source: APiQypJC3IyFcJJqrxkO3avYagg1r1g0W7wCVtpq0z9+/HkSKxbfa3l+iDenSd6AS0b02Y/FmWpxew==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr13593159pjb.146.1587835381550;
        Sat, 25 Apr 2020 10:23:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g25sm8370790pfo.150.2020.04.25.10.23.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 10:23:00 -0700 (PDT)
Message-ID: <5ea471f4.1c69fb81.7d403.cee6@mx.google.com>
Date:   Sat, 25 Apr 2020 10:23:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 118 passed with 6 offline, 5 untried/unknown, 1 conflict (v4.14.177)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 118 passed with 6 offline=
, 5 untried/unknown, 1 conflict (v4.14.177)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177
Git Commit: 050272a0423e68207fd2367831ae610680129062
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 20 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-199-g=
a7097ef0ff82)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-199-g=
a7097ef0ff82)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 65 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

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

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
