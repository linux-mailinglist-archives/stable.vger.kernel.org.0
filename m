Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4691C676E2
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 01:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfGLXjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 19:39:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41355 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfGLXjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 19:39:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so8284660wrm.8
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 16:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AS78fkGwPznrOvf/DrMdaP9ctBPtIVJwOugMvrmJs4c=;
        b=S6OH8wl5kJvKwqTv2j3rNwiHcuxJHqTtu2RECfx6xzpjfrqDWkReJnE36QTyGWR1JK
         jZO0Ktwen/sueUA305EjOz1+keduA6tsFIyz4txXj7XUoCOy4q6xuUAExitmSJxLdQfo
         NMCqeLxJM6WK2Uv0z4O7V/0WVDgkJ7s4exbfWG8UT6KJ6IpFFkkS2bSy36Bm75/B/Wfh
         q8UAeYSP46VkyOF7Vs/UqVtOjv4ucZA86NUJGuqCciz+HxkCuF8Vq9SjIbud3h+e6VPh
         UNdUHc/zMIjxwx05pU1T7CAomnHOOIaRxEUF6aUqkEpkgcdHw6ljuNSFTiJPvo0rhxNl
         AgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AS78fkGwPznrOvf/DrMdaP9ctBPtIVJwOugMvrmJs4c=;
        b=FUW0eczZVb4ghFr5Ms/ol/k/twbZ0fcrXuujp0qEN9VXswPZg2ozwwkX1kpDWkqALO
         kqtgzfcMqAP6tKLyNz0r0p00ZoOsrXXH4b7mhS7f6b20HYd/q/fc33ndWipg/588/H4x
         8NiYQI9Y5ZtB+XpxARabuISTGHywuQFJBS3YdPdOKnJ/qWco/a/sXf5jEoZ17pTfLMf/
         qsbPV7jYyknH6mz41FHygkqAxLjtHi6Qt3rmOKzj8E5o68kjg1Zqvn5s4jY7h5CUdlNi
         lky0Z2bpSYWrpvNVGPeTH/z2Ujn95T1hPUkROPRkpI25r7GJ9mZg1CEqpgriC8kY84KI
         4EXQ==
X-Gm-Message-State: APjAAAWUWtom8v1O7ujHwYxNm4eVSdADDq6DDKMpt5joCyMOiQbxMetu
        /5UcxXv/2YnPknzvont78V/Zvz0t7IE=
X-Google-Smtp-Source: APXvYqwWpF0sd0mr+SueTaY7N2LQyPk0avOI4Y5Ow4PLdZai/uHOdMyZ6cgUARWeHZz5XSocQV6ksw==
X-Received: by 2002:adf:e442:: with SMTP id t2mr7596104wrm.286.1562974758770;
        Fri, 12 Jul 2019 16:39:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm3857564wrx.34.2019.07.12.16.39.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 16:39:18 -0700 (PDT)
Message-ID: <5d291a26.1c69fb81.95a61.799f@mx.google.com>
Date:   Fri, 12 Jul 2019 16:39:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.58-92-gd66f8e7f112f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 4 failed,
 117 passed with 1 offline (v4.19.58-92-gd66f8e7f112f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 4 failed, 117 passed with 1 offline=
 (v4.19.58-92-gd66f8e7f112f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.58-92-gd66f8e7f112f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.58-92-gd66f8e7f112f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.58-92-gd66f8e7f112f
Git Commit: d66f8e7f112fefe0c1d2a0f77da022a56ccde6dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v4.19.58)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905d-p230: 1 offline lab

---
For more info write to <info@kernelci.org>
