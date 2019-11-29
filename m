Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECA510D9A9
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfK2ShB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 13:37:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32997 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfK2ShB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 13:37:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so6688028wrq.0
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 10:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wnzCoQ0hwGrGUYMNGVt11AeI3CzsjNr+1Eof1OHnVn4=;
        b=kok7lWkcfXDIJBGvbTmYGw19O2X11GA4+640YA5ugPYilX4Y9oU1D1+iUDICK/f3yZ
         91EUkV7G3fP8lXYLCvMpL8OioBIEoKausDG2Ow3Qp1UuMcC1tYQzfdDD/GkzCMK25PQ7
         cLlS4sCIozL/T0wA6LGA4Q78Bg4/P79w0EEd9Tkm1MjLk4KNvQGQC3TUA9KjbTG683Xg
         +swYjd+psOgsktwZNm10vETIZl2s2Th7Fu+KfMyGlmqLkJqZ9tuyf21710nsrVfx9mzf
         bLfoEzjW+nuW1qx/RCujvjy6osw15Te6XOLKvsvhUUUC024zDp9uRWgbzl3oE1Z+3dpQ
         6Tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wnzCoQ0hwGrGUYMNGVt11AeI3CzsjNr+1Eof1OHnVn4=;
        b=XxqJJsUPXTAbPnwOQXn1yPiaGy6suLeYiBZvLVn7UZNpNTcD5z3qeZqQFfY8Q8Bv3V
         TUNPXL1fRbLVR9scWj3rMJ4+tLox+gNW/udpjlunHF4wSumu33+WG1+USvlRoyrhHKpS
         iJzdEJBNct94kZC4ewY09Mx8BO1Ct5Ay30s0yfhoecUaHT9U7TCe05zeyLlp051oyRDM
         DnIYiqChiWByZIYodZivgI5f2XhIMk37X1jcuHR8jVsuYhF/fWrc/P0K9ZO7ooRR97cJ
         SR231C/tJhxejN25S0ySd5ao2S/CvtrvcVxhmExtXwhX9VkpMnsNhJY2hKMFUVqmZlYs
         OMtw==
X-Gm-Message-State: APjAAAWm0gGh+So7CVIAu12dbNXVuT47rUUKoYlvXOjLpAebjIsXFW8s
        zADpKW55D/gFIzhlGU2V/igudE//EQd9zg==
X-Google-Smtp-Source: APXvYqwVhEnArxrWr8pc1gsVTbuFxNXQvIbWrI2cAVp0usJDVpE96+8tUvszrPbx15+wC/BHMiKd4A==
X-Received: by 2002:a5d:4946:: with SMTP id r6mr48251041wrs.155.1575052619234;
        Fri, 29 Nov 2019 10:36:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm14867173wrw.54.2019.11.29.10.36.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 10:36:58 -0800 (PST)
Message-ID: <5de1654a.1c69fb81.35abf.eb17@mx.google.com>
Date:   Fri, 29 Nov 2019 10:36:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.156-205-g36dea990ac35
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 124 boots: 1 failed,
 117 passed with 6 offline (v4.14.156-205-g36dea990ac35)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 1 failed, 117 passed with 6 offline=
 (v4.14.156-205-g36dea990ac35)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.156-205-g36dea990ac35/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.156-205-g36dea990ac35/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.156-205-g36dea990ac35
Git Commit: 36dea990ac35ede053b2c69d91cc480b19fbb7dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 13 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
