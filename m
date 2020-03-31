Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397E0199859
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgCaOXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 10:23:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37482 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbgCaOXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 10:23:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id i34so283215pgl.4
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 07:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KSV6hf4GearCQ39Ml/AdoBYE56Y7ae60VPiWTGU8+BU=;
        b=GkujWkaM5k6xMiUflAbLdd6JBfp3mDbNkjtg6++WInKtz09+Zcetucjkkk/DwUYKXx
         JO01efQgvUp+VinC6qObZdMYEHT38TX9SW82imuvKwZToO6Og8BOvffMFu42jz4HEqeg
         DU1o5ql/Jd8u9BUxL0VOZ8J9nZFcoA4nQesWplfppFypLEBhdvEMnuzcAlHSrQ9AhqWT
         wUchX3uuhlDmWQ54VOZFMq+0gs6/ccA0GfGnAIxVmb89eGDppSXr2lbdIaMdwNWeJHAf
         RV2MqxxSvQ1XtZksqEamrFb4dwIhQDdaAeKC5BDVOaSMUKnYxCIELhngzXX7lU7BjcUd
         CQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KSV6hf4GearCQ39Ml/AdoBYE56Y7ae60VPiWTGU8+BU=;
        b=ChelAa/tPiiFNqh2v8RA5rxKKRUUVe/PrvoQTksXskuOZXGiDrYz0pPhls9SgWaTGe
         0x/WjLjYqkv862Amrv7w3DnSY7wnhoWdw3CEkkAraiC6tN7PrW/UqXRcc31kJKw6+yVp
         0m+p8wNzofYjEtdIp3kf5ZsKXoxW7Lglyr7dVVPGFKnlZNwGhiuLGadw8zcsutuBmzVc
         ydQb8XDvPe/wKwhuLtaK0Y6DH8hkykXWnwiqFCLhkUQshGDrv2hG3tgVfNzFS7mWo7PU
         VhdXphCUvEPs6qacEdxE/907HJ2tjw23jP5R6XmzANUMX3fuxly81UGcYkDc24GQ3O1G
         HK+w==
X-Gm-Message-State: ANhLgQ2DC4t9OcjBA/z7y3CHX31yJA17qWWYxNbap+Ad+0LjYmFhhOcD
        NeZ+abU2By1YZ8hI1ED0Tcf1bCnLsyg=
X-Google-Smtp-Source: ADFU+vtqRkV2/SmEVj1d9Wa7V6w9uMrPKC86kYWYPYI9q6bxKaZXOFcxEcSDUZJ6QyYNgXCGsos49Q==
X-Received: by 2002:aa7:9467:: with SMTP id t7mr18421838pfq.97.1585664598550;
        Tue, 31 Mar 2020 07:23:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm2088698pjs.17.2020.03.31.07.23.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 07:23:17 -0700 (PDT)
Message-ID: <5e835255.1c69fb81.4a9c4.8d40@mx.google.com>
Date:   Tue, 31 Mar 2020 07:23:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217-82-gb193eaf1881d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 90 boots: 3 failed,
 83 passed with 2 offline, 2 untried/unknown (v4.4.217-82-gb193eaf1881d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 3 failed, 83 passed with 2 offline, 2=
 untried/unknown (v4.4.217-82-gb193eaf1881d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.217-82-gb193eaf1881d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217-82-gb193eaf1881d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217-82-gb193eaf1881d
Git Commit: b193eaf1881d9417b2663976c1bd7eb6e856251a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 52 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 5 days (last pass: v4.4.216-127-g=
955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
