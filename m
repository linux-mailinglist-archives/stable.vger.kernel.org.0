Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580A9384A0
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfFGG4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 02:56:35 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46071 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfFGG4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 02:56:35 -0400
Received: by mail-wr1-f45.google.com with SMTP id f9so942742wre.12
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 23:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H5o7ahuj8beM1VlZUYu5wUDdFRRLeHBiUcP6ZZ3QnCk=;
        b=sAmjjVK6EMrq1iARJcr3tavr/lXr0fOCZrj7U/8U0xaegJjF49ZZgCr4r1sKZjCRPh
         E2awciu7k8Ujk+iYDnRRsSC7BhlgTM5iB+VCdxWIL0PKsKTZue3pG3roIASw7hBxOFWi
         vRgLBcx0/Ya0eHok3I33rW9OpeevKy28fx9ikkt0UB5LIhVrtM84cswj/ZX0yVLAQhJ5
         vH5q0VxAqxPh4zx8Pn3QtdjWJEBuwa15ay2/VNJmS9IBqbrJG837Dgzg+Q5OODRCUV2o
         ZRfKr/LTt0idlOszF6w2StNPIkO5tcSl+PKY8XMngeieLWq23ltCcXKd14PieGLCB2Z/
         begw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H5o7ahuj8beM1VlZUYu5wUDdFRRLeHBiUcP6ZZ3QnCk=;
        b=J0Dzp5rhF/f3AKcNrpnNUjt+eKqt5/WKt7x+04N3bfDnWjmRhA5FzV84OEc28OqMEq
         kDoMMCQY43h1tpQ1IybmsQAE0s9vbQiCuMTI0Ry9rEuBnnncnxs8pKH1PxU75FKegqTy
         JwUusEhEg1toxBdQF+A499R/Oal+kNzuip3AE9VCo2ycoO8C2iXZcw2o8Sk2zT2pr7oR
         NVJH5TXHS/Il1M5V5aZvNye1GZUT7KQQypoHmbYKFMrMxkdqLOKY1vHdAZWfTdKyajHf
         +2q6ztSjCrFkY9urSlMq8xLLnkd+8DhFjZ/UYgo1NLKdqANT5IIt/rnxP9cuJOt0hJgs
         vSwg==
X-Gm-Message-State: APjAAAWQlXpwjwvwwyuZAj3TZYnDn6T6JqdOY0tBiKvQyzYkdLGRvD3L
        Va4AcF4vpuDLnXVzU250k8F3G+sz5o4qEA==
X-Google-Smtp-Source: APXvYqwPQ3LrA5nBSCWEX3pLJg1qAkVJ3gUTekdhjTx63mmpiGyiJaSU6UzukwpxFXWUC2WS487Zww==
X-Received: by 2002:a5d:6b49:: with SMTP id x9mr15643588wrw.170.1559890593548;
        Thu, 06 Jun 2019 23:56:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm1636902wrh.91.2019.06.06.23.56.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 23:56:32 -0700 (PDT)
Message-ID: <5cfa0aa0.1c69fb81.c5f66.899b@mx.google.com>
Date:   Thu, 06 Jun 2019 23:56:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7-86-g0765c25688d0
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 131 boots: 1 failed,
 117 passed with 12 offline, 1 conflict (v5.1.7-86-g0765c25688d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 131 boots: 1 failed, 117 passed with 12 offline=
, 1 conflict (v5.1.7-86-g0765c25688d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.7-86-g0765c25688d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.7-86-g0765c25688d0/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.7-86-g0765c25688d0
Git Commit: 0765c25688d0a4d2e117d61e5771cea2fff45a98
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre-seattle: new failure (last pass: v5.1.7)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-khadas-vim:
            lab-baylibre-seattle: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
