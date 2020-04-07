Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D177E1A077B
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGGmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:42:22 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39376 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgDGGmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:42:22 -0400
Received: by mail-pj1-f65.google.com with SMTP id z3so328718pjr.4
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 23:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0WrhtuGTvAiHolplQzOFCp8uMJmZGpkXRTQNU1RlUn0=;
        b=jPOT+umaoEF3aQUwqmokQvtYp3aIyDh17j88Z9YBdJlfKijcfMwe7Lxpco89DoC8/E
         Ny1XL9eb2ahxYn4jT2elqXy1pERg06pQw+w6+Tfz6ZfhXE+nZCOHoiXWQ546O+Fgxb/r
         qK2h+JsAxM4BH0GZGEJ1zJirpC9OzFSLbL+LvEisEQRTdfQsIEapyV6wKLQBoH3uu8ra
         f3nskIfKtdUFAcUs9zcsJ7a2tvNvdwASI2HtssF4oX8cIDCej9lydKz2YnWGvOQZQBsA
         q+64iUFG4VqciZqCGm7wjpcB1Zj55N7f6BqDtCvvPC1QUFZRn1nfz0oefdmv7RXb0lv6
         z/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0WrhtuGTvAiHolplQzOFCp8uMJmZGpkXRTQNU1RlUn0=;
        b=Q+WfM8qv1ZqhJVIApX4mkcqIKjKkcsgG4Sit4/KjmtEg0rFV/xiEyD+YPW/H/waNeS
         /4vU7E2O3tCpdQqSLO6NVS8kjHeUHxmsqrObEYpfemvpOUYccEcw2oD0VRPLI1tGnZZr
         EpYaOOw9mS8ZqiNV0UylDcY+hcrwF9p9mLf4GjQRIVOVjy8j0vfLmmo8WnUlB2mgZiB9
         cy5/Q4VMsqQWzzkRLoJDjr5S/WKCB3Mnc5kz2P2vF1Casms3WsQRnf7FTxvji2Mxl9Ca
         hG4qv7oIgH+zCoB9LMNz4m1bYRHy4IpGVeAI8jBwSmt20Jb7t4pr9IrdtZVvpJR2EA9u
         DMHQ==
X-Gm-Message-State: AGi0PuYI2gTcF+W1BTq/+5MI1ksnjXeVrRyov+moIpCVn3yo38aRfbqL
        pSaAT88LA7yIqpS0uBxYk4ycfJF6jb0=
X-Google-Smtp-Source: APiQypK57TH5YU6m+E+Su+24ecp8TBp3mF+myXrhgggwCX8YyCn4ma4LUKLutr1Mx9Sc4yxlYjeoQg==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr953417pll.75.1586241739973;
        Mon, 06 Apr 2020 23:42:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u21sm728698pjy.8.2020.04.06.23.42.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 23:42:19 -0700 (PDT)
Message-ID: <5e8c20cb.1c69fb81.3e683.27d7@mx.google.com>
Date:   Mon, 06 Apr 2020 23:42:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-15-g7272a1730d3e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 74 boots: 3 failed,
 65 passed with 4 offline, 2 untried/unknown (v4.4.218-15-g7272a1730d3e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 74 boots: 3 failed, 65 passed with 4 offline, 2=
 untried/unknown (v4.4.218-15-g7272a1730d3e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-15-g7272a1730d3e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-15-g7272a1730d3e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-15-g7272a1730d3e
Git Commit: 7272a1730d3e906b608802b86f16e0b4ee2dc550
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.218-5-g1d2=
188f191be)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 58 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 11 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.218-5-g1d2=
188f191be)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
