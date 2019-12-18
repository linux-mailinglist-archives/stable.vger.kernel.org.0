Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1127124A7B
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfLRO5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:57:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34094 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfLRO5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 09:57:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so2647769wrr.1
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 06:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=avK/HKE62hktMm4idL3dIY2G4sUDTZ7wZ1dhagpfVqs=;
        b=N2Sm2w9PEt41O40DD1dMispC+2VWLhwpZk+6jNf9PM7VLVy+UrD97uJgaVd8o5Bmmu
         s94icUjf+OaxC4zsgsxWBNZ0uVzsNgaUXG6ad5qd3bJ6AGdFKyE9rR05maa3gaUZUmkP
         7lO0fpk30uL7RWdxi6TGqAWgaxlETe932OOUvxk+etQILIUXgoswpoyUC3Ej0iQQ6GXJ
         ufblxhCUQsUQC4qALIhPc6/rMymxLJHsDmYDH3uPFJdqmONzssdL/NsV7SBSi3bzEfN/
         S+RDrr8JIbyaTvyKgCh+6693Lht68L4OWG7PWXpIF7urEWM7gSAcW60F5aVJGzM+ir9B
         cRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=avK/HKE62hktMm4idL3dIY2G4sUDTZ7wZ1dhagpfVqs=;
        b=Npay/x8Fy8PJHrypH0y4LLKhXfm6Hs5UusAHX0KyN62xaHn334UVSMy9mgVZJh2mm1
         64XWgdUdyI/lLiyc4EhG126o9FKI7e8lIZeM+OFx2Axs0SedvaAezCUFqR3u06miubXO
         /5z6CHeehpPxNNpeTxjPI9/q9il14+EDbpp9DYd3tzneT3NM83UXE+lGJiYru3zGRm1D
         rOnRwSvSXbjnIRawUIcmeGkusVkOPjHOuXckXFmk+Nh/CbaG0UAtPwWwDJwCTb245q0W
         MIe39OmJBdwPOiVDiV9j7cXSy8yFy862hcCWJDl2ah8T3bbA+/sGkaO/ULYlAaihf0Hl
         BhCQ==
X-Gm-Message-State: APjAAAVR0b5VUefdb3Sghf2VgjfS0a0cp6mmOfINXD9kkvxejGgMs88f
        o7S9Da4ky7p+bSTqcW6oGJVNUW/HJRs=
X-Google-Smtp-Source: APXvYqypBqZhCTuVt39cEytVP11EjaZ1nivv4GHvOS32VzO9hTPNJDmIBX4dZ4FWVZZdc8vbXjm+Qw==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr3511948wrr.265.1576681051994;
        Wed, 18 Dec 2019 06:57:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x132sm6674255wmg.0.2019.12.18.06.57.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:57:31 -0800 (PST)
Message-ID: <5dfa3e5b.1c69fb81.9ee25.36e6@mx.google.com>
Date:   Wed, 18 Dec 2019 06:57:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16-215-g8f8658b68c66
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 106 boots: 0 failed,
 99 passed with 6 offline, 1 untried/unknown (v5.3.16-215-g8f8658b68c66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 106 boots: 0 failed, 99 passed with 6 offline, =
1 untried/unknown (v5.3.16-215-g8f8658b68c66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.16-215-g8f8658b68c66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.16-215-g8f8658b68c66/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.16-215-g8f8658b68c66
Git Commit: 8f8658b68c66a7a3269eb2aceb53b1c76b4b2833
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.3.16-216-g07=
63039c4844)

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
            stih410-b2120: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
