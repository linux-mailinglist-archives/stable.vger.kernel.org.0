Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58C9A021
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 21:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbfHVTeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 15:34:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33072 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfHVTeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 15:34:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so6507493wrr.0
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 12:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FjxCCZ1wUxzuOaWT1JRhEF0dAwjXtlMLLzR4Ej7Gv8I=;
        b=pfvJK3IWLTi+OJollQYSp7j0uaRr1x8dxIXr3bQ19H4G3W7GO+h4Jj9hzizZsvn3hy
         7WKnZ0gAjKRMI5leTtACsDSAEsSJeoj8fGfuicxYJj6GYfRHHP5qh+J8HbEecT6IIRIl
         Kx+KniEuUjXhJmckBO3CyYh6vh1RbSx2VABv52cP7IwCmaujtjdXMvO0aEkSQPni3+/d
         N/rE5A/ZzEbn1ed4dUm1rRs7ViPvQPzYrWd0GHcr1/3uMfAuc+Q/1tysJVKs6Umd9W3c
         5cOrRXMx87suW0kY6eyzw0xAV1j02A9JLzvJYTnixrc/MLFS1omfjcsnponAelgOfMAn
         U92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FjxCCZ1wUxzuOaWT1JRhEF0dAwjXtlMLLzR4Ej7Gv8I=;
        b=ODQfEKLuuJZDL7TVWd+/uDXFB/DGkFBKwHD8KjyPsmaHA3PGSk5Es5gV/1q0rjFEt4
         6BglUTliQfAjepAdZpkawoxqJQv/fqytPJvFnKudws3tBWDoXyAqnf/Mwx8bZuMW605T
         7JAPmOma0djLGZ/Yt6iahLZJbJG/jQdpJaJ9GMPKh1NVLGKQo9a+ZwSLwjL/QIKjJVdQ
         cWp9Fp3Od+ULNWR5hcKkZnBbp55k8TNEmEwC9KQ0IuRL3PkFYFDSWD6scfQm4O3qfLiS
         tZTe/H/uokKIMiZsdAwhc26UtSei8HE669LOSTOE9Qt8+ckPVkmlBtrnPtiGazUG5uUz
         SJGw==
X-Gm-Message-State: APjAAAWpLU34oqNeH/uPIrW7QN3LwLL9VzK9Z8W+5rScyXlkf2am4+3e
        tHLIXppyV7hZX6NnuF89/3bvhofvzfh6dQ==
X-Google-Smtp-Source: APXvYqz2o1tdKh79a4FiY0MjDjzLA3rIm1ikYtdMO5p7CcuSz7MY5fReFQK1g4HWWePAh/KwX0fBCQ==
X-Received: by 2002:a5d:518d:: with SMTP id k13mr623199wrv.349.1566502442511;
        Thu, 22 Aug 2019 12:34:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a19sm1412276wra.2.2019.08.22.12.33.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 12:33:59 -0700 (PDT)
Message-ID: <5d5eee27.1c69fb81.1472e.7132@mx.google.com>
Date:   Thu, 22 Aug 2019 12:33:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-72-gd21235a08ace
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 2 failed,
 109 passed with 17 offline (v4.14.139-72-gd21235a08ace)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 2 failed, 109 passed with 17 offlin=
e (v4.14.139-72-gd21235a08ace)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-72-gd21235a08ace/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-72-gd21235a08ace/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-72-gd21235a08ace
Git Commit: d21235a08aceb1b05daef34272af34118aa92c24
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
39-62-g3f2d1f5446a4 - first fail: v4.14.139-72-g6c641edcbe64)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
39-62-g3f2d1f5446a4 - first fail: v4.14.139-72-g6c641edcbe64)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
