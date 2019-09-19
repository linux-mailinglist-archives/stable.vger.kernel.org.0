Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6AB7D53
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 16:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfISO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 10:57:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32781 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbfISO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 10:57:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so7377284wme.0
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 07:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P1eOk5neT1sHlGRtIZpJKVIvuHMGjEoHH99cWVbzulI=;
        b=ZFmprA+E3Z+fk2GFnoq+QZvkxChLtDFzyDHZJMmfJxQ/mjmcJ82TwqNX/nh0tXfpjK
         flfYt4iE6Y/BiAbH7O8ZrgvRqkjeyoXXdqYboX0uOgbDvVBfiX947TdnqjJNrJlT7MQ2
         f4q42S2o/6vcFUmoRsi7MGfG4VyRVs9OIjMrjBEmcrFpONp4QrfgVULYfZHNIWpog69u
         P1XD+A0pd1M2mVEw/Cu12zZT1AKyPStuUZ2M50IboiR9kU+hGrZq2JX03IfhtzQHxdu6
         3cfcg4X6cYMur5geqLLbLehRBQ2FrSfGCvfnmICOJLcX+8W74CKf0r5hYn8TVP056foI
         xFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P1eOk5neT1sHlGRtIZpJKVIvuHMGjEoHH99cWVbzulI=;
        b=WeWZV45wMWio5lLUDxWTtCgx5fpdQ+zC1xmv57jA5s983N2+6UGyCwIo4PPwsGPytk
         /6uXlYQt6oNkIBLqKllbv0lI1yfQCm7R3qQ5/u9na2cmQ3AICzAIY9Jew5S27GskmLCm
         h6sQkoYS4nmysIR7G4FAhwlPqk7RCpxhYu9uwEFPiX04fGfzJO1MzaH5GRgKsHq98do9
         MCrMH6v7YiAu2qtfa/AewWskovfovtckvU17uumASvRA7r7SeTv/6jZXbW1tKkOOxq3u
         r+roLITJzPBRYJ7idNoha4KZ7HuVRp0+ahgVCsD6v08H71dNqedtW66UjFrpKlnfKmxE
         iZfw==
X-Gm-Message-State: APjAAAUfsJ6vaOrLg7PlIsZsKQ9DA87OXl4P0rcTuHQQSMtZrIYPTgEl
        HReaHvQ9aP0Svq//KeEr51r7sC64ON0vag==
X-Google-Smtp-Source: APXvYqyz+DfjLq7ixqjeOtcs7ITghn9ZmLVEdTolmv1I5aTRcBwpBcfl8TEImQDphVjqMYpmBrvkjQ==
X-Received: by 2002:a1c:7f4f:: with SMTP id a76mr3241510wmd.117.1568905070057;
        Thu, 19 Sep 2019 07:57:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f15sm4877551wmh.4.2019.09.19.07.57.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 07:57:49 -0700 (PDT)
Message-ID: <5d83976d.1c69fb81.6a1ac.5b87@mx.google.com>
Date:   Thu, 19 Sep 2019 07:57:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.16
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 145 boots: 4 failed,
 122 passed with 18 offline, 1 conflict (v5.2.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 145 boots: 4 failed, 122 passed with 18 offline=
, 1 conflict (v5.2.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.16/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.16/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.16
Git Commit: 1e2ba4a74fa73f911f5d0f5f8fb0f6e621024842
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 28 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-sei510: 1 failed lab
            meson-gxl-s805x-libretech-ac: 1 failed lab
            rk3399-firefly: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos5800-peach-pi: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4ek: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
