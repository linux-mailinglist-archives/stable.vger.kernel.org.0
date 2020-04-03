Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93119D6B0
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgDCM3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:29:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46947 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCM3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:29:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id s23so2622172plq.13
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hxWzc5hoYKAMjeb0Upg5qTrBahthYwCGiUDgCL6YJRo=;
        b=q34dSqI9anO7zmP2QrxSU20p6Qdl9GU36Eg7ySKhF/K9E/6nbh5cEacBi2PWIiWdlm
         JpneyDo1DoP4LOKGk4u1vLGg94G4RkQbWyd3kcq+tmQNTbmYKpo+x8d8dSSmo82zdaM1
         1Wqogf1Eu778XCoEuD1sf2R5HxTRJ9fr3ZRmQl12Nd9+iBigWuquzUQxOgiIkNuv1AjX
         JKWODczfCNPiXOnOHWLf0Rb77pK7KGylKOgiDgsrslq6JDE/gvc1vP5nnPYq55A9crOG
         bZBOHTsHzyew8+Dk/K4r32o/RlTlwtI9vB336O4p01jJ8SaJSTpGcMXBM2WTNDsRmHPm
         Pzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hxWzc5hoYKAMjeb0Upg5qTrBahthYwCGiUDgCL6YJRo=;
        b=cwk+Ksd0dQa2wQc5fBcJUtTHR+JZKfgQJtkVyarel7ZbyjQSAj2H4D8x8mx413inGx
         e6eM/EGyUGrpcGqROkC6uVMUSMjHZ0cbjX08qTQ6UKXarkWtA6fSqpih6dX/cz8Rpc93
         h5gnZjuAulSgwkSA90hbDHpGw2lEYBM5TPzBfgJ664/KSGBeHymMGHKzVkQiHfX3tFwb
         ygcSms+59+Ynj3ER4BsIQc6UoXLS7Zj1rcJxGelpN5VO9WnXxuKo2S2E3dkjgzrbkGkN
         eTHTF8auD6BSIt/90CtRogsUYBWa3hOQS81pml/kSFMAI14HCaL0OcFeILItqyASryIc
         psdA==
X-Gm-Message-State: AGi0PuaEYWoZNbIVeARL2vQmOICq6sswzmPFjQsla89m4WzbdnbuAlwG
        vSEQvLaLm2Lb/NnuC2T69nQmctA57tQ=
X-Google-Smtp-Source: APiQypJOdz0n2ZzIhXJUX8qzQkQjiJKhZ6hc553qNvQDXUMFdvuhGeaSsE7i38Qsz28RlfQ1/1OuBA==
X-Received: by 2002:a17:902:aa48:: with SMTP id c8mr7447650plr.95.1585916943876;
        Fri, 03 Apr 2020 05:29:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm5778279pju.33.2020.04.03.05.29.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:29:02 -0700 (PDT)
Message-ID: <5e872c0e.1c69fb81.f568.a98b@mx.google.com>
Date:   Fri, 03 Apr 2020 05:29:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 146 boots: 1 failed,
 138 passed with 2 offline, 5 untried/unknown (v4.19.114)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 146 boots: 1 failed, 138 passed with 2 offline=
, 5 untried/unknown (v4.19.114)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114
Git Commit: dda0e2920330128e0dbdeb11c8f25031aa40b11c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 21 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
