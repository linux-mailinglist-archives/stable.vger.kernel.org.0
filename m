Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229D38F8AF
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 03:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHPB72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 21:59:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36824 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfHPB72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 21:59:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so60974wrt.3
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 18:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b0OErWDbpXMERdfpz1wX5MgFRYV59zBOn8QavVcr+Xc=;
        b=yiYrMso+f8iDSKbwNpmEr8shDVfmxc7jBA7YMPSUwIoWuUulUjhQncpZsyeH0Dtagd
         eqwwuYJHpbIRZ9x78w5seTorZ8Aurtf9ihjepyrqQ1j7Qxe29EgLc7XayRvUO/obrc5o
         n2835twefUnUawur3m7MpUyjKVhLROzlkjKtkRBpN5Zgnn8bVFWbRy7JjLbrAwS7zNKx
         /fu0mRZ/TaGwRp2HF7QpLF3ipnzVVJY2VBAQq7c+8qJg6hsTUxc6TEjdYGgvxsM1cnQO
         0mPvxbq9/AskXLaosjkL/7kVzZZrfaYl77EZjtNKG/32MKXMxkEWabM1XhBuzzOMSurt
         vKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b0OErWDbpXMERdfpz1wX5MgFRYV59zBOn8QavVcr+Xc=;
        b=RTvkMgK98ShMe1tcakfHQ2jTQjz/YfMtzoeEQKri0lExmpyYA1DzEEE140fmkpmCqx
         hKPl4tTw5j0RVL6Pgm48HRYcEBF89yYvJRdbHMm59RCcF+i+vzWlPkYrxSWwGYBjL4Zp
         80noXZDtRC/nhCSptlhxGtIaYxR2tC28MmHDHV2NzdeOSub7dD/Y9cTVHRQMq6ly4qXL
         aKuTKOmwfPLTVWR5HcI5+6gWqwUInBgKbb4HB3XHwbZ6BvVFcts+XE0Bng2TcpKgEdfq
         teKRun/eFO/WCRCCWKQZ4vTFcmX19RCNqtE7CeqEngHxnH5i54AxTNTjiPIbJLr/KIDm
         tDXg==
X-Gm-Message-State: APjAAAUTPxYtiV0X2swWbvEEZ20sgfMJaouQW7fR1tZnMdKDktVvyvDF
        a68bgju3QjJ1tZDTAXX6pd0gsFX6oTSklQ==
X-Google-Smtp-Source: APXvYqwqmRN7V5gah1VuBYD66ZPnCkHvoAh21ZZ6DJNRevBi17nWjIgrNcPobZ7xx36Vy+opeGrZ4g==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr8452135wrn.184.1565920765715;
        Thu, 15 Aug 2019 18:59:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g11sm3805179wrq.92.2019.08.15.18.59.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 18:59:25 -0700 (PDT)
Message-ID: <5d560dfd.1c69fb81.b41db.31fb@mx.google.com>
Date:   Thu, 15 Aug 2019 18:59:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-92-gabb1bb8b9ba6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 133 boots: 1 failed,
 123 passed with 8 offline, 1 untried/unknown (v4.19.66-92-gabb1bb8b9ba6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 133 boots: 1 failed, 123 passed with 8 offline=
, 1 untried/unknown (v4.19.66-92-gabb1bb8b9ba6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-92-gabb1bb8b9ba6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-92-gabb1bb8b9ba6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-92-gabb1bb8b9ba6
Git Commit: abb1bb8b9ba6c66716095994039bed6c81200787
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
6 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
6 - first fail: v4.19.66-92-gf777613d3df0)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v4.19.66-92-gf777613d3d=
f0)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.66-92-gf777613d3d=
f0)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

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
