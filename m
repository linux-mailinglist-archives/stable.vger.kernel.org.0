Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4103119DD0D
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgDCRsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 13:48:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45435 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDCRsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 13:48:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id o26so3836066pgc.12
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 10:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8DEPl5czLnkr2xVQSF3fQ0wHqjGppMlcopjPa69nUOQ=;
        b=tkFHNCGOuSshxej7vPkso10JUN3t5fFvI/+MfBOetWMtpxNpsvRY51haYb1IAE8HFo
         qzPCyiaphQxxdhjBZurUb1HN20tp9cxfu7+vpD7gcQqWb7sYCPTGz2+fTMzyV03Nw7cB
         t+Mvv2O6ETEjbI0tUYmXm22ngMFcfMrDtPtxgkkIr9ZpsInIa8YdxQRhXwwLvuI8//tv
         gMY1jxdNoI1uelFdax/W1D5X8oPlVx7zelt3t/YvssDaC6hl7ioJfxqyPmDC15qttVDy
         Ld236nHnnm8qewrdJqyC/26HRyTEDQXCvPnpBJ5hWHFvpKcdtFlPCnTIye8aSp5Lxdno
         sU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8DEPl5czLnkr2xVQSF3fQ0wHqjGppMlcopjPa69nUOQ=;
        b=t+H2awTAz5PRLNMOM6s4PILi81fyx8MC6qMq8tRyIKJj/QCd4XWERrmuWVSQjGWmgw
         rzCN8yQytsyAyWi3b/JZvAgDjLbCNCCvK2QrjWk6+kjd1VVi/m4OD5L3Z+DKippuP5RQ
         OoxYsaB/dA7f48Z1TEEW1SxIw9n7/CFCTDy/j6hP1FeHgGzAjYqB4DDsC6RdR9qNQDVX
         RZpm9PuKat34or0/+Zk1bHYYll1Zbyh/5PLcudcpU2hmKOQVdauO1RvX42mVXuwboMPj
         TK3q+AY4beRD/xcuN08VA9AP8n3iFml/olRcZ3BmAql7m+pjlqc2hQ6JeIDoDwwy8T1i
         ExMw==
X-Gm-Message-State: AGi0PuavEa2DJ0ncUFWA7EimSRrdRduIv1KvCe/60xy8+330BK543MIV
        rgj85DWIPHKayAKpIXV4xYjTpiD3zD0=
X-Google-Smtp-Source: APiQypK2hagtpkTqq11uWMLeeYZTIpADPVnpE9qVa2uRU34eMJn8oWk8GKlks/Q2N0vfU3tb4UnJrA==
X-Received: by 2002:a62:834c:: with SMTP id h73mr9681579pfe.59.1585936085405;
        Fri, 03 Apr 2020 10:48:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm6373925pfj.108.2020.04.03.10.48.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:48:04 -0700 (PDT)
Message-ID: <5e8776d4.1c69fb81.e1293.dcdb@mx.google.com>
Date:   Fri, 03 Apr 2020 10:48:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-13-gb06cec08743b
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 146 boots: 1 failed,
 137 passed with 2 offline, 6 untried/unknown (v4.19.114-13-gb06cec08743b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 146 boots: 1 failed, 137 passed with 2 offline=
, 6 untried/unknown (v4.19.114-13-gb06cec08743b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-13-gb06cec08743b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-13-gb06cec08743b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-13-gb06cec08743b
Git Commit: b06cec08743be6234dfb7ff4f6c5a0692138e974
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 55 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 21 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.114)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114)

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
