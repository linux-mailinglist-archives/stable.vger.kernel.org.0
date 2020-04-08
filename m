Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA5C1A1B21
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 06:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDHEyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 00:54:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40617 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDHEyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 00:54:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id c20so1857171pfi.7
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 21:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pLk3xqNu5jRO0d0PBe2daDQP47tX8DDNtObDFjlRE2M=;
        b=at5EvXasOYYcmpidGE+z/qR3ePVw4l5vd9Wfi8oNLVJM7qExEt3CUAdm1TNMYxa2ZU
         mMXCgg6+gRBC0rqQ4TGiLVpUEs516xkBD8qcGBkzHjHUVESLU/2ThmeqdX2uCAQVlnSS
         jCXPvnKt+orDZc2GiLH/0+rhHnDiVGlDFZX+YDtr6+T2ptApbqv5LyqOm4MFFdcFk6E4
         4Rus5/y8M5OO77ttj7vjee6ozZkwRTw71hrgAr6DGAiglIxuKpCM2DQrkb/77L4COon1
         gpQzLBLqx6X3z658HWE8WXUO9jphUhaC8b0PV2N/Y5L53+Y0zE1U/A+Ks/Ceo/jz8l8x
         SYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pLk3xqNu5jRO0d0PBe2daDQP47tX8DDNtObDFjlRE2M=;
        b=Aa8UJaiOA3I3SDvIkoz3G6dT3Cebv4MIvYgIWL386FTxeSQzLf6PHsRwp8EIQyxUZx
         XPscjYmjHaPWtCD1pzfR+br4cLak1oEvmt+hCdudXZti+P+Mpe3cJ/muAKEACFZ1+t4n
         NyrBhhhu/Xs2MjJQS8+TFX5kBJ5ir61MjShYQJROzC4gbzBG96P3zTCdFV3RB9/iuBgr
         j8nG7EkkycoN9RTWoo2sbjATS00YJ3mVxYty5HDUZa7fZZ5O2OuFi2R9o6n3O/2f8mh9
         iEm1oXC08Lg/tZzddBp9K0drM9PyDV7G/1nq2sAbxlY6hFU8H2bJgxVc3heZ4KXdG6D9
         C41Q==
X-Gm-Message-State: AGi0PuZ+EfW5wyywRsVhPVc6Us2AJMQBTB2AcC8TyJy20HxWFfynILUo
        kD0KvnbFTkTbDmjk8BSwxpWaVwAMB0E=
X-Google-Smtp-Source: APiQypKjAGYgZxS11cqnpf6dWkSNdgWzhP/QmtiLju6dvj2GmpNBD4wMAW8MusHJ//cLgyRqOJgnUQ==
X-Received: by 2002:a63:6d87:: with SMTP id i129mr5377152pgc.54.1586321693779;
        Tue, 07 Apr 2020 21:54:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m28sm14514056pgn.7.2020.04.07.21.54.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 21:54:52 -0700 (PDT)
Message-ID: <5e8d591c.1c69fb81.889cc.29a6@mx.google.com>
Date:   Tue, 07 Apr 2020 21:54:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2-31-gf106acd0db7c
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 164 boots: 6 failed,
 149 passed with 3 offline, 6 untried/unknown (v5.6.2-31-gf106acd0db7c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 164 boots: 6 failed, 149 passed with 3 offline,=
 6 untried/unknown (v5.6.2-31-gf106acd0db7c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.2-31-gf106acd0db7c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.2-31-gf106acd0db7c/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.2-31-gf106acd0db7c
Git Commit: f106acd0db7c11e0208a2ecbeb0f7c52fc6c455a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v5.6.2-30-g14d42f1aa3c3)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.2-30-g14d42f1aa3c=
3)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-30-g14d4=
2f1aa3c3)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.2-30-g14d42f1aa3c3)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab
            stih410-b2120: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab
            exynos5800-peach-pi: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
