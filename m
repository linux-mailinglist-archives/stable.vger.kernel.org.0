Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FF556BBF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFZOUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 10:20:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54652 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 10:20:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so2303731wme.4
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+V6q+BPPeMNaqobhLn7ruCdtTxB12Orp2PgS6wrByP0=;
        b=BbPKvd07+CN6PHpyyKpsdH0yxIObCFecVt/8vZ4Cf7ugaIn+TFI63bK3td3vGS7tN2
         DCCrfLrJBw0MHa7P1Pc+zUIax3ZbRQCBjJMAXJu8goYC1PR5DWWiwkU358nnADl/QYwS
         ySbmEDRvIze4GDLgzvpPTsMWlRfvWeBpFKpM66X71L6G5w7UXI3izJnQ/0YZjn9NF59/
         4VMQsxbaTakSefv43qfyK+Ck0WtKsesnm+L9fZzePLRDd6lY7LUDXvZ3/t5LAd8ZCRMu
         SKrxzS5xh3SaLk2vURglZPdHQAlrcp0T2GLrkDkBdWUniT19lqDL06oWDDCZ64rxiR7v
         iULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+V6q+BPPeMNaqobhLn7ruCdtTxB12Orp2PgS6wrByP0=;
        b=bFoE7Zdi+EW+B6kNwXwJO8vMNw7wVrKgCf78nMpzeg/3ThWNNnq6BOsgtUXn2uiiPx
         YWLbSErdN+HDlAY+BKhbQwDFpJD/yUi9iuxiOG4WwMhyAajoSn3ayNcMds64R7KGOcgX
         ng+405+Ok6gurF0AV7qNU1E6+pgK54WWqW32jlwR49P6+wcWlgDgmjDVr10F3mqZhY/J
         NyM9+qDyG6o319XHdw/j95akdyuaw9jjdpEoABChoX1edSe1BjQHjcgVD3KYmag3ZOKt
         fJfATlW7oN3rbgPDLijtCSwfjb9SGqHLoUU9f6qQVoKhC5pzurPq7NuiIlJ2Q3OgNlg2
         gthQ==
X-Gm-Message-State: APjAAAVojrLLaPHJuWNG9cZMCRkU9ue6zoKknM+vTjg6V+Of52W37ke4
        +MuVzQTKLAhaR3Lc2cAay+Leu3Vd0yhfSw==
X-Google-Smtp-Source: APXvYqyiO9c6w/uvtwLEtXyBqef2aCKlNODIcpXJGyJuio9pEu5Bl6ZxFbDmaAqs/QNCptNbuykpHg==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr2702217wmg.159.1561558815119;
        Wed, 26 Jun 2019 07:20:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p13sm11824656wrt.67.2019.06.26.07.20.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 07:20:14 -0700 (PDT)
Message-ID: <5d137f1e.1c69fb81.b73a8.ee41@mx.google.com>
Date:   Wed, 26 Jun 2019 07:20:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15-3-gc152bcbd620b
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 144 boots: 3 failed,
 141 passed (v5.1.15-3-gc152bcbd620b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 144 boots: 3 failed, 141 passed (v5.1.15-3-gc15=
2bcbd620b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15-3-gc152bcbd620b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15-3-gc152bcbd620b/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15-3-gc152bcbd620b
Git Commit: c152bcbd620b0ed02448a2b1d198feadebe58374
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 25 SoC families, 16 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.1.14=
-122-g815c105311e8 - first fail: v5.1.15)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.1.14=
-122-g815c105311e8 - first fail: v5.1.15)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
