Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27B0824D5
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHES1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 14:27:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45049 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfHES1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 14:27:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so85354658wrf.11
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 11:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LIQ+BTAfYOlvy4ObHsv0M1Pyx3cDYno+rPPuaXC9he0=;
        b=olMmDoeXgFg0rtDpZ8yE1f0yLPfwPLbM2bqNexuB7hU52vT7hzT2VxUG9dH2mfyO/C
         AkIEgeQQD4Et2uvh/9zlOjLR3ontn/x1w9/2lhmYFri4MXGwyuS3ATFWH3w4IBSCm6As
         1ceceVPd6lSNafomm4wF7W0rCArx+dfud4VptrYfv5TmCAmNToWw/0AOwSmCL40ggS4x
         5Gp5LnPi+3Iptno3MO9x6qFuzGZ/azxftCCoHT1umPzjI3aVF+BFlk3/lHcyYwiIGcb3
         n4TndaknBaKMkVLihsurM3lYY1X+g5+seZsEU77u8dTERFKTlbJFTL/6K8ew5La0LsOh
         Fgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LIQ+BTAfYOlvy4ObHsv0M1Pyx3cDYno+rPPuaXC9he0=;
        b=go+ineyvaVG9SPpy868dZGYTjkmy42/1b4Q4GfIVxQ3aOt8OGKdqK4Voy37XRBMpA9
         cCuultjqfK3eK43hRLaxCdX4++xXsfl7GDT1k9lP9bjCmUc7Q3FbXA7a4W0tLs3p53B+
         1MFUVsXSPYJ2Uw+15Vf0dk+mNHRwArH6XwsOXJV/1JQKN4qvEnWQNcHHCYs/7GxJlhjC
         gFyk9ZocZocLj3kRU8wIBqQkIcb3rWLEnHeFWJm+L5taVD5KwHBssylnQZI7swK40x4M
         Z5BjLHVgQF5wdKMWRbm/NLicgr1KjFk1B7CObSkGcqhRr2lqaNahrtClp5gyLPvj6KgM
         qLwQ==
X-Gm-Message-State: APjAAAVUkvUMjr9C6bGoinUpDAR8s6xI7uSUXqwJOA+QSAmWrITDWdCG
        NjDBbxD4Oa3Om9ofR15bKu+aNdqdqmI=
X-Google-Smtp-Source: APXvYqxa7TlXz5imr956Vf8nenNVomCCC/ZSAH26N2M/dv4aA9HJrlTAS6VTLmPN7z+eRfRygPMnhw==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr23125137wrm.235.1565029630753;
        Mon, 05 Aug 2019 11:27:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a84sm110310708wmf.29.2019.08.05.11.27.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 11:27:10 -0700 (PDT)
Message-ID: <5d4874fe.1c69fb81.14163.7147@mx.google.com>
Date:   Mon, 05 Aug 2019 11:27:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.6-132-ga312bfbb74da
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 134 boots: 0 failed,
 93 passed with 41 offline (v5.2.6-132-ga312bfbb74da)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 134 boots: 0 failed, 93 passed with 41 offline =
(v5.2.6-132-ga312bfbb74da)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.6-132-ga312bfbb74da/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.6-132-ga312bfbb74da/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.6-132-ga312bfbb74da
Git Commit: a312bfbb74da87b0c6822845b2cb9932d43c9208
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 28 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.4-=
235-g44397d30b22d - first fail: v5.2.6)

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905d-p230: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxl-s905x-p212: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab
            rk3399-firefly: 1 offline lab
            sun50i-a64-pine64-plus: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm:

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
