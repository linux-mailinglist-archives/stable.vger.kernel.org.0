Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D751DF746
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgEWMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgEWMk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 08:40:28 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00B1C061A0E
        for <stable@vger.kernel.org>; Sat, 23 May 2020 05:40:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p30so6262787pgl.11
        for <stable@vger.kernel.org>; Sat, 23 May 2020 05:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zx4Dlu7gRhX3u8qAYGi71NDSpT8Jw3gx+TPCipL4bgM=;
        b=KQZ2amMm4x+zsseHrVwImwyBWt+DQ32u5488kQ84YJ0iJfj+oUnDL8OPw80UQ5ADVL
         ohu3n4yTemz5ypkv+DXCkDluRo6BF0hPV7CKHyQjrdwe7W/ZmKLLIJY4zH3J2jO4oyTT
         k6pg5HGv4M0Du/z2WpUMxU8cQix1bHvoqgNOBi6cAzblR7BP1vxIm/RV0QXwFxd6w7C1
         cqWpPq6Lz7+rBsYiADpt7UolRKsnCgy3PMMe5L8tYNkD7s189iiRbyhrcQWpO7rveEBD
         JYQup5he2PYTsdeXATTatq9gSDVId5WFcdRnssbdhEXJaZHJ07S3M+ND8OVbQKhMiyes
         14fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zx4Dlu7gRhX3u8qAYGi71NDSpT8Jw3gx+TPCipL4bgM=;
        b=gyyczwjNi+RZeuPivgAXra5KzZ/rAqcO1YyVl08goPROtxYjnI5dzf9OPsIVJrWSWy
         ZRD3B21huxnIkthCPJnRJEatX1hXaRji76DJld+JH7Ej8B7GRidxI8I3bbn60rsPNZ5w
         T3LIJj0vIWrMDjANNTc1v4fBv2I69CWjoDP+i4g5hjMCvEKbdFef5ydue19Jqug8DBAG
         4tbtOnCOdOLL+tUFU9wrYWrnGtmhW0ZXVtViSVxKaa3xC4Ke59NUa9KfKmpwrsUdN3ZU
         is+ysDoHU82C6uh8c/amUiuSA5lVUwnsKM1FJ+c3fKZUk1F5X/uO4W9Hq05J/qNK35fG
         PgWg==
X-Gm-Message-State: AOAM530v/07uz5avNbj9YjcBWFNXDTCzX44j0QDy8esQeh0kSKvWgv9c
        5UdjJoFPRXM5m2rWtR4n4dEgcZxWfOQ=
X-Google-Smtp-Source: ABdhPJwYokdvCSBSjom7zW0IY+8l3aFIPtmkTKO8MPb0pP+IlNe+pSVXYh4HHhiq7+R9oDp7FK5DiA==
X-Received: by 2002:a62:19cf:: with SMTP id 198mr8432554pfz.247.1590237626094;
        Sat, 23 May 2020 05:40:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a27sm8311463pgn.62.2020.05.23.05.40.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 05:40:25 -0700 (PDT)
Message-ID: <5ec919b9.1c69fb81.86a88.5e85@mx.google.com>
Date:   Sat, 23 May 2020 05:40:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v3.16.84
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-3.16.y
Subject: stable/linux-3.16.y boot: 35 boots: 31 failed,
 0 passed with 4 untried/unknown (v3.16.84)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable/branch/linux-3.16.y/kernel/v3.16.84/pl=
an/baseline/

---------------------------------------------------------------------------=
----

stable/linux-3.16.y boot: 35 boots: 31 failed, 0 passed with 4 untried/unkn=
own (v3.16.84)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-3.=
16.y/kernel/v3.16.84/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.16.y/k=
ernel/v3.16.84/

Tree: stable
Branch: linux-3.16.y
Git Describe: v3.16.84
Git Commit: babf7e4a11200d94219dcebd64f50e6304bbde2e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 6 SoC families, 11 builds out of 187

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 1 failed lab

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs

    multi_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            omap4-panda: 2 failed labs
            qemu_arm-virt-gicv2: 1 failed lab
            qemu_arm-virt-gicv3: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs

    sunxi_defconfig:
        gcc-8:
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs

    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 2 failed labs

    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qemu_arm64-virt-gicv2: 1 failed lab
            qemu_arm64-virt-gicv3: 1 failed lab

---
For more info write to <info@kernelci.org>
