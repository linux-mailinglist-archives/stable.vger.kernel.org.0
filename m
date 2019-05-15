Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE731F9CF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfEOSR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:17:58 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36988 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfEOSR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:17:58 -0400
Received: by mail-wm1-f46.google.com with SMTP id 7so974239wmo.2
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=28QOsUrkOtQ3+F3AZF6tvz0XZ0x3E0XcKQguFdoMZBs=;
        b=uGqMThuYgKtih8xCeUwRzWX9M+ZVXnaGZsNs5kAUKpp+/8S1fvmwqv/WvDKay9sdDH
         NWV7M1G3Mn1HAsiEC+FJSTY2Cg6sRuDKI6aoVKMjMMjlP+xH+su43HWmNMRBwvfvoeNT
         BEXTGhOLxzNwCpRUxZvtwPXtkemCQIcWuOr8dPI0Pdr3MjNNaI2FP5rF3nmJja96tB6P
         vTi41cfwjmocbJfW0cYVRU/loP4E7VzGGOfvb/tnBIHnsHnX/zAeCQux11LcofVt1kWS
         4blSWfAtoPpBGD3pLz4C8Oq/efwxNRDsbVVBGyVH5NrrOujLaqY/ZHbFFhUsI2yzM+3O
         knjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=28QOsUrkOtQ3+F3AZF6tvz0XZ0x3E0XcKQguFdoMZBs=;
        b=ff8Xo0pz3YRCEa5zkZfPg4iGfuUi+L84F1gzVI72uixvxTMd8u4Qdsr63jnScLYdap
         AwM3wFkAaKQtcBI4PF/9Gfklvrc+PNpkgw3kRxw211HMka/FKoPwMb0LaMMT78fw3SGX
         XfU95PCL5Bl3w6EXkLkBk3x338iXKeSnb+5/PErIuxRlZ0io67xpcmM2z1WDxXQ4rvZx
         O31CFCDzku5cKZC4GjYGhSMbKrvGOOS5oIrWejm4xE0KuG5LewzOPfyuRQZENjCBtY5V
         08pPJ5/gSHVM48vViy9HwiQOA+maRoozBOufPeBEwJCFLY+p6d8NVH7bfapQ4TJfXPlU
         hbLQ==
X-Gm-Message-State: APjAAAVgnXcSiV24/KygB6+g8BtH5on/Y72Cs1Non+1bosUiVpZ5VgRg
        S+JFjXQJWU0T2OFtJ5pJkN2xShYNoZp5Rg==
X-Google-Smtp-Source: APXvYqyro/iT5GlK/XGZTJ/IvyXti7Yx/BZpScAI00+FnAX+1ELtGlEVNssNcB5ScrLjYBvaeUyFAA==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr14995733wml.77.1557944276033;
        Wed, 15 May 2019 11:17:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s3sm3953642wre.97.2019.05.15.11.17.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 11:17:55 -0700 (PDT)
Message-ID: <5cdc57d3.1c69fb81.d387.73ba@mx.google.com>
Date:   Wed, 15 May 2019 11:17:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.176-52-g2647f24152a7
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 106 passed with 3 offline, 1 untried/unknown,
 2 conflicts (v4.9.176-52-g2647f24152a7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 106 passed with 3 offline,=
 1 untried/unknown, 2 conflicts (v4.9.176-52-g2647f24152a7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.176-52-g2647f24152a7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.176-52-g2647f24152a7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.176-52-g2647f24152a7
Git Commit: 2647f24152a78a686e9e2c8382f5b292cc31b99a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.176-35-g6194f35e77=
9b)

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
