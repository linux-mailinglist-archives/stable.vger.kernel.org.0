Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CE7BD65F
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 04:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411381AbfIYC2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 22:28:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51295 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411378AbfIYC2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 22:28:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so2729447wme.1
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 19:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=13fE/9vjajftZbVtVfwa4d48ivo0akDICLK4m4E41b4=;
        b=KbSLeDp8zydZjkTb6/GuqtQ0F2Kuu6N2Ewk+Bgf4L8SdNh9DylXhGwyf0olWMXmzqC
         BgRxrO3PO/k+pHK7wmLPiD6mJ4x7X6cciKl1tC/kF9zY6vMhlro/Ks35d2cIORu9wN5j
         bhErs1CX786GG7o+edWsKJ3jfnA7C+BaTLttTDGog/JoF+o+ebvzXabrERocHIauGfuS
         U6QF6ksdDSBALHhAxmxUKt6jOhJkJFxHiDwF/f+2z0MPRkQrUo6FlmEBxjrY/vaG6LJz
         kZ2pEL1FA3jZLmxkdQD/TI0JXL6SmJMNh7TRWhmILJWEYyBwzf7h+hdMYDOfAIwD7EmY
         QUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=13fE/9vjajftZbVtVfwa4d48ivo0akDICLK4m4E41b4=;
        b=Umc5rtCk4jP1zcHuUW7KxiYz5lQ7vbYEBj7rPY2lRv1vKfCs08I5DsZmYyJFCwSWRC
         5ON6Ejq1sVsdq73mGpulHrkvT7sAOF7e+4CTU47zZV1+mbezNTUbC6fDMM5F+C+OyU2Z
         L862BW502ecC45G2Dz2QYR9QhylZw2zQS3tWfO6JWh0rd1PcHTQCksiG55CJGzu1dtVI
         nCEee0uibeNeuyGr28vSQ3FSSqygStRxlGPTJbqEwgVQSCVJmW55Js+K8hQUrRjjV9rz
         4To58rBzWIj3fxOHV0J+yac5l8vluesiu/VcFLNEuh33YX1YkysiZfVn3fEwES7MXTd+
         UvlA==
X-Gm-Message-State: APjAAAV3HmHgnj4OFxTcuWvDgiiutV/PSKp5Da5s5v12vgz2XLG0AhU8
        r/dvRZ3/Hltt/xF7rjleUHGPMj8t8Lt7WQ==
X-Google-Smtp-Source: APXvYqxb+K+7eK1dYZDK9gkowvpMKvX+GmdDPY2RSa94ljmvdBw4D//LZm4bLedF8g5ywz+RHm3iNA==
X-Received: by 2002:a1c:a616:: with SMTP id p22mr4171773wme.3.1569378525274;
        Tue, 24 Sep 2019 19:28:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q19sm5764556wra.89.2019.09.24.19.28.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 19:28:44 -0700 (PDT)
Message-ID: <5d8ad0dc.1c69fb81.3c95d.cabb@mx.google.com>
Date:   Tue, 24 Sep 2019 19:28:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.146-14-g070435ea791f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 126 boots: 0 failed,
 116 passed with 9 offline, 1 conflict (v4.14.146-14-g070435ea791f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 0 failed, 116 passed with 9 offline=
, 1 conflict (v4.14.146-14-g070435ea791f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146-14-g070435ea791f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146-14-g070435ea791f/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146-14-g070435ea791f
Git Commit: 070435ea791ffa96b7198d29d8d6733af5a6e173
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 22 SoC families, 14 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
