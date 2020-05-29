Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E851E729E
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 04:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405461AbgE2Cbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 22:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405447AbgE2Cbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 22:31:47 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461A5C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:31:47 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so411443plo.7
        for <stable@vger.kernel.org>; Thu, 28 May 2020 19:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mmn8YIBDZMxuJFpUbDlFcQkobl+SPqpD/A77VT4kUOM=;
        b=xbtzn8CkkOnzMsbJ1c5JlmtfvWoDPqeGPJsEKD9lv6/kCpw61q98eiI2YWImZ9Icog
         6wswa9LidL041zWTs8trZ7Z0xDZ9LoMRUfcDv+BNUCOf+6yjilgz0Hrmt8f4OGhfIUul
         XOCYzD1RFycwIjDi/QXWcEIVQpdUGTZ0kgXX/pL/zNuAtGQ5yzQgWVhYqrAbYi04U0z0
         evMQOblmlE5pK9B4SCQ3yM97YvoMcoL/CZcKfGj8arUypN8YsGORxwYwcEWmPUo3A2DO
         ArwT1i0TQej1bE3sAR2KEY3uAfevhLqw8vC254U2AUNBRGhqJb/0EJF22E8Giv4UtYRS
         8oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mmn8YIBDZMxuJFpUbDlFcQkobl+SPqpD/A77VT4kUOM=;
        b=VaxXEEzNzJOH3WsLEUPFX31BXY1ONqn3NkVbe0Io4Td/TNC+J4RvYaGGY7mctt/Loy
         GoXIUtPZ89Dw9mAQXLTwxzpuOpD7TEZTkv1I0L8lzuAy9pRMyrB9g8A4wSRbJJcPWQ5a
         1L5Ja7lUUAXy9I/fDKgB46JMkpkf4SlSR0sgtPxZj3r3d8nzfjm2oleZ9uovvGVHW8tC
         pHTuZXUZiC7mUY6qH0ex5WLv4L9fd2omUj7OwMLknjT3+tu0Phc80u4Bh/6DXOoqU2Mv
         V8AdjOt+OO3ZJRB3aUwylSSFSCJBcBXD5MaHU59hzVwy5HQmSFWeZDM7EeesGRDcP4wL
         jxoA==
X-Gm-Message-State: AOAM530zqiIpVYcTRpW5joWpug2WYQV9p6YmvrHR3tIL0b+XIZZ+oaW8
        HiBvwlmDRzvZNPAHfmpJZkj572G3sDc=
X-Google-Smtp-Source: ABdhPJxYdAYmvzQ15PrZyd+eZ48ahWd0vyBD4+QDszyheB3BE6VF8rNdsXLIs149edfsvuiLkxjUbw==
X-Received: by 2002:a17:90a:5ae6:: with SMTP id n93mr7379017pji.159.1590719506474;
        Thu, 28 May 2020 19:31:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5sm5660684pjn.56.2020.05.28.19.31.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 19:31:45 -0700 (PDT)
Message-ID: <5ed07411.1c69fb81.24428.f062@mx.google.com>
Date:   Thu, 28 May 2020 19:31:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.182
Subject: stable-rc/linux-4.14.y boot: 106 boots: 2 failed,
 91 passed with 8 offline, 5 untried/unknown (v4.14.182)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
2/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 106 boots: 2 failed, 91 passed with 8 offline,=
 5 untried/unknown (v4.14.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.182/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.182/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.182
Git Commit: 4f68020fef1c6cf1b680ffb6481ac41379283ea3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 20 SoC families, 13 builds out of 160

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.181-59-g2=
c9e54b6ad6a)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.181-59-g2=
c9e54b6ad6a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 15 days (last pass: v4.14=
.180 - first fail: v4.14.180-37-gad4fc99d1989)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxm-nexbox-a1: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
