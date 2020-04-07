Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6E1A16B5
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDGUXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:23:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36529 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGUXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:23:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so1668391plo.3
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UXokoAGuLxiwUh1ak+Jll9I/TC40PlzzcgA8+hBf6RQ=;
        b=iMDHdKprjraEaHicyDyZlT8zBuNcVB0JlqRGFt07oFTUumA9QdPNXsV83Qpn3li5Z9
         3Dsg//7JxUdcb6t0Xh6Cb3DqYsV95RxE0v4xHLvMxjGlI1X/LqZr1a9bb+2ycuvquByK
         pZmQi1/ONVyyR212H8MPMkDCQNwtLIYMdHp9GZzLFHpWqexgOmihXdKFy1VOEwOxORKd
         cqPnUlZspWsLAUawsaT0NM0p8za5DPy1TWZ0C1q/iAbOEMeV7bfRLq8QxWypRA4L1IQX
         jXm5WYvKxLr5k/muBRhD29J+BF+vKeCaQ6TxGWZYA/guQIDh0seFF+1wgNNY89HTeaug
         a/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UXokoAGuLxiwUh1ak+Jll9I/TC40PlzzcgA8+hBf6RQ=;
        b=AybosZnBxuBBTEOFkGMhg0ozTvlzRbT+3lC55tpTn3aCNFcXyBte5kNxJ6ow7OkRBF
         rXrsmkHGqX1/CQYp3V2zi9qk+VwGBP55ugTPnSiGtHRHAs+aD1nci0wcr+aWu9HlF48u
         S0FDZHwjZeJHFVBf8dIBcQMqFGI710UnwBdXW3u5ogGhYgi8vR5TQIE/SbMJePTKbxRU
         YtRcXJwnJWo+iniGy4F7LbeOMVwNTmUS+zFXpIcVsfRm6ch/1NXOfHIQlMnvRqf9jT2E
         q5RcFfjPjNTabKUKkbrADZA506RCqkaeAnXrAn+fynYoQRQ39qbWY+YbuQ2T1ovrzWmX
         Jaag==
X-Gm-Message-State: AGi0PuZOFilxcOGj3GC5zlMTdQiQtFW8s5L8e1NXMstAR0nyIchqGAfR
        xnhliqQxwqT9NCp+W4Hc8BCRHyyggNo=
X-Google-Smtp-Source: APiQypLXAxt3YCAmp2Z92lI5AN0KcczNRKdkO/Ay5g4FAjXDFr7s/BjKl6I2NgjF2KAcfu11jbsa8Q==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr3308459plp.77.1586290985579;
        Tue, 07 Apr 2020 13:23:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b133sm14927449pfb.180.2020.04.07.13.23.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 13:23:04 -0700 (PDT)
Message-ID: <5e8ce128.1c69fb81.ad2b1.4cf2@mx.google.com>
Date:   Tue, 07 Apr 2020 13:23:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-14-gca15f5517c01
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 3 failed,
 122 passed with 2 offline, 5 untried/unknown (v4.14.175-14-gca15f5517c01)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 3 failed, 122 passed with 2 offline=
, 5 untried/unknown (v4.14.175-14-gca15f5517c01)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-14-gca15f5517c01/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-14-gca15f5517c01/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-14-gca15f5517c01
Git Commit: ca15f5517c01c19340ef1b1f6c8139cb30f82b30
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 47 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-13-g71660814=
22ab)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
