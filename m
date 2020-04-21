Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFC1B1A5B
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 02:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgDUAAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 20:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725550AbgDUAAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 20:00:05 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29ABC061A0E
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 17:00:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so104477pjc.4
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 17:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=836y9YUY5qmXY0uwOrD2sCwV6yxxJ2WxtNRc56BpdHY=;
        b=xR6nQtuPNeX+/h6tppxPwufbMyADmka/RjVr7fEsXovAPjQQIhZc7SIb2kLqv2pKx+
         oiohd+RuDR2CKdJKRqNVaGNwcrOIt2hS+VXwEzDB1wF4Gnhlffo/yPSkRQAGhnj2KW+4
         hzl4Y7oNI3rNYXjds+IaguM1pM1klzpu8REcPLtYVsHbPyscKB+BowW6ZVmTzv7WN9tC
         siNgdeKMtUklzIi2n7cgvu8rkFj3TaVmKsrsA61AolkHu7JPMbsV/BP8DY9FM294aONI
         8BBXXEsRCdDmGbcjlDDVX2dd3kkYHNUNZycFOwGRcAV/Mk5yCRHr6rBizb+56dCM3kKX
         FjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=836y9YUY5qmXY0uwOrD2sCwV6yxxJ2WxtNRc56BpdHY=;
        b=TVtM/tCE90jeGsHrmP50qGeVfxwndiHnjw4uEw2KEvnut+28LgS1oNQpQL0cuO3ppO
         tmHGyx2gUmyUs+JUSJ0fv1ltZBI/TADs7LgKOXbYujScu96hxt1+OXlWG5MATWongSek
         sr3Ed/KYd7DV2FZH0n8ifpCnkpQGrL6hdudjJMkWtd0OP3T0hDlIwHLaxvsbazdsMPn+
         uCcnsH+Jv5Si8n8Qqfzh23scuph3dJ3+2iWAaus3KHlaDMYJnWtu8ULAnt8EI4EftHMD
         KBgd357KXOt8E3V2McqRjFv/QCYYbd9cN8xFNGPlSCAHFAmg+81yCCMXaue3QLRhIoi8
         DxTg==
X-Gm-Message-State: AGi0PuYl1k/UNhGUrhTtXP5awrIJ2r+l5lY4YeQrFgKloOJtgteOm1Gn
        beeEPbmAsmThKnyp3Sn7mT0AkAZ+qD4=
X-Google-Smtp-Source: APiQypK7M1+B5WHUAO7V3IJys+0UymEeY/uUnUDIi7QG/0LFuO3szpIuyxokeWmjmIw0PbgwXI+KwA==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr2264323pjd.38.1587427204080;
        Mon, 20 Apr 2020 17:00:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q145sm627560pfq.105.2020.04.20.17.00.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 17:00:03 -0700 (PDT)
Message-ID: <5e9e3783.1c69fb81.11020.2679@mx.google.com>
Date:   Mon, 20 Apr 2020 17:00:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.33-61-gf969422316c7
Subject: stable-rc/linux-5.4.y boot: 144 boots: 1 failed,
 133 passed with 6 offline, 4 untried/unknown (v5.4.33-61-gf969422316c7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 144 boots: 1 failed, 133 passed with 6 offline,=
 4 untried/unknown (v5.4.33-61-gf969422316c7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.33-61-gf969422316c7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.33-61-gf969422316c7/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.33-61-gf969422316c7
Git Commit: f969422316c773400cbec8d7fe672db7d4bb97af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 97 unique boards, 25 SoC families, 22 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.33-48-g8661e77d45a=
e)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.4.3=
0-81-gf163418797b9 - first fail: v5.4.31-258-gd88fa8738f21)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.4.3=
0-81-gf163418797b9 - first fail: v5.4.31-258-gd88fa8738f21)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 72 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 12 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.33-48-g866=
1e77d45ae)

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
