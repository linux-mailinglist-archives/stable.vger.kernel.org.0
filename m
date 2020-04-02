Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFD919CCC6
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 00:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgDBWXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 18:23:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34649 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBWXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 18:23:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so2473918pfj.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 15:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nLJSf8yja6lPhQFJrr9cobnALT8GD/lFXMkMdwl8X+M=;
        b=w63qSatlg5VY5r5MjYQoWX/rikfPP2M3CrjaKo2GSEujkxpD+seJ13tc+o410VYVve
         ONt/teT0SFSTT6NB8ju3RNe9ct5SPXxAJWocR4wQG8gKGfbeLYavBdsOpwDN3J4EgTPD
         vs3vT8pNaiO4pQdUCkbf/u0MTjIC2Prj3UdLapEVJ72bik7ac2XFIz9ImqLgwNl9RmUo
         suDrbVhWZ+axdhn6zlmu0MFE4wyA/p1wjD4x9PFa6K5uzcjLW0BatBj9/QgjKfnz6Tn6
         ITIxMi2Tc6hdsuLorHplc8PSkNa80xKjaeKymEzPO+yL/P7BZNU/OzAc9aojIpzNMFSR
         kLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nLJSf8yja6lPhQFJrr9cobnALT8GD/lFXMkMdwl8X+M=;
        b=CEHlHq5rQLFtr+wYOYqdBT3yDmqcLir5Hg9IGdHJ8/5p5RY3uIBiporiJsTOM43YFP
         VQCnZm8Qcull6jUGBLXFOagsERBFOFmFyWAZrogOPwjJ44LORtSc/OnzSMZInyksrCEW
         sgr+Ll56mFXHf1ayKCfUgtzCP2y2j/RF2hnLOQAWgG9E5otLKC+s7u4E0HyyrMKHDYlP
         oZ5P8v2JdIyFAzYuL7oOBh4CA4K7Um+j+hITRemEaSvOF2iggABAwn/B5x+0iu61QfjM
         SdFZglPCBe7Qm8MzDPjLVDmE+R+sw2xrnAZ/jbpzfCpJBq+kCp9aV6eFSpnBpCEke5FS
         Oh5Q==
X-Gm-Message-State: AGi0Pua34yNVZYEQfofmOztX3Gm8CYAKu2sOam4xJfYLsv68eMPbUgvT
        deifgBckcO9T1UjVgoFnhhpgv9OKupk=
X-Google-Smtp-Source: APiQypIXB3L6jQ4KkyKd/wH7/8g6yPJwmIckDRhI65P0h+d/noLtRzne0NdKehjEWckccR9tS6EAAw==
X-Received: by 2002:a63:8948:: with SMTP id v69mr5220932pgd.318.1585866229337;
        Thu, 02 Apr 2020 15:23:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g75sm4367165pje.37.2020.04.02.15.23.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 15:23:48 -0700 (PDT)
Message-ID: <5e8665f4.1c69fb81.89619.31d4@mx.google.com>
Date:   Thu, 02 Apr 2020 15:23:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 81 boots: 3 failed,
 73 passed with 5 untried/unknown (v4.14.175)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 81 boots: 3 failed, 73 passed with 5 untried/unkn=
own (v4.14.175)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.175/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.175/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.175
Git Commit: 4520f06b03ae667e442da1ab9351fd28cd7ac598
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 14 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 69 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: failing since 12 days (last pass: v4.14.173 - =
first fail: v4.14.174)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.172)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
