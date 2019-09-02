Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AB3A5E34
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 01:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfIBXiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 19:38:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52401 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfIBXiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 19:38:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id t17so16071874wmi.2
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 16:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U51aRCizvkP9SDMzNs2y6ZopWiza/8BE9CRSmoyYduk=;
        b=kEEa310NX15ITArwT8Qmf+Dxzuk+etjaoiL8PEFAi/3NKKsWACk/KyjKveIwt2ChjL
         TdY7gjdDuUI1eerjkRUO3a8BKbqARDK2BI3Kxm+VgpRsNR6sGwjOVkkHR9ODSNcL4Hj9
         w+cKkvxWy3DNqnNOXxrr6Qw6ccxth+9QqD2cfhixdLQHTUOSvavXMcuCjvVaWxk3XZCB
         nEVqxa6mmhNddsVqRY+4H7n/rKhoXyw51VE1k54isuMVJ3uBWk35rLhah1I7LX1MVxsU
         fopuPRj8vnmz0XrDmpADklaL7D7TbhpwPoBb3WmQkZwdNDh1fjbBFu9OmpqXbOXRYc7f
         g51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U51aRCizvkP9SDMzNs2y6ZopWiza/8BE9CRSmoyYduk=;
        b=JA6XWKIx+ibE4/1wZBTYAm1F4OkKliAqjSVazridPOl7/C5cKh/ZZY1tXHxGkQGzbn
         DRqdEcj4CtPYberBdz2ea1dI+PG+NlDnue5ANRd9q5nk+4Uama52IbMICSzNZT9j0WO8
         KD761nCZeO7pKVCXeCNrA35FPVsy+GQjWxg/oMSspJ+mBzY7HiVv+crrn4xuHe1gVDHR
         HaYmudosVHgnslG6MNYXlPGeWiC5SkXE3Z6nXRL2QyZmGJ7WVRhojCjbhnqqLY28J8jk
         fZmOvvpPGEAO3PHSu/8dvhShmOtdcOuIb06f1MkoYat/t4Hle3pqz6OtIk5Xf9yhQaJx
         9X4w==
X-Gm-Message-State: APjAAAVbuCb8vj/O/VbQVQmDks2H5QgTIHoXgqdDTpJZ4NWY79+MMydW
        eQuCK/AU8gFqGZ6r4ywDI+ryXv+PCuALuw==
X-Google-Smtp-Source: APXvYqw4LmLcYdmbkBgMvsAPONdFXzWRt88kUiyXhrL2WbEbFn1oveVNinnIw+4cmIMme6mxaXOX9Q==
X-Received: by 2002:a1c:9950:: with SMTP id b77mr39755486wme.46.1567467482272;
        Mon, 02 Sep 2019 16:38:02 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o14sm45440700wrg.64.2019.09.02.16.38.01
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 16:38:01 -0700 (PDT)
Message-ID: <5d6da7d9.1c69fb81.ff86b.79c8@mx.google.com>
Date:   Mon, 02 Sep 2019 16:38:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.11
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 156 boots: 5 failed,
 142 passed with 8 offline, 1 untried/unknown (v5.2.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 156 boots: 5 failed, 142 passed with 8 offline,=
 1 untried/unknown (v5.2.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.11/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.11/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.11
Git Commit: c3915fe1bf1235dbf3b0bced734c960202915bd5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          bcm2836-rpi-2-b:
              lab-collabora: new failure (last pass: v5.2.10-163-g9f631715f=
fe6)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 19 days (last pass: v5.2.=
8 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 19 days (last pass: v5.2.=
8 - first fail: v5.2.8-145-g2440e485aeda)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.2.10-163-g9f631715ff=
e6)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
