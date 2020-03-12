Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC0182890
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 06:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbgCLFrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 01:47:31 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33568 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387677AbgCLFrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 01:47:31 -0400
Received: by mail-pj1-f68.google.com with SMTP id dw20so348827pjb.0
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 22:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DaW5AVtGuQR/W9KxC4cgy72p2skjuCUZvzIIiBvWt88=;
        b=dhYte9girmjGMSbvkAOuEOKHEwkHN9oKzxpNZnP2deBDETzRmsLddkEPdXiyCa9AQq
         lbmmYzQ+JVNn3w0a4AwMqUA0nimKm+laRBmiR9wgL97xZgnzXI3F4uUXqQRhn/+PDXW5
         hUp6QXngDgV940pq6vwmibhiNFyBtgpVhmui1RivrFAguW1CN0knH2vS9v/ez+OeKKxM
         /MNY85fnorKOXWg2r1fFJBF9Y1vGx/Pwl2cJZmvdSeY0Abp/OizmvWCLldw8gJXzComg
         1LoeXJXmIi2uNYXY1FPkc2lOltft2A/2K/EldeuWqHd32nAAqlsUWQWdxWVmpd/s4Cg0
         C/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DaW5AVtGuQR/W9KxC4cgy72p2skjuCUZvzIIiBvWt88=;
        b=G6QLyXoPilaSij1+PDeMIYOteEkkatWJNY/ekZrBjA6whpWcLDsRtvx1pd6nU5xzjO
         DfGKDjVHHhTxH4gsbTleTr/5zhdlpgih3vs3edzm7NxVgFo61HPUMGEk68VBdSJmJZ0u
         Ql+3D5oxmoDnJHAPHDnyaf/aGLBd6AXgANH9KwUXVD/IZuvEjBOPEQJFvOj/xVPmaq3B
         Vty96NTaYwjKc7Nw5fL770ySG/KkdBrqHyoqct6hdS5172Yob7A82c1VGCH3qs7rur7a
         8T6ripEfE8VK++r/eYFX6+RDS2Gkde+fKH/1BmjyIov8wILeELGSQpPSjB17qFUZTk3p
         MDYg==
X-Gm-Message-State: ANhLgQ0gkL0XOaOWErqbYWeumvHmn1QBhsUlIj7LXQG2DK+Iz36SkOOE
        +NfxfO+5AONhFYfG69QsxJJEuGjGoPQ=
X-Google-Smtp-Source: ADFU+vuNJ0YaeWWBMm8KLCTe+BUK9R6xtyZrItNrZl10K0jjiYWCBDnGTlQVRPwTSwFL5/l9tpsMDQ==
X-Received: by 2002:a17:90a:a10f:: with SMTP id s15mr2420699pjp.40.1583992048056;
        Wed, 11 Mar 2020 22:47:28 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s18sm15434351pfe.15.2020.03.11.22.47.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 22:47:27 -0700 (PDT)
Message-ID: <5e69ccef.1c69fb81.11507.e5b5@mx.google.com>
Date:   Wed, 11 Mar 2020 22:47:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.24-170-g98d2a8785f3d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 120 boots: 2 failed,
 111 passed with 3 offline, 2 untried/unknown,
 2 conflicts (v5.4.24-170-g98d2a8785f3d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 120 boots: 2 failed, 111 passed with 3 offline,=
 2 untried/unknown, 2 conflicts (v5.4.24-170-g98d2a8785f3d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24-170-g98d2a8785f3d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24-170-g98d2a8785f3d/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24-170-g98d2a8785f3d
Git Commit: 98d2a8785f3d7d8b83e1bfb79c3d6fe176066598
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 23 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 32 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.24=
-169-g01c3b21f542b - first fail: v5.4.24-168-g877097a6286a)
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v5.4.24-168-g877097a628=
6a)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.24-168-g877097a62=
86a)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.24-168-g87=
7097a6286a)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v5.4.24-168-g877097a628=
6a)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
