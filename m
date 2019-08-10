Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19F4887C8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 05:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfHJDzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 23:55:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37975 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfHJDzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 23:55:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so99909873wrr.5
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 20:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+qj7EUcYz3FNqSrNroWaAalx/eOSDdrVyfm5FTyqBLo=;
        b=RZREd4lpAb2tIDeAOCzLCrFQE8IJeXPSpTEmDmyKlxZdgSfsA1VdzITMPnQfe2EW+9
         liTDM37YyWQtjL3LwDKmP9zYKSRLO5Aabf0TR5dTouhb4d9xVwtKijRD1tpQs2O2k0Uw
         5uXabnDabu1QF+eUtU4TMScQBDFoguEM9DYxQ2/EQNhfccqHHQQzYHC68a/r4wNry7fT
         r+COOnwfiqySbGTtJ2ol7ezKoiGTM4MqTvwtdSrYalSsRejCEpbVT2dz4zpsuILB+KIV
         /6g+UeVMMX8QsKcE7hHerq85SZ7QnxEplJL+vFy/IybDg8ULfKu/MkeTDQgc3vQurz4F
         pLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+qj7EUcYz3FNqSrNroWaAalx/eOSDdrVyfm5FTyqBLo=;
        b=r0xwNza+qYBwq6/XikURnN40J0CQMyMbPx7SQ4oevRbWHaADf3bsv2tpISW4bZVW4C
         Hf03FW6ZslEC5aFbiHvsX//4SqV39bMxzat30wTnZnf9fMaCqvQhzsT6sk5XVJezbAGb
         KIyc6e0q29tdoeRtxkTz90WdXlNTGeOoPwthkddF/cRKJcBTKuFRqvLvXNYlo/X+FWtv
         j0zWwEdjmku8G/NPXINROj94RVCk0GYu1QVJoqVVZfWqPUap3EMWrsv0FDsziqQUp3CZ
         nOnyGd4Up+6RzSGo4esmOqNXGoU198PjWALLYATVSDoIkWeTi8KVetS4ZXDTcUu+Hslc
         TKHw==
X-Gm-Message-State: APjAAAUl5Ua1J25MX404tpy6fNur+Eny/0oxmVkcSejuUJH5rZdlU5JR
        4+9uRdcwLurDJvanh894Suzxu1KIt0ud3g==
X-Google-Smtp-Source: APXvYqyUngODS6Tp0j8ObTLrlyKKM1FkTXaYZRut7PwDlCdQgWToYX62cWvFcTvWZcFnj2ke5EdRJQ==
X-Received: by 2002:adf:ea89:: with SMTP id s9mr8465980wrm.76.1565409340256;
        Fri, 09 Aug 2019 20:55:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r16sm12335820wrc.81.2019.08.09.20.55.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 20:55:39 -0700 (PDT)
Message-ID: <5d4e403b.1c69fb81.13348.0157@mx.google.com>
Date:   Fri, 09 Aug 2019 20:55:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.188-22-gab9a14a0618d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 94 boots: 2 failed,
 82 passed with 9 offline, 1 conflict (v4.4.188-22-gab9a14a0618d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 2 failed, 82 passed with 9 offline, 1=
 conflict (v4.4.188-22-gab9a14a0618d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.188-22-gab9a14a0618d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.188-22-gab9a14a0618d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.188-22-gab9a14a0618d
Git Commit: ab9a14a0618d99ad7e0b7e589a97f3421ac4d662
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
7-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
7-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
7-23-g462a4b2bd3bf - first fail: v4.4.187-40-geae076a61a51)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
