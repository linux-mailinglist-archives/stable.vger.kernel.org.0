Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E00D1AF9B6
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 13:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgDSLzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 07:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725845AbgDSLzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 07:55:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17A1C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 04:55:08 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d17so3628763pgo.0
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 04:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6XTi+LjSrXQ2MQhAqx8zgHVeQoOLBVYABUYm84bzXiY=;
        b=OP/xoN5XvY1+t7UxmuwanbvYeLpdHghvijjSx/q7CvWNZLfRY1tzwNhEkAPiK7jqie
         ddKRaQaQW71X3MejBq7elbDeOuYdRkcL5vB/67/UBjEPQNZN5vSoc0vEC/9We8IZqCb3
         axVP4HJqOKNZ0RU4cpWB+ljCu40VmpbhRYxlIRVDWgZhUslnDjA2tK2EK8adqGsv2qu9
         sJSfIrJ+EyUdwiZKILBqne7UEpd2X8K2QlXzW1m0TJxm4IzjQMsm2U6mccPZtEWMQyOB
         1kNL3y5JtZrSnu0YdAJ2RHOjsRd8RhOpCbNGLTaISHomqmidBujTy4rus4maT5SWHBWD
         v8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6XTi+LjSrXQ2MQhAqx8zgHVeQoOLBVYABUYm84bzXiY=;
        b=m88fKGLRLYBGli0Xh75etqi4D/GE9Nx74hknkB56EveiizwUkNv28RU849zP2FWqMF
         z7jxL0KpRCBHDMsn7afDTVeFUBhjfkCaE64KtykLdliackxB2ztD8wDadDW3i4aJvXf2
         iIoyGjqlcbwvfDwayTpMRguzofRPSEaJkTXXFXIX5BrUTSqejwFMz8Rp7ESog5jlwKbd
         JoyA4ALhR3k/hWoVfJE0lvaB4oS+UvUf53esp3QDdqORK6zvKQg6nVUM+gIqceEyTbEk
         3MfO1TekFbeM6brPa0Q+DJQpHmXTTKp92CGXG4+KuoVUeYWEgnPUL7nKuPCUewPgU3J0
         tcxQ==
X-Gm-Message-State: AGi0Puauy1riSGwOj8Gz3I6+kQwDU8esNNkOxlMkeJ/9Vz+CaUsBRx43
        NvQxMvMovK5A8TXiHrvHYWqYevGxhSs=
X-Google-Smtp-Source: APiQypKWjBhMuZZVTlihG3ufsXnhiKOiNK61otCiXM/pylqj247xdPHzC1iG1jLG8Fm0xtoxqRp0eQ==
X-Received: by 2002:a63:6e06:: with SMTP id j6mr11885699pgc.167.1587297308114;
        Sun, 19 Apr 2020 04:55:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10sm2738178pgq.69.2020.04.19.04.55.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 04:55:07 -0700 (PDT)
Message-ID: <5e9c3c1b.1c69fb81.d2ca1.85a1@mx.google.com>
Date:   Sun, 19 Apr 2020 04:55:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.5-55-g6caad25c36fc
Subject: stable-rc/linux-5.6.y boot: 168 boots: 3 failed,
 154 passed with 5 offline, 6 untried/unknown (v5.6.5-55-g6caad25c36fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 168 boots: 3 failed, 154 passed with 5 offline,=
 6 untried/unknown (v5.6.5-55-g6caad25c36fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.5-55-g6caad25c36fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.5-55-g6caad25c36fc/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.5-55-g6caad25c36fc
Git Commit: 6caad25c36fc06b9e505be0ae53a4a91676734e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 104 unique boards, 25 SoC families, 22 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.3-294-g576aa353744=
c)

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.3-294-g576aa35374=
4c)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.3-294-g576=
aa353744c)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.6.3-294-g576aa353744=
c)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.6.3-294-g576aa353744=
c)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
