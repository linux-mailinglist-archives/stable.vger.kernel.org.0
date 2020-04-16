Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6272C1AD16E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 22:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgDPUo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 16:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727780AbgDPUoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 16:44:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C65C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 13:44:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o1so59317pjs.4
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 13:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KtY6AkhfDUO/ZqsP5OdYgSmSDYpfxO782a5JZsTENYU=;
        b=DfsleSsPYpqVclFemNL121mIluDpq3asuJufrqFpcVwqSOgfvIqsFJfWQ+PI4adgs0
         EbZGRLzaPzUBHs02y4kNVl4S9DcEIg+XIq/TDK9dvci3fLPqobcDZ8Z7I82+KBCauJlC
         rN9DuFPB4se9OToHXNlgCA6SqUkn8LrRKijKssaH80sHK0Pe6KYzrY9Ab73UHymQ3Nl6
         XlINeswZrs9+9hUaTgmMahao0/LjVxX7HKi77I/9NF+Y4mHxrViwYRi0bH4sAbTRnFgw
         YP9ykvGtOyBEAygENHLBw2H4tCO5WdXEEapblGy3g1XkncPh6mZpmrfeuiy+Bh7Wi+U2
         /Ggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KtY6AkhfDUO/ZqsP5OdYgSmSDYpfxO782a5JZsTENYU=;
        b=p3KUtYU6j/wJKyllrjBQ4d0SHXapsRbqB25z9dnmFat0VDDXILfPiJ4p9GcZPxhfup
         ifmXIdr6f9oUilC9l4ggHVVaQQrYc8Gj3YwsFQFeB/cZ44GECmDRVgNPXFxWV4M2+lnO
         Yf8FOAO7Aq7+92QxBLZYnEbxvYSlvGOvYXGBQJ5CiRpwL3drs+be+zlGgaF30VRWh9KS
         SGbI7I0rjPCPMpf94vZKOTWnyIMLsezoBLWcE5kfhDU5M82eZYm69RPctq8EYusp9XaY
         88f5JUlel6b5rmJGN05tFnWhuTtRwN5B9+0L/sRmvu6ezqi/SpWlswhNBAAuSd6iuMFB
         nQeg==
X-Gm-Message-State: AGi0Puab3ngOHcybkFI9OcpSvFYyg7PybIkbIf8ow63tKMnlKKqaJwsj
        qQimJmlI+tCQgmKYjPsq0KHYnaFp31U=
X-Google-Smtp-Source: APiQypKwr38oFcyY65hvVEyqsOmHqPHjBtofIJbjgKEVXyhAeVNzQZv9c6w4DyalrBiYyVsSl42IzA==
X-Received: by 2002:a17:90a:1911:: with SMTP id 17mr167191pjg.65.1587069893526;
        Thu, 16 Apr 2020 13:44:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c125sm17407010pfa.142.2020.04.16.13.44.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:44:52 -0700 (PDT)
Message-ID: <5e98c3c4.1c69fb81.fd610.b735@mx.google.com>
Date:   Thu, 16 Apr 2020 13:44:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.31-275-gccba204bf567
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 164 boots: 4 failed,
 151 passed with 3 offline, 6 untried/unknown (v5.4.31-275-gccba204bf567)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 4 failed, 151 passed with 3 offline,=
 6 untried/unknown (v5.4.31-275-gccba204bf567)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.31-275-gccba204bf567/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.31-275-gccba204bf567/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.31-275-gccba204bf567
Git Commit: ccba204bf567bf5349e9635ea1fb8cd18d23c123
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v5.4.31-258-gd88fa8738f=
21)

    multi_v5_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v5.4.31-258-gd88fa8738f=
21)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 8 days (last pass: v5.4.30-37-g40=
da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.31-258-gd88fa8738=
f21)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.30-81-gf16=
3418797b9)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.4.30-81-gf163418797b=
9)
          meson-gxm-q200:
              lab-baylibre: failing since 5 days (last pass: v5.4.30-54-g6f=
04e8ca5355 - first fail: v5.4.30-81-gf163418797b9)

Boot Failures Detected:

arm:
    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
