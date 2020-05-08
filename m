Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CE1CB8E4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 22:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEHUWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 16:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgEHUWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 16:22:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4199CC061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 13:22:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s18so1351516pgl.12
        for <stable@vger.kernel.org>; Fri, 08 May 2020 13:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LkI93uA/wbaVlPusA3frR6XzAdWo5aZ9SC6wTdne34c=;
        b=vq6ruuWEobIBkkiq1RxI1ejdx4rhbPOelFC8zNRFi92906KQ9V0GKdE4sqJE3OP6lb
         0O9PpUuxPDGnZqr8bAk7JxvehyMcJVeoj7OnXMfYhk1iYoFykLo4XoqpmARXuoyCiEq7
         PhnWAZM0bmzOgVDPV5CyROzaSfesKTpHNiXjOCJH5x3ONuIOHsdvaK9xAecb3QEHSLnC
         H4BpCwCcFqea63sUVw+ibotlAP4wTD2fS05MR6b9jghfd6uTxGNU1BijehWbQQOHWKRn
         Xo4TbqqXNFO+7IUxmiREFTp1ERtV28HZTpNC7jNjisMWRuMCcbnOPFMfhrfOxGiSLcD7
         4Q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LkI93uA/wbaVlPusA3frR6XzAdWo5aZ9SC6wTdne34c=;
        b=iy/DRwg/Nq4sDpoRibjz0kaaOPaYfk/3tfMrpDEo+JYKADsM5Q6yJHojDGue0+d/Bj
         Qg89C7wjOzf0Q3SG6KG2hd+bdXuZU1XxHp9MQK83KK0cA14Ymunal964zekO1Jq4DWAX
         +Lg8WW9miLz8OEfA0VmCx+CltGDFqI2ywULS7xp9Hm8PAOSDadtm1atvO9nfMUR1YH56
         gYvaNNQ+NMjRfpjQTkSNGwXJRZ8/TLIccQWr8UXMI0q37N35LKyCvPdxr/mA2abTuP6S
         Xwktw6TcNxebhMHin/3sx7vs0be1hKqoXkvyvtbzxP5lSM+CTYmaHqwhRGPEflJMRrxs
         JeIw==
X-Gm-Message-State: AGi0PuYWuaJVeS+JWP8mhdHu1KX1shbU1o1XVu/YFle/ZeCWDPCdePZO
        8NXM6PGba0Nb04UP26Dq/GKV5ABQopY=
X-Google-Smtp-Source: APiQypIjlIc1wyExanjo/0F+v6dh7ZLzCafzUUo+pabB2o0hK5PJuVd+ZYI+il3rPHslRncG3RkIow==
X-Received: by 2002:aa7:8091:: with SMTP id v17mr4778906pff.93.1588969363311;
        Fri, 08 May 2020 13:22:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm3074837pjs.35.2020.05.08.13.22.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 13:22:42 -0700 (PDT)
Message-ID: <5eb5bf92.1c69fb81.8661.b836@mx.google.com>
Date:   Fri, 08 May 2020 13:22:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.11-50-g27749cf494a8
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 124 boots: 0 failed,
 115 passed with 6 offline, 3 untried/unknown (v5.6.11-50-g27749cf494a8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 124 boots: 0 failed, 115 passed with 6 offline,=
 3 untried/unknown (v5.6.11-50-g27749cf494a8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.11-50-g27749cf494a8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.11-50-g27749cf494a8/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.11-50-g27749cf494a8
Git Commit: 27749cf494a88f40047cf4c13a13536a41b454ed
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 23 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.11)

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.6.11)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
