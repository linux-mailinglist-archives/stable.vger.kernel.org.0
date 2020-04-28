Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE31BCE88
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 23:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD1VVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726274AbgD1VVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 17:21:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5065AC03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 14:21:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n24so9007556plp.13
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 14:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=61MEvgafueLi3Q42GPqVShlqTiZnvlMXMDRh76edVJg=;
        b=ly/EerLXtyFb8o5VXbBNORUWEjdWZoZptydFWTiz9YyM/Bf2d1VNxXSh8jV+11G/mU
         WXWZ8F05gdV6MrqzbZR9dxr+XgBUjzQ6+Dh0y5jAkKdVnipPZpjFUDkUUs4J+LrmfSjS
         pApsKofN0Hp5nPyWcTu94GBaGAl0216xVKfuxRNzZy6qu+z7AtfTUM0V1mNOxEQIzbu0
         abYR13+IBDyDEKgnKs/XqyX5LOE9OofeewpgHamjdzjvUarYEczqBkPtKGS8JkbicW4v
         PdxRbpu9CW1T01MsLKuEhrjfRNr6w11YtYiuP6s2zKeAhXlwiizM4ORGuCdXSw1mYowu
         256g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=61MEvgafueLi3Q42GPqVShlqTiZnvlMXMDRh76edVJg=;
        b=WU96DDPl6hM4kQIEscQxrf7UM06NEdi2zKSJPhPLywbkeyyteyWOnBJRv8t6JP6t+2
         b0wzUxXS5z4IOykuqOCGuapZ12nCDyn+CEbBiRIdz8xJfkie4l0Ah+w697lw2mJHSpGN
         JLj+MsI0085mN2V5BpRYyXfNo1xjzGvsmST0RFJExP1XwZU0RkksYBdL0DEiUWkbG2n0
         GGmYr3uJfdPRPgJkAZ6nCaLiqieXQl3owkSS0zIaCFt/cW+XA21LHATD1ye8oWgLr9br
         vKwoflJGI/7Fi8WLtU8S03b7XivjHm/zndYysIYp3nGMLwQo3paRmw3nO7SB6vhyG3zW
         H5Wg==
X-Gm-Message-State: AGi0PuaxCEl47hSICO/0fjP2l833Hwi+0u7x8lVBALhjPPqfxRqKBUP6
        eyv/UDV+N52PO+MeAwMugZ/avYy4z0I=
X-Google-Smtp-Source: APiQypK4OQy+QGuXMOh9fxDeX58cGC3SBTtMQSzkNohdDg+2B/uYWk1FP16VaxbaIb/RDXqFSuY9Jg==
X-Received: by 2002:a17:90a:e2d0:: with SMTP id fr16mr7603929pjb.146.1588108889341;
        Tue, 28 Apr 2020 14:21:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u188sm16010951pfu.33.2020.04.28.14.21.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 14:21:28 -0700 (PDT)
Message-ID: <5ea89e58.1c69fb81.5184f.cabf@mx.google.com>
Date:   Tue, 28 Apr 2020 14:21:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220-59-g49bfc79b0bcc
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 114 boots: 1 failed,
 99 passed with 6 offline, 6 untried/unknown,
 2 conflicts (v4.9.220-59-g49bfc79b0bcc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 1 failed, 99 passed with 6 offline, =
6 untried/unknown, 2 conflicts (v4.9.220-59-g49bfc79b0bcc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220-59-g49bfc79b0bcc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220-59-g49bfc79b0bcc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220-59-g49bfc79b0bcc
Git Commit: 49bfc79b0bcc584621083a36bfb7662a2bc39378
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 18 builds out of 187

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.220-59-gc20ade302=
372)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: failing since 1 day (last pass: v4.9.220 - fir=
st fail: v4.9.220-59-gc20ade302372)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
