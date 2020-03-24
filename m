Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603581910B0
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgCXNal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:30:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34232 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbgCXNak (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 09:30:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id t3so9037935pgn.1
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 06:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j+5A5a+fqfg2FvQ0HU4k8IsT9LEJTS1NYlAdS8995K8=;
        b=WsSS8IlC82pyiTRM3Cu4YX+xbxe/z/3tdfOp14zGkXjQYA/3TxtmEb8hX+J/5eLq9W
         QUs9ZpVWW0R+Sfar9F0Pcq+jGqVLnRDTlnA7UupSEjEM6wLysXfmF5KRmFl8Dt89LAZ3
         aF+U5/dctB6qCDzictHNDmRfNpKhpwndBkFey41uEIzjZIZo5DBB/hobWg8EY/jXK50f
         ADNasCKviPuwPRUlQt4onsYM79PKtw2+8IQpj976QA+Rekdg3iK4CfwoCK6+kAKmBjtO
         H4gLCFhhNw3R3NDYKh75oTNE9jWs9yS/94Ru0Mb84xAkbiwRECxy44TF67khSxkunbMn
         2ApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j+5A5a+fqfg2FvQ0HU4k8IsT9LEJTS1NYlAdS8995K8=;
        b=qSoCQlYrQbAsNli+lupcBKm/uvPDq8YC74ElgFajRkrlDnHihNYiDEJvkLnojcB09O
         HtFfpWR8AD9fomQj9c3zRfYYgdgQx/e7zrvBli8jKg8HccFuiPPVUiAkhbLOH3X4AymC
         tS/Qghb4UQm7C5btAAUEqhhfLeJHzPE+5Vl7jvTLBTSaluR+ruNo9/OdRo2mFRn8Zeir
         ftrWvm7dESyms1TMR07QbK5sWprwMzvRVtctqooBzNAff4vzA4jB9v0NljOaZRgeJ+1L
         y8Bwd1FBtNRdKwcVOOaPHQ27oFCWOwbCwn3zTQge+cIWWLAmllM/fNeenjZdfViSButn
         uEGQ==
X-Gm-Message-State: ANhLgQ0ysohGU+h1ZDu4jgFHG+zWO0XGCrDDRLB4sDcPsgh1DTWTzKuv
        lLj+kGBlF0Wd7S7t6iju8AQ1d4+t3aI=
X-Google-Smtp-Source: ADFU+vtGCQIEvv9TJmJdgHVxmdJnYcK89TnAfkhWphin9m9AFaH+d8hXy5qsTPOm03bHlWuHDBbTGQ==
X-Received: by 2002:a63:d351:: with SMTP id u17mr27096647pgi.396.1585056639070;
        Tue, 24 Mar 2020 06:30:39 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y30sm16555105pff.67.2020.03.24.06.30.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:30:38 -0700 (PDT)
Message-ID: <5e7a0b7e.1c69fb81.fc99.d296@mx.google.com>
Date:   Tue, 24 Mar 2020 06:30:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-145-gfd0aa3aacb6f
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 2 failed,
 118 passed with 4 offline, 6 untried/unknown (v4.14.173-145-gfd0aa3aacb6f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 2 failed, 118 passed with 4 offline=
, 6 untried/unknown (v4.14.173-145-gfd0aa3aacb6f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-145-gfd0aa3aacb6f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-145-gfd0aa3aacb6f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-145-gfd0aa3aacb6f
Git Commit: fd0aa3aacb6fce4848eb71f17acdfdecc12e8e82
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-140-g=
00befb200af4)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 33 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-140-g=
00befb200af4)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173-140-g00befb2=
00af4)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.173-140-g00befb20=
0af4)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
