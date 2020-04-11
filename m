Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B6A1A5385
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgDKT2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 15:28:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36707 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDKT2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 15:28:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id c23so2549753pgj.3
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 12:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ojT8jVlwMwWrQT3NgbODGLp5ZO8pTVXAUQv3hhXa18I=;
        b=MISIpVs9NnGOGsaYwEIY7aOE2mDNiCKPtBEwm+/DRA4aTpjIwDF1JQAyRhs99Jx6EC
         Pswbiy6DJ2CWPg/rBu6ezRy0YyijlPYHp87ypjS/ktGmRlqlfmSCFd43RKB59ydYjNeI
         d3qt7l49Cyk9KZRlEznAZWuTt68H/mCvpbfELS9NL4Gec5+RPXCkdRQYOtJ6GscQE1gl
         iv2wnTU0lTx6/2lVLvkKK+Yg955Kcuw5fILvTpIiAmqyLg+AVD//UZOYPEmwCAK+huuE
         ZTE3YpPNW/BgAoiFZmokZnDVtAY04/Co0fUdjuttys2fOqVEs3Nz2FKZE6xOoOJbacGu
         b+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ojT8jVlwMwWrQT3NgbODGLp5ZO8pTVXAUQv3hhXa18I=;
        b=SrL57zgV0B8+9PDmgC3BFl/y2UnMSQO2RSAsvTNkfrRrRdH27qElBoqzKyjd1AFtDM
         BCVU0r2ZvAjz9kr888wjLwoojQrwoBhVvupp/qwEiBofAzBcydB8mUvpGNdtMyVkzWPP
         awEz0fMFNDikdgYw/pSOTA2pETUIgwTrH7n04xxIcn698kUCTrlj6IAeyIvGBSUEaRKr
         WTETqlw8dzXGfrTx39OExewrCGbLbK/ztiF2WXrPtynFwtP4h6sALLnsaZC26QFbTRVl
         RfhjiacLYWSGMaPkKT+tTa5pdR2SMJXZXjL0UdxXOEu2LIX8zg42nSFxOe3DWKCMoxuj
         BBEQ==
X-Gm-Message-State: AGi0PuZ0pEi7JrEU3uxbvrhYGiGdjNwEfzoHy36nBpSSmxPNu8lT0XEp
        Vm9qWw1qEtisROVkkHoZ7NxUN6/6q54=
X-Google-Smtp-Source: APiQypLIqbe4dLpOU44B2TH/Pc28lbGTc/leNiLQ24W/t9buaEzU0tMjHUZ0jtWyRlf9oRgzmC2TMQ==
X-Received: by 2002:a63:705d:: with SMTP id a29mr4829570pgn.414.1586633312826;
        Sat, 11 Apr 2020 12:28:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g25sm4713751pfh.55.2020.04.11.12.28.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 12:28:32 -0700 (PDT)
Message-ID: <5e921a60.1c69fb81.530e4.005f@mx.google.com>
Date:   Sat, 11 Apr 2020 12:28:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-55-g3b903e5affcf
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 140 boots: 1 failed,
 131 passed with 2 offline, 6 untried/unknown (v4.19.114-55-g3b903e5affcf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 140 boots: 1 failed, 131 passed with 2 offline=
, 6 untried/unknown (v4.19.114-55-g3b903e5affcf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-55-g3b903e5affcf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-55-g3b903e5affcf/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-55-g3b903e5affcf
Git Commit: 3b903e5affcf69ffcfc0ebb8c3f2c016b646682d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 21 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 63 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 29 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-35-g7ec457f5=
7a75)

arm64:

    defconfig:
        gcc-8:
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.19.114-35-g7ec457f57=
a75)

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
