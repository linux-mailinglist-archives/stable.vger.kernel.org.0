Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1553217BFB0
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCFN46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:56:58 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34690 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgCFN46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 08:56:58 -0500
Received: by mail-pj1-f68.google.com with SMTP id gc16so1714332pjb.1
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 05:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PIRaNdKnQxWl/RuOd/ovuxka2a2okngtvBfGptir/PY=;
        b=azBEjphCiibX/ZkuCGmMCgVvr12Oq9pReOYeFc6GzqHFeSNgMKvUcNmUllJo66ldfH
         P0vdTZQ14p9gcctEjTaEtar1iJ+tzrbD0dlXRamjDV2pSip5Si9LMdPl42SvZBnZzsB7
         t96ZMgBJylLi/WHHEjGmAw+aI+KuX0fqZ3ZYdDwX5LdlM4OVV0EFInna34jPwVLxTLi9
         cMj1C9qRTy3XhkaFFW5U7EjNA6SdGU+EbB5IfAhGp4uVwSAg4aH/byxHF8+0J92hLefQ
         vfUtZY/doBNkwewpN53Ajqs5CKsskzCuo94yjv0yQCl4VRnI7G0vNb4DmRygHsZAKF3R
         MkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PIRaNdKnQxWl/RuOd/ovuxka2a2okngtvBfGptir/PY=;
        b=fa2kYSxHX9CmKScB6W/PPu3uSfRumsimmYeRAbTbuvEB8ZbbYJCdYl7KQ8JrH84Tqs
         6mXG67CXWxCJVVNdlePd7d7YtlPQKQH+SZhBAlW95win+mDY4sJUjTdHskfe0unWWXrL
         /izcvN9tFQ/9aHj4AMrclJvTNbUvtJ9lPYcnhCCJjRKhwzFoEhlfsYciEBmPCGBmWrGq
         bJEdV7Mt4TsZDU1bWXkQ5ppr1ND8U1FD79w3wutJHjr00eVmQ800A2hZuX0XnPApEvqq
         +Wyo0ljnB+Ph66xFHoT49gmcgn/KGtoNuAX/8HLsL/dWTw7tMYzhrNqq4tbGe9GrUPFO
         l5ZA==
X-Gm-Message-State: ANhLgQ0GSx0vi5J97l3OQBQQo1MJzgP/S+xxMV8p0xBO0H+KSgysUFUo
        VVrbA22nOgBkKKn2P11lURAturKgEZ4=
X-Google-Smtp-Source: ADFU+vvCr/gJS8Md257YsFpR2RhMFLT4sBLPLFKSPguTCNAlfEG8LBBNAodHVzGHxLHjo78QQxWvYg==
X-Received: by 2002:a17:90b:3609:: with SMTP id ml9mr3810108pjb.146.1583503014912;
        Fri, 06 Mar 2020 05:56:54 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm35496944pfi.83.2020.03.06.05.56.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:56:54 -0800 (PST)
Message-ID: <5e6256a6.1c69fb81.ac129.f528@mx.google.com>
Date:   Fri, 06 Mar 2020 05:56:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.24
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y boot: 120 boots: 3 failed,
 112 passed with 3 offline, 2 untried/unknown (v5.4.24)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 120 boots: 3 failed, 112 passed with 3 offline,=
 2 untried/unknown (v5.4.24)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24
Git Commit: cff670b3eb68257029e2977a6bfeac7d9b829e9a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 25 SoC families, 19 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.22)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 26 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v5.4.23-153-g12=
54e88b4fc1)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.23-153-g12=
54e88b4fc1)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
