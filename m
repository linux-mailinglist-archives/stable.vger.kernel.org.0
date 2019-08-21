Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9126C9715F
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 07:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHUFGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 01:06:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33479 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHUFGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 01:06:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id p77so3882945wme.0
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 22:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xrs7oAOzbPM/jGW76OfxDBw8H5D0N2s8y6o4xKhevqw=;
        b=Rb513Mr0PSqk/rQg8RlQTAKG6Pk8LMLzad8i9vnBXCWss/P5JKVMHPDtmewli3gCur
         VO7rBCWp6QI+HWSjA9R7z04I4DmTyRu93H/wulsLEN9PM6uDKwlxEznzubYP89qVaRub
         yzaixNRuXgXonF/m7WAlPnwGIKWY1i9AJ6j1wVh8b0fEaquBEzXj9zdEHDaZqelWsFVL
         LwOhu4aQEJAGUc4QjbNs8LxJisYdDeJClc6qz5AY2rgm3dVfUB0uVkwG7Rl2AUh8GNc+
         t7tXA4QzqnEjsB/2I9bGoGzFpqZ7v5SvBLOFp60qxQEz9u5urQA5DepxA08wD9bgBBhu
         mxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xrs7oAOzbPM/jGW76OfxDBw8H5D0N2s8y6o4xKhevqw=;
        b=sS0XtHSzOOvCmC43NdAbMtOhHC8iKCuYYWc/CUEUevV3dDRJa8AQrKrmuQXOCXITgt
         yaqvxpSPXaQIDV02qy2xa/9gSFcNE880WI3TyrX2HXVTUtemCMVIhGoIE18Kv2XDql7v
         WEZQfFv8nfo+HdWtVXXW5BgaZAy6j5WXLAlf/4d9qAURScXrVdRdc5dAqRlsR70M1bV3
         YxxL60HaY+N6/G0gu4ZK2uJglDgDaQoxDwTnHRnw+zia2oP9jiqSD3L0Cj3TKMS03OCw
         Er5TkEP+5CQYxIICnx8aVo7UrWgvAHtJzHnPPF1YAbFrgZJPjrjvKQhYkf4n1Yz6Y4We
         0UgQ==
X-Gm-Message-State: APjAAAX326SSxX5Jt202aJ22y2C6WbuMdtUd29LHJ5GimPMrDAvRLyrO
        PRLqA9Dl5etx0Dc90epGPHsu6lyMoHsHpg==
X-Google-Smtp-Source: APXvYqwbgtumBo+Wh+JirG0c0ov8HsbbLTE3PSPgCTcFe1IxTyPsGZ5mL1llBEp/jw7t8uwmMHnG1Q==
X-Received: by 2002:a1c:2d87:: with SMTP id t129mr3493915wmt.157.1566364009354;
        Tue, 20 Aug 2019 22:06:49 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t14sm13653064wrs.58.2019.08.20.22.06.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 22:06:48 -0700 (PDT)
Message-ID: <5d5cd168.1c69fb81.b7aca.dbba@mx.google.com>
Date:   Tue, 20 Aug 2019 22:06:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-108-g43d83221544f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 136 boots: 0 failed,
 125 passed with 10 offline, 1 untried/unknown (v5.2.9-108-g43d83221544f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 0 failed, 125 passed with 10 offline=
, 1 untried/unknown (v5.2.9-108-g43d83221544f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-108-g43d83221544f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-108-g43d83221544f/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-108-g43d83221544f
Git Commit: 43d83221544f8dc5dc4b00b2a09af1d0e359ae38
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am57xx-beagle-x15:
              lab-drue: new failure (last pass: v5.2.9-108-gd3ad3ee990bc)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
252-g0953e780f37b - first fail: v5.2.9-108-gd3ad3ee990bc)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
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
