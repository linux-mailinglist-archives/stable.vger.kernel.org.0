Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0233DAB07D
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 04:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404311AbfIFCB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 22:01:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35829 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404307AbfIFCB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 22:01:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id n10so5189357wmj.0
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 19:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=as02QgxmtrA6D985ENkLisXcl2TvRFhj26FDYV5dQNE=;
        b=2AkplRY6QYyJd4H95pVaOBGgkY9XM47LgVekrP6MIneJ+leoF6mmqDyXLdDA6UE0Qk
         fw0J2l60CaiIt4fHWouNNccWc4z3hg6F82n859Fbflthxhv1JR/IArkzJvFmE3dUZ85o
         zjTkP7uiPl1slPzv8bZjO1zi0XkhJ/4pYuxAiNDsl4Ys/C6/GPyK7idOFwdDcgd94WKp
         J4/WquXZpzwyTx/BIO9ODSL2agWHglxOGpAG5sbG0bz/rwBRmFnBnIEbNZ7Dj33GDYVm
         g09PcZjx0RKs0nNP4isBc1CJlMZlixOzzZGaotcC6gho+vG3A0Le4uz1DDP2bivocHTF
         Odog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=as02QgxmtrA6D985ENkLisXcl2TvRFhj26FDYV5dQNE=;
        b=rIG9y0Ivq/mkjhVl8jP8Gb0SCt0UQVn0aWayGq1+nfcKUwwBeOUtgt371KkSpRuQCP
         As8tSF+yG7cQ6/sTKvIrcmkfzsDErWnu2z4ABrfmNeEjN4UyjjJy0dGfCJbRpDLHQO2f
         SfxB3SIquILqcZy98QcjzmjJMR7SDNYdRmbMvDbuo+TEB9rm1o+/A8xk8fRBGl1J9/AT
         rFl+2pzF5SJTz7ccrprFO/4LRUdJhZqhJ/PS57vpTlFEIRvdSk0hx2qis3Lnb7Ch6Tk2
         nRHV7mBli+r1g9lFrGK7KtFnZzMmKroK136Jc6WhY1TrbxH5GiF2sLT0nmeI/3CoHl8f
         QW8g==
X-Gm-Message-State: APjAAAUaw+76caZE0HRi1VB5x1/pGavH9g8aqbLU27Ebl0izLdNaCcVO
        fkOVHs+tGQh8u/2ctGZPYh+COJXnd3j0Hg==
X-Google-Smtp-Source: APXvYqyv2TEcChHw+9y8nrBQ9kP3CozKgiTe3R74B+cMEpkiv5LYYIwxq6JJEAfjYJl93ntSykiRJg==
X-Received: by 2002:a1c:f50c:: with SMTP id t12mr5261057wmh.49.1567735317002;
        Thu, 05 Sep 2019 19:01:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q15sm5491993wrg.65.2019.09.05.19.01.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 19:01:56 -0700 (PDT)
Message-ID: <5d71be14.1c69fb81.c17d5.b5e2@mx.google.com>
Date:   Thu, 05 Sep 2019 19:01:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.190-77-ge794000482e1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 118 boots: 6 failed,
 103 passed with 8 offline, 1 conflict (v4.4.190-77-ge794000482e1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 118 boots: 6 failed, 103 passed with 8 offline,=
 1 conflict (v4.4.190-77-ge794000482e1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.190-77-ge794000482e1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.190-77-ge794000482e1/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.190-77-ge794000482e1
Git Commit: e794000482e1e5db19d05acb6cbeda8c8387069b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
