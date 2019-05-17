Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D547621165
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfEQAks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:40:48 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:45370 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfEQAks (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 20:40:48 -0400
Received: by mail-wr1-f46.google.com with SMTP id b18so5188658wrq.12
        for <stable@vger.kernel.org>; Thu, 16 May 2019 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cjlx2QwcfEO0HbcfG0jKkwTp5bOGrlZZo6D5hIldQgY=;
        b=gEmb4u72w0lqdoVpMgjNJwXGwM7P5t1G30xnzuHR16mPmvBcb/AGzMBgfpl94Nauap
         57uQjAwbi0HR0Hxp4uyi9QedZk3aKEqsCTFM41N6EqAY9WFCzrZO2WKgHBo2PtoVPRsi
         Q/gNFgCl1RRKSDcej3DB4mHjsH20fvUAx+otBW7l31sEmZy3ouF0Xi3shk02yaAO7KD3
         6dGM2jxjTcpcUIum36oS3tIblHz6C5cVaIE0G02/1DFvCM86+Thz91rZenlalBMYALS4
         V5vXmEmNOHJr2hV+RaXPQCWx5NZ3w1Q/SHvdOOf9zftll83epmDEXwG4uEKlBEzCWHkX
         JBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cjlx2QwcfEO0HbcfG0jKkwTp5bOGrlZZo6D5hIldQgY=;
        b=K0f1xXfT8bnm9lX9Xf9s9TdHayK+PUzJvvWeWPOiXguaPfI7Ye05GC3ETxcyNVxKDR
         /f+KSvw/I4sfm32nnjmIVkdgssyesehxfUPthDJs1Wm9mJGqyvlAcH4ah9ax7i/GmXG9
         ryq4Ca1xckWOrgrhy3ZJp/ctBBoGAFHMsFnTMVzj5bYp8Tx7MlP6HMHIaxxRhBjC+B97
         PVKqjcdZz1u6MqfKCd0ZxvRKirP366JyqjDTcHXT27T4PHnuCwaml/ft1Td/qqPriBw0
         Kn8uGMmZA9uCnYxH65ivuSxMVWPQvWNyQ7fTvL/vu6VRWazcpFb2yP9+NIYQJiRBtr2l
         vq0w==
X-Gm-Message-State: APjAAAW8MBN97t34cFI3Zg22tVPxKFvKbqZlyUUGMkBf2aBAckw/ygIr
        Znt+l2pJA/wTWzx2Wjbud7KtOyPlHqQBHA==
X-Google-Smtp-Source: APXvYqxTFwre698FxLpf6MBYHNM7Gieu84lKBriQbwJf8HhtRSyitiuG/FEXFJhYii24+wob+WiChw==
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr5309085wrp.37.1558053647398;
        Thu, 16 May 2019 17:40:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z5sm6998749wmi.34.2019.05.16.17.40.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:40:46 -0700 (PDT)
Message-ID: <5cde030e.1c69fb81.5ffa0.8af5@mx.google.com>
Date:   Thu, 16 May 2019 17:40:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180
Subject: stable-rc/linux-4.4.y boot: 96 boots: 1 failed,
 90 passed with 3 offline, 2 conflicts (v4.4.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 1 failed, 90 passed with 3 offline, 2=
 conflicts (v4.4.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180
Git Commit: 0f654c12cd720e65f1fb3174a7ee468f1daa09e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.4.179-254-gc=
e69be0d452a - first fail: v4.4.179-267-gbe756dada5b7)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.179-267-gbe756dada=
5b7)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
