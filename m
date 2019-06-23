Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1354FB81
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFWMQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 08:16:16 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:35959 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfFWMQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 08:16:16 -0400
Received: by mail-wm1-f45.google.com with SMTP id u8so10647098wmm.1
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 05:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SHBvvYGdxt1TIggWVNqsW5NKXJg10HDf1jn1gIYzqz0=;
        b=X/pDPLouvtWx7FCI2bCb/u7RsDObKR2ti+HwNHvSGBEPHWVI/ksxmxsnCCehnj8rkL
         R7dStDDW2pHiFsOmVdVR9DVYqbxkKs4W9673xJv8fNpfMD27uyrLHbt4Dfqk/IU8kxiU
         aegqpbdK/RuHDVK5O9o/hybiCZpE1kkNXS1dXH1Ci6h5mrdFGjKwKMz4IgizneaPppId
         OP/GcN/veaHqaK9fM9xX2x0xb5afvm7vxgCTU/xIJI6eFtrx6rRn2p7J21/0fkVRk60w
         R8FutlR6DpV5yeO2szsOGNiLVOBQqz3okgLFv22UaqX2i42BiZBgS7aKB5NO9nVhiDNZ
         XCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SHBvvYGdxt1TIggWVNqsW5NKXJg10HDf1jn1gIYzqz0=;
        b=P5qhOU02+R0HhvNvWtLcFmqMx4SvZisGuVzlazJOqNlsVrFeknb4S5hH3mbzgh1BSL
         3W8QKs1JVr/FvE+kMexa3YYB5vJ6MJmeszIYuNrnhjoVovDksD+FVXR2mx9HjWsjLvma
         t7jF85BlLJdOrtTiXgHcBsld9x37CzVP/RynnzA6lqtTe5m9c66/25GssgQgG6KBN2j8
         CvXSg0Pej8zpnNa2nyiYoEFXkUBGdgHi7goVPMNDYuAd6NoyElXJ02eYJR3VwZ1VkZ6L
         0Qk6RaWo8g2CUR2c83/7sjO2fHut49PshEQ4E47pxEnwpqA2vJTwAvS62YwzN8EWw1xV
         hEWQ==
X-Gm-Message-State: APjAAAXSBm9ch9CRvQFjpeTE/WdzzQXjW05iRav/sW0Ac6XNzxzG1WAQ
        P5WH9UZW2MEJc+RccbwQkX0G0+9GelI=
X-Google-Smtp-Source: APXvYqz4sRQqNlK2P1U+e0PlaA2YagE9XOHoIRla8JGt49x8JrhYpiS8Xj0q+R0cbLtFZusSObwzJA==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr5734753wmm.108.1561292173931;
        Sun, 23 Jun 2019 05:16:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l12sm5832180wmj.22.2019.06.23.05.16.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 05:16:13 -0700 (PDT)
Message-ID: <5d0f6d8d.1c69fb81.52b6c.ef39@mx.google.com>
Date:   Sun, 23 Jun 2019 05:16:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.183-3-gd0b6ae47932e
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 91 boots: 1 failed,
 82 passed with 7 offline, 1 conflict (v4.4.183-3-gd0b6ae47932e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 1 failed, 82 passed with 7 offline, 1=
 conflict (v4.4.183-3-gd0b6ae47932e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.183-3-gd0b6ae47932e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-3-gd0b6ae47932e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-3-gd0b6ae47932e
Git Commit: d0b6ae47932e0314c3a0dbe5378cd2c9259528c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 19 SoC families, 13 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 2 days (last pass: v4.4.182 - fir=
st fail: v4.4.182-85-g847c345985fd)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
