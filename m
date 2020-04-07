Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AE31A03EB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 03:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgDGBAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 21:00:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39894 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgDGBAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 21:00:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id k15so3225pfh.6
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 18:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QJYCl39+PdpVXPzKLhUYiGXEarEiqUzl6wwrRvmO1qg=;
        b=ypLE0XHua+54DFBo7X74MMnFHjt0QqFrnh/TBoKW+tIfXMqcYtfYfGl1hzGfnR8h64
         QtW5NP01VnsVZthSlsUGfIRNk1jm14m3I4/qT8sWYsqkVB4OnQnEzStEMueymbJ6DA6o
         a6tT8eM59wlIdkXAkWok4lZb2L4w7REWda8xMAHOZgnAGRG+JPCyFrDVRQOLOutQ7njx
         Bfhb4iUM1zuCwBYE4hojS6q46LQLeqQbJdQvJ2uP7eQSc2S23wUOt2N+xmfvC77x9ciL
         4uQmly87XLsdrPrpN50aBenTQjQXauycLfluMT5nWqmpu2gQATXDcpa8I01U2r+VJ1Q8
         JZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QJYCl39+PdpVXPzKLhUYiGXEarEiqUzl6wwrRvmO1qg=;
        b=DOtlXFb6zACA0KRoh0yXaghiozbZs/BXvzSYuiOOHk4li+iMm9//ls4npaZu6lLySp
         Ih9zRxDmOtSgD5eM8De417Yi6qcceVYogWWBDq5UdGfWWmRL9AgLi3y2uCv66uVZhPov
         bYP9GDwGYKzFNKljzui06vKLNwZtZFtc8CYjHg22m5OG4nuAy90aSwTftMSaWE/e0VQ1
         XbhfltYWWtx71A8QV7Cd2OCb5HFPGP/CoMAyxzd6L/JF204iNA47qtQvFmf+/UHDFqiS
         xMOS7T35mMzAQ11qrog+8AdtLmNJPumg/A/lbhw8qfPc4pUDnwB6bFZNTmP0e7JaR0lQ
         5Lkw==
X-Gm-Message-State: AGi0PuYS2cfoJngo9aLAkC40B6Ahuz8YGrzmA9ex59SNTqUw2jJJAbb5
        OHExdoPOMt2mEfzY2j4Cc3UFvINfdhc=
X-Google-Smtp-Source: APiQypKQ7w7dKm0b0A2UQ5zpy6nsK4Wg6i7obXApkmlHoAT48e1pnOV6clDOjgWv4Q1/v22Jup5dVA==
X-Received: by 2002:a63:3e06:: with SMTP id l6mr1735312pga.126.1586221244963;
        Mon, 06 Apr 2020 18:00:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h15sm12624035pfq.10.2020.04.06.18.00.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:00:44 -0700 (PDT)
Message-ID: <5e8bd0bc.1c69fb81.5658.a5fe@mx.google.com>
Date:   Mon, 06 Apr 2020 18:00:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.16.82
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-3.16.y
Subject: stable/linux-3.16.y boot: 45 boots: 41 failed,
 0 passed with 4 untried/unknown (v3.16.82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-3.16.y boot: 45 boots: 41 failed, 0 passed with 4 untried/unkn=
own (v3.16.82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-3.=
16.y/kernel/v3.16.82/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.16.y/k=
ernel/v3.16.82/

Tree: stable
Branch: linux-3.16.y
Git Describe: v3.16.82
Git Commit: 4f0eaca39dd14d3492f6bbdd02b9657a180e6c03
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 6 SoC families, 11 builds out of 187

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 2 failed labs

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 2 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs

---
For more info write to <info@kernelci.org>
