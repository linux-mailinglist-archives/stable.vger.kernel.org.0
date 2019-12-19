Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30C7125A0F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 04:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLSDr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 22:47:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34490 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLSDr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 22:47:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so4504425wrr.1
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 19:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GfGogAfUg/IxAvv3n+6o6CcZqvyrvp76GwVcPl/bHi0=;
        b=D+Yc9EwjEql+3BUEyWPW45hwmDKVBL2zFBr8yKb784kQxrwFcUNZdCyI3ZlUJvx86/
         mwsF1kSiIEH/vvFhRBbcYOsNeACjZ/+yZZrKmrynASxIIBTnCla0wuXfPBNiVF+C/6NO
         8kmLpEqvHumNhQz5QvPdd9mX51ps2J5o7TtiL0VnmAowcpbhVwm41ho+IkKaihKasGuJ
         hJuGvfvsXtLcPEloXls4Ijd9QYLWNM8V+sPZ1rPQu8a2cOngNTD0WI/ZWgTpE6/78Rbi
         C04iC/hLqWvHXNaIwkpCVdZFUJGWFe6vitp5zVLrF+EVYVvJGkel0Wis5bUt6Ynn62gc
         SjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GfGogAfUg/IxAvv3n+6o6CcZqvyrvp76GwVcPl/bHi0=;
        b=ZsSuYIrkA45YSCto2j9dYaWWRHnlAN4uoTQ8i1o5PsaQkfo/I70512ZlfSRUZAa3qN
         IpRIfyiqb0yeFtMGbEC/skHSatpl2favallsxTjAm5zvQ/ef+dv2ItnvXSPM8quQnhk8
         bfB2q0Lddwo1bfFaapAOcX1PDMHNQdwWxZDPLFWLKfQMvSKqamHMh5xgwIoB2rOLaQQc
         hboJkFXwW3E6vJ/mYySwNz47ZSxtfhiVfO925jCzwA77IwckBHhYym9ARKismJStduRf
         PsccGAoJRGpJl1najXGWZPt7R6EjYonGgz1s2dc8PNQn7GZZGxD0TDJD0ON34N054726
         a/Mg==
X-Gm-Message-State: APjAAAVxRerTbXeRFDMwwMzr40uFR/oH+j26Kjh+VMgJijg4FvfeX8ok
        oOj8GjQrvfaBK/ZcJzMLzbaBgSlj7ypc+g==
X-Google-Smtp-Source: APXvYqztLLCuzcaSNklvjavqY9XBmo1VnoT0OqACjlOS0qLZkdMp02LpDfaS8qxwb4+KqOzIF0IrXA==
X-Received: by 2002:adf:d184:: with SMTP id v4mr6757013wrc.76.1576727245717;
        Wed, 18 Dec 2019 19:47:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a16sm4933293wrt.37.2019.12.18.19.47.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 19:47:25 -0800 (PST)
Message-ID: <5dfaf2cd.1c69fb81.4090c.8a47@mx.google.com>
Date:   Wed, 18 Dec 2019 19:47:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 66 boots: 0 failed,
 61 passed with 5 offline (v5.3.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 66 boots: 0 failed, 61 passed with 5 offline (v=
5.3.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.18/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.18/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.18
Git Commit: d4f3318ed8fab6316cb7a269b8f42306632a3876
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 208

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.3.16-215-g8f=
8658b68c66)

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
