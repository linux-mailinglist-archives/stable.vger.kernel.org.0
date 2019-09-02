Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134BAA5E39
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfIBXk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 19:40:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44264 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfIBXk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 19:40:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so4486299wrk.11
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 16:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rq2175MxgueJEkG+cVZcJFzwrjRgSznb5VOu3aWIcfI=;
        b=Xhmyx1sH5q9XYjK8ghk7Kf3AwOmm8hSPAjQaWqMRueV5lxc7kukledruXnN2o11M0W
         CAL2W/ewqqDWca+EY0pTyYhHkbIvCbvSHlOzBuK6OoGGVyYgAZniCbod4pWsX96dhaLO
         8XVagpejKm3H/duNiey8GdDUmiOYpv7SZ/raCraOD17ePIEqnQ1hpM2Xety6HiTUmM7F
         q31VSvpf0shEDsO5ZjdOAjLlEEe+QNds9cA18JYwoguXfjLLyB2TqWY4ReKeQCMVtjmF
         VtDzQVAAhC9q4JkfmLVYex9c07Kl/f5VI3pjuooW8+GZRqe44WmHjyzfDCSagnGcTuZ7
         1AUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rq2175MxgueJEkG+cVZcJFzwrjRgSznb5VOu3aWIcfI=;
        b=pivwT3IbV3s/K3WSGwnvS68c5Bshmh2bStdVyZr2dqyXwTwr2bRRBRXR3hJgh3pWci
         nWCmJYD9jEb86uRG13TdltbPzIxH20SJ8fXlv4rfPcdtKpgXMG4cZa5dSIIFpflSPVaO
         dk2QmelJ8s1iL+wEGgRbsw3ePUp4KFUsdS+515NE+BEhtDzVMchczFWvRPVUgHCH8149
         Voq5HAgvPRExHgZfV5xFShM0JzR4p0GqWhVMlf8Bh8Ro7jWTYtH0+/q1x6y7DcgEAv5a
         1hWYjed24JZKfvE6vsDzCAnC5Mfqx+wWy4fuNG7QtKu7szMa1MzNPTASIGWKAFa4vfHF
         3mfg==
X-Gm-Message-State: APjAAAVFwN7rCIfS1ygNfR3oExV4Ei1iQWJGUTXJrFwg5msS7EUG7dOm
        QL0xTidZiCIuOefP+BvczmDVMHln4T6iSg==
X-Google-Smtp-Source: APXvYqz35kYlnKvObLZBkW0rH9s5LMGwgCQh12Nw5vUH/FWcEVNvHwD3nfcKL3Z1pC7GvzVXEKbVuw==
X-Received: by 2002:adf:8bd8:: with SMTP id w24mr39265727wra.273.1567467655627;
        Mon, 02 Sep 2019 16:40:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s1sm56416576wrg.80.2019.09.02.16.40.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 16:40:54 -0700 (PDT)
Message-ID: <5d6da886.1c69fb81.9900f.ec04@mx.google.com>
Date:   Mon, 02 Sep 2019 16:40:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.190
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 128 boots: 5 failed,
 113 passed with 10 offline (v4.9.190)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 128 boots: 5 failed, 113 passed with 10 offline=
 (v4.9.190)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.190/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.190/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.190
Git Commit: 228e87c35b6c083be778d24b64c02ad05015f3d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
