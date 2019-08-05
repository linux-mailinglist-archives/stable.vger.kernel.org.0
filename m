Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AE282567
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfHETPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:15:49 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:34939 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfHETPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:15:48 -0400
Received: by mail-wm1-f46.google.com with SMTP id l2so74030798wmg.0
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w1t9ecRFuxuteq9NZKtOaPNl+UPiIqybhQpuoST//JE=;
        b=LlC2j3cOZ72TPEtRDxienW7lROUEyYiX19odd8n4tf+ri3Ln0XED+UuJTLitrjZaAl
         F55AlZ6VQqha9C3t9HXgt/p7pboDNau8iHDidzqyWhAXr3waYtGQYqeYoDjc0JKNNShd
         uVVSioWKckfE2sicgFG8LTFyjxxXbE8WPBE3FdOMcXr/l/NBakxIg0zF0sdhMfq4DBzh
         x+1rTEKN9ZFSdao+uylWenK/qKD2mN2rzKTIGU86niDTUbVA2zZE5q6kNEjhQpL/FoS2
         z/ZLmeaiRbnG3ZDoq1OxFLz93La4eZMNk5SxHu0wy4uSsLr+ISZb1RHqGCffm71erLjJ
         ADVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w1t9ecRFuxuteq9NZKtOaPNl+UPiIqybhQpuoST//JE=;
        b=Od1D78k5clo/JtaLHH2zt0b0S88weiIbdwpbhQyuXZi9iZQY47kHOKN3/RiKZzEGIO
         Ui0zt7NST/nPXuPGqHNc75s6U81AWMiZn9OT6sKWzWY9X6sg2HYh1dYJX4dEr2CCjAUJ
         LYo50HTP5VG4PcwDuJd9ucATuR/GM5NJqy7gicaJrWICC54QSTz2ab+I+L+Zp0s2jSWQ
         z7owF9IRXpDifolUqHsaX0k9Ug4ILtEGLOOIoaH7hnsRYwwbRs+yOQqzQcLZSPX1JEIg
         o0TUvaMdr77sAv5fyjzUlwjNTwN2JkbFZ8ChemTYadbHibKhz8zVPQvhs04giTDRSNPe
         S8jQ==
X-Gm-Message-State: APjAAAXQP2id2H0dEBzJ+PxbaXvLb0stANR79iQoV73M+nKnEZge8o5K
        mOD4w6ow+oIsk0nrA6gCaLCcVST5Tcc5gA==
X-Google-Smtp-Source: APXvYqwbqsllK13jO3S3fcoz4iF1pv4sYVK7Hum7h1wf756i30lMz7dG0pgwBoOhdPnLoV6i45DZuA==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr19942126wmj.155.1565032546445;
        Mon, 05 Aug 2019 12:15:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f12sm93044604wrg.5.2019.08.05.12.15.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:15:45 -0700 (PDT)
Message-ID: <5d488061.1c69fb81.b1ff5.545e@mx.google.com>
Date:   Mon, 05 Aug 2019 12:15:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.136-54-g20d3ec30650b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 119 boots: 4 failed,
 104 passed with 11 offline (v4.14.136-54-g20d3ec30650b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 4 failed, 104 passed with 11 offlin=
e (v4.14.136-54-g20d3ec30650b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.136-54-g20d3ec30650b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.136-54-g20d3ec30650b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.136-54-g20d3ec30650b
Git Commit: 20d3ec30650b0c33377164def17390367716d4c8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5420-arndale-octa: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
