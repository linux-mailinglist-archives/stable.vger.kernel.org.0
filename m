Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91F8920CB
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 11:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHSJzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 05:55:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41661 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfHSJzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 05:55:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id j16so8017971wrr.8
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 02:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cL8PK6euVD+RFb8/ykxmEF3JOjON27VtlpLKZyuYlHQ=;
        b=uxrNO1B/twhlRTS93Rhi+Wsq6yqjzer3+mOxbXQmcM4npDMihh9n5LY6q2UcxVTlWI
         R3Ez0eS8h65Bklm+J5ALfX6tPsXz4pxXgSdB/zBdxFRPWCB2jqjxIcmmUR0/a0kAfEx1
         +NfVZ2kgTe6LArzI6ePccYM+mlcm+/3tw9ylPiLIY/F0uyhgi8s3+3IROWbrAI0641Tr
         c8pTNIgpfwDn1e52zFqVmTkDnclk1vQlj2sFvxvNTHOWhKlBs4UFoQ9Dz/Kh6tbr8nPy
         ONaPJacXLCxSFjyqFdJheDJfQDegfaj7rqfrunE+tslvv7q3sTy7gvnZyv7Q4m4RgMtU
         o2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cL8PK6euVD+RFb8/ykxmEF3JOjON27VtlpLKZyuYlHQ=;
        b=HtAlygpBW3LpdsjnO3rlJyxNgTISstArzZldpA64I/kwUBB5bGPlqlOc+tC4f5p8Ra
         iprEDbmgrThCIFbz1bjJ5HuvMDc9vYEYtPCw7gKpPZ+Stw3cSNBp5lp2GjQCxIxwpjvD
         MXsNOvmDrvVpzevJ+GlX+oLyqJzXEP8/yDZXk85O5vjWAODBTGDeY8bwC1jI9rparICV
         jWxQWC67yHrNNOWVQD0MEzwWWKdJyY+lo9JaH8pF05nJFN6GV68uV8xdNPQw7p/bAfSP
         iktbNwXxX8Zx1uL7awIA2iYqMc9LYDWBpPBP3843NSMjSDIYAkaC+7niC+8zNZe1HR5K
         kDeQ==
X-Gm-Message-State: APjAAAW8SFXTPcyETEK9ZGrKdo7etgD9chMBtZ0KU9+NHllrLup/Nyn/
        FbPSDZYX8zEMOFT9jvnDhYXtM6c9ROs=
X-Google-Smtp-Source: APXvYqwjW+qRnNhGEQnwE4NpR9rFcmknuIq4tqX36BwUat6gBGor1DZo37iidsMGbDX0MEgDKCUCwQ==
X-Received: by 2002:adf:fad0:: with SMTP id a16mr13858072wrs.195.1566208508099;
        Mon, 19 Aug 2019 02:55:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c201sm27936214wmd.33.2019.08.19.02.55.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 02:55:07 -0700 (PDT)
Message-ID: <5d5a71fb.1c69fb81.85d30.7700@mx.google.com>
Date:   Mon, 19 Aug 2019 02:55:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-160-g404a6b65b19f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 127 boots: 1 failed,
 110 passed with 15 offline, 1 untried/unknown (v4.19.66-160-g404a6b65b19f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 1 failed, 110 passed with 15 offlin=
e, 1 untried/unknown (v4.19.66-160-g404a6b65b19f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-160-g404a6b65b19f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-160-g404a6b65b19f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-160-g404a6b65b19f
Git Commit: 404a6b65b19f5d3c6d86cf6b85b5feedb8bfc73e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

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
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
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
